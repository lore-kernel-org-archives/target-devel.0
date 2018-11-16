From: David Disseldorp <ddiss@suse.de>
Date: Fri, 16 Nov 2018 13:10:15 +0000
Subject: Re: [PATCH 02/10] target/core: Use kvcalloc() instead of open-coding it
Message-Id: <20181116141015.54888a45@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20181106171718.89594-3-bvanassche@acm.org>
In-Reply-To: <20181106171718.89594-3-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hi Bart,

On Thu, 08 Nov 2018 15:17:45 -0800, Bart Van Assche wrote:

> What makes you think that I dropped any of the __GFP flags? The only purpose
> of the __GFP_NOWARN and __GFP_RETRY_MAYFAIL flags is to make kcalloc() fail
> quickly and silently.

Are you confusing __GFP_RETRY_MAYFAIL with __GFP_NORETRY here?

> I'm not dropping these flags: as one can see in the
> kvmalloc_node() implementation that function passes these flags to
> kmalloc_node(). The source code I'm referring to is available in mm/util.c.

I see that (given tag_num * tag_size > PAGE_SIZE) __GFP_NOWARN is added
by kvmalloc_node(), but __GFP_RETRY_MAYFAIL is dropped with your change,
which sees __GFP_NORETRY added in the >PAGE_SIZE path.

Cheers, David
