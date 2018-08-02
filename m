From: Mike Christie <mchristi@redhat.com>
Date: Thu, 02 Aug 2018 17:12:27 +0000
Subject: [PATCH 8/8] target: loop, usb, vhost, xen: use target_remove_session
Message-Id: <1533229947-6277-9-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This converts drivers that were only calling transport_deregister_session
to use target_remove_session. The calling of
transport_deregister_session_configfs via target_remove_session for these
types of drivers is ok, because they were not exporting info from fields
like sess_acl_list, sess->se_tpg and sess->fabric_sess_ptr from configfs
accessible functions, so they will see no difference.

Signed-off-by: Mike Christie <mchristi@redhat.com>
Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Felipe Balbi <balbi@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Juergen Gross <jgross@suse.com>
---
 drivers/target/loopback/tcm_loop.c  | 2 +-
 drivers/usb/gadget/function/f_tcm.c | 2 +-
 drivers/vhost/scsi.c                | 2 +-
 drivers/xen/xen-scsiback.c          | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 54b5b94..bc8918f 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -805,7 +805,7 @@ static int tcm_loop_drop_nexus(
 	/*
 	 * Release the SCSI I_T Nexus to the emulated Target Port
 	 */
-	transport_deregister_session(tl_nexus->se_sess);
+	target_remove_session(se_sess);
 	tpg->tl_nexus = NULL;
 	kfree(tl_nexus);
 	return 0;
diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
index ba7c5f6..106988a 100644
--- a/drivers/usb/gadget/function/f_tcm.c
+++ b/drivers/usb/gadget/function/f_tcm.c
@@ -1638,7 +1638,7 @@ static int tcm_usbg_drop_nexus(struct usbg_tpg *tpg)
 	/*
 	 * Release the SCSI I_T Nexus to the emulated vHost Target Port
 	 */
-	transport_deregister_session(tv_nexus->tvn_se_sess);
+	target_remove_session(se_sess);
 	tpg->tpg_nexus = NULL;
 
 	kfree(tv_nexus);
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index e936884..76f8d64 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1797,7 +1797,7 @@ static int vhost_scsi_drop_nexus(struct vhost_scsi_tpg *tpg)
 	/*
 	 * Release the SCSI I_T Nexus to the emulated vhost Target Port
 	 */
-	transport_deregister_session(tv_nexus->tvn_se_sess);
+	target_remove_session(se_sess);
 	tpg->tpg_nexus = NULL;
 	mutex_unlock(&tpg->tv_tpg_mutex);
 
diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index 2ffc7ed..2aadabd 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -1576,7 +1576,7 @@ static int scsiback_drop_nexus(struct scsiback_tpg *tpg)
 	/*
 	 * Release the SCSI I_T Nexus to the emulated xen-pvscsi Target Port
 	 */
-	transport_deregister_session(tv_nexus->tvn_se_sess);
+	target_remove_session(se_sess);
 	tpg->tpg_nexus = NULL;
 	mutex_unlock(&tpg->tv_tpg_mutex);
 
-- 
2.7.2

