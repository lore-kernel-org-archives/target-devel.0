From: Mike Christie <michael.christie@oracle.com>
Date: Sun, 25 Oct 2020 23:03:15 +0000
Subject: [PATCH 4/7] target: fix cmd_count ref leak
Message-Id: <1603666998-8086-5-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1603666998-8086-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1603666998-8086-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: himanshu.madhani@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

percpu_ref_init sets the refcount to 1 and percpu_ref_kill drops it.
Drivers like iscsi and loop do not call target_sess_cmd_list_set_waiting
during session shutdown though, so they have been calling
percpu_ref_exit
with a refcount still taken and leaking the cmd_counts memory.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_transport.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index ee2d2db..465b6583 100644
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
