From: Hannes Reinecke <hare@suse.de>
Date: Mon, 08 Jun 2020 06:21:10 +0000
Subject: Re: [PATCH 16/17] iscsi target: export session state and alias in sysfs
Message-Id: <0df57c39-48f5-d257-3d76-0dc2bb4ff305@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
 <1591562164-9766-17-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1591562164-9766-17-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 6/7/20 10:36 PM, Mike Christie wrote:
> Export the session state and alias in sysfs.
> 
> Note:
> It does not export the per connection state. In the future we can
> have the iscsi target add/rm an attribute group directly for each
> connection when we login and logout/drop a connection. Since those
> are dynamic and can change while the session exists, we don't need
> them at device addition so it can be done directly from the module.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/target/iscsi/iscsi_target_configfs.c | 97 ++++++++++++++++++++++------
>   1 file changed, 76 insertions(+), 21 deletions(-)
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
