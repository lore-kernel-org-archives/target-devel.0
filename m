From: Jason Wang <jasowang@redhat.com>
Date: Mon, 02 Nov 2020 05:57:02 +0000
Subject: Re: [PATCH 04/17] vhost: prep vhost_dev_init users to handle failures
Message-Id: <0f4a5f72-01e7-46d1-f214-c61cbb812859@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
 <1603326903-27052-5-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1603326903-27052-5-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Mike Christie <michael.christie@oracle.com>, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, mst@redhat.com, pbonzini@redhat.com, stefanha@redhat.com, virtualization@lists.linux-foundation.org


On 2020/10/22 上午8:34, Mike Christie wrote:
> This is just a prep patch to get vhost_dev_init callers ready to handle
> the next patch where the function can fail. In this patch vhost_dev_init
> just returns 0, but I think it's easier to check for goto/error handling
> errors separated from the next patch.
>
> Signed-off-by: Mike Christie<michael.christie@oracle.com>
> ---
>   drivers/vhost/net.c   | 11 +++++++----
>   drivers/vhost/scsi.c  |  7 +++++--
>   drivers/vhost/test.c  |  9 +++++++--
>   drivers/vhost/vdpa.c  |  7 +++++--
>   drivers/vhost/vhost.c | 14 ++++++++------
>   drivers/vhost/vhost.h | 10 +++++-----
>   drivers/vhost/vsock.c |  9 ++++++---
>   7 files changed, 43 insertions(+), 24 deletions(-)


Acked-by: Jason Wang <jasowang@redhat.com>
