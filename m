From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Fri, 24 Aug 2018 02:27:58 +0000
Subject: Re: [PATCH] scsi: target: iscsi: cxgbit: use pr_debug() instead of pr_info()
Message-Id: <yq1wosg8pn5.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1534002029-9281-1-git-send-email-varun@chelsio.com>
In-Reply-To: <1534002029-9281-1-git-send-email-varun@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org


Varun,

> DDP programming happens in data path and it can fail because of lack
> of resources so use pr_debug() instead of pr_info() for this case.

Applied to 4.19/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
