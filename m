From: David Disseldorp <ddiss@suse.de>
Date: Mon, 11 Mar 2019 16:48:05 +0000
Subject: Re: [PATCH] target:tcmu:add '\n' when return user space
Message-Id: <20190311174805.1c428705@linux-6o2u>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Mon, 11 Mar 2019 11:15:53 -0500, Mike Christie wrote:

> >> Although minor, this is still a modification to a released API so
> >> probably can't be done without potentially breaking user-space.
> >>  
> > 
> > I think the lack of newline is breaking some tools, because they were
> > looking for newlines due to the other files having it.
> >   
> 
> I guess that does not make sense. It will be easier to update userspace
> and we would have to carry the userspcae patch for older kernels, so the
> patch is not needed.

Agreed. After getting burnt by 6baca7601bde I'm hesitant to make any
changes to existing configFS attributes.

Cheers, David
