From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 20 Nov 2018 18:03:14 +0000
Subject: Re: [PATCH v3 3/4] target: add device vendor_id configfs attribute
Message-Id: <1542736994.185366.77.camel@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20181119210636.22979-4-ddiss@suse.de>
In-Reply-To: <20181119210636.22979-4-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Tue, 2018-11-20 at 19:00 +-0100, David Disseldorp wrote:
+AD4 I tend to agree that it's dangerous, but chose to stay somewhat
+AD4 consistent with the other t10+AF8-wwn strings that are treated as though
+AD4 they may not be NULL terminated.
+AD4 
+AD4 If you're in favour adding an extra terminator byte here, then I think
+AD4 it'd make sense to do the same for model+AFsAXQ, revision+AFsAXQ and unit+AF8-serial+AFsAXQ
+AD4 too. Are you okay with that approach?

Sure, I would welcome that change.

Thanks,

Bart.
