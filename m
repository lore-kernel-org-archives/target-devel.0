From: Christoph Hellwig <hch@infradead.org>
Date: Tue, 24 Mar 2020 09:23:23 +0000
Subject: Re: [RFC PATCH 5/5] scsi: target: avoid XCOPY per-loop read/write cmd allocations
Message-Id: <20200324092323.GE18399@infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <20200323165410.24423-1-ddiss@suse.de>
 <20200323165410.24423-6-ddiss@suse.de>
In-Reply-To: <20200323165410.24423-6-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Disseldorp <ddiss@suse.de>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, bvanassche@acm.org

On Mon, Mar 23, 2020 at 05:54:10PM +0100, David Disseldorp wrote:
> Reads and writes in the XCOPY loop are synchronous, so needn't be
> allocated / freed with each loop.

That is true, but I think with your previous cleanups we can easily
go one step further and just allocate a single command and sense buffer
directly in struct xcopy_op, and just have local completions on the
stack.
