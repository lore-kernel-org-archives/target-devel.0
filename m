From: David Disseldorp <ddiss@suse.de>
Date: Thu, 26 Mar 2020 21:20:44 +0000
Subject: Re: [RFC PATCH 5/5] scsi: target: avoid XCOPY per-loop read/write cmd allocations
Message-Id: <20200326222044.06e3d5c9@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20200323165410.24423-1-ddiss@suse.de>
        <20200323165410.24423-6-ddiss@suse.de>
        <20200324092323.GE18399@infradead.org>
In-Reply-To: <20200324092323.GE18399@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@infradead.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, bvanassche@acm.org

Hi Christoph,

Thanks for the feedback...

On Tue, 24 Mar 2020 02:23:23 -0700, Christoph Hellwig wrote:

> On Mon, Mar 23, 2020 at 05:54:10PM +0100, David Disseldorp wrote:
> > Reads and writes in the XCOPY loop are synchronous, so needn't be
> > allocated / freed with each loop.  
> 
> That is true, but I think with your previous cleanups we can easily
> go one step further and just allocate a single command and sense buffer
> directly in struct xcopy_op, and just have local completions on the
> stack.

I'm probably missing something, but having the (stack) completion
separate to the se_cmd and sense buffer would mean that it's no longer a
straightforward container_of() in the .check_stop_free() callback.

I've reworked this patch to put the entire xcopy_pt_cmd on the stack and
will send it out with v2.

Cheers, David
