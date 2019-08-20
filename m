From: Naohiro Aota <naohiro.aota@wdc.com>
Date: Tue, 20 Aug 2019 09:04:29 +0000
Subject: [PATCH v2 2/2] scsi: target/tcm_loop: update upper limit of LUN
Message-Id: <20190820090429.1961085-2-naohiro.aota@wdc.com>
List-Id: <target-devel.vger.kernel.org>
References: <20190820090429.1961085-1-naohiro.aota@wdc.com>
In-Reply-To: <20190820090429.1961085-1-naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Mike Christie <mchristi@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>, "Martin K . Petersen" <martin.petersen@oracle.com>, Naohiro Aota <naohiro.aota@wdc.com>

targetcli-fb (or its library: rtslib-fb) allows us to create LUN up to
65535. On the other hand, the kernel driver is limiting max_lun to 0.

This limitation causes actual problem when you delete a loopback device
(using /sys/class/scsi_device/${lun}/device/delete) and rescan it (using
/sys/class/scsi_host/host${h}/scan). You can delete the device, but
cannot rescan it because its LUN is larger than max_lun and so the scan
request results in -EINVAL error in scsi_scan_host_selected().

This commit fix the upper limit to a max possible value: U64_MAX.

Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
---
 drivers/target/loopback/tcm_loop.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 0942f3bd7eec..50e93b487375 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -336,10 +336,10 @@ static int tcm_loop_driver_probe(struct device *dev)
 	 */
 	*((struct tcm_loop_hba **)sh->hostdata) = tl_hba;
 	/*
-	 * Setup single ID, Channel and LUN for now..
+	 * Setup single ID, and Channel for now..
 	 */
 	sh->max_id = 2;
-	sh->max_lun = 0;
+	sh->max_lun = U64_MAX;
 	sh->max_channel = 0;
 	sh->max_cmd_len = SCSI_MAX_VARLEN_CDB_SIZE;
 
-- 
2.23.0
