From: Christoph Hellwig <hch@lst.de>
Date: Fri, 05 Oct 2018 07:43:29 +0000
Subject: Re: [PATCH 03/17] target/core: Remove an unused data member from struct xcopy_pt_cmd
Message-Id: <20181005074329.GC24541@lst.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Mon, Sep 17, 2018 at 02:35:40PM -0700, Bart Van Assche wrote:
> A value is assigned to the xcopy_op member of struct xcopy_pt_cmd
> but that value is never used. Hence remove the xcopy_op member.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
