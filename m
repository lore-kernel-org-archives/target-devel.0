From: Hannes Reinecke <hare@suse.de>
Date: Tue, 15 Oct 2019 05:59:06 +0000
Subject: Re: [PATCH] target: do not overwrite CDB byte 1
Message-Id: <28c6b43e-2f1c-e58e-2106-a28f941e2ecd@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <12498eab-76fd-eaad-1316-c2827badb76a@ts.fujitsu.com>
In-Reply-To: <12498eab-76fd-eaad-1316-c2827badb76a@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: target-devel@vger.kernel.org

On 10/14/19 8:29 PM, Bodo Stroesser wrote:
> passthrough_parse_cdb() - used by TCMU and PSCSI - attepts to
> reset the LUN field of SCSI-2 CDBs (bits 5,6,7 of byte 1).
> The current code is wrong, as for newer commands not having the
> LUN field it overwrites relevant command bits (e.g. for SECURITY
> PROTOCOL IN / OUT)
> We think this code was unnecessary from the beginning or at least
> it is no longer useful. So we remove it entirely.
> 
> Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
> ---
>  drivers/target/target_core_device.c |   21 ---------------------
>  1 file changed, 21 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      Teamlead Storage & Networking
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 247165 (AG München), GF: Felix Imendörffer
