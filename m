From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Date: Mon, 27 Apr 2020 15:08:21 +0000
Subject: [PATCH 2/4] target: tcmu: add attrbutes enforce_pr_isids and force_pr_aptpl
Message-Id: <20200427150823.15350-3-bstroesser@ts.fujitsu.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200427150823.15350-1-bstroesser@ts.fujitsu.com>
In-Reply-To: <20200427150823.15350-1-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: mchristi@redhat.com, ddiss@suse.de, hch@lst.de, martin.petersen@oracle.com, Bodo Stroesser <bstroesser@ts.fujitsu.com>

tcmu has not set TRANSPORT_FLAG_PASSTHROUGH_PGR. Therefore the
in core pr emulation is active by default, but there are some
attributes for configuration missing. So we add them now.

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
---
 drivers/target/target_core_configfs.c | 11 +++++++++++
 drivers/target/target_core_user.c     | 19 +++++++++----------
 include/target/target_core_backend.h  |  1 +
 3 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index d8589bb39c53..efa92d836946 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1210,6 +1210,17 @@ struct configfs_attribute *passthrough_attrib_attrs[] = {
 };
 EXPORT_SYMBOL(passthrough_attrib_attrs);
 
+/*
+ * pr related dev_attrib attributes for devices passing through CDBs,
+ * but allowing in core pr emulation.
+ */
+struct configfs_attribute *passthrough_pr_attrib_attrs[] = {
+	&attr_enforce_pr_isids,
+	&attr_force_pr_aptpl,
+	NULL,
+};
+EXPORT_SYMBOL(passthrough_pr_attrib_attrs);
+
 TB_CIT_SETUP_DRV(dev_attrib, NULL, NULL);
 TB_CIT_SETUP_DRV(dev_action, NULL, NULL);
 
diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index f769bb1e3735..8adde343182f 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -2753,12 +2753,12 @@ static int __init tcmu_module_init(void)
 		goto out_unreg_device;
 	}
 
-	for (i = 0; passthrough_attrib_attrs[i] != NULL; i++) {
+	for (i = 0; passthrough_attrib_attrs[i] != NULL; i++)
 		len += sizeof(struct configfs_attribute *);
-	}
-	for (i = 0; tcmu_attrib_attrs[i] != NULL; i++) {
+	for (i = 0; passthrough_pr_attrib_attrs[i] != NULL; i++)
+		len += sizeof(struct configfs_attribute *);
+	for (i = 0; tcmu_attrib_attrs[i] != NULL; i++)
 		len += sizeof(struct configfs_attribute *);
-	}
 	len += sizeof(struct configfs_attribute *);
 
 	tcmu_attrs = kzalloc(len, GFP_KERNEL);
@@ -2767,13 +2767,12 @@ static int __init tcmu_module_init(void)
 		goto out_unreg_genl;
 	}
 
-	for (i = 0; passthrough_attrib_attrs[i] != NULL; i++) {
+	for (i = 0; passthrough_attrib_attrs[i] != NULL; i++)
 		tcmu_attrs[i] = passthrough_attrib_attrs[i];
-	}
-	for (k = 0; tcmu_attrib_attrs[k] != NULL; k++) {
-		tcmu_attrs[i] = tcmu_attrib_attrs[k];
-		i++;
-	}
+	for (k = 0; passthrough_pr_attrib_attrs[k] != NULL; k++)
+		tcmu_attrs[i++] = passthrough_pr_attrib_attrs[k];
+	for (k = 0; tcmu_attrib_attrs[k] != NULL; k++)
+		tcmu_attrs[i++] = tcmu_attrib_attrs[k];
 	tcmu_ops.tb_dev_attrib_attrs = tcmu_attrs;
 
 	ret = transport_backend_register(&tcmu_ops);
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 1b752d8ea529..8177667eba6d 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -94,6 +94,7 @@ int	transport_set_vpd_ident(struct t10_vpd *, unsigned char *);
 
 extern struct configfs_attribute *sbc_attrib_attrs[];
 extern struct configfs_attribute *passthrough_attrib_attrs[];
+extern struct configfs_attribute *passthrough_pr_attrib_attrs[];
 
 /* core helpers also used by command snooping in pscsi */
 void	*transport_kmap_data_sg(struct se_cmd *);
-- 
2.12.3
