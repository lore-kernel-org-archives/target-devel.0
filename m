From: Nakayama Kenjiro <nakayamakenjiro@gmail.com>
Date: Wed, 13 Sep 2017 18:35:16 +0000
Subject: Re: [PATCH] target: Add netlink command reply supported option for each device
Message-Id: <CAA_ZtA_m24ZBc5CRN+-M7wsu1BNWsWFTNPi1xAAg3xnVyx1DBQ@mail.gmail.com>
List-Id: <target-devel.vger.kernel.org>
References: <20170913050122.13731-1-nakayamakenjiro@gmail.com>
In-Reply-To: <20170913050122.13731-1-nakayamakenjiro@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

(re-sending this message as mail server returned error)

> I am ok with the idea for the patch, but what type of setup do you have
> where there are multiple applications using the interface and some
> support it and some do not? Is it because tcmu-runner is starting by
> default due to something like a distro systemd unit file and then you
> also have your app running too?

Though I am not going to run multiple applications using the
support/non-support interface atm, I have to note to use the non-support
app as  "Please do not run tcmu-runner (or any app that enables
netlink reply support) before/during running this app. If you ran it, you
have to restart the host and never run it again". It sounds like a
little bit silly note...

> Also, if you do not implement sync netlink support, how does your daemon
> tell the kernel if the device failed to setup in the daemon? For
> deletion how did you work around the uio crashes and leaks?

Yes, I admit that the application should implement the netlink sync
support, and I know the issue when I am using the device without
netlink sync. However, I believe that it would be good if there is an
option to (force) disable the netlink sync for the workaround. It
means that not only for the non-supported app, but also for the
trouble shooting. (As I sent timeout patch to add timeout, it sometimes
causes an issue like hang due to the netlink sync failure.)

> > would be expected to support the netlink reply. To make matters worse,
> > users will not be able to add a device via configfs manually.
> >
>
> What is the specific issue with manually setting it up through configfs?
> rtslib/tagretcli use the same configfs operations and does not know what
> tcmu and daemons like tcmu-runner support.

I meant the following steps:

1. Run tcmu-runner (to enable netlink reply support).

  // You can stop tcmu-runner process as it keeps the netlink support enabled //
  # ./tcmu-runner

2. Enable the new device

  // This will hang echo command forever //
  mkdir -p /sys/kernel/config/target/core/user_20/test
  echo "1" >> /sys/kernel/config/target/core/user_20/test/enable

My application is using same steps inside the code.

Regards,
Kenjiro


On Thu, Sep 14, 2017 at 12:58 AM, Mike Christie <mchristi@redhat.com> wrote:
> On 09/13/2017 12:01 AM, Kenjiro Nakayama wrote:
>> Currently netlink command reply support option
>> (TCMU_ATTR_SUPP_KERN_CMD_REPLY) can be enabled only on module
>> scope. Because of that, once an application enables the netlink
>> command reply support, all applications using target_core_user.ko
>
> I am ok with the idea for the patch, but what type of setup do you have
> where there are multiple applications using the interface and some
> support it and some do not? Is it because tcmu-runner is starting by
> default due to something like a distro systemd unit file and then you
> also have your app running too?
>
> Also, if you do not implement sync netlink support, how does your daemon
> tell the kernel if the device failed to setup in the daemon? For
> deletion how did you work around the uio crashes and leaks?
>
>> would be expected to support the netlink reply. To make matters worse,
>> users will not be able to add a device via configfs manually.
>>
>
> What is the specific issue with manually setting it up through configfs?
> rtslib/tagretcli use the same configfs operations and does not know what
> tcmu and daemons like tcmu-runner support.



-- 
Kenjiro NAKAYAMA <nakayamakenjiro@gmail.com>
GPG Key fingerprint = ED8F 049D E67A 727D 9A44  8E25 F44B E208 C946 5EB9
