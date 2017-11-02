From: Hannes Reinecke <hare@suse.com>
Date: Thu, 02 Nov 2017 13:58:24 +0000
Subject: Re: [PATCH 03/11] target: Inline transport_put_cmd()
Message-Id: <fb4fb006-ec0e-bc6e-6876-fc6e525e5778@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: target-devel@vger.kernel.org

On 10/31/2017 07:03 PM, Bart Van Assche wrote:
> Since all transput_put_cmd() does is to call target_put_sess_cmd(),
> inline transport_put_cmd() into its callers. Leave out the BUG_ON()
> statement because if cmd->se_tfo = NULL then cmd->cmd_kref is 0
> and kref_put() will complain anyway. Notes:
> - transport_init_se_cmd() initializes both .se_tfo and .cmd_kref.
> - The only target driver that does not call transport_init_se_cmd()
>   for all commands is the iSCSI target driver. See also
>   iscsi_target_rx_opcode().
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Nicholas Bellinger <nab@linux-iscsi.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Mike Christie <mchristi@redhat.com>
> ---
>  drivers/target/target_core_transport.c | 23 +++--------------------
>  1 file changed, 3 insertions(+), 20 deletions(-)
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
