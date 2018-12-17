From: Wei Yongjun <weiyongjun1@huawei.com>
Date: Mon, 17 Dec 2018 12:19:53 +0000
Subject: [PATCH -next] scsi: target/core: Use kmem_cache_free() instead of kfree()
Message-Id: <1545049193-159337-1-git-send-email-weiyongjun1@huawei.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

memory allocated by kmem_cache_alloc() should be freed using
kmem_cache_free(), not kfree().

Fixes: ad669505c4e9 ("scsi: target/core: Make sure that target_wait_for_sess_cmds() waits long enough")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/target/target_core_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 65a1819..ef9e75b 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -266,7 +266,7 @@ struct se_session *transport_alloc_session(enum target_prot_op sup_prot_ops)
 	}
 	ret = transport_init_session(se_sess);
 	if (ret < 0) {
-		kfree(se_sess);
+		kmem_cache_free(se_sess_cache, se_sess);
 		return ERR_PTR(ret);
 	}
 	se_sess->sup_prot_ops = sup_prot_ops;
