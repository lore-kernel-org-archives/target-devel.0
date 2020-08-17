From: James Bottomley <jejb@linux.ibm.com>
Date: Mon, 17 Aug 2020 14:41:58 +0000
Subject: Re: [PATCH 0/8] scsi: convert tasklets to use new tasklet_setup()
Message-Id: <1597675318.4475.11.camel@linux.ibm.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200817085409.25268-1-allen.cryptic@gmail.com>
In-Reply-To: <20200817085409.25268-1-allen.cryptic@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Allen Pais <allen.cryptic@gmail.com>, martin.petersen@oracle.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com
Cc: keescook@chromium.org, linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, target-devel@vger.kernel.org, megaraidlinux.pdl@broadcom.com, Allen Pais <allen.lkml@gmail.com>

On Mon, 2020-08-17 at 14:24 +0530, Allen Pais wrote:
> From: Allen Pais <allen.lkml@gmail.com>
> 
> Commit 12cc923f1ccc ("tasklet: Introduce new initialization API")'
> introduced a new tasklet initialization API. This series converts 
> all the scsi drivers to use the new tasklet_setup() API

I've got to say I agree with Jens, this was a silly obfuscation:

+#define from_tasklet(var, callback_tasklet, tasklet_fieldname) \
+       container_of(callback_tasklet, typeof(*var), tasklet_fieldname)

Just use container_of directly since we all understand what it does.

James
