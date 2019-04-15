From: David Disseldorp <ddiss@suse.de>
Date: Mon, 15 Apr 2019 13:41:18 +0000
Subject: [PATCH] target: separate read/write type cmd metrics
Message-Id: <20190415134118.4831-1-ddiss@suse.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

From: Zhang Zhuoyu <zhangzhuoyu@cmss.chinamobile.com>

Separate data-directional cmds in order to distinguish between LUN
read/write IOPS.

Signed-off-by: Zhang Zhuoyu <zhangzhuoyu@cmss.chinamobile.com>
[ddiss@suse.de: keep in_cmds metric]
Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 drivers/target/target_core_stat.c      | 41 +++++++++++++++++++++++++++++++++-
 drivers/target/target_core_transport.c | 12 +++++++++-
 include/target/target_core_base.h      |  4 +++-
 3 files changed, 54 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index 8d9ceedfd455..11ced0ee095c 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -625,11 +625,46 @@ static ssize_t target_stat_tgt_port_in_cmds_show(struct config_item *item,
 	struct se_device *dev;
 	ssize_t ret = -ENODEV;
 
+	rcu_read_lock();
+	dev = rcu_dereference(lun->lun_se_dev);
+	if (dev) {
+		unsigned long incmds = atomic_long_read(&lun->lun_stats.read_cmds)
+				+ atomic_long_read(&lun->lun_stats.write_cmds)
+				+ atomic_long_read(&lun->lun_stats.nodata_cmds);
+		ret = snprintf(page, PAGE_SIZE, "%lu\n", incmds);
+	}
+	rcu_read_unlock();
+	return ret;
+}
+
+static ssize_t target_stat_tgt_port_read_cmds_show(struct config_item *item,
+		char *page)
+{
+	struct se_lun *lun = to_stat_tgt_port(item);
+	struct se_device *dev;
+	ssize_t ret = -ENODEV;
+
+	rcu_read_lock();
+	dev = rcu_dereference(lun->lun_se_dev);
+	if (dev)
+		ret = snprintf(page, PAGE_SIZE, "%lu\n",
+			       atomic_long_read(&lun->lun_stats.read_cmds));
+	rcu_read_unlock();
+	return ret;
+}
+
+static ssize_t target_stat_tgt_port_write_cmds_show(struct config_item *item,
+		char *page)
+{
+	struct se_lun *lun = to_stat_tgt_port(item);
+	struct se_device *dev;
+	ssize_t ret = -ENODEV;
+
 	rcu_read_lock();
 	dev = rcu_dereference(lun->lun_se_dev);
 	if (dev)
 		ret = snprintf(page, PAGE_SIZE, "%lu\n",
-			       atomic_long_read(&lun->lun_stats.cmd_pdus));
+			       atomic_long_read(&lun->lun_stats.write_cmds));
 	rcu_read_unlock();
 	return ret;
 }
@@ -689,6 +724,8 @@ CONFIGFS_ATTR_RO(target_stat_tgt_port_, indx);
 CONFIGFS_ATTR_RO(target_stat_tgt_port_, name);
 CONFIGFS_ATTR_RO(target_stat_tgt_port_, port_index);
 CONFIGFS_ATTR_RO(target_stat_tgt_port_, in_cmds);
+CONFIGFS_ATTR_RO(target_stat_tgt_port_, write_cmds);
+CONFIGFS_ATTR_RO(target_stat_tgt_port_, read_cmds);
 CONFIGFS_ATTR_RO(target_stat_tgt_port_, write_mbytes);
 CONFIGFS_ATTR_RO(target_stat_tgt_port_, read_mbytes);
 CONFIGFS_ATTR_RO(target_stat_tgt_port_, hs_in_cmds);
@@ -700,6 +737,8 @@ static struct configfs_attribute *target_stat_scsi_tgt_port_attrs[] = {
 	&target_stat_tgt_port_attr_name,
 	&target_stat_tgt_port_attr_port_index,
 	&target_stat_tgt_port_attr_in_cmds,
+	&target_stat_tgt_port_attr_write_cmds,
+	&target_stat_tgt_port_attr_read_cmds,
 	&target_stat_tgt_port_attr_write_mbytes,
 	&target_stat_tgt_port_attr_read_mbytes,
 	&target_stat_tgt_port_attr_hs_in_cmds,
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index e3f7e21e6614..cb55fa4465f1 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1430,7 +1430,17 @@ target_setup_cmd_from_cdb(struct se_cmd *cmd, unsigned char *cdb)
 		return ret;
 
 	cmd->se_cmd_flags |= SCF_SUPPORTED_SAM_OPCODE;
-	atomic_long_inc(&cmd->se_lun->lun_stats.cmd_pdus);
+	switch (cmd->data_direction) {
+	case DMA_FROM_DEVICE:
+		atomic_long_inc(&cmd->se_lun->lun_stats.read_cmds);
+		break;
+	case DMA_TO_DEVICE:
+		atomic_long_inc(&cmd->se_lun->lun_stats.write_cmds);
+		break;
+	default:
+		atomic_long_inc(&cmd->se_lun->lun_stats.nodata_cmds);
+		break;
+	}
 	return 0;
 }
 EXPORT_SYMBOL(target_setup_cmd_from_cdb);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 19a5bf4214fc..0c25291956e8 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -707,7 +707,9 @@ struct se_port_stat_grps {
 };
 
 struct scsi_port_stats {
-	atomic_long_t	cmd_pdus;
+	atomic_long_t	read_cmds;
+	atomic_long_t	write_cmds;
+	atomic_long_t	nodata_cmds;
 	atomic_long_t	tx_data_octets;
 	atomic_long_t	rx_data_octets;
 };
-- 
2.16.4
