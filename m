From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Tue, 26 Jun 2018 16:55:26 +0000
Subject: Re: [PATCH 1/1] tcmu: Don't pass KERN_ERR to pr_err
Message-Id: <yq1k1ql32td.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1530031640-8100-1-git-send-email-mchristi@redhat.com>
In-Reply-To: <1530031640-8100-1-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org


Mike,

> Fix warning:
>
> smatch warnings:
> drivers/target/target_core_user.c:301 tcmu_genl_cmd_done() warn: KERN_*
> level not at start of string

Applied to 4.19/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
