From: Bart Van Assche <Bart.VanAssche@wdc.com>
Date: Wed, 18 Jul 2018 22:11:12 +0000
Subject: Re: [PATCH 03/15] target: fix __transport_register_session locking
Message-Id: <5314c2679866b3f099502f38938e9dd7e7c1ed7c.camel@wdc.com>
List-Id: <target-devel.vger.kernel.org>
References: <1531696591-8558-4-git-send-email-mchristi@redhat.com>
In-Reply-To: <1531696591-8558-4-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Sun, 2018-07-15 at 18:16 -0500, Mike Christie wrote:
+AD4- When +AF8AXw-transport+AF8-register+AF8-session is called from
+AD4- transport+AF8-register+AF8-session irqs will already have been disabled,
+AD4- so we do not want the unlock irq call to enable them until
+AD4- the higher level has done the final
+AD4- spin+AF8-unlock+AF8-irqrestore/spin+AF8-unlock+AF8-irq.
+AD4- 
+AD4- This has +AF8AXw-transport+AF8-register+AF8-session use the save/restore
+AD4- call.

Reviewed-by: Bart Van Assche +ADw-bart.vanassche+AEA-wdc.com+AD4-


