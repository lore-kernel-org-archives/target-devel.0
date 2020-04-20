From: Mike Christie <mchristi@redhat.com>
Date: Mon, 20 Apr 2020 19:14:18 +0000
Subject: [RFC PATCH 04/12] target: use tpid in target_stat_iport_port_ident_show
Message-Id: <20200420191426.17055-5-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200420191426.17055-1-mchristi@redhat.com>
In-Reply-To: <20200420191426.17055-1-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jsmart2021@gmail.com, bvanassche@acm.org, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Mike Christie <mchristi@redhat.com>

Use the tpid session id instead of sess_get_initiator_sid.

Note that for userspace compat this patch continues the behavior:

1. Still add the "+i+" even if there is no session_id.
2. Use the acl initiatorname instead of the transportID port/addr/name.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_fabric_lib.c |  7 +++++++
 drivers/target/target_core_internal.h   |  1 +
 drivers/target/target_core_stat.c       | 12 ++++++------
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index 39b0e5e..6a53e16 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -508,3 +508,10 @@ void target_free_transport_id(struct t10_transport_id *tpid)
 	}
 	kfree(tpid);
 }
+
+char *transport_id_get_sid(struct t10_transport_id *tpid)
+{
+	if (tpid->proto == SCSI_PROTOCOL_ISCSI)
+		return tpid->iscsi.session_id;
+	return NULL;
+}
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 5e016aa..efc5449 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -105,6 +105,7 @@ int	target_get_pr_transport_id(struct se_node_acl *nacl,
 const char *target_parse_pr_out_transport_id(struct se_portal_group *tpg,
 		char *buf, u32 *out_tid_len, char **port_nexus_ptr);
 void target_free_transport_id(struct t10_transport_id *tpid);
+char *transport_id_get_sid(struct t10_transport_id *tpid);
 
 /* target_core_hba.c */
 struct se_hba *core_alloc_hba(const char *, u32, u32);
diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index 237309d..cc9c966 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -1309,8 +1309,8 @@ static ssize_t target_stat_iport_port_ident_show(struct config_item *item,
 	struct se_node_acl *nacl = lacl->se_lun_nacl;
 	struct se_session *se_sess;
 	struct se_portal_group *tpg;
+	char *session_id = NULL;
 	ssize_t ret;
-	unsigned char buf[64];
 
 	spin_lock_irq(&nacl->nacl_sess_lock);
 	se_sess = nacl->nacl_sess;
@@ -1319,13 +1319,13 @@ static ssize_t target_stat_iport_port_ident_show(struct config_item *item,
 		return -ENODEV;
 	}
 
+	session_id = transport_id_get_sid(se_sess->tpid);
+	if (!session_id)
+		session_id = "";
 	tpg = nacl->se_tpg;
 	/* scsiAttIntrPortName+scsiAttIntrPortIdentifier */
-	memset(buf, 0, 64);
-	if (tpg->se_tpg_tfo->sess_get_initiator_sid != NULL)
-		tpg->se_tpg_tfo->sess_get_initiator_sid(se_sess, buf, 64);
-
-	ret = snprintf(page, PAGE_SIZE, "%s+i+%s\n", nacl->initiatorname, buf);
+	ret = snprintf(page, PAGE_SIZE, "%s+i+%s\n", nacl->initiatorname,
+		       session_id);
 	spin_unlock_irq(&nacl->nacl_sess_lock);
 	return ret;
 }
-- 
1.8.3.1
