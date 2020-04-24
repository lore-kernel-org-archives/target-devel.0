From: Hou Pu <houpu@bytedance.com>
Date: Fri, 24 Apr 2020 03:58:43 +0000
Subject: [PATCH v2 2/2] iscsi-target: Fix inconsistent debug message in __iscsi_target_sk_check_close
Message-Id: <20200424035843.5914-3-houpu@bytedance.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200424035843.5914-1-houpu@bytedance.com>
In-Reply-To: <20200424035843.5914-1-houpu@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: martin.petersen@oracle.com, mchristi@redhat.com
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Hou Pu <houpu@bytedance.com>

Following commit changed the return value of __iscsi_target_sk_check_close.
But the pr_debug is still printing FALSE when returing TRUE which is a little
confusing.

commit 25cdda95fda78d22d44157da15aa7ea34be3c804
Author: Nicholas Bellinger <nab@linux-iscsi.org>
Date:   Wed May 24 21:47:09 2017 -0700

    iscsi-target: Fix initial login PDU asynchronous socket close OOPs

Signed-off-by: Hou Pu <houpu@bytedance.com>
---
 drivers/target/iscsi/iscsi_target_nego.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 5292b6c51b4e..2fee1946fb7a 100644
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
