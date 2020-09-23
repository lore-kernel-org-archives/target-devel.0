From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Wed, 23 Sep 2020 00:51:57 +0000
Subject: Re: [PATCH] scsi: target: Fix lun lookup for TARGET_SCF_LOOKUP_LUN_FROM_TAG case.
Message-Id: <160082230400.6366.234985652157623643.b4-ty@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1600300471-26135-1-git-send-email-sudhakar.panneerselvam@oracle.com>
In-Reply-To: <1600300471-26135-1-git-send-email-sudhakar.panneerselvam@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org, Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>, linux-scsi@vger.kernel.org, michael.christie@oracle.com
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, ssudhakarp@gmail.com

On Wed, 16 Sep 2020 23:54:31 +0000, Sudhakar Panneerselvam wrote:

> transport_lookup_tmr_lun() uses "orig_fe_lun" member of struct se_cmd
> for the lookup. Hence, update this field directly for the
> TARGET_SCF_LOOKUP_LUN_FROM_TAG case.

Applied to 5.9/scsi-fixes, thanks!

[1/1] scsi: target: Fix lun lookup for TARGET_SCF_LOOKUP_LUN_FROM_TAG case
      https://git.kernel.org/mkp/scsi/c/149415586243

-- 
Martin K. Petersen	Oracle Linux Engineering
