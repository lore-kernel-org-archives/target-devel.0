From: James Bottomley <jejb@linux.ibm.com>
Date: Mon, 17 Aug 2020 19:57:32 +0000
Subject: Re: [PATCH 0/8] scsi: convert tasklets to use new tasklet_setup()
Message-Id: <1597694252.22390.12.camel@linux.ibm.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200817085409.25268-1-allen.cryptic@gmail.com>
         <1597675318.4475.11.camel@linux.ibm.com> <202008171227.D3A4F454D8@keescook>
In-Reply-To: <202008171227.D3A4F454D8@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kees Cook <keescook@chromium.org>
Cc: Allen Pais <allen.cryptic@gmail.com>, martin.petersen@oracle.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com, linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, target-devel@vger.kernel.org, megaraidlinux.pdl@broadcom.com, Allen Pais <allen.lkml@gmail.com>

On Mon, 2020-08-17 at 12:28 -0700, Kees Cook wrote:
> On Mon, Aug 17, 2020 at 07:41:58AM -0700, James Bottomley wrote:
> > On Mon, 2020-08-17 at 14:24 +0530, Allen Pais wrote:
> > > From: Allen Pais <allen.lkml@gmail.com>
> > > 
> > > Commit 12cc923f1ccc ("tasklet: Introduce new initialization
> > > API")' introduced a new tasklet initialization API. This series
> > > converts all the scsi drivers to use the new tasklet_setup() API
> > 
> > I've got to say I agree with Jens, this was a silly obfuscation:
> > 
> > +#define from_tasklet(var, callback_tasklet, tasklet_fieldname) \
> > +       container_of(callback_tasklet, typeof(*var),
> > tasklet_fieldname)
> > 
> > Just use container_of directly since we all understand what it
> > does.
> 
> But then the lines get really long, wrapped, etc.

I really don't think that's a problem but if you want to add a new
generic container_of that does typeof instead of insisting on the type,
I'd be sort of OK with that ... provided you don't gratuitously alter
the argument order.

The thing I object to is that this encourages everyone to roll their
own unnecessary container_of type macros in spite of the fact that it's
function is wholly generic.  It's fine if you're eliminating one of the
arguments, or actually making the macro specific to the type, but in
this case you're not, you're making a completely generic macro where
the name is the only thing that's specific to this case.

>  This is what the timer_struct conversion did too (added a
> container_of wrapper), so I think it makes sense here too.

I didn't see that one to object to it ...

James
