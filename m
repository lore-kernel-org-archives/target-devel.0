From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 08 Oct 2018 16:32:24 +0000
Subject: Re: [PATCH 05/17] target/core: Make sure that target_wait_for_sess_cmds() waits long enough
Message-Id: <1539016344.64374.22.camel@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20180917213554.987-6-bvanassche@acm.org>
In-Reply-To: <20180917213554.987-6-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Sat, 2018-10-06 at 20:28 -0700, Nicholas A. Bellinger wrote:
+AD4 On Mon, 2018-09-17 at 14:35 -0700, Bart Van Assche wrote:
+AD4 +AD4 diff --git a/drivers/target/target+AF8-core+AF8-transport.c b/drivers/target/target+AF8-core+AF8-transport.c
+AD4 +AD4 index 94e9d03af99d..54ccd8f56a57 100644
+AD4 +AD4 --- a/drivers/target/target+AF8-core+AF8-transport.c
+AD4 +AD4 +-+-+- b/drivers/target/target+AF8-core+AF8-transport.c
+AD4 +AD4 +AEAAQA -224,6 +-224,13 +AEAAQA void transport+AF8-subsystem+AF8-check+AF8-init(void)
+AD4 +AD4  	sub+AF8-api+AF8-initialized +AD0 1+ADs
+AD4 +AD4  +AH0
+AD4 +AD4  
+AD4 +AD4 +-static void target+AF8-release+AF8-sess+AF8-cmd+AF8-refcnt(struct percpu+AF8-ref +ACo-ref)
+AD4 +AD4 +-+AHs
+AD4 +AD4 +-	struct se+AF8-session +ACo-sess +AD0 container+AF8-of(ref, typeof(+ACo-sess), cmd+AF8-count)+ADs
+AD4 +AD4 +-
+AD4 +AD4 +-	wake+AF8-up(+ACY-sess-+AD4-cmd+AF8-list+AF8-wq)+ADs
+AD4 +AD4 +-+AH0
+AD4 +AD4 +-
+AD4 +AD4  /+ACoAKg
+AD4 +AD4   +ACo transport+AF8-init+AF8-session - initialize a session object
+AD4 +AD4   +ACo +AEA-se+AF8-sess: Session object pointer.
+AD4 +AD4 +AEAAQA -237,7 +-244,8 +AEAAQA int transport+AF8-init+AF8-session(struct se+AF8-session +ACo-se+AF8-sess)
+AD4 +AD4  	INIT+AF8-LIST+AF8-HEAD(+ACY-se+AF8-sess-+AD4-sess+AF8-cmd+AF8-list)+ADs
+AD4 +AD4  	spin+AF8-lock+AF8-init(+ACY-se+AF8-sess-+AD4-sess+AF8-cmd+AF8-lock)+ADs
+AD4 +AD4  	init+AF8-waitqueue+AF8-head(+ACY-se+AF8-sess-+AD4-cmd+AF8-list+AF8-wq)+ADs
+AD4 +AD4 -	return 0+ADs
+AD4 +AD4 +-	return percpu+AF8-ref+AF8-init(+ACY-se+AF8-sess-+AD4-cmd+AF8-count,
+AD4 +AD4 +-			       target+AF8-release+AF8-sess+AF8-cmd+AF8-refcnt, 0, GFP+AF8-KERNEL)+ADs
+AD4 +AD4  +AH0
+AD4 +AD4  EXPORT+AF8-SYMBOL(transport+AF8-init+AF8-session)+ADs
+AD4 +AD4  
+AD4 +AD4 +AEAAQA -587,6 +-595,7 +AEAAQA void transport+AF8-free+AF8-session(struct se+AF8-session +ACo-se+AF8-sess)
+AD4 +AD4  		sbitmap+AF8-queue+AF8-free(+ACY-se+AF8-sess-+AD4-sess+AF8-tag+AF8-pool)+ADs
+AD4 +AD4  		kvfree(se+AF8-sess-+AD4-sess+AF8-cmd+AF8-map)+ADs
+AD4 +AD4  	+AH0
+AD4 +AD4 +-	percpu+AF8-ref+AF8-exit(+ACY-se+AF8-sess-+AD4-cmd+AF8-count)+ADs
+AD4 +AD4  	kmem+AF8-cache+AF8-free(se+AF8-sess+AF8-cache, se+AF8-sess)+ADs
+AD4 +AD4  +AH0
+AD4 +AD4  EXPORT+AF8-SYMBOL(transport+AF8-free+AF8-session)+ADs
+AD4 +AD4 +AEAAQA -2730,6 +-2739,7 +AEAAQA int target+AF8-get+AF8-sess+AF8-cmd(struct se+AF8-cmd +ACo-se+AF8-cmd, bool ack+AF8-kref)
+AD4 +AD4  	+AH0
+AD4 +AD4  	se+AF8-cmd-+AD4-transport+AF8-state +AHwAPQ CMD+AF8-T+AF8-PRE+AF8-EXECUTE+ADs
+AD4 +AD4  	list+AF8-add+AF8-tail(+ACY-se+AF8-cmd-+AD4-se+AF8-cmd+AF8-list, +ACY-se+AF8-sess-+AD4-sess+AF8-cmd+AF8-list)+ADs
+AD4 +AD4 +-	percpu+AF8-ref+AF8-get(+ACY-se+AF8-sess-+AD4-cmd+AF8-count)+ADs
+AD4 +AD4  out:
+AD4 +AD4  	spin+AF8-unlock+AF8-irqrestore(+ACY-se+AF8-sess-+AD4-sess+AF8-cmd+AF8-lock, flags)+ADs
+AD4 +AD4  
+AD4 
+AD4 This would need to be a percpu+AF8-ref+AF8-tryget+AF8-live() before
+AD4 CMD+AF8-T+AF8-PRE+AF8-EXECUTE is assigned, replacing the sess-+AD4-sess+AF8-tearing+AF8-down
+AD4 check.

I think the current code is fine since the percpu+AF8-ref+AF8-get() call happens
with the sess+AF8-cmd+AF8-lock held and after the sess+AF8-tearing+AF8-down flag has been
checked. The spinlock is needed anyway to protect the list+AF8-add+AF8-tail() call.
Let's keep the discussion about dropping se+AF8-cmd+AF8-list and switching to
sbitmap instead for later because this patch series is already complicated
enough and also because I'm not convinced that that switching to an sbitmap
would be an improvement.

+AD4 +AD4 +AEAAQA -2769,6 +-2777,8 +AEAAQA static void target+AF8-release+AF8-cmd+AF8-kref(struct kref +ACo-kref)
+AD4 +AD4  	se+AF8-cmd-+AD4-se+AF8-tfo-+AD4-release+AF8-cmd(se+AF8-cmd)+ADs
+AD4 +AD4  	if (compl)
+AD4 +AD4  		complete(compl)+ADs
+AD4 +AD4 +-
+AD4 +AD4 +-	percpu+AF8-ref+AF8-put(+ACY-se+AF8-sess-+AD4-cmd+AF8-count)+ADs
+AD4 +AD4  +AH0
+AD4 +AD4  
+AD4 +AD4  /+ACoAKg
+AD4 +AD4 +AEAAQA -2897,6 +-2907,8 +AEAAQA void target+AF8-sess+AF8-cmd+AF8-list+AF8-set+AF8-waiting(struct se+AF8-session +ACo-se+AF8-sess)
+AD4 +AD4  	spin+AF8-lock+AF8-irqsave(+ACY-se+AF8-sess-+AD4-sess+AF8-cmd+AF8-lock, flags)+ADs
+AD4 +AD4  	se+AF8-sess-+AD4-sess+AF8-tearing+AF8-down +AD0 1+ADs
+AD4 +AD4  	spin+AF8-unlock+AF8-irqrestore(+ACY-se+AF8-sess-+AD4-sess+AF8-cmd+AF8-lock, flags)+ADs
+AD4 +AD4 +-
+AD4 +AD4 +-	percpu+AF8-ref+AF8-kill+AF8-and+AF8-confirm(+ACY-se+AF8-sess-+AD4-cmd+AF8-count, NULL)+ADs
+AD4 +AD4  +AH0
+AD4 +AD4  EXPORT+AF8-SYMBOL(target+AF8-sess+AF8-cmd+AF8-list+AF8-set+AF8-waiting)+ADs
+AD4 +AD4  
+AD4 
+AD4 Here is where percpu-ref and RCU grace-period magic comes in..
+AD4 
+AD4 As a (future) consequence of relying solely upon se+AF8-sess-+AD4-cmd+AF8-count, the
+AD4 percpu+AF8-ref+AF8-kill+AF8-and+AF8-confirm() needs a percpu+AF8-ref-+AD4-confirm+AF8-switch()
+AD4 callback to work correctly, along with a matching local
+AD4 wait+AF8-for+AF8-completion() within target+AF8-sess+AF8-cmd+AF8-list+AF8-set+AF8-waiting().

I do not agree. A session is only freed after target+AF8-wait+AF8-for+AF8-sess+AF8-cmds()
has returned so it is sufficient if that function waits until the switch
to atomic mode of the percpu-refcount has finished. I don't see why
target+AF8-sess+AF8-cmd+AF8-list+AF8-set+AF8-waiting() should wait until the switch to atomic
mode has finished.

Bart.
