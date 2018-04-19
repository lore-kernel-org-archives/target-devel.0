From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Thu, 19 Apr 2018 04:41:55 +0000
Subject: Re: [PATCH] target: fix crash with iscsi target and dvd
Message-Id: <yq18t9jlsdo.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180416094841.30212-1-ming.lei@redhat.com>
In-Reply-To: <20180416094841.30212-1-ming.lei@redhat.com> (Ming Lei's message
	of "Mon, 16 Apr 2018 17:48:41 +0800")
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Wakko Warner <wakko@animx.eu.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>


Ming,

> When the current page can't be added to bio, one new bio should be
> created for adding this page again, instead of ignoring this page.
>
> This patch fixes kernel crash with iscsi target and dvd, as reported
> by Wakko.

I queued this up in 4.17/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
