From: Mike Christie <michael.christie@oracle.com>
Date: Sun, 07 Jun 2020 20:36:03 +0000
Subject: [PATCH 16/17] iscsi target: export session state and alias in sysfs
Message-Id: <1591562164-9766-17-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: bvanassche@acm.org, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

Export the session state and alias in sysfs.

Note:
It does not export the per connection state. In the future we can
have the iscsi target add/rm an attribute group directly for each
connection when we login and logout/drop a connection. Since those
are dynamic and can change while the session exists, we don't need
them at device addition so it can be done directly from the module.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/iscsi/iscsi_target_configfs.c | 97 ++++++++++++++++++++++------
 1 file changed, 76 insertions(+), 21 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index ba608fa..64de2ec 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -28,6 +28,28 @@
 #include "iscsi_target.h"
 #include <target/iscsi/iscsi_target_stat.h>
 
+static const struct {
+	enum target_sess_state_table	value;
+	char				*name;
+} session_states[] = {
+	{ TARG_SESS_STATE_FREE,		"TARG_SESS_FREE" },
+	{ TARG_SESS_STATE_ACTIVE,	"TARG_SESS_STATE_ACTIVE" },
+	{ TARG_SESS_STATE_LOGGED_IN,	"TARG_SESS_STATE_LOGGED_IN" },
+	{ TARG_SESS_STATE_FAILED,	"TARG_SESS_STATE_FAILED" },
+	{ TARG_SESS_STATE_IN_CONTINUE,	"TARG_SESS_STATE_IN_CONTINUE" },
+};
+
+static const char *session_state_name(enum target_sess_state_table state)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(session_states); i++) {
+		if (session_states[i].value = state)
+			return session_states[i].name;
+	}
+
+	return NULL;
+}
 
 /* Start items for lio_target_portal_cit */
 
@@ -502,6 +524,7 @@ static ssize_t lio_target_nacl_info_show(struct config_item *item, char *page)
 	struct iscsi_session *sess;
 	struct iscsi_conn *conn;
 	struct se_session *se_sess;
+	const char *state_name;
 	ssize_t rb = 0;
 	u32 max_cmd_sn;
 
@@ -525,27 +548,12 @@ static ssize_t lio_target_nacl_info_show(struct config_item *item, char *page)
 				(sess->sess_ops->SessionType) ?
 				"Discovery" : "Normal");
 		rb += sprintf(page+rb, "Session State: ");
-		switch (sess->session_state) {
-		case TARG_SESS_STATE_FREE:
-			rb += sprintf(page+rb, "TARG_SESS_FREE\n");
-			break;
-		case TARG_SESS_STATE_ACTIVE:
-			rb += sprintf(page+rb, "TARG_SESS_STATE_ACTIVE\n");
-			break;
-		case TARG_SESS_STATE_LOGGED_IN:
-			rb += sprintf(page+rb, "TARG_SESS_STATE_LOGGED_IN\n");
-			break;
-		case TARG_SESS_STATE_FAILED:
-			rb += sprintf(page+rb, "TARG_SESS_STATE_FAILED\n");
-			break;
-		case TARG_SESS_STATE_IN_CONTINUE:
-			rb += sprintf(page+rb, "TARG_SESS_STATE_IN_CONTINUE\n");
-			break;
-		default:
-			rb += sprintf(page+rb, "ERROR: Unknown Session"
-					" State!\n");
-			break;
-		}
+
+		state_name = session_state_name(sess->session_state);
+		if (state_name)
+			rb += sprintf(page+rb, "%s\n", state_name);
+		else
+			rb += sprintf(page+rb, "ERROR: Unknown Session State!\n");
 
 		rb += sprintf(page+rb, "---------------------[iSCSI Session"
 				" Values]-----------------------\n");
@@ -1333,6 +1341,51 @@ static ssize_t iscsi_disc_enforce_discovery_auth_store(struct config_item *item,
 
 /* End lio_target_discovery_auth_cit */
 
+/* session sysfs */
+static ssize_t
+lio_show_sess_state(struct device *dev, struct device_attribute *attr,
+		    char *buf)
+{
+	struct se_session *se_sess = container_of(dev, struct se_session, dev);
+	struct iscsi_session *sess = se_sess->fabric_sess_ptr;
+	const char *state_name;
+
+	state_name = session_state_name(sess->session_state);
+	if (!state_name)
+		return -EINVAL;
+
+	return snprintf(buf, PAGE_SIZE, "%s", state_name);
+}
+
+static ssize_t
+lio_show_initiator_alias(struct device *dev, struct device_attribute *attr,
+			 char *buf)
+{
+	struct se_session *se_sess = container_of(dev, struct se_session, dev);
+	struct iscsi_session *sess = se_sess->fabric_sess_ptr;
+
+	return snprintf(buf, PAGE_SIZE, "%s", sess->sess_ops->InitiatorAlias);
+}
+
+static DEVICE_ATTR(state, S_IRUGO, lio_show_sess_state, NULL);
+static DEVICE_ATTR(initiator_alias, S_IRUGO, lio_show_initiator_alias, NULL);
+
+static struct attribute *lio_sess_attrs[] = {
+	&dev_attr_state.attr,
+	&dev_attr_initiator_alias.attr,
+	NULL,
+};
+
+static struct attribute_group lio_sess_attr_group = {
+	.name = "iscsi_session",
+	.attrs = lio_sess_attrs,
+};
+
+static const struct attribute_group *lio_sess_attr_groups[] = {
+	&lio_sess_attr_group,
+	NULL,
+};
+
 /* Start functions for target_core_fabric_ops */
 
 static int iscsi_get_cmd_state(struct se_cmd *se_cmd)
@@ -1556,6 +1609,8 @@ static void lio_release_cmd(struct se_cmd *se_cmd)
 	.fabric_drop_np			= lio_target_call_delnpfromtpg,
 	.fabric_init_nodeacl		= lio_target_init_nodeacl,
 
+	.session_attr_groups		= lio_sess_attr_groups,
+
 	.tfc_discovery_attrs		= lio_target_discovery_auth_attrs,
 	.tfc_wwn_attrs			= lio_target_wwn_attrs,
 	.tfc_tpg_base_attrs		= lio_target_tpg_attrs,
-- 
1.8.3.1
