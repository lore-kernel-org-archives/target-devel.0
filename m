From: SF Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 12 Dec 2017 12:21:38 +0000
Subject: [PATCH 1/2] target: cxgbit: Delete an error message for a failed memory allocation in two functions
Message-Id: <c2568ddf-715e-101b-7dbf-3459179d9e16@users.sourceforge.net>
List-Id: <target-devel.vger.kernel.org>
References: <77d06f1c-a650-644f-7364-55bb52aeb6ac@users.sourceforge.net>
In-Reply-To: <77d06f1c-a650-644f-7364-55bb52aeb6ac@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>, Johannes Berg <johannes.berg@intel.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Varun Prakash <varun@chelsio.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 12 Dec 2017 11:34:51 +0100

Omit an extra message for a memory allocation failure in these functions.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/target/iscsi/cxgbit/cxgbit_target.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/target/iscsi/cxgbit/cxgbit_target.c b/drivers/target/iscsi/cxgbit/cxgbit_target.c
index 514986b57c2d..9163152b6d0b 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_target.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_target.c
@@ -1126,8 +1126,6 @@ static int cxgbit_handle_nop_out(struct cxgbit_sock *csk, struct iscsi_cmd *cmd)
 	if (payload_length && hdr->ttt = cpu_to_be32(0xFFFFFFFF)) {
 		ping_data = kzalloc(payload_length + 1, GFP_KERNEL);
 		if (!ping_data) {
-			pr_err("Unable to allocate memory for"
-				" NOPOUT ping data.\n");
 			ret = -1;
 			goto out;
 		}
@@ -1188,11 +1186,9 @@ cxgbit_handle_text_cmd(struct cxgbit_sock *csk, struct iscsi_cmd *cmd)
 
 	if (payload_length) {
 		text_in = kzalloc(payload_length, GFP_KERNEL);
-		if (!text_in) {
-			pr_err("Unable to allocate text_in of payload_length: %u\n",
-			       payload_length);
+		if (!text_in)
 			return -ENOMEM;
-		}
+
 		skb_copy_bits(csk->skb, pdu_cb->doffset,
 			      text_in, payload_length);
 
-- 
2.15.1

