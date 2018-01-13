From: Mike Christie <mchristi@redhat.com>
Date: Sat, 13 Jan 2018 18:50:39 +0000
Subject: Re: [PATCH 0/5]: Fix target_core_user userspace restarts (v2)
Message-Id: <5A5A54FF.4010804@redhat.com>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="------------060801050901020108080500"
List-Id: <target-devel.vger.kernel.org>
References: <1513677838-6675-1-git-send-email-mchristi@redhat.com>
In-Reply-To: <1513677838-6675-1-git-send-email-mchristi@redhat.com>
To: target-devel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060801050901020108080500
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 01/12/2018 10:08 PM, Nicholas A. Bellinger wrote:
> On Fri, 2018-01-12 at 16:41 -0600, Mike Christie wrote:
>> On 01/12/2018 04:13 PM, Nicholas A. Bellinger wrote:
> 
> <SNIP>
> 
>>> Was wondering about that..
>>>
>>> Why shouldn't these be added as backend device specific configfs
>>> attributes, similar to what tcmu does for tcmu_attrib_attrs[]..?
>>
>>
>> Hey,
>>
>> The problem is that rtslib assumes attrs are things that the user always
>> wants to get/set. For example, when you create a device the attrs will
>> be read and stored in some config file so later when targetcli
>> restoreconfig is run it will write the stored values thinking they are
>> the user requested defaults.
>>
>> The primary purpose of the files being added in these last patches are
>> to allow userspace to tell the backend module to perform some operation.
>> For example, when we restart tcmu-runner it is really easy to do if IO
>> is not being sent to the daemon at the same time. The block file
>> prevents IO from being sent and the reset file makes sure the ring
>> (buffer used to pass commands between user/kernel space) is in a good
>> state (this is needed for the case where runner crashed).
>>
>> We do not want targetcli writing whatever value it found in these
>> special files when the device was created because it might for example
>> leave a device blocked.
> 
> pi_prot_format is a similar case wrt rtslib + se_device creation.
> 
> For that one, attr read is always '0' and attr write '0' is considered
> a nop.
> 

This will work for me. I attached a patch that implements this for the
files and is built off your for-next branch.


>>
>> I guess the options were:
>>
>> 1. This patch that separates this kind of files and tries to make it
>> generic.
>> 2. Instead of the generic action dir, I could just make a
>> target_core_user specific dir.
>> 3. I can modify rtslib with a attr file blacklist, and these special
>> files can go in it.
>>
>> I thought #1 or even #2 was nicer, because attrs seemed like they had a
>> specific purpose to get/set info about an object.
> 
> If it's purely to avoid block_dev + reset_ring attr write operation upon
> rtslib se_device creation, following how pi_prot_format works with
> existing tcmu_attrib_attrs[] is an option too.
> 
> That said, I'm not against adding a new se_device->dev_action_group, but
> want to make sure these new attributes are really considered private to
> tcmu's own user-space, separate what rtslib + friends code ever expects
> to poke at..
> 
> Is that the case..?

I am not sure I understood the question completely.

I can imagine someone creating other apps and wanting to use these files
for similar reasons as tcmu-runner. We have seen people that are making
their own tcmu daemons/userspace apps and sometimes use rtslib and
sometimes do not. Does that answer your question?

I can go either way on the action dir vs attached patch that implements
them as attrs. I did know about the 4th pi_prot_format style option :)

--------------060801050901020108080500
Content-Type: text/x-patch;
 name="0001-tcmu-allow-userspace-to-reset-ring-v3.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-tcmu-allow-userspace-to-reset-ring-v3.patch"

From cfccc62293ac174d9c407fb2faf04870eab571e2 Mon Sep 17 00:00:00 2001
From: Mike Christie <mchristi@redhat.com>
Date: Sat, 13 Jan 2018 12:34:34 -0600
Subject: [PATCH] tcmu: allow userspace to reset ring (v3)

This patch adds 2 tcmu attrs to block/unblock a device and
reset the ring buffer. They are used when the userspace
daemon has crashed or forced to shutdown while IO is executing.
On restart, the daemon can block the device so new IO is not
sent to userspace while it puts the ring in a clean state.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---

v3: move files back to attr based. Uses 0 as a no op to avoid targetcli
setup attr initialization from missetting the state.
v2: move reset/block files to action dir
v1: RFC to add reset/block attrs.

 drivers/target/target_core_user.c | 167 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 164 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index dedb971..e7c051a5 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -121,6 +121,7 @@ struct tcmu_dev {
 
 #define TCMU_DEV_BIT_OPEN 0
 #define TCMU_DEV_BIT_BROKEN 1
+#define TCMU_DEV_BIT_BLOCKED 2
 	unsigned long flags;
 
 	struct uio_info uio_info;
@@ -875,6 +877,11 @@ static sense_reason_t queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, int *scsi_err)
 
 	*scsi_err = TCM_NO_SENSE;
 
+	if (test_bit(TCMU_DEV_BIT_BLOCKED, &udev->flags)) {
+		*scsi_err = TCM_LUN_BUSY;
+		return -1;
+	}
+
 	if (test_bit(TCMU_DEV_BIT_BROKEN, &udev->flags)) {
 		*scsi_err = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 		return -1;
@@ -1249,7 +1256,7 @@ static struct se_device *tcmu_alloc_device(struct se_hba *hba, const char *name)
 	return &udev->se_dev;
 }
 
-static bool run_cmdr_queue(struct tcmu_dev *udev)
+static bool run_cmdr_queue(struct tcmu_dev *udev, bool fail)
 {
 	struct tcmu_cmd *tcmu_cmd, *tmp_cmd;
 	LIST_HEAD(cmds);
@@ -1260,7 +1267,7 @@ static bool run_cmdr_queue(struct tcmu_dev *udev)
 	if (list_empty(&udev->cmdr_queue))
 		return true;
 
-	pr_debug("running %s's cmdr queue\n", udev->name);
+	pr_debug("running %s's cmdr queue forcefail %d\n", udev->name, fail);
 
 	list_splice_init(&udev->cmdr_queue, &cmds);
 
@@ -1270,6 +1277,20 @@ static bool run_cmdr_queue(struct tcmu_dev *udev)
 	        pr_debug("removing cmd %u on dev %s from queue\n",
 		         tcmu_cmd->cmd_id, udev->name);
 
+		if (fail) {
+			idr_remove(&udev->commands, tcmu_cmd->cmd_id);
+			/*
+			 * We were not able to even start the command, so
+			 * fail with busy to allow a retry in case runner
+			 * was only temporarily down. If the device is being
+			 * removed then LIO core will do the right thing and
+			 * fail the retry.
+			 */
+			target_complete_cmd(tcmu_cmd->se_cmd, SAM_STAT_BUSY);
+			tcmu_free_cmd(tcmu_cmd);
+			continue;
+		}
+
 		ret = queue_cmd_ring(tcmu_cmd, &scsi_ret);
 		if (ret < 0) {
 		        pr_debug("cmd %u on dev %s failed with %u\n",
@@ -1306,7 +1327,7 @@ static int tcmu_irqcontrol(struct uio_info *info, s32 irq_on)
 
 	mutex_lock(&udev->cmdr_lock);
 	tcmu_handle_completions(udev);
-	run_cmdr_queue(udev);
+	run_cmdr_queue(udev, false);
 	mutex_unlock(&udev->cmdr_lock);
 
 	return 0;
@@ -1788,6 +1809,78 @@ static void tcmu_destroy_device(struct se_device *dev)
 	kref_put(&udev->kref, tcmu_dev_kref_release);
 }
 
+static void tcmu_unblock_dev(struct tcmu_dev *udev)
+{
+	mutex_lock(&udev->cmdr_lock);
+	clear_bit(TCMU_DEV_BIT_BLOCKED, &udev->flags);
+	mutex_unlock(&udev->cmdr_lock);
+}
+
+static void tcmu_block_dev(struct tcmu_dev *udev)
+{
+	mutex_lock(&udev->cmdr_lock);
+
+	if (test_and_set_bit(TCMU_DEV_BIT_BLOCKED, &udev->flags))
+		goto unlock;
+
+	/* complete IO that has executed successfully */
+	tcmu_handle_completions(udev);
+	/* fail IO waiting to be queued */
+	run_cmdr_queue(udev, true);
+
+unlock:
+	mutex_unlock(&udev->cmdr_lock);
+}
+
+static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
+{
+	struct tcmu_mailbox *mb;
+	struct tcmu_cmd *cmd;
+	int i;
+
+	mutex_lock(&udev->cmdr_lock);
+
+	idr_for_each_entry(&udev->commands, cmd, i) {
+		if (!list_empty(&cmd->cmdr_queue_entry))
+			continue;
+
+		pr_debug("removing cmd %u on dev %s from ring (is expired %d)\n",
+			  cmd->cmd_id, udev->name,
+			  test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags));
+
+		idr_remove(&udev->commands, i);
+		if (!test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags)) {
+			if (err_level == 1) {
+				/*
+				 * Userspace was not able to start the
+				 * command or it is retryable.
+				 */
+				target_complete_cmd(cmd->se_cmd, SAM_STAT_BUSY);
+			} else {
+				/* hard failure */
+				target_complete_cmd(cmd->se_cmd,
+						    SAM_STAT_CHECK_CONDITION);
+			}
+		}
+		tcmu_cmd_free_data(cmd, cmd->dbi_cnt);
+		tcmu_free_cmd(cmd);
+	}
+
+	mb = udev->mb_addr;
+	tcmu_flush_dcache_range(mb, sizeof(*mb));
+	pr_debug("mb last %u head %u tail %u\n", udev->cmdr_last_cleaned,
+		 mb->cmd_tail, mb->cmd_head);
+
+	udev->cmdr_last_cleaned = 0;
+	mb->cmd_tail = 0;
+	mb->cmd_head = 0;
+	tcmu_flush_dcache_range(mb, sizeof(*mb));
+
+	del_timer(&udev->cmd_timer);
+
+	mutex_unlock(&udev->cmdr_lock);
+}
+
 enum {
 	Opt_dev_config, Opt_dev_size, Opt_hw_block_size, Opt_hw_max_sectors,
 	Opt_nl_reply_supported, Opt_max_data_area_mb, Opt_err,
@@ -2178,6 +2271,72 @@ static ssize_t tcmu_emulate_write_cache_store(struct config_item *item,
 }
 CONFIGFS_ATTR(tcmu_, emulate_write_cache);
 
+static ssize_t tcmu_block_dev_show(struct config_item *item, char *page)
+{
+	return snprintf(page, PAGE_SIZE, "0\n");
+}
+
+static ssize_t tcmu_block_dev_store(struct config_item *item, const char *page,
+				    size_t count)
+{
+	struct se_dev_attrib *da = container_of(to_config_group(item),
+						struct se_dev_attrib, da_group);
+	struct tcmu_dev *udev = TCMU_DEV(da->da_dev);
+	u8 val;
+	int ret;
+
+	ret = kstrtou8(page, 0, &val);
+	if (ret < 0)
+		return ret;
+
+	if (!val)
+		return count;
+
+	if (val == 2) {
+		tcmu_unblock_dev(udev);
+	} else if (val == 1) {
+		tcmu_block_dev(udev);
+	} else {
+		pr_err("Invalid block value %d\n", val);
+		return -EINVAL;
+	}
+
+	return count;
+}
+CONFIGFS_ATTR(tcmu_, block_dev);
+
+static ssize_t tcmu_reset_ring_show(struct config_item *item, char *page)
+{
+	return snprintf(page, PAGE_SIZE, "0\n");
+}
+
+static ssize_t tcmu_reset_ring_store(struct config_item *item, const char *page,
+				     size_t count)
+{
+	struct se_dev_attrib *da = container_of(to_config_group(item),
+						struct se_dev_attrib, da_group);
+	struct tcmu_dev *udev = TCMU_DEV(da->da_dev);
+	u8 val;
+	int ret;
+
+
+	ret = kstrtou8(page, 0, &val);
+	if (ret < 0)
+		return ret;
+
+	if (!val)
+		return count;
+
+	if (val != 1 && val != 2) {
+		pr_err("Invalid reset ring value %d\n", val);
+		return -EINVAL;
+	}
+
+	tcmu_reset_ring(udev, val);
+	return count;
+}
+CONFIGFS_ATTR(tcmu_, reset_ring);
+
 static struct configfs_attribute *tcmu_attrib_attrs[] = {
 	&tcmu_attr_cmd_time_out,
 	&tcmu_attr_qfull_time_out,
@@ -2186,6 +2345,8 @@ static ssize_t tcmu_emulate_write_cache_store(struct config_item *item,
 	&tcmu_attr_dev_size,
 	&tcmu_attr_emulate_write_cache,
 	&tcmu_attr_nl_reply_supported,
+	&tcmu_attr_block_dev,
+	&tcmu_attr_reset_ring,
 	NULL,
 };
 
-- 
1.8.3.1


--------------060801050901020108080500--
