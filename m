From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 02 Apr 2019 19:58:07 +0000
Subject: [PATCH 03/11] target/core: Release SPC-2 reservation upon initiator logout
Message-Id: <20190402195815.254796-4-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

While testing with the libiscsi tool I noticed after the tool had stopped
and hence after it had logged out that an SPC-2 reservation was still active:

$ (cd /sys/kernel/config/target/core && find -name res_holder|xargs grep -aH .)
./pscsi_0/vdev3/pr/res_holder:Passthrough
./iblock_0/vdev2/pr/res_holder:No SPC-3 Reservation holder
./fileio_1/vdev1/pr/res_holder:SPC-2 Reservation: iSCSI Initiator: iqn.2007-10.com.github:sahlberg:libiscsi:iscsi-test-2
./fileio_0/vdev0/pr/res_holder:No SPC-3 Reservation holder

This is a bug. SPC-2 reservations must be cleared when an initiator
logs out. This patch fixes that bug. A quote from SPC-2 illustrates this:
"Reservations managed using the reserve/release method do not persist
across some recovery actions (e.g., hard resets). When a target performs
one of these recovery actions, the application client(s) have to rediscover
the configuration and re-establish the required reservations."

Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/target_core_transport.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index e3f7e21e6614..93ef5c6362d6 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -550,6 +550,15 @@ void transport_deregister_session_configfs(struct se_session *se_sess)
 }
 EXPORT_SYMBOL(transport_deregister_session_configfs);
 
+static int target_sess_release_reservation(struct se_device *dev, void *data)
+{
+	struct se_session *sess = data;
+
+	if (dev->reservation_holder = sess)
+		target_release_reservation(dev);
+	return 0;
+}
+
 void transport_free_session(struct se_session *se_sess)
 {
 	struct se_node_acl *se_nacl = se_sess->se_node_acl;
@@ -592,6 +601,7 @@ void transport_free_session(struct se_session *se_sess)
 		sbitmap_queue_free(&se_sess->sess_tag_pool);
 		kvfree(se_sess->sess_cmd_map);
 	}
+	target_for_each_device(target_sess_release_reservation, se_sess);
 	percpu_ref_exit(&se_sess->cmd_count);
 	kmem_cache_free(se_sess_cache, se_sess);
 }
-- 
2.21.0.196.g041f5ea1cf98
