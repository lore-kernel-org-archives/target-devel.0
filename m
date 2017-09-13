From: Nakayama Kenjiro <nakayamakenjiro@gmail.com>
Date: Wed, 13 Sep 2017 19:27:18 +0000
Subject: Re: [PATCH] target: Add netlink command reply supported option for each device
Message-Id: <CAA_ZtA8ASDuH+-WcJ1+7CSHRKRKt78+w4CcW6o05nnP3XyYb6A@mail.gmail.com>
List-Id: <target-devel.vger.kernel.org>
References: <20170913050122.13731-1-nakayamakenjiro@gmail.com>
In-Reply-To: <20170913050122.13731-1-nakayamakenjiro@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

> If you are not going to use targetcli/rtslib then you do not need
> netlink and to go through those extra steps.
>
> It sounds like you want to do:
>
> 1. app runs configfs commands to add and enable tcmu device.
> 2. app knows tcmu device name and other info so it can just setup its
> objects on successful writing to the enable file.
> 3. It sounds like you do not need the nl events at all at this point
> right.

Yes, that's correct I don't need any nl events actually. But my point
is that when netlink reply support is enabled on the host by other app,
writing to the enable file ($TARGET/user_N/device/enable) hangs because
of waiting for the netlink sync in kernel. That's why I thought I
should implement it.

Currently there are no way to disable the netlink sync once enabled
it and even no way to check if it is enable/disabled on the host. You
don't think that it is necessary? At least, I would like to confirm
the netlink sync was disabled before running a non-support netlink app.

Regards,
Kenjiro



On Thu, Sep 14, 2017 at 3:43 AM, Mike Christie <mchristi@redhat.com> wrote:
> On 09/13/2017 01:28 PM, Nakayama Kenjiro wrote:
>>> I am ok with the idea for the patch, but what type of setup do you have
>>> where there are multiple applications using the interface and some
>>> support it and some do not? Is it because tcmu-runner is starting by
>>> default due to something like a distro systemd unit file and then you
>>> also have your app running too?
>>
>> Though I am not going to run multiple applications using the
>> support/non-support interface atm, I have to note to use the non-support
>> app as  "Please do not run tcmu-runner (or any app that enables
>> netlink reply support) before/during running this app. If you ran it, you
>> have to restart the host and never run it again". It sounds like a
>> little bit silly note...
>
> Yes. Agree.
>
>>
>>> Also, if you do not implement sync netlink support, how does your daemon
>>> tell the kernel if the device failed to setup in the daemon? For
>>> deletion how did you work around the uio crashes and leaks?
>>
>> Yes, I admit that the application should implement the netlink sync
>> support,
>
> Actually maybe I would not add support for it at all if I were you.
>
> Some other questions/comments, because how the daemons like tcmu-runner
> do setup might be a result of using targetcli/rtslib, and if you are not
> going to use that then you can simplfy things.
>
> The current normal way to create a device is:
>
> 1. Start app which listens on nl.
> 2. targetcli/rtslib run configfs commands to add and enable tcmu device.
> 3. tcmu sends nl event to app which sets up its objects for the device
> and returns success/failure.
>
> This approach works well for the targetcli/rtslib device management
> flow, but has those extra steps.
>
> If you are not going to use targetcli/rtslib then you do not need
> netlink and to go through those extra steps.
>
> It sounds like you want to do:
>
> 1. app runs configfs commands to add and enable tcmu device.
> 2. app knows tcmu device name and other info so it can just setup its
> objects on successful writing to the enable file.
> 3. It sounds like you do not need the nl events at all at this point right.



-- 
Kenjiro NAKAYAMA <nakayamakenjiro@gmail.com>
GPG Key fingerprint = ED8F 049D E67A 727D 9A44  8E25 F44B E208 C946 5EB9
