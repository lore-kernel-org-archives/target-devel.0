From: Maurizio Lombardi <mlombard@redhat.com>
Date: Sat, 03 Oct 2020 07:46:39 +0000
Subject: Re: [PATCH] Revert "scsi: target/iscsi: Detect conn_cmd_list corruption early"
Message-Id: <fea1f8a6-615e-6d44-ec20-b4f46da10d55@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20201002073341.12470-1-mlombard@redhat.com>
 <ce44115e-f8ac-0307-88bd-f6a2e9d7f7f3@acm.org>
In-Reply-To: <ce44115e-f8ac-0307-88bd-f6a2e9d7f7f3@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bart Van Assche <bvanassche@acm.org>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org



Dne 03. 10. 20 v 2:23 Bart Van Assche napsal(a):
> Hi Maurizio,
> 
> I agree that the same WARN_ON() occurs inside __iscsit_free_cmd(). What is not
> clear to me is how removing the WARN_ON() statement from iscsit_free_cmd() can
> help since an identical statement occurs inside __iscsit_free_cmd()?


It doesn't help indeed, this patch just removes one duplicate warning but doesn't
really change anything.

The bug I am trying to fix will need a different patch to prevent the race condition.

Maurizio
