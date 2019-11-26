From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 26 Nov 2019 20:55:44 +0000
Subject: Re: [PATCH v3 03/13] scsi: qla2xxx: Initialize free_work before flushing it
Message-Id: <0e30f3d6-148d-28cf-7f55-8acc9599e1be@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20191125165702.1013-1-r.bolshakov@yadro.com>
 <20191125165702.1013-4-r.bolshakov@yadro.com>
In-Reply-To: <20191125165702.1013-4-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Bolshakov <r.bolshakov@yadro.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: linux@yadro.com, Quinn Tran <qutran@marvell.com>, stable@vger.kernel.org, Himanshu Madhani <hmadhani@marvell.com>, Hannes Reinecke <hare@suse.de>

On 11/25/19 8:56 AM, Roman Bolshakov wrote:
> Target creation triggers a new BUG_ON introduced in in 4d43d395fed12
> ("workqueue: Try to catch flush_work() without INIT_WORK().").
> The BUG_ON reveals an attempt to flush free_work in qla24xx_do_nack_work
> before it's initialized in qlt_unreg_sess: [ ... ]

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
