From: Bart Van Assche <bart.vanassche@wdc.com>
Date: Wed, 13 Dec 2017 23:50:20 +0000
Subject: [PATCH 02/11] target: Use config_item_name() instead of open-coding it
Message-Id: <20171213235029.581-3-bart.vanassche@wdc.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Some target code uses config_item_name() while other code accesses
.ci_name directly. Make the target code consistent by switching to
config_item_name().

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_configfs.c | 4 ++--
 drivers/target/target_core_sbc.c      | 7 ++++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 72b1cd1bf9d9..c6c16a41c035 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -261,8 +261,8 @@ static struct config_group *target_core_register_fabric(
 			&tf->tf_discovery_cit);
 	configfs_add_default_group(&tf->tf_disc_group, &tf->tf_group);
 
-	pr_debug("Target_Core_ConfigFS: REGISTER -> Allocated Fabric:"
-			" %s\n", tf->tf_group.cg_item.ci_name);
+	pr_debug("Target_Core_ConfigFS: REGISTER -> Allocated Fabric: %s\n",
+		 config_item_name(&tf->tf_group.cg_item));
 	return &tf->tf_group;
 }
 
diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 750a04ed0e93..5876c0ab95c8 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -978,9 +978,10 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 	}
 	case COMPARE_AND_WRITE:
 		if (!dev->dev_attrib.emulate_caw) {
-			pr_err_ratelimited("se_device %s/%s (vpd_unit_serial %s) reject"
-				" COMPARE_AND_WRITE\n", dev->se_hba->backend->ops->name,
-				dev->dev_group.cg_item.ci_name, dev->t10_wwn.unit_serial);
+			pr_err_ratelimited("se_device %s/%s (vpd_unit_serial %s) reject COMPARE_AND_WRITE\n",
+					   dev->se_hba->backend->ops->name,
+					   config_item_name(&dev->dev_group.cg_item),
+					   dev->t10_wwn.unit_serial);
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
 		}
 		sectors = cdb[13];
-- 
2.15.1

