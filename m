From: Wei Yongjun <weiyongjun1@huawei.com>
Date: Sat, 22 Dec 2018 10:30:30 +0000
Subject: [PATCH -next] RDMA/srpt: Use kmem_cache_free() instead of kfree()
Message-Id: <1545474630-123120-1-git-send-email-weiyongjun1@huawei.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

memory allocated by kmem_cache_alloc() should be freed using
kmem_cache_free(), not kfree().

Fixes: 5dabcd0456d7 ("RDMA/srpt: Add support for immediate data")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index d38205c..e9c336c 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -674,7 +674,7 @@ static struct srpt_ioctx *srpt_alloc_ioctx(struct srpt_device *sdev,
 	return ioctx;
 
 err_free_buf:
-	kfree(ioctx->buf);
+	kmem_cache_free(buf_cache, ioctx->buf);
 err_free_ioctx:
 	kfree(ioctx);
 err:
