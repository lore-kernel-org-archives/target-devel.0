From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 02 Apr 2019 19:58:05 +0000
Subject: [PATCH 01/11] target/core: Fix a race condition in the LUN lookup code
Message-Id: <20190402195815.254796-2-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

The rcu_dereference(deve->se_lun) expression occurs two times in the
LUN lookup functions. Since these expressions are not serialized against
deve->se_lun assignments each of these expressions may yield a different
result. Avoid that the wrong LUN pointer is stored in se_cmd by reading
deve->se_lun only once.

Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Fixes: 29a05deebf6c ("target: Convert se_node_acl->device_list[] to RCU hlist") # v4.10
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/target_core_device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 1f8482b6473b..7eae1c823c4e 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -85,7 +85,7 @@ transport_lookup_cmd_lun(struct se_cmd *se_cmd, u64 unpacked_lun)
 			goto out_unlock;
 		}
 
-		se_cmd->se_lun = rcu_dereference(deve->se_lun);
+		se_cmd->se_lun = se_lun;
 		se_cmd->pr_res_key = deve->pr_res_key;
 		se_cmd->orig_fe_lun = unpacked_lun;
 		se_cmd->se_cmd_flags |= SCF_SE_LUN_CMD;
@@ -176,7 +176,7 @@ int transport_lookup_tmr_lun(struct se_cmd *se_cmd, u64 unpacked_lun)
 			goto out_unlock;
 		}
 
-		se_cmd->se_lun = rcu_dereference(deve->se_lun);
+		se_cmd->se_lun = se_lun;
 		se_cmd->pr_res_key = deve->pr_res_key;
 		se_cmd->orig_fe_lun = unpacked_lun;
 		se_cmd->se_cmd_flags |= SCF_SE_LUN_CMD;
-- 
2.21.0.196.g041f5ea1cf98
