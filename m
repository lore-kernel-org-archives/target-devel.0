From: David Disseldorp <ddiss@suse.de>
Date: Thu, 12 Sep 2019 09:55:47 +0000
Subject: [PATCH 3/3] target: remove unused extension parameters
Message-Id: <20190912095547.22427-4-ddiss@suse.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 drivers/target/iscsi/iscsi_target_parameters.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_parameters.h b/drivers/target/iscsi/iscsi_target_parameters.h
index daf47f38e081..240c4c4344f6 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.h
+++ b/drivers/target/iscsi/iscsi_target_parameters.h
@@ -93,9 +93,6 @@ extern void iscsi_set_session_parameters(struct iscsi_sess_ops *,
 #define OFMARKER			"OFMarker"
 #define IFMARKINT			"IFMarkInt"
 #define OFMARKINT			"OFMarkInt"
-#define X_EXTENSIONKEY			"X-com.sbei.version"
-#define X_EXTENSIONKEY_CISCO_NEW	"X-com.cisco.protocol"
-#define X_EXTENSIONKEY_CISCO_OLD	"X-com.cisco.iscsi.draft"
 
 /*
  * Parameter names of iSCSI Extentions for RDMA (iSER).  See RFC-5046
-- 
2.16.4
