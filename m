From: Bart Van Assche <bvanassche@acm.org>
Date: Wed, 28 Nov 2018 16:36:19 +0000
Subject: Re: [PATCH v3 3/4] target: add device vendor_id configfs attribute
Message-Id: <1543422979.185366.103.camel@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20181119210636.22979-4-ddiss@suse.de>
In-Reply-To: <20181119210636.22979-4-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Wed, 2018-11-28 at 17:28 +-0100, David Disseldorp wrote:
+AD4 On Wed, 28 Nov 2018 08:08:30 -0800, Bart Van Assche wrote:
+AD4 
+AD4 +AD4 +AD4 Just a follow up here. I think it's safer to retain strncpy() in this
+AD4 +AD4 +AD4 function for the purpose of zero filling. scsi+AF8-dump+AF8-inquiry() and
+AD4 +AD4 +AD4 target+AF8-stat+AF8-lu+AF8-vend+AF8-show() walk the entire length of the t10+AF8-wwn.vendor
+AD4 +AD4 +AD4 buffer.  
+AD4 +AD4 
+AD4 +AD4 How about adding a comment about above struct t10+AF8-wwn that vendor+AFsAXQ, model+AFsAXQ
+AD4 +AD4 and revision+AFsAXQ in that structure may but do not have to be terminated with a
+AD4 +AD4 trailing '+AFw-0' and also that unit+AF8-serial+AFsAXQ is '+AFw-0'-terminated?
+AD4 +AD4 
+AD4 +AD4 It would make me happy if the size of the character arrays in that structure
+AD4 +AD4 would be increased by one and if the target code would be modified such that
+AD4 +AD4 these strings are always '+AFw-0'-terminated.
+AD4 
+AD4 I'm working on the +-1 length increase for those t10+AF8-wwn members ATM, but
+AD4 just thought I'd mention that the zeroing of unused bytes is still
+AD4 required due to the scsi+AF8-dump+AF8-inquiry() +- target+AF8-stat+AF8-lu+AF8-vend+AF8-show()
+AD4 behaviour.

Hi David,

Maybe I'm missing something, but why is zeroing of unused bytes in these functions
necessary? Would the following be correct if all strings in struct t10+AF8-wwn would be
'+AFw-0'-terminated?

 static ssize+AF8-t target+AF8-stat+AF8-lu+AF8-vend+AF8-show(struct config+AF8-item +ACo-item, char +ACo-page)
 +AHs
 	struct se+AF8-device +ACo-dev +AD0 to+AF8-stat+AF8-lu+AF8-dev(item)+ADs
-	int i+ADs
-	char str+AFs-sizeof(dev-+AD4-t10+AF8-wwn.vendor)+-1+AF0AOw
 
-	/+ACo scsiLuVendorId +ACo-/
-	for (i +AD0 0+ADs i +ADw sizeof(dev-+AD4-t10+AF8-wwn.vendor)+ADs i+-+-)
-		str+AFs-i+AF0 +AD0 ISPRINT(dev-+AD4-t10+AF8-wwn.vendor+AFs-i+AF0) ?
-			dev-+AD4-t10+AF8-wwn.vendor+AFs-i+AF0 : ' '+ADs
-	str+AFs-i+AF0 +AD0 '+AFw-0'+ADs
-	return snprintf(page, PAGE+AF8-SIZE, +ACIAJQ-s+AFw-n+ACI, str)+ADs
+-	return snprintf(page, PAGE+AF8-SIZE, +ACIAJQ--16s+AFw-n+ACI, dev-+AD4-t10+AF8-wwn.vendor)+ADs
 +AH0
+AFs ... +AF0
 static void scsi+AF8-dump+AF8-inquiry(struct se+AF8-device +ACo-dev)
 +AHs
 	struct t10+AF8-wwn +ACo-wwn +AD0 +ACY-dev-+AD4-t10+AF8-wwn+ADs
-	char buf+AFs-17+AF0AOw
-	int i, device+AF8-type+ADs
+-	int device+AF8-type +AD0 dev-+AD4-transport-+AD4-get+AF8-device+AF8-type(dev)+ADs
+-
 	/+ACo
 	 +ACo Print Linux/SCSI style INQUIRY formatting to the kernel ring buffer
 	 +ACo-/
-	for (i +AD0 0+ADs i +ADw 8+ADs i+-+-)
-		if (wwn-+AD4-vendor+AFs-i+AF0 +AD4APQ 0x20)
-			buf+AFs-i+AF0 +AD0 wwn-+AD4-vendor+AFs-i+AF0AOw
-		else
-			buf+AFs-i+AF0 +AD0 ' '+ADs
-	buf+AFs-i+AF0 +AD0 '+AFw-0'+ADs
-	pr+AF8-debug(+ACI  Vendor: +ACU-s+AFw-n+ACI, buf)+ADs
-
-	for (i +AD0 0+ADs i +ADw 16+ADs i+-+-)
-		if (wwn-+AD4-model+AFs-i+AF0 +AD4APQ 0x20)
-			buf+AFs-i+AF0 +AD0 wwn-+AD4-model+AFs-i+AF0AOw
-		else
-			buf+AFs-i+AF0 +AD0 ' '+ADs
-	buf+AFs-i+AF0 +AD0 '+AFw-0'+ADs
-	pr+AF8-debug(+ACI  Model: +ACU-s+AFw-n+ACI, buf)+ADs
-
-	for (i +AD0 0+ADs i +ADw 4+ADs i+-+-)
-		if (wwn-+AD4-revision+AFs-i+AF0 +AD4APQ 0x20)
-			buf+AFs-i+AF0 +AD0 wwn-+AD4-revision+AFs-i+AF0AOw
-		else
-			buf+AFs-i+AF0 +AD0 ' '+ADs
-	buf+AFs-i+AF0 +AD0 '+AFw-0'+ADs
-	pr+AF8-debug(+ACI  Revision: +ACU-s+AFw-n+ACI, buf)+ADs
-
-	device+AF8-type +AD0 dev-+AD4-transport-+AD4-get+AF8-device+AF8-type(dev)+ADs
+-	pr+AF8-debug(+ACI  Vendor: +ACU--8s+AFw-n+ACI, wwn-+AD4-vendor)+ADs
+-	pr+AF8-debug(+ACI  Model: +ACU--16s+AFw-n+ACI, wwn-+AD4-model)+ADs
+-	pr+AF8-debug(+ACI  Revision: +ACU--4s+AFw-n+ACI, wwn-+AD4-revision)+ADs
 	pr+AF8-debug(+ACI  Type:   +ACU-s +ACI, scsi+AF8-device+AF8-type(device+AF8-type))+ADs
 +AH0

Thanks,

Bart.
