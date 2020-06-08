From: Mike Christie <michael.christie@oracle.com>
Date: Mon, 08 Jun 2020 15:21:15 +0000
Subject: Re: [PATCH 11/17] target: add session sysfs class support
Message-Id: <75aa23e1-2194-31fb-ef12-90f868e12494@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
 <1591562164-9766-12-git-send-email-michael.christie@oracle.com>
 <f0bd2a33-c084-6c9b-faa1-9d92bdb2df7a@suse.de>
In-Reply-To: <f0bd2a33-c084-6c9b-faa1-9d92bdb2df7a@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Hannes Reinecke <hare@suse.de>, bvanassche@acm.org, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

On 6/8/20 1:14 AM, Hannes Reinecke wrote:
>> +    se_sess->target_name = 
>> kstrdup(se_tpg->se_tpg_wwn->wwn_group.cg_item.ci_name,
>> +                       GFP_KERNEL);
>> +    if (!se_sess->target_name)
>> +        goto free_acl;
>> +
>> +    if (se_sess->tfo->fabric_alias)
>> +        se_sess->fabric_name = kstrdup(se_sess->tfo->fabric_alias,
>> +                           GFP_KERNEL);
>> +    else
>> +        se_sess->fabric_name = kstrdup(se_sess->tfo->fabric_name,
>> +                           GFP_KERNEL);
>> +    if (!se_sess->fabric_name)
>> +        goto free_target;
>> +
>> +    se_sess->tpg_name = kstrdup(se_tpg->tpg_group.cg_item.ci_name,
>> +                    GFP_KERNEL);
>> +    if (!se_sess->tpg_name)
>> +        goto free_fabric;
>> +
>> +    return 0;
> 
> I wonder if we need to copy these variables.
> Why can't we display them directly, returning an error if the respective
> link is not available?
> If one is worried about the sysfs/configfs reference counting we can get 
> the reference in the _show() functions; wouldn't that be a better solution?

Do you mean in the sysfs show function do a configfs_depend_item() on 
the tpg, www, acl, etc? If so, I'm not sure that's safe, because for the 
tpg for example, we could do:

1. Userspace starts tpg removal with a rmdir.
2. Userspace also opens sysfs session file and has a ref to the session, 
but not the tpg yet.
3. kernel tears down tpg and sessions under it. The tpg is freed. The 
session is not because of the ref taken in #2.
4. sysfs session show function starts to reference se_sess->se_tpg so it 
can do a configfs_depend_item on the tpg_group.cg_item, but the se_tpg 
is freed in #3.

We either need to:
1. cp like above.
2. Handle both configfs and device struct refcounts for the same struct. 
So add a device struct to the www, tpg, acl and then coordinate the 
refcounting.
3. take a reference to the se_tpg when the session is created then drop 
it in the session release.
4. add some code and end up mix locking and state checks with refcounts. 
For example the tpg would have its configfs refcount like it does today 
(no new device struct in it), and when it deletes the sessions under it 
make sure the se_sess->se_tpg is NULL'd in a way that the session show 
function can do

lock()
if (!se_sess->se_tpg)
	return

se_sess->se_tpg access
unlock()

And then you have to do that up the stack for the other structs we want 
to ref.
