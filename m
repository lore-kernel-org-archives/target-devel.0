From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 08 Nov 2017 08:44:15 +0000
Subject: [PATCH 2/2] tcmu: Add a missing unlock on an error path
Message-Id: <20171108084415.dn443crpreqwqoiw@mwanda>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Mike Christie <mchristi@redhat.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org

We added a new error path here but we forgot to drop the lock first
before returning.

Fixes: 0d44374c1aae ("tcmu: fix double se_cmd completion")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 07f2d95f7ae7..cc2468a299d3 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -888,6 +888,7 @@ tcmu_queue_cmd_ring(struct tcmu_cmd *tcmu_cmd)
 	ret = tcmu_setup_cmd_timer(tcmu_cmd);
 	if (ret) {
 		tcmu_cmd_free_data(tcmu_cmd, tcmu_cmd->dbi_cnt);
+		mutex_unlock(&udev->cmdr_lock);
 		return TCM_OUT_OF_RESOURCES;
 	}
 	entry->hdr.cmd_id = tcmu_cmd->cmd_id;
