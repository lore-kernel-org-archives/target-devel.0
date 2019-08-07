From: Jason Gunthorpe <jgg@ziepe.ca>
Date: Wed, 07 Aug 2019 12:10:37 +0000
Subject: Re: [bug report] rdma: rtnl_lock deadlock?
Message-Id: <20190807121037.GC1557@ziepe.ca>
List-Id: <target-devel.vger.kernel.org>
References: <5D4A3597.5020406@huawei.com>
In-Reply-To: <5D4A3597.5020406@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jiangyiwen <jiangyiwen@huawei.com>
Cc: bvanassche@acm.org, dledford@redhat.com, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, yebiaoxiang@huawei.com, Xiexiangyou <xiexiangyou@huawei.com>

On Wed, Aug 07, 2019 at 10:21:11AM +0800, Jiangyiwen wrote:
> Hello,
> 
> I find a scenario may cause deadlock of rtnl_lock as follows:
> 
> 1. CPU1 add rtnl_lock and wait kworker finished.
> CPU1 add rtnl_lock before call unregister_netdevice_queue() and
> then wait sport->work(function srpt_refresh_port_work) finished
> in srpt_remove_one().

This is an old kernel, this issue has been fixed

Jason
