From: Kees Cook <keescook@chromium.org>
Date: Tue, 31 Oct 2017 18:12:29 +0000
Subject: Re: [PATCH v2] target/iscsi: Convert timers to use timer_setup()
Message-Id: <CAGXu5jJNabMzjCSwFjaaF6VcBBD57gG9FgXTBgAHCmbKcb_AHw@mail.gmail.com>
List-Id: <target-devel.vger.kernel.org>
References: <20171027091930.GA14728@beast> <1509109031.3135.1.camel@wdc.com>
 <CAGXu5j+z9t28n33e6r9hxRNX1hpkzF4Z5sy308sWYh84whkRfQ@mail.gmail.com>
 <1509470185.12927.1.camel@wdc.com> <yq11slj9qtq.fsf@oracle.com>
 <1509471239.12927.3.camel@wdc.com> <yq1k1zb8b9n.fsf@oracle.com>
In-Reply-To: <yq1k1zb8b9n.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "varun@chelsio.com" <varun@chelsio.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "jiangyilism@gmail.com" <jiangyilism@gmail.com>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>

On Tue, Oct 31, 2017 at 10:42 AM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
> Bart,
>
>> The tree I tested indeed includes that rebased patch. BTW, since the code
>> touched by that patch has not been modified in the past months, the rebased
>> patch is identical to the patch I posted in May 2017.
>
> OK. Just checking.
>
> So what's the plan here? Should both patches be routed through the timer
> tree?

That was my plan. Does that sound okay?

-Kees

-- 
Kees Cook
Pixel Security
