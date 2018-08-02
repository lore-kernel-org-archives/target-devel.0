From: Mike Christie <mchristi@redhat.com>
Date: Thu, 02 Aug 2018 17:12:26 +0000
Subject: [PATCH 7/8] tcm_fc: use target_remove_session
Message-Id: <1533229947-6277-8-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This converts tcm_fc to use target_remove_session

tcm_fc was calling transport_deregister_session_configfs then calling
transport_deregister_session when commands have completed. It should be
ok for it to call transport_deregister_session_configfs later via
target_remove_session because transport_deregister_session_configfs
only prevents access from configfs via tpg removal and its call to the
close_session callback for that driver, and this is already protected by
the ft_lport_lock and its port lookup handling.

Signed-off-by: Mike Christie <mchristi@redhat.com>
Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Johannes Thumshirn <jth@kernel.org>
---
 drivers/target/tcm_fc/tfc_sess.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index efd7d5e..6d4adf5 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -287,7 +287,6 @@ static struct ft_sess *ft_sess_delete(struct ft_tport *tport, u32 port_id)
 
 static void ft_close_sess(struct ft_sess *sess)
 {
-	transport_deregister_session_configfs(sess->se_sess);
 	target_sess_cmd_list_set_waiting(sess->se_sess);
 	target_wait_for_sess_cmds(sess->se_sess);
 	ft_sess_put(sess);
@@ -448,7 +447,7 @@ static void ft_sess_free(struct kref *kref)
 {
 	struct ft_sess *sess = container_of(kref, struct ft_sess, kref);
 
-	transport_deregister_session(sess->se_sess);
+	target_remove_session(sess->se_sess);
 	kfree_rcu(sess, rcu);
 }
 
-- 
2.7.2

