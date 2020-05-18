From: Mike Christie <mchristi@redhat.com>
Date: Mon, 18 May 2020 19:39:38 +0000
Subject: Re: [PATCH v2] scsi: target: tcmu: userspace must not complete queued commands
Message-Id: <cbc8d169-2bf0-34ed-ccd7-e4a6f74260e7@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200518164833.12775-1-bstroesser@ts.fujitsu.com>
In-Reply-To: <20200518164833.12775-1-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bodo Stroesser <bstroesser@ts.fujitsu.com>, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 5/18/20 11:48 AM, Bodo Stroesser wrote:
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
> To fix this bug, we no longer add queued commands to the idr.
> Instead the cmd_id is assign when a command is written to
> the command ring.
> 
> Due to this change I had to adapt the source code at several
> places where up to now an idr_for_each had been done.
> 
> Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>

Acked-by: Mike Christie <mchristi@redhat.com>
