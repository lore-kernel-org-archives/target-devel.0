From: Christoph Hellwig <hch@lst.de>
Date: Fri, 05 Oct 2018 07:46:13 +0000
Subject: Re: [PATCH 06/17] target/core: Use sg_alloc_table() instead of open-coding it
Message-Id: <20181005074613.GE24541@lst.de>
List-Id: <target-devel.vger.kernel.org>
References: <20180917213554.987-7-bvanassche@acm.org>
In-Reply-To: <20180917213554.987-7-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Mon, Sep 17, 2018 at 02:35:43PM -0700, Bart Van Assche wrote:
> The purpose of sg_alloc_table() is to allocate and initialize an
> sg-list. Use that function instead of open-coding it.

Hmm.  This looks correct, but what is the point if we don't plan
on using chained sg-lists?
