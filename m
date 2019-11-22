From: Hannes Reinecke <hare@suse.de>
Date: Fri, 22 Nov 2019 09:14:13 +0000
Subject: Re: [PATCH v2 00/15] scsi: qla2xxx: Bug fixes
Message-Id: <b84e274f-c20e-9351-27de-4cf1b34916d9@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20191120222723.27779-1-r.bolshakov@yadro.com>
In-Reply-To: <20191120222723.27779-1-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Roman Bolshakov <r.bolshakov@yadro.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: linux@yadro.com

On 11/20/19 11:27 PM, Roman Bolshakov wrote:
> 
> Hi Martin,
> 
> The patch series contains fixes for qla2xxx and solves two visible
> issues:
>   - Target port in N2N topology doesn't perform login if it has higher
>     WWPN than initiator
>   - ABORT TASK TMF leads to crash if it's received shortly after ACL of
>     an initiator is deleted and there's active I/O from the initiator
> 
> It also contains reliability improvements and cleanups.
> 
> Unfortunately, there's still an issue the latest patch. The discard
> works but ELS IOCB for LOGO is likely built incorrectly by
> qla24xx_els_dcmd_iocb(). The issue can also be exposed when "1" is
> written to fc_host/hostN/device/issue_logo file with logging turned on.
> 
> Changes since v1 (https://patchwork.kernel.org/cover/11141979/):
> - Fixes target port in N2N mode were added (patches 5-11);
> - Target port makes explicit LOGO on session teardown in the patch made
>   by Quinn. Together with patch 1, it helps to immediately turn
>   fc_remote_port to the Blocked stated on client side and avoids visibly
>   stuck session;
> - The last three patches address violation of FCP specification with
>   regards to handling of ABTS-LS from ports that are not currently
>   logged in.
> 
> Thank you,
> Roman
> 
> Quinn Tran (1):
>   scsi: qla2xxx: Use explicit LOGO in target mode
> 
> Roman Bolshakov (14):
>   scsi: qla2xxx: Ignore NULL pointer in tcm_qla2xxx_free_mcmd
>   scsi: qla2xxx: Initialize free_work before flushing it
>   scsi: qla2xxx: Drop superfluous INIT_WORK of del_work
>   scsi: qla2xxx: Change discovery state before PLOGI
>   scsi: qla2xxx: Allow PLOGI in target mode
>   scsi: qla2xxx: Don't call qlt_async_event twice
>   scsi: qla2xxx: Fix PLOGI payload and ELS IOCB dump length
>   scsi: qla2xxx: Configure local loop for N2N target
>   scsi: qla2xxx: Send Notify ACK after N2N PLOGI
>   scsi: qla2xxx: Don't defer relogin unconditonally
>   scsi: qla2xxx: Ignore PORT UPDATE after N2N PLOGI
>   scsi: qla2xxx: Add async mode for qla24xx_els_dcmd_iocb
>   scsi: qla2xxx: Add debug dump of LOGO payload and ELS IOCB
>   scsi: qla2xxx: Handle ABTS according to FCP spec for logged out ports
> 
>  drivers/scsi/qla2xxx/qla_attr.c    |  2 +-
>  drivers/scsi/qla2xxx/qla_def.h     |  1 +
>  drivers/scsi/qla2xxx/qla_gbl.h     |  2 +-
>  drivers/scsi/qla2xxx/qla_init.c    | 21 ++++++---------
>  drivers/scsi/qla2xxx/qla_iocb.c    | 42 ++++++++++++++++++++++++------
>  drivers/scsi/qla2xxx/qla_isr.c     |  4 ---
>  drivers/scsi/qla2xxx/qla_mbx.c     |  3 ++-
>  drivers/scsi/qla2xxx/qla_target.c  | 34 ++++++++++++++++--------
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c |  3 +++
>  9 files changed, 73 insertions(+), 39 deletions(-)
> 
This patchset has the nice benefit that it has fixed the crashes on
rmmod we had been seeing.

So, for the entire patchset:

Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      Teamlead Storage & Networking
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 247165 (AG München), GF: Felix Imendörffer
