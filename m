From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Tue, 22 Sep 2020 03:56:55 +0000
Subject: Re: [PATCH] scsi: target: tcmu: add a missing newline when printing parameters
Message-Id: <160074695010.411.10221836550956633689.b4-ty@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1599132573-33818-1-git-send-email-wangxiongfeng2@huawei.com>
In-Reply-To: <1599132573-33818-1-git-send-email-wangxiongfeng2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 3 Sep 2020 19:29:33 +0800, Xiongfeng Wang wrote:

> When I cat module paramter 'global_max_data_area_mb' by sysfs, it
> displays as follows. It's better to add a newline for easy reading.
> 
> root@(none):/# cat /sys/module/target_core_user/parameters/global_max_data_area_mb
> 2048noneroot@(none):/#

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: target: tcmu: Add missing newline when printing parameters
      https://git.kernel.org/mkp/scsi/c/6d70cb343484

-- 
Martin K. Petersen	Oracle Linux Engineering
