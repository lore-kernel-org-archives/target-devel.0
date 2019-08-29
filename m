From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 29 Aug 2019 18:48:19 +0000
Subject: Re: Bug report: KFIFO kfifo_init() may introduce buffer overflow
Message-Id: <CAHk-=wgQeKWHW0bQ1aV5=2ivbD-WWDHcBBJ_cX5R75iiNNq2uA@mail.gmail.com>
List-Id: <target-devel.vger.kernel.org>
References: <20190722114700.GE3089@kadam>
In-Reply-To: <20190722114700.GE3089@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Tue, Aug 6, 2019 at 3:29 AM laokz <laokz@foxmail.com> wrote:
>
> Sorry for the late reply. I didn't submit any patch, for as newbie I wasn't
> quite sure about the severity of this issue. The developers may do their
> choice.

It does seem pretty bad.

Also, INIT_KFIFO() and DECLARE_KFIFO() should probably have a

     BUILD_BUG_ON(!__is_kfifo_ptr && !is_power_of_2(ARRAY_SIZE(__tmp->buf)));

or something. Probably worth indirection through a helper macro to set
the ".mask" field.

And yes, commit dfe2a77fd243 ("kfifo: fix kfifo_alloc() and
kfifo_init()") seems wrong, It's fine for the __kfifo_alloc() case
where we actually allocate the rounded-up size, but it's completely
wrong for the __kfifo_init() case where somebody _else_ allocated the
size.

So the kfifo_init() case needs to just use a round_down, and possibly
add a WARN_ON_ONCE() too.

Anybody?

             Linus
