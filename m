From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 17 Dec 2018 16:16:00 +0000
Subject: Re: [PATCH -next] scsi: target/core: Use kmem_cache_free() instead of kfree()
Message-Id: <1545063360.185366.430.camel@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <1545049193-159337-1-git-send-email-weiyongjun1@huawei.com>
In-Reply-To: <1545049193-159337-1-git-send-email-weiyongjun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Mon, 2018-12-17 at 12:19 +-0000, Wei Yongjun wrote:
+AD4 memory allocated by kmem+AF8-cache+AF8-alloc() should be freed using
+AD4 kmem+AF8-cache+AF8-free(), not kfree().
+AD4 
+AD4 Fixes: ad669505c4e9 (+ACI-scsi: target/core: Make sure that target+AF8-wait+AF8-for+AF8-sess+AF8-cmds() waits long enough+ACI)
+AD4 Signed-off-by: Wei Yongjun +ADw-weiyongjun1+AEA-huawei.com+AD4
+AD4 ---
+AD4  drivers/target/target+AF8-core+AF8-transport.c +AHw 2 +--
+AD4  1 file changed, 1 insertion(+-), 1 deletion(-)
+AD4 
+AD4 diff --git a/drivers/target/target+AF8-core+AF8-transport.c b/drivers/target/target+AF8-core+AF8-transport.c
+AD4 index 65a1819..ef9e75b 100644
+AD4 --- a/drivers/target/target+AF8-core+AF8-transport.c
+AD4 +-+-+- b/drivers/target/target+AF8-core+AF8-transport.c
+AD4 +AEAAQA -266,7 +-266,7 +AEAAQA struct se+AF8-session +ACo-transport+AF8-alloc+AF8-session(enum target+AF8-prot+AF8-op sup+AF8-prot+AF8-ops)
+AD4  	+AH0
+AD4  	ret +AD0 transport+AF8-init+AF8-session(se+AF8-sess)+ADs
+AD4  	if (ret +ADw 0) +AHs
+AD4 -		kfree(se+AF8-sess)+ADs
+AD4 +-		kmem+AF8-cache+AF8-free(se+AF8-sess+AF8-cache, se+AF8-sess)+ADs
+AD4  		return ERR+AF8-PTR(ret)+ADs
+AD4  	+AH0
+AD4  	se+AF8-sess-+AD4-sup+AF8-prot+AF8-ops +AD0 sup+AF8-prot+AF8-ops+ADs

Thanks for this patch.

Reviewed-by: Bart Van Assche +ADw-bvanassche+AEA-acm.org+AD4
