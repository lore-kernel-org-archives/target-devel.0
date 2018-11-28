From: Bart Van Assche <bvanassche@acm.org>
Date: Wed, 28 Nov 2018 16:08:30 +0000
Subject: Re: [PATCH v3 3/4] target: add device vendor_id configfs attribute
Message-Id: <1543421310.185366.96.camel@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20181119210636.22979-4-ddiss@suse.de>
In-Reply-To: <20181119210636.22979-4-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Wed, 2018-11-28 at 16:37 +-0100, David Disseldorp wrote:
+AD4 On Tue, 20 Nov 2018 19:00:57 +-0100, David Disseldorp wrote:
+AD4 
+AD4 +AD4 +AD4 +AD4 +-	strncpy(buf, page, sizeof(buf))+ADs    
+AD4 +AD4 +AD4 
+AD4 +AD4 +AD4 Isn't strncpy() deprecated? How about using strlcpy() instead?  
+AD4 +AD4 
+AD4 +AD4 Will change to use strlcpy in the next round.
+AD4 
+AD4 Just a follow up here. I think it's safer to retain strncpy() in this
+AD4 function for the purpose of zero filling. scsi+AF8-dump+AF8-inquiry() and
+AD4 target+AF8-stat+AF8-lu+AF8-vend+AF8-show() walk the entire length of the t10+AF8-wwn.vendor
+AD4 buffer.

How about adding a comment about above struct t10+AF8-wwn that vendor+AFsAXQ, model+AFsAXQ
and revision+AFsAXQ in that structure may but do not have to be terminated with a
trailing '+AFw-0' and also that unit+AF8-serial+AFsAXQ is '+AFw-0'-terminated?

It would make me happy if the size of the character arrays in that structure
would be increased by one and if the target code would be modified such that
these strings are always '+AFw-0'-terminated.

Thanks,

Bart.
