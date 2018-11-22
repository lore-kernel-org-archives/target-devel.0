From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Thu, 22 Nov 2018 03:11:46 +0000
Subject: Re: [PATCH v5] target: add emulate_pr backstore attr to toggle PR support
Message-Id: <yq1zhu17qml.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20181107131107.7426-1-ddiss@suse.de>
In-Reply-To: <20181107131107.7426-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org


David,

> The new emulate_pr backstore attribute allows for Persistent Reservation
> and SCSI2 RESERVE/RELEASE support to be completely disabled. This can be
> useful for scenarios such as:
> - Ensuring ATS (Compare & Write) usage on recent VMware ESXi initiators.
> - Allowing clustered (e.g. tcm-user) backends to block such requests,
>   avoiding the multi-node reservation state propagation.
>
> When explicitly disabled, PR and RESERVE/RELEASE requests receive
> Invalid Command Operation Code response sense data.

Applied to 4.21/scsi-queue. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
