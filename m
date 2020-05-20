From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Wed, 20 May 2020 02:30:07 +0000
Subject: Re: [PATCH v1 target] target: Add initiatorname to NON_EXISTENT_LUN error
Message-Id: <158994171818.20861.13529776753176885593.b4-ty@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <9b13bb2e1f52f1792cd81850ee95bf3781bb5363.1589759816.git.lance.digby@gmail.com>
In-Reply-To: <9b13bb2e1f52f1792cd81850ee95bf3781bb5363.1589759816.git.lance.digby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mchristi@redhat.com, Lance Digby <lance.digby@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, 18 May 2020 11:02:16 +1000, Lance Digby wrote:

> The NON_EXISTENT_LUN error can be written without an error condition
> on the initiator responsible. Adding the initiatorname to this message
> will reduce the effort required to fix this when many initiators are
> supported by a target.
> 
> This version ensures the initiator name is also printed on the same
> message in transport_lookup_tmr_lun for consistency.

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: target: core: Add initiatorname to NON_EXISTENT_LUN error
      https://git.kernel.org/mkp/scsi/c/5482d56bfedf

-- 
Martin K. Petersen	Oracle Linux Engineering
