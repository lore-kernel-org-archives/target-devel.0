From: Mike Christie <mchristi@redhat.com>
Date: Wed, 13 Sep 2017 15:58:05 +0000
Subject: Re: [PATCH] target: Add netlink command reply supported option for each device
Message-Id: <6eaf2a2e-5635-0923-cbe3-5c8b8dbd021a@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20170913050122.13731-1-nakayamakenjiro@gmail.com>
In-Reply-To: <20170913050122.13731-1-nakayamakenjiro@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 09/13/2017 12:01 AM, Kenjiro Nakayama wrote:
> Currently netlink command reply support option
> (TCMU_ATTR_SUPP_KERN_CMD_REPLY) can be enabled only on module
> scope. Because of that, once an application enables the netlink
> command reply support, all applications using target_core_user.ko

I am ok with the idea for the patch, but what type of setup do you have
where there are multiple applications using the interface and some
support it and some do not? Is it because tcmu-runner is starting by
default due to something like a distro systemd unit file and then you
also have your app running too?

Also, if you do not implement sync netlink support, how does your daemon
tell the kernel if the device failed to setup in the daemon? For
deletion how did you work around the uio crashes and leaks?

> would be expected to support the netlink reply. To make matters worse,
> users will not be able to add a device via configfs manually.
> 

What is the specific issue with manually setting it up through configfs?
rtslib/tagretcli use the same configfs operations and does not know what
tcmu and daemons like tcmu-runner support.
