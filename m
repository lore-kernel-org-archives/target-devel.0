From: Kees Cook <keescook@chromium.org>
Date: Thu, 29 Aug 2019 19:42:17 +0000
Subject: Re: Bug report: KFIFO kfifo_init() may introduce buffer overflow
Message-Id: <201908291240.A6A9AA5431@keescook>
List-Id: <target-devel.vger.kernel.org>
References: <20190722114700.GE3089@kadam>
In-Reply-To: <20190722114700.GE3089@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Thu, Aug 29, 2019 at 12:32:41PM -0700, Linus Torvalds wrote:
> On Thu, Aug 29, 2019 at 11:48 AM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Anybody?
> 
> This is ENTIRELY UNTESTED.
> 
> Anybody willing to test and take ownership?

I don't know this code at all, but note below...

> 
>               Linus

>  include/linux/kfifo.h | 12 ++++++++----
>  lib/kfifo.c           |  4 +++-
>  2 files changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/kfifo.h b/include/linux/kfifo.h
> index fc4b0b10210f..078f52c20aad 100644
> --- a/include/linux/kfifo.h
> +++ b/include/linux/kfifo.h
> @@ -117,6 +117,12 @@ struct kfifo_rec_ptr_2 __STRUCT_KFIFO_PTR(unsigned char, 2, void);
>   */
>  #define DECLARE_KFIFO(fifo, type, size)	STRUCT_KFIFO(type, size) fifo
>  
> +#define VERIFY_POWER_OF2(x) \
> +	((x)+BUILD_BUG_ON_ZERO((x) & ((x)-1)))
> +
> +#define __KFIFO_MASK_SIZE(fifo) \
> +	(__is_kfifo_ptr(&(fifo)) ? 0 : VERIFY_POWER_OF2(ARRAY_SIZE((fifo).buf)) - 1)
> +
>  /**
>   * INIT_KFIFO - Initialize a fifo declared by DECLARE_KFIFO
>   * @fifo: name of the declared fifo datatype
> @@ -127,7 +133,7 @@ struct kfifo_rec_ptr_2 __STRUCT_KFIFO_PTR(unsigned char, 2, void);
>  	struct __kfifo *__kfifo = &__tmp->kfifo; \
>  	__kfifo->in = 0; \
>  	__kfifo->out = 0; \
> -	__kfifo->mask = __is_kfifo_ptr(__tmp) ? 0 : ARRAY_SIZE(__tmp->buf) - 1;\
> +	__kfifo->mask = __KFIFO_MASK_SIZE(fifo); \

I think this should be:

+	__kfifo->mask = __KFIFO_MASK_SIZE(*__tmp); \

? I didn't compile it, but I saw the others were using (fifo).buf but
this was using __tmp->buf.

>  	__kfifo->esize = sizeof(*__tmp->buf); \
>  	__kfifo->data = __is_kfifo_ptr(__tmp) ?  NULL : __tmp->buf; \
>  })
> @@ -147,9 +153,7 @@ struct kfifo_rec_ptr_2 __STRUCT_KFIFO_PTR(unsigned char, 2, void);
>  			{ \
>  			.in	= 0, \
>  			.out	= 0, \
> -			.mask	= __is_kfifo_ptr(&(fifo)) ? \
> -				  0 : \
> -				  ARRAY_SIZE((fifo).buf) - 1, \
> +			.mask	= __KFIFO_MASK_SIZE(fifo), \
>  			.esize	= sizeof(*(fifo).buf), \
>  			.data	= __is_kfifo_ptr(&(fifo)) ? \
>  				NULL : \
> diff --git a/lib/kfifo.c b/lib/kfifo.c
> index 117ad0e7fbf4..7f145cb41e6d 100644
> --- a/lib/kfifo.c
> +++ b/lib/kfifo.c
> @@ -68,7 +68,9 @@ int __kfifo_init(struct __kfifo *fifo, void *buffer,
>  {
>  	size /= esize;
>  
> -	size = roundup_pow_of_two(size);
> +	/* Warn because we had a bug here and would round up */
> +	if (WARN_ON_ONCE(!is_power_of_2(size)))
> +		size = rounddown_pow_of_two(size);
>  
>  	fifo->in = 0;
>  	fifo->out = 0;


-- 
Kees Cook
