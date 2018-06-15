From: Zhu Lingshan <lszhu@suse.com>
Date: Fri, 15 Jun 2018 18:23:10 +0000
Subject: [PATCH 01/33] TCMU PR: first commit to implement TCMU PR
Message-Id: <20180615182342.6239-1-lszhu@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

These commits and the following intend to implement Persistent
Reservation operations for TCMU devices.

This series of commits would implement such PR operations:
PR_Out_Register, PR_Out_Reserve, PR_Out_Clear, PR_Out_Preempt,
PR_Out_Release and PR_In_ReadKeys.

Next wave of patches will contain the other PR operations.

This patch added a struct tcmu_pr_info to store PR information
for the handling functions, added command codes and attrs for
netlink interfaces.

Design note:
In order to get consistent Persistent Reservation results from
multiple targets hosting the same TCMU device(like Ceph RBD),
this solution stores a string on the device itself(like RBD metadata).

Everytime when kernel receive a PR request against a TCMU device,
it will query this string(a netlink attr carried by a netlink cmd).
Then decide whether the PR request should be performed, after
processing, it will update this string.

For example:
When receive a PR Reserve request, kernel will send a netlink
message to tcmu-runner, try to get the string, tcmu-runner will
response, send the PR info string to kernel. Then kernel will
decode the string, find information like key, reservation holder,
then process this request. After processing, it will update the
string, send the updated string to tcmu-runner, so that tcmu-runner
will write it back to the device(like RBD metadata).

So we make the device itself as a "single" response point, (with
locks protection) we will get a consistent result even more than one
initiators sending multiple PR requests via multiple targets.

Signed-off-by: Zhu Lingshan <lszhu@suse.com>
---
 include/uapi/linux/target_core_user.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/include/uapi/linux/target_core_user.h b/include/uapi/linux/target_core_user.h
index 0be80f72646b..2d5c3e55d3f8 100644
--- a/include/uapi/linux/target_core_user.h
+++ b/include/uapi/linux/target_core_user.h
@@ -132,9 +132,13 @@ enum tcmu_genl_cmd {
 	TCMU_CMD_ADDED_DEVICE,
 	TCMU_CMD_REMOVED_DEVICE,
 	TCMU_CMD_RECONFIG_DEVICE,
+	TCMU_CMD_GET_PR_INFO,
+	TCMU_CMD_SET_PR_INFO,
 	TCMU_CMD_ADDED_DEVICE_DONE,
 	TCMU_CMD_REMOVED_DEVICE_DONE,
 	TCMU_CMD_RECONFIG_DEVICE_DONE,
+	TCMU_CMD_GET_PR_INFO_DONE,
+	TCMU_CMD_SET_PR_INFO_DONE,
 	TCMU_CMD_SET_FEATURES,
 	__TCMU_CMD_MAX,
 };
@@ -151,8 +155,23 @@ enum tcmu_genl_attr {
 	TCMU_ATTR_CMD_STATUS,
 	TCMU_ATTR_DEVICE_ID,
 	TCMU_ATTR_SUPP_KERN_CMD_REPLY,
+	TCMU_ATTR_PR_INFO,
 	__TCMU_ATTR_MAX,
 };
 #define TCMU_ATTR_MAX (__TCMU_ATTR_MAX - 1)
 
+/* This struct help to store the Persistent Reservation which we
+ * are handling, it is encoded from or decoded to the string buffer in
+ * "struct tcmu_dev_pr_info"
+ */
+struct tcmu_pr_info {
+	u32 vers;		/* on disk format version number */
+	u32 seq;		/* sequence number bumped every xattr write */
+	struct tcmu_scsi2_rsv *scsi2_rsv; /* SCSI2 reservation if any */
+	u32 gen;		/* PR generation number */
+	struct tcmu_pr_rsv *rsv;	/* SCSI3 reservation if any */
+	u32 num_regs;		/* number of registrations */
+	struct list_head regs;	/* list of registrations */
+};
+
 #endif
-- 
2.17.1

