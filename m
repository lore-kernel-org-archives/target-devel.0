From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Fri, 27 Mar 2020 01:56:44 +0000
Subject: Re: [PATCH] scsi: target: core: add task tag to trace events
Message-Id: <yq17dz6ftlv.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <226e01deaa9baf46d6ff3b8698bc9fe881f7dfc1.camel@dubeyko.com>
In-Reply-To: <226e01deaa9baf46d6ff3b8698bc9fe881f7dfc1.camel@dubeyko.com>
        (Viacheslav Dubeyko's message of "Mon, 16 Mar 2020 16:07:17 +0300")
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, linux@yadro.com, v.dubeiko@yadro.com, rostedt@goodmis.org, mingo@redhat.com, r.bolshakov@yadro.com, k.shelekhin@yadro.com


Viacheslav,

> However, it's still hard to identify command on the initiator and
> command on the target in the real life output of system log.  For that
> purpose SCSI provides a command identifier or task tag (term used in
> previous standards). This patch adds tag ID in the system log's
> output:

Applied to 5.7/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
