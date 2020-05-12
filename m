From: Mike Christie <mchristi@redhat.com>
Date: Tue, 12 May 2020 15:55:33 +0000
Subject: Re: [PATCH 12/15] target: add sysfs session helper functions
Message-Id: <52a13df8-3d36-2ebc-a288-88d4dbfe9cd1@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200510215744.21999-1-mchristi@redhat.com>
 <20200510215744.21999-13-mchristi@redhat.com>
 <66e9bbf8-fdb2-d819-a496-75a1dea779cf@ts.fujitsu.com>
 <a3686299-8fab-3cf7-0641-5e7c98a7292d@acm.org>
 <5234c678-92e6-0689-1eca-aa0c252adf58@redhat.com>
 <a1ca0d10-9011-52a6-f40b-dc5086d9e273@ts.fujitsu.com>
In-Reply-To: <a1ca0d10-9011-52a6-f40b-dc5086d9e273@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Bodo Stroesser <bstroesser@ts.fujitsu.com>, Bart Van Assche <bvanassche@acm.org>, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Hannes Reinecke <hare@suse.de>

On 5/12/20 6:19 AM, Bodo Stroesser wrote:
> On 05/11/20 22:16, Mike Christie wrote:
>> On 5/11/20 2:21 PM, Bart Van Assche wrote:
>>> On 2020-05-11 11:39, Bodo Stroesser wrote:
>>>> On 05/10/20 23:57, Mike Christie wrote:
>>>>> This patch adds helpers to add/remove a dir per session. There is
>>>>> only 2
>>>>> files/dirs initially.
>>>>>
>>>>
>>>> ...
>>>>
>>>>> +
>>>>> +int target_sysfs_add_session(struct se_portal_group *se_tpg,
>>>>> +                 struct se_session *se_sess)
>>>>> +{
>>>>> +    int ret;
>>>>> +
>>>>> +    /*
>>>>> +     * Copy ACL name so we don't have to worry about mixing configfs
>>>>> +     * and sysfs refcounts.
>>>>> +     */
>>>>> +    if (!se_sess->se_node_acl->dynamic_node_acl) {
>>>>> +        se_sess->acl_name >>>>> kstrdup(se_sess->se_node_acl->initiatorname,
>>>>> +                        GFP_KERNEL);
>>>>> +        if (!se_sess->acl_name)
>>>>> +            return -ENOMEM;
>>>>> +    }
>>>>> +
>>>>> +    ret = kobject_add(&se_sess->kobj, se_tpg->sessions_kobj, "%s-%d",
>>>>> +              se_sess->tpt_id->name, se_sess->sid);
>>>>> +    if (ret) {
>>>>> +        pr_err("Could not add session%d to sysfs. Error %d.\n",
>>>>> +               se_sess->sid, ret);
>>>>> +        goto free_acl_name;
>>>>> +    }
>>>>> +
>>>>> +    ret = add_transport_id_attrs(se_sess);
>>>>> +    if (ret)
>>>>> +        goto del_kobj;
>>>>> +
>>>>> +    if (se_sess->tfo->session_attrs) {
>>>>> +        ret = sysfs_create_group(&se_sess->kobj,
>>>>> +                     se_sess->tfo->session_attrs);
>>>>> +        if (ret)
>>>>> +            goto rm_tpt_id_grps;
>>>>> +    }
>>>>> +
>>>>> +    ret = sysfs_create_link(tcm_core_sessions_kobj, &se_sess->kobj,
>>>>> +                se_sess->kobj.name);
>>>>
>>>> I would prefer to have links named "session-%d" or "%d" only, of course
>>>> with se_sess->sid as the value for '%d'.
>>
>> Yeah for the part of your comment that got chopped I can see your point.
>> For the dynamic acl case (userspace did not create an ACL so the kernel
>> made a tmp one), then doing session-$id will be easier for userspace to
>> lookup a specific session since it does not know the initiator name and
>> only knows the session id.
> 
> Yes, I meant, that "session-%d" or even "%d" only would be fine for the
> links in scsi_target/sessions. When looking for a session if session-id
> is known only, then this is easy to use.
> 
> Regarding the session folders in the tpgt_X folder, I think the "%s-%d"
> format with acl or initiator name followed by the session-id would be
> fine for both cases, with acl and with dynamic acl. Again the above
> links can be used for dynamic acl lookup.
>
I don't think that's possible.

To handle Greg's comment we will use device structs instead of kobjects
directly. It's going to end up looking like
drivers/scsi_transport_iscsi.c where that initiator side session has a
device struct in it. You have a scsi_target_session class and device
structs show up in /sys/class/scsi_target_session. In this case, you do
not have control over the symlink name from
/sys/class/scsi_target_session to /sys/devices/. The dir name and
symlink name are going to be the device structs name.
