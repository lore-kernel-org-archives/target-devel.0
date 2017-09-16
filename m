From: Mike Christie <mchristi@redhat.com>
Date: Sat, 16 Sep 2017 01:01:18 +0000
Subject: Re: [PATCH] target: Add netlink command reply supported option for each device
Message-Id: <59BC77DE.2030301@redhat.com>
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
> would be expected to support the netlink reply. To make matters worse,
> users will not be able to add a device via configfs manually.
> 
> To fix these issues, this patch adds an option to make netlink command
> reply disabled on each device through configfs. Original
> TCMU_ATTR_SUPP_KERN_CMD_REPLY is still enabled on module scope to keep
> backward-compatibility and used by default, however once users set
> nl_reply_supported=<NAGATIVE_VALUE> via configfs for a particular
> device, the device disables the netlink command reply support.
> 

Patch is ok with me.

Reviewed-by: Mike Christie <mchristi@redhat.com>

