From: Christoph Hellwig <hch@infradead.org>
Date: Tue, 24 Mar 2020 09:16:52 +0000
Subject: Re: [RFC PATCH 4/5] scsi: target: increase XCOPY I/O size
Message-Id: <20200324091652.GD18399@infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <20200323165410.24423-1-ddiss@suse.de>
 <20200323165410.24423-5-ddiss@suse.de>
In-Reply-To: <20200323165410.24423-5-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Disseldorp <ddiss@suse.de>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, bvanassche@acm.org

On Mon, Mar 23, 2020 at 05:54:09PM +0100, David Disseldorp wrote:
> The I/O size is already bound by dev_attrib.hw_max_sectors, so increase
> the hardcoded XCOPY_MAX_SECTORS maximum to improve performance against
> backstores with high-latency.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
