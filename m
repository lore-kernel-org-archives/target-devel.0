From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 08 Oct 2018 18:02:36 +0000
Subject: Re: [PATCH 10/17] target/core: Make it possible to wait from more than one context for command compl
Message-Id: <1539021756.64374.36.camel@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20180917213554.987-11-bvanassche@acm.org>
In-Reply-To: <20180917213554.987-11-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Sat, 2018-10-06 at 20:44 -0700, Nicholas A. Bellinger wrote:
+AD4 On Mon, 2018-09-17 at 14:35 -0700, Bart Van Assche wrote:
+AD4 +AD4 +AEAAQA -2759,9 +-2802,16 +AEAAQA static void target+AF8-release+AF8-cmd+AF8-kref(struct kref +ACo-kref)
+AD4 +AD4  +AHs
+AD4 +AD4  	struct se+AF8-cmd +ACo-se+AF8-cmd +AD0 container+AF8-of(kref, struct se+AF8-cmd, cmd+AF8-kref)+ADs
+AD4 +AD4  	struct se+AF8-session +ACo-se+AF8-sess +AD0 se+AF8-cmd-+AD4-se+AF8-sess+ADs
+AD4 +AD4 -	struct completion +ACo-compl +AD0 se+AF8-cmd-+AD4-compl+ADs
+AD4 +AD4 +-	struct wait+AF8-queue+AF8-head release+AF8-wq+ADs
+AD4 +AD4  	unsigned long flags+ADs
+AD4 +AD4  
+AD4 +AD4 +-	init+AF8-waitqueue+AF8-head(+ACY-release+AF8-wq)+ADs
+AD4 +AD4 +-	/+ACo
+AD4 +AD4 +-	 +ACo No locking is required since we are in the release function and
+AD4 +AD4 +-	 +ACo adding to release+AF8-wq is only allowed while holding a reference.
+AD4 +AD4 +-	 +ACo-/
+AD4 +AD4 +-	list+AF8-splice+AF8-init(+ACY-se+AF8-cmd-+AD4-release+AF8-wq.head, +ACY-release+AF8-wq.head)+ADs
+AD4 +AD4 +-
+AD4 +AD4  	if (se+AF8-sess) +AHs
+AD4 +AD4  		spin+AF8-lock+AF8-irqsave(+ACY-se+AF8-sess-+AD4-sess+AF8-cmd+AF8-lock, flags)+ADs
+AD4 +AD4  		list+AF8-del+AF8-init(+ACY-se+AF8-cmd-+AD4-se+AF8-cmd+AF8-list)+ADs
+AD4 +AD4 +AEAAQA -2770,8 +-2820,7 +AEAAQA static void target+AF8-release+AF8-cmd+AF8-kref(struct kref +ACo-kref)
+AD4 +AD4  
+AD4 +AD4  	target+AF8-free+AF8-cmd+AF8-mem(se+AF8-cmd)+ADs
+AD4 +AD4  	se+AF8-cmd-+AD4-se+AF8-tfo-+AD4-release+AF8-cmd(se+AF8-cmd)+ADs
+AD4 +AD4 -	if (compl)
+AD4 +AD4 -		complete(compl)+ADs
+AD4 +AD4 +-	wake+AF8-up+AF8-all(+ACY-release+AF8-wq)+ADs
+AD4 +AD4  
+AD4 +AD4  	percpu+AF8-ref+AF8-put(+ACY-se+AF8-sess-+AD4-cmd+AF8-count)+ADs
+AD4 +AD4  +AH0
+AD4 
+AD4 Your earlier commit 7b2cc7dc0 in mainline to use a local stack compl in
+AD4 transport+AF8-generic+AF8-free+AF8-cmd() was a reasonable change, because fast-path
+AD4 code in target+AF8-release+AF8-cmd+AF8-kref() was only doing a complete() when the
+AD4 se+AF8-cmd was actually being quiesced..
+AD4 
+AD4 However, the addition of wake+AF8-up+AF8-all() above for every se+AF8-cmd means a
+AD4 +AF8AXw-wake+AF8-up+AF8-common+AF8-lock() happens no matter what every time in fast-path
+AD4 code.

That's easy to fix. How about replacing this patch with the following patch?


+AFs-PATCH+AF0 target/core: Make it possible to wait from more than one context for command completion

This patch does not change any functionality but makes the next patch
easier to read.

Signed-off-by: Bart Van Assche +ADw-bvanassche+AEA-acm.org+AD4
Cc: Nicholas Bellinger +ADw-nab+AEA-linux-iscsi.org+AD4
Cc: Mike Christie +ADw-mchristi+AEA-redhat.com+AD4
Cc: Christoph Hellwig +ADw-hch+AEA-lst.de+AD4
Cc: Hannes Reinecke +ADw-hare+AEA-suse.de+AD4
---
 drivers/target/target+AF8-core+AF8-transport.c +AHw 15 +-+-+-+-+-+-+-+-+-+------
 include/target/target+AF8-core+AF8-base.h      +AHw  2 +--
 2 files changed, 11 insertions(+-), 6 deletions(-)

diff --git a/drivers/target/target+AF8-core+AF8-transport.c b/drivers/target/target+AF8-core+AF8-transport.c
index 79fa79afcdc2..de54494cf98f 100644
--- a/drivers/target/target+AF8-core+AF8-transport.c
+-+-+- b/drivers/target/target+AF8-core+AF8-transport.c
+AEAAQA -1331,7 +-1331,7 +AEAAQA void transport+AF8-init+AF8-se+AF8-cmd(
 	INIT+AF8-LIST+AF8-HEAD(+ACY-cmd-+AD4-se+AF8-cmd+AF8-list)+ADs
 	INIT+AF8-LIST+AF8-HEAD(+ACY-cmd-+AD4-state+AF8-list)+ADs
 	init+AF8-completion(+ACY-cmd-+AD4-t+AF8-transport+AF8-stop+AF8-comp)+ADs
-	cmd-+AD4-compl +AD0 NULL+ADs
+-	memset(cmd-+AD4-compl, 0, sizeof(cmd-+AD4-compl))+ADs
 	spin+AF8-lock+AF8-init(+ACY-cmd-+AD4-t+AF8-state+AF8-lock)+ADs
 	INIT+AF8-WORK(+ACY-cmd-+AD4-work, NULL)+ADs
 	kref+AF8-init(+ACY-cmd-+AD4-cmd+AF8-kref)+ADs
+AEAAQA -2692,7 +-2692,7 +AEAAQA int transport+AF8-generic+AF8-free+AF8-cmd(struct se+AF8-cmd +ACo-cmd, int wait+AF8-for+AF8-tasks)
 			transport+AF8-lun+AF8-remove+AF8-cmd(cmd)+ADs
 	+AH0
 	if (aborted)
-		cmd-+AD4-compl +AD0 +ACY-compl+ADs
+-		cmd-+AD4-compl+AFs-0+AF0 +AD0 +ACY-compl+ADs
 	if (+ACE-aborted +AHwAfA tas)
 		ret +AD0 target+AF8-put+AF8-sess+AF8-cmd(cmd)+ADs
 	if (aborted) +AHs
+AEAAQA -2759,9 +-2759,12 +AEAAQA static void target+AF8-release+AF8-cmd+AF8-kref(struct kref +ACo-kref)
 +AHs
 	struct se+AF8-cmd +ACo-se+AF8-cmd +AD0 container+AF8-of(kref, struct se+AF8-cmd, cmd+AF8-kref)+ADs
 	struct se+AF8-session +ACo-se+AF8-sess +AD0 se+AF8-cmd-+AD4-se+AF8-sess+ADs
-	struct completion +ACo-compl +AD0 se+AF8-cmd-+AD4-compl+ADs
+-	struct completion +ACo-compl+AFs-2+AF0AOw
 	unsigned long flags+ADs
 
+-	BUILD+AF8-BUG+AF8-ON(sizeof(compl) +ACEAPQ sizeof(se+AF8-cmd-+AD4-compl))+ADs
+-	memcpy(compl, se+AF8-cmd-+AD4-compl, sizeof(compl))+ADs
+-
 	if (se+AF8-sess) +AHs
 		spin+AF8-lock+AF8-irqsave(+ACY-se+AF8-sess-+AD4-sess+AF8-cmd+AF8-lock, flags)+ADs
 		list+AF8-del+AF8-init(+ACY-se+AF8-cmd-+AD4-se+AF8-cmd+AF8-list)+ADs
+AEAAQA -2770,8 +-2773,10 +AEAAQA static void target+AF8-release+AF8-cmd+AF8-kref(struct kref +ACo-kref)
 
 	target+AF8-free+AF8-cmd+AF8-mem(se+AF8-cmd)+ADs
 	se+AF8-cmd-+AD4-se+AF8-tfo-+AD4-release+AF8-cmd(se+AF8-cmd)+ADs
-	if (compl)
-		complete(compl)+ADs
+-	if (compl+AFs-0+AF0)
+-		complete(compl+AFs-0+AF0)+ADs
+-	if (compl+AFs-1+AF0)
+-		complete(compl+AFs-1+AF0)+ADs
 
 	percpu+AF8-ref+AF8-put(+ACY-se+AF8-sess-+AD4-cmd+AF8-count)+ADs
 +AH0
diff --git a/include/target/target+AF8-core+AF8-base.h b/include/target/target+AF8-core+AF8-base.h
index d084479fbe18..34c9a8ffa4af 100644
--- a/include/target/target+AF8-core+AF8-base.h
+-+-+- b/include/target/target+AF8-core+AF8-base.h
+AEAAQA -475,7 +-475,7 +AEAAQA struct se+AF8-cmd +AHs
 	struct se+AF8-session	+ACo-se+AF8-sess+ADs
 	struct se+AF8-tmr+AF8-req	+ACo-se+AF8-tmr+AF8-req+ADs
 	struct list+AF8-head	se+AF8-cmd+AF8-list+ADs
-	struct completion	+ACo-compl+ADs
+-	struct completion	+ACo-compl+AFs-2+AF0AOw
 	const struct target+AF8-core+AF8-fabric+AF8-ops +ACo-se+AF8-tfo+ADs
 	sense+AF8-reason+AF8-t		(+ACo-execute+AF8-cmd)(struct se+AF8-cmd +ACo)+ADs
 	sense+AF8-reason+AF8-t (+ACo-transport+AF8-complete+AF8-callback)(struct se+AF8-cmd +ACo, bool, int +ACo)+ADs
