From: Christoph Hellwig <hch@lst.de>
Date: Fri, 05 Oct 2018 07:44:27 +0000
Subject: Re: [PATCH 04/17] target/core: Change the return type of transport_init_session from void to int
Message-Id: <20181005074427.GD24541@lst.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Mon, Sep 17, 2018 at 02:35:41PM -0700, Bart Van Assche wrote:
> This patch does not change any functionality but makes the next patch in
> this series easier to read.

I'd rather see it go with the actual change - while the patch might be
a little harder to read at least it makes sense that way.
