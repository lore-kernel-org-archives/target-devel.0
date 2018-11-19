From: David Disseldorp <ddiss@suse.de>
Date: Mon, 19 Nov 2018 21:06:34 +0000
Subject: [PATCH v3 2/4] target: don't assume t10_wwn.vendor is null terminated
Message-Id: <20181119210636.22979-3-ddiss@suse.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 drivers/target/target_core_stat.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index f0db91ebd735..89f35167f036 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -804,10 +804,17 @@ static ssize_t target_stat_transport_dev_name_show(struct config_item *item,
 	if (dev) {
 		wwn = &dev->t10_wwn;
 		/* scsiTransportDevName */
-		ret = snprintf(page, PAGE_SIZE, "%s+%s\n",
+		if (strlen(wwn->unit_serial)) {
+			ret = snprintf(page, PAGE_SIZE, "%s+%s\n",
+				tpg->se_tpg_tfo->tpg_get_wwn(tpg),
+				wwn->unit_serial);
+		} else {
+			ret = snprintf(page, PAGE_SIZE, "%s+%."
+				__stringify(INQUIRY_VENDOR_IDENTIFIER_LEN)
+				"s\n",
 				tpg->se_tpg_tfo->tpg_get_wwn(tpg),
-				(strlen(wwn->unit_serial)) ? wwn->unit_serial :
 				wwn->vendor);
+		}
 	}
 	rcu_read_unlock();
 	return ret;
-- 
2.13.7
