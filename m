From: Varun Prakash <varun@chelsio.com>
Date: Thu, 26 Jul 2018 11:24:04 +0000
Subject: Re: [PATCH 13/20] target/iscsi: Reduce number of __iscsit_free_cmd() callers
Message-Id: <20180726111000.GA2015@chelsio.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180622215307.8758-14-bart.vanassche@wdc.com>
In-Reply-To: <20180622215307.8758-14-bart.vanassche@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Sat, Jun 23, 2018 at 03:23:00AM +0530, Bart Van Assche wrote:
> Instead of calling __iscsit_free_cmd() from inside iscsit_aborted_task()
> if a command has been aborted and from inside iscsit_free_cmd() if a
> command has not been aborted, call __iscsit_free_cmd() from inside
> lio_release_cmd(). The latter function is namely called for all commands
> once the reference count has dropped to zero.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Reviewed-by: Mike Christie <mchristi@redhat.com>
> Cc: Varun Prakash <varun@chelsio.com>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/target/iscsi/iscsi_target.c          | 2 --
>  drivers/target/iscsi/iscsi_target_configfs.c | 1 +
>  drivers/target/iscsi/iscsi_target_util.c     | 4 +---
>  3 files changed, 2 insertions(+), 5 deletions(-)
> 

Hi Bart,

cxgbit driver is not working with this patch as transport_free_pages()
is called before calling conn->conn_transport->iscsit_release_cmd(), cxgbit
driver calls dma_unmap_sg() in ->iscsit_release_cmd(), transport_free_pages()
frees the scatterlist pages so dma unmap will not work.

cxgbit driver needs a callback before target frees the pages
so that it can dma unmap.

We can remove ->iscsit_release_cmd() from __iscsit_free_cmd() and call it
directly from iscsit_free_cmd(), iscsit_aborted_task().    

Thanks
Varun 
