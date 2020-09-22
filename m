From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Tue, 22 Sep 2020 21:32:38 +0000
Subject: Re: [PATCH 0/3] target: scsi: tcmu: code rework and speed up of read data handling
Message-Id: <yq1h7rppkfc.fsf@ca-mkp.ca.oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200910155041.17654-1-bstroesser@ts.fujitsu.com>
In-Reply-To: <20200910155041.17654-1-bstroesser@ts.fujitsu.com> (Bodo
        Stroesser's message of "Thu, 10 Sep 2020 17:50:38 +0200")
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Christie <michael.christie@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org


Bodo,

> The patches simplify some code, splits off new helper functions or
> implement a cleaner code sequence to prevent double work.  The 3rd
> patch speeds up buffer preparation for SCSI commands with long read
> data.

Applied to 5.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
