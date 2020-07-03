From: Michael Christie <michael.christie@oracle.com>
Date: Fri, 03 Jul 2020 22:12:26 +0000
Subject: Re: [RFC PATCH 00/10] target: add configfs interface
Message-Id: <16CCC5B0-A73C-44D3-A413-DBFE23989D26@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1593232509-13720-1-git-send-email-michael.christie@oracle.com>
 <0b59d643-61bf-6876-cc42-83ee8040da10@acm.org>
In-Reply-To: <0b59d643-61bf-6876-cc42-83ee8040da10@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Bart Van Assche <bvanassche@acm.org>
Cc: Hannes Reinecke <hare@suse.de>, Bodo Stroesser <bstroesser@ts.fujitsu.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org



> On Jul 3, 2020, at 12:37 PM, Bart Van Assche <bvanassche@acm.org> wrote:
> 
> On 2020-06-26 21:34, Mike Christie wrote:
>> With Hannes not liking the refcounting/tricks in the sysfs approach
>> I took another stab at configfs. This approach works similar to the
>> loop/vhost/usb/xen nexus interface where there is a special file
>> that allows userspace to add/remove sessions.
> 
> Hi Mike,
> 
> Are you perhaps referring to the comment in the following message?
> https://urldefense.com/v3/__https://lore.kernel.org/linux-scsi/f0bd2a33-c084-6c9b-faa1-9d92bdb2df7a@suse.de/__;!!GqivPVa7Brio!L7jRHXS-8N1S4DIyD7kLwn1WPta5_ANJgQpJrI-fdmRlub6ViFCvtW0VCqwhN37bZMtc$ 

Yes.

> The duplication of strings in that patch also looks weird to me.
> I think kobject_del() waits for ongoing sysfs show and store callbacks to finish.

Nice!

I didn’t know that. I added that free_session callback for that reason. When testing I was just verifying that the callback was called when all refs to the file had dropped and didn’t check that it was actually device_del.


> Since patch 12/15 adds a kobject_del() call in target_sysfs_remove_session(), is
> that call perhaps sufficient to guarantee that the

Yes. It’s doable. There might be an issue with one driver, but I can fix that up.


> se_sess->se_node_acl->initiatorname pointer and similar pointers are all valid
> at least as long the session sysfs object exists?
> 
> Thanks,
> 
> Bart.
