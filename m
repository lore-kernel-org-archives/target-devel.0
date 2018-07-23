From: Mike Christie <mchristi@redhat.com>
Date: Mon, 23 Jul 2018 19:07:44 +0000
Subject: [PATCH 2/9] tcmu: initialize list head
Message-Id: <1532372871-7128-3-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Use INIT_LIST_HEAD to initialize node list head.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_user.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index fafe65f..b010ed7 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1342,6 +1342,7 @@ static struct se_device *tcmu_alloc_device(struct se_hba *hba, const char *name)
 	udev->max_blocks = DATA_BLOCK_BITS_DEF;
 	mutex_init(&udev->cmdr_lock);
 
+	INIT_LIST_HEAD(&udev->node);
 	INIT_LIST_HEAD(&udev->timedout_entry);
 	INIT_LIST_HEAD(&udev->cmdr_queue);
 	idr_init(&udev->commands);
-- 
1.8.3.1

