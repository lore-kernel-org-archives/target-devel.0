From: Sagi Grimberg <sagi@grimberg.me>
Date: Wed, 07 Feb 2018 13:05:18 +0000
Subject: [PATCH v2 3/3] iscsi-target: use common inet_addr_is_any
Message-Id: <20180207130518.22803-4-sagi@grimberg.me>
List-Id: <target-devel.vger.kernel.org>
References: <20180207130518.22803-1-sagi@grimberg.me>
In-Reply-To: <20180207130518.22803-1-sagi@grimberg.me>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Instead of open-coding it.

Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org
---
 drivers/target/iscsi/iscsi_target.c | 28 ++--------------------------
 1 file changed, 2 insertions(+), 26 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 9eb10d34682c..8e223799347a 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -26,6 +26,7 @@
 #include <linux/delay.h>
 #include <linux/sched/signal.h>
 #include <asm/unaligned.h>
+#include <linux/inet.h>
 #include <net/ipv6.h>
 #include <scsi/scsi_proto.h>
 #include <scsi/iscsi_proto.h>
@@ -3291,30 +3292,6 @@ iscsit_send_task_mgt_rsp(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 	return conn->conn_transport->iscsit_xmit_pdu(conn, cmd, NULL, NULL, 0);
 }
 
-static bool iscsit_check_inaddr_any(struct iscsi_np *np)
-{
-	bool ret = false;
-
-	if (np->np_sockaddr.ss_family = AF_INET6) {
-		const struct sockaddr_in6 sin6 = {
-			.sin6_addr = IN6ADDR_ANY_INIT };
-		struct sockaddr_in6 *sock_in6 -			 (struct sockaddr_in6 *)&np->np_sockaddr;
-
-		if (!memcmp(sock_in6->sin6_addr.s6_addr,
-				sin6.sin6_addr.s6_addr, 16))
-			ret = true;
-	} else {
-		struct sockaddr_in * sock_in -			(struct sockaddr_in *)&np->np_sockaddr;
-
-		if (sock_in->sin_addr.s_addr = htonl(INADDR_ANY))
-			ret = true;
-	}
-
-	return ret;
-}
-
 #define SENDTARGETS_BUF_LIMIT 32768U
 
 static int
@@ -3393,7 +3370,6 @@ iscsit_build_sendtargets_response(struct iscsi_cmd *cmd,
 			list_for_each_entry(tpg_np, &tpg->tpg_gnp_list,
 						tpg_np_list) {
 				struct iscsi_np *np = tpg_np->tpg_np;
-				bool inaddr_any = iscsit_check_inaddr_any(np);
 				struct sockaddr_storage *sockaddr;
 
 				if (np->np_network_transport != network_transport)
@@ -3422,7 +3398,7 @@ iscsit_build_sendtargets_response(struct iscsi_cmd *cmd,
 					}
 				}
 
-				if (inaddr_any)
+				if (inet_addr_is_any((struct sockaddr *)&np->np_sockaddr))
 					sockaddr = &conn->local_sockaddr;
 				else
 					sockaddr = &np->np_sockaddr;
-- 
2.14.1

