From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Tue, 05 Dec 2017 03:32:37 +0000
Subject: Re: [PATCH] ibmvscsis: add DRC indices to debug statements
Message-Id: <yq14lp54zoq.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20171204220728.94613-1-bryantly@linux.vnet.ibm.com>
In-Reply-To: <20171204220728.94613-1-bryantly@linux.vnet.ibm.com> (Bryant
        G. Ly's message of "Mon, 4 Dec 2017 16:07:28 -0600")
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Cc: nab@linux-iscsi.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Brad Warrum <bwarrum@us.ibm.com>


Bryant,

> Where applicable, changes pr_debug, pr_info, pr_err, etc. calls
> to the dev_* versions.  This adds the DRC index of the device to the
> corresponding trace statement.

Applied to 4.16/scsi-queue, thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
