From: Mike Christie <mchristi@redhat.com>
Date: Tue, 19 Dec 2017 10:03:56 +0000
Subject: [PATCH 3/5] target_core_user: add cmd id to broken ring message
Message-Id: <1513677838-6675-4-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Log cmd id that was not found in the tcmu_handle_completions
lookup failure path.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_user.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index a746fed..1238480 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1098,7 +1098,8 @@ static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
 
 		cmd = idr_remove(&udev->commands, entry->hdr.cmd_id);
 		if (!cmd) {
-			pr_err("cmd_id not found, ring is broken\n");
+			pr_err("cmd_id %u not found, ring is broken\n",
+			       entry->hdr.cmd_id);
 			set_bit(TCMU_DEV_BIT_BROKEN, &udev->flags);
 			break;
 		}
-- 
1.8.3.1

