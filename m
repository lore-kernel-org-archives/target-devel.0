From: Anastasia Kovaleva <a.kovaleva@yadro.com>
Date: Thu, 22 Oct 2020 17:20:09 +0000
Subject: [PATCH 1/3] scsi: target: core: Set residuals for 4Kn devices
Message-Id: <20201022172011.42367-2-a.kovaleva@yadro.com>
List-Id: <target-devel.vger.kernel.org>
References: <20201022172011.42367-1-a.kovaleva@yadro.com>
In-Reply-To: <20201022172011.42367-1-a.kovaleva@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, linux@yadro.com, Roman Bolshakov <r.bolshakov@yadro.com>, Bart Van Assche <bvanassche@acm.org>, Konstantin Vinogradov <k.vinogradov@yadro.com>

From: Roman Bolshakov <r.bolshakov@yadro.com>

TCM always fails SBC commands with residuals for 4Kn devices when the
command is processed by sbc_parse_cdb(). That prevents residual
signalling to the transport driver because residual kind and residual
amount aren't set. It also makes residual handling different from
512-byte formatted devices - if there are residuals 512-byte LUN would
proceed with command execution while 4K-byte LUN would fail.

Based-on: https://patchwork.kernel.org/project/target-devel/patch/20170523234854.21452-31-bart.vanassche@sandisk.com/
Based-on-patch-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Konstantin Vinogradov <k.vinogradov@yadro.com>
---
 drivers/target/target_core_transport.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 9fb0be0aa620..6d73b453c2cb 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1325,17 +1325,6 @@ target_cmd_size_check(struct se_cmd *cmd, unsigned int size)
 				return TCM_INVALID_CDB_FIELD;
 			}
 		}
-		/*
-		 * Reject READ_* or WRITE_* with overflow/underflow for
-		 * type SCF_SCSI_DATA_CDB.
-		 */
-		if (dev->dev_attrib.block_size != 512)  {
-			pr_err("Failing OVERFLOW/UNDERFLOW for LBA op"
-				" CDB on non 512-byte sector setup subsystem"
-				" plugin: %s\n", dev->transport->name);
-			/* Returns CHECK_CONDITION + INVALID_CDB_FIELD */
-			return TCM_INVALID_CDB_FIELD;
-		}
 		/*
 		 * For the overflow case keep the existing fabric provided
 		 * ->data_length.  Otherwise for the underflow case, reset
-- 
2.24.3 (Apple Git-128)
