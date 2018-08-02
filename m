From: Mike Christie <mchristi@redhat.com>
Date: Thu, 02 Aug 2018 17:12:20 +0000
Subject: [PATCH 1/8] target: fix __transport_register_session locking
Message-Id: <1533229947-6277-2-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

When __transport_register_session is called from
transport_register_session irqs will already have been disabled, so we
do not want the unlock irq call to enable them until the higher level
has done the final spin_unlock_irqrestore/ spin_unlock_irq.

This has __transport_register_session use the save/restore call.

Signed-off-by: Mike Christie <mchristi@redhat.com>
Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_transport.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 7261561..b419d4f 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -347,6 +347,7 @@ void __transport_register_session(
 {
 	const struct target_core_fabric_ops *tfo = se_tpg->se_tpg_tfo;
 	unsigned char buf[PR_REG_ISID_LEN];
+	unsigned long flags;
 
 	se_sess->se_tpg = se_tpg;
 	se_sess->fabric_sess_ptr = fabric_sess_ptr;
@@ -383,7 +384,7 @@ void __transport_register_session(
 			se_sess->sess_bin_isid = get_unaligned_be64(&buf[0]);
 		}
 
-		spin_lock_irq(&se_nacl->nacl_sess_lock);
+		spin_lock_irqsave(&se_nacl->nacl_sess_lock, flags);
 		/*
 		 * The se_nacl->nacl_sess pointer will be set to the
 		 * last active I_T Nexus for each struct se_node_acl.
@@ -392,7 +393,7 @@ void __transport_register_session(
 
 		list_add_tail(&se_sess->sess_acl_list,
 			      &se_nacl->acl_sess_list);
-		spin_unlock_irq(&se_nacl->nacl_sess_lock);
+		spin_unlock_irqrestore(&se_nacl->nacl_sess_lock, flags);
 	}
 	list_add_tail(&se_sess->sess_list, &se_tpg->tpg_sess_list);
 
-- 
2.7.2

