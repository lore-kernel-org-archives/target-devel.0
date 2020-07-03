From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Date: Fri, 03 Jul 2020 16:57:10 +0000
Subject: Re: [RFC PATCH 10/10] target: export sessions via configfs
Message-Id: <2e70df6e-560f-590f-721c-2532f7af3d50@ts.fujitsu.com>
List-Id: <target-devel.vger.kernel.org>
References: <1593232509-13720-1-git-send-email-michael.christie@oracle.com>
 <1593232509-13720-11-git-send-email-michael.christie@oracle.com>
 <24118898-006c-0538-6685-b4902f9eee48@ts.fujitsu.com>
 <8e557b7a-aebc-7b3c-d02f-637cff0fd4b9@oracle.com>
In-Reply-To: <8e557b7a-aebc-7b3c-d02f-637cff0fd4b9@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Christie <michael.christie@oracle.com>, hare@suse.de, bvanassche@acm.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 2020-07-03 18:27, Mike Christie wrote:
> On 7/3/20 7:51 AM, Bodo Stroesser wrote:
>> On 2020-06-27 06:35, Mike Christie wrote:
>>> This patch exports the LIO sessions via configfs. If userspace makes
>>> a "sessions" dir on the ACL or TPG dir to indicate to the kernel it
>>> supports the new interface on that TPG, then the kernel will make a
>>> dir per session in the tpg/sessions or tpg/acls/alc/sessions dir
>>
>> I someone creates a new ACL on a running tpg, can it happen that a
>> session already is created before user can create the sessions folder?
> 
> Right now yes. In the patch I started to try to support a per tpg mix. If a session exists then you do mkdir sessions, then before you can delete the tpg you have to delete the sessions that were created after the mkdir.
> 
> But to handle all the side cases, it becomes a pain, and I don't think anyone will ever use that feature, so I plan to make it either on or off for all sessions on the tpg and no mixing. I think normally we see different tools at the per target or per fabric level, so we should be ok.

Maybe I don't get it. What I meant is:

Creation of the "sessions" folders in tpg and acl has to be done by
user.
If user creates a new acl while tpg is active, the acl immediately
becomes active, I think.
If user then creates the "sessions" folder, it could happen that
a session already is started meanwhile. That session would be
invisible then.
Maybe an "enable" attr for acl would help?

.....

> No. It works the same as today. When you do a tpg removal like when you do
> 
> targetlci clearconfig
> 
> rtslib disables the tpg which prevents the target from creating new sessions. We then bring down the objects under it like luns, portals, etc. When we get to sessions, if the target has not yet brought them down (some targets do this on tpg disablement and some do not), then with that github patch rtslib will kill them like it does for the other objects.
> 

Ahh, I see.




Let me resend another part of my response, that was far down:

>   }
>   +int target_cfgfs_register_session(struct se_portal_group *se_tpg,
> +                  struct se_session *se_sess)
> +{
> +    struct se_node_acl *se_nacl;
> +    int ret;
> +
> +    /*
> +     * If the fabric doesn't support close_session, there's no way for
> +     * userspace to clean up the session during nacl/tpg deletion.
> +     */
> +    if (!se_tpg->cfgfs_sess_supp || !se_tpg->se_tpg_tfo->close_session)
> +        return 0;

Why is the cfgfs_sess_supp flag per tpg? It seems to be set if either
tpg/sessions or any acl/sessions folder is created.
So what will happen here if e.g session for an acl is created while
only tpg/sessions exists?
Do we need an similar flag per acl also?
And if we have a per acl and the tpg flag I think they should be removed
when user removes an empty sessions folder.

> +
> +    se_nacl = se_sess->se_node_acl;
> +    if (se_nacl->dynamic_node_acl) {
> +        ret = configfs_register_group(&se_tpg->tpg_sess_group,
> +                          &se_sess->group);
> +    } else {
> +        ret = configfs_register_group(&se_nacl->acl_sess_group,
> +                          &se_sess->group);
> +    }
> +    if (ret)
> +        goto fail;

Do we have a possible race here? I think it would be better to first
call target_depend_item() and then register the new session's group.

> +
> +    /*
> +     * The session is not created via a mkdir like other objects. A
> +     * transport event like a login or userspace used the nexus file to
> +     * initiate creation. However, we want the same behavior as other
> +     * objects where we must remove the children before removing the
> +     * parent dir, so do a depend on the parent that is released when the
> +     * session is removed.
> +     */
> +    if (se_nacl->dynamic_node_acl) {
> +        ret = target_depend_item(&se_tpg->tpg_sess_group.cg_item);
> +    } else {
> +        ret = target_depend_item(&se_nacl->acl_sess_group.cg_item);
> +    }
> +    if (ret)
> +        goto unreg_cfgfs;
> +
> +    se_sess->added_to_cfgfs = true;
> +    return 0;
