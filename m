From: Mike Christie <mchristi@redhat.com>
Date: Mon, 11 May 2020 21:04:34 +0000
Subject: Re: [PATCH 03/15] target: add helper to parse acl and transport name
Message-Id: <07a1eadb-1040-2921-b16b-8cbb3231b025@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200510215744.21999-1-mchristi@redhat.com>
 <20200510215744.21999-4-mchristi@redhat.com>
 <20302416-6b4a-e9eb-695b-c4dcf50d02dd@ts.fujitsu.com>
In-Reply-To: <20302416-6b4a-e9eb-695b-c4dcf50d02dd@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Bodo Stroesser <bstroesser@ts.fujitsu.com>, bvanassche@acm.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Juergen Gross <jgross@suse.com>

On 5/11/20 1:22 PM, Bodo Stroesser wrote:
> On 05/10/20 23:57, Mike Christie wrote:
>> The drivers that emulate the initiator port id (loop, scsi vhost, xen
>> scsiback)
>> do almost the extact same parsing when making their I_T_nexus. This
>> adds a
>> helper that parses out the acl name and port name from the user
>> buffer, so
>> these types of drivers drop prefixes like "naa." when they need to for
>> the
>> SCSI SPC4 TransportID SAS address, but then keep it for the LIO ACL name.
>>
>> The next patches will then convert those drivers.
>>
>> Cc: Michael S. Tsirkin <mst@redhat.com>
>> Cc: Jason Wang <jasowang@redhat.com>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> Cc: Stefan Hajnoczi <stefanha@redhat.com>
>> Cc: Juergen Gross <jgross@suse.com>
>> Signed-off-by: Mike Christie <mchristi@redhat.com>
>> ---
>>   drivers/target/target_core_fabric_lib.c | 73
>> +++++++++++++++++++++++++++++++++
>>   include/target/target_core_fabric.h     |  2 +
>>   2 files changed, 75 insertions(+)
>>
>> diff --git a/drivers/target/target_core_fabric_lib.c
>> b/drivers/target/target_core_fabric_lib.c
>> index e89b3d8..81ed7d5 100644
>> --- a/drivers/target/target_core_fabric_lib.c
>> +++ b/drivers/target/target_core_fabric_lib.c
>> @@ -423,6 +423,79 @@ const char
>> *target_parse_pr_out_transport_id(struct se_portal_group *tpg,
>>       return buf + offset;
>>   }
>>   +/**
>> + * target_parse_emulated_name - parse TransportID and acl name from
>> user buffer
>> + * @proto_id: SCSI protocol identifier
>> + * @user_buf: buffer with emualted name to extract acl and
>> TransportID from
>> + * @acl_name: buffer to store se_node_acl name in
>> + * @max_name_len: len of acl_name buffer
>> + * @tpt_id_name: Pointer to the TransportID name will be stored here.
>> + */
>> +int target_parse_emulated_name(u8 proto_id, const char *user_buf,
>> +                   unsigned char *acl_name, int max_name_len,
>> +                   unsigned char **tpt_id_name)
>> +{
>> +    int user_len = strlen(user_buf);
>> +    char *proto_prefix, *name_start;
>> +
>> +    if (user_len >= max_name_len) {
>> +        pr_err("Emulated name: %s, exceeds max: %d\n", user_buf,
>> +               max_name_len);
>> +        return -EINVAL;
>> +    }
>> +
>> +    switch (proto_id) {
>> +    case SCSI_PROTOCOL_SAS:
>> +        proto_prefix = "naa.";
>> +        break;
>> +    case SCSI_PROTOCOL_FCP:
>> +        proto_prefix = "fc.";
>> +        break;
>> +    case SCSI_PROTOCOL_ISCSI:
>> +        proto_prefix = "iqn.";
>> +        break;
>> +    default:
>> +        pr_err("Unsupported proto_id: 0x%02x\n", proto_id);
>> +        return -EINVAL;
>> +    }
>> +
>> +    name_start = strstr(user_buf, proto_prefix);
>> +    if (!name_start) {
>> +        pr_err("Invalid emulated name %s. Must start with %s\n",
>> +               user_buf, proto_prefix);
>> +        return -EINVAL;
>> +    }
>> +
>> +    switch (proto_id) {
>> +    case SCSI_PROTOCOL_SAS:
>> +        sprintf(acl_name, name_start);
>> +        break;
>> +    case SCSI_PROTOCOL_FCP:
>> +        sprintf(acl_name, &name_start[3]); /* Skip over "fc." */
>> +        break;
> 
> Would it make sense to check acl_name for SAS and FCP according to
> the assumptions made in (sas|fc)_get_pr_transport_id() how the
> string should look like?
> 
> - SAS: 8 hex digits
> - FC: 8 pairs of 2 hex digits separated by 7 colons
> 
> For compatibility reasons 16 hex digits could be allowed alternatively
> for FC, if fc_get_pr_transport_id() is enhanced accordingly
In general I would say yes.

One hiccup I hit is that other than checking the prefix we have not been
validating names. So we could have existing setups with completely bogus
names like "naa.iworkbutamwrong", and if the user has never done
workloads that use PRs then it has worked fine.

If we start to validate the name here, how do we handle a failure? I
took the easy route and kept the existing behavior. For new
functionality like if a userspace daemon detects the bad value in sysfs
then I think it can decide to report a failover for that new
functionality and we would be ok.

In the long run though code path wise, I am going to replace the nacl
use in the PR code with the transport ID, so we won't have multiple
places doing stuff like
"/* Skip over 'naa. prefix */"
.
I am trying to do that work in the PR related patchset and keep this
focused on the sysfs part.
