From: Kees Cook <keescook@chromium.org>
Date: Thu, 26 Oct 2017 14:50:55 +0000
Subject: Re: [PATCH] iscsi-target: Convert timers to use timer_setup()
Message-Id: <CAGXu5jLSV4ddCr+-9SfNXG2jj5QbJjJwnLEAarz40qH8FDm6pw@mail.gmail.com>
List-Id: <target-devel.vger.kernel.org>
References: <20171025100145.GA144703@beast> <CAHmME9pJRRhWg3=eorVkkSXhpsPgeCfRJFJp2i1-kdXr_E0PCA@mail.gmail.com>
 <CAGXu5jKNDM8NjgtgBp-XapHEiaY_ryk3pBXdaryux6spX++zmQ@mail.gmail.com>
 <1508943795.4165.18.camel@wdc.com> <CAGXu5j+xk+tHh5z9Hvtg6kGSuZQcK=QYHpcZf_akMnKjP69CKA@mail.gmail.com>
 <1509026649.13829.0.camel@wdc.com>
In-Reply-To: <1509026649.13829.0.camel@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jiangyilism@gmail.com" <jiangyilism@gmail.com>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "Jason@zx2c4.com" <Jason@zx2c4.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "varun@chelsio.com" <varun@chelsio.com>

On Thu, Oct 26, 2017 at 4:04 PM, Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> On Thu, 2017-10-26 at 10:24 +0200, Kees Cook wrote:
>> On Wed, Oct 25, 2017 at 5:03 PM, Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
>> > On Wed, 2017-10-25 at 16:10 +0200, Kees Cook wrote:
>> > > However, maintainers: sorry to send this one -- it can't be merged
>> > > yet, this uses timer_setup_on_stack() which is only in -next right
>> > > now. If it looks okay, though, I can carry this in the timer tree.
>> >
>> > Hello Kees,
>> >
>> > Can you have a look at the following patch and queue it before your
>> > patch if you think this would be useful (this patch has been tested):
>> > "target/iscsi: Simplify timer manipulation code"
>> > (https://www.spinics.net/lists/target-devel/msg15385.html).
>>
>> This looks good, yeah. Can you resend it with me CCed? It doesn't look
>> like it was CCed to lkml, so it's not easy to for me to add it to me
>> tree.
>
> OK, I will resend that patch as a reply to this e-mail. BTW, I just finished
> retesting that patch on top of v4.14-rc6.

Thanks for the testing!

-Kees

-- 
Kees Cook
Pixel Security
