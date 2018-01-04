From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Date: Thu, 04 Jan 2018 16:11:00 +0000
Subject: [PATCH] tcmu: Allow reconfig to handle multiple attributes
Message-Id: <20180104161100.15330-1-bryantly@linux.vnet.ibm.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-4"
Content-Transfer-Encoding: quoted-printable
To: mchristi@redhat.com, nab@linux-iscsi.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>

This patch allows for multiple attributes to be reconfigured
and handled all in one call as compared to multiple netlinks.

Example:
set attribute dev_reconfig=DEv_config=FBo//home/path:dev_size!47483648

Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
---
 drivers/target/target_core_user.c     | 92 +++++++++++++++++++++++++++++++=
+++-
 include/uapi/linux/target_core_user.h |  1 +
 2 files changed, 92 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core=
_user.c
index 4824abf92ed79..619fae5e865f1 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -152,6 +152,8 @@ struct tcmu_dev {
 	char dev_config[TCMU_CONFIG_LEN];
=20
 	int nl_reply_supported;
+
+	char dev_reconfig[TCMU_CONFIG_LEN * 2];
 };
=20
 #define TCMU_DEV(_se_dev) container_of(_se_dev, struct tcmu_dev, se_dev)
@@ -1452,6 +1454,10 @@ static int tcmu_netlink_event(struct tcmu_dev *udev,=
 enum tcmu_genl_cmd cmd,
 			ret =3D nla_put_u8(skb, reconfig_attr,
 					  *((u8 *)reconfig_data));
 			break;
+		case TCMU_ATTR_DEV_RECFG:
+			pr_err("Put string into netlink and send it\n");
+			ret =3D nla_put_string(skb, reconfig_attr, reconfig_data);
+			break;
 		default:
 			BUG();
 		}
@@ -1637,7 +1643,7 @@ static void tcmu_destroy_device(struct se_device *dev)
=20
 enum {
 	Opt_dev_config, Opt_dev_size, Opt_hw_block_size, Opt_hw_max_sectors,
-	Opt_nl_reply_supported, Opt_err,
+	Opt_nl_reply_supported, Opt_dev_reconfig, Opt_err,
 };
=20
 static match_table_t tokens =3D {
@@ -1646,6 +1652,7 @@ static match_table_t tokens =3D {
 	{Opt_hw_block_size, "hw_block_size=3D%u"},
 	{Opt_hw_max_sectors, "hw_max_sectors=3D%u"},
 	{Opt_nl_reply_supported, "nl_reply_supported=3D%d"},
+	{Opt_dev_reconfig, "dev_reconfig=3D%s"},
 	{Opt_err, NULL}
 };
=20
@@ -1731,6 +1738,14 @@ static ssize_t tcmu_set_configfs_dev_params(struct s=
e_device *dev,
 			if (ret < 0)
 				pr_err("kstrtoint() failed for nl_reply_supported=3D\n");
 			break;
+		case Opt_dev_reconfig:
+			arg_p =3D match_strdup(&args[0]);
+			if (!arg_p) {
+				ret =3D -ENOMEM;
+				break;
+			}
+			kfree(arg_p);
+			break;
 		default:
 			break;
 		}
@@ -1945,12 +1960,87 @@ static ssize_t tcmu_emulate_write_cache_store(struc=
t config_item *item,
 }
 CONFIGFS_ATTR(tcmu_, emulate_write_cache);
=20
+static ssize_t tcmu_dev_reconfig_show(struct config_item *item, char *page)
+{
+	struct se_dev_attrib *da =3D container_of(to_config_group(item),
+						struct se_dev_attrib, da_group);
+	struct tcmu_dev *udev =3D TCMU_DEV(da->da_dev);
+
+	return snprintf(page, PAGE_SIZE, "%s\n", udev->dev_reconfig);
+}
+
+static ssize_t tcmu_dev_reconfig_store(struct config_item *item,
+				       const char *page,
+				       size_t count)
+{
+	struct se_dev_attrib *da =3D container_of(to_config_group(item),
+						struct se_dev_attrib, da_group);
+	struct tcmu_dev *udev =3D TCMU_DEV(da->da_dev);
+	int token, ret;
+	char *orig, *ptr, *opts, *arg_p;
+	substring_t args[MAX_OPT_ARGS];
+
+	/* Check if device has been configured before */
+	if (tcmu_dev_configured(udev)) {
+		ret =3D tcmu_netlink_event(udev, TCMU_CMD_RECONFIG_DEVICE,
+					 TCMU_ATTR_DEV_RECFG, page);
+		if (ret) {
+			pr_err("Unable to reconfigure device\n");
+			return ret;
+		}
+
+		opts =3D kstrdup(page, GFP_KERNEL);
+		if (!opts)
+			return -ENOMEM;
+
+		orig =3D opts;
+		strcpy(udev->dev_reconfig, opts);
+
+		while ((ptr =3D strsep(&opts, ":")) !=3D NULL) {
+			if (!*ptr)
+				continue;
+
+			token =3D match_token(ptr, tokens, args);
+			switch (token) {
+			case Opt_dev_config:
+				if (match_strlcpy(udev->dev_config, &args[0],
+						  TCMU_CONFIG_LEN) =3D 0) {
+					pr_err("Could not reconfigure dev_config");
+				}
+				ret =3D tcmu_update_uio_info(udev);
+				if (ret)
+					pr_err("Could not reconfigure dev_config");
+				break;
+			case Opt_dev_size:
+				arg_p =3D match_strdup(&args[0]);
+				if (!arg_p)
+					pr_err("Could not reconfigure dev_size");
+				ret =3D kstrtoul(arg_p, 0,
+					       (unsigned long *)&udev->dev_size);
+				kfree(arg_p);
+				if (ret < 0)
+					pr_err("kstrtoul() failed for dev_size=3D\n");
+
+				pr_err("found dev_size");
+				break;
+			default:
+				break;
+			}
+		}
+		return count;
+	}
+
+	return count;
+}
+CONFIGFS_ATTR(tcmu_, dev_reconfig);
+
 static struct configfs_attribute *tcmu_attrib_attrs[] =3D {
 	&tcmu_attr_cmd_time_out,
 	&tcmu_attr_dev_config,
 	&tcmu_attr_dev_size,
 	&tcmu_attr_emulate_write_cache,
 	&tcmu_attr_nl_reply_supported,
+	&tcmu_attr_dev_reconfig,
 	NULL,
 };
=20
diff --git a/include/uapi/linux/target_core_user.h b/include/uapi/linux/tar=
get_core_user.h
index aff57a0b29a6c..068b088f51f77 100644
--- a/include/uapi/linux/target_core_user.h
+++ b/include/uapi/linux/target_core_user.h
@@ -150,6 +150,7 @@ enum tcmu_genl_attr {
 	TCMU_ATTR_CMD_STATUS,
 	TCMU_ATTR_DEVICE_ID,
 	TCMU_ATTR_SUPP_KERN_CMD_REPLY,
+	TCMU_ATTR_DEV_RECFG,
 	__TCMU_ATTR_MAX,
 };
 #define TCMU_ATTR_MAX (__TCMU_ATTR_MAX - 1)
--=20
2.14.3 (Apple Git-98)

