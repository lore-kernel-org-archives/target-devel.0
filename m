From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Wed, 06 Mar 2019 17:37:16 +0000
Subject: Re: [PATCH] tcmu: wait for nl reply only if there are listeners or during an add
Message-Id: <yq1pnr3zyyb.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1549076481-15420-1-git-send-email-mchristi@redhat.com>
In-Reply-To: <1549076481-15420-1-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org


Cathy,

> genlmsg_multicast_allns now returns the correct statuses when a
> message is sent to a listener. However in the case of adding a
> device we want to wait for the listener otherwise we may miss the
> the device during startup.

Applied to 5.1/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
