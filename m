From: Roman Bolshakov <r.bolshakov@yadro.com>
Date: Wed, 29 Apr 2020 09:44:34 +0000
Subject: [RFC PATCH 01/11] scsi: target/core: Add a way to hide a port group
Message-Id: <20200429094443.43937-2-r.bolshakov@yadro.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200429094443.43937-1-r.bolshakov@yadro.com>
In-Reply-To: <20200429094443.43937-1-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org, Mike Christie <mchristi@redhat.com>, Bart Van Assche <bvanassche@acm.org>, David Disseldorp <ddiss@suse.de>
Cc: linux-scsi@vger.kernel.org, linux@yadro.com, Roman Bolshakov <r.bolshakov@yadro.com>

Default target port group is always returned in the list of port groups,
even if the behaviour is unwanted, i.e. it has no members and
non-default port groups are primary port groups.

A new port group attribute - "hidden" can be used to hide empty port
groups with no ports in REPORT TARGET PORT GROUPS, including default
target port group:

  echo 1 > $DEVICE/alua/default_tg_pt_gp/hidden

Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/target/target_core_alua.c     |  9 +++++++++
 drivers/target/target_core_configfs.c | 29 +++++++++++++++++++++++++++
 include/target/target_core_base.h     |  1 +
 3 files changed, 39 insertions(+)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 385e4cf9cfa6..b98a5b5fce49 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -164,6 +164,8 @@ target_emulate_report_target_port_groups(struct se_cmd *cmd)
 	spin_lock(&dev->t10_alua.tg_pt_gps_lock);
 	list_for_each_entry(tg_pt_gp, &dev->t10_alua.tg_pt_gps_list,
 			tg_pt_gp_list) {
+		if (tg_pt_gp->tg_pt_gp_hidden && !tg_pt_gp->tg_pt_gp_members)
+			continue;
 		/*
 		 * Check if the Target port group and Target port descriptor list
 		 * based on tg_pt_gp_members count will fit into the response payload.
@@ -308,6 +310,13 @@ target_emulate_set_target_port_groups(struct se_cmd *cmd)
 		rc = TCM_UNSUPPORTED_SCSI_OPCODE;
 		goto out;
 	}
+	if (l_tg_pt_gp->tg_pt_gp_hidden && !tg_pt_gp->tg_pt_gp_members) {
+		spin_unlock(&l_lun->lun_tg_pt_gp_lock);
+		pr_err("Unable to change state for hidden port group"
+		       " with no members\n");
+		rc = TCM_INVALID_CDB_FIELD;
+		goto out;
+	}
 	valid_states = l_tg_pt_gp->tg_pt_gp_alua_supported_states;
 	spin_unlock(&l_lun->lun_tg_pt_gp_lock);
 
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index ff82b21fdcce..42390ce9d4db 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2908,6 +2908,33 @@ static ssize_t target_tg_pt_gp_preferred_store(struct config_item *item,
 	return core_alua_store_preferred_bit(to_tg_pt_gp(item), page, count);
 }
 
+static ssize_t target_tg_pt_gp_hidden_show(struct config_item *item,
+					   char *page)
+{
+	return sprintf(page, "%d\n", to_tg_pt_gp(item)->tg_pt_gp_hidden);
+}
+
+static ssize_t target_tg_pt_gp_hidden_store(struct config_item *item,
+					    const char *page, size_t count)
+{
+	struct t10_alua_tg_pt_gp *tg_pt_gp = to_tg_pt_gp(item);
+	int tmp, ret;
+
+	ret = kstrtoint(page, 0, &tmp);
+	if (ret < 0) {
+		pr_err("Unable to extract hidden flag: %d\n", ret);
+		return ret;
+	}
+
+	if (tmp != 0 && tmp != 1) {
+		pr_err("Illegal value for hidden flag: %d\n", tmp);
+		return -EINVAL;
+	}
+	tg_pt_gp->tg_pt_gp_hidden = tmp;
+
+	return count;
+}
+
 static ssize_t target_tg_pt_gp_tg_pt_gp_id_show(struct config_item *item,
 		char *page)
 {
@@ -2996,6 +3023,7 @@ CONFIGFS_ATTR(target_tg_pt_gp_, alua_support_standby);
 CONFIGFS_ATTR(target_tg_pt_gp_, alua_support_active_optimized);
 CONFIGFS_ATTR(target_tg_pt_gp_, alua_support_active_nonoptimized);
 CONFIGFS_ATTR(target_tg_pt_gp_, alua_write_metadata);
+CONFIGFS_ATTR(target_tg_pt_gp_, hidden);
 CONFIGFS_ATTR(target_tg_pt_gp_, nonop_delay_msecs);
 CONFIGFS_ATTR(target_tg_pt_gp_, trans_delay_msecs);
 CONFIGFS_ATTR(target_tg_pt_gp_, implicit_trans_secs);
@@ -3019,6 +3047,7 @@ static struct configfs_attribute *target_core_alua_tg_pt_gp_attrs[] = {
 	&target_tg_pt_gp_attr_trans_delay_msecs,
 	&target_tg_pt_gp_attr_implicit_trans_secs,
 	&target_tg_pt_gp_attr_preferred,
+	&target_tg_pt_gp_attr_hidden,
 	&target_tg_pt_gp_attr_tg_pt_gp_id,
 	&target_tg_pt_gp_attr_members,
 	NULL,
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 6d4a694f6ea7..922b3086e408 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -292,6 +292,7 @@ struct t10_alua_tg_pt_gp {
 	int	tg_pt_gp_trans_delay_msecs;
 	int	tg_pt_gp_implicit_trans_secs;
 	int	tg_pt_gp_pref;
+	int	tg_pt_gp_hidden;
 	int	tg_pt_gp_write_metadata;
 	u32	tg_pt_gp_members;
 	int	tg_pt_gp_alua_access_state;
-- 
2.26.1
