From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Thu, 05 Nov 2020 04:21:43 +0000
Subject: Re: [PATCH 1/2] libfc: move scsi/fc_encode.h to libfc
Message-Id: <160455005255.26277.5936613179662668851.b4-ty@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20201026160705.3706396-1-arnd@kernel.org>
In-Reply-To: <20201026160705.3706396-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hannes Reinecke <hare@suse.de>, "James E.J. Bottomley" <jejb@linux.ibm.com>, Arnd Bergmann <arnd@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, GR-QLogic-Storage-Upstream@marvell.com, target-devel@vger.kernel.org, "Gustavo A. R. Silva" <gustavoars@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Lee Jones <lee.jones@linaro.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Javed Hasan <jhasan@marvell.com>, Saurav Kashyap <skashyap@marvell.com>

On Mon, 26 Oct 2020 17:06:12 +0100, Arnd Bergmann wrote:

> Most of this file is only used inside of libfc, so move
> it to where it is actually used, with only fc_fill_fc_hdr()
> left inside of the header.

Applied to 5.11/scsi-queue, thanks!

[1/2] scsi: libfc: Move scsi/fc_encode.h to libfc
      https://git.kernel.org/mkp/scsi/c/e31ac898ac29
[2/2] scsi: libfc: Work around -Warray-bounds warning
      https://git.kernel.org/mkp/scsi/c/8fd9efca86d0

-- 
Martin K. Petersen	Oracle Linux Engineering
