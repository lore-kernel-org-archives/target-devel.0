From: Mike Christie <mchristi@redhat.com>
Date: Fri, 22 Jun 2018 03:52:38 +0000
Subject: [PATCH 1/3] tcmu: delete unused __wait
Message-Id: <1529639560-9429-2-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

When this code change this was never cleaned up.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_user.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index e4a76f9..898a561 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1564,7 +1564,6 @@ static int tcmu_wait_genl_cmd_reply(struct tcmu_dev *udev)
 {
 	struct tcmu_nl_cmd *nl_cmd = &udev->curr_nl_cmd;
 	int ret;
-	DEFINE_WAIT(__wait);
 
 	if (!tcmu_kern_cmd_reply_supported)
 		return 0;
-- 
2.7.2

