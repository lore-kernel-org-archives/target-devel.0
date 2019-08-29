From: Kees Cook <keescook@chromium.org>
Date: Thu, 29 Aug 2019 17:21:33 +0000
Subject: Re: Bug report: KFIFO kfifo_init() may introduce buffer overflow
Message-Id: <201908291021.DF893CEE5B@keescook>
List-Id: <target-devel.vger.kernel.org>
References: <20190722114700.GE3089@kadam>
In-Reply-To: <20190722114700.GE3089@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: target-devel@vger.kernel.org

On Tue, Aug 06, 2019 at 06:27:13PM +0800, laokz wrote:
> On Fri, Aug 2, 2019 at 09:30 +0200，Greg KH wrote:
> > On Mon, Jul 22, 2019 at 09:26:23PM +0800, laokz wrote:
> > > Hello Dan,
> > > 
> > > On Mon, Jul 22, 2019 at 14:50 +0300，Dan Carpenter wrote:
> > > > > It looks like you're right.  Probably the fix is to:
> > > > > 1) Change INITIAL_SRP_LIMIT to 8192
> > > > 
> > > > I meant 1024 not 8192.
> > > 
> > > Nice to see that. It really helped for me. Thank you very much.
> > 
> > Did anything ever happen with this?  Was a patch submitted to resolve
> > this issue?
> Sorry for the late reply. I didn't submit any patch, for as newbie I wasn't
> quite sure about the severity of this issue. The developers may do their
> choice.

It's worth fixing regardless. :) Did a patch get sent for this?

-- 
Kees Cook
