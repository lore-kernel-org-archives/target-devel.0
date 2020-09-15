From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Tue, 15 Sep 2020 22:06:28 +0000
Subject: Re: [PATCH] scsi: target: remove redundant assignment to variable 'ret'
Message-Id: <yq1een24rvk.fsf@ca-mkp.ca.oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200914023207.113792-1-jingxiangfeng@huawei.com>
In-Reply-To: <20200914023207.113792-1-jingxiangfeng@huawei.com> (Jing
        Xiangfeng's message of "Mon, 14 Sep 2020 10:32:07 +0800")
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jing Xiangfeng <jingxiangfeng@huawei.com>
Cc: martin.petersen@oracle.com, bvanassche@acm.org, michael.christie@oracle.com, mlombard@redhat.com, sudhakar.panneerselvam@oracle.com, ddiss@suse.de, gustavoars@kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org


Jing,

> The variable ret has been initialized with a value '0'. The assignment
> in switch-case is redundant. So remove it.

Applied to 5.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
