From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Thu, 07 Mar 2019 00:13:13 +0000
Subject: Re: [PATCH v1] scsi: tcmu: Switch to bitmap_zalloc()
Message-Id: <yq1lg1rwnhi.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20190304094434.57965-1-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20190304094434.57965-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org


Andy,

> Switch to bitmap_zalloc() to show clearly what we are allocating.
> Besides that it returns pointer of bitmap type instead of opaque void
> *.

Applied to 5.1/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
