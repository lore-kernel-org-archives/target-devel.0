From: Chuhong Yuan <hslester96@gmail.com>
Date: Thu, 28 May 2020 10:20:56 +0000
Subject: [PATCH] sbp-target: add the missed kfree() in an error path
Message-Id: <20200528102056.911825-1-hslester96@gmail.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Chris Boot <bootc@bootc.net>, "Martin K . Petersen" <martin.petersen@oracle.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>

sbp_fetch_command() forgets to call kfree() in an error path.
Add the missed call to fix it.

Fixes: a511ce339780 ("sbp-target: Initial merge of firewire/ieee-1394 target mode support")
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 drivers/target/sbp/sbp_target.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index e4a9b9fe3dfb..504a755ea344 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -1128,8 +1128,10 @@ static int sbp_fetch_command(struct sbp_target_request *req)
 				req->orb_pointer + sizeof(req->orb),
 				req->cmd_buf + sizeof(req->orb.command_block),
 				copy_len);
-		if (ret != RCODE_COMPLETE)
+		if (ret != RCODE_COMPLETE) {
+			kfree(req->cmd_buf);
 			return -EIO;
+		}
 	}
 
 	return 0;
-- 
2.26.2
