From: Greg KH <greg@kroah.com>
Date: Fri, 02 Aug 2019 07:30:57 +0000
Subject: Re: Bug report: KFIFO kfifo_init() may introduce buffer overflow
Message-Id: <20190802073057.GD26174@kroah.com>
List-Id: <target-devel.vger.kernel.org>
References: <20190722114700.GE3089@kadam>
In-Reply-To: <20190722114700.GE3089@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: target-devel@vger.kernel.org

On Mon, Jul 22, 2019 at 09:26:23PM +0800, laokz wrote:
> Hello Dan,
> 
> On Mon, Jul 22, 2019 at 14:50 +0300，Dan Carpenter wrote:
> > > It looks like you're right.  Probably the fix is to:
> > > 1) Change INITIAL_SRP_LIMIT to 8192
> > 
> > I meant 1024 not 8192.
> 
> Nice to see that. It really helped for me. Thank you very much.

Did anything ever happen with this?  Was a patch submitted to resolve
this issue?

thanks,

greg k-h
