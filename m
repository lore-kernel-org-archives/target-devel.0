From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Tue, 19 Jun 2018 02:26:13 +0000
Subject: Re: [PATCH 0/3] Use sbitmap instead of percpu_ida
Message-Id: <yq1bmc7ikai.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180612190545.10781-1-willy@infradead.org>
	<yq136xols59.fsf@oracle.com>
	<20180615023731.GA5706@bombadil.infradead.org>
In-Reply-To: <20180615023731.GA5706@bombadil.infradead.org> (Matthew Wilcox's
	message of "Thu, 14 Jun 2018 19:37:31 -0700")
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: Juergen Gross <jgross@suse.com>, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, netdev@vger.kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, target-devel@vger.kernel.org, kvm@vger.kernel.org, qla2xxx-upstream@qlogic.com, linux1394-devel@lists.sourceforge.net, Kent Overstreet <kent.overstreet@gmail.com>


Matthew,

>> Since most of the changes are in scsi or target, should I take this
>> series through my tree?
>
> I'd welcome that.  Nick seems to be inactive as target maintainer;
> his tree on kernel.org hasn't seen any updates in five months.

Applied to 4.19/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
