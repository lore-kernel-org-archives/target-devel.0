From: Bart Van Assche <bart.vanassche@wdc.com>
Date: Fri, 22 Jun 2018 21:53:07 +0000
Subject: [PATCH 20/20] target: Remove se_dev_entry.ua_count
Message-Id: <20180622215307.8758-21-bart.vanassche@wdc.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

se_dev_entry.ua_count is only used to check whether or not
se_dev_entry.ua_list is empty. Use list_empty_careful() instead.
Checking whether or not ua_list is empty without holding the
lock that protects that list is fine because the code that
dequeues from that list will check again whether or not that
list is empty.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
---
 drivers/target/target_core_device.c |  1 -
 drivers/target/target_core_ua.c     | 12 ++----------
 include/target/target_core_base.h   |  1 -
 3 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index e8d2a7f22382..d91cbff57680 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -336,7 +336,6 @@ int core_enable_device_list_for_node(
 		return -ENOMEM;
 	}
 
-	atomic_set(&new->ua_count, 0);
 	spin_lock_init(&new->ua_lock);
 	INIT_LIST_HEAD(&new->ua_list);
 	INIT_LIST_HEAD(&new->lun_link);
diff --git a/drivers/target/target_core_ua.c b/drivers/target/target_core_ua.c
index 9399b38339f9..c8ac242ce888 100644
--- a/drivers/target/target_core_ua.c
+++ b/drivers/target/target_core_ua.c
@@ -55,7 +55,7 @@ target_scsi3_ua_check(struct se_cmd *cmd)
 		rcu_read_unlock();
 		return 0;
 	}
-	if (!atomic_read(&deve->ua_count)) {
+	if (list_empty_careful(&deve->ua_list)) {
 		rcu_read_unlock();
 		return 0;
 	}
@@ -154,7 +154,6 @@ int core_scsi3_ua_allocate(
 				&deve->ua_list);
 		spin_unlock(&deve->ua_lock);
 
-		atomic_inc_mb(&deve->ua_count);
 		return 0;
 	}
 	list_add_tail(&ua->ua_nacl_list, &deve->ua_list);
@@ -164,7 +163,6 @@ int core_scsi3_ua_allocate(
 		" 0x%02x, ASCQ: 0x%02x\n", deve->mapped_lun,
 		asc, ascq);
 
-	atomic_inc_mb(&deve->ua_count);
 	return 0;
 }
 
@@ -196,8 +194,6 @@ void core_scsi3_ua_release_all(
 	list_for_each_entry_safe(ua, ua_p, &deve->ua_list, ua_nacl_list) {
 		list_del(&ua->ua_nacl_list);
 		kmem_cache_free(se_ua_cache, ua);
-
-		atomic_dec_mb(&deve->ua_count);
 	}
 	spin_unlock(&deve->ua_lock);
 }
@@ -263,8 +259,6 @@ bool core_scsi3_ua_for_check_condition(struct se_cmd *cmd, u8 *key, u8 *asc,
 		}
 		list_del(&ua->ua_nacl_list);
 		kmem_cache_free(se_ua_cache, ua);
-
-		atomic_dec_mb(&deve->ua_count);
 	}
 	spin_unlock(&deve->ua_lock);
 	rcu_read_unlock();
@@ -304,7 +298,7 @@ int core_scsi3_ua_clear_for_request_sense(
 		rcu_read_unlock();
 		return -EINVAL;
 	}
-	if (!atomic_read(&deve->ua_count)) {
+	if (list_empty_careful(&deve->ua_list)) {
 		rcu_read_unlock();
 		return -EPERM;
 	}
@@ -327,8 +321,6 @@ int core_scsi3_ua_clear_for_request_sense(
 		}
 		list_del(&ua->ua_nacl_list);
 		kmem_cache_free(se_ua_cache, ua);
-
-		atomic_dec_mb(&deve->ua_count);
 	}
 	spin_unlock(&deve->ua_lock);
 	rcu_read_unlock();
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index ca59e065c1fd..7a4ee7852ca4 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -638,7 +638,6 @@ struct se_dev_entry {
 	atomic_long_t		total_cmds;
 	atomic_long_t		read_bytes;
 	atomic_long_t		write_bytes;
-	atomic_t		ua_count;
 	/* Used for PR SPEC_I_PT=1 and REGISTER_AND_MOVE */
 	struct kref		pr_kref;
 	struct completion	pr_comp;
-- 
2.17.1

