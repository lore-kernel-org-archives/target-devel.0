From: Jens Axboe <axboe@kernel.dk>
Date: Tue, 12 Jun 2018 20:40:43 +0000
Subject: Re: [PATCH 0/3] Use sbitmap instead of percpu_ida
Message-Id: <f7a9f7ad-843f-58fc-68f0-79dfd4019c18@kernel.dk>
List-Id: <target-devel.vger.kernel.org>
References: <20180612190545.10781-1-willy@infradead.org>
In-Reply-To: <20180612190545.10781-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux1394-devel@lists.sourceforge.net, linux-usb@vger.kernel.org, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, Juergen Gross <jgross@suse.com>, qla2xxx-upstream@qlogic.com, Kent Overstreet <kent.overstreet@gmail.com>

On 6/12/18 1:05 PM, Matthew Wilcox wrote:
> Removing the percpu_ida code nets over 400 lines of removal.  It's not
> as spectacular as deleting an entire architecture, but it's still a
> worthy reduction in lines of code.
> 
> Untested due to lack of hardware and not understanding how to set up a
> target platform.
> 
> Changes from v1:
>  - Fixed bugs pointed out by Jens in iscsit_wait_for_tag()
>  - Abstracted out tag freeing as requested by Bart
>  - Made iscsit_wait_for_tag static as pointed out by 0day

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

