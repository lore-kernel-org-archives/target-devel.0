From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Thu, 19 Dec 2019 23:45:17 +0000
Subject: Re: [PATCH] scsi: libfc: remove unnecessary assertion on ep variable
Message-Id: <yq18sn7c22a.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20191217212214.30722-1-pakki001@umn.edu>
In-Reply-To: <20191217212214.30722-1-pakki001@umn.edu> (Aditya Pakki's message
        of "Tue, 17 Dec 2019 15:22:13 -0600")
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aditya Pakki <pakki001@umn.edu>
Cc: kjlu@umn.edu, "Martin K. Petersen" <martin.petersen@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ira Weiny <ira.weiny@intel.com>, Allison Randal <allison@lohutok.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org


Aditya,

> In ft_recv_write_data(), the pointer ep is dereferenced first and
> then asserts for NULL. The patch removes the unnecessary assertion.

Applied to 5.6/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
