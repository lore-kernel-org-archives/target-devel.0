From: Bart Van Assche <bvanassche@acm.org>
Date: Thu, 08 Nov 2018 23:17:45 +0000
Subject: Re: [PATCH 02/10] target/core: Use kvcalloc() instead of open-coding it
Message-Id: <1541719065.196084.230.camel@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20181106171718.89594-3-bvanassche@acm.org>
In-Reply-To: <20181106171718.89594-3-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Thu, 2018-11-08 at 13:54 +-0100, David Disseldorp wrote:
+AD4 Looks reasonable. Any reason for dropping the extra +AF8AXw-GFP flags?

Hi David,

What makes you think that I dropped any of the +AF8AXw-GFP flags? The only purpose
of the +AF8AXw-GFP+AF8-NOWARN and +AF8AXw-GFP+AF8-RETRY+AF8-MAYFAIL flags is to make kcalloc() fail
quickly and silently. I'm not dropping these flags: as one can see in the
kvmalloc+AF8-node() implementation that function passes these flags to
kmalloc+AF8-node(). The source code I'm referring to is available in mm/util.c.

Bart.
