From: Roman Bolshakov <r.bolshakov@yadro.com>
Date: Wed, 29 Apr 2020 09:44:36 +0000
Subject: [RFC PATCH 03/11] scsi: target/core: Add cleanup sequence in core_tpg_register()
Message-Id: <20200429094443.43937-4-r.bolshakov@yadro.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200429094443.43937-1-r.bolshakov@yadro.com>
In-Reply-To: <20200429094443.43937-1-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org, Mike Christie <mchristi@redhat.com>, Bart Van Assche <bvanassche@acm.org>, David Disseldorp <ddiss@suse.de>
Cc: linux-scsi@vger.kernel.org, linux@yadro.com, Roman Bolshakov <r.bolshakov@yadro.com>

It does not change any functionality but allows to introduce more steps
in the cleanup sequence without code duplication later.

Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/target/target_core_tpg.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index d24e0a3ba3ff..d3896c3f2f95 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -484,10 +484,8 @@ int core_tpg_register(
 
 		ret = core_tpg_add_lun(se_tpg, se_tpg->tpg_virt_lun0,
 				true, g_lun0_dev);
-		if (ret < 0) {
-			kfree(se_tpg->tpg_virt_lun0);
-			return ret;
-		}
+		if (ret < 0)
+			goto out_free_lun0;
 	}
 
 	pr_debug("TARGET_CORE[%s]: Allocated portal_group for endpoint: %s, "
@@ -497,6 +495,10 @@ int core_tpg_register(
 		se_tpg->proto_id, se_tpg->se_tpg_tfo->tpg_get_tag(se_tpg));
 
 	return 0;
+
+out_free_lun0:
+	kfree(se_tpg->tpg_virt_lun0);
+	return ret;
 }
 EXPORT_SYMBOL(core_tpg_register);
 
-- 
2.26.1
