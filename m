From: Christoph Hellwig <hch@lst.de>
Date: Sat, 06 Oct 2018 12:07:07 +0000
Subject: Re: [PATCH 08/17] target/core: Make compare_and_write_callback() accept NULL as third argument
Message-Id: <20181006120707.GC7723@lst.de>
List-Id: <target-devel.vger.kernel.org>
References: <20180917213554.987-9-bvanassche@acm.org>
In-Reply-To: <20180917213554.987-9-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Mon, Sep 17, 2018 at 02:35:45PM -0700, Bart Van Assche wrote:
> This patch does not change any functionality. A later patch in this series,
> namely "Make ABORT and LUN RESET handling synchronous", depends on this
> patch.

I'd be tempted to just merge it into that patch to make that fact more
obvious.
