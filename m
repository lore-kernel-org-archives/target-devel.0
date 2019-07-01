From: Varun Prakash <varun@chelsio.com>
Date: Mon, 01 Jul 2019 16:44:51 +0000
Subject: [PATCH] scsi: target: cxgbit: add support for IEEE_8021QAZ_APP_SEL_STREAM selector
Message-Id: <1561998771-10265-1-git-send-email-varun@chelsio.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

IEEE_8021QAZ_APP_SEL_STREAM is a valid selector
for iSCSI connections, so add code to use
IEEE_8021QAZ_APP_SEL_STREAM selector to get priority
mask.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/target/iscsi/cxgbit/cxgbit_cm.c   | 8 +++++---
 drivers/target/iscsi/cxgbit/cxgbit_main.c | 3 ++-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/target/iscsi/cxgbit/cxgbit_cm.c b/drivers/target/iscsi/cxgbit/cxgbit_cm.c
index dab09b6..9d0ed93 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_cm.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_cm.c
@@ -878,10 +878,12 @@ static u8 cxgbit_get_iscsi_dcb_priority(struct net_device *ndev, u16 local_port)
 		return 0;
 
 	if (caps & DCB_CAP_DCBX_VER_IEEE) {
-		iscsi_dcb_app.selector = IEEE_8021QAZ_APP_SEL_ANY;
-
+		iscsi_dcb_app.selector = IEEE_8021QAZ_APP_SEL_STREAM;
 		ret = dcb_ieee_getapp_mask(ndev, &iscsi_dcb_app);
-
+		if (!ret) {
+			iscsi_dcb_app.selector = IEEE_8021QAZ_APP_SEL_ANY;
+			ret = dcb_ieee_getapp_mask(ndev, &iscsi_dcb_app);
+		}
 	} else if (caps & DCB_CAP_DCBX_VER_CEE) {
 		iscsi_dcb_app.selector = DCB_APP_IDTYPE_PORTNUM;
 
diff --git a/drivers/target/iscsi/cxgbit/cxgbit_main.c b/drivers/target/iscsi/cxgbit/cxgbit_main.c
index 4a7bb0b..4cd63c0 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_main.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_main.c
@@ -592,7 +592,8 @@ static void cxgbit_dcb_workfn(struct work_struct *work)
 	iscsi_app = &dcb_work->dcb_app;
 
 	if (iscsi_app->dcbx & DCB_CAP_DCBX_VER_IEEE) {
-		if (iscsi_app->app.selector != IEEE_8021QAZ_APP_SEL_ANY)
+		if ((iscsi_app->app.selector != IEEE_8021QAZ_APP_SEL_STREAM) &&
+		    (iscsi_app->app.selector != IEEE_8021QAZ_APP_SEL_ANY))
 			goto out;
 
 		priority = iscsi_app->app.priority;
-- 
2.0.2
