From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 12 Nov 2019 03:57:51 +0000
Subject: [PATCH 2/3] target/core: Fix a use-after-free in the TMF handling code
Message-Id: <20191112035752.8338-3-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

The target_remove_from_state_list() call uses the cmd->dev pointer. Make
sure that that pointer remains valid as long as TMF processing is in
progress.  This patch fixes the following KASAN complaint:

BUG: KASAN: use-after-free in target_remove_from_state_list+0x22/0x130 [target_core_mod]
Read of size 8 at addr ffff8880b110cf80 by task kworker/0:1/12

CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 5.4.0-rc1-dbg+ #6
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
Workqueue: events target_tmr_work [target_core_mod]
Call Trace:
 dump_stack+0x8a/0xd6
 print_address_description.constprop.0+0x40/0x60
 __kasan_report.cold+0x1b/0x33
 kasan_report+0x16/0x20
 __asan_load8+0x58/0x90
 target_remove_from_state_list+0x22/0x130 [target_core_mod]
 transport_cmd_check_stop_to_fabric+0x17/0xe0 [target_core_mod]
 target_tmr_work+0xe2/0x1a0 [target_core_mod]
 process_one_work+0x549/0xa40
 worker_thread+0x7a/0x5d0
 kthread+0x1bc/0x210
 ret_from_fork+0x24/0x30

The buggy address belongs to the page:
page:ffffea0002c44300 refcount:0 mapcount:0 mapping:0000000000000000 index:0x0
flags: 0x1fff000000000000()
raw: 1fff000000000000 0000000000000000 ffffea0002c44308 0000000000000000
raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8880b110ce80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff8880b110cf00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>ffff8880b110cf80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                   ^
 ffff8880b110d000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff8880b110d080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff

Cc: Mike Christie <mchristi@redhat.com>
Cc: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/target_core_transport.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 09f833c1de8a..ba6bd73fe63b 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3256,6 +3256,8 @@ static void target_tmr_work(struct work_struct *work)
 	struct se_tmr_req *tmr = cmd->se_tmr_req;
 	int ret;
 
+	target_depend_item(&dev->dev_group.cg_item);
+
 	if (cmd->transport_state & CMD_T_ABORTED)
 		goto aborted;
 
@@ -3297,10 +3299,14 @@ static void target_tmr_work(struct work_struct *work)
 	cmd->se_tfo->queue_tm_rsp(cmd);
 
 	transport_cmd_check_stop_to_fabric(cmd);
+
+out:
+	target_undepend_item(&dev->dev_group.cg_item);
 	return;
 
 aborted:
 	target_handle_abort(cmd);
+	goto out;
 }
 
 int transport_generic_handle_tmr(
-- 
2.23.0
