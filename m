From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Date: Mon, 11 May 2020 07:37:09 +0000
Subject: [PATCH] RDMA/srpt: Add a newline when printing parameter 'srpt_service_guid' by sysfs
Message-Id: <1589182629-27743-1-git-send-email-wangxiongfeng2@huawei.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: bvanassche@acm.org, dledford@redhat.com, jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, wangxiongfeng2@huawei.com

When I cat module parameter 'srpt_service_guid', it displays as follows.
It is better to add a newline for easy reading.

[root@hulk-202 ~]# cat /sys/module/ib_srpt/parameters/srpt_service_guid
0x0205cdfffe8346b9[root@hulk-202 ~]#

Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 9855274..79b6341 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -81,7 +81,7 @@
 
 static int srpt_get_u64_x(char *buffer, const struct kernel_param *kp)
 {
-	return sprintf(buffer, "0x%016llx", *(u64 *)kp->arg);
+	return sprintf(buffer, "0x%016llx\n", *(u64 *)kp->arg);
 }
 module_param_call(srpt_service_guid, NULL, srpt_get_u64_x, &srpt_service_guid,
 		  0444);
-- 
1.7.12.4
