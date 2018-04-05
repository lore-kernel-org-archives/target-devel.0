From: Lee Duncan <lduncan@suse.com>
Date: Thu, 05 Apr 2018 20:54:25 +0000
Subject: Re: [PATCH] target: change default dbroot to /etc/target
Message-Id: <ca9bf1ea-3007-7c20-6749-35ea59ce3356@suse.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180404194703.31888-1-lduncan@suse.com>
In-Reply-To: <20180404194703.31888-1-lduncan@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 04/05/2018 10:57 AM, Christoph Hellwig wrote:
> On Thu, Apr 05, 2018 at 10:06:35AM -0700, Lee Duncan wrote:
>> Also, I think it's a bit unlikely that anyone will still be using
>> /var/target, since targetcli-fb has been setting the target root to
>> /etc/target for a while now, and the old targetcli has been deprecated.
>> (It's the only app I know that hard-codes the old location.)
> 
> That is a a good point.  How about having a search path in the kernel?
> Try the configs attribute first if one is set, then /etc/target, then
> /var/target?
> 

Good suggestion.

But the configfs path is only passed in optionally, and possibly much
after initialization, so there's no way the code can check the configfs
path at initialization time, when this decision is first made.

How about if the code looks for /etc/target, then uses /var/target if
/etc/target is not present? Then users can use the current sysfs logic
to set the path to any other directory, if neither of these paths are to
their liking?

And users can always find out the current dbroot with the sysfs attribute.
-- 
Lee Duncan
SUSE Labs
