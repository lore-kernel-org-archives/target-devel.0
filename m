From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Tue, 05 Feb 2019 02:18:41 +0000
Subject: Re: [PATCH] target: make the pi_prot_format ConfigFS path readable
Message-Id: <yq1k1if3rlq.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20190204183210.8386-1-ddiss@suse.de>
In-Reply-To: <20190204183210.8386-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org


David,

> pi_prot_format conversion to write-only caused userspace
> breakage. Make the ConfigFS path readable again and hardcode the "0\n"
> content, matching previous output.

Applied to 5.0/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
