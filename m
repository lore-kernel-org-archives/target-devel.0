From: Hou Pu <houpu@bytedance.com>
Date: Thu, 16 Jul 2020 10:02:12 +0000
Subject: [PATCH v4 2/2] iscsi-target: Fix inconsistent debug message in __iscsi_target_sk_check_close
Message-Id: <20200716100212.4237-3-houpu@bytedance.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200716100212.4237-1-houpu@bytedance.com>
In-Reply-To: <20200716100212.4237-1-houpu@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: mchristi@redhat.com, Hou Pu <houpu@bytedance.com>

The commit 25cdda95fda7 ("iscsi-target: Fix initial login PDU
asynchronous socket close OOPs") changed the return value of
__iscsi_target_sk_check_close. But the pr_debug is still printing
FALSE when returning TRUE which is a little confusing.

Signed-off-by: Hou Pu <houpu@bytedance.com>
---
 drivers/target/iscsi/iscsi_target_nego.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 10477e44d17b..701c008d6bd5 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -481,7 +481,7 @@ static bool __iscsi_target_sk_check_close(struct sock *sk)
 {
 	if (sk->sk_state = TCP_CLOSE_WAIT || sk->sk_state = TCP_CLOSE) {
 		pr_debug("__iscsi_target_sk_check_close: TCP_CLOSE_WAIT|TCP_CLOSE,"
-			"returning FALSE\n");
+			"returning TRUE\n");
 		return true;
 	}
 	return false;
-- 
2.11.0
