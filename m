From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Thu, 05 Nov 2020 03:03:20 +0000
Subject: Re: [PATCH v4 0/4] scsi: target: COMPARE AND WRITE miscompare sense
Message-Id: <yq1blgctsi5.fsf@ca-mkp.ca.oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20201031233211.5207-1-ddiss@suse.de>
In-Reply-To: <20201031233211.5207-1-ddiss@suse.de> (David Disseldorp's message
        of "Sun, 1 Nov 2020 00:32:07 +0100")
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Disseldorp <ddiss@suse.de>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org


David,

> This patchset adds missing functionality to return the offset of
> non-matching read/compare data in the sense INFORMATION field on
> COMPARE AND WRITE miscompare.

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
