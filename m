From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Fri, 02 Oct 2020 22:41:06 +0000
Subject: Re: [PATCH] scsi: target: core: Add CONTROL field for trace events
Message-Id: <yq11rigfdza.fsf@ca-mkp.ca.oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200929125957.83069-1-r.bolshakov@yadro.com>
In-Reply-To: <20200929125957.83069-1-r.bolshakov@yadro.com> (Roman Bolshakov's
        message of "Tue, 29 Sep 2020 15:59:57 +0300")
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Bolshakov <r.bolshakov@yadro.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, linux@yadro.com


Roman,

> trace-cmd report doesn't show events from target subsystem because
> scsi_command_size() leaks through event format string:

Applied to 5.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
