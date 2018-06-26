From: Mike Christie <mchristi@redhat.com>
Date: Tue, 26 Jun 2018 17:09:27 +0000
Subject: Re: [PATCH 00/20] SCSI target patches for kernel v4.19
Message-Id: <5B327347.8040904@redhat.com>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="------------040201030003040502070707"
List-Id: <target-devel.vger.kernel.org>
References: <20180622215307.8758-1-bart.vanassche@wdc.com>
In-Reply-To: <20180622215307.8758-1-bart.vanassche@wdc.com>
To: target-devel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040201030003040502070707
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

On 06/22/2018 04:52 PM, Bart Van Assche wrote:
> Hello,
> 
> This is a series with bug fixes and code simplifications mainly for the SCSI
> target core. The following tests have been run against this patch series for
> both the iSCSI and SRPT target drivers:
> - Run the libiscsi conformance tests.
> - For the SRP target driver, run the srp-test software.
> 
> Please consider this patch series for kernel v4.19.
> 
> Thanks,
> 
> Bart.
> 
> Bart Van Assche (20):
>   target: Use config_item_name() instead of open-coding it
>   target: Avoid that EXTENDED COPY commands trigger lock inversion
>   target: Move a list_del_init() statement
>   target: Rename transport_init_session() into transport_alloc_session()
>   target: Introduce transport_init_session()
>   target: Make the session shutdown code also wait for commands that are
>     being aborted
>   target: Document when CMD_T_STOP and CMD_T_COMPLETE are set
>   target: Simplify core_tmr_handle_tas_abort()
>   target: Fold core_tmr_handle_tas_abort() into
>     transport_cmd_finish_abort()
>   target: Simplify transport_generic_free_cmd() (1/2)
>   target: Simplify transport_generic_free_cmd() (2/2)
>   target: Simplify the code for waiting for command completion
>   target/iscsi: Reduce number of __iscsit_free_cmd() callers
>   target/iscsi: Make iscsit_ta_authentication() respect the output
>     buffer size
>   target: Remove second argument from fabric_make_tpg()
>   target/tcm_loop: Avoid that static checkers warn about dead code
>   target: Do not duplicate the code that marks that a command has sense
>     data
>   target: Send unit attention condition even if the sense buffer is too
>     small
>   target: Fix handling of removed LUNs
>   target: Remove se_dev_entry.ua_count
> 

Looks ok to me.

Reviewed-by: Mike Christie <mchristi@redhat.com>

Martin, there was going to be one conflict between my patches and Bart's
set. I was not sure how you wanted to handle it because I was not sure
which would be merged first.

The problem was that Bart's patch in this set:

[PATCH 02/20] target: Avoid that EXTENDED COPY commands trigger lock
inversion

modified target_find_device and I was removing the last user of it in my
set you just merged.

I attached a updated version of Bart's:

[PATCH 02/20] target: Avoid that EXTENDED COPY commands trigger lock
inversion

that just removes target_find_device instead of fixing it up, so Bart
does not have to resend/rework any of his patches.

--------------040201030003040502070707
Content-Type: text/x-patch;
 name="0001-target-Avoid-that-EXTENDED-COPY-commands-trigger-lock.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-target-Avoid-that-EXTENDED-COPY-commands-trigger-lock.p";
 filename*1="atch"

From 13173cb9edcad9d5030de01eb097f8c9d88fb5d8 Mon Sep 17 00:00:00 2001
From: Bart Van Assche <bart.vanassche@wdc.com>
Date: Tue, 26 Jun 2018 12:01:19 -0500
Subject: [PATCH] target: Avoid that EXTENDED COPY commands trigger lock
 inversion

The approach for adding a device to the devices_idr data structure
and for removing it is as follows:
* &dev->dev_group.cg_item is initialized before a device is added
  to devices_idr.
* If the reference count of a device drops to zero then
  target_free_device() removes the device from devices_idr.
* All devices_idr manipulations are protected by device_mutex.

This means that increasing the reference count of a device is
sufficient to prevent removal from devices_idr and also that it is
safe access dev_group.cg_item for any device that is referenced by
devices_idr. Use this to modify target_find_device() and
target_for_each_device() such that these functions no longer
introduce a dependency between device_mutex and the configfs root
inode mutex.

Note: it is safe to pass a NULL pointer to config_item_put() and
also to config_item_get_unless_zero().

This patch prevents that lockdep reports the following complaint:

======================================================
WARNING: possible circular locking dependency detected
4.12.0-rc1-dbg+ #1 Not tainted
------------------------------------------------------
rmdir/12053 is trying to acquire lock:
 (device_mutex#2){+.+.+.}, at: [<ffffffffa010afce>]
target_free_device+0xae/0xf0 [target_core_mod]

but task is already holding lock:
 (&sb->s_type->i_mutex_key#14){++++++}, at: [<ffffffff811c5c30>]
vfs_rmdir+0x50/0x140

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #1 (&sb->s_type->i_mutex_key#14){++++++}:
       lock_acquire+0x59/0x80
       down_write+0x36/0x70
       configfs_depend_item+0x3a/0xb0 [configfs]
       target_depend_item+0x13/0x20 [target_core_mod]
       target_xcopy_locate_se_dev_e4_iter+0x87/0x100 [target_core_mod]
       target_devices_idr_iter+0x16/0x20 [target_core_mod]
       idr_for_each+0x39/0xc0
       target_for_each_device+0x36/0x50 [target_core_mod]
       target_xcopy_locate_se_dev_e4+0x28/0x80 [target_core_mod]
       target_xcopy_do_work+0x2e9/0xdd0 [target_core_mod]
       process_one_work+0x1ca/0x3f0
       worker_thread+0x49/0x3b0
       kthread+0x109/0x140
       ret_from_fork+0x31/0x40

-> #0 (device_mutex#2){+.+.+.}:
       __lock_acquire+0x101f/0x11d0
       lock_acquire+0x59/0x80
       __mutex_lock+0x7e/0x950
       mutex_lock_nested+0x16/0x20
       target_free_device+0xae/0xf0 [target_core_mod]
       target_core_dev_release+0x10/0x20 [target_core_mod]
       config_item_put+0x6e/0xb0 [configfs]
       configfs_rmdir+0x1a6/0x300 [configfs]
       vfs_rmdir+0xb7/0x140
       do_rmdir+0x1f4/0x200
       SyS_rmdir+0x11/0x20
       entry_SYSCALL_64_fastpath+0x23/0xc2

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&sb->s_type->i_mutex_key#14);
                               lock(device_mutex#2);
                               lock(&sb->s_type->i_mutex_key#14);
  lock(device_mutex#2);

 *** DEADLOCK ***

3 locks held by rmdir/12053:
 #0:  (sb_writers#10){.+.+.+}, at: [<ffffffff811e223f>]
mnt_want_write+0x1f/0x50
 #1:  (&sb->s_type->i_mutex_key#14/1){+.+.+.}, at: [<ffffffff811cb97e>]
do_rmdir+0x15e/0x200
 #2:  (&sb->s_type->i_mutex_key#14){++++++}, at: [<ffffffff811c5c30>]
vfs_rmdir+0x50/0x140

stack backtrace:
CPU: 3 PID: 12053 Comm: rmdir Not tainted 4.12.0-rc1-dbg+ #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.0.0-prebuilt.qemu-project.org 04/01/2014
Call Trace:
 dump_stack+0x86/0xcf
 print_circular_bug+0x1c7/0x220
 __lock_acquire+0x101f/0x11d0
 lock_acquire+0x59/0x80
 __mutex_lock+0x7e/0x950
 mutex_lock_nested+0x16/0x20
 target_free_device+0xae/0xf0 [target_core_mod]
 target_core_dev_release+0x10/0x20 [target_core_mod]
 config_item_put+0x6e/0xb0 [configfs]
 configfs_rmdir+0x1a6/0x300 [configfs]
 vfs_rmdir+0xb7/0x140
 do_rmdir+0x1f4/0x200
 SyS_rmdir+0x11/0x20
 entry_SYSCALL_64_fastpath+0x23/0xc2

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
[drop target_find_device because it is no longer used]
Signed-off-by: Mike Christie <mchristi@redhat.com>

---
 drivers/target/target_core_device.c  | 46 +++++++++++++-----------------------
 include/target/target_core_backend.h |  2 --
 2 files changed, 17 insertions(+), 31 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index e27db4d..68cc48b 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -879,39 +879,21 @@ sector_t target_to_linux_sector(struct se_device *dev, sector_t lb)
 }
 EXPORT_SYMBOL(target_to_linux_sector);
 
-/**
- * target_find_device - find a se_device by its dev_index
- * @id: dev_index
- * @do_depend: true if caller needs target_depend_item to be done
- *
- * If do_depend is true, the caller must do a target_undepend_item
- * when finished using the device.
- *
- * If do_depend is false, the caller must be called in a configfs
- * callback or during removal.
- */
-struct se_device *target_find_device(int id, bool do_depend)
-{
-	struct se_device *dev;
-
-	mutex_lock(&device_mutex);
-	dev = idr_find(&devices_idr, id);
-	if (dev && do_depend && target_depend_item(&dev->dev_group.cg_item))
-		dev = NULL;
-	mutex_unlock(&device_mutex);
-	return dev;
-}
-EXPORT_SYMBOL(target_find_device);
-
 struct devices_idr_iter {
+	struct config_item *prev_item;
 	int (*fn)(struct se_device *dev, void *data);
 	void *data;
 };
 
 static int target_devices_idr_iter(int id, void *p, void *data)
+	__must_hold(&device_mutex)
 {
 	struct devices_idr_iter *iter = data;
 	struct se_device *dev = p;
+	int ret;
+
+	config_item_put(iter->prev_item);
+	iter->prev_item = NULL;
 
 	/*
 	 * We add the device early to the idr, so it can be used
@@ -922,7 +904,15 @@ static int target_devices_idr_iter(int id, void *p, void *data)
 	if (!(dev->dev_flags & DF_CONFIGURED))
 		return 0;
 
-	return iter->fn(dev, iter->data);
+	iter->prev_item = config_item_get_unless_zero(&dev->dev_group.cg_item);
+	if (!iter->prev_item)
+		return 0;
+	mutex_unlock(&device_mutex);
+
+	ret = iter->fn(dev, iter->data);
+
+	mutex_lock(&device_mutex);
+	return ret;
 }
 
 /**
@@ -936,15 +926,13 @@ static int target_devices_idr_iter(int id, void *p, void *data)
 int target_for_each_device(int (*fn)(struct se_device *dev, void *data),
 			   void *data)
 {
-	struct devices_idr_iter iter;
+	struct devices_idr_iter iter = { .fn = fn, .data = data };
 	int ret;
 
-	iter.fn = fn;
-	iter.data = data;
-
 	mutex_lock(&device_mutex);
 	ret = idr_for_each(&devices_idr, target_devices_idr_iter, &iter);
 	mutex_unlock(&device_mutex);
+	config_item_put(iter.prev_item);
 	return ret;
 }
 
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 34a15d5..c3ac472 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -106,8 +106,6 @@ bool	target_lun_is_rdonly(struct se_cmd *);
 sense_reason_t passthrough_parse_cdb(struct se_cmd *cmd,
 	sense_reason_t (*exec_cmd)(struct se_cmd *cmd));
 
-struct	se_device *target_find_device(int id, bool do_depend);
-
 bool target_sense_desc_format(struct se_device *dev);
 sector_t target_to_linux_sector(struct se_device *dev, sector_t lb);
 bool target_configure_unmap_from_queue(struct se_dev_attrib *attrib,
-- 
2.7.2


--------------040201030003040502070707--
