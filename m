From: Nakayama Kenjiro <nakayamakenjiro@gmail.com>
Date: Sat, 16 Sep 2017 12:54:36 +0000
Subject: Re: [PATCH v3] target/tcmu: Add a timeout for the completion of netlink command reply
Message-Id: <CAA_ZtA9FTbP2RUYe54_Fy-k3De_PbeU_f1HJb=nXx5y=P1tOTw@mail.gmail.com>
List-Id: <target-devel.vger.kernel.org>
References: <20170915071713.13758-1-nakayamakenjiro@gmail.com>
In-Reply-To: <20170915071713.13758-1-nakayamakenjiro@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

> There is still one issue. For the tcmu-runner type of app the problem is
> if userspace is using the uio device when the kernel times out and
> addition or removal then we will crash the kernel due to null pointer
> accesses.
>
> What is the goal of this patch? Do you just want to catch the case where
> there are no listeners in userspace, or are you trying to dynamically
> detect the case where userspace does not have sync command support?
>
> With your other patch, we will know if apps are not doing sync nl
> commands, so I am guessing it's not that.

I am thinking that the goal of this patch is to rescue from
a)userspace's reply failure and b)kernel's reply catch failure.

More specifically,

  a) e.g in tcmu-runner, it could fail to send a netlink reply in
  send_netlink_reply() .
  b) tcmu_genl_cmd_done() could return an error before calling
  complete(&nl_cmd->complete).

Both a) and b) could cause the hanging and no resort to rescue it
now. The most troublesome when this hang happened is that the host
will fail to shutdown, so force shutdown is necessary. That's why I
would like to add the timeout.

But I'm sorry, I didn't notice the timeout will crash the
kernel with tcmu-runner type of app. Better handling would be necessary.

> Do we just want to detect the case where there is no listners? If so,
> can we fix the genlmsg_multicast_allns call so it returns -ESRCH if
> there are no listeners and not when any listerner call fails? Or maybe
> just not use it for new uses. We could pass in the nl portid of the
> listener in the device create call and unicast to the specific nl
> handler. We will know for sure if there is something that wants to
> listen and we will get -ECONNREFUSED if something happened and there is
> nothing listening.

That's good idea that sending nl to the specific portid. But it would
not solve above situation a) and b), wouldn't it?


On Sat, Sep 16, 2017 at 10:21 AM, Mike Christie <mchristi@redhat.com> wrote:
> On 09/15/2017 02:17 AM, Kenjiro Nakayama wrote:
>> This patch adds a timeout for the completion of netlink command reply.
>>
>> Current code waits for the netlink reply from userspace and the status
>> change, but it hangs forever when userspace failed to reply. To fix
>> this issue, this patch replace wait_for_completion with
>> wait_for_completion_timeout.
>>
>> Default timeout is 300 sec that gives enough time, and this is
>> configurable via configfs.
>>
>> Changes since v1(suggested by Mike Christie):
>> v2: - Makes default timeout enough long as 300 sec.
>>     - Makes timeout configurable via configfs.
>> v3: - Reinit command status and wake up other calls waiting after
>>       timeout.
>>     - Use timeout in seconds.
>>
>
>
> There is still one issue. For the tcmu-runner type of app the problem is
> if userspace is using the uio device when the kernel times out and
> addition or removal then we will crash the kernel due to null pointer
> accesses.
>
> What is the goal of this patch? Do you just want to catch the case where
> there are no listeners in userspace, or are you trying to dynamically
> detect the case where userspace does not have sync command support?
>
> With your other patch, we will know if apps are not doing sync nl
> commands, so I am guessing it's not that.
>
> Do we just want to detect the case where there is no listners? If so,
> can we fix the genlmsg_multicast_allns call so it returns -ESRCH if
> there are no listeners and not when any listerner call fails? Or maybe
> just not use it for new uses. We could pass in the nl portid of the
> listener in the device create call and unicast to the specific nl
> handler. We will know for sure if there is something that wants to
> listen and we will get -ECONNREFUSED if something happened and there is
> nothing listening.



-- 
Kenjiro NAKAYAMA <nakayamakenjiro@gmail.com>
GPG Key fingerprint = ED8F 049D E67A 727D 9A44  8E25 F44B E208 C946 5EB9
