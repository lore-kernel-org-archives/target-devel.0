From: Maurizio Lombardi <mlombard@redhat.com>
Date: Wed, 07 Oct 2020 14:53:25 +0000
Subject: [PATCH 1/2] target: iscsi: prevent a race condition in iscsit_unmap_cmd()
Message-Id: <20201007145326.56850-2-mlombard@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20201007145326.56850-1-mlombard@redhat.com>
In-Reply-To: <20201007145326.56850-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, bvanassche@acm.org, michael.christie@oracle.com

A potential race condition may occur in iscsit_unmap_cmd() if the
__iscsit_free_cmd() function is called by two different threads.

This patch adds a spinlock to serialize the calls to
iscsit_unmap_cmd()

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/target/iscsi/iscsi_target_login.c | 1 +
 drivers/target/iscsi/iscsi_target_util.c  | 5 ++++-
 include/target/iscsi/iscsi_target_core.h  | 1 +
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 893d1b406c29..e16ceee87bba 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -1110,6 +1110,7 @@ static struct iscsi_conn *iscsit_alloc_conn(struct iscsi_np *np)
 	spin_lock_init(&conn->nopin_timer_lock);
 	spin_lock_init(&conn->response_queue_lock);
 	spin_lock_init(&conn->state_lock);
+	spin_lock_init(&conn->unmap_cmd_lock);
 
 	timer_setup(&conn->nopin_response_timer,
 		    iscsit_handle_nopin_response_timeout, 0);
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 45ba07c6ec27..3082f5bde9fa 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -755,8 +755,11 @@ void __iscsit_free_cmd(struct iscsi_cmd *cmd, bool check_queues)
 		iscsit_remove_cmd_from_response_queue(cmd, conn);
 	}
 
-	if (conn && conn->conn_transport->iscsit_unmap_cmd)
+	if (conn && conn->conn_transport->iscsit_unmap_cmd) {
+		spin_lock(&conn->unmap_cmd_lock);
 		conn->conn_transport->iscsit_unmap_cmd(conn, cmd);
+		spin_unlock(&conn->unmap_cmd_lock);
+	}
 }
 
 void iscsit_free_cmd(struct iscsi_cmd *cmd, bool shutdown)
diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
index 1eccb2ac7d02..ae7ac0134c8c 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -575,6 +575,7 @@ struct iscsi_conn {
 	spinlock_t		nopin_timer_lock;
 	spinlock_t		response_queue_lock;
 	spinlock_t		state_lock;
+	spinlock_t		unmap_cmd_lock;
 	/* libcrypto RX and TX contexts for crc32c */
 	struct ahash_request	*conn_rx_hash;
 	struct ahash_request	*conn_tx_hash;
-- 
2.26.2
