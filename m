From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Sat, 08 Dec 2018 02:26:13 +0000
Subject: Re: [PATCH v2 00/10] Make ABORT and LUN RESET handling synchronous
Message-Id: <yq1ftv8oit6.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20181127235204.186731-1-bvanassche@acm.org>
In-Reply-To: <20181127235204.186731-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org


Bart,

> This is a respin of the patch series that makes ABORT and LUN RESET
> handling synchronous. Compared to last time when this patch series was
> posted, the actual patch that makes task management function handling
> synchronous has been split into three patches. That makes the changes
> easier to follow.  Please consider this patch series for kernel v4.21.

Applied to 4.21/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
