From: Zou Wei <zou_wei@huawei.com>
Date: Tue, 03 Nov 2020 11:57:54 +0000
Subject: [PATCH -next] IB/isert: Fix warning Comparison to bool
Message-Id: <1604404674-32998-1-git-send-email-zou_wei@huawei.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: sagi@grimberg.me, dledford@redhat.com, jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, Zou Wei <zou_wei@huawei.com>

Fix below warning reported by coccicheck:

./ib_isert.c:1104:12-24: WARNING: Comparison to bool

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index bd47894..e47cd02 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1101,7 +1101,7 @@ isert_handle_scsi_cmd(struct isert_conn *isert_conn,
 sequence_cmd:
 	rc = iscsit_sequence_cmd(conn, cmd, buf, hdr->cmdsn);
 
-	if (!rc && dump_payload = false && unsol_data)
+	if (!rc && !dump_payload && unsol_data)
 		iscsit_set_unsolicited_dataout(cmd);
 	else if (dump_payload && imm_data)
 		target_put_sess_cmd(&cmd->se_cmd);
-- 
2.6.2
