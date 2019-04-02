From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 02 Apr 2019 19:58:06 +0000
Subject: [PATCH 02/11] target/core: Rework the SPC-2 reservation handling code
Message-Id: <20190402195815.254796-3-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Instead of tracking the initiator that established an SPC-2
reservation, track the session through which the SPC-2 reservation
has been established. This patch does not change any functionality.

Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/target_core_configfs.c |  5 ++--
 drivers/target/target_core_pr.c       | 33 +++++++++++++++------------
 drivers/target/target_core_pr.h       |  1 +
 drivers/target/target_core_tmr.c      |  2 +-
 include/target/target_core_base.h     |  4 ++--
 include/target/target_core_fabric.h   |  1 +
 6 files changed, 27 insertions(+), 19 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 3fe79875b3ac..db2558fe8d46 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1624,11 +1624,12 @@ static ssize_t target_core_dev_pr_show_spc3_res(struct se_device *dev,
 static ssize_t target_core_dev_pr_show_spc2_res(struct se_device *dev,
 		char *page)
 {
+	struct se_session *sess = dev->reservation_holder;
 	struct se_node_acl *se_nacl;
 	ssize_t len;
 
-	se_nacl = dev->dev_reserved_node_acl;
-	if (se_nacl) {
+	if (sess) {
+		se_nacl = sess->se_node_acl;
 		len = sprintf(page,
 			      "SPC-2 Reservation: %s Initiator: %s\n",
 			      se_nacl->se_tpg->se_tpg_tfo->fabric_name,
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 1597a9ebadca..03767693f580 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -111,10 +111,10 @@ target_scsi2_reservation_check(struct se_cmd *cmd)
 		break;
 	}
 
-	if (!dev->dev_reserved_node_acl || !sess)
+	if (!dev->reservation_holder || !sess)
 		return 0;
 
-	if (dev->dev_reserved_node_acl != sess->se_node_acl)
+	if (dev->reservation_holder->se_node_acl != sess->se_node_acl)
 		return TCM_RESERVATION_CONFLICT;
 
 	if (dev->dev_reservation_flags & DRF_SPC2_RESERVATIONS_WITH_ISID) {
@@ -200,6 +200,16 @@ static int target_check_scsi2_reservation_conflict(struct se_cmd *cmd)
 	return 0;
 }
 
+void target_release_reservation(struct se_device *dev)
+{
+	dev->reservation_holder = NULL;
+	dev->dev_reservation_flags &= ~DRF_SPC2_RESERVATIONS;
+	if (dev->dev_reservation_flags & DRF_SPC2_RESERVATIONS_WITH_ISID) {
+		dev->dev_res_bin_isid = 0;
+		dev->dev_reservation_flags &= ~DRF_SPC2_RESERVATIONS_WITH_ISID;
+	}
+}
+
 sense_reason_t
 target_scsi2_reservation_release(struct se_cmd *cmd)
 {
@@ -217,21 +227,16 @@ target_scsi2_reservation_release(struct se_cmd *cmd)
 		return TCM_RESERVATION_CONFLICT;
 
 	spin_lock(&dev->dev_reservation_lock);
-	if (!dev->dev_reserved_node_acl || !sess)
+	if (!dev->reservation_holder || !sess)
 		goto out_unlock;
 
-	if (dev->dev_reserved_node_acl != sess->se_node_acl)
+	if (dev->reservation_holder->se_node_acl != sess->se_node_acl)
 		goto out_unlock;
 
 	if (dev->dev_res_bin_isid != sess->sess_bin_isid)
 		goto out_unlock;
 
-	dev->dev_reserved_node_acl = NULL;
-	dev->dev_reservation_flags &= ~DRF_SPC2_RESERVATIONS;
-	if (dev->dev_reservation_flags & DRF_SPC2_RESERVATIONS_WITH_ISID) {
-		dev->dev_res_bin_isid = 0;
-		dev->dev_reservation_flags &= ~DRF_SPC2_RESERVATIONS_WITH_ISID;
-	}
+	target_release_reservation(dev);
 	tpg = sess->se_tpg;
 	pr_debug("SCSI-2 Released reservation for %s LUN: %llu ->"
 		" MAPPED LUN: %llu for %s\n",
@@ -275,13 +280,13 @@ target_scsi2_reservation_reserve(struct se_cmd *cmd)
 
 	tpg = sess->se_tpg;
 	spin_lock(&dev->dev_reservation_lock);
-	if (dev->dev_reserved_node_acl &&
-	   (dev->dev_reserved_node_acl != sess->se_node_acl)) {
+	if (dev->reservation_holder &&
+	    dev->reservation_holder->se_node_acl != sess->se_node_acl) {
 		pr_err("SCSI-2 RESERVATION CONFLIFT for %s fabric\n",
 			tpg->se_tpg_tfo->fabric_name);
 		pr_err("Original reserver LUN: %llu %s\n",
 			cmd->se_lun->unpacked_lun,
-			dev->dev_reserved_node_acl->initiatorname);
+			dev->reservation_holder->se_node_acl->initiatorname);
 		pr_err("Current attempt - LUN: %llu -> MAPPED LUN: %llu"
 			" from %s \n", cmd->se_lun->unpacked_lun,
 			cmd->orig_fe_lun,
@@ -290,7 +295,7 @@ target_scsi2_reservation_reserve(struct se_cmd *cmd)
 		goto out_unlock;
 	}
 
-	dev->dev_reserved_node_acl = sess->se_node_acl;
+	dev->reservation_holder = sess;
 	dev->dev_reservation_flags |= DRF_SPC2_RESERVATIONS;
 	if (sess->sess_bin_isid != 0) {
 		dev->dev_res_bin_isid = sess->sess_bin_isid;
diff --git a/drivers/target/target_core_pr.h b/drivers/target/target_core_pr.h
index 198fad5c89dc..a31c93e4e19c 100644
--- a/drivers/target/target_core_pr.h
+++ b/drivers/target/target_core_pr.h
@@ -58,6 +58,7 @@ extern struct kmem_cache *t10_pr_reg_cache;
 
 extern void core_pr_dump_initiator_port(struct t10_pr_registration *,
 			char *, u32);
+extern void target_release_reservation(struct se_device *dev);
 extern sense_reason_t target_scsi2_reservation_release(struct se_cmd *);
 extern sense_reason_t target_scsi2_reservation_reserve(struct se_cmd *);
 extern int core_scsi3_alloc_aptpl_registration(
diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 3a1bb799a9ab..344df737f3a3 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -390,7 +390,7 @@ int core_tmr_lun_reset(
 	if (!preempt_and_abort_list &&
 	     (dev->dev_reservation_flags & DRF_SPC2_RESERVATIONS)) {
 		spin_lock(&dev->dev_reservation_lock);
-		dev->dev_reserved_node_acl = NULL;
+		dev->reservation_holder = NULL;
 		dev->dev_reservation_flags &= ~DRF_SPC2_RESERVATIONS;
 		spin_unlock(&dev->dev_reservation_lock);
 		pr_debug("LUN_RESET: SCSI-2 Released reservation\n");
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 19a5bf4214fc..7c9716fe731e 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -795,8 +795,8 @@ struct se_device {
 	spinlock_t		se_tmr_lock;
 	spinlock_t		qf_cmd_lock;
 	struct semaphore	caw_sem;
-	/* Used for legacy SPC-2 reservationsa */
-	struct se_node_acl	*dev_reserved_node_acl;
+	/* Used for legacy SPC-2 reservations */
+	struct se_session	*reservation_holder;
 	/* Used for ALUA Logical Unit Group membership */
 	struct t10_alua_lu_gp_member *dev_alua_lu_gp_mem;
 	/* Used for SPC-3 Persistent Reservations */
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 8ed90407f062..063f133e47c2 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -142,6 +142,7 @@ void	transport_register_session(struct se_portal_group *,
 		struct se_node_acl *, struct se_session *, void *);
 ssize_t	target_show_dynamic_sessions(struct se_portal_group *, char *);
 void	transport_free_session(struct se_session *);
+void	target_spc2_release(struct se_node_acl *nacl);
 void	target_put_nacl(struct se_node_acl *);
 void	transport_deregister_session_configfs(struct se_session *);
 void	transport_deregister_session(struct se_session *);
-- 
2.21.0.196.g041f5ea1cf98
