From: Mike Christie <mchristi@redhat.com>
Date: Thu, 02 Aug 2018 17:12:25 +0000
Subject: [PATCH 6/8] target: srp, vscsi, sbp, qla: use target_remove_session
Message-Id: <1533229947-6277-7-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This converts the drivers that called transport_deregister_session_configfs
and then immediately called transport_deregister_session to use
target_remove_session.

Signed-off-by: Mike Christie <mchristi@redhat.com>
Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Chris Boot <bootc@bootc.net>
Cc: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
Cc: Michael Cyr <mikecyr@linux.vnet.ibm.com>
Cc: <qla2xxx-upstream@qlogic.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c    | 3 +--
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 3 +--
 drivers/scsi/qla2xxx/tcm_qla2xxx.c       | 3 +--
 drivers/target/sbp/sbp_target.c          | 3 +--
 4 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 21435a7..1ae638b 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2029,8 +2029,7 @@ static void srpt_release_channel_work(struct work_struct *w)
 	target_sess_cmd_list_set_waiting(se_sess);
 	target_wait_for_sess_cmds(se_sess);
 
-	transport_deregister_session_configfs(se_sess);
-	transport_deregister_session(se_sess);
+	target_remove_session(se_sess);
 	ch->sess = NULL;
 
 	if (ch->using_rdma_cm)
diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index 1bdf937..fac3773 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -2267,8 +2267,7 @@ static int ibmvscsis_drop_nexus(struct ibmvscsis_tport *tport)
 	 * Release the SCSI I_T Nexus to the emulated ibmvscsis Target Port
 	 */
 	target_wait_for_sess_cmds(se_sess);
-	transport_deregister_session_configfs(se_sess);
-	transport_deregister_session(se_sess);
+	target_remove_session(se_sess);
 	tport->ibmv_nexus = NULL;
 	kfree(nexus);
 
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index b9ce4e7..f71ec94 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1461,8 +1461,7 @@ static void tcm_qla2xxx_free_session(struct fc_port *sess)
 	}
 	target_wait_for_sess_cmds(se_sess);
 
-	transport_deregister_session_configfs(sess->se_sess);
-	transport_deregister_session(sess->se_sess);
+	target_remove_session(se_sess);
 }
 
 static int tcm_qla2xxx_session_cb(struct se_portal_group *se_tpg,
diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index c4369b5..3d10189 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -235,8 +235,7 @@ static void sbp_session_release(struct sbp_session *sess, bool cancel_work)
 	if (cancel_work)
 		cancel_delayed_work_sync(&sess->maint_work);
 
-	transport_deregister_session_configfs(sess->se_sess);
-	transport_deregister_session(sess->se_sess);
+	target_remove_session(sess->se_sess);
 
 	if (sess->card)
 		fw_card_put(sess->card);
-- 
2.7.2

