From: David Disseldorp <ddiss@suse.de>
Date: Fri, 16 Nov 2018 17:02:43 +0000
Subject: Re: [PATCH 02/10] target/core: Use kvcalloc() instead of open-coding it
Message-Id: <20181116180243.7ad1562e@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20181106171718.89594-3-bvanassche@acm.org>
In-Reply-To: <20181106171718.89594-3-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Fri, 16 Nov 2018 07:58:41 -0800, Bart Van Assche wrote:

> On Fri, 2018-11-16 at 14:10 +0100, David Disseldorp wrote:
> > On Thu, 08 Nov 2018 15:17:45 -0800, Bart Van Assche wrote:  
> > > What makes you think that I dropped any of the __GFP flags? The only purpose
> > > of the __GFP_NOWARN and __GFP_RETRY_MAYFAIL flags is to make kcalloc() fail
> > > quickly and silently.  
> > 
> > Are you confusing __GFP_RETRY_MAYFAIL with __GFP_NORETRY here?  
> 
> No. Passing __GFP_RETRY_MAYFAIL to a memory allocation function makes the memory
> allocator try less hard than without that flag.

In the context of this patch we're going from __GFP_RETRY_MAYFAIL to
__GFP_NORETRY (due to the  kvmalloc_node() >PAGE_SIZE logic), so "fail
quickly" makes more sense to me when referring to the latter.

> > > I'm not dropping these flags: as one can see in the
> > > kvmalloc_node() implementation that function passes these flags to
> > > kmalloc_node(). The source code I'm referring to is available in mm/util.c.  
> > 
> > I see that (given tag_num * tag_size > PAGE_SIZE) __GFP_NOWARN is added
> > by kvmalloc_node(), but __GFP_RETRY_MAYFAIL is dropped with your change,
> > which sees __GFP_NORETRY added in the >PAGE_SIZE path.  
> 
> That's right. If you want I can mention this in the patch description.

I don't think that's needed, I was just interested in the motivation for
the change in __GFP flags.

Cheers, David
