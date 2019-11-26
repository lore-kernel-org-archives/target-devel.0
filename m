From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 26 Nov 2019 20:56:07 +0000
Subject: Re: [PATCH v3 04/13] scsi: qla2xxx: Drop superfluous INIT_WORK of del_work
Message-Id: <d8ed8672-ac41-16fc-d51c-a20f2dbd4f14@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20191125165702.1013-1-r.bolshakov@yadro.com>
 <20191125165702.1013-5-r.bolshakov@yadro.com>
In-Reply-To: <20191125165702.1013-5-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Bolshakov <r.bolshakov@yadro.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: linux@yadro.com, Quinn Tran <qutran@marvell.com>, Himanshu Madhani <hmadhani@marvell.com>, Hannes Reinecke <hare@suse.de>

On 11/25/19 8:56 AM, Roman Bolshakov wrote:
> del_work is already initialized inside qla2x00_alloc_fcport, there's no
> need to overwrite it. Indeed, it might prevent complete traversal of
> workqueue list.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
