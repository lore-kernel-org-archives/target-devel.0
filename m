From: Bryant Ly <bryant.ly@me.com>
Date: Tue, 18 Sep 2018 00:38:17 +0000
Subject: Re: [PATCHv2 2/2] scsi: ibmvscsis: Ensure partition name is properly NUL terminated
Message-Id: <8E56DEE3-6A6D-49E5-81D0-0E26CDBC28A6@me.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180911192226.3620-1-labbott@redhat.com>
 <20180911192226.3620-3-labbott@redhat.com>
In-Reply-To: <20180911192226.3620-3-labbott@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Laura Abbott <labbott@redhat.com>
Cc: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>, Michael Cyr <mikecyr@linux.vnet.ibm.com>, Kees Cook <keescook@chromium.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org



> On Sep 11, 2018, at 2:22 PM, Laura Abbott <labbott@redhat.com> wrote:
> 
> While reviewing another part of the code, Kees noticed that the
> strncpy of the partition name might not always be NUL terminated. Switch
> to using strscpy which does this safely.
> 
> Reported-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Laura Abbott <labbott@redhat.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> ---
> v2: Switch to strscpy instead of just strlcpy
> ---
> drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 

Reviewed-by: Bryant G. Ly bly@catalogicsoftware.com

I sent a PR to update my email from bryantly@linux.vnet.ibm.com a week ago.

-Bryant
