From: David Disseldorp <ddiss@suse.de>
Date: Tue, 04 Dec 2018 10:12:38 +0000
Subject: [PATCH v6 5/5] target: perform t10_wwn ID initialisation in target_alloc_device()
Message-Id: <20181204101238.20587-6-ddiss@suse.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Initialise the t10_wwn vendor, model and revision defaults when a
device is allocated instead of when it's enabled. This ensures that
custom vendor or model strings set prior to enablement are not later
overwritten with default values.

The TRANSPORT_FLAG_PASSTHROUGH conditional can be dropped for the
following reasons:
- target_core_pscsi overwrites the defaults in the
  pscsi_configure_device() callback.
  + the contents is then only used for ConfigFS via
    $pscsi_dev/info, $pscsi_dev/statistics/scsi_lu/vend, etc.
- target_core_user doesn't touch the defaults, nor are they used for
  anything outside of ConfigFS.

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 drivers/target/target_core_device.c | 27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 5512871f50e4..bfc1b8b49940 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -810,6 +810,16 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 	mutex_init(&xcopy_lun->lun_tg_pt_md_mutex);
 	xcopy_lun->lun_tpg = &xcopy_pt_tpg;
 
+	/* Preload the default INQUIRY const values */
+	BUILD_BUG_ON(sizeof(dev->t10_wwn.vendor) != INQUIRY_VENDOR_LEN + 1);
+	strlcpy(dev->t10_wwn.vendor, "LIO-ORG", sizeof(dev->t10_wwn.vendor));
+	BUILD_BUG_ON(sizeof(dev->t10_wwn.model) != INQUIRY_MODEL_LEN + 1);
+	strlcpy(dev->t10_wwn.model, dev->transport->inquiry_prod,
+		sizeof(dev->t10_wwn.model));
+	BUILD_BUG_ON(sizeof(dev->t10_wwn.revision) != INQUIRY_REVISION_LEN + 1);
+	strlcpy(dev->t10_wwn.revision, dev->transport->inquiry_rev,
+		sizeof(dev->t10_wwn.revision));
+
 	return dev;
 }
 
@@ -984,23 +994,6 @@ int target_configure_device(struct se_device *dev)
 	 */
 	INIT_WORK(&dev->qf_work_queue, target_qf_do_work);
 
-	/*
-	 * Preload the initial INQUIRY const values if we are doing
-	 * anything virtual (IBLOCK, FILEIO, RAMDISK), but not for TCM/pSCSI
-	 * passthrough because this is being provided by the backend LLD.
-	 */
-	BUILD_BUG_ON(sizeof(dev->t10_wwn.vendor) != INQUIRY_VENDOR_LEN + 1);
-	BUILD_BUG_ON(sizeof(dev->t10_wwn.model) != INQUIRY_MODEL_LEN + 1);
-	BUILD_BUG_ON(sizeof(dev->t10_wwn.revision) != INQUIRY_REVISION_LEN + 1);
-	if (!(dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH)) {
-		strlcpy(dev->t10_wwn.vendor, "LIO-ORG",
-			sizeof(dev->t10_wwn.vendor));
-		strlcpy(dev->t10_wwn.model, dev->transport->inquiry_prod,
-			sizeof(dev->t10_wwn.model));
-		strlcpy(dev->t10_wwn.revision, dev->transport->inquiry_rev,
-			sizeof(dev->t10_wwn.revision));
-	}
-
 	scsi_dump_inquiry(dev);
 
 	spin_lock(&hba->device_lock);
-- 
2.13.7
