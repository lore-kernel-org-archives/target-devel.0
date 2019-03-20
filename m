From: tangwenji <hndksztwj@163.com>
Date: Wed, 20 Mar 2019 14:14:44 +0000
Subject: [PATCH] target:iscsi:free conn_ops when zalloc_cpumask_var failed
Message-Id: <1553091284-4412-1-git-send-email-hndksztwj@163.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

From: tangwenji <tang.wenji@zte.com.cn>

It should not free cpumask but free conn->conn_ops When zalloc_cpumask_var failed.

Signed-off-by: tangwenji <tang.wenji@zte.com.cn>
---
 drivers/target/iscsi/iscsi_target_login.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index ae3209e..c3e1d40 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -1159,13 +1159,13 @@ static struct iscsi_conn *iscsit_alloc_conn(struct iscsi_np *np)
 
 	if (!zalloc_cpumask_var(&conn->conn_cpumask, GFP_KERNEL)) {
 		pr_err("Unable to allocate conn->conn_cpumask\n");
-		goto free_mask;
+		goto free_conn_ops;
 	}
 
 	return conn;
 
-free_mask:
-	free_cpumask_var(conn->conn_cpumask);
+free_conn_ops:
+	kfree(conn->conn_ops);
 put_transport:
 	iscsit_put_transport(conn->conn_transport);
 free_conn:
-- 
2.5.0.windows.1
