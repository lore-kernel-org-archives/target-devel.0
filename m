From: Mike Christie <mchristi@redhat.com>
Date: Mon, 15 Jan 2018 19:39:46 +0000
Subject: Re: [PATCH 0/5]: Fix target_core_user userspace restarts (v2)
Message-Id: <5A5D0382.9030702@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <1513677838-6675-1-git-send-email-mchristi@redhat.com>
In-Reply-To: <1513677838-6675-1-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 01/14/2018 10:19 PM, Nicholas A. Bellinger wrote:
> On Sat, 2018-01-13 at 12:50 -0600, Mike Christie wrote:
>> On 01/12/2018 10:08 PM, Nicholas A. Bellinger wrote:
>>> On Fri, 2018-01-12 at 16:41 -0600, Mike Christie wrote:
>>>> On 01/12/2018 04:13 PM, Nicholas A. Bellinger wrote:
> 
> <SNIP>
> 
>>>>
>>>> I guess the options were:
>>>>
>>>> 1. This patch that separates this kind of files and tries to make it
>>>> generic.
>>>> 2. Instead of the generic action dir, I could just make a
>>>> target_core_user specific dir.
>>>> 3. I can modify rtslib with a attr file blacklist, and these special
>>>> files can go in it.
>>>>
>>>> I thought #1 or even #2 was nicer, because attrs seemed like they had a
>>>> specific purpose to get/set info about an object.
>>>
>>> If it's purely to avoid block_dev + reset_ring attr write operation upon
>>> rtslib se_device creation, following how pi_prot_format works with
>>> existing tcmu_attrib_attrs[] is an option too.
>>>
>>> That said, I'm not against adding a new se_device->dev_action_group, but
>>> want to make sure these new attributes are really considered private to
>>> tcmu's own user-space, separate what rtslib + friends code ever expects
>>> to poke at..
>>>
>>> Is that the case..?
>>
>> I am not sure I understood the question completely.
>>
>> I can imagine someone creating other apps and wanting to use these files
>> for similar reasons as tcmu-runner. We have seen people that are making
>> their own tcmu daemons/userspace apps and sometimes use rtslib and
>> sometimes do not. Does that answer your question?
>>
> 
> Was just curious if these actions are intended to be driven by tcmu
> user-space code for resetting kernel code to consistent state during
> error handling, or if end-users would be expected to trigger during
> normal operation..?

Users would never need to use them. It is just for the userspace apps to
coordinate their state with the kernel.

> 
> If it's intended to be driven by tcmu user-space consumers, then adding
> a new config_group makes sense.
> 

Ok.

>> I can go either way on the action dir vs attached patch that implements
>> them as attrs. I did know about the 4th pi_prot_format style option :)
> 
> Likewise.  :)
> 
> That said, assuming tcmu-runner & friends will be using these attributes
> internally, I'm OK with merging the original series.
> 

Ok.
