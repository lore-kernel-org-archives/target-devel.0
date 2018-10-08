From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 08 Oct 2018 16:14:18 +0000
Subject: Re: [PATCH 05/17] target/core: Make sure that target_wait_for_sess_cmds() waits long enough
Message-Id: <1539015258.64374.8.camel@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20180917213554.987-6-bvanassche@acm.org>
In-Reply-To: <20180917213554.987-6-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Sat, 2018-10-06 at 14:05 +-0200, Christoph Hellwig wrote:
+AD4 On Mon, Sep 17, 2018 at 02:35:42PM -0700, Bart Van Assche wrote:
+AD4 +AD4 A session must only be released after all code that accesses the session
+AD4 +AD4 structure has finished. Make sure that this is the case by introducing a
+AD4 +AD4 new command counter per session that is only decremented after the
+AD4 +AD4 .release+AF8-cmd() callback has finished.
+AD4 
+AD4 Can you explain what problems we are running into right now due to the
+AD4 lack of a refcount?

I will explain that further down in this e-mail.

+AD4 +AD4 +AEAAQA -2897,6 +-2907,8 +AEAAQA void target+AF8-sess+AF8-cmd+AF8-list+AF8-set+AF8-waiting(struct se+AF8-session +ACo-se+AF8-sess)
+AD4 +AD4  	spin+AF8-lock+AF8-irqsave(+ACY-se+AF8-sess-+AD4-sess+AF8-cmd+AF8-lock, flags)+ADs
+AD4 +AD4  	se+AF8-sess-+AD4-sess+AF8-tearing+AF8-down +AD0 1+ADs
+AD4 +AD4  	spin+AF8-unlock+AF8-irqrestore(+ACY-se+AF8-sess-+AD4-sess+AF8-cmd+AF8-lock, flags)+ADs
+AD4 +AD4 +-
+AD4 +AD4 +-	percpu+AF8-ref+AF8-kill+AF8-and+AF8-confirm(+ACY-se+AF8-sess-+AD4-cmd+AF8-count, NULL)+ADs
+AD4 
+AD4 This is equivalent ot a plain percpu+AF8-ref+AF8-kill call.

OK, I will change this into percpu+AF8-ref+AF8-kill().

+AD4 +AD4 +AEAAQA -2911,17 +-2923,14 +AEAAQA void target+AF8-wait+AF8-for+AF8-sess+AF8-cmds(struct se+AF8-session +ACo-se+AF8-sess)
+AD4 +AD4  
+AD4 +AD4  	WARN+AF8-ON+AF8-ONCE(+ACE-se+AF8-sess-+AD4-sess+AF8-tearing+AF8-down)+ADs
+AD4 +AD4  
+AD4 +AD4 -	spin+AF8-lock+AF8-irq(+ACY-se+AF8-sess-+AD4-sess+AF8-cmd+AF8-lock)+ADs
+AD4 +AD4  	do +AHs
+AD4 +AD4 -		ret +AD0 wait+AF8-event+AF8-interruptible+AF8-lock+AF8-irq+AF8-timeout(
+AD4 +AD4 -				se+AF8-sess-+AD4-cmd+AF8-list+AF8-wq,
+AD4 +AD4 -				list+AF8-empty(+ACY-se+AF8-sess-+AD4-sess+AF8-cmd+AF8-list),
+AD4 +AD4 -				se+AF8-sess-+AD4-sess+AF8-cmd+AF8-lock, 180 +ACo HZ)+ADs
+AD4 +AD4 +-		ret +AD0 wait+AF8-event+AF8-timeout(se+AF8-sess-+AD4-cmd+AF8-list+AF8-wq,
+AD4 +AD4 +-				percpu+AF8-ref+AF8-is+AF8-zero(+ACY-se+AF8-sess-+AD4-cmd+AF8-count),
+AD4 +AD4 +-				180 +ACo HZ)+ADs
+AD4 
+AD4 So this is basically the big change - check for a zero reference instead
+AD4 of the list+AF8-empty.
+AD4 
+AD4 I fail to see how this makes a difference, and also why we even need a
+AD4 percpu ref as the get/pull calls are under, or right next to
+AD4 sess+AF8-cmd+AF8-lock critical sections.

Hi Christoph,

After having called target+AF8-wait+AF8-for+AF8-sess+AF8-cmds(), several target drivers call
target+AF8-remove+AF8-session(). That last function frees the session object
synchronously. In other words, it is not safe to use the session pointer after
target+AF8-wait+AF8-for+AF8-sess+AF8-cmds() has returned. That means that
target+AF8-wait+AF8-for+AF8-sess+AF8-cmds() must wait until all code that can dereference the
session pointer has finished, including target+AF8-release+AF8-cmd+AF8-kref(). That
function executes the following code after having removed a command from the
command list:

	target+AF8-free+AF8-cmd+AF8-mem(se+AF8-cmd)+ADs
	se+AF8-cmd-+AD4-se+AF8-tfo-+AD4-release+AF8-cmd(se+AF8-cmd)+ADs
	if (compl)
		complete(compl)+ADs

Hence this patch that makes target+AF8-wait+AF8-for+AF8-sess+AF8-cmds() wait until
target+AF8-release+AF8-cmd+AF8-kref() has called .release+AF8-cmd(). Since I applied this patch
I have not hit the following crash anymore:

BUG: KASAN: use-after-free in do+AF8-raw+AF8-spin+AF8-lock+-0x1c/0x130
Read of size 4 at addr ffff8801534b16e4 by task rmdir/14805
CPU: 16 PID: 14805 Comm: rmdir Not tainted 4.18.0-rc2-dbg+- +ACM-5
Call Trace:
dump+AF8-stack+-0xa4/0xf5
print+AF8-address+AF8-description+-0x6f/0x270
kasan+AF8-report+-0x241/0x360
+AF8AXw-asan+AF8-load4+-0x78/0x80
do+AF8-raw+AF8-spin+AF8-lock+-0x1c/0x130
+AF8-raw+AF8-spin+AF8-lock+AF8-irqsave+-0x52/0x60
srpt+AF8-set+AF8-ch+AF8-state+-0x27/0x70 +AFs-ib+AF8-srpt+AF0
srpt+AF8-disconnect+AF8-ch+-0x1b/0xc0 +AFs-ib+AF8-srpt+AF0
srpt+AF8-close+AF8-session+-0xa8/0x260 +AFs-ib+AF8-srpt+AF0
target+AF8-shutdown+AF8-sessions+-0x170/0x180 +AFs-target+AF8-core+AF8-mod+AF0
core+AF8-tpg+AF8-del+AF8-initiator+AF8-node+AF8-acl+-0xf3/0x200 +AFs-target+AF8-core+AF8-mod+AF0
target+AF8-fabric+AF8-nacl+AF8-base+AF8-release+-0x25/0x30 +AFs-target+AF8-core+AF8-mod+AF0
config+AF8-item+AF8-release+-0x9c/0x110 +AFs-configfs+AF0
config+AF8-item+AF8-put+-0x26/0x30 +AFs-configfs+AF0
configfs+AF8-rmdir+-0x3b8/0x510 +AFs-configfs+AF0
vfs+AF8-rmdir+-0xb3/0x1e0
do+AF8-rmdir+-0x262/0x2c0
do+AF8-syscall+AF8-64+-0x77/0x230
entry+AF8-SYSCALL+AF8-64+AF8-after+AF8-hwframe+-0x49/0xbe

Please let me know if you need more information.

Bart.
