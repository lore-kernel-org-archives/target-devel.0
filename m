From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Date: Wed, 08 Apr 2020 13:26:09 +0000
Subject: [PATCH 1/2] target: Write NULL to *port_nexus_ptr if no ISID
Message-Id: <20200408132610.14623-2-bstroesser@ts.fujitsu.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200408132610.14623-1-bstroesser@ts.fujitsu.com>
In-Reply-To: <20200408132610.14623-1-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: mchristi@redhat.com, martin.petersen@oracle.com, Bodo Stroesser <bstroesser@ts.fujitsu.com>

This patch fixes a minor flaw that could be triggered by
a PR OUT RESERVE on iSCSI, if TRANSPORT IDs with and without ISID
are used in the same command.
In case an ISCSI Transport ID has no ISID, port_nexus_ptr was not
used to write NULL, so value from previous call might persist.
I don't know, if that ever could happen, but with the change the
code is cleaner, I think.

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
---
 drivers/target/target_core_fabric_lib.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index 6b4b354c88aa..f5f673e128ef 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -341,7 +341,8 @@ static char *iscsi_parse_pr_out_transport_id(
 			*p = tolower(*p);
 			p++;
 		}
-	}
+	} else
+		*port_nexus_ptr = NULL;
 
 	return &buf[4];
 }
-- 
2.12.3
