From: Lee Duncan <lduncan@suse.com>
Date: Thu, 05 Apr 2018 17:06:35 +0000
Subject: Re: [PATCH] target: change default dbroot to /etc/target
Message-Id: <9d522b0a-147b-fe92-8276-39ddf8ea806a@suse.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180404194703.31888-1-lduncan@suse.com>
In-Reply-To: <20180404194703.31888-1-lduncan@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 04/05/2018 12:17 AM, Christoph Hellwig wrote:
> On Wed, Apr 04, 2018 at 12:47:03PM -0700, Lee Duncan wrote:
>> The dbroot (target PR database root directory) is
>> configurable but default to /var/target, a historic
>> value. But the reason for adding configurability
>> was to move the target directory out of /var. This
>> is because the File Hierarchy Standard v3.0 mandates
>> that this "target" directory not be in /var. See
>> https://refspecs.linuxfoundation.org/FHS_3.0/fhs-3.0.pdf
>>
>> This change moves the default from /var/target to
>> /etc/target, but this value is still configurable,
>> so those wishing to continue to use /var/target
>> can still do so.
> 
> This will break upgrades of all existing setups, so NAK.
> 

Hi Christoph:

I half expected this response, but here's the problem with the current
approach ...

The "dbroot" attribute is managed by target_core_mod, but this module is
generally never loaded directly. Usually it is loaded because some other
module (like ib_isert) is loaded, and it depends on target_core_mod.

So if a user starts up rdma services, for example, they end up with a
target_core_mod that will not allow dbroot to be changed. This is
because the dbroot change rules will not allow a change when there are
any children modules. [This problem will continue to grow as we get
other target-mode drivers, such as nvme?]

So setting the dbroot for all target driver requires some entity to load
target_core_mod and set dbroot before any other module that uses
target_core_mod loads.

This means either we need a special service, at boot time, to load the
core driver and set dbroot, so that all target drivers are treated
equally, or we put the burden on every target driver to do this setup,
which seems like an unreasonable duplication of effort.

Bottom line, we need a better way to set dbroot. This is true no matter
what the default value is for this attribute.

I understand your reluctance to change dbroot, but I also see this
leading to /var/target being the default location from now on unless we
change it some time. I'm open to suggestions on how we could update this
value and not break existing systems. A simple shell script could move
things from /var/target to /etc/target, but bare kernels have no way to
invoke "upgrade" scripts that I know of.

Also, I think it's a bit unlikely that anyone will still be using
/var/target, since targetcli-fb has been setting the target root to
/etc/target for a while now, and the old targetcli has been deprecated.
(It's the only app I know that hard-codes the old location.)

For now, I believe a workable solution may be to add "dbroot" as a
module parameter? If dbroot was a module param for target_core_mod, then
dbroot=/etc/target could be passed in by default (via modprobe.d) for
distros that wish to change the location.

I will work on such a patch, but if you dislike this idea please feel
free to save me some work, and let me know.
-- 
Lee Duncan
SUSE Labs
