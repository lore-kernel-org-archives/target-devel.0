From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Mon, 26 Oct 2020 22:29:45 +0000
Subject: Re: [PATCH v2] scsi: target: tcmu: scatter_/gather_data_area rework
Message-Id: <yq1eelk7hbp.fsf@ca-mkp.ca.oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20201019115118.11949-1-bostroesser@gmail.com>
In-Reply-To: <20201019115118.11949-1-bostroesser@gmail.com> (Bodo Stroesser's
        message of "Mon, 19 Oct 2020 13:51:18 +0200")
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bodo Stroesser <bostroesser@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Christie <michael.christie@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org


Bodo,

> This is made on top of the scsi-staging tree plus my previous
> patch:
> "scsi: target: tcmu: add compat mode for 32bit userspace on 64bit
> kernel"

Make sure to put all commentary below ---. Otherwise the tooling gets
confused about what goes in the commit message.

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
