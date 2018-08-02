From: Mike Christie <mchristi@redhat.com>
Date: Thu, 02 Aug 2018 17:12:24 +0000
Subject: [PATCH 5/8] target: add session removal function
Message-Id: <1533229947-6277-6-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This adds a function to remove a session which should be used by drivers
that use target_setup_session. The next patches will convert the target
drivers to use this new function.

Signed-off-by: Mike Christie <mchristi@redhat.com>
Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Chris Boot <bootc@bootc.net>
Cc: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
Cc: Michael Cyr <mikecyr@linux.vnet.ibm.com>
Cc: <qla2xxx-upstream@qlogic.com>
Cc: Johannes Thumshirn <jth@kernel.org>
Cc: Felipe Balbi <balbi@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Juergen Gross <jgross@suse.com>

---
 drivers/target/target_core_transport.c | 7 +++++++
 include/target/target_core_fabric.h    | 1 +
 2 files changed, 8 insertions(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 57fadec..86c0156 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -616,6 +616,13 @@ void transport_deregister_session(struct se_session *se_sess)
 }
 EXPORT_SYMBOL(transport_deregister_session);
 
+void target_remove_session(struct se_session *se_sess)
+{
+	transport_deregister_session_configfs(se_sess);
+	transport_deregister_session(se_sess);
+}
+EXPORT_SYMBOL(target_remove_session);
+
 static void target_remove_from_state_list(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index fbcc9a4..f4147b3 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -114,6 +114,7 @@ struct se_session *target_setup_session(struct se_portal_group *,
 		const char *, void *,
 		int (*callback)(struct se_portal_group *,
 				struct se_session *, void *));
+void target_remove_session(struct se_session *);
 
 void transport_init_session(struct se_session *);
 struct se_session *transport_alloc_session(enum target_prot_op);
-- 
2.7.2

