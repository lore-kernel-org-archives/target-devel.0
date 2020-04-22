From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Wed, 22 Apr 2020 04:02:42 +0000
Subject: Re: [PATCH] scsi: target/iblock: fix WRITE SAME zeroing
Message-Id: <yq1d080i2vx.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200419163109.11689-1-ddiss@suse.de>
In-Reply-To: <20200419163109.11689-1-ddiss@suse.de> (David Disseldorp's
        message of "Sun, 19 Apr 2020 18:31:09 +0200")
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Disseldorp <ddiss@suse.de>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, bvanassche@acm.org


David,

> SBC4 specifies that WRITE SAME requests with the UNMAP bit set to zero
> "shall perform the specified write operation to each LBA specified by
> the command".
> 2237498f0b5c modified the iblock backend to call blkdev_issue_zeroout()
> when handling WRITE SAME requests with UNMAP=0 and a zero data segment.
> The iblock blkdev_issue_zeroout() call incorrectly provides a flags
> parameter of 0 (bool false), instead of BLKDEV_ZERO_NOUNMAP. The bool
> false parameter reflects the blkdev_issue_zeroout() API prior to
> ee472d835c264, which was merged shortly before 2237498f0b5c.

Applied to 5.7/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
