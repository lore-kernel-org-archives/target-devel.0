From: Mike Christie <mchristi@redhat.com>
Date: Sun, 17 Sep 2017 20:27:21 +0000
Subject: Re: [PATCH v3] target/tcmu: Add a timeout for the completion of netlink command reply
Message-Id: <59BEDAA9.8080200@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20170915071713.13758-1-nakayamakenjiro@gmail.com>
In-Reply-To: <20170915071713.13758-1-nakayamakenjiro@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 09/16/2017 07:54 AM, Nakayama Kenjiro wrote:
>> There is still one issue. For the tcmu-runner type of app the problem is
>> if userspace is using the uio device when the kernel times out and
>> addition or removal then we will crash the kernel due to null pointer
>> accesses.
>>
>> What is the goal of this patch? Do you just want to catch the case where
>> there are no listeners in userspace, or are you trying to dynamically
>> detect the case where userspace does not have sync command support?
>>
>> With your other patch, we will know if apps are not doing sync nl
>> commands, so I am guessing it's not that.
> 
> I am thinking that the goal of this patch is to rescue from
> a)userspace's reply failure and b)kernel's reply catch failure.
> 
> More specifically,
> 
>   a) e.g in tcmu-runner, it could fail to send a netlink reply in
>   send_netlink_reply() .
>   b) tcmu_genl_cmd_done() could return an error before calling
>   complete(&nl_cmd->complete).
> 
> Both a) and b) could cause the hanging and no resort to rescue it
> now. The most troublesome when this hang happened is that the host
> will fail to shutdown, so force shutdown is necessary. That's why I
> would like to add the timeout.
> 
> But I'm sorry, I didn't notice the timeout will crash the
> kernel with tcmu-runner type of app. Better handling would be necessary.
> 
>> Do we just want to detect the case where there is no listners? If so,
>> can we fix the genlmsg_multicast_allns call so it returns -ESRCH if
>> there are no listeners and not when any listerner call fails? Or maybe
>> just not use it for new uses. We could pass in the nl portid of the
>> listener in the device create call and unicast to the specific nl
>> handler. We will know for sure if there is something that wants to
>> listen and we will get -ECONNREFUSED if something happened and there is
>> nothing listening.
> 
> That's good idea that sending nl to the specific portid. But it would
> not solve above situation a) and b), wouldn't it?

No. Completely different problems, and timeout seems sane for your cases.

For the sync add/delete device timeout case are our only options when
timing out:

1. Free the kernel structs and possibly crash the kernel.
2. Definitely hang.
3. Possibly Leak. - On timeout of add/delete return a ETIME failure, but
do not teardown the kernel structs in case userspace is using them via
uio or mmap.
4. Add more complicated protocol for something that is going to be rare.
5. ?



