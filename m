From: Mike Christie <mchristi@redhat.com>
Date: Sun, 10 May 2020 21:57:38 +0000
Subject: [PATCH 09/15] target: drop sess_get_initiator_sid from PR code
Message-Id: <20200510215744.21999-10-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200510215744.21999-1-mchristi@redhat.com>
In-Reply-To: <20200510215744.21999-1-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: bvanassche@acm.org, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Mike Christie <mchristi@redhat.com>

Use the transport id session id in the PR related code.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_pr.c        | 23 ++++-------------------
 drivers/target/target_core_transport.c | 11 ++++-------
 2 files changed, 8 insertions(+), 26 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index cd2d32f..fbe3638 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -1204,17 +1204,7 @@ static struct t10_pr_registration *core_scsi3_locate_pr_reg(
 	struct se_node_acl *nacl,
 	struct se_session *sess)
 {
-	struct se_portal_group *tpg = nacl->se_tpg;
-	unsigned char buf[PR_REG_ISID_LEN], *isid_ptr = NULL;
-
-	if (tpg->se_tpg_tfo->sess_get_initiator_sid != NULL) {
-		memset(&buf[0], 0, PR_REG_ISID_LEN);
-		tpg->se_tpg_tfo->sess_get_initiator_sid(sess, &buf[0],
-					PR_REG_ISID_LEN);
-		isid_ptr = &buf[0];
-	}
-
-	return __core_scsi3_locate_pr_reg(dev, nacl, isid_ptr);
+	return __core_scsi3_locate_pr_reg(dev, nacl, sess->tpt_id->session_id);
 }
 
 static void core_scsi3_put_pr_reg(struct t10_pr_registration *pr_reg)
@@ -1592,7 +1582,7 @@ static void core_scsi3_lunacl_undepend_item(struct se_dev_entry *se_deve)
 			 * SCSI Intiatior TransportID w/ ISIDs is enforced
 			 * for fabric modules (iSCSI) requiring them.
 			 */
-			if (tpg->se_tpg_tfo->sess_get_initiator_sid &&
+			if (se_sess->tpt_id->session_id &&
                             dev->dev_attrib.enforce_pr_isids &&
 			    !iport_ptr) {
 				pr_warn("SPC-PR: enforce_pr_isids is set but a isid has not been sent in the SPEC_I_PT data for %s.",
@@ -2057,7 +2047,7 @@ static sense_reason_t core_scsi3_update_and_write_aptpl(struct se_device *dev, b
 	struct se_portal_group *se_tpg;
 	struct t10_pr_registration *pr_reg, *pr_reg_p, *pr_reg_tmp;
 	struct t10_reservation *pr_tmpl = &dev->t10_pr;
-	unsigned char isid_buf[PR_REG_ISID_LEN], *isid_ptr = NULL;
+	unsigned char *isid_ptr = NULL;
 	sense_reason_t ret = TCM_NO_SENSE;
 	int pr_holder = 0, type;
 
@@ -2067,12 +2057,7 @@ static sense_reason_t core_scsi3_update_and_write_aptpl(struct se_device *dev, b
 	}
 	se_tpg = se_sess->se_tpg;
 
-	if (se_tpg->se_tpg_tfo->sess_get_initiator_sid) {
-		memset(&isid_buf[0], 0, PR_REG_ISID_LEN);
-		se_tpg->se_tpg_tfo->sess_get_initiator_sid(se_sess, &isid_buf[0],
-				PR_REG_ISID_LEN);
-		isid_ptr = &isid_buf[0];
-	}
+	isid_ptr = se_sess->tpt_id->session_id;
 	/*
 	 * Follow logic from spc4r17 Section 5.7.7, Register Behaviors Table 47
 	 */
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index fb00fcc..fdf84db 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -343,7 +343,7 @@ void __transport_register_session(
 	void *fabric_sess_ptr)
 {
 	const struct target_core_fabric_ops *tfo = se_tpg->se_tpg_tfo;
-	unsigned char buf[PR_REG_ISID_LEN];
+	unsigned char *sid;
 	unsigned long flags;
 
 	se_sess->se_tpg = se_tpg;
@@ -374,12 +374,9 @@ void __transport_register_session(
 		 * If the fabric module supports an ISID based TransportID,
 		 * save this value in binary from the fabric I_T Nexus now.
 		 */
-		if (se_tpg->se_tpg_tfo->sess_get_initiator_sid != NULL) {
-			memset(&buf[0], 0, PR_REG_ISID_LEN);
-			se_tpg->se_tpg_tfo->sess_get_initiator_sid(se_sess,
-					&buf[0], PR_REG_ISID_LEN);
-			se_sess->sess_bin_isid = get_unaligned_be64(&buf[0]);
-		}
+		sid = se_sess->tpt_id->session_id;
+		if (sid)
+			se_sess->sess_bin_isid = get_unaligned_be64(sid);
 
 		spin_lock_irqsave(&se_nacl->nacl_sess_lock, flags);
 		/*
-- 
1.8.3.1
