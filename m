From: Christoph Hellwig <hch@lst.de>
Date: Fri, 05 Oct 2018 07:43:18 +0000
Subject: Re: [PATCH 02/17] target/core: Use the SECTOR_SHIFT constant
Message-Id: <20181005074318.GB24541@lst.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Mon, Sep 17, 2018 at 02:35:39PM -0700, Bart Van Assche wrote:
> Instead of duplicating the SECTOR_SHIFT definition from <linux/blkdev.h>,
> use it. This patch does not change any functionality.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
