From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Date: Wed, 08 Nov 2017 10:13:50 +0000
Subject: Re: [PATCH v3 5/8] target: Use sgl_alloc_order() and sgl_free()
Message-Id: <1510136030.29624.75.camel@haakon3.daterainc.com>
List-Id: <target-devel.vger.kernel.org>
References: <20171103222339.26540-1-bart.vanassche@wdc.com>
	 <20171103222339.26540-6-bart.vanassche@wdc.com>
	 <b8cd6935-2f42-6b43-f252-0f7d00e6fb71@suse.de>
In-Reply-To: <b8cd6935-2f42-6b43-f252-0f7d00e6fb71@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hannes Reinecke <hare@suse.de>
Cc: Bart Van Assche <bart.vanassche@wdc.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Herbert Xu <herbert@gondor.apana.org.au>, Hannes Reinecke <hare@suse.com>, Sagi Grimberg <sagi@grimberg.me>, target-devel <target-devel@vger.kernel.org>

On Mon, 2017-11-06 at 08:10 +0100, Hannes Reinecke wrote:
> On 11/03/2017 11:23 PM, Bart Van Assche wrote:
> > Use the sgl_alloc_order() and sgl_free() functions instead of open
> > coding these functions.
> > 
> > Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> > Cc: Nicholas A. Bellinger <nab@linux-iscsi.org>
> > Cc: Christoph Hellwig <hch@lst.de>
> > Cc: Hannes Reinecke <hare@suse.com>
> > Cc: Sagi Grimberg <sagi@grimberg.me>
> > ---
> >  drivers/target/Kconfig                 |  1 +
> >  drivers/target/target_core_transport.c | 46 +++-------------------------------
> >  2 files changed, 5 insertions(+), 42 deletions(-)
> > 
> Reviewed-by: Hannes Reinecke <hare@suse.com>
> 

Nice improvement to turn this into common code.

Acked-by: Nicholas Bellinger <nab@linux-iscsi.org>


