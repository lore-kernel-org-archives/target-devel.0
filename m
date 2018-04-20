From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Fri, 20 Apr 2018 23:09:48 +0000
Subject: Re: [PATCH v2] target: Fix Fortify_panic kernel exception
Message-Id: <yq1muxxh3ur.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1523979202-61407-1-git-send-email-bryantly@linux.vnet.ibm.com>
In-Reply-To: <1523979202-61407-1-git-send-email-bryantly@linux.vnet.ibm.com>
        (Bryant G. Ly's message of "Tue, 17 Apr 2018 10:33:21 -0500")
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Cc: hch@lst.de, nab@linux-iscsi.org, martin.petersen@oracle.com, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-block@vger.kernel.org, stable@vger.kernel.org


Bryant,

> The bug exists in the memcmp in which the length passed in must be
> guaranteed to be 1. This bug currently exists because the second
> pointer passed in, can be smaller than the cmd->data_length, which
> causes a fortify_panic.
>
> The fix is to use memchr_inv instead to find whether or not a 0 exists
> instead of using memcmp. This way you dont have to worry about buffer
> overflow which is the reason for the fortify_panic.

Clarified the commit description a bit and applied the patch
4.17/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
