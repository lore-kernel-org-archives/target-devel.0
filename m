From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Date: Mon, 06 Nov 2017 16:25:49 +0000
Subject: Re: [PATCH] iSCSI-target: Use common error handling code in iscsi_decode_text_input()
Message-Id: <20171106162549.5b2511db@alans-desktop>
List-Id: <target-devel.vger.kernel.org>
References: <d36d5072-3e35-da39-bc0f-af15deb630a8@users.sourceforge.net>
In-Reply-To: <d36d5072-3e35-da39-bc0f-af15deb630a8@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Arun Easi <arun.easi@cavium.com>, Bart Van Assche <bart.vanassche@sandisk.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org

On Fri, 3 Nov 2017 22:33:08 +0100
SF Markus Elfring <elfring@users.sourceforge.net> wrote:

> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Fri, 3 Nov 2017 22:20:38 +0100
> 
> Add a jump target so that a bit of exception handling can be better reused
> at the end of this function.

Why not look at what the C compiler generates before making the code less
readable ?

Alan
