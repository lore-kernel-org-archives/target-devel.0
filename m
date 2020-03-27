From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Fri, 27 Mar 2020 17:49:52 +0000
Subject: Re: [PATCH v3 0/5] scsi: target: XCOPY performance
Message-Id: <yq11rpdbscf.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200327141954.955-1-ddiss@suse.de>
In-Reply-To: <20200327141954.955-1-ddiss@suse.de> (David Disseldorp's message
        of "Fri, 27 Mar 2020 15:19:49 +0100")
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Disseldorp <ddiss@suse.de>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, bvanassche@acm.org


David,

> These changes remove unnecessary heap allocations in the XCOPY
> READ/WRITE dispatch loop.
>
> Synthetic benchmarks on my laptop using the libiscsi iscsi-dd utility
> (--xcopy --max 1 --blocks 65535 src=dst) against a target backed by an
> 8G zram (DEBUG_KMEMLEAK=y) iblock backstore (avg across four runs) show:
> before: 5.30845G/s
> after:  5.99056G/s (approx. +12.8%)

Applied to 5.7/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
