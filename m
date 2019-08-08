From: Jiangyiwen <jiangyiwen@huawei.com>
Date: Thu, 08 Aug 2019 01:59:18 +0000
Subject: Re: [bug report] rdma: rtnl_lock deadlock?
Message-Id: <5D4B81F6.7010002@huawei.com>
List-Id: <target-devel.vger.kernel.org>
References: <5D4A3597.5020406@huawei.com> <20190807121037.GC1557@ziepe.ca>
In-Reply-To: <20190807121037.GC1557@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: bvanassche@acm.org, dledford@redhat.com, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, yebiaoxiang@huawei.com, Xiexiangyou <xiexiangyou@huawei.com>

Hi Jason,

On 2019/8/7 20:10, Jason Gunthorpe wrote:
> On Wed, Aug 07, 2019 at 10:21:11AM +0800, Jiangyiwen wrote:
>> Hello,
>>
>> I find a scenario may cause deadlock of rtnl_lock as follows:
>>
>> 1. CPU1 add rtnl_lock and wait kworker finished.
>> CPU1 add rtnl_lock before call unregister_netdevice_queue() and
>> then wait sport->work(function srpt_refresh_port_work) finished
>> in srpt_remove_one().
> This is an old kernel, this issue has been fixed
>
> Jason
>
Thank you for your reply, and can you tell me the commit id?
I use the kernel version is Linux4.19.36.

Thanks,
Yiwen.
