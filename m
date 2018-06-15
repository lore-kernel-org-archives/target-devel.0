From: Matthew Wilcox <willy@infradead.org>
Date: Fri, 15 Jun 2018 02:37:31 +0000
Subject: Re: [PATCH 0/3] Use sbitmap instead of percpu_ida
Message-Id: <20180615023731.GA5706@bombadil.infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <20180612190545.10781-1-willy@infradead.org>
	<yq136xols59.fsf@oracle.com>
In-Reply-To: <yq136xols59.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Juergen Gross <jgross@suse.com>, Jens Axboe <axboe@kernel.dk>, kvm@vger.kernel.org, linux-scsi@vger.kernel.org, netdev@vger.kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, target-devel@vger.kernel.org, qla2xxx-upstream@qlogic.com, linux1394-devel@lists.sourceforge.net, Kent Overstreet <kent.overstreet@gmail.com>

On Thu, Jun 14, 2018 at 10:06:58PM -0400, Martin K. Petersen wrote:
> 
> Matthew,
> 
> > Removing the percpu_ida code nets over 400 lines of removal.  It's not
> > as spectacular as deleting an entire architecture, but it's still a
> > worthy reduction in lines of code.
> 
> Since most of the changes are in scsi or target, should I take this
> series through my tree?

I'd welcome that.  Nick seems to be inactive as target maintainer;
his tree on kernel.org hasn't seen any updates in five months.

Thanks!
