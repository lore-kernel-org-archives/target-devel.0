From: Mike Christie <mchristi@redhat.com>
Date: Sun, 10 May 2020 21:57:42 +0000
Subject: [PATCH 13/15] target: add target_setup_session sysfs support
Message-Id: <20200510215744.21999-14-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200510215744.21999-1-mchristi@redhat.com>
In-Reply-To: <20200510215744.21999-1-mchristi@redhat.com>
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
index 04cb042..7bfeab2 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -457,6 +457,7 @@ struct se_session *
 
 	if (IS_ERR(sess))
 		return sess;
+	sess->tfo = tpg->se_tpg_tfo;
 
 	sess->tpt_id = target_create_transport_id(tpg->proto_id, tpt_id_name,
 						  NULL);
@@ -471,6 +472,10 @@ struct se_session *
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
@@ -478,12 +483,14 @@ struct se_session *
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
@@ -674,6 +681,7 @@ void transport_deregister_session(struct se_session *se_sess)
 
 void target_remove_session(struct se_session *se_sess)
 {
+	target_sysfs_remove_session(se_sess);
 	transport_deregister_session_configfs(se_sess);
 	transport_deregister_session(se_sess);
 }
-- 
1.8.3.1
