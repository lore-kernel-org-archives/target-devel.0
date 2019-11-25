From: Roman Bolshakov <r.bolshakov@yadro.com>
Date: Mon, 25 Nov 2019 17:00:51 +0000
Subject: Re: [PATCH v3 07/13] scsi: qla2xxx: Don't call qlt_async_event twice
Message-Id: <20191125170051.kxctfl7skse3gfk7@SPB-NB-133.local>
List-Id: <target-devel.vger.kernel.org>
References: <20191125165702.1013-1-r.bolshakov@yadro.com>
 <20191125165702.1013-8-r.bolshakov@yadro.com>
In-Reply-To: <20191125165702.1013-8-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: linux@yadro.com, Quinn Tran <qutran@marvell.com>, Himanshu Madhani <hmadhani@marvell.com>, Hannes Reinecke <hare@suse.de>

On Mon, Nov 25, 2019 at 07:56:56PM +0300, Roman Bolshakov wrote:
> MBA_PORT_UPDATE generates duplicate log lines in target mode because
> qlt_async_event is called twice. Drop the calls within the case as
> the function will be called right after the switch statement.
> 
> Cc: Quinn Tran <qutran@marvell.com>
> Acked-by: Himanshu Madhani <hmadhani@marvel.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Tested-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
> ---

The Acked-by tag should contain:

Acked-by: Himanshu Madhani <hmadhani@marvell.com>
