From: Hannes Reinecke <hare@suse.com>
Date: Thu, 02 Nov 2017 13:59:30 +0000
Subject: Re: [PATCH 04/11] target: Avoid that EXTENDED COPY commands triggers lock inversion
Message-Id: <98b817f0-7960-b595-ff39-71303291fb16@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: target-devel@vger.kernel.org

On 10/31/2017 07:03 PM, Bart Van Assche wrote:
> This patch prevents that lockdep reports the following complaint:
> 
> ===========================
> WARNING: possible circular locking dependency detected
> 4.12.0-rc1-dbg+ #1 Not tainted
> ------------------------------------------------------
> rmdir/12053 is trying to acquire lock:
>  (device_mutex#2){+.+.+.}, at: [<ffffffffa010afce>] target_free_device+0xae/0xf0 [target_core_mod]
> 
> but task is already holding lock:
>  (&sb->s_type->i_mutex_key#14){++++++}, at: [<ffffffff811c5c30>] vfs_rmdir+0x50/0x140
> 
> which lock already depends on the new lock.
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #1 (&sb->s_type->i_mutex_key#14){++++++}:
>        lock_acquire+0x59/0x80
>        down_write+0x36/0x70
>        configfs_depend_item+0x3a/0xb0 [configfs]
>        target_depend_item+0x13/0x20 [target_core_mod]
>        target_xcopy_locate_se_dev_e4_iter+0x87/0x100 [target_core_mod]
>        target_devices_idr_iter+0x16/0x20 [target_core_mod]
>        idr_for_each+0x39/0xc0
>        target_for_each_device+0x36/0x50 [target_core_mod]
>        target_xcopy_locate_se_dev_e4+0x28/0x80 [target_core_mod]
>        target_xcopy_do_work+0x2e9/0xdd0 [target_core_mod]
>        process_one_work+0x1ca/0x3f0
>        worker_thread+0x49/0x3b0
>        kthread+0x109/0x140
>        ret_from_fork+0x31/0x40
> 
> -> #0 (device_mutex#2){+.+.+.}:
>        __lock_acquire+0x101f/0x11d0
>        lock_acquire+0x59/0x80
>        __mutex_lock+0x7e/0x950
>        mutex_lock_nested+0x16/0x20
>        target_free_device+0xae/0xf0 [target_core_mod]
>        target_core_dev_release+0x10/0x20 [target_core_mod]
>        config_item_put+0x6e/0xb0 [configfs]
>        configfs_rmdir+0x1a6/0x300 [configfs]
>        vfs_rmdir+0xb7/0x140
>        do_rmdir+0x1f4/0x200
>        SyS_rmdir+0x11/0x20
>        entry_SYSCALL_64_fastpath+0x23/0xc2
> 
> other info that might help us debug this:
> 
>  Possible unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(&sb->s_type->i_mutex_key#14);
>                                lock(device_mutex#2);
>                                lock(&sb->s_type->i_mutex_key#14);
>   lock(device_mutex#2);
> 
>  *** DEADLOCK ***
> 
> 3 locks held by rmdir/12053:
>  #0:  (sb_writers#10){.+.+.+}, at: [<ffffffff811e223f>] mnt_want_write+0x1f/0x50
>  #1:  (&sb->s_type->i_mutex_key#14/1){+.+.+.}, at: [<ffffffff811cb97e>] do_rmdir+0x15e/0x200
>  #2:  (&sb->s_type->i_mutex_key#14){++++++}, at: [<ffffffff811c5c30>] vfs_rmdir+0x50/0x140
> 
> stack backtrace:
> CPU: 3 PID: 12053 Comm: rmdir Not tainted 4.12.0-rc1-dbg+ #1
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.0.0-prebuilt.qemu-project.org 04/01/2014
> Call Trace:
>  dump_stack+0x86/0xcf
>  print_circular_bug+0x1c7/0x220
>  __lock_acquire+0x101f/0x11d0
>  lock_acquire+0x59/0x80
>  __mutex_lock+0x7e/0x950
>  mutex_lock_nested+0x16/0x20
>  target_free_device+0xae/0xf0 [target_core_mod]
>  target_core_dev_release+0x10/0x20 [target_core_mod]
>  config_item_put+0x6e/0xb0 [configfs]
>  configfs_rmdir+0x1a6/0x300 [configfs]
>  vfs_rmdir+0xb7/0x140
>  do_rmdir+0x1f4/0x200
>  SyS_rmdir+0x11/0x20
>  entry_SYSCALL_64_fastpath+0x23/0xc2
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Nicholas Bellinger <nab@linux-iscsi.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Mike Christie <mchristi@redhat.com>
> ---
>  drivers/target/target_core_configfs.c | 18 +++++++++++++++++-
>  include/target/target_core_base.h     |  1 +
>  2 files changed, 18 insertions(+), 1 deletion(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
