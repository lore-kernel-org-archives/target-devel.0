From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Date: Mon, 06 Jul 2020 12:32:42 +0000
Subject: Re: [RFC PATCH 10/10] target: export sessions via configfs
Message-Id: <2dc8a518-01c8-fa28-dac5-3fe0162d2f62@ts.fujitsu.com>
List-Id: <target-devel.vger.kernel.org>
References: <1593232509-13720-1-git-send-email-michael.christie@oracle.com>
 <1593232509-13720-11-git-send-email-michael.christie@oracle.com>
 <24118898-006c-0538-6685-b4902f9eee48@ts.fujitsu.com>
 <8e557b7a-aebc-7b3c-d02f-637cff0fd4b9@oracle.com>
 <2e70df6e-560f-590f-721c-2532f7af3d50@ts.fujitsu.com>
 <7642F0BE-2E98-47FA-B1B9-00CA083B6530@oracle.com>
In-Reply-To: <7642F0BE-2E98-47FA-B1B9-00CA083B6530@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Michael Christie <michael.christie@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, Bart Van Assche <bvanassche@acm.org>, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org



On 2020-07-03 23:19, Michael Christie wrote:

...

>> Why is the cfgfs_sess_supp flag per tpg? It seems to be set if either
>> tpg/sessions or any acl/sessions folder is created.
>> So what will happen here if e.g session for an acl is created while
>> only tpg/sessions exists?
> 
> Ah yeah, that is bogus. I am still working on an issue in this code. I wasn’t expecting a line by line and just a general review of cfgfs vs sysfs :) Sorry about that.
> 
> I originally made it so when we make the tpg and before it is enabled you had to do mkdir sessions on the tpg to signal the kernel that the app supports the new interface. The kernel would then make the acl sessions dir for you.
> 
> I was tracking down a bug in that though, and for the posting I made it so userspace had to create the acl sessions dir. While cutting and pasting the code I forgot to fix up that code.

Ah, ok. Please see below.
> 
> 
> 
>> Do we need an similar flag per acl also?
>> And if we have a per acl and the tpg flag I think they should be removed
>> when user removes an empty sessions folder.
> 
> It’s just a lot easier to leave it set if userspace has enabled it once. You actually need to take into account if the tpg is enabled, and then you have some issues with the drivers that have their own nexus interface, and then there are different userspace code paths that handle this.
> 
> I don’t think it’s going to be common to mix and match updated and non-updated tools, so once its set, it’s set. If you disagree let me know. It can be done.

I see no need for such a mix.

If it works like you described above - kernel creates acl/sessions dirs
after user created tpg/sessions - I think it is really fine.
