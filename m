From: Mike Christie <mchristi@redhat.com>
Date: Sun, 15 Jul 2018 23:16:19 +0000
Subject: [PATCH 03/15] target: fix __transport_register_session locking
Message-Id: <1531696591-8558-4-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

When __transport_register_session is called from
transport_register_session irqs will already have been disabled,
so we do not want the unlock irq call to enable them until
the higher level has done the final
spin_unlock_irqrestore/spin_unlock_irq.

This has __transport_register_session use the save/restore
call.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_transport.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 6324743..75ddbbb 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -347,6 +347,7 @@ void __transport_register_session(
 {
 	const struct target_core_fabric_ops *tfo = se_tpg->se_tpg_tfo;
 	unsigned char buf[PR_REG_ISID_LEN];
+	unsigned long flags;
 
 	se_sess->se_tpg = se_tpg;
 	se_sess->fabric_sess_ptr = fabric_sess_ptr;
@@ -384,7 +385,7 @@ void __transport_register_session(
 			WARN_ON(hex2bin((u8 *)&se_sess->sess_bin_isid, buf, 6));
 		}
 
-		spin_lock_irq(&se_nacl->nacl_sess_lock);
+		spin_lock_irqsave(&se_nacl->nacl_sess_lock, flags);
 		/*
 		 * The se_nacl->nacl_sess pointer will be set to the
 		 * last active I_T Nexus for each struct se_node_acl.
@@ -393,7 +394,7 @@ void __transport_register_session(
 
 		list_add_tail(&se_sess->sess_acl_list,
 			      &se_nacl->acl_sess_list);
-		spin_unlock_irq(&se_nacl->nacl_sess_lock);
+		spin_unlock_irqrestore(&se_nacl->nacl_sess_lock, flags);
 	}
 	list_add_tail(&se_sess->sess_list, &se_tpg->tpg_sess_list);
 
-- 
2.7.2

