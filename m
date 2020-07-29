From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Wed, 29 Jul 2020 04:10:37 +0000
Subject: Re: [PATCH v4 0/2] iscsi-target: fix login error when receiving is too fast
Message-Id: <159599579268.11289.2746650835004823983.b4-ty@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200716100212.4237-1-houpu@bytedance.com>
In-Reply-To: <20200716100212.4237-1-houpu@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Hou Pu <houpu@bytedance.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, mchristi@redhat.com

On Thu, 16 Jul 2020 06:02:10 -0400, Hou Pu wrote:

> We encountered "iSCSI Login negotiation failed" several times.
> After enable debug log in iscsi_target_nego.c of iSCSI target.
> Error shows:
>   "Got LOGIN_FLAGS_READ_ACTIVE=1, conn: xxxxxxxxxx >>>>"
> 
> Patch 1 is trying to fix this problem. Please see comment in patch 1
> for details.
> 
> [...]

Applied to 5.9/scsi-queue, thanks!

[1/2] scsi: target: iscsi: Fix login error when receiving
      https://git.kernel.org/mkp/scsi/c/4e108d4f2816
[2/2] scsi: target: iscsi: Fix inconsistent debug message
      https://git.kernel.org/mkp/scsi/c/df2de6f28629

-- 
Martin K. Petersen	Oracle Linux Engineering
