From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Mon, 09 Dec 2019 23:36:44 +0000
Subject: Re: [PATCH v3 00/13] scsi: qla2xxx: Bug fixes
Message-Id: <yq1blshqdf7.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20191125165702.1013-1-r.bolshakov@yadro.com>
In-Reply-To: <20191125165702.1013-1-r.bolshakov@yadro.com> (Roman Bolshakov's
        message of "Mon, 25 Nov 2019 19:56:49 +0300")
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Bolshakov <r.bolshakov@yadro.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux@yadro.com


Roman,

> The patch series contains fixes for qla2xxx and solves two visible
> issues:
>   - Target port in N2N topology doesn't perform login if it has higher
>     WWPN than initiator
>   - ABORT TASK TMF leads to crash if it's received shortly after ACL of
>     an initiator is deleted and there's active I/O from the initiator

I was concerned about the churn in this series but the actual code
changes are mostly simple and to the point.

Applied to 5.5/scsi-fixes with a couple of checkpatch tweaks. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
