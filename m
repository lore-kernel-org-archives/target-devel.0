From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Fri, 30 Oct 2020 02:06:00 +0000
Subject: Re: [PATCH v2 0/5] scsi: target: COMPARE AND WRITE miscompare sense
Message-Id: <yq15z6s1n9n.fsf@ca-mkp.ca.oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20201026190646.8727-1-ddiss@suse.de>
        <yq1blgk1nfx.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1blgk1nfx.fsf@ca-mkp.ca.oracle.com> (Martin K. Petersen's
        message of "Thu, 29 Oct 2020 22:02:08 -0400")
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Disseldorp <ddiss@suse.de>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org


>> This patchset adds missing functionality to return the offset of
>> non-matching read/compare data in the sense INFORMATION field on
>> COMPARE AND WRITE miscompare.
>
> Applied 2-5 to 5.11/scsi-staging, thanks!

Dropped again, breaks IB.

-- 
Martin K. Petersen	Oracle Linux Engineering
