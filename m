From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Date: Fri, 03 Apr 2020 14:32:14 +0000
Subject: [PATCH 2/2] target: make pgr_support and alua_support attributes writable
Message-Id: <20200403143214.18303-3-bstroesser@ts.fujitsu.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Currently in tcmu reservation commands are handled by core's
pr implementation (default) or completely rejected (emulate_pr
set to 0). We additionally want to be able to do full
reservation handling in userspace. Therefore we need a way to
set the TRANSPORT_FLAG_PASSTHROUGH_PGR.
The inverted flag is displayed by attribute pgr_support.
Since we moved the flag from transport/backend to se_device in
the previous patch, we now can make it changeable per device by
allowing to write the attribute.
The new field transport_flags_changeable in transport/backend
is used to reject writing if not allowed for a backend.

I think, that it also makes sense to allow to reset
TRANSPORT_FLAG_PASSTHROUGH_PGR in pscsi, which is set by default,
because this enables usage of core's pr implementation in pscsi.

Regarding ALUA we also want to be able to passthrough commands
to userspace in tcmu. Therefore we want
TRANSPORT_FLAG_PASSTHROUGH_ALUA to be changeable, because
by setting it we can switch off all ALUA checks in core. So we
also need to set TRANSPORT_FLAG_PASSTHROUGH_ALUA in tcmu's
transport_flags_changeable.

For pscsi, we do not allow to change / reset
TRANSPORT_FLAG_PASSTHROUGH_ALUA, because ALUA is not implemented
in passthrough_parse_cdb() yet.

Of course, ALUA and reservation handling in userspace will work
only, if session/nexus information is sent to userspace along with
every command. This will be object of a following patch or patch
series.

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
---
 drivers/target/target_core_configfs.c | 56 +++++++++++++++++++++++++++++++++--
 drivers/target/target_core_pscsi.c    |  1 +
 drivers/target/target_core_user.c     |  2 ++
 include/target/target_core_backend.h  |  1 +
 4 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 074614e19f9e..337bc12c890b 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1105,6 +1105,32 @@ static ssize_t alua_support_show(struct config_item *item, char *page)
 			flags & TRANSPORT_FLAG_PASSTHROUGH_ALUA ? 0 : 1);
 }
 
+static ssize_t alua_support_store(struct config_item *item,
+		const char *page, size_t count)
+{
+	struct se_dev_attrib *da = to_attrib(item);
+	struct se_device *dev = da->da_dev;
+	bool flag;
+	int ret;
+
+	if (!(dev->transport->transport_flags_changeable &
+	      TRANSPORT_FLAG_PASSTHROUGH_ALUA)) {
+		pr_err("dev[%p]: Unable to change SE Device alua_support:"
+			" alua_support has fixed value\n", dev);
+		return -EINVAL;
+	}
+
+	ret = strtobool(page, &flag);
+	if (ret < 0)
+		return ret;
+
+	if (flag)
+		dev->transport_flags &= ~TRANSPORT_FLAG_PASSTHROUGH_ALUA;
+	else
+		dev->transport_flags |= TRANSPORT_FLAG_PASSTHROUGH_ALUA;
+	return count;
+}
+
 static ssize_t pgr_support_show(struct config_item *item, char *page)
 {
 	struct se_dev_attrib *da = to_attrib(item);
@@ -1114,6 +1140,32 @@ static ssize_t pgr_support_show(struct config_item *item, char *page)
 			flags & TRANSPORT_FLAG_PASSTHROUGH_PGR ? 0 : 1);
 }
 
+static ssize_t pgr_support_store(struct config_item *item,
+		const char *page, size_t count)
+{
+	struct se_dev_attrib *da = to_attrib(item);
+	struct se_device *dev = da->da_dev;
+	bool flag;
+	int ret;
+
+	if (!(dev->transport->transport_flags_changeable &
+	      TRANSPORT_FLAG_PASSTHROUGH_PGR)) {
+		pr_err("dev[%p]: Unable to change SE Device pgr_support:"
+			" pgr_support has fixed value\n", dev);
+		return -EINVAL;
+	}
+
+	ret = strtobool(page, &flag);
+	if (ret < 0)
+		return ret;
+
+	if (flag)
+		dev->transport_flags &= ~TRANSPORT_FLAG_PASSTHROUGH_PGR;
+	else
+		dev->transport_flags |= TRANSPORT_FLAG_PASSTHROUGH_PGR;
+	return count;
+}
+
 CONFIGFS_ATTR(, emulate_model_alias);
 CONFIGFS_ATTR(, emulate_dpo);
 CONFIGFS_ATTR(, emulate_fua_write);
@@ -1146,8 +1198,8 @@ CONFIGFS_ATTR(, unmap_granularity);
 CONFIGFS_ATTR(, unmap_granularity_alignment);
 CONFIGFS_ATTR(, unmap_zeroes_data);
 CONFIGFS_ATTR(, max_write_same_len);
-CONFIGFS_ATTR_RO(, alua_support);
-CONFIGFS_ATTR_RO(, pgr_support);
+CONFIGFS_ATTR(, alua_support);
+CONFIGFS_ATTR(, pgr_support);
 
 /*
  * dev_attrib attributes for devices using the target core SBC/SPC
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 4e37fa9b409d..e7d92ef43ca4 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -1073,6 +1073,7 @@ static const struct target_backend_ops pscsi_ops = {
 	.transport_flags_default = TRANSPORT_FLAG_PASSTHROUGH |
 				   TRANSPORT_FLAG_PASSTHROUGH_ALUA |
 				   TRANSPORT_FLAG_PASSTHROUGH_PGR,
+	.transport_flags_changeable = TRANSPORT_FLAG_PASSTHROUGH_PGR,
 	.attach_hba		= pscsi_attach_hba,
 	.detach_hba		= pscsi_detach_hba,
 	.pmode_enable_hba	= pscsi_pmode_enable_hba,
diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 8251f0c734cc..d6ddc95a6331 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -2617,6 +2617,8 @@ static struct target_backend_ops tcmu_ops = {
 	.name			= "user",
 	.owner			= THIS_MODULE,
 	.transport_flags_default = TRANSPORT_FLAG_PASSTHROUGH,
+	.transport_flags_changeable = TRANSPORT_FLAG_PASSTHROUGH_PGR |
+	                              TRANSPORT_FLAG_PASSTHROUGH_ALUA,
 	.attach_hba		= tcmu_attach_hba,
 	.detach_hba		= tcmu_detach_hba,
 	.alloc_device		= tcmu_alloc_device,
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 9d1c16d24edf..6468c5a7c9d1 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -24,6 +24,7 @@ struct target_backend_ops {
 	struct module *owner;
 
 	u8 transport_flags_default;
+	u8 transport_flags_changeable;
 
 	int (*attach_hba)(struct se_hba *, u32);
 	void (*detach_hba)(struct se_hba *);
-- 
2.12.3
