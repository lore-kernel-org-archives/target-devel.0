From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Date: Thu, 16 Nov 2017 06:14:19 +0000
Subject: [PATCH-4.1.y 7/7] target: Fix node_acl demo-mode + uncached dynamic shutdown regression
Message-Id: <1510812859-15101-8-git-send-email-nab@linux-iscsi.org>
List-Id: <target-devel.vger.kernel.org>
References: <1510812859-15101-1-git-send-email-nab@linux-iscsi.org>
In-Reply-To: <1510812859-15101-1-git-send-email-nab@linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel <target-devel@vger.kernel.org>
Cc: stable <stable@vger.kernel.org>, Sasha Levin <alexander.levin@verizon.com>, Greg-KH <gregkh@linuxfoundation.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Justin Maggard <jmaggard01@gmail.com>

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 6f48655facfd7f7ccfe6d252ac0fe319ab02e4dd upstream.

This patch fixes a generate_node_acls = 1 + cache_dynamic_acls = 0
regression, that was introduced by

  commit 01d4d673558985d9a118e1e05026633c3e2ade9b
  Author: Nicholas Bellinger <nab@linux-iscsi.org>
  Date:   Wed Dec 7 12:55:54 2016 -0800

which originally had the proper list_del_init() usage, but was
dropped during list review as it was thought unnecessary by HCH.

However, list_del_init() usage is required during the special
generate_node_acls = 1 + cache_dynamic_acls = 0 case when
transport_free_session() does a list_del(&se_nacl->acl_list),
followed by target_complete_nacl() doing the same thing.

This was manifesting as a general protection fault as reported
by Justin:

kernel: general protection fault: 0000 [#1] SMP
kernel: Modules linked in:
kernel: CPU: 0 PID: 11047 Comm: iscsi_ttx Not tainted 4.13.0-rc2.x86_64.1+ #20
kernel: Hardware name: Intel Corporation S5500BC/S5500BC, BIOS S5500.86B.01.00.0064.050520141428 05/05/2014
kernel: task: ffff88026939e800 task.stack: ffffc90007884000
kernel: RIP: 0010:target_put_nacl+0x49/0xb0
kernel: RSP: 0018:ffffc90007887d70 EFLAGS: 00010246
kernel: RAX: dead000000000200 RBX: ffff8802556ca000 RCX: 0000000000000000
kernel: RDX: dead000000000100 RSI: 0000000000000246 RDI: ffff8802556ce028
kernel: RBP: ffffc90007887d88 R08: 0000000000000001 R09: 0000000000000000
kernel: R10: ffffc90007887df8 R11: ffffea0009986900 R12: ffff8802556ce020
kernel: R13: ffff8802556ce028 R14: ffff8802556ce028 R15: ffffffff88d85540
kernel: FS:  0000000000000000(0000) GS:ffff88027fc00000(0000) knlGS:0000000000000000
kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
kernel: CR2: 00007fffe36f5f94 CR3: 0000000009209000 CR4: 00000000003406f0
kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
kernel: DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
kernel: Call Trace:
kernel:  transport_free_session+0x67/0x140
kernel:  transport_deregister_session+0x7a/0xc0
kernel:  iscsit_close_session+0x92/0x210
kernel:  iscsit_close_connection+0x5f9/0x840
kernel:  iscsit_take_action_for_connection_exit+0xfe/0x110
kernel:  iscsi_target_tx_thread+0x140/0x1e0
kernel:  ? wait_woken+0x90/0x90
kernel:  kthread+0x124/0x160
kernel:  ? iscsit_thread_get_cpumask+0x90/0x90
kernel:  ? kthread_create_on_node+0x40/0x40
kernel:  ret_from_fork+0x22/0x30
kernel: Code: 00 48 89 fb 4c 8b a7 48 01 00 00 74 68 4d 8d 6c 24 08 4c
89 ef e8 e8 28 43 00 48 8b 93 20 04 00 00 48 8b 83 28 04 00 00 4c 89
ef <48> 89 42 08 48 89 10 48 b8 00 01 00 00 00 00 ad de 48 89 83 20
kernel: RIP: target_put_nacl+0x49/0xb0 RSP: ffffc90007887d70
kernel: ---[ end trace f12821adbfd46fed ]---

To address this, go ahead and use proper list_del_list() for all
cases of se_nacl->acl_list deletion.

Reported-by: Justin Maggard <jmaggard01@gmail.com>
Tested-by: Justin Maggard <jmaggard01@gmail.com>
Cc: Justin Maggard <jmaggard01@gmail.com>
Cc: stable@vger.kernel.org # 4.1+
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_tpg.c       | 4 ++--
 drivers/target/target_core_transport.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 03f43ce..7077172 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -500,7 +500,7 @@ int core_tpg_del_initiator_node_acl(
 	if (acl->dynamic_node_acl) {
 		acl->dynamic_node_acl = 0;
 	}
-	list_del(&acl->acl_list);
+	list_del_init(&acl->acl_list);
 	tpg->num_node_acls--;
 	spin_unlock_irq(&tpg->acl_node_lock);
 
@@ -801,7 +801,7 @@ int core_tpg_deregister(struct se_portal_group *se_tpg)
 	spin_lock_irq(&se_tpg->acl_node_lock);
 	list_for_each_entry_safe(nacl, nacl_tmp, &se_tpg->acl_node_list,
 			acl_list) {
-		list_del(&nacl->acl_list);
+		list_del_init(&nacl->acl_list);
 		se_tpg->num_node_acls--;
 		spin_unlock_irq(&se_tpg->acl_node_lock);
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 64cd004..958b0dc 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -457,7 +457,7 @@ static void target_complete_nacl(struct kref *kref)
 	}
 
 	spin_lock_irqsave(&se_tpg->acl_node_lock, flags);
-	list_del(&nacl->acl_list);
+	list_del_init(&nacl->acl_list);
 	se_tpg->num_node_acls--;
 	spin_unlock_irqrestore(&se_tpg->acl_node_lock, flags);
 
@@ -530,7 +530,7 @@ void transport_free_session(struct se_session *se_sess)
 			spin_unlock(&se_nacl->nacl_sess_lock);
 
 			if (se_nacl->dynamic_stop)
-				list_del(&se_nacl->acl_list);
+				list_del_init(&se_nacl->acl_list);
 		}
 		spin_unlock_irqrestore(&se_tpg->acl_node_lock, flags);
 
-- 
1.8.5.3

