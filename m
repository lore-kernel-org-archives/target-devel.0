From: Christoph Hellwig <hch@infradead.org>
Date: Fri, 27 Mar 2020 09:24:41 +0000
Subject: Re: [PATCH v2 3/5] scsi: target: avoid per-loop XCOPY buffer allocations
Message-Id: <20200327092441.GA7952@infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <20200326221505.5303-1-ddiss@suse.de>
 <20200326221505.5303-4-ddiss@suse.de>
In-Reply-To: <20200326221505.5303-4-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Disseldorp <ddiss@suse.de>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, bvanassche@acm.org

On Thu, Mar 26, 2020 at 11:15:03PM +0100, David Disseldorp wrote:
> The main target_xcopy_do_work() loop unnecessarily allocates an I/O
> buffer with each synchronous READ / WRITE pair. This commit
> significantly reduces allocations by reusing the XCOPY I/O buffer when
> possible.
> 
> Signed-off-by: David Disseldorp <ddiss@suse.de>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
