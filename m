From: Zhu Lingshan <lszhu@suse.com>
Date: Fri, 15 Jun 2018 18:23:33 +0000
Subject: [PATCH 24/33] TCMU PR: handle PR read keys for TCMU devs
Message-Id: <20180615182342.6239-24-lszhu@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patch added a function tcmu_execute_pr_read_keys() which
can help handle Persistent Reservation Read Keys.

Signed-off-by: Zhu Lingshan <lszhu@suse.com>
---
 drivers/target/target_core_user.c | 74 +++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 2fcdfc97ca75..a89c866a755d 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -2846,6 +2846,80 @@ static int tcmu_pr_info_mock_empty(struct tcmu_pr_info **_pr_info)
 	return 0;
 }
 
+static sense_reason_t
+tcmu_execute_pr_read_keys(struct se_cmd *cmd, unsigned char *buf, u32 buf_len)
+{
+	struct se_device *dev = cmd->se_dev;
+	struct tcmu_pr_info *pr_info = NULL;
+	struct tcmu_pr_reg *reg;
+	u32 add_len = 0, off = 8;
+	int rc;
+	struct tcmu_dev *udev = TCMU_DEV(dev);
+
+	udev->pr_info.pr_info_buf = kzalloc(TCMU_PR_INFO_XATTR_MAX_SIZE,
+					    GFP_KERNEL);
+	if (!udev->pr_info.pr_info_buf)
+		return TCM_OUT_OF_RESOURCES;
+
+	if (buf_len < 8) {
+		WARN_ON(1);
+		kfree(udev->pr_info.pr_info_buf);
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+	}
+
+	pr_debug("getting pr_info for buf: %p, %u\n", buf, buf_len);
+
+	rc = tcmu_pr_info_get(udev, &pr_info, NULL, NULL);
+	if (rc = -ENODATA) {
+		pr_debug("PR info not present for read, mocking empty\n");
+		rc = tcmu_pr_info_mock_empty(&pr_info);
+	}
+	if (rc < 0) {
+		kfree(udev->pr_info.pr_info_buf);
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+	}
+	pr_debug("packing read_keys response buf: %p, %u\n", buf, buf_len);
+
+	buf[0] = ((pr_info->gen >> 24) & 0xff);
+	buf[1] = ((pr_info->gen >> 16) & 0xff);
+	buf[2] = ((pr_info->gen >> 8) & 0xff);
+	buf[3] = (pr_info->gen & 0xff);
+
+	pr_debug("packed gen %u in read_keys response\n", pr_info->gen);
+
+	list_for_each_entry(reg, &pr_info->regs, regs_node) {
+		/*
+		 * Check for overflow of 8byte PRI READ_KEYS payload and
+		 * next reservation key list descriptor.
+		 */
+		if ((add_len + 8) > (buf_len - 8))
+			break;
+
+		buf[off++] = ((reg->key >> 56) & 0xff);
+		buf[off++] = ((reg->key >> 48) & 0xff);
+		buf[off++] = ((reg->key >> 40) & 0xff);
+		buf[off++] = ((reg->key >> 32) & 0xff);
+		buf[off++] = ((reg->key >> 24) & 0xff);
+		buf[off++] = ((reg->key >> 16) & 0xff);
+		buf[off++] = ((reg->key >> 8) & 0xff);
+		buf[off++] = (reg->key & 0xff);
+		pr_debug("packed key 0x%llx in read_keys response\n", reg->key);
+
+		add_len += 8;
+	}
+
+	buf[4] = ((add_len >> 24) & 0xff);
+	buf[5] = ((add_len >> 16) & 0xff);
+	buf[6] = ((add_len >> 8) & 0xff);
+	buf[7] = (add_len & 0xff);
+
+	pr_debug("packed len %u in read_keys response\n", add_len);
+	tcmu_pr_info_free(pr_info);
+	kfree(udev->pr_info.pr_info_buf);
+
+	return TCM_NO_SENSE;
+}
+
 static int tcmu_configure_device(struct se_device *dev)
 {
 	struct tcmu_dev *udev = TCMU_DEV(dev);
-- 
2.17.1

