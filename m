From: Bart Van Assche <bvanassche@acm.org>
Date: Thu, 29 Nov 2018 16:35:26 +0000
Subject: Re: [PATCH v4 6/7] target: remove hardcoded T10 Vendor ID in INQUIRY response
Message-Id: <1543509326.185366.129.camel@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20181129010157.12687-7-ddiss@suse.de>
In-Reply-To: <20181129010157.12687-7-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Thu, 2018-11-29 at 02:01 +-0100, David Disseldorp wrote:
+AD4 Use the value stored in t10+AF8-wwn.vendor, which defaults to +ACI-LIO-ORG+ACI, but
+AD4 can be reconfigured via the vendor+AF8-id ConfigFS attribute.
+AD4 
+AD4 Signed-off-by: David Disseldorp +ADw-ddiss+AEA-suse.de+AD4
+AD4 ---
+AD4  drivers/target/target+AF8-core+AF8-spc.c +AHw 8 +-+-+-+-+----
+AD4  1 file changed, 5 insertions(+-), 3 deletions(-)
+AD4 
+AD4 diff --git a/drivers/target/target+AF8-core+AF8-spc.c b/drivers/target/target+AF8-core+AF8-spc.c
+AD4 index 8ffe712cb44d..4503f3336bc2 100644
+AD4 --- a/drivers/target/target+AF8-core+AF8-spc.c
+AD4 +-+-+- b/drivers/target/target+AF8-core+AF8-spc.c
+AD4 +AEAAQA -115,7 +-115,8 +AEAAQA spc+AF8-emulate+AF8-inquiry+AF8-std(struct se+AF8-cmd +ACo-cmd, unsigned char +ACo-buf)
+AD4  	 +ACo-/
+AD4  	memset(+ACY-buf+AFs-8+AF0, 0x20,
+AD4  	       INQUIRY+AF8-VENDOR+AF8-LEN +- INQUIRY+AF8-MODEL+AF8-LEN +- INQUIRY+AF8-REVISION+AF8-LEN)+ADs
+AD4 -	memcpy(+ACY-buf+AFs-8+AF0, +ACI-LIO-ORG+ACI, sizeof(+ACI-LIO-ORG+ACI) - 1)+ADs
+AD4 +-	memcpy(+ACY-buf+AFs-8+AF0, dev-+AD4-t10+AF8-wwn.vendor,
+AD4 +-	       strnlen(dev-+AD4-t10+AF8-wwn.vendor, INQUIRY+AF8-VENDOR+AF8-LEN))+ADs
+AD4  	memcpy(+ACY-buf+AFs-16+AF0, dev-+AD4-t10+AF8-wwn.model,
+AD4  	       strnlen(dev-+AD4-t10+AF8-wwn.model, INQUIRY+AF8-MODEL+AF8-LEN))+ADs
+AD4  	memcpy(+ACY-buf+AFs-32+AF0, dev-+AD4-t10+AF8-wwn.revision,
+AD4 +AEAAQA -258,8 +-259,9 +AEAAQA spc+AF8-emulate+AF8-evpd+AF8-83(struct se+AF8-cmd +ACo-cmd, unsigned char +ACo-buf)
+AD4  	buf+AFs-off+-1+AF0 +AD0 0x1+ADs /+ACo T10 Vendor ID +ACo-/
+AD4  	buf+AFs-off+-2+AF0 +AD0 0x0+ADs
+AD4  	/+ACo left align Vendor ID and pad with spaces +ACo-/
+AD4 -	memset(+ACY-buf+AFs-off+-4+AF0, 0x20, 8)+ADs
+AD4 -	memcpy(+ACY-buf+AFs-off+-4+AF0, +ACI-LIO-ORG+ACI, sizeof(+ACI-LIO-ORG+ACI) - 1)+ADs
+AD4 +-	memset(+ACY-buf+AFs-off+-4+AF0, 0x20, INQUIRY+AF8-VENDOR+AF8-LEN)+ADs
+AD4 +-	memcpy(+ACY-buf+AFs-off+-4+AF0, dev-+AD4-t10+AF8-wwn.vendor,
+AD4 +-	       strnlen(dev-+AD4-t10+AF8-wwn.vendor, INQUIRY+AF8-VENDOR+AF8-LEN))+ADs
+AD4  	/+ACo Extra Byte for NULL Terminator +ACo-/
+AD4  	id+AF8-len+-+-+ADs
+AD4  	/+ACo Identifier Length +ACo-/

Where is the code that initializes dev-+AD4-t10+AF8-wwn.vendor to +ACI-LIO-ORG+ACI? Did I
perhaps overlook something? Additionally, why are you using strnlen() for
a string of which it is guaranteed that its length is less than or equal to
the second strnlen() argument?

Thanks,

Bart.
