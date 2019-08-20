From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 20 Aug 2019 15:43:59 +0000
Subject: Re: [PATCH v2 1/2] scsi: target/tcm_loop: ignore already deleted scsi device
Message-Id: <737dd6be-a8c9-492c-8057-1f16b3d90519@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20190820090429.1961085-1-naohiro.aota@wdc.com>
 <1973f310-ad00-ff88-fe08-a31f81dc5c33@acm.org> <5D5C1159.4030507@redhat.com>
In-Reply-To: <5D5C1159.4030507@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Christie <mchristi@redhat.com>, Naohiro Aota <naohiro.aota@wdc.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Nicholas Bellinger <nab@linux-iscsi.org>, "Martin K . Petersen" <martin.petersen@oracle.com>

On 8/20/19 8:27 AM, Mike Christie wrote:
> tcm loop does not take a reference to the scsi_device at creation/link
> time then need to release at removal/unlink time. The above
> scsi_device_put is for the successful scsi_device_lookup call. tcm loop
> works like a scsi host driver that does its own scanning via
> scsi_add_device (maybe similar to scsi drivers that are raid cards).
> Like other host drivers it does not take a reference to the device when
> it is added and relies on scsi-ml to handle all that for it before doing
> operations like queuecommand.
> 
> The leak is if you removed the scsi_device via the scsi ml sysfs
> interface then there is no way to completely unlink the lio port because
> if scsi_device_lookup fails we return from the function and do not do
> not release our refcount on the tl_tpg_port_count.

Hi Mike,

Does this mean that you think that this patch is the right way to 
address the reported issue?

Thanks,

Bart.
