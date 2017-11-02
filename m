From: Hannes Reinecke <hare@suse.com>
Date: Thu, 02 Nov 2017 14:27:38 +0000
Subject: Re: [PATCH 08/11] target/iscsi: Modify iscsit_do_crypto_hash_buf() prototype
Message-Id: <4af8b169-f280-86bc-cc53-fc1ad5024fc3@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: target-devel@vger.kernel.org

On 10/31/2017 07:03 PM, Bart Van Assche wrote:
> Change the type of the last two arguments from u8 * into const void *
> and void * respectively such that the u8 * casts can be left out
> from the callers. This patch does not change any functionality.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Nicholas Bellinger <nab@linux-iscsi.org>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Mike Christie <mchristi@redhat.com>
> ---
>  drivers/target/iscsi/iscsi_target.c | 41 +++++++++++++++----------------------
>  1 file changed, 17 insertions(+), 24 deletions(-)
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
