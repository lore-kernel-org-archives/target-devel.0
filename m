From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Tue, 02 Jul 2019 20:41:05 +0000
Subject: Re: [PATCH V2] iscsi: set auth_protocol back to NULL if CHAP_A value is not supported.
Message-Id: <yq1lfxgf9um.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20190626172734.20751-1-mlombard@redhat.com>
In-Reply-To: <20190626172734.20751-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org


Maurizio,

> If the CHAP_A value is not supported, the chap_server_open() function
> should free the auth_protocol pointer and set it to NULL, or we will
> leave a dangling pointer around.

Applied to 5.2/scsi-fixes. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
