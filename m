From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 08 Nov 2017 08:43:44 +0000
Subject: [PATCH 1/2] tcmu: Fix some memory corruption
Message-Id: <20171108084344.hmqtb5k2puzh3sc6@mwanda>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Kenjiro Nakayama <nakayamakenjiro@gmail.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org

"udev->nl_reply_supported" is an int but on 64 bit arches we are writing
8 bytes of data to it so it corrupts four bytes beyond the end of the
struct.

Fixes: b849b4567549 ("target: Add netlink command reply supported option for each device")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 3be4c9696d19..07f2d95f7ae7 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1724,11 +1724,10 @@ static ssize_t tcmu_set_configfs_dev_params(struct se_device *dev,
 				ret = -ENOMEM;
 				break;
 			}
-			ret = kstrtol(arg_p, 0,
-					(long int *) &udev->nl_reply_supported);
+			ret = kstrtoint(arg_p, 0, &udev->nl_reply_supported);
 			kfree(arg_p);
 			if (ret < 0)
-				pr_err("kstrtoul() failed for nl_reply_supported=\n");
+				pr_err("kstrtoint() failed for nl_reply_supported=\n");
 			break;
 		default:
 			break;
