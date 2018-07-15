From: Mike Christie <mchristi@redhat.com>
Date: Sun, 15 Jul 2018 23:16:27 +0000
Subject: [PATCH 11/15] target: export initiator port values for all sessions
Message-Id: <1531696591-8558-12-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Export the initiator port info in configfs

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_fabric_configfs.c | 48 ++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 497fa01..2deda28 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -897,6 +897,53 @@ static void target_fabric_drop_tpg(
 	config_item_put(item);
 }
 
+static ssize_t target_fabric_session_initiator_port_show(
+	struct config_item *item, char *page)
+{
+	struct se_session *se_sess = container_of(to_config_group(item),
+						  struct se_session, group);
+	ssize_t len;
+	int isid_len = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&se_sess->configfs_lock, flags);
+	if (!se_sess->se_tpg) {
+		len = -ENOTCONN;
+		goto unlock;
+	}
+
+	if (se_sess->se_tpg->se_tpg_tfo->sess_get_initiator_sid)
+		isid_len = 15;
+
+	if (strlen(se_sess->se_node_acl->initiatorname) + isid_len + 1 >
+	    PAGE_SIZE) {
+		len = -EINVAL;
+		goto unlock;
+	}
+
+	if (se_sess->se_tpg->se_tpg_tfo->sess_get_initiator_sid) {
+		len = snprintf(page, PAGE_SIZE, "%s 0x%6phN\n",
+			       se_sess->se_node_acl->initiatorname,
+			       &se_sess->sess_bin_isid);
+	} else {
+		len = snprintf(page, PAGE_SIZE, "%s\n",
+			       se_sess->se_node_acl->initiatorname);
+	}
+	len += 1; /* Include NULL terminator */
+
+unlock:
+	spin_unlock_irqrestore(&se_sess->configfs_lock, flags);
+
+	return len;
+}
+
+CONFIGFS_ATTR_RO(target_fabric_session_, initiator_port);
+
+static struct configfs_attribute *target_fabric_session_attrs[] = {
+	&target_fabric_session_attr_initiator_port,
+	NULL,
+};
+
 static void target_fabric_session_release(struct config_item *item)
 {
 	struct se_session *se_sess = container_of(to_config_group(item),
@@ -918,6 +965,7 @@ int target_fabric_init_session(struct se_session *se_sess)
 
 	se_sess->cit.ct_owner = THIS_MODULE;
 	se_sess->cit.ct_item_ops = &target_session_item_ops;
+	se_sess->cit.ct_attrs = target_fabric_session_attrs;
 	config_group_init_type_name(&se_sess->group, name, &se_sess->cit);
 	kfree(name);
 	return 0;
-- 
2.7.2

