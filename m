From: Chris Boot <bootc@boo.tc>
Date: Sun, 10 Dec 2017 21:51:07 +0000
Subject: Re: [PATCH] sbp-target: Delete an error message for a failed memory allocation in three functions
Message-Id: <e482cc36-285c-4402-7cbf-a335428a5710@boo.tc>
List-Id: <target-devel.vger.kernel.org>
References: <06164454-67a9-d206-647c-b70f4a1c3812@users.sourceforge.net>
In-Reply-To: <06164454-67a9-d206-647c-b70f4a1c3812@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: SF Markus Elfring <elfring@users.sourceforge.net>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net, Chris Boot <bootc@bootc.net>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org

On 10/12/2017 19:10, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sun, 10 Dec 2017 19:54:11 +0100
> 
> Omit an extra message for a memory allocation failure in these functions.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
[snip]

Looks good to me.

Acked-by: Chris Boot <bootc@boo.tc>

Thanks,
Chris

-- 
Chris Boot
bootc@boo.tc
