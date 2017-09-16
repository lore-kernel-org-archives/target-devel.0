From: Mike Christie <mchristi@redhat.com>
Date: Sat, 16 Sep 2017 01:21:56 +0000
Subject: Re: [PATCH v3] target/tcmu: Add a timeout for the completion of netlink command reply
Message-Id: <59BC7CB4.1070005@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20170915071713.13758-1-nakayamakenjiro@gmail.com>
In-Reply-To: <20170915071713.13758-1-nakayamakenjiro@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 09/15/2017 02:17 AM, Kenjiro Nakayama wrote:
> This patch adds a timeout for the completion of netlink command reply.
> 
> Current code waits for the netlink reply from userspace and the status
> change, but it hangs forever when userspace failed to reply. To fix
> this issue, this patch replace wait_for_completion with
> wait_for_completion_timeout.
> 
> Default timeout is 300 sec that gives enough time, and this is
> configurable via configfs.
> 
> Changes since v1(suggested by Mike Christie):
> v2: - Makes default timeout enough long as 300 sec.
>     - Makes timeout configurable via configfs.
> v3: - Reinit command status and wake up other calls waiting after
>       timeout.
>     - Use timeout in seconds.
> 


There is still one issue. For the tcmu-runner type of app the problem is
if userspace is using the uio device when the kernel times out and
addition or removal then we will crash the kernel due to null pointer
accesses.

What is the goal of this patch? Do you just want to catch the case where
there are no listeners in userspace, or are you trying to dynamically
detect the case where userspace does not have sync command support?

With your other patch, we will know if apps are not doing sync nl
commands, so I am guessing it's not that.

Do we just want to detect the case where there is no listners? If so,
can we fix the genlmsg_multicast_allns call so it returns -ESRCH if
there are no listeners and not when any listerner call fails? Or maybe
just not use it for new uses. We could pass in the nl portid of the
listener in the device create call and unicast to the specific nl
handler. We will know for sure if there is something that wants to
listen and we will get -ECONNREFUSED if something happened and there is
nothing listening.
