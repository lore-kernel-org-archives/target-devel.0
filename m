From: Hannes Reinecke <hare@suse.com>
Date: Thu, 02 Nov 2017 13:57:18 +0000
Subject: Re: [PATCH 02/11] target: Suppress gcc 7 fallthrough warnings
Message-Id: <497fbb02-0d6b-5df7-c74b-90e5a17a3a4a@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: target-devel@vger.kernel.org

On 10/31/2017 07:03 PM, Bart Van Assche wrote:
> Avoid that gcc 7 reports the following warning when building with W=1:
> 
> warning: this statement may fall through [-Wimplicit-fallthrough=]
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Nicholas Bellinger <nab@linux-iscsi.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Mike Christie <mchristi@redhat.com>
> Cc: Varun Prakash <varun@chelsio.com>
> ---
>  drivers/target/iscsi/cxgbit/cxgbit_main.c | 1 +
>  drivers/target/target_core_pr.c           | 2 ++
>  drivers/target/target_core_transport.c    | 4 ++--
>  3 files changed, 5 insertions(+), 2 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
