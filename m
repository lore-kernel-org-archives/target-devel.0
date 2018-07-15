From: Mike Christie <mchristi@redhat.com>
Date: Sun, 15 Jul 2018 23:16:24 +0000
Subject: [PATCH 08/15] target: add session removal function
Message-Id: <1531696591-8558-9-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This adds a function to remove a session which should be used by
drivers that use target_setup_session.

All the drivers but iscsi and tcm_fc were doing calling
transport_deregister_session_configfs and then immediately calling
transport_deregister_session or just calling
transport_deregisteir_session.

For tcm_fc, it should be ok to call
transport_deregister_session_configfs later like in the new
remove function because the transport_deregister_session_configfs call
was not affecting the target_sess_cmd_list_set_waiting/
target_wait_for_sess_cmds calls and nothing else was being
torn down between that time.

For drivers that only called transport_deregister_session
the new remove function that calls transport_deregister_session_configfs
should be ok, because those drivers did not access se_nacl->nacl_sess
or sess_acl_list so they will see no difference.

iscsi does not use the setup/remove session functions and we
let it to continue to go wild with it calling the lower level
functions directly.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c    | 3 +--
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 3 +--
 drivers/scsi/qla2xxx/tcm_qla2xxx.c       | 3 +--
 drivers/target/loopback/tcm_loop.c       | 2 +-
 drivers/target/sbp/sbp_target.c          | 3 +--
 drivers/target/target_core_transport.c   | 7 +++++++
 drivers/target/tcm_fc/tfc_sess.c         | 3 +--
 drivers/usb/gadget/function/f_tcm.c      | 2 +-
 drivers/vhost/scsi.c                     | 2 +-
 drivers/xen/xen-scsiback.c               | 2 +-
 include/target/target_core_fabric.h      | 1 +
 11 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 496ee6b..ba53245c 100644
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
index 7e2d2c0..99df92e 100644
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
index c0e1921..e25c15d 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1456,8 +1456,7 @@ static void tcm_qla2xxx_free_session(struct fc_port *sess)
 	}
 	target_wait_for_sess_cmds(se_sess);
 
-	transport_deregister_session_configfs(sess->se_sess);
-	transport_deregister_session(sess->se_sess);
+	target_remove_session(se_sess);
 }
 
 static int tcm_qla2xxx_session_cb(struct se_portal_group *se_tpg,
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 3bb2236..f3398db 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -800,7 +800,7 @@ static int tcm_loop_drop_nexus(
 	/*
 	 * Release the SCSI I_T Nexus to the emulated Target Port
 	 */
-	transport_deregister_session(tl_nexus->se_sess);
+	target_remove_session(se_sess);
 	tpg->tl_nexus = NULL;
 	kfree(tl_nexus);
 	return 0;
diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index 14244bf..2087d5f 100644
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
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 77c5954..57279fe 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -640,6 +640,13 @@ void transport_deregister_session(struct se_session *se_sess)
 }
 EXPORT_SYMBOL(transport_deregister_session);
 
+void target_remove_session(struct se_session *se_sess)
+{
+	transport_deregister_session_configfs(se_sess);
+	transport_deregister_session(se_sess);
+}
+EXPORT_SYMBOL(target_remove_session);
+
 static void target_remove_from_state_list(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index b8b1600..9fbbd5a 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -287,7 +287,6 @@ static struct ft_sess *ft_sess_delete(struct ft_tport *tport, u32 port_id)
 
 static void ft_close_sess(struct ft_sess *sess)
 {
-	transport_deregister_session_configfs(sess->se_sess);
 	target_sess_cmd_list_set_waiting(sess->se_sess);
 	target_wait_for_sess_cmds(sess->se_sess);
 	ft_sess_put(sess);
@@ -441,7 +440,7 @@ static void ft_sess_free(struct kref *kref)
 {
 	struct ft_sess *sess = container_of(kref, struct ft_sess, kref);
 
-	transport_deregister_session(sess->se_sess);
+	target_remove_session(sess->se_sess);
 	kfree_rcu(sess, rcu);
 }
 
diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index ac2d509..e35668f 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1633,7 +1633,7 @@ static int tcm_usbg_drop_nexus(struct usbg_tpg *tpg)
 	/*
 	 * Release the SCSI I_T Nexus to the emulated vHost Target Port
 	 */
-	transport_deregister_session(tv_nexus->tvn_se_sess);
+	target_remove_session(se_sess);
 	tpg->tpg_nexus = NULL;
 
 	kfree(tv_nexus);
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 8da06c9..d41dde0 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1792,7 +1792,7 @@ static int vhost_scsi_drop_nexus(struct vhost_scsi_tpg *tpg)
 	/*
 	 * Release the SCSI I_T Nexus to the emulated vhost Target Port
 	 */
-	transport_deregister_session(tv_nexus->tvn_se_sess);
+	target_remove_session(se_sess);
 	tpg->tpg_nexus = NULL;
 	mutex_unlock(&tpg->tv_tpg_mutex);
 
diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index e8b11d2..6780e40 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -1571,7 +1571,7 @@ static int scsiback_drop_nexus(struct scsiback_tpg *tpg)
 	/*
 	 * Release the SCSI I_T Nexus to the emulated xen-pvscsi Target Port
 	 */
-	transport_deregister_session(tv_nexus->tvn_se_sess);
+	target_remove_session(se_sess);
 	tpg->tpg_nexus = NULL;
 	mutex_unlock(&tpg->tv_tpg_mutex);
 
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index aad2fd1..aa69b13 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -113,6 +113,7 @@ struct se_session *target_setup_session(struct se_portal_group *,
 		const char *, void *,
 		int (*callback)(struct se_portal_group *,
 				struct se_session *, void *));
+void target_remove_session(struct se_session *);
 
 void transport_init_session(struct se_session *);
 struct se_session *transport_alloc_session(enum target_prot_op);
-- 
2.7.2

