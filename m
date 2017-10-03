From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Tue, 03 Oct 2017 02:51:51 +0000
Subject: Re: [PATCH] ibmvscsis: Fix write_pending failure path
Message-Id: <yq1k20d0wqg.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20171002175938.11764-1-bryantly@linux.vnet.ibm.com>
In-Reply-To: <20171002175938.11764-1-bryantly@linux.vnet.ibm.com> (Bryant
        G. Ly's message of "Mon, 2 Oct 2017 12:59:38 -0500")
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Cc: nab@linux-iscsi.org, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Bryant G. Ly" <bgly@us.ibm.com>


Bryant,

> For write_pending if the queue is down or client failed then return
> -EIO so that LIO can properly process the completed command. Prior we
> returned 0 since LIO could not handle it properly. Now with: target:
> Fix unknown fabric callback queue-full errors that patch addresses
> LIO's ability to handle things right.

Applied to 4.14/scsi-fixes. thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
