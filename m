From: Randy Dunlap <rd.dunlab@gmail.com>
Date: Sat, 14 Apr 2018 17:51:03 +0000
Subject: [PATCH v3 1/4] target: target_core_transport.c: fix kernel-doc warnings
Message-Id: <20180414175106.13760-2-rd.dunlab@gmail.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180414175106.13760-1-rd.dunlab@gmail.com>
In-Reply-To: <20180414175106.13760-1-rd.dunlab@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Randy Dunlap <rdunlap@infradead.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-doc@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jonathan Corbet <corbet@lwn.net>

From: Randy Dunlap <rdunlap@infradead.org>

Correct a function parameter's name to eliminate kernel-doc warnings
in drivers/target/target_core_transport.c.

Fixes these kernel-doc warnings: (tested by adding these files to a new
target.rst documentation file)

../drivers/target/target_core_transport.c:1671: warning: No description found for parameter 'fabric_tmr_ptr'
../drivers/target/target_core_transport.c:1671: warning: Excess function parameter 'fabric_context' description in 'target_submit_tmr'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org
Cc: target-devel@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jonathan Corbet <corbet@lwn.net>
---
 drivers/target/target_core_transport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20180413.orig/drivers/target/target_core_transport.c
+++ linux-next-20180413/drivers/target/target_core_transport.c
@@ -1654,7 +1654,7 @@ static bool target_lookup_lun_from_tag(s
  * @se_sess: associated se_sess for endpoint
  * @sense: pointer to SCSI sense buffer
  * @unpacked_lun: unpacked LUN to reference for struct se_lun
- * @fabric_context: fabric context for TMR req
+ * @fabric_tmr_ptr: fabric context for TMR req
  * @tm_type: Type of TM request
  * @gfp: gfp type for caller
  * @tag: referenced task tag for TMR_ABORT_TASK
