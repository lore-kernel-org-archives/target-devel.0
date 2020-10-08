From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Thu, 08 Oct 2020 02:31:52 +0000
Subject: Re: [PATCH 02/14] target/rd: drop double zeroing
Message-Id: <yq11ri9zbvz.fsf@ca-mkp.ca.oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1600601186-7420-1-git-send-email-Julia.Lawall@inria.fr>
        <1600601186-7420-3-git-send-email-Julia.Lawall@inria.fr>
In-Reply-To: <1600601186-7420-3-git-send-email-Julia.Lawall@inria.fr> (Julia
        Lawall's message of "Sun, 20 Sep 2020 13:26:14 +0200")
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Julia Lawall <Julia.Lawall@inria.fr>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org


Julia,

> sg_init_table zeroes its first argument, so the allocation of that argument
> doesn't have to.

Applied to 5.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
