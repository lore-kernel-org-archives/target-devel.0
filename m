From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Wed, 20 May 2020 02:30:01 +0000
Subject: Re: [PATCH v2] scsi: target: tcmu: userspace must not complete queued commands
Message-Id: <158994171818.20861.2092677585621625446.b4-ty@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200518164833.12775-1-bstroesser@ts.fujitsu.com>
In-Reply-To: <20200518164833.12775-1-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mchristi@redhat.com, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Bodo Stroesser <bstroesser@ts.fujitsu.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>

On Mon, 18 May 2020 18:48:33 +0200, Bodo Stroesser wrote:

> When tcmu queues a new command - no matter whether in command
> ring or in qfull_queue - a cmd_id from IDR udev->commands is
> assigned to the command.
> 
> If userspaces sends a wrong command completion containing the
> cmd_id of a command on the qfull_queue, tcmu_handle_completions()
> finds the command in the IDR and calls tcmu_handle_completion()
> for it. This might do some nasty things, because commands in
> qfull_queue do not have a valid dbi list.
> 
> [...]

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: target: tcmu: Userspace must not complete queued commands
      https://git.kernel.org/mkp/scsi/c/61fb24822166

PS. Please run checkpatch. Had to fix a bunch of whitespace errors.

-- 
Martin K. Petersen	Oracle Linux Engineering
