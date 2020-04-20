From: Mike Christie <mchristi@redhat.com>
Date: Mon, 20 Apr 2020 19:14:24 +0000
Subject: [RFC PATCH 10/12] target: add target_setup_session sysfs support
Message-Id: <20200420191426.17055-11-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200420191426.17055-1-mchristi@redhat.com>
In-Reply-To: <20200420191426.17055-1-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jsmart2021@gmail.com, bvanassche@acm.org, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Mike Christie <mchristi@redhat.com>

This adds a session dir per session for users of target_setup_session.

TODO:
1. drivers like tcm_qla2xxx allocate resources in the fabric ops
init_session callback, but I have not implemented free_session
callbacks for them yet.

2. Drivers that delete their tpg before the sessions need to
be updated.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_transport.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 7aa830e..fd41f35 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -472,10 +472,24 @@ struct se_session *
 		if (rc)
 			goto free_sess;
 	}
+	/*
+	 * init_session was successful so set the tfo now, because if there
+	 * is a failure going forward we will want to call the free_session
+	 * callback.
+	 */
+	sess->tfo = tpg->se_tpg_tfo;
 
 	transport_register_session(tpg, sess->se_node_acl, sess, private);
+
+	rc = target_sysfs_add_session(tpg, sess);
+	if (rc)
+		goto dereg_sess;
+
 	return sess;
 
+dereg_sess:
+	transport_deregister_session_configfs(sess);
+	transport_deregister_session(sess);
 free_sess:
 	transport_free_session(sess);
 	return ERR_PTR(rc);
@@ -671,6 +685,7 @@ void transport_deregister_session(struct se_session *se_sess)
 
 void target_remove_session(struct se_session *se_sess)
 {
+	target_sysfs_remove_session(se_sess);
 	transport_deregister_session_configfs(se_sess);
 	transport_deregister_session(se_sess);
 }
-- 
1.8.3.1
