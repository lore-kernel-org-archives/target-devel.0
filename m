From: "Ly, Bryant" <bly@catalogicsoftware.com>
Date: Tue, 18 Sep 2018 00:37:11 +0000
Subject: Re: [PATCHv3 1/2] scsi: ibmvscsis: Fix a stringop-overflow warning
Message-Id: <B86907DE-444B-498D-A402-78190A5A402B@catalogicsoftware.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180911192226.3620-1-labbott@redhat.com>
 <20180911192226.3620-2-labbott@redhat.com>
In-Reply-To: <20180911192226.3620-2-labbott@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Laura Abbott <labbott@redhat.com>
Cc: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>, Michael Cyr <mikecyr@linux.vnet.ibm.com>, Kees Cook <keescook@chromium.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>



> On Sep 11, 2018, at 2:22 PM, Laura Abbott <labbott@redhat.com> wrote:
> 
> There's currently a warning about string overflow with strncat:
> 
> drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c: In function 'ibmvscsis_probe':
> drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c:3479:2: error: 'strncat' specified
> bound 64 equals destination size [-Werror=stringop-overflow=]
>  strncat(vscsi->eye, vdev->name, MAX_EYE);
>  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Switch to a single snprintf instead of a strcpy + strcat to handle this
> cleanly.
> 
> Signed-off-by: Laura Abbott <labbott@redhat.com>
> ---
> v3: Make sure there is an extra space in the partition name
> ---
> drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 3 +--
> 1 file changed, 1 insertion(+), 2 deletions(-)
> 

Reviewed-by: Bryant G. Ly bly@catalogicsoftware.com

I sent a PR to update my email from bryantly@linux.vnet.ibm.com a week ago.

-Bryant
