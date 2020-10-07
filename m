From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Wed, 07 Oct 2020 03:48:00 +0000
Subject: Re: [PATCH] scsi: target: core: Add CONTROL field for trace events
Message-Id: <160204240573.16940.10978624159806052406.b4-ty@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200929125957.83069-1-r.bolshakov@yadro.com>
In-Reply-To: <20200929125957.83069-1-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Bolshakov <r.bolshakov@yadro.com>, target-devel@vger.kernel.org
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux@yadro.com

On Tue, 29 Sep 2020 15:59:57 +0300, Roman Bolshakov wrote:

> trace-cmd report doesn't show events from target subsystem because
> scsi_command_size() leaks through event format string:
> 
>   [target:target_sequencer_start] function scsi_command_size not defined
>   [target:target_cmd_complete] function scsi_command_size not defined
> 
> Addition of scsi_command_size() to plugin_scsi.c in trace-cmd doesn't
> help because an expression is used inside TP_printk(). trace-cmd event
> parser doesn't understand minus sign inside [ ]:
> 
> [...]

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: target: core: Add CONTROL field for trace events
      https://git.kernel.org/mkp/scsi/c/7010645ba725

-- 
Martin K. Petersen	Oracle Linux Engineering
