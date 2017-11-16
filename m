From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Date: Thu, 16 Nov 2017 06:14:16 +0000
Subject: [PATCH-4.1.y 4/7] target: Avoid mappedlun symlink creation during lun shutdown
Message-Id: <1510812859-15101-5-git-send-email-nab@linux-iscsi.org>
List-Id: <target-devel.vger.kernel.org>
References: <1510812859-15101-1-git-send-email-nab@linux-iscsi.org>
In-Reply-To: <1510812859-15101-1-git-send-email-nab@linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel <target-devel@vger.kernel.org>
Cc: stable <stable@vger.kernel.org>, Sasha Levin <alexander.levin@verizon.com>, Greg-KH <gregkh@linuxfoundation.org>, Nicholas Bellinger <nab@linux-iscsi.org>, James Shen <jcs@datera.io>

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 49cb77e297dc611a1b795cfeb79452b3002bd331 upstream.

This patch closes a race between se_lun deletion during configfs
unlink in target_fabric_port_unlink() -> core_dev_del_lun()
-> core_tpg_remove_lun(), when transport_clear_lun_ref() blocks
waiting for percpu_ref RCU grace period to finish, but a new
NodeACL mappedlun is added before the RCU grace period has
completed.

This can happen in target_fabric_mappedlun_link() because it
only checks for se_lun->lun_se_dev, which is not cleared until
after transport_clear_lun_ref() percpu_ref RCU grace period
finishes.

This bug originally manifested as NULL pointer dereference
OOPsen in target_stat_scsi_att_intr_port_show_attr_dev() on
v4.1.y code, because it dereferences lun->lun_se_dev without
a explicit NULL pointer check.

In post v4.1 code with target-core RCU conversion, the code
in target_stat_scsi_att_intr_port_show_attr_dev() no longer
uses se_lun->lun_se_dev, but the same race still exists.

To address the bug, go ahead and set se_lun>lun_shutdown as
early as possible in core_tpg_remove_lun(), and ensure new
NodeACL mappedlun creation in target_fabric_mappedlun_link()
fails during se_lun shutdown.

Reported-by: James Shen <jcs@datera.io>
Cc: James Shen <jcs@datera.io>
Tested-by: James Shen <jcs@datera.io>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_fabric_configfs.c | 5 +++++
 drivers/target/target_core_tpg.c             | 3 +++
 include/target/target_core_base.h            | 1 +
 3 files changed, 9 insertions(+)

diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 1f7886b..65e0a06 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -98,6 +98,11 @@ static int target_fabric_mappedlun_link(
 				"_tpg does not exist\n");
 		return -EINVAL;
 	}
+	if (lun->lun_shutdown) {
+		pr_err("Unable to create mappedlun symlink because"
+			" lun->lun_shutdown=true\n");
+		return -EINVAL;
+	}
 	se_tpg = lun->lun_sep->sep_tpg;
 
 	nacl_ci = &lun_acl_ci->ci_parent->ci_group->cg_item;
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 6c350f0..03f43ce 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -883,6 +883,8 @@ void core_tpg_remove_lun(
 	struct se_portal_group *tpg,
 	struct se_lun *lun)
 {
+	lun->lun_shutdown = true;
+
 	core_clear_lun_from_tpg(lun, tpg);
 	transport_clear_lun_ref(lun);
 
@@ -890,6 +892,7 @@ void core_tpg_remove_lun(
 
 	spin_lock(&tpg->tpg_lun_lock);
 	lun->lun_status = TRANSPORT_LUN_STATUS_FREE;
+	lun->lun_shutdown = false;
 	spin_unlock(&tpg->tpg_lun_lock);
 
 	percpu_ref_exit(&lun->lun_ref);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index c978ad2..ad3c146 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -725,6 +725,7 @@ struct se_lun {
 	u32			lun_access;
 	u32			lun_flags;
 	u32			unpacked_lun;
+	bool			lun_shutdown;
 	atomic_t		lun_acl_count;
 	spinlock_t		lun_acl_lock;
 	spinlock_t		lun_sep_lock;
-- 
1.8.5.3

