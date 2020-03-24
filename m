From: Christoph Hellwig <hch@infradead.org>
Date: Tue, 24 Mar 2020 09:07:17 +0000
Subject: Re: [RFC PATCH 2/5] scsi: target: drop xcopy DISK BLOCK LENGTH debug
Message-Id: <20200324090717.GB18399@infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <20200323165410.24423-1-ddiss@suse.de>
 <20200323165410.24423-3-ddiss@suse.de>
In-Reply-To: <20200323165410.24423-3-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Disseldorp <ddiss@suse.de>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, bvanassche@acm.org

On Mon, Mar 23, 2020 at 05:54:07PM +0100, David Disseldorp wrote:
> The DISK BLOCK LENGTH field is carried with XCOPY target descriptors on
> the wire, but is currently unmarshalled during 0x02 segment descriptor
> passing. The unmarshalled value is currently unused, so drop it.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
