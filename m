From: Bart Van Assche <bvanassche@acm.org>
Date: Sun, 19 Apr 2020 23:45:16 +0000
Subject: Re: [PATCH] scsi: target/iblock: fix WRITE SAME zeroing
Message-Id: <8883020c-0575-bba6-0a6d-e858b1f83e79@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20200419163109.11689-1-ddiss@suse.de>
In-Reply-To: <20200419163109.11689-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Disseldorp <ddiss@suse.de>, target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com

On 4/19/20 9:31 AM, David Disseldorp wrote:
> SBC4 specifies that WRITE SAME requests with the UNMAP bit set to zero
> "shall perform the specified write operation to each LBA specified by
> the command".
> 2237498f0b5c modified the iblock backend to call blkdev_issue_zeroout()
> when handling WRITE SAME requests with UNMAP=0 and a zero data segment.
> The iblock blkdev_issue_zeroout() call incorrectly provides a flags
> parameter of 0 (bool false), instead of BLKDEV_ZERO_NOUNMAP. The bool
> false parameter reflects the blkdev_issue_zeroout() API prior to
> ee472d835c264, which was merged shortly before 2237498f0b5c.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
