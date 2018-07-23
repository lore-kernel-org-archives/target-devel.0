From: Mike Christie <mchristi@redhat.com>
Date: Mon, 23 Jul 2018 19:07:48 +0000
Subject: [PATCH 6/9] tcmu: unmap if dev is configured
Message-Id: <1532372871-7128-7-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

The tcmu dev is added to the list of tcmu devices during configuration.
At this time the tcmu setup has completed, but lio core has not
completed its setup. The device is not yet usable so do not try to unmap
blocks from it

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_user.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index d6b4022..31cfe83 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -2581,6 +2581,11 @@ static void find_free_blocks(void)
 	list_for_each_entry(udev, &root_udev, node) {
 		mutex_lock(&udev->cmdr_lock);
 
+		if (!target_dev_configured(&udev->se_dev)) {
+			mutex_unlock(&udev->cmdr_lock);
+			continue;
+		}
+
 		/* Try to complete the finished commands first */
 		tcmu_handle_completions(udev);
 
-- 
1.8.3.1

