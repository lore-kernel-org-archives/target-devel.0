From: Bart Van Assche <bvanassche@acm.org>
Date: Thu, 29 Nov 2018 16:28:37 +0000
Subject: Re: [PATCH v4 4/7] target: consistently null-terminate t10_wwn.revision
Message-Id: <1543508917.185366.124.camel@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20181129010157.12687-5-ddiss@suse.de>
In-Reply-To: <20181129010157.12687-5-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Thu, 2018-11-29 at 02:01 +-0100, David Disseldorp wrote:
+AD4  		strncpy(+ACY-dev-+AD4-t10+AF8-wwn.revision+AFs-0+AF0,
+AD4 -			dev-+AD4-transport-+AD4-inquiry+AF8-rev, 4)+ADs
+AD4 +-			dev-+AD4-transport-+AD4-inquiry+AF8-rev, INQUIRY+AF8-REVISION+AF8-LEN)+ADs
+AD4 +-		dev-+AD4-t10+AF8-wwn.revision+AFs-INQUIRY+AF8-REVISION+AF8-LEN+AF0 +AD0 '+AFw-0'+ADs

Can the above two statements be changed into a single strlcpy() call?

+AD4 -	memcpy(+ACY-wwn-+AD4-revision+AFs-0+AF0, +ACY-buf+AFs-32+AF0, sizeof(wwn-+AD4-revision))+ADs
+AD4 +-	memcpy(+ACY-wwn-+AD4-revision+AFs-0+AF0, +ACY-buf+AFs-32+AF0, INQUIRY+AF8-REVISION+AF8-LEN)+ADs
+AD4 +-	wwn-+AD4-revision+AFs-INQUIRY+AF8-REVISION+AF8-LEN+AF0 +AD0 '+AFw-0'+ADs

Have you considered to use snprintf(..., +ACIAJQ.+ACo-s+ACI, ...) instead?

Thanks,

Bart.
