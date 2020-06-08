From: Hannes Reinecke <hare@suse.de>
Date: Mon, 08 Jun 2020 06:16:22 +0000
Subject: Re: [PATCH 13/17] iscsi target: replace module sids with lio's sid
Message-Id: <8f729965-7954-6c96-de78-ea30013659e2@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
 <1591562164-9766-14-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1591562164-9766-14-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 6/7/20 10:36 PM, Mike Christie wrote:
> This is the first phase in hooking iscsi into the sysfs API. This patch
> has it use lio core's sid instead of its internal ones.
> 
> We have 2 sids in the iscsi target layer:
> - module sid: int id that is unique across all iscsi targets. Used for
>    sess_get_index().
> - iscsi target port group sid: int id that is unique in the tpg. Uses
>    for logging.
> 
> The lio one works exactly like the iscsi target module one, and the iscsi
> tpg one is not very useful because when you have multiple tpgs you can't
> tell which tpg the session is under. In the latter case the lio core one
> is more useful, because it matches what we see in userspace and logs and
> we can distinguish what fabric/target/tpg the session is under.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/target/iscsi/iscsi_target.c          |  6 ++----
>   drivers/target/iscsi/iscsi_target_configfs.c |  6 ++----
>   drivers/target/iscsi/iscsi_target_erl0.c     | 11 ++++++-----
>   drivers/target/iscsi/iscsi_target_erl2.c     |  8 ++++----
>   drivers/target/iscsi/iscsi_target_login.c    | 20 ++------------------
>   drivers/target/iscsi/iscsi_target_stat.c     |  3 +--
>   drivers/target/iscsi/iscsi_target_tmr.c      |  2 +-
>   drivers/target/iscsi/iscsi_target_tpg.c      | 16 +++++++---------
>   drivers/target/iscsi/iscsi_target_util.c     |  2 +-
>   include/target/iscsi/iscsi_target_core.h     |  6 ------
>   10 files changed, 26 insertions(+), 54 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
