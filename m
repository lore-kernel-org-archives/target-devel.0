From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Wed, 26 Sep 2018 01:30:08 +0000
Subject: Re: [PATCH v2] scsi: target: iscsi: cxgbit: fix csk leak
Message-Id: <yq18t3pgi5b.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1537366497-4369-1-git-send-email-varun@chelsio.com>
In-Reply-To: <1537366497-4369-1-git-send-email-varun@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org


Varun,

> csk leak can happen if a new TCP connection gets established after
> cxgbit_accept_np() returns, to fix this leak free remaining csk in
> cxgbit_free_np().

Applied to 4.20/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
