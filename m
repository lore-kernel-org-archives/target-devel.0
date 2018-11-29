From: Bart Van Assche <bvanassche@acm.org>
Date: Thu, 29 Nov 2018 16:24:38 +0000
Subject: Re: [PATCH v4 3/7] target: consistently null-terminate t10_wwn.model
Message-Id: <1543508678.185366.122.camel@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20181129010157.12687-4-ddiss@suse.de>
In-Reply-To: <20181129010157.12687-4-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Thu, 2018-11-29 at 02:01 +-0100, David Disseldorp wrote:
+AD4 diff --git a/drivers/target/target+AF8-core+AF8-configfs.c b/drivers/target/target+AF8-core+AF8-configfs.c
+AD4 index f6b1549f4142..9f49b1afd685 100644
+AD4 --- a/drivers/target/target+AF8-core+AF8-configfs.c
+AD4 +-+-+- b/drivers/target/target+AF8-core+AF8-configfs.c
+AD4 +AEAAQA -613,12 +-613,12 +AEAAQA static void dev+AF8-set+AF8-t10+AF8-wwn+AF8-model+AF8-alias(struct se+AF8-device +ACo-dev)
+AD4  	const char +ACo-configname+ADs
+AD4  
+AD4  	configname +AD0 config+AF8-item+AF8-name(+ACY-dev-+AD4-dev+AF8-group.cg+AF8-item)+ADs
+AD4 -	if (strlen(configname) +AD4APQ 16) +AHs
+AD4 +-	if (strlen(configname) +AD4APQ INQUIRY+AF8-MODEL+AF8-LEN) +AHs
+AD4  		pr+AF8-warn(+ACI-dev+AFsAJQ-p+AF0: Backstore name '+ACU-s' is too long for +ACI
+AD4  			+ACI-INQUIRY+AF8-MODEL, truncating to 16 bytes+AFw-n+ACI, dev,
+AD4  			configname)+ADs
+AD4  	+AH0
+AD4 -	snprintf(+ACY-dev-+AD4-t10+AF8-wwn.model+AFs-0+AF0, 16, +ACIAJQ-s+ACI, configname)+ADs
+AD4 +-	snprintf(+ACY-dev-+AD4-t10+AF8-wwn.model+AFs-0+AF0, INQUIRY+AF8-MODEL+AF8-LEN, +ACIAJQ-s+ACI, configname)+ADs

Both the old and the new statement truncate inquiry strings that are 16 bytes
long, which is a bug. Additionally, have you considered to use strlcpy()
instead of snprintf()?

+AD4  		strncpy(+ACY-dev-+AD4-t10+AF8-wwn.model+AFs-0+AF0,
+AD4 -			dev-+AD4-transport-+AD4-inquiry+AF8-prod, 16)+ADs
+AD4 +-			dev-+AD4-transport-+AD4-inquiry+AF8-prod, INQUIRY+AF8-MODEL+AF8-LEN)+ADs
+AD4 +-		dev-+AD4-t10+AF8-wwn.model+AFs-INQUIRY+AF8-MODEL+AF8-LEN+AF0 +AD0 '+AFw-0'+ADs

Have you considered to use strlcpy() instead of strncpy() followed by explicit
'+AFw-0'-termination?

+AD4  		strncpy(+ACY-dev-+AD4-t10+AF8-wwn.model+AFs-0+AF0,
+AD4 -			dev-+AD4-transport-+AD4-inquiry+AF8-prod, 16)+ADs
+AD4 +-			dev-+AD4-transport-+AD4-inquiry+AF8-prod, INQUIRY+AF8-MODEL+AF8-LEN)+ADs
+AD4 +-		dev-+AD4-t10+AF8-wwn.model+AFs-INQUIRY+AF8-MODEL+AF8-LEN+AF0 +AD0 '+AFw-0'+ADs

Same question here: have you considered to use strlcpy() instead of strncpy()
followed by explicit '+AFw-0'-termination?

+AD4 -	memcpy(+ACY-wwn-+AD4-model+AFs-0+AF0, +ACY-buf+AFs-16+AF0, sizeof(wwn-+AD4-model))+ADs
+AD4 +-	BUILD+AF8-BUG+AF8-ON(sizeof(wwn-+AD4-model) +ACEAPQ INQUIRY+AF8-MODEL+AF8-LEN +- 1)+ADs
+AD4 +-	memcpy(+ACY-wwn-+AD4-model+AFs-0+AF0, +ACY-buf+AFs-16+AF0, INQUIRY+AF8-MODEL+AF8-LEN)+ADs
+AD4 +-	wwn-+AD4-model+AFs-INQUIRY+AF8-MODEL+AF8-LEN+AF0 +AD0 '+AFw-0'+ADs

Can the memcpy() and '+AFw-0'-termination be changed into an snprintf(..., +ACIAJQ.+ACo-s+ACI, ...)
call?

Thanks,

Bart.
