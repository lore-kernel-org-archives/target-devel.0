From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Sat, 08 Dec 2018 02:55:19 +0000
Subject: Re: [PATCH v7 0/5] target: user configurable T10 Vendor ID
Message-Id: <yq14lbon2w8.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20181205121838.23982-1-ddiss@suse.de>
In-Reply-To: <20181205121838.23982-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org


David,

> This patch-set allows for the modification of the T10 Vendor
> Identification string returned in the SCSI INQUIRY response, via the
> target/core/$backstore/$name/wwn/vendor_id ConfigFS path.

Applied to 4.21/scsi-queue, thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
