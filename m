From: Bart Van Assche <bart.vanassche@wdc.com>
Date: Wed, 13 Dec 2017 23:50:19 +0000
Subject: [PATCH 01/11] target: Fix an argument name in a function documentation header
Message-Id: <20171213235029.581-2-bart.vanassche@wdc.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Fixes: commit ea98d7f9c7cc ("target: Add target_submit_tmr helper function")
Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 58caacd54a3b..8e853f9db695 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1654,7 +1654,7 @@ static bool target_lookup_lun_from_tag(struct se_session *se_sess, u64 tag,
  * @se_sess: associated se_sess for endpoint
  * @sense: pointer to SCSI sense buffer
  * @unpacked_lun: unpacked LUN to reference for struct se_lun
- * @fabric_context: fabric context for TMR req
+ * @fabric_tmr_ptr: fabric context for TMR req
  * @tm_type: Type of TM request
  * @gfp: gfp type for caller
  * @tag: referenced task tag for TMR_ABORT_TASK
-- 
2.15.1

