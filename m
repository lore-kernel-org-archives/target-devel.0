From: Bart Van Assche <Bart.VanAssche@wdc.com>
Date: Mon, 06 Aug 2018 23:35:26 +0000
Subject: Re: [PATCH v2] target: fix tcm_loop build errors when SCSI=m
Message-Id: <61b623a6cce458a16be3a7e19edf25c22c5bb907.camel@wdc.com>
List-Id: <target-devel.vger.kernel.org>
References: <24dc30ca-b558-fb6c-d478-967dbfa887c4@infradead.org>
In-Reply-To: <24dc30ca-b558-fb6c-d478-967dbfa887c4@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Mon, 2018-08-06 at 16:29 -0700, Randy Dunlap wrote:
+AD4- On 08/06/2018 04:26 PM, Bart Van Assche wrote:
+AD4- +AD4- On Mon, 2018-08-06 at 16:20 -0700, Randy Dunlap wrote:
+AD4- +AD4- +AD4- Fixes: 3703b2c5d041 (+ACIAWw-SCSI+AF0- tcm+AF8-loop: Add multi-fabric Linux/SCSI LLD
+AD4- +AD4- +AD4-        fabric module+ACI-)
+AD4- +AD4- 
+AD4- +AD4- From drivers/target/Kconfig on Linus' master branch:
+AD4- +AD4- 
+AD4- +AD4- menuconfig TARGET+AF8-CORE
+AD4- +AD4- 	tristate +ACI-Generic Target Core Mod (TCM) and ConfigFS Infrastructure+ACI-
+AD4- +AD4- 	depends on SCSI +ACYAJg- BLOCK
+AD4- +AD4- 
+AD4- +AD4- if TARGET+AF8-CORE
+AD4- +AD4- +AFs- ... +AF0-
+AD4- +AD4- source +ACI-drivers/target/loopback/Kconfig+ACI-
+AD4- +AD4- endif
+AD4- +AD4- 
+AD4- +AD4- In other words, the loopback driver already depends on SCSI. So I doubt that
+AD4- +AD4- this is a longstanding issue. Did you encounter this with Linus' master branch
+AD4- +AD4- or rather with linux-next?
+AD4- 
+AD4- Darn.  Thanks for the info.
+AD4- 
+AD4- I encountered it in linux-next.  I'll dig deeper.

This patch series may be what you are looking for: +ACIAWw-PATCH v2 0/9+AF0- block:
Consolidate scsi sense buffer usage+ACI- (https://lkml.org/lkml/2018/7/31/829).

Bart.

