From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Fri, 30 Oct 2020 01:52:30 +0000
Subject: Re: [PATCH 1/2] libfc: move scsi/fc_encode.h to libfc
Message-Id: <yq1y2jo1nvx.fsf@ca-mkp.ca.oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20201026160705.3706396-1-arnd@kernel.org>
In-Reply-To: <20201026160705.3706396-1-arnd@kernel.org> (Arnd Bergmann's
        message of "Mon, 26 Oct 2020 17:06:12 +0100")
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Arnd Bergmann <arnd@kernel.org>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Arnd Bergmann <arnd@arndb.de>, Saurav Kashyap <skashyap@marvell.com>, Javed Hasan <jhasan@marvell.com>, GR-QLogic-Storage-Upstream@marvell.com, "Gustavo A. R. Silva" <gustavoars@kernel.org>, Lee Jones <lee.jones@linaro.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, target-devel@vger.kernel.org


Arnd,

> Most of this file is only used inside of libfc, so move it to where it
> is actually used, with only fc_fill_fc_hdr() left inside of the
> header.

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
