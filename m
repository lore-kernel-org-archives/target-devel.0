From: kbuild test robot <lkp@intel.com>
Date: Wed, 16 May 2018 12:47:21 +0000
Subject: [RFC PATCH] iscsit_wait_for_tag() can be static
Message-Id: <20180516124721.GA27100@ivb43.lkp.intel.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180515160043.27044-2-willy@infradead.org>
In-Reply-To: <20180515160043.27044-2-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: Juergen Gross <jgross@suse.com>, Jens Axboe <axboe@kernel.dk>, kvm@vger.kernel.org, linux-scsi@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, netdev@vger.kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, target-devel@vger.kernel.org, kbuild-all@01.org, qla2xxx-upstream@qlogic.com, linux1394-devel@lists.sourceforge.net, Kent Overstreet <kent.overstreet@gmail.com>


Fixes: 5aff7a710f13 ("Convert target drivers to use sbitmap")
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 iscsi_target_util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 28bcffa..e147aef 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -147,7 +147,7 @@ void iscsit_free_r2ts_from_list(struct iscsi_cmd *cmd)
 	spin_unlock_bh(&cmd->r2t_lock);
 }
 
-int iscsit_wait_for_tag(struct se_session *se_sess, int state, int *cpup)
+static int iscsit_wait_for_tag(struct se_session *se_sess, int state, int *cpup)
 {
 	int tag = -1;
 	DEFINE_WAIT(wait);
