From: Roman Bolshakov <r.bolshakov@yadro.com>
Date: Wed, 29 Apr 2020 09:44:43 +0000
Subject: [RFC PATCH 10/11] scsi: target/core: Prevent RTPI conflicts
Message-Id: <20200429094443.43937-11-r.bolshakov@yadro.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200429094443.43937-1-r.bolshakov@yadro.com>
In-Reply-To: <20200429094443.43937-1-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org, Mike Christie <mchristi@redhat.com>, Bart Van Assche <bvanassche@acm.org>, David Disseldorp <ddiss@suse.de>
Cc: linux-scsi@vger.kernel.org, linux@yadro.com, Roman Bolshakov <r.bolshakov@yadro.com>

RTPI values have to be unique per SAM-5 4.6.5.2 (Relative Port
Identifier attribute).

There are four sources of RTPI changes, where RTPI duplicates may
appear:

1. Automatically increased RTPI for new SCSI target ports. They have to
be unique among target ports. Simultaneous creation of SCSI target ports
is synchronized by g_tpg_mutex. No real LUNs are attached upon creation
(except virtual LUN 0) therefore, no synchronization is needed between
peer ports.

2. Manually configured RTPI values on SCSI target ports using rtpi attr
in configfs. They should be unique for all peer ports on the LUNs
available through the ports and among all SCSI target ports.

3. New peer ports created in configfs. They shouldn't conflict with other
peer ports on the se_device and RTPI values of the ports the se_device
is exported on.

4. Export of a backstore with peer ports on a SCSI target port. RTPI of
a peer port may have the same value as automatically or manually
configured RTPI of a SCSI target port.

The change introduces synchronization for 2-4. RTPI modification is
locked by global RTPI mutex. It can be used in sleeping context,
therefore it should be a mutex rather than a spinlock.

Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/target/target_core_configfs.c | 38 +++++++++++++
 drivers/target/target_core_device.c   | 19 +++++++
 drivers/target/target_core_internal.h |  2 +
 drivers/target/target_core_tpg.c      | 81 ++++++++++++++++++++++++++-
 4 files changed, 138 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 803e968659e3..c43f244f8bd6 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -3100,7 +3100,9 @@ target_core_alua_tg_pt_gp_peers_make(struct config_group *group,
 {
 	struct t10_alua_tg_pt_gp *tg_pt_gp = container_of(group,
 			struct t10_alua_tg_pt_gp, tg_pt_gp_peers_group);
+	struct se_device *dev = tg_pt_gp->tg_pt_gp_dev;
 	struct t10_alua_tg_pt_gp_peer *peer_port;
+	struct se_lun *lun;
 	u16 val;
 	int ret;
 
@@ -3119,6 +3121,38 @@ target_core_alua_tg_pt_gp_peers_make(struct config_group *group,
 		goto out_free;
 	}
 
+	ret = mutex_lock_interruptible(&g_rtpi_mutex);
+	if (ret < 0)
+		goto out_free;
+
+	spin_lock(&dev->t10_alua.tg_pt_gps_lock);
+	if (core_dev_has_rtpi(dev, val)) {
+		pr_err("TARGET_CORE[0]: RTPI %#x conflicts with a peer port\n",
+		       val);
+		spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
+		ret = -EINVAL;
+		goto out_unlock_rtpi;
+	}
+	spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
+
+	spin_lock(&dev->se_port_lock);
+	list_for_each_entry(lun, &dev->dev_sep_list, lun_dev_link) {
+		struct se_portal_group *tpg = lun->lun_tpg;
+
+		if (tpg->tpg_rtpi = val) {
+			pr_err("TARGET_CORE[0]: RTPI %#x conflicts with"
+			       " TARGET_CORE[%s]->TPG[%u]_LUN[%llu]\n",
+			       val,
+			       tpg->se_tpg_tfo->fabric_name,
+			       tpg->se_tpg_tfo->tpg_get_tag(tpg),
+			       lun->unpacked_lun);
+			spin_unlock(&dev->se_port_lock);
+			ret = -EINVAL;
+			goto out_unlock_rtpi;
+		}
+	}
+	spin_unlock(&dev->se_port_lock);
+
 	peer_port->tg_pt_gp_peer_rtpi = val;
 	config_item_init_type_name(&peer_port->tg_pt_gp_peer_item,
 				   name,
@@ -3128,8 +3162,12 @@ target_core_alua_tg_pt_gp_peers_make(struct config_group *group,
 	list_add_tail(&peer_port->tg_pt_gp_peer_list,
 		      &tg_pt_gp->tg_pt_gp_peer_list);
 	spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
+	mutex_unlock(&g_rtpi_mutex);
 
 	return &peer_port->tg_pt_gp_peer_item;
+
+out_unlock_rtpi:
+	mutex_unlock(&g_rtpi_mutex);
 out_free:
 	kfree(peer_port);
 	return ERR_PTR(ret);
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 24d358f942b8..f3c783c83fd6 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -975,6 +975,25 @@ void target_free_device(struct se_device *dev)
 	dev->transport->free_device(dev);
 }
 
+bool core_dev_has_rtpi(struct se_device *dev, u16 rtpi)
+{
+	struct t10_alua_tg_pt_gp *tg_pt_gp;
+	struct t10_alua_tg_pt_gp_peer *peer;
+
+	assert_spin_locked(&dev->t10_alua.tg_pt_gps_lock);
+
+	list_for_each_entry(tg_pt_gp, &dev->t10_alua.tg_pt_gps_list,
+			    tg_pt_gp_list) {
+		list_for_each_entry(peer, &tg_pt_gp->tg_pt_gp_peer_list,
+				    tg_pt_gp_peer_list) {
+			if (peer->tg_pt_gp_peer_rtpi = rtpi)
+				return 1;
+		}
+	}
+
+	return 0;
+}
+
 int core_dev_setup_virtual_lun0(void)
 {
 	struct se_hba *hba;
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index e1aabb79467a..90a82abdc828 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -80,6 +80,7 @@ int	core_dev_del_initiator_node_lun_acl(struct se_lun *,
 		struct se_lun_acl *);
 void	core_dev_free_initiator_node_lun_acl(struct se_portal_group *,
 		struct se_lun_acl *lacl);
+bool	core_dev_has_rtpi(struct se_device *dev, u16 rtpi);
 int	core_dev_setup_virtual_lun0(void);
 void	core_dev_release_virtual_lun0(void);
 struct se_device *target_alloc_device(struct se_hba *hba, const char *name);
@@ -115,6 +116,7 @@ int	core_tmr_lun_reset(struct se_device *, struct se_tmr_req *,
 		struct list_head *, struct se_cmd *);
 
 /* target_core_tpg.c */
+extern struct mutex g_rtpi_mutex;
 extern struct se_device *g_lun0_dev;
 extern struct configfs_attribute *core_tpg_attrib_attrs[];
 
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index c0d564f17951..ca14d6d32b62 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -31,6 +31,8 @@
 #include "target_core_ua.h"
 
 extern struct se_device *g_lun0_dev;
+/* Synchronizes RTPI changes system-wide */
+DEFINE_MUTEX(g_rtpi_mutex);
 static u16 g_tpg_count;
 static u16 g_tpg_rtpi_counter = 1;
 static LIST_HEAD(g_tpg_list);
@@ -645,6 +647,8 @@ int core_tpg_add_lun(
 	bool lun_access_ro,
 	struct se_device *dev)
 {
+	const char *devname = config_item_name(&dev->dev_group.cg_item);
+	struct se_portal_group *tmp_tpg;
 	int ret;
 
 	ret = percpu_ref_init(&lun->lun_ref, core_tpg_lun_ref_release, 0,
@@ -652,10 +656,39 @@ int core_tpg_add_lun(
 	if (ret < 0)
 		goto out;
 
+	mutex_lock(&g_rtpi_mutex);
 	if (!(dev->transport->transport_flags &
 	     TRANSPORT_FLAG_PASSTHROUGH_ALUA) &&
-	    !(dev->se_hba->hba_flags & HBA_FLAGS_INTERNAL_USE))
+	    !(dev->se_hba->hba_flags & HBA_FLAGS_INTERNAL_USE)) {
+		/*
+		 * LUN won't be created if a peer RTPI in a port group
+		 * conflicts with Port RTPI.
+		 * RTPI values must be strictly unique.
+		 */
+		mutex_lock(&g_tpg_mutex);
+		list_for_each_entry(tmp_tpg, &g_tpg_list, tpg_list) {
+			spin_lock(&dev->t10_alua.tg_pt_gps_lock);
+			if (core_dev_has_rtpi(dev, tmp_tpg->tpg_rtpi)) {
+				pr_err("TARGET_CORE[%s]->TPG[%u]_LUN[%llu]:"
+				       " RTPI %#x conflicts with peer port of"
+				       " %s\n",
+				       tmp_tpg->se_tpg_tfo->fabric_name,
+				       tmp_tpg->se_tpg_tfo->tpg_get_tag(
+					       tmp_tpg),
+				       lun->unpacked_lun,
+				       tmp_tpg->tpg_rtpi,
+				       devname);
+				spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
+				mutex_unlock(&g_tpg_mutex);
+				ret = -EINVAL;
+				goto out_unlock_rtpi;
+			}
+			spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
+		}
+		mutex_unlock(&g_tpg_mutex);
+
 		target_attach_tg_pt_gp(lun, dev->t10_alua.default_tg_pt_gp);
+	}
 
 	mutex_lock(&tpg->tpg_lun_mutex);
 
@@ -673,9 +706,13 @@ int core_tpg_add_lun(
 	if (!(dev->se_hba->hba_flags & HBA_FLAGS_INTERNAL_USE))
 		hlist_add_head_rcu(&lun->link, &tpg->tpg_lun_hlist);
 	mutex_unlock(&tpg->tpg_lun_mutex);
+	mutex_unlock(&g_rtpi_mutex);
 
 	return 0;
 
+out_unlock_rtpi:
+	mutex_unlock(&g_rtpi_mutex);
+	percpu_ref_exit(&lun->lun_ref);
 out:
 	return ret;
 }
@@ -747,6 +784,8 @@ static ssize_t core_tpg_rtpi_store(struct config_item *item,
 				   const char *page, size_t count)
 {
 	struct se_portal_group *se_tpg = attrib_to_tpg(item);
+	struct se_lun *lun;
+	struct se_device *dev;
 	struct se_portal_group *tpg;
 	u16 val;
 	int ret;
@@ -757,6 +796,10 @@ static ssize_t core_tpg_rtpi_store(struct config_item *item,
 	if (val = 0)
 		return -EINVAL;
 
+	ret = mutex_lock_interruptible(&g_rtpi_mutex);
+	if (ret < 0)
+		return ret;
+
 	/* RTPI shouldn't conflict with values of existing ports */
 	ret = mutex_lock_interruptible(&g_tpg_mutex);
 	if (ret < 0)
@@ -771,10 +814,44 @@ static ssize_t core_tpg_rtpi_store(struct config_item *item,
 			       val,
 			       tpg->se_tpg_tfo->fabric_name,
 			       tpg->se_tpg_tfo->tpg_get_tag(tpg));
+			mutex_unlock(&g_tpg_mutex);
 			ret = -EINVAL;
 			goto out;
 		}
 	}
+	mutex_unlock(&g_tpg_mutex);
+
+	/* RTPI shouldn't conflict with values of peer ports */
+	ret = mutex_lock_interruptible(&se_tpg->tpg_lun_mutex);
+	if (ret < 0)
+		goto out;
+
+	hlist_for_each_entry_rcu(lun, &se_tpg->tpg_lun_hlist, link) {
+		rcu_read_lock();
+		dev = rcu_dereference(lun->lun_se_dev);
+		if (dev) {
+			const char *devname;
+
+			devname = config_item_name(&dev->dev_group.cg_item);
+
+			spin_lock(&dev->t10_alua.tg_pt_gps_lock);
+			if (core_dev_has_rtpi(dev, val)) {
+				pr_err("TARGET_CORE[%s]->TPG[%u] - RTPI"
+				       " conflicts with a peer port of %s\n",
+				       se_tpg->se_tpg_tfo->fabric_name,
+				       se_tpg->se_tpg_tfo->tpg_get_tag(tpg),
+				       devname);
+				spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
+				rcu_read_unlock();
+				mutex_unlock(&se_tpg->tpg_lun_mutex);
+				ret = -EINVAL;
+				goto out;
+			}
+			spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
+		}
+		rcu_read_unlock();
+	}
+	mutex_unlock(&se_tpg->tpg_lun_mutex);
 
 	if (se_tpg->tpg_rtpi != val) {
 		se_tpg->tpg_rtpi = val;
@@ -782,7 +859,7 @@ static ssize_t core_tpg_rtpi_store(struct config_item *item,
 	}
 	ret = count;
 out:
-	mutex_unlock(&g_tpg_mutex);
+	mutex_unlock(&g_rtpi_mutex);
 	return ret;
 }
 
-- 
2.26.1
