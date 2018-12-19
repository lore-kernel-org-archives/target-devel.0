From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Wed, 19 Dec 2018 03:53:21 +0000
Subject: Re: [PATCH -next] scsi: target/core: Use kmem_cache_free() instead of kfree()
Message-Id: <yq17eg6i34e.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1545049193-159337-1-git-send-email-weiyongjun1@huawei.com>
In-Reply-To: <1545049193-159337-1-git-send-email-weiyongjun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org


Wei,

> memory allocated by kmem_cache_alloc() should be freed using
> kmem_cache_free(), not kfree().

Applied to 4.21/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
