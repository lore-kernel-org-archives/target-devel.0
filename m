From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Wed, 27 May 2020 02:13:00 +0000
Subject: Re: [PATCH 1/1] vhost: scsi: notify TCM about the maximum sg entries supported per command.
Message-Id: <159054550934.12032.480617639517233845.b4-ty@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1590166317-953-1-git-send-email-sudhakar.panneerselvam@oracle.com>
In-Reply-To: <1590166317-953-1-git-send-email-sudhakar.panneerselvam@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, jasowang@redhat.com, shirley.ma@oracle.com, mst@redhat.com, pbonzini@redhat.com, stefanha@redhat.com

On Fri, 22 May 2020 16:51:57 +0000, Sudhakar Panneerselvam wrote:

> vhost-scsi pre-allocates the maximum sg entries per command and if a
> command requires more than VHOST_SCSI_PREALLOC_SGLS entries, then that
> command is failed by it. This patch lets vhost communicate the max sg limit
> when it registers vhost_scsi_ops with TCM. With this change, TCM would
> report the max sg entries through "Block Limits" VPD page which will be
> typically queried by the SCSI initiator during device discovery. By knowing
> this limit, the initiator could ensure the maximum transfer length is less
> than or equal to what is reported by vhost-scsi.

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: vhost: Notify TCM about the maximum sg entries supported per command
      https://git.kernel.org/mkp/scsi/c/5ae6a6a91503

-- 
Martin K. Petersen	Oracle Linux Engineering
