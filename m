From: Michael Christie <michael.christie@oracle.com>
Date: Thu, 03 Sep 2020 15:36:58 +0000
Subject: Re: [RFC PATCH] scsi: target: detect XCOPY NAA descriptor conflicts
Message-Id: <7F596A9A-2116-4BA8-8A32-E98EDE996D8C@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200813002142.13820-1-ddiss@suse.de>
 <2155E745-0E65-441B-93AF-7B4C0A53F5F4@oracle.com>
 <20200903002336.083e88a4@suse.de>
In-Reply-To: <20200903002336.083e88a4@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: David Disseldorp <ddiss@suse.de>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org



> On Sep 2, 2020, at 5:23 PM, David Disseldorp <ddiss@suse.de> wrote:
> 
> Hi Mike,
> 
> On Tue, 1 Sep 2020 22:17:51 -0500, Michael Christie wrote:
> 
>>> --- a/drivers/target/target_core_xcopy.c
>>> +++ b/drivers/target/target_core_xcopy.c
>>> @@ -68,8 +68,14 @@ static int target_xcopy_locate_se_dev_e4_iter(struct se_device *se_dev,
>>> 	if (rc != 0)
>>> 		return 0;
>>> 
>>> -	info->found_dev = se_dev;
>>> 	pr_debug("XCOPY 0xe4: located se_dev: %p\n", se_dev);
>>> +	if (info->found_dev) {
>>> +		pr_warn("XCOPY 0xe4 descriptor conflict for se_dev %p and %p\n",
>>> +			info->found_dev, se_dev);
>>> +		target_undepend_item(&info->found_dev->dev_group.cg_item);
>>> +		return -ENOTUNIQ;
>>> +	}
>>> +	info->found_dev = se_dev;  
>> 
>> Was it valid to copy to/from the same LUN? You would copy from/to different src/destinations on that LUN. Would your patch break that?
> 
> XCOPY allows for copies to occur on the same LUN or between separate
> src/destinations. The intention of this patch is that regardless of the
> source or destination, if the NAA WWN could refer to multiple LUNs on
> the same target (via target_for_each_device()) then the XCOPY should
> fail and force the initiator to fallback to initiator driver copy.

So is the answer to my question a maybe but it probably will never happen?

If the user has multiple backend devices with the same serial, then your patch would now return error right? Is the reason that this patch is a RFC to try and figure out if that case is valid or ever happens? If so, the only way I could see that happening on purpose is if someone was trying to bypass a device issue.

For example, I create 2 tcmu devices. They both point to the same real device. Then export dev1 through target port1 and dev2 through target port2. Each tcmu device would then have it’s own data/cmd ring and locking, so you do not hit those perf issues. I do this for perf testing. I don’t think that type of thing is common or ever done, so I think the patch would be ok if that is a concern and it’s better than possible data corruption.

Code wise it looks ok to me.
