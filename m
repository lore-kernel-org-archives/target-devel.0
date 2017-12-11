From: Varun Prakash <varun@chelsio.com>
Date: Mon, 11 Dec 2017 15:42:25 +0000
Subject: [PATCH] cxgbit: call neigh_event_send() to update MAC address
Message-Id: <1513006225-1953-1-git-send-email-varun@chelsio.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

If nud_state is not valid then call neigh_event_send() to update MAC
address.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/target/iscsi/cxgbit/cxgbit_cm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/target/iscsi/cxgbit/cxgbit_cm.c b/drivers/target/iscsi/cxgbit/cxgbit_cm.c
index 92eb57e..8de1601 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_cm.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_cm.c
@@ -893,6 +893,9 @@ cxgbit_offload_init(struct cxgbit_sock *csk, int iptype, __u8 *peer_ip,
 		return -ENODEV;
 
 	rcu_read_lock();
+	if (!(n->nud_state & NUD_VALID))
+		neigh_event_send(n, NULL);
+
 	ret = -ENOMEM;
 	if (n->dev->flags & IFF_LOOPBACK) {
 		if (iptype = 4)
-- 
2.0.2

