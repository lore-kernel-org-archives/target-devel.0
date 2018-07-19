From: Christoph Hellwig <hch@infradead.org>
Date: Thu, 19 Jul 2018 20:38:21 +0000
Subject: Re: [PATCH 03/15] target: fix __transport_register_session locking
Message-Id: <20180719203821.GA14654@infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <1531696591-8558-4-git-send-email-mchristi@redhat.com>
In-Reply-To: <1531696591-8558-4-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Sun, Jul 15, 2018 at 06:16:19PM -0500, Mike Christie wrote:
> When __transport_register_session is called from
> transport_register_session irqs will already have been disabled,
> so we do not want the unlock irq call to enable them until
> the higher level has done the final
> spin_unlock_irqrestore/spin_unlock_irq.

if you use up your line length this could be:

so we do not want the unlock irq call to enable them until the higher
level has done the final spin_unlock_irqrestore/spin_unlock_irq.


> 
> This has __transport_register_session use the save/restore
> call.

Can be condensed as well.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
