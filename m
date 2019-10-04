From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Fri, 04 Oct 2019 02:00:49 +0000
Subject: Re: [PATCH] target: Remove tpg_list and se_portal_group.se_tpg_node
Message-Id: <yq14l0ps20e.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20190930232224.58980-1-bvanassche@acm.org>
In-Reply-To: <20190930232224.58980-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org


Bart,

> Maintaining tpg_list without ever iterating over it is not
> useful. Hence remove tpg_list. This patch does not change the behavior
> of the SCSI target code.

Applied to 5.5/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
