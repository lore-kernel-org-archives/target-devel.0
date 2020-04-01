From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Date: Wed, 01 Apr 2020 13:21:53 +0000
Subject: [PATCH] target: tcmu: add missing pr attributes to passthrough backends
Message-Id: <20200401132153.23501-1-bstroesser@ts.fujitsu.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

In commit b49d6f7885306ee636d5c1af52170f3069ccf5f7 the new attribute
emulate_pr was added.
passthrough_parse_cdb() uses the attribute's value to distinguish,
whether reservation commands should be rejected or not.
But the new attribute was not added to passthrough_attrib_attrs, so in
pscsi and tcmu - the users of passthrough_parse_cdb() - the attribute
is not available to change parser's behavior.
This patch adds the new attribute as well as the "pr control" attributes
enforce_pr_isids and force_pr_aptpl to passthrough_attrib_attrs.

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
---
 drivers/target/target_core_configfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index ff82b21fdcce..c5a974c5b31d 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1203,6 +1203,9 @@ struct configfs_attribute *passthrough_attrib_attrs[] = {
 	&attr_hw_block_size,
 	&attr_hw_max_sectors,
 	&attr_hw_queue_depth,
+	&attr_emulate_pr,
+	&attr_enforce_pr_isids,
+	&attr_force_pr_aptpl,
 	&attr_alua_support,
 	&attr_pgr_support,
 	NULL,
-- 
2.12.3
