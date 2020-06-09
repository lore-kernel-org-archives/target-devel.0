From: Michael Christie <michael.christie@oracle.com>
Date: Tue, 09 Jun 2020 03:10:52 +0000
Subject: Re: [PATCH 11/17] target: add session sysfs class support
Message-Id: <3B8F389C-A12D-4222-863F-6A656AF4680F@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
 <1591562164-9766-12-git-send-email-michael.christie@oracle.com>
 <f0bd2a33-c084-6c9b-faa1-9d92bdb2df7a@suse.de>
 <75aa23e1-2194-31fb-ef12-90f868e12494@oracle.com>
 <7598A2AE-B43F-41BB-82E0-8882FA7D66E0@oracle.com>
In-Reply-To: <7598A2AE-B43F-41BB-82E0-8882FA7D66E0@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hannes Reinecke <hare@suse.de>, bvanassche@acm.org, bstroesser@ts.fujitsu.com, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>



> On Jun 8, 2020, at 10:55 AM, Michael Christie <michael.christie@oracle.com> wrote:
> 
> 
> 
>> On Jun 8, 2020, at 10:21 AM, Mike Christie <michael.christie@oracle.com> wrote:
>> 
>> On 6/8/20 1:14 AM, Hannes Reinecke wrote:
>>>> +    se_sess->target_name = kstrdup(se_tpg->se_tpg_wwn->wwn_group.cg_item.ci_name,
>>>> +                       GFP_KERNEL);
>>>> +    if (!se_sess->target_name)
>>>> +        goto free_acl;
>>>> +
>>>> +    if (se_sess->tfo->fabric_alias)
>>>> +        se_sess->fabric_name = kstrdup(se_sess->tfo->fabric_alias,
>>>> +                           GFP_KERNEL);
>>>> +    else
>>>> +        se_sess->fabric_name = kstrdup(se_sess->tfo->fabric_name,
>>>> +                           GFP_KERNEL);
>>>> +    if (!se_sess->fabric_name)
>>>> +        goto free_target;
>>>> +
>>>> +    se_sess->tpg_name = kstrdup(se_tpg->tpg_group.cg_item.ci_name,
>>>> +                    GFP_KERNEL);
>>>> +    if (!se_sess->tpg_name)
>>>> +        goto free_fabric;
>>>> +
>>>> +    return 0;
>>> I wonder if we need to copy these variables.
>>> Why can't we display them directly, returning an error if the respective
>>> link is not available?
>>> If one is worried about the sysfs/configfs reference counting we can get the reference in the _show() functions; wouldn't that be a better solution?
>> 
>> Do you mean in the sysfs show function do a configfs_depend_item() on the tpg, www, acl, etc? If so, I'm not sure that's safe, because for the tpg for example, we could do:
>> 
>> 1. Userspace starts tpg removal with a rmdir.
>> 2. Userspace also opens sysfs session file and has a ref to the session, but not the tpg yet.
>> 3. kernel tears down tpg and sessions under it. The tpg is freed. The session is not because of the ref taken in #2.
>> 4. sysfs session show function starts to reference se_sess->se_tpg so it can do a configfs_depend_item on the tpg_group.cg_item, but the se_tpg is freed in #3.
>> 
>> We either need to:
>> 1. cp like above.
>> 2. Handle both configfs and device struct refcounts for the same struct. So add a device struct to the www, tpg, acl and then coordinate the refcounting.
>> 3. take a reference to the se_tpg when the session is created then drop it in the session release.
> 
> 
> Ignore #3. That does not work. Userspace expects to be able to rmdir on a tpg and that will remove the underlying sessions. If the session takes a ref to the tpg, then it breaks userspace because something now has to do the session removal before the tpg rmdir.
> 

I was thinking about this some more and we could do the following:

1. When userspace creates a target or tpg, it tells the kernel if it supports the updated session interface.
2. If userspace supports it, when we create a session we get a reference to the tpg with configfs_depend_item(). And create the sysfs interface. We might actually be able to do confifgfs.
3. On tpg deletion, if at #1 it has told us it supports the new interface then userspace just has to tear down the sessions by doing a rmdir on the sessions if we do configfs or write to some new delete file if we use sysfs.
