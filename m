From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Date: Fri, 03 Apr 2020 10:26:44 +0000
Subject: Re: [PATCH] target: tcmu: add missing pr attributes to passthrough backends
Message-Id: <b5b27cb5-bf42-6b85-66d6-dff1bc87af7a@ts.fujitsu.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200401132153.23501-1-bstroesser@ts.fujitsu.com>
In-Reply-To: <20200401132153.23501-1-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hi David,

On 04/03/20 01:30, David Disseldorp wrote:
> Hi,
> 
> On Wed,  1 Apr 2020 15:21:53 +0200, Bodo Stroesser wrote:
> 
>> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
>> index ff82b21fdcce..c5a974c5b31d 100644
>> --- a/drivers/target/target_core_configfs.c
>> +++ b/drivers/target/target_core_configfs.c
>> @@ -1203,6 +1203,9 @@ struct configfs_attribute *passthrough_attrib_attrs[] = {
>>   	&attr_hw_block_size,
>>   	&attr_hw_max_sectors,
>>   	&attr_hw_queue_depth,
>> +	&attr_emulate_pr,
>> +	&attr_enforce_pr_isids,
>> +	&attr_force_pr_aptpl,
>>   	&attr_alua_support,
>>   	&attr_pgr_support,
>>   	NULL,
> 
> The attr_emulate_pr addition here looks fine. If you and Mike agree to
> proceed with the other two attrs then it probably makes sense to add
> them via a separate patch.

Before my patch and also after it if setting of emulate_pr is not
changed tcmu uses the core's pr emulation.
So I think at least for tcmu it makes sense to add the two "pr control"
attributes here, because they are missing for the default mode of tcmu,
while the emulate_pr attribute should be added to be able to switch off
pr in total.

Of course we end up then having the "pr control" attributes for pscsi
also and they have no effect because TRANSPORT_FLAG_PASSTHROUGH_PGR
is set in pscsi. Regarding this I'll soon send a patch that converts
pgr_support and alua_support attribute from readonly to read write,
if the backend allows writing it.
I need that for full userspace emulation with tcmu, but I guess for
pscsi it would also be good to allow writing of at least pgr_support.
Writing 1 to that attribute would reset TRANSPORT_FLAG_PASSTHROUGH_PGR
and thus switch on core's pr emulation for pscsi, making
enforce_pr_isids and force_pr_aptpl useful for pscsi.

Thank you,
Bodo

> 
> Cheers, David
> 
