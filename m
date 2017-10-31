From: Bart Van Assche <bart.vanassche@wdc.com>
Date: Tue, 31 Oct 2017 18:03:13 +0000
Subject: [PATCH 05/11] target/iscsi: Define OFFLOAD_BUF_SIZE once
Message-Id: <20171031180319.19258-6-bart.vanassche@wdc.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

The constant OFFLOAD_BUF_SIZE is defined twice - once in
iscsi_target_seq_pdu_list.c and once in iscsi_target_erl1.c. Since
that constant is not used in the former source file, remove its
definition from that source file.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Mike Christie <mchristi@redhat.com>
---
 drivers/target/iscsi/iscsi_target_seq_pdu_list.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_seq_pdu_list.c b/drivers/target/iscsi/iscsi_target_seq_pdu_list.c
index e446a09c886b..f65e5e584212 100644
--- a/drivers/target/iscsi/iscsi_target_seq_pdu_list.c
+++ b/drivers/target/iscsi/iscsi_target_seq_pdu_list.c
@@ -25,8 +25,6 @@
 #include "iscsi_target_tpg.h"
 #include "iscsi_target_seq_pdu_list.h"
 
-#define OFFLOAD_BUF_SIZE	32768
-
 #ifdef DEBUG
 static void iscsit_dump_seq_list(struct iscsi_cmd *cmd)
 {
-- 
2.14.2

