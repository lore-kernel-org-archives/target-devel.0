From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Date: Mon, 27 Apr 2020 15:08:20 +0000
Subject: [PATCH 1/4] target: add missing emulate_pr attribute to passthrough backends
Message-Id: <20200427150823.15350-2-bstroesser@ts.fujitsu.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200427150823.15350-1-bstroesser@ts.fujitsu.com>
In-Reply-To: <20200427150823.15350-1-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: mchristi@redhat.com, ddiss@suse.de, hch@lst.de, martin.petersen@oracle.com, Bodo Stroesser <bstroesser@ts.fujitsu.com>

In commit b49d6f7885306ee636d5c1af52170f3069ccf5f7 the new attribute
emulate_pr was added.
passthrough_parse_cdb() uses the attribute's value to distinguish,
whether reservation commands should be rejected or not.
But the new attribute was not added to passthrough_attrib_attrs, so in
pscsi and tcmu - the users of passthrough_parse_cdb() - the attribute
is not available to change parser's behavior.

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
---
 drivers/target/target_core_configfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index ff82b21fdcce..d8589bb39c53 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1203,6 +1203,7 @@ struct configfs_attribute *passthrough_attrib_attrs[] = {
 	&attr_hw_block_size,
 	&attr_hw_max_sectors,
 	&attr_hw_queue_depth,
+	&attr_emulate_pr,
 	&attr_alua_support,
 	&attr_pgr_support,
 	NULL,
-- 
2.12.3
