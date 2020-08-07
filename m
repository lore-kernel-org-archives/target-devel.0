From: Mike Christie <michael.christie@oracle.com>
Date: Fri, 07 Aug 2020 01:42:07 +0000
Subject: Re: [PATCH] scsi: target: loop: Fix handling of aborted TMRs
Message-Id: <61420558-b077-13ca-b5e3-6269fb419233@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200715160403.12578-1-bstroesser@ts.fujitsu.com>
 <795a006d-6d66-a635-7e76-601cb7807f5b@oracle.com>
 <2694d1fc-8792-0fe2-4dec-78f15d3b4ec5@ts.fujitsu.com>
 <90048ea8-3b8f-cc06-7869-dca645cd68f2@oracle.com>
 <7c2d8052-fb5e-0a3b-a894-df8bfab44f21@ts.fujitsu.com>
 <b8fc90b9-7038-b202-e7ef-bc4da56816f0@oracle.com>
In-Reply-To: <b8fc90b9-7038-b202-e7ef-bc4da56816f0@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bodo Stroesser <bstroesser@ts.fujitsu.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 7/27/20 1:13 PM, Mike Christie wrote:
> I would really like to figure out if #2 is a regression and understand what happened so we don't make the same mistake again and also fix iscsi. The problem with iscsi though is every couple kernels has a bug in this code path so git bisect is being a pain.

Sorry for the delay. I was able to track down the hang part of this. It turns out loop did work at some point. It worked a couple times over the years, but every X kernels we would break it again.

The last time we didn't have the hang was because we executed TMFs one at a time. We would end up always calling queue_tm_rsp since the LUN reset was always going to execute after the abort. So to fix the wake up / hang part of the bug for everyone we could revert:

commit db5b21a24e01d35495014076700efa02d6dcbb68
Author: Bart Van Assche <bvanassche@acm.org>
Date:   Tue Nov 27 15:51:59 2018 -0800

    scsi: target/core: Use system workqueues for TMF

It's not clear how much processing TMFs for the same device in parallel helps. If it doesn't help, this would be an easy fix for everyone.

One other thing that is not clear to me is if aborted_task was always meant to be used for task management requests. I think when it was first added, it was only called for normal cmds. I couldn't tell exactly when we meant (vs it snuck in by accident) to start calling it for all commands.

If the async TMF feature helps, then I'm ok with with your fix for loop where we say the aborted_task callout was meant for all commands and go from there. We then have to do something similar in xen, and check that the other drivers didn't expect the old behavior. I think for that qla2xxx bug you mentioned, tcm_qla2xxx_aborted_task didn't expect a qla_tgt_mgmt_cmd to be passed into aborted_task so it crashed trying to access it as a qla_tgt_cmd.

What do you think?
