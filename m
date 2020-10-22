From: Anastasia Kovaleva <a.kovaleva@yadro.com>
Date: Thu, 22 Oct 2020 17:20:10 +0000
Subject: [PATCH 2/3] scsi: target: core: Signal WRITE residuals
Message-Id: <20201022172011.42367-3-a.kovaleva@yadro.com>
List-Id: <target-devel.vger.kernel.org>
References: <20201022172011.42367-1-a.kovaleva@yadro.com>
In-Reply-To: <20201022172011.42367-1-a.kovaleva@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, linux@yadro.com, Anastasia Kovaleva <a.kovaleva@yadro.com>, Roman Bolshakov <r.bolshakov@yadro.com>

According to RFC 7143 11.4.5.2.:

  If SPDTL > EDTL for a task, iSCSI Overflow MUST be signaled in the
  SCSI Response PDU as specified in Section 11.4.5.1.  The Residual
  Count MUST be set to the numerical value of (SPDTL - EDTL).

  If SPDTL < EDTL for a task, iSCSI Underflow MUST be signaled in the
  SCSI Response PDU as specified in Section 11.4.5.1.  The Residual
  Count MUST be set to the numerical value of (EDTL - SPDTL).

libiscsi has residual write tests that check residual kind and residual
amount and all of them (Write10Residuals, Write12Residuals,
Write16Residuals) currently fail.

One of the reasons why they fail is because target completes write
commands with INVALID FIELD IN CDB before setting the Overflow/Underflow
bit and residual amount.

Set the Overflow/Underflow bit and the residual amount before failing a
write to comply with RFC 7143.

Signed-off-by: Anastasia Kovaleva <a.kovaleva@yadro.com>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/target/target_core_transport.c | 34 +++++++++++++++-----------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 6d73b453c2cb..8cb3012721d8 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1306,6 +1306,26 @@ target_cmd_size_check(struct se_cmd *cmd, unsigned int size)
 			" %u does not match SCSI CDB Length: %u for SAM Opcode:"
 			" 0x%02x\n", cmd->se_tfo->fabric_name,
 				cmd->data_length, size, cmd->t_task_cdb[0]);
+		/*
+		 * For READ command for the overflow case keep the existing
+		 * fabric provided ->data_length. Otherwise for the underflow
+		 * case, reset ->data_length to the smaller SCSI expected data
+		 * transfer length.
+		 */
+		if (size > cmd->data_length) {
+			cmd->se_cmd_flags |= SCF_OVERFLOW_BIT;
+			cmd->residual_count = (size - cmd->data_length);
+		} else {
+			cmd->se_cmd_flags |= SCF_UNDERFLOW_BIT;
+			cmd->residual_count = (cmd->data_length - size);
+			/*
+			 * Do not truncate ->data_length for WRITE command to
+			 * dump all payload
+			 */
+			if (cmd->data_direction = DMA_FROM_DEVICE) {
+				cmd->data_length = size;
+			}
+		}
 
 		if (cmd->data_direction = DMA_TO_DEVICE) {
 			if (cmd->se_cmd_flags & SCF_SCSI_DATA_CDB) {
@@ -1325,20 +1345,6 @@ target_cmd_size_check(struct se_cmd *cmd, unsigned int size)
 				return TCM_INVALID_CDB_FIELD;
 			}
 		}
-		/*
-		 * For the overflow case keep the existing fabric provided
-		 * ->data_length.  Otherwise for the underflow case, reset
-		 * ->data_length to the smaller SCSI expected data transfer
-		 * length.
-		 */
-		if (size > cmd->data_length) {
-			cmd->se_cmd_flags |= SCF_OVERFLOW_BIT;
-			cmd->residual_count = (size - cmd->data_length);
-		} else {
-			cmd->se_cmd_flags |= SCF_UNDERFLOW_BIT;
-			cmd->residual_count = (cmd->data_length - size);
-			cmd->data_length = size;
-		}
 	}
 
 	return target_check_max_data_sg_nents(cmd, dev, size);
-- 
2.24.3 (Apple Git-128)
