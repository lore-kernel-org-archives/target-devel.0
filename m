From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Date: Fri, 03 Apr 2020 14:32:13 +0000
Subject: [PATCH 1/2] target: make transport_flags per device
Message-Id: <20200403143214.18303-2-bstroesser@ts.fujitsu.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

pgr_support and alua_support device attributes show the
inverted value of the transport_flags
 * TRANSPORT_FLAG_PASSTHROUGH_PGR
 * TRANSPORT_FLAG_PASSTHROUGH_ALUA

These attributes are per device, while the flags are per
backend. So we rename the transport_flags in backend/transport
to transport_flags_default and use its value to initialize
the new transport_flags field in the se_device structure.

Now data and attribute both are per se_device.

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
---
 drivers/target/target_core_alua.c      | 10 +++++-----
 drivers/target/target_core_configfs.c  | 14 +++++++-------
 drivers/target/target_core_device.c    |  3 ++-
 drivers/target/target_core_pr.c        |  2 +-
 drivers/target/target_core_pscsi.c     |  6 +++---
 drivers/target/target_core_tpg.c       |  3 +--
 drivers/target/target_core_transport.c |  6 +++---
 drivers/target/target_core_user.c      |  2 +-
 include/target/target_core_backend.h   |  2 +-
 include/target/target_core_base.h      |  1 +
 10 files changed, 25 insertions(+), 24 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 385e4cf9cfa6..6b72afee2f8b 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -677,7 +677,7 @@ target_alua_state_check(struct se_cmd *cmd)
 
 	if (dev->se_hba->hba_flags & HBA_FLAGS_INTERNAL_USE)
 		return 0;
-	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_ALUA)
+	if (dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_ALUA)
 		return 0;
 
 	/*
@@ -1090,7 +1090,7 @@ int core_alua_do_port_transition(
 	struct t10_alua_tg_pt_gp *tg_pt_gp;
 	int primary, valid_states, rc = 0;
 
-	if (l_dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_ALUA)
+	if (l_dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_ALUA)
 		return -ENODEV;
 
 	valid_states = l_tg_pt_gp->tg_pt_gp_alua_supported_states;
@@ -1920,7 +1920,7 @@ ssize_t core_alua_store_tg_pt_gp_info(
 	unsigned char buf[TG_PT_GROUP_NAME_BUF];
 	int move = 0;
 
-	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_ALUA ||
+	if (dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_ALUA ||
 	    (dev->se_hba->hba_flags & HBA_FLAGS_INTERNAL_USE))
 		return -ENODEV;
 
@@ -2177,7 +2177,7 @@ ssize_t core_alua_store_offline_bit(
 	unsigned long tmp;
 	int ret;
 
-	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_ALUA ||
+	if (dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_ALUA ||
 	    (dev->se_hba->hba_flags & HBA_FLAGS_INTERNAL_USE))
 		return -ENODEV;
 
@@ -2263,7 +2263,7 @@ ssize_t core_alua_store_secondary_write_metadata(
 
 int core_setup_alua(struct se_device *dev)
 {
-	if (!(dev->transport->transport_flags &
+	if (!(dev->transport_flags &
 	     TRANSPORT_FLAG_PASSTHROUGH_ALUA) &&
 	    !(dev->se_hba->hba_flags & HBA_FLAGS_INTERNAL_USE)) {
 		struct t10_alua_lu_gp_member *lu_gp_mem;
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index c5a974c5b31d..074614e19f9e 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1099,7 +1099,7 @@ static ssize_t block_size_store(struct config_item *item,
 static ssize_t alua_support_show(struct config_item *item, char *page)
 {
 	struct se_dev_attrib *da = to_attrib(item);
-	u8 flags = da->da_dev->transport->transport_flags;
+	u8 flags = da->da_dev->transport_flags;
 
 	return snprintf(page, PAGE_SIZE, "%d\n",
 			flags & TRANSPORT_FLAG_PASSTHROUGH_ALUA ? 0 : 1);
@@ -1108,7 +1108,7 @@ static ssize_t alua_support_show(struct config_item *item, char *page)
 static ssize_t pgr_support_show(struct config_item *item, char *page)
 {
 	struct se_dev_attrib *da = to_attrib(item);
-	u8 flags = da->da_dev->transport->transport_flags;
+	u8 flags = da->da_dev->transport_flags;
 
 	return snprintf(page, PAGE_SIZE, "%d\n",
 			flags & TRANSPORT_FLAG_PASSTHROUGH_PGR ? 0 : 1);
@@ -1645,7 +1645,7 @@ static ssize_t target_pr_res_holder_show(struct config_item *item, char *page)
 	if (!dev->dev_attrib.emulate_pr)
 		return sprintf(page, "SPC_RESERVATIONS_DISABLED\n");
 
-	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR)
+	if (dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR)
 		return sprintf(page, "Passthrough\n");
 
 	spin_lock(&dev->dev_reservation_lock);
@@ -1787,7 +1787,7 @@ static ssize_t target_pr_res_type_show(struct config_item *item, char *page)
 
 	if (!dev->dev_attrib.emulate_pr)
 		return sprintf(page, "SPC_RESERVATIONS_DISABLED\n");
-	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR)
+	if (dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR)
 		return sprintf(page, "SPC_PASSTHROUGH\n");
 	if (dev->dev_reservation_flags & DRF_SPC2_RESERVATIONS)
 		return sprintf(page, "SPC2_RESERVATIONS\n");
@@ -1801,7 +1801,7 @@ static ssize_t target_pr_res_aptpl_active_show(struct config_item *item,
 	struct se_device *dev = pr_to_dev(item);
 
 	if (!dev->dev_attrib.emulate_pr ||
-	    (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR))
+	    (dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR))
 		return 0;
 
 	return sprintf(page, "APTPL Bit Status: %s\n",
@@ -1814,7 +1814,7 @@ static ssize_t target_pr_res_aptpl_metadata_show(struct config_item *item,
 	struct se_device *dev = pr_to_dev(item);
 
 	if (!dev->dev_attrib.emulate_pr ||
-	    (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR))
+	    (dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR))
 		return 0;
 
 	return sprintf(page, "Ready to process PR APTPL metadata..\n");
@@ -1861,7 +1861,7 @@ static ssize_t target_pr_res_aptpl_metadata_store(struct config_item *item,
 	u8 type = 0;
 
 	if (!dev->dev_attrib.emulate_pr ||
-	    (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR))
+	    (dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR))
 		return count;
 	if (dev->dev_reservation_flags & DRF_SPC2_RESERVATIONS)
 		return count;
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 4cee1138284b..d5800cf22df7 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -732,6 +732,7 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 
 	dev->se_hba = hba;
 	dev->transport = hba->backend->ops;
+	dev->transport_flags = dev->transport->transport_flags_default;
 	dev->prot_length = sizeof(struct t10_pi_tuple);
 	dev->hba_index = hba->hba_index;
 
@@ -1100,7 +1101,7 @@ passthrough_parse_cdb(struct se_cmd *cmd,
 	 * emulate the response, since tcmu does not have the information
 	 * required to process these commands.
 	 */
-	if (!(dev->transport->transport_flags &
+	if (!(dev->transport_flags &
 	      TRANSPORT_FLAG_PASSTHROUGH_PGR)) {
 		if (cdb[0] = PERSISTENT_RESERVE_IN) {
 			cmd->execute_cmd = target_scsi3_emulate_pr_in;
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 5e931690e697..91e41cc55704 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -4086,7 +4086,7 @@ target_check_reservation(struct se_cmd *cmd)
 		return 0;
 	if (!dev->dev_attrib.emulate_pr)
 		return 0;
-	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR)
+	if (dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR)
 		return 0;
 
 	spin_lock(&dev->dev_reservation_lock);
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index c9d92b3e777d..4e37fa9b409d 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -1070,9 +1070,9 @@ static void pscsi_req_done(struct request *req, blk_status_t status)
 static const struct target_backend_ops pscsi_ops = {
 	.name			= "pscsi",
 	.owner			= THIS_MODULE,
-	.transport_flags	= TRANSPORT_FLAG_PASSTHROUGH |
-				  TRANSPORT_FLAG_PASSTHROUGH_ALUA |
-				  TRANSPORT_FLAG_PASSTHROUGH_PGR,
+	.transport_flags_default = TRANSPORT_FLAG_PASSTHROUGH |
+				   TRANSPORT_FLAG_PASSTHROUGH_ALUA |
+				   TRANSPORT_FLAG_PASSTHROUGH_PGR,
 	.attach_hba		= pscsi_attach_hba,
 	.detach_hba		= pscsi_detach_hba,
 	.pmode_enable_hba	= pscsi_pmode_enable_hba,
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index d24e0a3ba3ff..62aa5fa63ac0 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -582,8 +582,7 @@ int core_tpg_add_lun(
 	if (ret)
 		goto out_kill_ref;
 
-	if (!(dev->transport->transport_flags &
-	     TRANSPORT_FLAG_PASSTHROUGH_ALUA) &&
+	if (!(dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_ALUA) &&
 	    !(dev->se_hba->hba_flags & HBA_FLAGS_INTERNAL_USE))
 		target_attach_tg_pt_gp(lun, dev->t10_alua.default_tg_pt_gp);
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 9681d4ba02d7..5d766a220c1e 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1379,7 +1379,7 @@ transport_check_alloc_task_attr(struct se_cmd *cmd)
 	 * Check if SAM Task Attribute emulation is enabled for this
 	 * struct se_device storage object
 	 */
-	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH)
+	if (dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH)
 		return 0;
 
 	if (cmd->sam_task_attr = TCM_ACA_TAG) {
@@ -1992,7 +1992,7 @@ static bool target_handle_task_attr(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
 
-	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH)
+	if (dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH)
 		return false;
 
 	cmd->se_cmd_flags |= SCF_TASK_ATTR_SET;
@@ -2106,7 +2106,7 @@ static void transport_complete_task_attr(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
 
-	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH)
+	if (dev->transport_flags & TRANSPORT_FLAG_PASSTHROUGH)
 		return;
 
 	if (!(cmd->se_cmd_flags & SCF_TASK_ATTR_SET))
diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 0b9dfa6b17bc..8251f0c734cc 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -2616,7 +2616,7 @@ static struct configfs_attribute *tcmu_action_attrs[] = {
 static struct target_backend_ops tcmu_ops = {
 	.name			= "user",
 	.owner			= THIS_MODULE,
-	.transport_flags	= TRANSPORT_FLAG_PASSTHROUGH,
+	.transport_flags_default = TRANSPORT_FLAG_PASSTHROUGH,
 	.attach_hba		= tcmu_attach_hba,
 	.detach_hba		= tcmu_detach_hba,
 	.alloc_device		= tcmu_alloc_device,
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 1b752d8ea529..9d1c16d24edf 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -23,7 +23,7 @@ struct target_backend_ops {
 	char inquiry_rev[4];
 	struct module *owner;
 
-	u8 transport_flags;
+	u8 transport_flags_default;
 
 	int (*attach_hba)(struct se_hba *, u32);
 	void (*detach_hba)(struct se_hba *);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 6d4a694f6ea7..18c3f277b770 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -772,6 +772,7 @@ struct se_device {
 #define DF_USING_UDEV_PATH			0x00000008
 #define DF_USING_ALIAS				0x00000010
 #define DF_READ_ONLY				0x00000020
+	u8			transport_flags;
 	/* Physical device queue depth */
 	u32			queue_depth;
 	/* Used for SPC-2 reservations enforce of ISIDs */
-- 
2.12.3
