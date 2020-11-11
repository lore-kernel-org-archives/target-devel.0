From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Wed, 11 Nov 2020 02:58:22 +0000
Subject: Re: [PATCH v4 0/4] scsi: target: COMPARE AND WRITE miscompare sense
Message-Id: <160506295513.14063.16995021450167842819.b4-ty@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20201031233211.5207-1-ddiss@suse.de>
In-Reply-To: <20201031233211.5207-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org, David Disseldorp <ddiss@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

On Sun, 1 Nov 2020 00:32:07 +0100, David Disseldorp wrote:

> This patchset adds missing functionality to return the offset of
> non-matching read/compare data in the sense INFORMATION field on
> COMPARE AND WRITE miscompare.
> 
> The functionality can be tested using the libiscsi
> CompareAndWrite.MiscompareSense test proposed via:
>   https://github.com/sahlberg/libiscsi/pull/344
> 
> [...]

Applied to 5.11/scsi-queue, thanks!

[1/4] scsi: target: Rename struct sense_info to sense_detail
      https://git.kernel.org/mkp/scsi/c/b455233dcc40
[2/4] scsi: target: Rename cmd.bad_sector to cmd.sense_info
      https://git.kernel.org/mkp/scsi/c/8dd992fb67f3
[3/4] scsi: target: Split out COMPARE AND WRITE memcmp into helper
      https://git.kernel.org/mkp/scsi/c/ab628b9fc8c2
[4/4] scsi: target: Return COMPARE AND WRITE miscompare offsets
      https://git.kernel.org/mkp/scsi/c/749c226cf56e

-- 
Martin K. Petersen	Oracle Linux Engineering
