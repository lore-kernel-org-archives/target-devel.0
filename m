From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Wed, 20 Nov 2019 03:02:21 +0000
Subject: Re: [PATCH] target: Fix a pr_debug() argument
Message-Id: <yq1lfsbfdxe.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20191107215525.64415-1-bvanassche@acm.org>
In-Reply-To: <20191107215525.64415-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org


Bart,

> With CONFIG_DYNAMIC_DEBUG=y, the output of pr_debug() statements is
> controlled by the settings in
> /sys/kernel/debug/dynamic_debug/control.

OK.

Applied to 5.5/scsi-queue, thanks.

-- 
Martin K. Petersen	Oracle Linux Engineering
