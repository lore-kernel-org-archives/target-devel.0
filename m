From: Bart Van Assche <Bart.VanAssche@wdc.com>
Date: Mon, 06 Aug 2018 23:26:06 +0000
Subject: Re: [PATCH v2] target: fix tcm_loop build errors when SCSI=m
Message-Id: <6b8fdea8b49952918e7169fb1b2490e7af03e4ef.camel@wdc.com>
List-Id: <target-devel.vger.kernel.org>
References: <24dc30ca-b558-fb6c-d478-967dbfa887c4@infradead.org>
In-Reply-To: <24dc30ca-b558-fb6c-d478-967dbfa887c4@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Mon, 2018-08-06 at 16:20 -0700, Randy Dunlap wrote:
+AD4- Fixes: 3703b2c5d041 (+ACIAWw-SCSI+AF0- tcm+AF8-loop: Add multi-fabric Linux/SCSI LLD
+AD4-        fabric module+ACI-)

From drivers/target/Kconfig on Linus' master branch:

menuconfig TARGET+AF8-CORE
	tristate +ACI-Generic Target Core Mod (TCM) and ConfigFS Infrastructure+ACI-
	depends on SCSI +ACYAJg- BLOCK

if TARGET+AF8-CORE
+AFs- ... +AF0-
source +ACI-drivers/target/loopback/Kconfig+ACI-
endif

In other words, the loopback driver already depends on SCSI. So I doubt that
this is a longstanding issue. Did you encounter this with Linus' master branch
or rather with linux-next?

Thanks,

Bart.

