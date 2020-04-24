From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Fri, 24 Apr 2020 18:15:53 +0000
Subject: Re: [PATCH] target: iscsi: remove the iscsi_data_count structure
Message-Id: <yq1imhoda1y.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200424113913.17237-1-mlombard@redhat.com>
In-Reply-To: <20200424113913.17237-1-mlombard@redhat.com> (Maurizio Lombardi's
        message of "Fri, 24 Apr 2020 13:39:13 +0200")
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org


Maurizio,

> This patch removes the iscsi_data_count structure and the
> iscsit_do_rx_data() function because they are used only by rx_data()

Applied to 5.8/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
