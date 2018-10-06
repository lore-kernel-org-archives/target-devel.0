From: Christoph Hellwig <hch@lst.de>
Date: Sat, 06 Oct 2018 12:13:08 +0000
Subject: Re: [PATCH 09/17] target/core: Always call transport_complete_callback() upon failure
Message-Id: <20181006121308.GD7723@lst.de>
List-Id: <target-devel.vger.kernel.org>
References: <20180917213554.987-10-bvanassche@acm.org>
In-Reply-To: <20180917213554.987-10-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Mon, Sep 17, 2018 at 02:35:46PM -0700, Bart Van Assche wrote:
> Call transport_complete_callback() not only if COMPARE AND WRITE fails but
> also if XDWRITEREAD fails. This makes the code more systematic.

This looks ok:

Reviewed-by: Christoph Hellwig <hch@lst.de>

But I wonder if transport_complete_callback should really be split into
multiple more specific callbacks instead.
