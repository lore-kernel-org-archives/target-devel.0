From: Jason Gunthorpe <jgg@ziepe.ca>
Date: Sun, 17 May 2020 23:39:33 +0000
Subject: Re: [PATCH] RDMA/srpt: Add a newline when printing parameter 'srpt_service_guid' by sysfs
Message-Id: <20200517233933.GA21233@ziepe.ca>
List-Id: <target-devel.vger.kernel.org>
References: <1589182629-27743-1-git-send-email-wangxiongfeng2@huawei.com>
In-Reply-To: <1589182629-27743-1-git-send-email-wangxiongfeng2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Cc: bvanassche@acm.org, dledford@redhat.com, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, May 11, 2020 at 03:37:09PM +0800, Xiongfeng Wang wrote:
> When I cat module parameter 'srpt_service_guid', it displays as follows.
> It is better to add a newline for easy reading.
> 
> [root@hulk-202 ~]# cat /sys/module/ib_srpt/parameters/srpt_service_guid
> 0x0205cdfffe8346b9[root@hulk-202 ~]#
> 
> Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
> ---
>  drivers/infiniband/ulp/srpt/ib_srpt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to for-next, thanks

Jason
