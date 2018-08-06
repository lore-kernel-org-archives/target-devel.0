From: Randy Dunlap <rdunlap@infradead.org>
Date: Mon, 06 Aug 2018 23:20:11 +0000
Subject: [PATCH v2] target: fix tcm_loop build errors when SCSI=m
Message-Id: <24dc30ca-b558-fb6c-d478-967dbfa887c4@infradead.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix build errors when CONFIG_SCSI=m and CONFIG_LOOPBACK_TARGET=y
by making LOOPBACK_TARGET depend on SCSI.

drivers/target/loopback/tcm_loop.o: In function `tcm_loop_port_link':
tcm_loop.c:(.text+0x445): undefined reference to `scsi_add_device'
drivers/target/loopback/tcm_loop.o: In function `tcm_loop_driver_remove':
tcm_loop.c:(.text+0x55c): undefined reference to `scsi_remove_host'
tcm_loop.c:(.text+0x564): undefined reference to `scsi_host_put'
drivers/target/loopback/tcm_loop.o: In function `tcm_loop_submission_work':
tcm_loop.c:(.text+0x7c4): undefined reference to `scmd_printk'
drivers/target/loopback/tcm_loop.o: In function `tcm_loop_driver_probe':
tcm_loop.c:(.text+0x7fb): undefined reference to `scsi_host_alloc'
tcm_loop.c:(.text+0x85b): undefined reference to `scsi_add_host_with_dma'
tcm_loop.c:(.text+0x896): undefined reference to `scsi_host_put'
drivers/target/loopback/tcm_loop.o: In function `tcm_loop_port_unlink':
tcm_loop.c:(.text+0x962): undefined reference to `scsi_device_lookup'
tcm_loop.c:(.text+0x972): undefined reference to `scsi_remove_device'
tcm_loop.c:(.text+0x97a): undefined reference to `scsi_device_put'
drivers/target/loopback/tcm_loop.o:(.data+0x210): undefined reference to `scsi_change_queue_depth'

Fixes: 3703b2c5d041 ("[SCSI] tcm_loop: Add multi-fabric Linux/SCSI LLD
       fabric module")

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org
Cc: target-devel@vger.kernel.org
Cc: Bart Van Assche <bart.vanassche@wdc.com>
Cc: stable@vger.kernel.org # 2.6.39++
---
v2: add Fixes: and Cc:stable

 drivers/target/loopback/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20180806.orig/drivers/target/loopback/Kconfig
+++ linux-next-20180806/drivers/target/loopback/Kconfig
@@ -1,5 +1,6 @@
 config LOOPBACK_TARGET
 	tristate "TCM Virtual SAS target and Linux/SCSI LDD fabric loopback module"
+	depends on SCSI
 	help
 	  Say Y here to enable the TCM Virtual SAS target and Linux/SCSI LLD
 	  fabric loopback module.


