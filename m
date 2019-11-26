From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 26 Nov 2019 20:55:17 +0000
Subject: Re: [PATCH v3 01/13] scsi: qla2xxx: Ignore NULL pointer in tcm_qla2xxx_free_mcmd
Message-Id: <4c8131c4-6386-860c-6dfc-695eabeedcb4@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20191125165702.1013-1-r.bolshakov@yadro.com>
 <20191125165702.1013-2-r.bolshakov@yadro.com>
In-Reply-To: <20191125165702.1013-2-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Bolshakov <r.bolshakov@yadro.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: linux@yadro.com, Quinn Tran <qutran@marvell.com>, Thomas Abraham <tabraham@suse.com>, stable@vger.kernel.org, Himanshu Madhani <hmadhani@marvell.com>, Hannes Reinecke <hare@suse.de>

On 11/25/19 8:56 AM, Roman Bolshakov wrote:
> If ABTS cannot be completed in target mode, the driver attempts to free [ ... ]

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
