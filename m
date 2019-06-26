From: Maurizio Lombardi <mlombard@redhat.com>
Date: Wed, 26 Jun 2019 15:48:36 +0000
Subject: [PATCH] target/iscsi: set auth_protocol back to NULL if CHAP_A value is not supported.
Message-Id: <20190626154836.11542-1-mlombard@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

If the CHAP_A value is not supported, the chap_server_open() function
should free the auth_protocol pointer and set it to NULL, or
we will leave a dangling pointer around.

[   66.010905] Unsupported CHAP_A value
[   66.011660] Security negotiation failed.
[   66.012443] iSCSI Login negotiation failed.
[   68.413924] general protection fault: 0000 [#1] SMP PTI
[   68.414962] CPU: 0 PID: 1562 Comm: targetcli Kdump: loaded Not tainted 4.18.0-80.el8.x86_64 #1
[   68.416589] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[   68.417677] RIP: 0010:__kmalloc_track_caller+0xc2/0x210

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/target/iscsi/iscsi_target_auth.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/iscsi/iscsi_target_auth.c
index b6e4862cc242..139abb19da43 100644
--- a/drivers/target/iscsi/iscsi_target_auth.c
+++ b/drivers/target/iscsi/iscsi_target_auth.c
@@ -119,6 +119,7 @@ static struct iscsi_chap *chap_server_open(
 	default:
 		pr_err("Unsupported CHAP_A value\n");
 		kfree(conn->auth_protocol);
+		conn->auth_protocol = NULL;
 		return NULL;
 	}
 
-- 
Maurizio Lombardi
