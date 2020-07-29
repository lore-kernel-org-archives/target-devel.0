From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Wed, 29 Jul 2020 04:10:32 +0000
Subject: Re: [PATCH v3 0/8] scsi: target: tcmu: Add TMR notification for tcmu
Message-Id: <159599579268.11289.16855842795289437175.b4-ty@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200726153510.13077-1-bstroesser@ts.fujitsu.com>
In-Reply-To: <20200726153510.13077-1-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Christie <michael.christie@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Bodo Stroesser <bstroesser@ts.fujitsu.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>

On Sun, 26 Jul 2020 17:35:02 +0200, Bodo Stroesser wrote:

> This patch series is made on top of Martin's for-next branch.
> 
> ChangeLog:
> 
> v2: in patch "scsi: target: tcmu: Implement tmr_notify callback"
>     changed new comment's style from "// ..." to "/* ... */"
>     and correctly use "/** " for function doc.
> 
> [...]

Applied to 5.9/scsi-queue, thanks!

[1/8] scsi: target: Modify core_tmr_abort_task()
      https://git.kernel.org/mkp/scsi/c/f5e2714ad1a6
[2/8] scsi: target: Add tmr_notify backend function
      https://git.kernel.org/mkp/scsi/c/2e45a1a9c75d
[3/8] scsi: target: tcmu: Use priv pointer in se_cmd
      https://git.kernel.org/mkp/scsi/c/a35129024e88
[4/8] scsi: target: tcmu: Do not queue aborted commands
      https://git.kernel.org/mkp/scsi/c/c96849276211
[5/8] scsi: target: tcmu: Factor out new helper ring_insert_padding
      https://git.kernel.org/mkp/scsi/c/3d3f9d56a570
[6/8] scsi: target: tcmu: Fix and simplify timeout handling
      https://git.kernel.org/mkp/scsi/c/ed212ca87897
[7/8] scsi: target: tcmu: Implement tmr_notify callback
      https://git.kernel.org/mkp/scsi/c/bc2d214af5db
[8/8] scsi: target: tcmu: Make TMR notification optional
      https://git.kernel.org/mkp/scsi/c/59526d7a187f

-- 
Martin K. Petersen	Oracle Linux Engineering
