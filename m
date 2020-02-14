From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Fri, 14 Feb 2020 22:14:44 +0000
Subject: Re: [PATCH 1/2] Revert "RDMA/isert: Fix a recently introduced regression related to logout"
Message-Id: <yq1y2t4olyj.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200213050900.19094-1-bvanassche@acm.org>
In-Reply-To: <20200213050900.19094-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org


Bart,

> Since commit 04060db41178 introduces soft lockups when toggling
> network interfaces, revert it.

Applied 1+2 to 5.6/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
