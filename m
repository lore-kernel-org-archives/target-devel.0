From: Max Gurtovoy <maxg@mellanox.com>
Date: Mon, 03 Aug 2020 15:00:08 +0000
Subject: [PATCH 1/1] target: make iscsit_register_transport() return void
Message-Id: <20200803150008.83920-1-maxg@mellanox.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: sagi@grimberg.me, michael.christie@oracle.com, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, bvanassche@acm.org
Cc: oren@mellanox.com, Max Gurtovoy <maxg@mellanox.com>

This function always return 0 now, we can make it return void to
simplify the code. Also, no caller ever check the return value of this
function.

Signed-off-by: Max Gurtovoy <maxg@mellanox.com>
---
 drivers/target/iscsi/iscsi_target_transport.c | 4 +---
 include/target/iscsi/iscsi_transport.h        | 2 +-
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_transport.c b/drivers/target/iscsi/iscsi_target_transport.c
index 0369405..27c85f2 100644
--- a/drivers/target/iscsi/iscsi_target_transport.c
+++ b/drivers/target/iscsi/iscsi_target_transport.c
@@ -31,7 +31,7 @@ void iscsit_put_transport(struct iscsit_transport *t)
 	module_put(t->owner);
 }
 
-int iscsit_register_transport(struct iscsit_transport *t)
+void iscsit_register_transport(struct iscsit_transport *t)
 {
 	INIT_LIST_HEAD(&t->t_node);
 
@@ -40,8 +40,6 @@ int iscsit_register_transport(struct iscsit_transport *t)
 	mutex_unlock(&transport_mutex);
 
 	pr_debug("Registered iSCSI transport: %s\n", t->name);
-
-	return 0;
 }
 EXPORT_SYMBOL(iscsit_register_transport);
 
diff --git a/include/target/iscsi/iscsi_transport.h b/include/target/iscsi/iscsi_transport.h
index 75bee29..b8feba7 100644
--- a/include/target/iscsi/iscsi_transport.h
+++ b/include/target/iscsi/iscsi_transport.h
@@ -43,7 +43,7 @@ static inline void *iscsit_priv_cmd(struct iscsi_cmd *cmd)
  * From iscsi_target_transport.c
  */
 
-extern int iscsit_register_transport(struct iscsit_transport *);
+extern void iscsit_register_transport(struct iscsit_transport *);
 extern void iscsit_unregister_transport(struct iscsit_transport *);
 extern struct iscsit_transport *iscsit_get_transport(int);
 extern void iscsit_put_transport(struct iscsit_transport *);
-- 
1.8.3.1
