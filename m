From: David Disseldorp <ddiss@suse.de>
Date: Mon, 26 Oct 2020 21:05:09 +0000
Subject: Re: [PATCH v2 1/5] lib/scatterlist: use consistent sg_copy_buffer() return type
Message-Id: <20201026220509.7f0a2abb@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20201026190646.8727-1-ddiss@suse.de>
        <20201026190646.8727-2-ddiss@suse.de>
        <08c0e425-d8c5-a950-f2a1-01bb6c9a5adf@interlog.com>
In-Reply-To: <08c0e425-d8c5-a950-f2a1-01bb6c9a5adf@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, 26 Oct 2020 16:50:53 -0400, Douglas Gilbert wrote:

> On 2020-10-26 3:06 p.m., David Disseldorp wrote:
> > sg_copy_buffer() returns a size_t with the number of bytes copied.
> > Return 0 instead of false if the copy is skipped.
> > 
> > Signed-off-by: David Disseldorp <ddiss@suse.de>
> > ---
> >   lib/scatterlist.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/lib/scatterlist.c b/lib/scatterlist.c
> > index 0a482ef988e5..a59778946404 100644
> > --- a/lib/scatterlist.c
> > +++ b/lib/scatterlist.c
> > @@ -933,7 +933,7 @@ size_t sg_copy_buffer(struct scatterlist *sgl, unsigned int nents, void *buf,
> >   	sg_miter_start(&miter, sgl, nents, sg_flags);
> >   
> >   	if (!sg_miter_skip(&miter, skip))
> > -		return false;
> > +		return 0;
> >   
> >   	while ((offset < buflen) && sg_miter_next(&miter)) {
> >   		unsigned int len;
> >   
> 
> This one probably should be sent by itself as a fix to:
>     linux-block@vger.kernel.org
> 
> and cc-ed to:
>     axboe@kernel.dk
> 
> on the assumption that Jens Axboe is the maintainer of lib/scatterlist.c .
> He put a fix of mine in sgl_alloc_order() into the kernel recently.
> 
> Otherwise:
> Reviewed-by: Douglas Gilbert <dgilbert@interlog.com>

Sent. Thanks Douglas!
