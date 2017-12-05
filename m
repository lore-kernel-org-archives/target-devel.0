From: David Disseldorp <ddiss@suse.de>
Date: Tue, 05 Dec 2017 20:54:42 +0000
Subject: [RFC PATCH] target: detect read-only from underlying iblock device
Message-Id: <20171205205442.25414-1-ddiss@suse.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

A read-only block device must currently be flagged as such when
configuring the iblock backstore, via a readonly=1 configfs parameter.
If a read-only block device is used without explicitly providing the
parameter, then backstore enablement fails with EACCES, e.g.
  losetup --read-only /dev/loop0 /lofile
  mkdir -p /sys/kernel/config/target/core/iblock_0/loopy
  echo "udev_path=/dev/loop0" \
	> /sys/kernel/config/target/core/iblock_0/loopy/control
  echo "1" > /sys/kernel/config/target/core/iblock_0/loopy/enable
  sh: echo: write error: Permission denied

This change allows an iblock backstore to be demoted to read-only if the
underlying device is detected as such, via a -EACCES return value from
blkdev_get_by_path(udev_path=$readonly_device, mode & FMODE_WRITE, ...).

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 drivers/target/target_core_iblock.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 07c814c42648..cafba262a440 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -103,6 +103,7 @@ static int iblock_configure_device(struct se_device *dev)
 	pr_debug( "IBLOCK: Claiming struct block_device: %s\n",
 			ib_dev->ibd_udev_path);
 
+ro_fallback:
 	mode = FMODE_READ|FMODE_EXCL;
 	if (!ib_dev->ibd_readonly)
 		mode |= FMODE_WRITE;
@@ -112,6 +113,17 @@ static int iblock_configure_device(struct se_device *dev)
 	bd = blkdev_get_by_path(ib_dev->ibd_udev_path, mode, ib_dev);
 	if (IS_ERR(bd)) {
 		ret = PTR_ERR(bd);
+		if (!ib_dev->ibd_readonly && (ret = -EACCES)) {
+			/*
+			 * EACCES is returned if FMODE_WRITE is set while
+			 * getting a read-only block device. Try once again
+			 * without FMODE_WRITE to allow for configuration of a
+			 * read-only block device without an explicit readonly=1
+			 * configfs parameter in iblock_set_configfs_dev_params().
+			 */
+			ib_dev->ibd_readonly = 1;
+			goto ro_fallback;
+		}
 		goto out_free_bioset;
 	}
 	ib_dev->ibd_bd = bd;
-- 
2.13.6

