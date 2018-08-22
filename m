From: Laura Abbott <labbott@redhat.com>
Date: Wed, 22 Aug 2018 17:37:09 +0000
Subject: [PATCH] iscsi-target: Don't use stack buffer for scatterlist
Message-Id: <20180822173709.5886-1-labbott@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Bart Van Assche <bart.vanassche@wdc.com>, Hannes Reinecke <hare@suse.com>
Cc: Laura Abbott <labbott@redhat.com>, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org


Fedora got a bug report of a crash with iSCSI:

kernel BUG at include/linux/scatterlist.h:143!
...
RIP: 0010:iscsit_do_crypto_hash_buf+0x154/0x180 [iscsi_target_mod]
...
 Call Trace:
  ? iscsi_target_tx_thread+0x200/0x200 [iscsi_target_mod]
  iscsit_get_rx_pdu+0x4cd/0xa90 [iscsi_target_mod]
  ? native_sched_clock+0x3e/0xa0
  ? iscsi_target_tx_thread+0x200/0x200 [iscsi_target_mod]
  iscsi_target_rx_thread+0x81/0xf0 [iscsi_target_mod]
  kthread+0x120/0x140
  ? kthread_create_worker_on_cpu+0x70/0x70
  ret_from_fork+0x3a/0x50

This is a BUG_ON for using a stack buffer with a scatterlist.
There are two cases that trigger this bug. Switch to using a
dynamically allocated buffer for one case and do not assign
a NULL buffer in another case.

Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id15258
Signed-off-by: Laura Abbott <labbott@redhat.com>
---
 drivers/target/iscsi/iscsi_target.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 8e223799347a..8b40f0e99e2c 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1419,7 +1419,8 @@ static void iscsit_do_crypto_hash_buf(struct ahash_request *hash,
 
 	sg_init_table(sg, ARRAY_SIZE(sg));
 	sg_set_buf(sg, buf, payload_length);
-	sg_set_buf(sg + 1, pad_bytes, padding);
+	if (padding)
+		sg_set_buf(sg + 1, pad_bytes, padding);
 
 	ahash_request_set_crypt(hash, sg, data_crc, payload_length + padding);
 
@@ -3913,10 +3914,14 @@ static bool iscsi_target_check_conn_state(struct iscsi_conn *conn)
 static void iscsit_get_rx_pdu(struct iscsi_conn *conn)
 {
 	int ret;
-	u8 buffer[ISCSI_HDR_LEN], opcode;
+	u8 *buffer, opcode;
 	u32 checksum = 0, digest = 0;
 	struct kvec iov;
 
+	buffer = kmalloc_array(ISCSI_HDR_LEN, sizeof(*buffer), GFP_KERNEL);
+	if (!buffer)
+		return;
+
 	while (!kthread_should_stop()) {
 		/*
 		 * Ensure that both TX and RX per connection kthreads
@@ -3985,6 +3990,8 @@ static void iscsit_get_rx_pdu(struct iscsi_conn *conn)
 		if (ret < 0)
 			return;
 	}
+
+	kfree(buffer);
 }
 
 int iscsi_target_rx_thread(void *arg)
-- 
2.17.1
