From: Mike Christie <michael.christie@oracle.com>
Date: Sun, 01 Nov 2020 18:59:28 +0000
Subject: [PATCH 2/8] target: fix cmd_count ref leak
Message-Id: <1604257174-4524-3-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1604257174-4524-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1604257174-4524-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: himanshu.madhani@oracle.com, njavali@marvell.com, james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

percpu_ref_init sets the refcount to 1 and percpu_ref_kill drops it.
Drivers like iscsi and loop do not call target_sess_cmd_list_set_waiting
during session shutdown though, so they have been calling
percpu_ref_exit
with a refcount still taken and leaking the cmd_counts memory.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/target/target_core_transport.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index ff26ab0..d47619a 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -238,6 +238,14 @@ int transport_init_session(struct se_session *se_sess)
 
 void transport_uninit_session(struct se_session *se_sess)
 {
+	/*
+	 * Drivers like iscsi and loop do not call
+	 * target_sess_cmd_list_set_waiting during session shutdown so we
+	 * have to drop the ref taken at init time here.
+	 */
+	if (!se_sess->sess_tearing_down)
+		percpu_ref_put(&se_sess->cmd_count);
+
 	percpu_ref_exit(&se_sess->cmd_count);
 }
 
-- 
1.8.3.1
