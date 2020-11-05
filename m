From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Thu, 05 Nov 2020 03:41:32 +0000
Subject: Re: [PATCH 0/8 v3] target: fix up locking/refcounting in IO paths
Message-Id: <yq1tuu4scev.fsf@ca-mkp.ca.oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1604257174-4524-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1604257174-4524-1-git-send-email-michael.christie@oracle.com>
        (Mike Christie's message of "Sun, 1 Nov 2020 12:59:26 -0600")
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Christie <michael.christie@oracle.com>
Cc: himanshu.madhani@oracle.com, njavali@marvell.com, james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org


Mike,

> The following patches made over Martin's staging branch fix some
> ref counting issues I hit while testing and improves the locking
> in the IO paths. To do the latter, the patches:

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
