From: Bart Van Assche <bvanassche@acm.org>
Date: Thu, 29 Nov 2018 16:17:54 +0000
Subject: Re: [PATCH v4 2/7] target: consistently null-terminate t10_wwn.vendor
Message-Id: <1543508274.185366.116.camel@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20181129010157.12687-3-ddiss@suse.de>
In-Reply-To: <20181129010157.12687-3-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Thu, 2018-11-29 at 02:01 +-0100, David Disseldorp wrote:
+AD4 -		strncpy(+ACY-dev-+AD4-t10+AF8-wwn.vendor+AFs-0+AF0, +ACI-LIO-ORG+ACI, 8)+ADs
+AD4 +-		strncpy(+ACY-dev-+AD4-t10+AF8-wwn.vendor+AFs-0+AF0, +ACI-LIO-ORG+ACI, INQUIRY+AF8-VENDOR+AF8-LEN)+ADs
+AD4 +-		dev-+AD4-t10+AF8-wwn.vendor+AFs-INQUIRY+AF8-VENDOR+AF8-LEN+AF0 +AD0 '+AFw-0'+ADs

This looks weird to me. Have you considered to use strlcpy() instead of
strncpy() and explicit '+AFw-0'-termination?

+AD4  		strncpy(+ACY-dev-+AD4-t10+AF8-wwn.model+AFs-0+AF0,
+AD4  			dev-+AD4-transport-+AD4-inquiry+AF8-prod, 16)+ADs
+AD4  		strncpy(+ACY-dev-+AD4-t10+AF8-wwn.revision+AFs-0+AF0,
+AD4 diff --git a/drivers/target/target+AF8-core+AF8-pscsi.c b/drivers/target/target+AF8-core+AF8-pscsi.c
+AD4 index 47d76c862014..ee65b5bb674c 100644
+AD4 --- a/drivers/target/target+AF8-core+AF8-pscsi.c
+AD4 +-+-+- b/drivers/target/target+AF8-core+AF8-pscsi.c
+AD4 +AEAAQA -190,7 +-190,9 +AEAAQA pscsi+AF8-set+AF8-inquiry+AF8-info(struct scsi+AF8-device +ACo-sdev, struct t10+AF8-wwn +ACo-wwn)
+AD4  	/+ACo
+AD4  	 +ACo Use sdev-+AD4-inquiry from drivers/scsi/scsi+AF8-scan.c:scsi+AF8-alloc+AF8-sdev()
+AD4  	 +ACo-/
+AD4 -	memcpy(+ACY-wwn-+AD4-vendor+AFs-0+AF0, +ACY-buf+AFs-8+AF0, sizeof(wwn-+AD4-vendor))+ADs
+AD4 +-	BUILD+AF8-BUG+AF8-ON(sizeof(wwn-+AD4-vendor) +ACEAPQ INQUIRY+AF8-VENDOR+AF8-LEN +- 1)+ADs
+AD4 +-	memcpy(+ACY-wwn-+AD4-vendor+AFs-0+AF0, +ACY-buf+AFs-8+AF0, INQUIRY+AF8-VENDOR+AF8-LEN)+ADs
+AD4 +-	wwn-+AD4-vendor+AFs-INQUIRY+AF8-VENDOR+AF8-LEN+AF0 +AD0 '+AFw-0'+ADs

Have you considered to use snprintf(..., +ACIAJQ.+ACo-s+ACI, ...) instead of memcpy()
followed by explicit '+AFw-0'-termination? I think that would result in code
that is easier to read. strlcpy() can't be used here because it is not
guaranteed that the input buffer is '+AFw-0'-terminated.

Thanks,

Bart.
