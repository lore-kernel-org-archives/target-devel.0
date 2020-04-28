From: Mike Christie <mchristi@redhat.com>
Date: Tue, 28 Apr 2020 06:11:07 +0000
Subject: [PATCH 09/11] target: add target_setup_session sysfs support
Message-Id: <20200428061109.3042-10-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200428061109.3042-1-mchristi@redhat.com>
In-Reply-To: <20200428061109.3042-1-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: bvanassche@acm.org, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Mike Christie <mchristi@redhat.com>

This adds a session dir per session for users of target_setup_session.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_transport.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 7f04b7bf..37aa6de 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -446,6 +446,7 @@ struct se_session *
 
 	if (IS_ERR(sess))
 		return sess;
+	sess->tfo = tpg->se_tpg_tfo;
 
 	sess->tpid = target_cp_transport_id(tpid);
 	if (!sess->tpid) {
@@ -459,6 +460,10 @@ struct se_session *
 		rc = -EACCES;
 		goto free_sess;
 	}
+
+	rc = target_sysfs_add_session(tpg, sess);
+	if (rc)
+		goto free_sess;
 	/*
 	 * Go ahead and perform any remaining fabric setup that is
 	 * required before transport_register_session().
@@ -466,12 +471,14 @@ struct se_session *
 	if (callback != NULL) {
 		rc = callback(tpg, sess, private);
 		if (rc)
-			goto free_sess;
+			goto rm_sysfs;
 	}
 
 	transport_register_session(tpg, sess->se_node_acl, sess, private);
 	return sess;
 
+rm_sysfs:
+	target_sysfs_remove_session(sess);
 free_sess:
 	transport_free_session(sess);
 	return ERR_PTR(rc);
@@ -662,6 +669,7 @@ void transport_deregister_session(struct se_session *se_sess)
 
 void target_remove_session(struct se_session *se_sess)
 {
+	target_sysfs_remove_session(se_sess);
 	transport_deregister_session_configfs(se_sess);
 	transport_deregister_session(se_sess);
 }
-- 
1.8.3.1
