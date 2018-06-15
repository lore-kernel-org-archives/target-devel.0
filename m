From: Zhu Lingshan <lszhu@suse.com>
Date: Fri, 15 Jun 2018 18:23:14 +0000
Subject: [PATCH 05/33] TCMU PR: add a function to get IT_Nexus
Message-Id: <20180615182342.6239-5-lszhu@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patch added a function tcmu_gen_it_nexus() which can help
generate a string contain IT_Nexus information from a session.

Signed-off-by: Zhu Lingshan <lszhu@suse.com>
---
 drivers/target/target_core_user.c | 44 +++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index d368c656ef79..26d8aee40719 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1769,6 +1769,50 @@ static int tcmu_set_dev_pr_info(struct tcmu_dev *udev, void *val)
 	return tcmu_send_set_pr_info_event(udev, val);
 }
 
+static int
+tcmu_gen_it_nexus(struct se_session *se_sess,
+		     char *nexus_buf,
+		     size_t buflen)
+{
+	struct se_portal_group *se_tpg;
+	const struct target_core_fabric_ops *tfo;
+	u32 tpg_tag = 0;
+	char *tpg_wwn = "";
+	int rc;
+
+	if (!se_sess || !se_sess->se_node_acl || !se_sess->se_tpg
+	    || !se_sess->se_tpg->se_tpg_tfo) {
+		pr_warn("invalid session for IT nexus generation\n");
+		return -EINVAL;
+	}
+
+	se_tpg = se_sess->se_tpg;
+	tfo = se_tpg->se_tpg_tfo;
+
+	/*
+	 * nexus generation may be coming from an xcopy, in which case tfo
+	 * refers to xcopy_pt_tfo (tpg_get_wwn and tpg_get_tag are NULL).
+	 */
+	if (tfo->tpg_get_tag)
+		tpg_tag = tfo->tpg_get_tag(se_tpg);
+	if (tfo->tpg_get_wwn)
+		tpg_wwn = tfo->tpg_get_wwn(se_tpg);
+
+	rc = snprintf(nexus_buf, buflen, "%s,i,0x%llx,%s,t,0x%x",
+		      se_sess->se_node_acl->initiatorname,
+		      se_sess->sess_bin_isid,
+		      tpg_wwn,
+		      tpg_tag);
+	if ((rc < 0) || (rc >= buflen)) {
+		pr_debug("error formatting reserve cookie\n");
+		return -EINVAL;
+	}
+
+	pr_debug("generated nexus: %s\n", nexus_buf);
+
+	return 0;
+}
+
 static int tcmu_configure_device(struct se_device *dev)
 {
 	struct tcmu_dev *udev = TCMU_DEV(dev);
-- 
2.17.1

