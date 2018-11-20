From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 20 Nov 2018 17:15:00 +0000
Subject: Re: [PATCH v3 1/4] target: use consistent left-aligned ASCII INQUIRY data
Message-Id: <1542734100.185366.68.camel@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20181119210636.22979-2-ddiss@suse.de>
In-Reply-To: <20181119210636.22979-2-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Mon, 2018-11-19 at 22:06 +-0100, David Disseldorp wrote:
+AD4 diff --git a/drivers/target/target+AF8-core+AF8-spc.c b/drivers/target/target+AF8-core+AF8-spc.c
+AD4 index f459118bc11b..c37dd36ec77d 100644
+AD4 --- a/drivers/target/target+AF8-core+AF8-spc.c
+AD4 +-+-+- b/drivers/target/target+AF8-core+AF8-spc.c
+AD4 +AEAAQA -108,12 +-108,17 +AEAAQA spc+AF8-emulate+AF8-inquiry+AF8-std(struct se+AF8-cmd +ACo-cmd, unsigned char +ACo-buf)
+AD4  
+AD4  	buf+AFs-7+AF0 +AD0 0x2+ADs /+ACo CmdQue+AD0-1 +ACo-/
+AD4  
+AD4 -	memcpy(+ACY-buf+AFs-8+AF0, +ACI-LIO-ORG +ACI, 8)+ADs
+AD4 -	memset(+ACY-buf+AFs-16+AF0, 0x20, 16)+ADs
+AD4 +-	/+ACo
+AD4 +-	 +ACo ASCII data fields described as being left-aligned shall have any
+AD4 +-	 +ACo unused bytes at the end of the field (i.e., highest offset) and the
+AD4 +-	 +ACo unused bytes shall be filled with ASCII space characters (20h).
+AD4 +-	 +ACo-/
+AD4 +-	memset(+ACY-buf+AFs-8+AF0, 0x20, 8 +- 16 +- 4)+ADs
+AD4 +-	memcpy(+ACY-buf+AFs-8+AF0, +ACI-LIO-ORG+ACI, sizeof(+ACI-LIO-ORG+ACI) - 1)+ADs
+AD4  	memcpy(+ACY-buf+AFs-16+AF0, dev-+AD4-t10+AF8-wwn.model,
+AD4 -	       min+AF8-t(size+AF8-t, strlen(dev-+AD4-t10+AF8-wwn.model), 16))+ADs
+AD4 +-	       strnlen(dev-+AD4-t10+AF8-wwn.model, 16))+ADs
+AD4  	memcpy(+ACY-buf+AFs-32+AF0, dev-+AD4-t10+AF8-wwn.revision,
+AD4 -	       min+AF8-t(size+AF8-t, strlen(dev-+AD4-t10+AF8-wwn.revision), 4))+ADs
+AD4 +-	       strnlen(dev-+AD4-t10+AF8-wwn.revision, 4))+ADs
+AD4  	buf+AFs-4+AF0 +AD0 31+ADs /+ACo Set additional length to 31 +ACo-/
+AD4  
+AD4  	return 0+ADs
+AD4 +AEAAQA -251,7 +-256,9 +AEAAQA spc+AF8-emulate+AF8-evpd+AF8-83(struct se+AF8-cmd +ACo-cmd, unsigned char +ACo-buf)
+AD4  	buf+AFs-off+AF0 +AD0 0x2+ADs /+ACo ASCII +ACo-/
+AD4  	buf+AFs-off+-1+AF0 +AD0 0x1+ADs /+ACo T10 Vendor ID +ACo-/
+AD4  	buf+AFs-off+-2+AF0 +AD0 0x0+ADs
+AD4 -	memcpy(+ACY-buf+AFs-off+-4+AF0, +ACI-LIO-ORG+ACI, 8)+ADs
+AD4 +-	/+ACo left align Vendor ID and pad with spaces +ACo-/
+AD4 +-	memset(+ACY-buf+AFs-off+-4+AF0, 0x20, 8)+ADs
+AD4 +-	memcpy(+ACY-buf+AFs-off+-4+AF0, +ACI-LIO-ORG+ACI, sizeof(+ACI-LIO-ORG+ACI) - 1)+ADs
+AD4  	/+ACo Extra Byte for NULL Terminator +ACo-/
+AD4  	id+AF8-len+-+-+ADs
+AD4  	/+ACo Identifier Length +ACo-/

A helper function that accepts a '+AFw-0'-terminated string and a field length as
input and that copies the input string and pads it with spaces would be welcome.
From the SCST source code:

	/+ACo
	 +ACo 8 byte ASCII Vendor Identification of the target
	 +ACo - left aligned.
	 +ACo-/
	scst+AF8-copy+AF8-and+AF8-fill(+ACY-buf+AFs-8+AF0, virt+AF8-dev-+AD4-t10+AF8-vend+AF8-id, 8)+ADs

	/+ACo
	 +ACo 16 byte ASCII Product Identification of the target - left
	 +ACo aligned.
	 +ACo-/
	scst+AF8-copy+AF8-and+AF8-fill(+ACY-buf+AFs-16+AF0, virt+AF8-dev-+AD4-prod+AF8-id, 16)+ADs

	/+ACo
	 +ACo 4 byte ASCII Product Revision Level of the target - left
	 +ACo aligned.
	 +ACo-/
	scst+AF8-copy+AF8-and+AF8-fill(+ACY-buf+AFs-32+AF0, virt+AF8-dev-+AD4-prod+AF8-rev+AF8-lvl, 4)+ADs

/+ACo
 +ACo Copy a zero-terminated string into a fixed-size byte array and fill the
 +ACo trailing bytes with +AEA-fill+AF8-byte.
 +ACo-/
static void scst+AF8-copy+AF8-and+AF8-fill+AF8-b(char +ACo-dst, const char +ACo-src, int len,
				 uint8+AF8-t fill+AF8-byte)
+AHs
	int cpy+AF8-len +AD0 min+AF8-t(int, strlen(src), len)+ADs

	memcpy(dst, src, cpy+AF8-len)+ADs
	memset(dst +- cpy+AF8-len, fill+AF8-byte, len - cpy+AF8-len)+ADs
+AH0

/+ACo
 +ACo Copy a zero-terminated string into a fixed-size char array and fill the
 +ACo trailing characters with spaces.
 +ACo-/
static void scst+AF8-copy+AF8-and+AF8-fill(char +ACo-dst, const char +ACo-src, int len)
+AHs
	scst+AF8-copy+AF8-and+AF8-fill+AF8-b(dst, src, len, ' ')+ADs
+AH0

Bart.
