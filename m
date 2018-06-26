From: Mike Christie <mchristi@redhat.com>
Date: Tue, 26 Jun 2018 16:47:20 +0000
Subject: [PATCH 1/1] tcmu: Don't pass KERN_ERR to pr_err
Message-Id: <1530031640-8100-1-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Fix warning:

smatch warnings:
drivers/target/target_core_user.c:301 tcmu_genl_cmd_done() warn: KERN_*
level not at start of string

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 9555981..847707a 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -383,7 +383,7 @@ static int tcmu_genl_cmd_done(struct genl_info *info, int completed_cmd)
 	}
 
 	if (!udev) {
-		pr_err(KERN_ERR "tcmu nl cmd %u/%d completion could not find device with dev id %u.\n",
+		pr_err("tcmu nl cmd %u/%d completion could not find device with dev id %u.\n",
 		       completed_cmd, rc, dev_id);
 		ret = -ENODEV;
 		goto unlock;
-- 
2.7.2

