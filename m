From: Mike Christie <michael.christie@oracle.com>
Date: Sun, 07 Jun 2020 20:35:55 +0000
Subject: [PATCH 08/17] target: use tpt_id in target_stat_iport_port_ident_show
Message-Id: <1591562164-9766-9-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: bvanassche@acm.org, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

Use the tpt_id session id instead of sess_get_initiator_sid.

Note that for userspace compat this patch continues the behavior:

1. Still add the "+i+" even if there is no session_id.
2. Use the acl initiatorname instead of the transportID port/addr/name.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/target/target_core_stat.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index 237309d..3eb1b9b 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -1308,9 +1308,7 @@ static ssize_t target_stat_iport_port_ident_show(struct config_item *item,
 	struct se_lun_acl *lacl = iport_to_lacl(item);
 	struct se_node_acl *nacl = lacl->se_lun_nacl;
 	struct se_session *se_sess;
-	struct se_portal_group *tpg;
 	ssize_t ret;
-	unsigned char buf[64];
 
 	spin_lock_irq(&nacl->nacl_sess_lock);
 	se_sess = nacl->nacl_sess;
@@ -1319,13 +1317,9 @@ static ssize_t target_stat_iport_port_ident_show(struct config_item *item,
 		return -ENODEV;
 	}
 
-	tpg = nacl->se_tpg;
-	/* scsiAttIntrPortName+scsiAttIntrPortIdentifier */
-	memset(buf, 0, 64);
-	if (tpg->se_tpg_tfo->sess_get_initiator_sid != NULL)
-		tpg->se_tpg_tfo->sess_get_initiator_sid(se_sess, buf, 64);
-
-	ret = snprintf(page, PAGE_SIZE, "%s+i+%s\n", nacl->initiatorname, buf);
+	ret = snprintf(page, PAGE_SIZE, "%s+i+%s\n", nacl->initiatorname,
+		       se_sess->tpt_id->session_id ? se_sess->tpt_id->session_id :
+		       "");
 	spin_unlock_irq(&nacl->nacl_sess_lock);
 	return ret;
 }
-- 
1.8.3.1
