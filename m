From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Tue, 22 Sep 2020 03:56:49 +0000
Subject: Re: [PATCH] scsi: target: remove redundant assignment to variable 'ret'
Message-Id: <160074695008.411.535339245470908448.b4-ty@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200914023207.113792-1-jingxiangfeng@huawei.com>
In-Reply-To: <20200914023207.113792-1-jingxiangfeng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mlombard@redhat.com, ddiss@suse.de, gustavoars@kernel.org, Jing Xiangfeng <jingxiangfeng@huawei.com>, michael.christie@oracle.com, sudhakar.panneerselvam@oracle.com, bvanassche@acm.org
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, 14 Sep 2020 10:32:07 +0800, Jing Xiangfeng wrote:

> The variable ret has been initialized with a value '0'. The assignment
> in switch-case is redundant. So remove it.

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: target: Remove redundant assignment to variable 'ret'
      https://git.kernel.org/mkp/scsi/c/1c370903d12d

-- 
Martin K. Petersen	Oracle Linux Engineering
