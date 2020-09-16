From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Wed, 16 Sep 2020 00:19:39 +0000
Subject: Re: [PATCH] scsi: target: tcmu: add a missing newline when printing parameters
Message-Id: <yq1zh5q1skp.fsf@ca-mkp.ca.oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1599132573-33818-1-git-send-email-wangxiongfeng2@huawei.com>
In-Reply-To: <1599132573-33818-1-git-send-email-wangxiongfeng2@huawei.com>
        (Xiongfeng Wang's message of "Thu, 3 Sep 2020 19:29:33 +0800")
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org


Xiongfeng,

> When I cat module paramter 'global_max_data_area_mb' by sysfs, it
> displays as follows. It's better to add a newline for easy reading.

Applied to 5.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
