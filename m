From: Bart Van Assche <bvanassche@acm.org>
Date: Thu, 29 Nov 2018 16:37:13 +0000
Subject: Re: [PATCH v4 7/7] target: use printf width specifier for t10_wwn field dumps
Message-Id: <1543509433.185366.131.camel@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20181129010157.12687-8-ddiss@suse.de>
In-Reply-To: <20181129010157.12687-8-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Thu, 2018-11-29 at 02:01 +-0100, David Disseldorp wrote:
+AD4 The existing for loops step over null-terminators for right-padding.
+AD4 Padding can be achieved in a much simpler way using printf width
+AD4 specifiers.

How about squashing patches 2, 3, 4 and 7 into a single patch? I think
that would make the entire patch series easier to review.

Thanks,

Bart.
