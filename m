From: Bart Van Assche <bvanassche@acm.org>
Date: Wed, 28 Nov 2018 16:47:39 +0000
Subject: Re: [PATCH v3 3/4] target: add device vendor_id configfs attribute
Message-Id: <1543423659.185366.104.camel@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20181119210636.22979-4-ddiss@suse.de>
In-Reply-To: <20181119210636.22979-4-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Wed, 2018-11-28 at 17:44 +-0100, David Disseldorp wrote:
+AD4 Hi Bart,
+AD4 
+AD4 On Wed, 28 Nov 2018 08:36:19 -0800, Bart Van Assche wrote:
+AD4 
+AD4 +AD4 Maybe I'm missing something, but why is zeroing of unused bytes in these functions
+AD4 +AD4 necessary? Would the following be correct if all strings in struct t10+AF8-wwn would be
+AD4 +AD4 '+AFw-0'-terminated?
+AD4 
+AD4 Your patch looks good to me. Mind if I tack it on to the end of my
+AD4 t10+AF8-wwn.vendor/model/revision+AFs-size+-1+AF0 patchset, with your authorship?

Sure, that sounds fine to me.

Bart.
