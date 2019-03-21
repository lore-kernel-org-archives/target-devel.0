From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Thu, 21 Mar 2019 00:33:42 +0000
Subject: Re: [PATCH][next] scsi: target: fix unsigned comparision with less than zero
Message-Id: <yq1sgvh5amx.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20190320163709.28767-1-colin.king@canonical.com>
In-Reply-To: <20190320163709.28767-1-colin.king@canonical.com> (Colin King's
        message of "Wed, 20 Mar 2019 16:37:09 +0000")
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Colin King <colin.king@canonical.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org


Colin,

> Currently an error return is being assigned to an unsigned size_t
> varianle and then checked if the result is less than zero which will
> always be false.  Fix this by making ret ssize_t rather than a size_t.

Applied to 5.2/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
