From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Tue, 31 Jul 2018 03:31:57 +0000
Subject: Re: [PATCH] Revert "scsi: target/iscsi: Reduce number of __iscsit_free_cmd() callers"
Message-Id: <yq1tvogulle.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180726172037.2658-1-bart.vanassche@wdc.com>
In-Reply-To: <20180726172037.2658-1-bart.vanassche@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org


Bart,

> The cxgbit driver expects that __iscsit_free_cmd() is called before the
> target core frees the command page list. Since this patch breaks the
> cxgbit driver, revert it.

Applied to 4.19/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
