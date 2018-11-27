From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 27 Nov 2018 23:51:57 +0000
Subject: [PATCH v2 03/10] target/core: Simplify transport_clear_lun_ref()
Message-Id: <20181127235204.186731-4-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Since transport_clear_lun_ref() already waits until the percpu-refcount
.release() method is called, it is not necessary to wait first until
percpu_ref_kill_and_confirm() has finished transitioning the refcount into
atomic mode. Remove the code that waits for percpu_ref_kill_and_confirm()
to complete and also the completion object that is used by that code.
This patch does not change the behavior of the SCSI target code.

Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Disseldorp <ddiss@suse.de>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/target_core_device.c    |  1 -
 drivers/target/target_core_tpg.c       |  1 -
 drivers/target/target_core_transport.c | 35 ++++----------------------
 include/target/target_core_base.h      |  1 -
 4 files changed, 5 insertions(+), 33 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 47b5ef153135..c6b1122ee097 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -822,7 +822,6 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 
 	xcopy_lun = &dev->xcopy_lun;
 	rcu_assign_pointer(xcopy_lun->lun_se_dev, dev);
-	init_completion(&xcopy_lun->lun_ref_comp);
 	init_completion(&xcopy_lun->lun_shutdown_comp);
 	INIT_LIST_HEAD(&xcopy_lun->lun_deve_list);
 	INIT_LIST_HEAD(&xcopy_lun->lun_dev_link);
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 02e8a5d86658..0cfb9d7b31a3 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -577,7 +577,6 @@ struct se_lun *core_tpg_alloc_lun(
 	}
 	lun->unpacked_lun = unpacked_lun;
 	atomic_set(&lun->lun_acl_count, 0);
-	init_completion(&lun->lun_ref_comp);
 	init_completion(&lun->lun_shutdown_comp);
 	INIT_LIST_HEAD(&lun->lun_deve_list);
 	INIT_LIST_HEAD(&lun->lun_dev_link);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index d9e4b736312e..3cd037558957 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2911,38 +2911,13 @@ void target_wait_for_sess_cmds(struct se_session *se_sess)
 }
 EXPORT_SYMBOL(target_wait_for_sess_cmds);
 
-static void target_lun_confirm(struct percpu_ref *ref)
-{
-	struct se_lun *lun = container_of(ref, struct se_lun, lun_ref);
-
-	complete(&lun->lun_ref_comp);
-}
-
+/*
+ * Prevent that new percpu_ref_tryget_live() calls succeed and wait until
+ * all references to the LUN have been released. Called during LUN shutdown.
+ */
 void transport_clear_lun_ref(struct se_lun *lun)
 {
-	/*
-	 * Mark the percpu-ref as DEAD, switch to atomic_t mode, drop
-	 * the initial reference and schedule confirm kill to be
-	 * executed after one full RCU grace period has completed.
-	 */
-	percpu_ref_kill_and_confirm(&lun->lun_ref, target_lun_confirm);
-	/*
-	 * The first completion waits for percpu_ref_switch_to_atomic_rcu()
-	 * to call target_lun_confirm after lun->lun_ref has been marked
-	 * as __PERCPU_REF_DEAD on all CPUs, and switches to atomic_t
-	 * mode so that percpu_ref_tryget_live() lookup of lun->lun_ref
-	 * fails for all new incoming I/O.
-	 */
-	wait_for_completion(&lun->lun_ref_comp);
-	/*
-	 * The second completion waits for percpu_ref_put_many() to
-	 * invoke ->release() after lun->lun_ref has switched to
-	 * atomic_t mode, and lun->lun_ref.count has reached zero.
-	 *
-	 * At this point all target-core lun->lun_ref references have
-	 * been dropped via transport_lun_remove_cmd(), and it's safe
-	 * to proceed with the remaining LUN shutdown.
-	 */
+	percpu_ref_kill(&lun->lun_ref);
 	wait_for_completion(&lun->lun_shutdown_comp);
 }
 
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index e3bdb0550a59..58a03a094257 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -731,7 +731,6 @@ struct se_lun {
 	struct scsi_port_stats	lun_stats;
 	struct config_group	lun_group;
 	struct se_port_stat_grps port_stat_grps;
-	struct completion	lun_ref_comp;
 	struct completion	lun_shutdown_comp;
 	struct percpu_ref	lun_ref;
 	struct list_head	lun_dev_link;
-- 
2.20.0.rc0.387.gc7a69e6b6c-goog
