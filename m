From: Bart Van Assche <bart.vanassche@wdc.com>
Date: Tue, 31 Oct 2017 18:03:10 +0000
Subject: [PATCH 02/11] target: Suppress gcc 7 fallthrough warnings
Message-Id: <20171031180319.19258-3-bart.vanassche@wdc.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Avoid that gcc 7 reports the following warning when building with W=1:

warning: this statement may fall through [-Wimplicit-fallthrough=]

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Varun Prakash <varun@chelsio.com>
---
 drivers/target/iscsi/cxgbit/cxgbit_main.c | 1 +
 drivers/target/target_core_pr.c           | 2 ++
 drivers/target/target_core_transport.c    | 4 ++--
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/target/iscsi/cxgbit/cxgbit_main.c b/drivers/target/iscsi/cxgbit/cxgbit_main.c
index 4fd775ace541..f3f8856bfb68 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_main.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_main.c
@@ -446,6 +446,7 @@ cxgbit_uld_lro_rx_handler(void *hndl, const __be64 *rsp,
 	case CPL_RX_ISCSI_DDP:
 	case CPL_FW4_ACK:
 		lro_flush = false;
+		/* fall through */
 	case CPL_ABORT_RPL_RSS:
 	case CPL_PASS_ESTABLISH:
 	case CPL_PEER_CLOSE:
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 6d5def64db61..6bdd47cae9e3 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -351,6 +351,7 @@ static int core_scsi3_pr_seq_non_holder(struct se_cmd *cmd, u32 pr_reg_type,
 		break;
 	case PR_TYPE_WRITE_EXCLUSIVE_REGONLY:
 		we = 1;
+		/* fall through */
 	case PR_TYPE_EXCLUSIVE_ACCESS_REGONLY:
 		/*
 		 * Some commands are only allowed for registered I_T Nexuses.
@@ -359,6 +360,7 @@ static int core_scsi3_pr_seq_non_holder(struct se_cmd *cmd, u32 pr_reg_type,
 		break;
 	case PR_TYPE_WRITE_EXCLUSIVE_ALLREG:
 		we = 1;
+		/* fall through */
 	case PR_TYPE_EXCLUSIVE_ACCESS_ALLREG:
 		/*
 		 * Each registered I_T Nexus is a reservation holder.
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 836d552b0385..e6a2817c8239 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2090,7 +2090,7 @@ static void transport_complete_qf(struct se_cmd *cmd)
 			ret = cmd->se_tfo->queue_data_in(cmd);
 			break;
 		}
-		/* Fall through for DMA_TO_DEVICE */
+		/* fall through */
 	case DMA_NONE:
 queue_status:
 		trace_target_cmd_complete(cmd);
@@ -2268,7 +2268,7 @@ static void target_complete_ok_work(struct work_struct *work)
 				goto queue_full;
 			break;
 		}
-		/* Fall through for DMA_TO_DEVICE */
+		/* fall through */
 	case DMA_NONE:
 queue_status:
 		trace_target_cmd_complete(cmd);
-- 
2.14.2

