From: Mike Christie <michael.christie@oracle.com>
Date: Wed, 04 Nov 2020 22:26:33 +0000
Subject: [PATCH 00/11 V4] vhost: vhost-scsi bug fixes
Message-Id: <1604528804-2878-1-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com, stefanha@redhat.com, virtualization@lists.linux-foundation.org

The following patches made over Michael's vhost branch
https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/log/?h=vhost

The patches fix issues with vhost-scsi's 256 cmd limit
where if the guest sends more than 256 cmds it will get IO
errors, or even if exactly 256 are being sent then we can race and
get IO errors. The patches also add LUN RESET support so guests
that do not support resetting command timers will not get IO
errors and offlined devices when the physical device hits temp
issues.

Jason, you reviewed ever non scsi patch but 2 of them. I was not
sure if that was an oversight or you were ok with them. I'm sending
this out hoping you were ok with them and forgot to reply (or I guess
will be ok with them if you just missed them last time).

V4:
- really really fix compile errors
- dropped threading patches so we can figure that out separately.

V3:
- fix compile errors
- fix possible crash where cmd could be freed while adding it to
completion list
- fix issue where we added the worker thread to the blk cgroup but
the blk IO was submitted by a driver workqueue.

V2:
- fix use before set cpu var errors
- drop vhost_vq_is_setup
- include patches to do a worker thread per scsi IO vq
