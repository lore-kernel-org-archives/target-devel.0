From: Michael Christie <mchristi@redhat.com>
Date: Thu, 02 Apr 2020 18:58:54 +0000
Subject: Re: [PATCH] target: tcmu: add missing pr attributes to passthrough backends
Message-Id: <68272880-55c1-f56b-13fe-ef58a284aa3d@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200401132153.23501-1-bstroesser@ts.fujitsu.com>
In-Reply-To: <20200401132153.23501-1-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 04/02/2020 09:11 AM, Bodo Stroesser wrote:
> 
> On 04/01/20 22:05, Michael Christie wrote:
>> On 04/01/2020 08:21 AM, Bodo Stroesser wrote:
>>> In commit b49d6f7885306ee636d5c1af52170f3069ccf5f7 the new attribute>
>>> emulate_pr was added.
>>> passthrough_parse_cdb() uses the attribute's value to distinguish,
>>> whether reservation commands should be rejected or not.
>>> But the new attribute was not added to passthrough_attrib_attrs, so in
>>> pscsi and tcmu - the users of passthrough_parse_cdb() - the attribute
>>> is not available to change parser's behavior.
>>> This patch adds the new attribute as well as the "pr control" attributes
>>> enforce_pr_isids and force_pr_aptpl to passthrough_attrib_attrs.
>>>
>>> Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
>>> ---
>>>   drivers/target/target_core_configfs.c | 3 +++
>>>   1 file changed, 3 insertions(+)
>>>
>>> diff --git a/drivers/target/target_core_configfs.c
>>> b/drivers/target/target_core_configfs.c
>>> index ff82b21fdcce..c5a974c5b31d 100644
>>> --- a/drivers/target/target_core_configfs.c
>>> +++ b/drivers/target/target_core_configfs.c
>>> @@ -1203,6 +1203,9 @@ struct configfs_attribute
>>> *passthrough_attrib_attrs[] = {
>>>       &attr_hw_block_size,
>>>       &attr_hw_max_sectors,
>>>       &attr_hw_queue_depth,
>>> +    &attr_emulate_pr,
>>
>> This one seems ok here, because it works for both pscsi and tcmu.
>>
>>> +    &attr_enforce_pr_isids,
>>> +    &attr_force_pr_aptpl,
>>
>> These only work for tcmu. pscsi will do whatever the physical device
>> does, and we can't control it. I guess the options would be:
> 
> Sorry, I forgot to add a note, that I'm preparing a further patch, that
> allows to write pgr_support attribute (TRANSPORT_FLAG_PASSTHROUGH_PGR),
> if the backend allows it.
> 
> We need this to be able to set TRANSPORT_FLAG_PASSTHROUGH_PGR for tcmu.
> 
> But of course it also would be an option for pscsi to allow resetting of
> TRANSPORT_FLAG_PASSTHROUGH_PGR. Then the pr emulation in target core can
> be used by pscsi. (And then the two other attributes become useful.)
> 
> I'm wondering anyway, whether reservation passthrough makes sense for

Yeah, I wondered the same thing. Some commands that use transport info
might not work correctly right now or apps could get confused when the
transport it sees is FC because the qla2xxx fabric driver is used to
export a pscsi LU, but the pscsi scsi_device struct is for a iSCSI
device so inquiry name and port info will look mismatched. But then for
really specific SCSI 2 reservation cases it might be working.

When I added the extra passthrough flags, I did not know how users were
using it, and I didn't want to break existing setups. I just kept the
same behavior/support incase someone had a specific setup that was working.

> pscsi? For tcmu we will also send a patch allowing to pass nexus info up
> to userland.
> 
>>
>> 1. Just add them above.
> 
> According to what I wrote above, I'd still prefer option 1. :)

I think it might be best to get them in at the same time then. If not,
we might end up where in some kernels those files do nothing and report
success, then in other kernels they actually work.


> 
> Thank you,
> Bodo
> 
>>
>> 2. Add them above and add some TRANSPORT_FLAG_PASSTHROUGH_PGR checks in
>> functions like force_pr_aptpl_store like we did for the pr functions, so
>> the user gets some feedback if they try to use them for pscsi. We would
>> have to add a isid function too.
>>
>> 3. Export the attrs or some common lib/helper functions to get/set the
>> values then target_core_user.c can setup the attrs and add it to
>> tcmu_attrib_attrs.
>>
>>
>>>       &attr_alua_support,
>>>       &attr_pgr_support,
>>>       NULL,
>>
>>
>>
> 
