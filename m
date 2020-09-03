From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Thu, 03 Sep 2020 03:00:58 +0000
Subject: Re: [PATCH] iscsi-target: fix hang in iscsit_access_np() when getting tpg->np_login_sem
Message-Id: <159910202092.23499.4192678071370193305.b4-ty@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200729130343.24976-1-houpu@bytedance.com>
In-Reply-To: <20200729130343.24976-1-houpu@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hou Pu <houpu@bytedance.com>, michael.christie@oracle.com, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, stable@vger.kernel.org

On Wed, 29 Jul 2020 09:03:43 -0400, Hou Pu wrote:

> The iscsi target login thread might stuck in following stack:
> 
> cat /proc/`pidof iscsi_np`/stack
> [<0>] down_interruptible+0x42/0x50
> [<0>] iscsit_access_np+0xe3/0x167
> [<0>] iscsi_target_locate_portal+0x695/0x8ac
> [<0>] __iscsi_target_login_thread+0x855/0xb82
> [<0>] iscsi_target_login_thread+0x2f/0x5a
> [<0>] kthread+0xfa/0x130
> [<0>] ret_from_fork+0x1f/0x30
> 
> [...]

Applied to 5.9/scsi-fixes, thanks!

[1/1] scsi: target: iscsi: Fix hang in iscsit_access_np() when getting tpg->np_login_sem
      https://git.kernel.org/mkp/scsi/c/ed43ffea78dc

-- 
Martin K. Petersen	Oracle Linux Engineering
