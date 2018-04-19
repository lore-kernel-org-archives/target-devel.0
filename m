From: xiubli@redhat.com
Date: Thu, 19 Apr 2018 07:46:03 +0000
Subject: [PATCHv4 2/3] target: adjust and export target_for_each_device visible to modules
Message-Id: <1524123964-21347-3-git-send-email-xiubli@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Make the target_for_each_device could list all the devices not only
configured as needed.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 drivers/target/target_core_device.c   | 10 +---------
 drivers/target/target_core_internal.h |  2 --
 drivers/target/target_core_xcopy.c    |  3 +++
 include/target/target_core_backend.h  |  3 +++
 4 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index e27db4d..58508a2 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -913,15 +913,6 @@ static int target_devices_idr_iter(int id, void *p, void *data)
 	struct devices_idr_iter *iter = data;
 	struct se_device *dev = p;
 
-	/*
-	 * We add the device early to the idr, so it can be used
-	 * by backend modules during configuration. We do not want
-	 * to allow other callers to access partially setup devices,
-	 * so we skip them here.
-	 */
-	if (!(dev->dev_flags & DF_CONFIGURED))
-		return 0;
-
 	return iter->fn(dev, iter->data);
 }
 
@@ -947,6 +938,7 @@ int target_for_each_device(int (*fn)(struct se_device *dev, void *data),
 	mutex_unlock(&device_mutex);
 	return ret;
 }
+EXPORT_SYMBOL(target_for_each_device);
 
 int target_configure_device(struct se_device *dev)
 {
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 73e8157..2f22aee 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -89,8 +89,6 @@ void	core_dev_free_initiator_node_lun_acl(struct se_portal_group *,
 struct se_device *target_alloc_device(struct se_hba *hba, const char *name);
 int	target_configure_device(struct se_device *dev);
 void	target_free_device(struct se_device *);
-int	target_for_each_device(int (*fn)(struct se_device *dev, void *data),
-			       void *data);
 
 /* target_core_configfs.c */
 extern struct configfs_item_operations target_core_dev_item_ops;
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 9ee89e0..cb9cc1e 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -67,6 +67,9 @@ static int target_xcopy_locate_se_dev_e4_iter(struct se_device *se_dev,
 	unsigned char tmp_dev_wwn[XCOPY_NAA_IEEE_REGEX_LEN];
 	int rc;
 
+	if (!(se_dev->dev_flags & DF_CONFIGURED))
+		return 0;
+
 	if (!se_dev->dev_attrib.emulate_3pc)
 		return 0;
 
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 5df7059..7451d65 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -109,6 +109,9 @@ sense_reason_t passthrough_parse_cdb(struct se_cmd *cmd,
 
 struct	se_device *target_find_device(int id, bool do_depend);
 
+int	target_for_each_device(int (*fn)(struct se_device *dev, void *data),
+			       void *data);
+
 bool target_sense_desc_format(struct se_device *dev);
 sector_t target_to_linux_sector(struct se_device *dev, sector_t lb);
 bool target_configure_unmap_from_queue(struct se_dev_attrib *attrib,
-- 
1.8.3.1

