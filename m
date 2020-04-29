From: Roman Bolshakov <r.bolshakov@yadro.com>
Date: Wed, 29 Apr 2020 09:44:41 +0000
Subject: [RFC PATCH 08/11] scsi: target/core: Add RTPI attribute for target port
Message-Id: <20200429094443.43937-9-r.bolshakov@yadro.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200429094443.43937-1-r.bolshakov@yadro.com>
In-Reply-To: <20200429094443.43937-1-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org, Mike Christie <mchristi@redhat.com>, Bart Van Assche <bvanassche@acm.org>, David Disseldorp <ddiss@suse.de>
Cc: linux-scsi@vger.kernel.org, linux@yadro.com, Roman Bolshakov <r.bolshakov@yadro.com>

RELATIVE TARGET PORT IDENTIFIER can be read and configured via configfs:
$ echo 0x10 > $TARGET/tpgt_N/attrib/rtpi

RTPI has to be unique among all target ports, otherwise the write fails.

Configuration of a new RTPI value triggers INQUIRY DATA HAS CHANGED unit
attention as defined in SPC-4 "6.6.1 INQUIRY command introduction":

> If INQUIRY data changes for any reason, the device server shall
> establish a unit attention condition for the initiator port associated
> with every I_T nexus (see SAM-5), with the additional sense code set to
> INQUIRY DATA HAS CHANGED.

Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/target/target_core_tpg.c | 69 ++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 67474690720d..c0d564f17951 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -720,6 +720,75 @@ void core_tpg_remove_lun(
 	percpu_ref_exit(&lun->lun_ref);
 }
 
+/* Set a Unit Attention on all I_T nexuses related to the port */
+static void core_tpg_ua(struct se_portal_group *se_tpg, u8 asc, u8 ascq)
+{
+	struct se_lun *lun;
+	struct se_dev_entry *se_deve;
+
+	mutex_lock(&se_tpg->tpg_lun_mutex);
+	hlist_for_each_entry_rcu(lun, &se_tpg->tpg_lun_hlist, link) {
+		spin_lock(&lun->lun_deve_lock);
+		list_for_each_entry(se_deve, &lun->lun_deve_list, lun_link)
+			core_scsi3_ua_allocate(se_deve, asc, ascq);
+		spin_unlock(&lun->lun_deve_lock);
+	}
+	mutex_unlock(&se_tpg->tpg_lun_mutex);
+}
+
+static ssize_t core_tpg_rtpi_show(struct config_item *item, char *page)
+{
+	struct se_portal_group *se_tpg = attrib_to_tpg(item);
+
+	return sprintf(page, "%#x\n", se_tpg->tpg_rtpi);
+}
+
+static ssize_t core_tpg_rtpi_store(struct config_item *item,
+				   const char *page, size_t count)
+{
+	struct se_portal_group *se_tpg = attrib_to_tpg(item);
+	struct se_portal_group *tpg;
+	u16 val;
+	int ret;
+
+	ret = kstrtou16(page, 0, &val);
+	if (ret < 0)
+		return ret;
+	if (val = 0)
+		return -EINVAL;
+
+	/* RTPI shouldn't conflict with values of existing ports */
+	ret = mutex_lock_interruptible(&g_tpg_mutex);
+	if (ret < 0)
+		return ret;
+
+	list_for_each_entry(tpg, &g_tpg_list, tpg_list) {
+		if (se_tpg != tpg && val = tpg->tpg_rtpi) {
+			pr_err("TARGET_CORE[%s]->TPG[%u] - RTPI %#x conflicts"
+			       " with TARGET_CORE[%s]->TPG[%u]\n",
+			       se_tpg->se_tpg_tfo->fabric_name,
+			       se_tpg->se_tpg_tfo->tpg_get_tag(tpg),
+			       val,
+			       tpg->se_tpg_tfo->fabric_name,
+			       tpg->se_tpg_tfo->tpg_get_tag(tpg));
+			ret = -EINVAL;
+			goto out;
+		}
+	}
+
+	if (se_tpg->tpg_rtpi != val) {
+		se_tpg->tpg_rtpi = val;
+		core_tpg_ua(se_tpg, 0x3f, ASCQ_3FH_INQUIRY_DATA_HAS_CHANGED);
+	}
+	ret = count;
+out:
+	mutex_unlock(&g_tpg_mutex);
+	return ret;
+}
+
+CONFIGFS_ATTR(core_tpg_, rtpi);
+
 struct configfs_attribute *core_tpg_attrib_attrs[] = {
+	&core_tpg_attr_rtpi,
 	NULL,
 };
-- 
2.26.1
