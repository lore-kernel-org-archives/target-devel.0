From: tangwenji <hndksztwj@163.com>
Date: Wed, 13 Mar 2019 14:56:38 +0000
Subject: [PATCH] target:iscsi:fix np_ip_proto and np_sock_type in iscsit_setup_np
Message-Id: <1552488998-3604-1-git-send-email-hndksztwj@163.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

From: tangwenji <tang.wenji@zte.com.cn>

In the switch, np_ip_proto and np_sock_type set different values according to np_network_transport, and then uniformly assign values, so the previous values are overwritten.

Signed-off-by: tangwenji <tang.wenji@zte.com.cn>
---
 drivers/target/iscsi/iscsi_target_login.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index ae3209e..c526e66 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -883,9 +883,6 @@ int iscsit_setup_np(
 		return -EINVAL;
 	}
 
-	np->np_ip_proto = IPPROTO_TCP;
-	np->np_sock_type = SOCK_STREAM;
-
 	ret = sock_create(sockaddr->ss_family, np->np_sock_type,
 			np->np_ip_proto, &sock);
 	if (ret < 0) {
-- 
2.5.0.windows.1
