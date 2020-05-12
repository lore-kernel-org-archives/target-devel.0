From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Tue, 12 May 2020 03:28:27 +0000
Subject: Re: [PATCH] target: loopback: fix READ with data and sensebytes
Message-Id: <158925392373.17325.9006412341355835743.b4-ty@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200428182617.32726-1-bstroesser@ts.fujitsu.com>
In-Reply-To: <20200428182617.32726-1-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: nab@linux-iscsi.org, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Bodo Stroesser <bstroesser@ts.fujitsu.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>

On Tue, 28 Apr 2020 20:26:17 +0200, Bodo Stroesser wrote:

> We use tcm_loop with tape emulations running on tcmu.
> In case application reads a short tape block with a longer READ,
> or a long tape block with a short READ, according to SCC spec
> data has to be tranferred _and_ sensebytes with ILI set and
> information field containing the residual count.
> Similar problem also exists when using fixed block size in READ.
> 
> [...]

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: target: loopback: Fix READ with data and sensebytes
      https://git.kernel.org/mkp/scsi/c/c68a56736c12

-- 
Martin K. Petersen	Oracle Linux Engineering
