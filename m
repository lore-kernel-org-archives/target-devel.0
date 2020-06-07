From: Mike Christie <michael.christie@oracle.com>
Date: Sun, 07 Jun 2020 20:35:50 +0000
Subject: [PATCH 03/17] target: add helper to parse acl and transport name
Message-Id: <1591562164-9766-4-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: bvanassche@acm.org, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Juergen Gross <jgross@suse.com>

The drivers that emulate the initiator port id (loop, scsi vhost, xen scsiback)
do almost the extact same parsing when making their I_T_nexus. This adds a
helper that parses out the acl name and port name from the user buffer, so
these types of drivers drop prefixes like "naa." when they need to for the
SCSI SPC4 TransportID SAS address, but then keep it for the LIO ACL name.

The next patches will then convert those drivers.

Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Juergen Gross <jgross@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Lee Duncan <lduncan@suse.com>
---
 drivers/target/target_core_fabric_lib.c | 73 +++++++++++++++++++++++++++++++++
 include/target/target_core_fabric.h     |  2 +
 2 files changed, 75 insertions(+)

diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index e89b3d8..81ed7d5 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -423,6 +423,79 @@ const char *target_parse_pr_out_transport_id(struct se_portal_group *tpg,
 	return buf + offset;
 }
 
+/**
+ * target_parse_emulated_name - parse TransportID and acl name from user buffer
+ * @proto_id: SCSI protocol identifier
+ * @user_buf: buffer with emualted name to extract acl and TransportID from
+ * @acl_name: buffer to store se_node_acl name in
+ * @max_name_len: len of acl_name buffer
+ * @tpt_id_name: Pointer to the TransportID name will be stored here.
+ */
+int target_parse_emulated_name(u8 proto_id, const char *user_buf,
+			       unsigned char *acl_name, int max_name_len,
+			       unsigned char **tpt_id_name)
+{
+	int user_len = strlen(user_buf);
+	char *proto_prefix, *name_start;
+
+	if (user_len >= max_name_len) {
+		pr_err("Emulated name: %s, exceeds max: %d\n", user_buf,
+		       max_name_len);
+		return -EINVAL;
+	}
+
+	switch (proto_id) {
+	case SCSI_PROTOCOL_SAS:
+		proto_prefix = "naa.";
+		break;
+	case SCSI_PROTOCOL_FCP:
+		proto_prefix = "fc.";
+		break;
+	case SCSI_PROTOCOL_ISCSI:
+		proto_prefix = "iqn.";
+		break;
+	default:
+		pr_err("Unsupported proto_id: 0x%02x\n", proto_id);
+		return -EINVAL;
+	}
+
+	name_start = strstr(user_buf, proto_prefix);
+	if (!name_start) {
+		pr_err("Invalid emulated name %s. Must start with %s\n",
+		       user_buf, proto_prefix);
+		return -EINVAL;
+	}
+
+	switch (proto_id) {
+	case SCSI_PROTOCOL_SAS:
+		sprintf(acl_name, name_start);
+		break;
+	case SCSI_PROTOCOL_FCP:
+		sprintf(acl_name, &name_start[3]); /* Skip over "fc." */
+		break;
+	case SCSI_PROTOCOL_ISCSI:
+		sprintf(acl_name, name_start);
+		break;
+	}
+
+	if (acl_name[user_len - 1] = '\n')
+		acl_name[user_len - 1] = '\0';
+
+	if (proto_id = SCSI_PROTOCOL_SAS) {
+		/*
+		 * target_setup_session will want the naa. prefix to match
+		 * the ACL name, but the t10 transport id only wants the
+		 * address.
+		 */
+		*tpt_id_name = acl_name + 4;
+	} else {
+		*tpt_id_name = acl_name;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(target_parse_emulated_name);
+
 struct t10_transport_id *target_create_transport_id(u8 proto, const char *name,
 						    const char *session_id)
 {
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index af1dd81..0113e1c 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -125,6 +125,8 @@ struct target_core_fabric_ops {
 int target_depend_item(struct config_item *item);
 void target_undepend_item(struct config_item *item);
 
+int target_parse_emulated_name(u8, const char *, unsigned char *, int,
+			       unsigned char **);
 struct t10_transport_id *target_create_transport_id(u8, const char *,
 						    const char *);
 void target_free_transport_id(struct t10_transport_id *);
-- 
1.8.3.1
