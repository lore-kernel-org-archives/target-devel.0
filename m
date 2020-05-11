From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 11 May 2020 19:21:59 +0000
Subject: Re: [PATCH 12/15] target: add sysfs session helper functions
Message-Id: <a3686299-8fab-3cf7-0641-5e7c98a7292d@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20200510215744.21999-1-mchristi@redhat.com>
 <20200510215744.21999-13-mchristi@redhat.com>
 <66e9bbf8-fdb2-d819-a496-75a1dea779cf@ts.fujitsu.com>
In-Reply-To: <66e9bbf8-fdb2-d819-a496-75a1dea779cf@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Bodo Stroesser <bstroesser@ts.fujitsu.com>, Mike Christie <mchristi@redhat.com>, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

On 2020-05-11 11:39, Bodo Stroesser wrote:
> On 05/10/20 23:57, Mike Christie wrote:
>> This patch adds helpers to add/remove a dir per session. There is only 2
>> files/dirs initially.
>>
> 
> ...
> 
>> +
>> +int target_sysfs_add_session(struct se_portal_group *se_tpg,
>> +                 struct se_session *se_sess)
>> +{
>> +    int ret;
>> +
>> +    /*
>> +     * Copy ACL name so we don't have to worry about mixing configfs
>> +     * and sysfs refcounts.
>> +     */
>> +    if (!se_sess->se_node_acl->dynamic_node_acl) {
>> +        se_sess->acl_name = kstrdup(se_sess->se_node_acl->initiatorname,
>> +                        GFP_KERNEL);
>> +        if (!se_sess->acl_name)
>> +            return -ENOMEM;
>> +    }
>> +
>> +    ret = kobject_add(&se_sess->kobj, se_tpg->sessions_kobj, "%s-%d",
>> +              se_sess->tpt_id->name, se_sess->sid);
>> +    if (ret) {
>> +        pr_err("Could not add session%d to sysfs. Error %d.\n",
>> +               se_sess->sid, ret);
>> +        goto free_acl_name;
>> +    }
>> +
>> +    ret = add_transport_id_attrs(se_sess);
>> +    if (ret)
>> +        goto del_kobj;
>> +
>> +    if (se_sess->tfo->session_attrs) {
>> +        ret = sysfs_create_group(&se_sess->kobj,
>> +                     se_sess->tfo->session_attrs);
>> +        if (ret)
>> +            goto rm_tpt_id_grps;
>> +    }
>> +
>> +    ret = sysfs_create_link(tcm_core_sessions_kobj, &se_sess->kobj,
>> +                se_sess->kobj.name);
> 
> I would prefer to have links named "session-%d" or "%d" only, of course
> with se_sess->sid as the value for '%d'.

Isn't se_sess->sid a property that is filled in by the iSCSI target
driver only? Is se_sess->sid zero for all other target drivers than the
iSCSI target driver?

> If userspace knows the session-id only, such names make it easier to
> find the corresponding link.

Personally I prefer the %s-%d naming scheme. I think that naming scheme
has the following advantages:
1. No need to run cat ... to retrieve the initiator name.
2. It becomes possible to derive from the 'ls' output which initiators
created multiple sessions.
3. All sessions created by the same initiator appear consecutively.

Thanks,

Bart.
