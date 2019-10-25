From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Fri, 25 Oct 2019 01:16:05 +0000
Subject: Re: [PATCH -next] scsi: cxgb4i: remove set but not used variable 'ppmax'
Message-Id: <yq1lft9bp62.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20191021142042.30964-1-yuehaibing@huawei.com>
In-Reply-To: <20191021142042.30964-1-yuehaibing@huawei.com>
        (yuehaibing@huawei.com's message of "Mon, 21 Oct 2019 22:20:42 +0800")
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: YueHaibing <yuehaibing@huawei.com>
Cc: kxie@chelsio.com, jejb@linux.ibm.com, martin.petersen@oracle.com, bvanassche@acm.org, davem@davemloft.net, tglx@linutronix.de, info@metux.net, kstewart@linuxfoundation.org, varun@chelsio.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, target-devel@vger.kernel.org


YueHaibing,

> Fixes gcc '-Wunused-but-set-variable' warning:
>
> drivers/scsi/cxgbi/cxgb4i/cxgb4i.c:2076:15:
>  warning: variable ppmax set but not used [-Wunused-but-set-variable]
> drivers/target/iscsi/cxgbit/cxgbit_ddp.c:300:15:
>  warning: variable ppmax set but not used [-Wunused-but-set-variable]

Applied to 5.5/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
