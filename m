From: Mike Christie <mchristi@redhat.com>
Date: Sun, 15 Jul 2018 23:16:18 +0000
Subject: [PATCH 02/15] target: fix isid copying and comparision
Message-Id: <1531696591-8558-3-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

The isid is 48 bits, and in hex string format it's 12 bytes.
We are currently copying the 12 byte hex string to a u64
so we can easily compare it, but this has the problem that
only 8 bytes of the 12 bytes are copied.

The next patches will want to print se_session sess_bin_isid
so this has us use hex2bin to when converting from the hex
sting to the bin value.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_pr.c        | 20 ++++++++++++++++----
 drivers/target/target_core_transport.c |  3 ++-
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 01ac306..65e5253 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -662,8 +662,7 @@ static struct t10_pr_registration *__core_scsi3_do_alloc_registration(
 			rcu_read_unlock();
 			pr_err("Unable to locate PR deve %s mapped_lun: %llu\n",
 				nacl->initiatorname, mapped_lun);
-			kmem_cache_free(t10_pr_reg_cache, pr_reg);
-			return NULL;
+			goto free_reg;
 		}
 		kref_get(&pr_reg->pr_reg_deve->pr_kref);
 		rcu_read_unlock();
@@ -679,12 +678,20 @@ static struct t10_pr_registration *__core_scsi3_do_alloc_registration(
 	 * save it to the registration now.
 	 */
 	if (isid != NULL) {
-		pr_reg->pr_reg_bin_isid = get_unaligned_be64(isid);
+		if (hex2bin((u8 *)&pr_reg->pr_reg_bin_isid, isid, 6)) {
+			pr_err("Invalid isid %s\n", isid);
+			goto free_reg;
+		}
+
 		snprintf(pr_reg->pr_reg_isid, PR_REG_ISID_LEN, "%s", isid);
 		pr_reg->isid_present_at_reg = 1;
 	}
 
 	return pr_reg;
+
+free_reg:
+	kmem_cache_free(t10_pr_reg_cache, pr_reg);
+	return NULL;
 }
 
 static int core_scsi3_lunacl_depend_item(struct se_dev_entry *);
@@ -873,7 +880,12 @@ int core_scsi3_alloc_aptpl_registration(
 	 * SCSI Initiator Port, restore it now.
 	 */
 	if (isid != NULL) {
-		pr_reg->pr_reg_bin_isid = get_unaligned_be64(isid);
+		if (hex2bin((u8 *)&pr_reg->pr_reg_bin_isid, isid, 6)) {
+			pr_err("Invalid isid %s\n", isid);
+			kmem_cache_free(t10_pr_reg_cache, pr_reg);
+			return -EINVAL;
+		}
+
 		snprintf(pr_reg->pr_reg_isid, PR_REG_ISID_LEN, "%s", isid);
 		pr_reg->isid_present_at_reg = 1;
 	}
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 7261561..6324743 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -380,7 +380,8 @@ void __transport_register_session(
 			memset(&buf[0], 0, PR_REG_ISID_LEN);
 			se_tpg->se_tpg_tfo->sess_get_initiator_sid(se_sess,
 					&buf[0], PR_REG_ISID_LEN);
-			se_sess->sess_bin_isid = get_unaligned_be64(&buf[0]);
+
+			WARN_ON(hex2bin((u8 *)&se_sess->sess_bin_isid, buf, 6));
 		}
 
 		spin_lock_irq(&se_nacl->nacl_sess_lock);
-- 
2.7.2

