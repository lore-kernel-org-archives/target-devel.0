From: Kenjiro Nakayama <nakayamakenjiro@gmail.com>
Date: Wed, 13 Sep 2017 06:07:03 +0000
Subject: [PATCH] target/tcmu: Adds a timeout for the completion of netlink command reply
Message-Id: <20170913060703.17846-1-nakayamakenjiro@gmail.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patch adds a timeout for the completion of netlink command reply.

Current code waits for the netlink reply from userspace and the status
change, but it hangs forever when userspace failed to reply. To fix
this issue, this patch replace wait_for_completion with
wait_for_completion_timeout.

Signed-off-by: Kenjiro Nakayama <nakayamakenjiro@gmail.com>
---
 drivers/target/target_core_user.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 942d094269fb..284294340167 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1333,7 +1333,12 @@ static int tcmu_wait_genl_cmd_reply(struct tcmu_dev *udev)
 		return 0;
 
 	pr_debug("sleeping for nl reply\n");
-	wait_for_completion(&nl_cmd->complete);
+	ret = wait_for_completion_timeout(&nl_cmd->complete,
+			msecs_to_jiffies(3000));
+	if (!ret) {
+		printk(KERN_ERR "timeout waiting for nl reply from userspace\n");
+		return -ETIME;
+	}
 
 	spin_lock(&udev->nl_cmd_lock);
 	nl_cmd->cmd = TCMU_CMD_UNSPEC;
-- 
2.13.5

