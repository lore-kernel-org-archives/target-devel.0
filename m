From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Mon, 13 Apr 2020 18:03:40 +0000
Subject: Re: [PATCH] target: tcmu: reset_ring should reset TCMU_DEV_BIT_BROKEN
Message-Id: <yq1ftd7xnyb.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200409101026.17872-1-bstroesser@ts.fujitsu.com>
In-Reply-To: <20200409101026.17872-1-bstroesser@ts.fujitsu.com> (Bodo
        Stroesser's message of "Thu, 9 Apr 2020 12:10:26 +0200")
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, mchristi@redhat.com, martin.petersen@oracle.com


Bodo,

> In case command ring buffer becomes inconsistent, tcmu sets device
> flag TCMU_DEV_BIT_BROKEN.  If the bit is set, tcmu rejects new
> commands from lio core with TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE,
> and no longer processes completions from the ring.  The reset_ring
> attribute can be used to completely clean up the command ring, so
> after reset_ring the ring no longer is inconsistent.
>
> Therefore reset_ring also should reset bit TCMU_DEV_BIT_BROKEN to
> allow normal processing.

Applied to 5.7/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
