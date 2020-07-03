From: Bart Van Assche <bvanassche@acm.org>
Date: Fri, 03 Jul 2020 17:37:42 +0000
Subject: Re: [RFC PATCH 00/10] target: add configfs interface
Message-Id: <0b59d643-61bf-6876-cc42-83ee8040da10@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <1593232509-13720-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1593232509-13720-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Christie <michael.christie@oracle.com>, hare@suse.de, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 2020-06-26 21:34, Mike Christie wrote:
> With Hannes not liking the refcounting/tricks in the sysfs approach
> I took another stab at configfs. This approach works similar to the
> loop/vhost/usb/xen nexus interface where there is a special file
> that allows userspace to add/remove sessions.

Hi Mike,

Are you perhaps referring to the comment in the following message?
https://lore.kernel.org/linux-scsi/f0bd2a33-c084-6c9b-faa1-9d92bdb2df7a@suse.de/
The duplication of strings in that patch also looks weird to me.
I think kobject_del() waits for ongoing sysfs show and store callbacks to finish.
Since patch 12/15 adds a kobject_del() call in target_sysfs_remove_session(), is
that call perhaps sufficient to guarantee that the
se_sess->se_node_acl->initiatorname pointer and similar pointers are all valid
at least as long the session sysfs object exists?

Thanks,

Bart.
