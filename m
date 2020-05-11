From: Hannes Reinecke <hare@suse.de>
Date: Mon, 11 May 2020 06:12:26 +0000
Subject: Re: [PATCH 07/15] iscsi target: setup transport_id
Message-Id: <55dbc4af-e001-1d4e-b407-6c2350869138@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20200510215744.21999-1-mchristi@redhat.com>
 <20200510215744.21999-8-mchristi@redhat.com>
In-Reply-To: <20200510215744.21999-8-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Mike Christie <mchristi@redhat.com>, bvanassche@acm.org, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 5/10/20 11:57 PM, Mike Christie wrote:
> The iscsi target does its own session setup. This patch updates the
> driver so it sets up the transport id.
> 
> Signed-off-by: Mike Christie <mchristi@redhat.com>
> ---
>   drivers/target/iscsi/iscsi_target_nego.c | 32 ++++++++++++++++++++++++++++----
>   1 file changed, 28 insertions(+), 4 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
