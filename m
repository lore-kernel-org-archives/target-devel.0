From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Thu, 21 Mar 2019 00:38:51 +0000
Subject: Re: [PATCH] target:iscsi:free conn_ops when zalloc_cpumask_var failed
Message-Id: <yq1ftrh5aec.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1553091284-4412-1-git-send-email-hndksztwj@163.com>
In-Reply-To: <1553091284-4412-1-git-send-email-hndksztwj@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org


tangwenji,

> It should not free cpumask but free conn->conn_ops When
> zalloc_cpumask_var failed.

Applied to 5.2/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
