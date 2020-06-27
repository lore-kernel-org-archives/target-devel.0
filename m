From: Mike Christie <michael.christie@oracle.com>
Date: Sat, 27 Jun 2020 04:35:06 +0000
Subject: [RFC PATCH 07/10] target: add return value to close_session
Message-Id: <1593232509-13720-8-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1593232509-13720-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1593232509-13720-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hare@suse.de, bvanassche@acm.org, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

This adds a return value to close_session. In this patch only fcoe
returns non-zero and we don't do anything. In the next patches we will
be able to remove the session via configfs through the common fabric
configfs interface and the fabric specific nexus one, so we will need
to handle the case where the interfaces both try to delete the session.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c        | 3 ++-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c           | 3 ++-
 drivers/target/iscsi/iscsi_target_configfs.c | 5 +++--
 drivers/target/tcm_fc/tcm_fc.h               | 2 +-
 drivers/target/tcm_fc/tfc_sess.c             | 5 +++--
 include/target/target_core_fabric.h          | 2 +-
 6 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index de564d1..f9a5bd8 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -3337,11 +3337,12 @@ static void srpt_release_cmd(struct se_cmd *se_cmd)
  * with a node ACL when the user invokes
  * rmdir /sys/kernel/config/target/$driver/$port/$tpg/acls/$i_port_id
  */
-static void srpt_close_session(struct se_session *se_sess)
+static int srpt_close_session(struct se_session *se_sess)
 {
 	struct srpt_rdma_ch *ch = se_sess->fabric_sess_ptr;
 
 	srpt_disconnect_ch_sync(ch);
+	return 0;
 }
 
 static void srpt_set_default_node_attrs(struct se_node_acl *nacl)
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index fa861ba..94a26ba 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -360,7 +360,7 @@ static void tcm_qla2xxx_put_sess(struct fc_port *sess)
 	kref_put(&sess->sess_kref, tcm_qla2xxx_release_session);
 }
 
-static void tcm_qla2xxx_close_session(struct se_session *se_sess)
+static int tcm_qla2xxx_close_session(struct se_session *se_sess)
 {
 	struct fc_port *sess = se_sess->fabric_sess_ptr;
 	struct scsi_qla_host *vha;
@@ -375,6 +375,7 @@ static void tcm_qla2xxx_close_session(struct se_session *se_sess)
 
 	sess->explicit_logout = 1;
 	tcm_qla2xxx_put_sess(sess);
+	return 0;
 }
 
 static int tcm_qla2xxx_write_pending(struct se_cmd *se_cmd)
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 3e843b0..aa7c4a6 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1460,7 +1460,7 @@ static int lio_tpg_check_prot_fabric_only(
  * This function calls iscsit_inc_session_usage_count() on the
  * struct iscsi_session in question.
  */
-static void lio_tpg_close_session(struct se_session *se_sess)
+static int lio_tpg_close_session(struct se_session *se_sess)
 {
 	struct iscsi_session *sess = se_sess->fabric_sess_ptr;
 	struct se_portal_group *se_tpg = &sess->tpg->tpg_se_tpg;
@@ -1473,7 +1473,7 @@ static void lio_tpg_close_session(struct se_session *se_sess)
 	    (sess->time2retain_timer_flags & ISCSI_TF_EXPIRED)) {
 		spin_unlock(&sess->conn_lock);
 		spin_unlock_bh(&se_tpg->session_lock);
-		return;
+		return 0;
 	}
 	iscsit_inc_session_usage_count(sess);
 	atomic_set(&sess->session_reinstatement, 1);
@@ -1486,6 +1486,7 @@ static void lio_tpg_close_session(struct se_session *se_sess)
 
 	iscsit_stop_session(sess, 1, 1);
 	iscsit_dec_session_usage_count(sess);
+	return 0;
 }
 
 static void lio_free_session(struct se_session *se_sess)
diff --git a/drivers/target/tcm_fc/tcm_fc.h b/drivers/target/tcm_fc/tcm_fc.h
index 2ff716d..4280171 100644
--- a/drivers/target/tcm_fc/tcm_fc.h
+++ b/drivers/target/tcm_fc/tcm_fc.h
@@ -130,7 +130,7 @@ struct ft_cmd {
  * Session ops.
  */
 void ft_sess_put(struct ft_sess *);
-void ft_sess_close(struct se_session *);
+int ft_sess_close(struct se_session *);
 u32 ft_sess_get_index(struct se_session *);
 u32 ft_sess_get_port_name(struct se_session *, unsigned char *, u32);
 
diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index 6df570a..12c54e6 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -306,7 +306,7 @@ static void ft_sess_delete_all(struct ft_tport *tport)
  * Remove session and send PRLO.
  * This is called when the ACL is being deleted or queue depth is changing.
  */
-void ft_sess_close(struct se_session *se_sess)
+int ft_sess_close(struct se_session *se_sess)
 {
 	struct ft_sess *sess = se_sess->fabric_sess_ptr;
 	u32 port_id;
@@ -315,7 +315,7 @@ void ft_sess_close(struct se_session *se_sess)
 	port_id = sess->port_id;
 	if (port_id = -1) {
 		mutex_unlock(&ft_lport_lock);
-		return;
+		return -ENODEV;
 	}
 	TFC_SESS_DBG(sess->tport->lport, "port_id %x close session\n", port_id);
 	ft_sess_unhash(sess);
@@ -323,6 +323,7 @@ void ft_sess_close(struct se_session *se_sess)
 	ft_close_sess(sess);
 	/* XXX Send LOGO or PRLO */
 	synchronize_rcu();		/* let transport deregister happen */
+	return 0;
 }
 
 u32 ft_sess_get_port_name(struct se_session *se_sess,
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 838c2f0..e200faa 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -73,7 +73,7 @@ struct target_core_fabric_ops {
 	 * the callout will be called if that function is successfully run.
 	 */
 	void (*free_session)(struct se_session *);
-	void (*close_session)(struct se_session *);
+	int (*close_session)(struct se_session *);
 	/*
 	 * Used only for SCSI fabrics that contain multi-value TransportIDs
 	 * (like iSCSI).  All other SCSI fabrics should set this to NULL.
-- 
1.8.3.1
