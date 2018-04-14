From: Randy Dunlap <rd.dunlab@gmail.com>
Date: Sat, 14 Apr 2018 17:51:04 +0000
Subject: [PATCH v3 2/4] target: target_core_transport.c: enable+fix kernel-doc
Message-Id: <20180414175106.13760-3-rd.dunlab@gmail.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180414175106.13760-1-rd.dunlab@gmail.com>
In-Reply-To: <20180414175106.13760-1-rd.dunlab@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Randy Dunlap <rdunlap@infradead.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-doc@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jonathan Corbet <corbet@lwn.net>

From: Randy Dunlap <rdunlap@infradead.org>

For exported functions that already have near-kernel-doc notation,
fix them to begin with "/**" and make a few corrections so that they
don't have any kernel-doc warnings.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org
Cc: target-devel@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jonathan Corbet <corbet@lwn.net>
---
 drivers/target/target_core_transport.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- linux-next-20180413.orig/drivers/target/target_core_transport.c
+++ linux-next-20180413/drivers/target/target_core_transport.c
@@ -1431,7 +1431,7 @@ transport_generic_map_mem_to_cmd(struct
 	return 0;
 }
 
-/*
+/**
  * target_submit_cmd_map_sgls - lookup unpacked lun and submit uninitialized
  * 			 se_cmd + use pre-allocated SGL memory.
  *
@@ -1441,7 +1441,7 @@ transport_generic_map_mem_to_cmd(struct
  * @sense: pointer to SCSI sense buffer
  * @unpacked_lun: unpacked LUN to reference for struct se_lun
  * @data_length: fabric expected data transfer length
- * @task_addr: SAM task attribute
+ * @task_attr: SAM task attribute
  * @data_dir: DMA data direction
  * @flags: flags for command submission from target_sc_flags_tables
  * @sgl: struct scatterlist memory for unidirectional mapping
@@ -1578,7 +1578,7 @@ int target_submit_cmd_map_sgls(struct se
 }
 EXPORT_SYMBOL(target_submit_cmd_map_sgls);
 
-/*
+/**
  * target_submit_cmd - lookup unpacked lun and submit uninitialized se_cmd
  *
  * @se_cmd: command descriptor to submit
@@ -1587,7 +1587,7 @@ EXPORT_SYMBOL(target_submit_cmd_map_sgls
  * @sense: pointer to SCSI sense buffer
  * @unpacked_lun: unpacked LUN to reference for struct se_lun
  * @data_length: fabric expected data transfer length
- * @task_addr: SAM task attribute
+ * @task_attr: SAM task attribute
  * @data_dir: DMA data direction
  * @flags: flags for command submission from target_sc_flags_tables
  *
@@ -2606,7 +2606,8 @@ int transport_generic_free_cmd(struct se
 }
 EXPORT_SYMBOL(transport_generic_free_cmd);
 
-/* target_get_sess_cmd - Add command to active ->sess_cmd_list
+/**
+ * target_get_sess_cmd - Add command to active ->sess_cmd_list
  * @se_cmd:	command descriptor to add
  * @ack_kref:	Signal that fabric will perform an ack target_put_sess_cmd()
  */
@@ -2800,7 +2801,8 @@ void target_show_cmd(const char *pfx, st
 }
 EXPORT_SYMBOL(target_show_cmd);
 
-/* target_sess_cmd_list_set_waiting - Flag all commands in
+/**
+ * target_sess_cmd_list_set_waiting - Flag all commands in
  *         sess_cmd_list to complete cmd_wait_comp.  Set
  *         sess_tearing_down so no more commands are queued.
  * @se_sess:	session to flag
@@ -2835,7 +2837,8 @@ void target_sess_cmd_list_set_waiting(st
 }
 EXPORT_SYMBOL(target_sess_cmd_list_set_waiting);
 
-/* target_wait_for_sess_cmds - Wait for outstanding descriptors
+/**
+ * target_wait_for_sess_cmds - Wait for outstanding descriptors
  * @se_sess:    session to wait for active I/O
  */
 void target_wait_for_sess_cmds(struct se_session *se_sess)
