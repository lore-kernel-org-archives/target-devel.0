From: Mike Christie <mchristi@redhat.com>
Date: Sat, 21 Oct 2017 00:14:23 +0000
Subject: Re: [PATCH 17/17] tcmu: allow max block and global max blocks to be settable
Message-Id: <59EA915F.3040000@redhat.com>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="------------050803020807070008090000"
List-Id: <target-devel.vger.kernel.org>
References: <1508310852-15366-18-git-send-email-mchristi@redhat.com>
In-Reply-To: <1508310852-15366-18-git-send-email-mchristi@redhat.com>
To: target-devel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050803020807070008090000
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

On 10/18/2017 02:14 AM, Mike Christie wrote:
> Users might have a physical system to a target so they could
> have a lot more than 2 gigs of memory they want to devote to
> tcmu. OTOH, we could be running in a vm and so a 2 gig
> global and 1 gig per dev limit might be too high. This patch
> allows the user to specify the limits.

There was a bug in the configfs/module_param error handling. I am
attaching a updated patch.

Xiubo, if you already started testing, this patch only affects the
configfs/module_param code path and it only happens if you pass in less
than or equal to 0, so you probably do not need to restart any tests
that have been done to the IO paths.

--------------050803020807070008090000
Content-Type: text/x-patch;
 name="0001-tcmu-allow-max-block-and-global-max-blocks-to-be-set.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-tcmu-allow-max-block-and-global-max-blocks-to-be-set.pa";
 filename*1="tch"

From 3cd6d610c8cf0bcecb18998469edd68eff8c3262 Mon Sep 17 00:00:00 2001
From: Mike Christie <mchristi@redhat.com>
Date: Fri, 20 Oct 2017 19:11:32 -0500
Subject: [PATCH] tcmu: allow max block and global max blocks to be settable v2

Users might have a physical system to a target so they could
have a lot more than 2 gigs of memory they want to devote to
tcmu. OTOH, we could be running in a vm and so a 2 gig
global and 1 gig per dev limit might be too high. This patch
allows the user to specify the limits.

---
v2:
Fix error handling during invalid configfs setting.

 drivers/target/target_core_user.c | 153 +++++++++++++++++++++++++++++++-------
 1 file changed, 128 insertions(+), 25 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 52ffe4f..ddcf3c1 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -74,18 +74,17 @@
 
 /*
  * For data area, the block size is PAGE_SIZE and
- * the total size is 256K * PAGE_SIZE.
+ * the total default size is 256K * PAGE_SIZE.
  */
 #define DATA_BLOCK_SIZE PAGE_SIZE
-#define DATA_BLOCK_BITS (256 * 1024)
-#define DATA_SIZE (DATA_BLOCK_BITS * DATA_BLOCK_SIZE)
+#define DATA_BLOCK_SHIFT PAGE_SHIFT
+#define TCMU_MBS_TO_BLOCKS(_mbs) (_mbs << (20 - DATA_BLOCK_SHIFT))
+#define TCMU_BLOCKS_TO_MBS(_blocks) (_blocks >> (20 - DATA_BLOCK_SHIFT))
+#define DEF_DATA_BLOCK_BITS (256 * 1024)
 #define DATA_BLOCK_INIT_BITS 128
 
-/* The total size of the ring is 8M + 256K * PAGE_SIZE */
-#define TCMU_RING_SIZE (CMDR_SIZE + DATA_SIZE)
-
 /* Default maximum of the global data blocks(512K * PAGE_SIZE) */
-#define TCMU_GLOBAL_MAX_BLOCKS (512 * 1024)
+#define DEF_TCMU_GLOBAL_MAX_BLOCKS (512 * 1024)
 
 static u8 tcmu_kern_cmd_reply_supported;
 
@@ -130,6 +129,8 @@ struct tcmu_dev {
 	/* Must add data_off and mb_addr to get the address */
 	size_t data_off;
 	size_t data_size;
+	uint32_t max_blocks;
+	size_t ring_size;
 
 	struct mutex cmdr_lock;
 	struct list_head cmdr_queue;
@@ -137,7 +138,7 @@ struct tcmu_dev {
 	uint32_t waiting_blocks;
 	uint32_t dbi_max;
 	uint32_t dbi_thresh;
-	DECLARE_BITMAP(data_bitmap, DATA_BLOCK_BITS);
+	unsigned long *data_bitmap;
 	struct radix_tree_root data_blocks;
 
 	struct idr commands;
@@ -204,6 +205,51 @@ struct tcmu_cmd {
 static LIST_HEAD(root_udev_waiter);
 
 static atomic_t global_db_count = ATOMIC_INIT(0);
+static int tcmu_global_max_blocks = DEF_TCMU_GLOBAL_MAX_BLOCKS;
+
+static int tcmu_set_global_max_data_area(const char *str,
+					 const struct kernel_param *kp)
+{
+	int ret, max_area_mb;
+
+	mutex_lock(&root_udev_mutex);
+	if (!list_empty(&root_udev)) {
+		mutex_unlock(&root_udev_mutex);
+		pr_err("Cannot set global_max_data_area. Devices are accessing the global page pool\n");
+		return -EINVAL;
+	}
+	mutex_unlock(&root_udev_mutex);
+
+	ret = kstrtoint(str, 10, &max_area_mb);
+	if (ret)
+		return -EINVAL;
+
+	if (max_area_mb <= 0) {
+		pr_err("global_max_data_area must be larger than 0.\n");
+		return -EINVAL;
+	}
+
+	tcmu_global_max_blocks = TCMU_MBS_TO_BLOCKS(max_area_mb);
+	return 0;
+}
+
+static int tcmu_get_global_max_data_area(char *buffer,
+					 const struct kernel_param *kp)
+{
+	return sprintf(buffer, "%d", TCMU_BLOCKS_TO_MBS(tcmu_global_max_blocks));
+}
+
+static const struct kernel_param_ops tcmu_global_max_data_area_op = {
+	.set = tcmu_set_global_max_data_area,
+	.get = tcmu_get_global_max_data_area,
+};
+
+module_param_cb(global_max_data_area_mb, &tcmu_global_max_data_area_op, NULL,
+		S_IWUSR | S_IRUGO);
+MODULE_PARM_DESC(global_max_data_area_mb,
+		 "Max MBs allowed to be allocated to all the tcmu device's "
+		 "data areas.");
+
 struct work_struct tcmu_unmap_work;
 
 static struct kmem_cache *tcmu_cmd_cache;
@@ -368,7 +414,7 @@ static inline bool tcmu_get_empty_block(struct tcmu_dev *udev,
 	page = radix_tree_lookup(&udev->data_blocks, dbi);
 	if (!page) {
 		if (atomic_add_return(1, &global_db_count) >
-					TCMU_GLOBAL_MAX_BLOCKS) {
+				      tcmu_global_max_blocks) {
 			atomic_dec(&global_db_count);
 			return false;
 		}
@@ -716,8 +762,8 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 	/* try to check and get the data blocks as needed */
 	space = spc_bitmap_free(udev->data_bitmap, udev->dbi_thresh);
 	if ((space * DATA_BLOCK_SIZE) < data_needed) {
-		unsigned long blocks_left = DATA_BLOCK_BITS - udev->dbi_thresh +
-						space;
+		unsigned long blocks_left = udev->max_blocks -
+						udev->dbi_thresh + space;
 		unsigned long grow;
 
 		if (blocks_left < blocks_needed) {
@@ -737,12 +783,12 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 			/*
 			 * Grow the data area by max(blocks needed,
 			 * dbi_thresh / 2), but limited to the max
-			 * DATA_BLOCK_BITS size.
+			 * udev max_blocks size.
 			 */
 			grow = max(blocks_needed, udev->dbi_thresh / 2);
 			udev->dbi_thresh += grow;
-			if (udev->dbi_thresh > DATA_BLOCK_BITS)
-				udev->dbi_thresh = DATA_BLOCK_BITS;
+			if (udev->dbi_thresh > udev->max_blocks)
+				udev->dbi_thresh = udev->max_blocks;
 		}
 	}
 
@@ -1204,7 +1250,7 @@ static struct se_device *tcmu_alloc_device(struct se_hba *hba, const char *name)
 	udev->cmd_time_out = TCMU_TIME_OUT;
 	/* for backwards compat use the cmd_time_out */
 	udev->qfull_time_out = TCMU_TIME_OUT;
-
+	udev->max_blocks = DEF_DATA_BLOCK_BITS;
 	mutex_init(&udev->cmdr_lock);
 
 	INIT_LIST_HEAD(&udev->timedout_entry);
@@ -1289,7 +1335,7 @@ static int tcmu_irqcontrol(struct uio_info *info, s32 irq_on)
 
 	mutex_lock(&udev->cmdr_lock);
 
-	if (atomic_read(&global_db_count) == TCMU_GLOBAL_MAX_BLOCKS) {
+	if (atomic_read(&global_db_count) == tcmu_global_max_blocks) {
 		spin_lock(&root_udev_waiter_lock);
 		if (!list_empty(&root_udev_waiter)) {
 			/*
@@ -1377,7 +1423,7 @@ static struct page *tcmu_try_get_block_page(struct tcmu_dev *udev, uint32_t dbi)
 
 		/*
 		 * Since this case is rare in page fault routine, here we
-		 * will allow the global_db_count >= TCMU_GLOBAL_MAX_BLOCKS
+		 * will allow the global_db_count >= tcmu_global_max_blocks
 		 * to reduce possible page fault call trace.
 		 */
 		atomic_inc(&global_db_count);
@@ -1438,7 +1484,7 @@ static int tcmu_mmap(struct uio_info *info, struct vm_area_struct *vma)
 	vma->vm_private_data = udev;
 
 	/* Ensure the mmap is exactly the right size */
-	if (vma_pages(vma) != (TCMU_RING_SIZE >> PAGE_SHIFT))
+	if (vma_pages(vma) != (udev->ring_size >> PAGE_SHIFT))
 		return -EINVAL;
 
 	return 0;
@@ -1520,6 +1566,7 @@ static void tcmu_dev_kref_release(struct kref *kref)
 	WARN_ON(!all_expired);
 
 	tcmu_blocks_release(&udev->data_blocks, 0, udev->dbi_max + 1);
+	kfree(udev->data_bitmap);
 	mutex_unlock(&udev->cmdr_lock);
 
 	call_rcu(&dev->rcu_head, tcmu_dev_call_rcu);
@@ -1696,6 +1743,11 @@ static int tcmu_configure_device(struct se_device *dev)
 
 	info = &udev->uio_info;
 
+	udev->data_bitmap = kzalloc(BITS_TO_LONGS(udev->max_blocks) *
+				    sizeof(unsigned long), GFP_KERNEL);
+	if (!udev->data_bitmap)
+		goto err_bitmap_alloc;
+
 	udev->mb_addr = vzalloc(CMDR_SIZE);
 	if (!udev->mb_addr) {
 		ret = -ENOMEM;
@@ -1705,7 +1757,7 @@ static int tcmu_configure_device(struct se_device *dev)
 	/* mailbox fits in first part of CMDR space */
 	udev->cmdr_size = CMDR_SIZE - CMDR_OFF;
 	udev->data_off = CMDR_SIZE;
-	udev->data_size = DATA_SIZE;
+	udev->data_size = udev->max_blocks * DATA_BLOCK_SIZE;
 	udev->dbi_thresh = 0; /* Default in Idle state */
 	udev->waiting_blocks = 0;
 
@@ -1724,7 +1776,7 @@ static int tcmu_configure_device(struct se_device *dev)
 
 	info->mem[0].name = "tcm-user command & data buffer";
 	info->mem[0].addr = (phys_addr_t)(uintptr_t)udev->mb_addr;
-	info->mem[0].size = TCMU_RING_SIZE;
+	info->mem[0].size = udev->ring_size = udev->data_size + CMDR_SIZE;
 	info->mem[0].memtype = UIO_MEM_NONE;
 
 	info->irqcontrol = tcmu_irqcontrol;
@@ -1777,6 +1829,9 @@ static int tcmu_configure_device(struct se_device *dev)
 	vfree(udev->mb_addr);
 	udev->mb_addr = NULL;
 err_vzalloc:
+	kfree(udev->data_bitmap);
+	udev->data_bitmap = NULL;
+err_bitmap_alloc:
 	kfree(info->name);
 	info->name = NULL;
 
@@ -1822,7 +1877,7 @@ static void tcmu_destroy_device(struct se_device *dev)
 
 enum {
 	Opt_dev_config, Opt_dev_size, Opt_hw_block_size, Opt_hw_max_sectors,
-	Opt_nl_reply_supported, Opt_err,
+	Opt_nl_reply_supported, Opt_max_data_area_mb, Opt_err,
 };
 
 static match_table_t tokens = {
@@ -1831,6 +1886,7 @@ enum {
 	{Opt_hw_block_size, "hw_block_size=%u"},
 	{Opt_hw_max_sectors, "hw_max_sectors=%u"},
 	{Opt_nl_reply_supported, "nl_reply_supported=%d"},
+	{Opt_max_data_area_mb, "max_data_area_mb=%u"},
 	{Opt_err, NULL}
 };
 
@@ -1864,7 +1920,7 @@ static ssize_t tcmu_set_configfs_dev_params(struct se_device *dev,
 	struct tcmu_dev *udev = TCMU_DEV(dev);
 	char *orig, *ptr, *opts, *arg_p;
 	substring_t args[MAX_OPT_ARGS];
-	int ret = 0, token;
+	int ret = 0, token, tmpval;
 
 	opts = kstrdup(page, GFP_KERNEL);
 	if (!opts)
@@ -1916,6 +1972,39 @@ static ssize_t tcmu_set_configfs_dev_params(struct se_device *dev,
 			if (ret < 0)
 				pr_err("kstrtoint() failed for nl_reply_supported=\n");
 			break;
+		case Opt_max_data_area_mb:
+			if (dev->export_count) {
+				pr_err("Unable to set max_data_area_mb while exports exist\n");
+				ret = -EINVAL;
+				break;
+			}
+
+			arg_p = match_strdup(&args[0]);
+			if (!arg_p) {
+				ret = -ENOMEM;
+				break;
+			}
+			ret = kstrtoint(arg_p, 0, &tmpval);
+			kfree(arg_p);
+			if (ret < 0) {
+				pr_err("kstrtoint() failed for max_data_area_mb=\n");
+				break;
+			}
+
+			if (tmpval <= 0) {
+				pr_err("Invalid max_data_area %d\n", tmpval);
+				ret = -EINVAL;
+				break;
+			}
+
+			udev->max_blocks = TCMU_MBS_TO_BLOCKS(tmpval);
+			if (udev->max_blocks > tcmu_global_max_blocks) {
+				pr_err("%d is too large. Adjusting max_data_area_mb to global limit of %u\n",
+				       tmpval,
+				       TCMU_BLOCKS_TO_MBS(tcmu_global_max_blocks));
+				udev->max_blocks = tcmu_global_max_blocks;
+			}
+			break;
 		default:
 			break;
 		}
@@ -1935,7 +2024,9 @@ static ssize_t tcmu_show_configfs_dev_params(struct se_device *dev, char *b)
 
 	bl = sprintf(b + bl, "Config: %s ",
 		     udev->dev_config[0] ? udev->dev_config : "NULL");
-	bl += sprintf(b + bl, "Size: %zu\n", udev->dev_size);
+	bl += sprintf(b + bl, "Size: %zu ", udev->dev_size);
+	bl += sprintf(b + bl, "MaxDataAreaMB: %u\n",
+		      TCMU_BLOCKS_TO_MBS(udev->max_blocks));
 
 	return bl;
 }
@@ -2019,6 +2110,17 @@ static ssize_t tcmu_qfull_time_out_store(struct config_item *item,
 }
 CONFIGFS_ATTR(tcmu_, qfull_time_out);
 
+static ssize_t tcmu_max_data_area_mb_show(struct config_item *item, char *page)
+{
+	struct se_dev_attrib *da = container_of(to_config_group(item),
+						struct se_dev_attrib, da_group);
+	struct tcmu_dev *udev = TCMU_DEV(da->da_dev);
+
+	return snprintf(page, PAGE_SIZE, "%u\n",
+			TCMU_BLOCKS_TO_MBS(udev->max_blocks));
+}
+CONFIGFS_ATTR_RO(tcmu_, max_data_area_mb);
+
 static ssize_t tcmu_dev_config_show(struct config_item *item, char *page)
 {
 	struct se_dev_attrib *da = container_of(to_config_group(item),
@@ -2165,6 +2267,7 @@ static ssize_t tcmu_emulate_write_cache_store(struct config_item *item,
 static struct configfs_attribute *tcmu_attrib_attrs[] = {
 	&tcmu_attr_cmd_time_out,
 	&tcmu_attr_qfull_time_out,
+	&tcmu_attr_max_data_area_mb,
 	&tcmu_attr_dev_config,
 	&tcmu_attr_dev_size,
 	&tcmu_attr_emulate_write_cache,
@@ -2248,7 +2351,7 @@ static uint32_t find_free_blocks(void)
 		if (tcmu_waiting_on_dev_blocks(udev)) {
 			/*
 			 * if we had to take pages from a dev that hit its
-			 * DATA_BLOCK_BITS limit put it on the waiter
+			 * max_blocks limit put it on the waiter
 			 * list so it gets rescheduled when pages are free.
 			 */
 			spin_lock(&root_udev_waiter_lock);
@@ -2289,7 +2392,7 @@ static bool run_cmdr_queues(void)
 	list_for_each_entry_safe(udev, tmp_udev, &devs, waiter) {
 		list_del_init(&udev->waiter);
 
-		free_blocks = TCMU_GLOBAL_MAX_BLOCKS -
+		free_blocks = tcmu_global_max_blocks -
 						atomic_read(&global_db_count);
 		pr_debug("checking cmdr queue for %s: blocks waiting %u free db count %u\n",
 			 udev->name, udev->waiting_blocks, free_blocks);
-- 
1.8.3.1


--------------050803020807070008090000--
