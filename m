From: Zhu Lingshan <lszhu@suse.com>
Date: Fri, 15 Jun 2018 18:23:36 +0000
Subject: [PATCH 27/33] TCMU PR: enable PR register and ReadKeys for TCMU
Message-Id: <20180615182342.6239-27-lszhu@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patch added a function is_passthrough_pr_supportive_dev()
to tell whether the device can support passthrough Persistent
Reservation, if supported, tcmu_configure_device() will set 1 to
dev->passthrough_pr to indicate it.

If dev->passthrough_pr is 1, both dev->transport->pr_ops
and dev->transport->pr_ops->pr_register are not NULL,
core_scsi3_emulate_pro_register() will call
dev->transport->pr_ops->pr_register, this means call
tcmu_execute_pr_register(). It is the same way how
core_scsi3_pri_read_keys() can call tcmu_execute_pr_read_keys.

Signed-off-by: Zhu Lingshan <lszhu@suse.com>
---
 drivers/target/target_core_pr.c   | 23 +++++++++++++++++++++++
 drivers/target/target_core_pr.h   |  2 ++
 drivers/target/target_core_user.c | 20 ++++++++++++++++++++
 include/target/target_core_base.h |  7 +++++++
 4 files changed, 52 insertions(+)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 01ac306131c1..0a06b8bb1134 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -2064,6 +2064,21 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 	sense_reason_t ret = TCM_NO_SENSE;
 	int pr_holder = 0, type;
 
+	if (dev->transport->pr_ops && dev->transport->pr_ops->pr_register
+	    && dev->passthrough_pr) {
+		bool ignore_existing;
+
+		if (register_type = REGISTER_AND_IGNORE_EXISTING_KEY)
+			ignore_existing = true;
+		else
+			ignore_existing = false;
+		ret = dev->transport->pr_ops->pr_register(cmd, res_key,
+							  sa_res_key, aptpl,
+							  all_tg_pt, spec_i_pt,
+							  ignore_existing);
+		return ret;
+	}
+
 	if (!se_sess || !se_lun) {
 		pr_err("SPC-3 PR: se_sess || struct se_lun is NULL!\n");
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
@@ -3707,6 +3722,7 @@ core_scsi3_pri_read_keys(struct se_cmd *cmd)
 	struct t10_pr_registration *pr_reg;
 	unsigned char *buf;
 	u32 add_len = 0, off = 8;
+	sense_reason_t ret = 0;
 
 	if (cmd->data_length < 8) {
 		pr_err("PRIN SA READ_KEYS SCSI Data Length: %u"
@@ -3718,6 +3734,13 @@ core_scsi3_pri_read_keys(struct se_cmd *cmd)
 	if (!buf)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
+	if (dev->transport->pr_ops && dev->transport->pr_ops->pr_read_keys
+	    && dev->passthrough_pr) {
+		ret = dev->transport->pr_ops->pr_read_keys(cmd, buf,
+							   cmd->data_length);
+		return ret;
+	}
+
 	put_unaligned_be32(dev->t10_pr.pr_generation, buf);
 
 	spin_lock(&dev->t10_pr.registration_lock);
diff --git a/drivers/target/target_core_pr.h b/drivers/target/target_core_pr.h
index 198fad5c89dc..1a74112c35d3 100644
--- a/drivers/target/target_core_pr.h
+++ b/drivers/target/target_core_pr.h
@@ -49,6 +49,8 @@
 #define PR_APTPL_MAX_IPORT_LEN			256
 #define PR_APTPL_MAX_TPORT_LEN			256
 
+#define PASSTHROUGH_PR_SUPPORT			1
+
 /*
  *  Function defined in target_core_spc.c
  */
diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index ea3685106d35..bde325888477 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -2955,6 +2955,21 @@ tcmu_execute_pr_read_keys(struct se_cmd *cmd, unsigned char *buf, u32 buf_len)
 	return TCM_NO_SENSE;
 }
 
+/*
+ * This function can help to check wheterh the device support
+ * pass through PR operations. Now only Ceph RBD support
+ * passthrough PR. When someday we have another kind of
+ * device can support passthrough PR, we can easily add
+ * a line like ret |= !strncmp(udev->dev_config, "qcow/", 5);
+ */
+static int is_passthrough_pr_supportive_dev(struct tcmu_dev *udev)
+{
+	int ret = 0;
+
+	ret |= !strncmp(udev->dev_config, "rbd/", 4);
+	return ret;
+}
+
 static int tcmu_configure_device(struct se_device *dev)
 {
 	struct tcmu_dev *udev = TCMU_DEV(dev);
@@ -3046,6 +3061,11 @@ static int tcmu_configure_device(struct se_device *dev)
 	list_add(&udev->node, &root_udev);
 	mutex_unlock(&root_udev_mutex);
 
+	if (is_passthrough_pr_supportive_dev(udev) && dev->transport->pr_ops) {
+		mutex_init(&udev->pr_info.pr_info_lock);
+		dev->passthrough_pr = PASSTHROUGH_PR_SUPPORT;
+	}
+
 	return 0;
 
 err_netlink:
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 9f9f5902af38..9acb3363fd2b 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -825,6 +825,13 @@ struct se_device {
 	/* For se_lun->lun_se_dev RCU read-side critical access */
 	u32			hba_index;
 	struct rcu_head		rcu_head;
+	/*
+	 * For now, only Ceph RBD support pass through PR operations,
+	 * others like QCOW can not support this yet, so we need this
+	 * int to indicate whether we can send pass through PR message
+	 * to userspace.
+	 */
+	int passthrough_pr;
 };
 
 struct se_hba {
-- 
2.17.1

