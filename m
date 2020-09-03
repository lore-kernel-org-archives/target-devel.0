From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Thu, 03 Sep 2020 03:01:05 +0000
Subject: Re: [PATCH] scsi: target: iscsi: Fix data digest calculation
Message-Id: <159910202092.23499.16081491903720380193.b4-ty@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1598358910-3052-1-git-send-email-varun@chelsio.com>
In-Reply-To: <1598358910-3052-1-git-send-email-varun@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Varun Prakash <varun@chelsio.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, bvanassche@acm.org, stable@vger.kernel.org, michael.christie@oracle.com, nab@linux-iscsi.org, target-devel@vger.kernel.org

On Tue, 25 Aug 2020 18:05:10 +0530, Varun Prakash wrote:

> Current code does not consider 'page_off' in data digest
> calculation, to fix this add a local variable 'first_sg' and
> set first_sg.offset to sg->offset + page_off.

Applied to 5.9/scsi-fixes, thanks!

[1/1] scsi: target: iscsi: Fix data digest calculation
      https://git.kernel.org/mkp/scsi/c/5528d03183fe

-- 
Martin K. Petersen	Oracle Linux Engineering
