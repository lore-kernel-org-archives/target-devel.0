From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Wed, 10 Jun 2020 02:02:48 +0000
Subject: Re: [PATCH v4 0/4] target: fix NULL pointer dereference
Message-Id: <159175452258.16072.16589931095798965569.b4-ty@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1591559913-8388-1-git-send-email-sudhakar.panneerselvam@oracle.com>
In-Reply-To: <1591559913-8388-1-git-send-email-sudhakar.panneerselvam@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org, michael.christie@oracle.com, Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>, linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, shirley.ma@oracle.com

On Sun, 7 Jun 2020 19:58:29 +0000, Sudhakar Panneerselvam wrote:

> The following set of commits address a NULL pointer dereference and some
> refactoring around this issue.
> 
> v4:
>  - initialize the LUN in transport_init_se_cmd()
> 
> v3:
>  - fix NULL pointer dereference when cdb initialization fails
> 
> [...]

Applied to 5.8/scsi-queue, thanks!

[1/4] scsi: target: Factor out a new helper, target_cmd_init_cdb()
      https://git.kernel.org/mkp/scsi/c/f98c2ddf8ba3
[2/4] scsi: target: Initialize LUN in transport_init_se_cmd()
      https://git.kernel.org/mkp/scsi/c/a36840d80027
[3/4] scsi: target: Fix NULL pointer dereference
      https://git.kernel.org/mkp/scsi/c/9e95fb805dc0
[4/4] scsi: target: Rename target_setup_cmd_from_cdb() to target_cmd_parse_cdb()
      https://git.kernel.org/mkp/scsi/c/987db58737e2

-- 
Martin K. Petersen	Oracle Linux Engineering
