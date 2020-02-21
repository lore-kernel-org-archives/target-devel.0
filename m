From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Fri, 21 Feb 2020 22:40:28 +0000
Subject: Re: [PATCH] scsi: target: use an enum to track emulate_ua_intlck_ctrl
Message-Id: <yq136b3tvhf.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200221094401.32021-1-ddiss@suse.de>
In-Reply-To: <20200221094401.32021-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org


David,

> The emulate_ua_intlck_ctrl device attribute accepts values of 0, 1 or 2
> via ConfigFS, which map to unit attention interlocks control codes in
> the MODE SENSE control Mode Page.
> Use an enum to track these values so that it's clear that, unlike the
> remaining emulate_X attributes, emulate_ua_intlck_ctrl isn't boolean.

Applied to 5.7/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
