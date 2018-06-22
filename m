From: Mike Christie <mchristi@redhat.com>
Date: Fri, 22 Jun 2018 21:40:23 +0000
Subject: [PATCH 6/6] target: remove target_find_device
Message-Id: <1529703623-9606-7-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

target_find_device is no longer used, so remove it.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_device.c  | 24 ------------------------
 include/target/target_core_backend.h |  2 --
 2 files changed, 26 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index e27db4d..a9ad6ec 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -879,30 +879,6 @@ sector_t target_to_linux_sector(struct se_device *dev, sector_t lb)
 }
 EXPORT_SYMBOL(target_to_linux_sector);
 
-/**
- * target_find_device - find a se_device by its dev_index
- * @id: dev_index
- * @do_depend: true if caller needs target_depend_item to be done
- *
- * If do_depend is true, the caller must do a target_undepend_item
- * when finished using the device.
- *
- * If do_depend is false, the caller must be called in a configfs
- * callback or during removal.
- */
-struct se_device *target_find_device(int id, bool do_depend)
-{
-	struct se_device *dev;
-
-	mutex_lock(&device_mutex);
-	dev = idr_find(&devices_idr, id);
-	if (dev && do_depend && target_depend_item(&dev->dev_group.cg_item))
-		dev = NULL;
-	mutex_unlock(&device_mutex);
-	return dev;
-}
-EXPORT_SYMBOL(target_find_device);
-
 struct devices_idr_iter {
 	int (*fn)(struct se_device *dev, void *data);
 	void *data;
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 34a15d5..c3ac472 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -106,8 +106,6 @@ bool	target_lun_is_rdonly(struct se_cmd *);
 sense_reason_t passthrough_parse_cdb(struct se_cmd *cmd,
 	sense_reason_t (*exec_cmd)(struct se_cmd *cmd));
 
-struct	se_device *target_find_device(int id, bool do_depend);
-
 bool target_sense_desc_format(struct se_device *dev);
 sector_t target_to_linux_sector(struct se_device *dev, sector_t lb);
 bool target_configure_unmap_from_queue(struct se_dev_attrib *attrib,
-- 
2.7.2

