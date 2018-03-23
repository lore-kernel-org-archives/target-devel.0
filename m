From: "bigeasy@linutronix.de" <bigeasy@linutronix.de>
Date: Fri, 23 Mar 2018 17:19:59 +0000
Subject: [PATCH 2/2] target: remove spin_lock_assert() in __target_(attach|detach)_tg_pt_gp()
Message-Id: <20180323171959.7ac6klrqg4fdk3ey@linutronix.de>
List-Id: <target-devel.vger.kernel.org>
References: <20180321153854.GB24312@kernel.org>
 <CA+55aFwKN_JijmCt=0S4jF8KzGPmoKNbuYF59va7U4ziJLLryA@mail.gmail.com>
 <20180322093745.GC4229@kernel.org>
 <20180323155513.dwbgvblenlji33as@linutronix.de>
 <1521822325.2535.5.camel@wdc.com>
 <CA+55aFxVkuntSektVmwXktzvfEezdDTAM_zj4DJdp3qJxWf8aA@mail.gmail.com>
 <20180323171736.bcyi2oiolge4l6hl@linutronix.de>
In-Reply-To: <20180323171736.bcyi2oiolge4l6hl@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "acme@kernel.org" <acme@kernel.org>, "daniel@bristot.me" <daniel@bristot.me>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "peterz@infradead.org" <peterz@infradead.org>, "rostedt@goodmis.org" <rostedt@goodmis.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "williams@redhat.com" <williams@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "lclaudio@redhat.com" <lclaudio@redhat.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>

__target_attach_tg_pt_gp() and __target_detach_tg_pt_gp() check if the caller
holds lun_tg_pt_gp_lock(). Both functions are static, the callers are
acquiring the lock before the invocation of the function so the check
looks superfluous.
Remove it.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/target/target_core_alua.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index e46ca968009c..e5bda674bdbd 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -1843,8 +1843,6 @@ static void __target_attach_tg_pt_gp(struct se_lun *lun,
 {
 	struct se_dev_entry *se_deve;
 
-	assert_spin_locked(&lun->lun_tg_pt_gp_lock);
-
 	spin_lock(&tg_pt_gp->tg_pt_gp_lock);
 	lun->lun_tg_pt_gp = tg_pt_gp;
 	list_add_tail(&lun->lun_tg_pt_gp_link, &tg_pt_gp->tg_pt_gp_lun_list);
@@ -1868,8 +1866,6 @@ void target_attach_tg_pt_gp(struct se_lun *lun,
 static void __target_detach_tg_pt_gp(struct se_lun *lun,
 		struct t10_alua_tg_pt_gp *tg_pt_gp)
 {
-	assert_spin_locked(&lun->lun_tg_pt_gp_lock);
-
 	spin_lock(&tg_pt_gp->tg_pt_gp_lock);
 	list_del_init(&lun->lun_tg_pt_gp_link);
 	tg_pt_gp->tg_pt_gp_members--;
-- 
2.16.2

