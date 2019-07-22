From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Mon, 22 Jul 2019 11:47:00 +0000
Subject: Re: Bug report: KFIFO kfifo_init() may introduce buffer overflow
Message-Id: <20190722114700.GE3089@kadam>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Mon, Jul 22, 2019 at 12:23:56PM +0800, laokz wrote:
> Hello,
> 
> A couple of weeks ago, I reported the respect author/maintainers. Haven't
> got reply yet, so I come here. 
> 
> The following is based on kernel 5.2-rc6.
> 
> include/linux/kfifo.h::kfifo_init() initialize a fifo using a preallocated
> buffer. It requests the buffer size should be power_of_two, if not so, the
> actual worker __kfifo_init() will round UP it to the next power of two. For
> it just records the new size in fifo's internal parameters, does not touch
> the real buffer, obviously this may introduce buffer overflow. 
> 
> In the source tree, I found an instance.
> 
> In drivers/scsi/ibmvscsi_tgt/libsrp.c::srp_iu_pool_alloc(), it calls
> kcalloc() and kfifo_init() with buffer size=max*sizeof(void
> *)=INITIAL_SRP_LIMIT*sizeof(void *), most likely be
> 800*8d00. That is NOT power of 2, KFIFO will treat it as 8192 big! Bad.
> 
> Here is its only call-chain:
>   #define INITIAL_SRP_LIMIT 800                       /* ibmvscsi_tgt.c */
>   ibmvscsis_probe()::vscsi->request_limit=INITIAL_SRP_LIMIT
>     -> srp_target_alloc(,vscsi->request_limit,)       /* libsrp.c */
>       ->srp_iu_pool_alloc(,nr,)                /* nr=vscsi->request_limit */
>         ->kfifo_init(,max*sizeof(void *),)     /* max=nr */
> 
> I know before kernel 3.9 __kfifo_init() algorithm was rounddown. I don't
> know why changed to roundup, but it is safe and more robust to rounddown
> instead of roundup.
> 
> If i'm wrong, please let me know also. Thanks.

It looks like you're right.  Probably the fix is to:
1) Change INITIAL_SRP_LIMIT to 8192
2) Change kfifo_init() to round down like you say
3) Add a WARN_ONCE() in kfifo_alloc and kfifo_init() if the size isn't
   a power of two.

regards,
dan carpenter
