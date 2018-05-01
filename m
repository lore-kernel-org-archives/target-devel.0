From: Andrei Vagin <avagin@openvz.org>
Date: Tue, 01 May 2018 06:48:42 +0000
Subject: [PATCH] target: allow to set a blkio cgroup for a backstore
Message-Id: <20180501064842.4253-1-avagin@openvz.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

The Block I/O (blkio) subsystem controls and monitors access to I/O on
block devices by tasks in cgroups. With the introduced changes, a
backstore will be like a task in a specified group.

One of interesting feature is an ability to set limits on a number of
I/O operations and bytes per seconds.

A new attribute is added for backstores, it is called blkio_cgroup.

If we write 1 to the attribute file, a blkio cgroup from the current
process is attached to the backstore.

If we write 0 to the attribute file, a current group will be detached
from the backstore.

When we know a blkio cgroup the only thing, what we need to do to make it
work, is to set this group for bio-s.

How to use:
 # Create a test backstore
$ targetcli
targetcli shell version 2.1.fb46
Copyright 2011-2013 by Datera, Inc and others.
/backstores/block> create dev=/dev/loop0 loop0
Created block storage object loop0 using /dev/loop0.
/backstores/block> cd /loopback
/loopback> create
Created target naa.50014056fd3f341c.
/loopback> cd naa.50014056fd3f341c/luns
/loopback/naa...fd3f341c/luns> create /backstores/block/loop0
Created LUN 0.
/loopback/naa...fd3f341c/luns> exit

 # Create a test cgroup and set it to a test backstore
$ CG_PATH=/sys/fs/cgroup/blkio/test
$ BS_PATH=/sys/kernel/config/target/core/iblock_0/loop0/attrib/blkio_cgroup
$ mkdir -p $CG_PATH
$ bash -c "echo 0 > $CG_PATH/tasks && echo 1 > $BS_PATH"
$ cat $BS_PATH
/test

 # Set 6 MB/sec for the backstore
$ echo "7:0 6291456" > $CG_PATH/blkio.throttle.read_bps_device

 # Check that everything work as expected
$ dd if=/dev/sda of=/dev/null iflag=direct bs=1M count0
100+0 records in
100+0 records out
104857600 bytes (105 MB, 100 MiB) copied, 16.6958 s, 6.3 MB/s

Signed-off-by: Andrei Vagin <avagin@openvz.org>
---
 drivers/target/target_core_configfs.c | 55 +++++++++++++++++++++++++++++++++++
 drivers/target/target_core_device.c   |  6 ++++
 drivers/target/target_core_iblock.c   | 18 +++++++++++-
 include/target/target_core_base.h     |  2 ++
 4 files changed, 80 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 3f4bf126eed0..62155cbd07cc 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1021,6 +1021,59 @@ static ssize_t queue_depth_store(struct config_item *item,
 	return count;
 }
 
+static ssize_t blkio_cgroup_show(struct config_item *item, char *page)
+{
+	struct se_dev_attrib *da = to_attrib(item);
+	struct se_device *dev = da->da_dev;
+	int rb;
+
+	read_lock(&dev->dev_attrib_lock);
+	if (dev->dev_attrib.blk_css) {
+		rb = cgroup_path(dev->dev_attrib.blk_css->cgroup,
+						page, PAGE_SIZE - 1);
+		if (rb = 0)
+			rb = strlen(page);
+		page[rb] = '\n';
+		page[rb + 1] = 0;
+		rb++;
+	} else
+		rb = 0;
+	read_unlock(&dev->dev_attrib_lock);
+
+	return rb;
+}
+
+static ssize_t blkio_cgroup_store(struct config_item *item,
+		const char *page, size_t count)
+{
+	struct se_dev_attrib *da = to_attrib(item);
+	struct se_device *dev = da->da_dev;
+	struct cgroup_subsys_state *css, *pcss;
+	int ret;
+	u32 val;
+
+	ret = kstrtou32(page, 0, &val);
+	if (ret < 0)
+		return ret;
+
+	if (val > 1)
+		return -EINVAL;
+	if (val = 1)
+		css = task_get_css(current, io_cgrp_id);
+	else
+		css = NULL;
+
+	write_lock(&dev->dev_attrib_lock);
+	pcss = dev->dev_attrib.blk_css;
+	dev->dev_attrib.blk_css = css;
+	write_unlock(&dev->dev_attrib_lock);
+
+	if (pcss)
+		css_put(pcss);
+
+	return count;
+}
+
 static ssize_t optimal_sectors_store(struct config_item *item,
 		const char *page, size_t count)
 {
@@ -1128,6 +1181,7 @@ CONFIGFS_ATTR_RO(, hw_max_sectors);
 CONFIGFS_ATTR(, optimal_sectors);
 CONFIGFS_ATTR_RO(, hw_queue_depth);
 CONFIGFS_ATTR(, queue_depth);
+CONFIGFS_ATTR(, blkio_cgroup);
 CONFIGFS_ATTR(, max_unmap_lba_count);
 CONFIGFS_ATTR(, max_unmap_block_desc_count);
 CONFIGFS_ATTR(, unmap_granularity);
@@ -1168,6 +1222,7 @@ struct configfs_attribute *sbc_attrib_attrs[] = {
 	&attr_optimal_sectors,
 	&attr_hw_queue_depth,
 	&attr_queue_depth,
+	&attr_blkio_cgroup,
 	&attr_max_unmap_lba_count,
 	&attr_max_unmap_block_desc_count,
 	&attr_unmap_granularity,
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index e27db4d45a9d..64274a5a1b32 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -773,6 +773,7 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 	INIT_LIST_HEAD(&dev->delayed_cmd_list);
 	INIT_LIST_HEAD(&dev->state_list);
 	INIT_LIST_HEAD(&dev->qf_cmd_list);
+	rwlock_init(&dev->dev_attrib_lock);
 	spin_lock_init(&dev->execute_task_lock);
 	spin_lock_init(&dev->delayed_cmd_lock);
 	spin_lock_init(&dev->dev_reservation_lock);
@@ -820,6 +821,7 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 	dev->dev_attrib.unmap_zeroes_data  				DA_UNMAP_ZEROES_DATA_DEFAULT;
 	dev->dev_attrib.max_write_same_len = DA_MAX_WRITE_SAME_LEN;
+	dev->dev_attrib.blk_css = NULL;
 
 	xcopy_lun = &dev->xcopy_lun;
 	rcu_assign_pointer(xcopy_lun->lun_se_dev, dev);
@@ -1080,6 +1082,10 @@ void target_free_device(struct se_device *dev)
 	if (dev->transport->free_prot)
 		dev->transport->free_prot(dev);
 
+	if (dev->dev_attrib.blk_css)
+		css_put(dev->dev_attrib.blk_css);
+	dev->dev_attrib.blk_css = NULL;
+
 	dev->transport->free_device(dev);
 }
 
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 07c814c42648..b952eacb84ed 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -35,6 +35,7 @@
 #include <linux/genhd.h>
 #include <linux/file.h>
 #include <linux/module.h>
+#include <linux/cgroup.h>
 #include <scsi/scsi_proto.h>
 #include <asm/unaligned.h>
 
@@ -694,6 +695,7 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	u32 sg_num = sgl_nents;
 	unsigned bio_cnt;
 	int i, op, op_flags = 0;
+	struct cgroup_subsys_state *blk_css = NULL;
 
 	if (data_direction = DMA_TO_DEVICE) {
 		struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
@@ -724,9 +726,17 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 		return 0;
 	}
 
+	read_lock(&dev->dev_attrib_lock);
+	blk_css = dev->dev_attrib.blk_css;
+	if (blk_css)
+		css_get(blk_css);
+	read_unlock(&dev->dev_attrib_lock);
+
 	bio = iblock_get_bio(cmd, block_lba, sgl_nents, op, op_flags);
 	if (!bio)
 		goto fail_free_ibr;
+	if (blk_css)
+		bio_associate_blkcg(bio, blk_css);
 
 	bio_start = bio;
 	bio_list_init(&list);
@@ -752,6 +762,8 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 					     op_flags);
 			if (!bio)
 				goto fail_put_bios;
+			if (blk_css)
+				bio_associate_blkcg(bio, blk_css);
 
 			refcount_inc(&ibr->pending);
 			bio_list_add(&list, bio);
@@ -774,9 +786,13 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 	return 0;
 
 fail_put_bios:
-	while ((bio = bio_list_pop(&list)))
+	while ((bio = bio_list_pop(&list))) {
+		bio_disassociate_task(bio);
 		bio_put(bio);
+	}
 fail_free_ibr:
+	if (blk_css)
+		css_put(blk_css);
 	kfree(ibr);
 fail:
 	return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 9f9f5902af38..014bee5657b4 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -688,6 +688,7 @@ struct se_dev_attrib {
 	u32		max_bytes_per_io;
 	struct se_device *da_dev;
 	struct config_group da_group;
+	struct cgroup_subsys_state *blk_css;
 };
 
 struct se_port_stat_grps {
@@ -777,6 +778,7 @@ struct se_device {
 	atomic_t		dev_ordered_sync;
 	atomic_t		dev_qf_count;
 	u32			export_count;
+	rwlock_t		dev_attrib_lock;
 	spinlock_t		delayed_cmd_lock;
 	spinlock_t		execute_task_lock;
 	spinlock_t		dev_reservation_lock;
-- 
2.14.3

