From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Sat, 12 Jan 2019 02:06:26 +0000
Subject: Re: [PATCH v4] scsi: tcmu: avoid cmd/qfull timers updated whenever a new cmd comes
Message-Id: <yq1pnt2y6hp.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20181123011530.2477-1-xiubli@redhat.com>
In-Reply-To: <20181123011530.2477-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org


Xiubo,

> This fix will keep the cmd/qfull timers to be pended for the oldest
> cmd in ringbuffer and full queue, and will update them with the next
> cmd's deadline only when the old cmd's deadline is reached or removed
> from the ringbuffer and full queue.

Applied to 5.0/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
