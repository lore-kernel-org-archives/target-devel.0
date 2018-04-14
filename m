From: Randy Dunlap <rd.dunlab@gmail.com>
Date: Sat, 14 Apr 2018 17:51:05 +0000
Subject: [PATCH v3 3/4] target: target_core_user.[ch]: convert comments into DOC:
Message-Id: <20180414175106.13760-4-rd.dunlab@gmail.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180414175106.13760-1-rd.dunlab@gmail.com>
In-Reply-To: <20180414175106.13760-1-rd.dunlab@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Randy Dunlap <rdunlap@infradead.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-doc@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jonathan Corbet <corbet@lwn.net>

From: Randy Dunlap <rdunlap@infradead.org>

Make documentation on target-supported userspace-I/O design be
usable by kernel-doc by using "DOC:". This is used in the driver-api
Documentation chapter.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org
Cc: target-devel@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jonathan Corbet <corbet@lwn.net>
---
 drivers/target/target_core_user.c     |    8 ++++++--
 include/uapi/linux/target_core_user.h |   11 ++++++-----
 2 files changed, 12 insertions(+), 7 deletions(-)

--- linux-next-20180413.orig/drivers/target/target_core_user.c
+++ linux-next-20180413/drivers/target/target_core_user.c
@@ -42,7 +42,11 @@
 
 #include <linux/target_core_user.h>
 
-/*
+/**
+ * DOC: Userspace I/O
+ * Userspace I/O
+ * -------------
+ *
  * Define a shared-memory interface for LIO to pass SCSI commands and
  * data to userspace for processing. This is to allow backends that
  * are too complex for in-kernel support to be possible.
@@ -53,7 +57,7 @@
  * See the .h file for how the ring is laid out. Note that while the
  * command ring is defined, the particulars of the data area are
  * not. Offset values in the command entry point to other locations
- * internal to the mmap()ed area. There is separate space outside the
+ * internal to the mmap-ed area. There is separate space outside the
  * command ring for data buffers. This leaves maximum flexibility for
  * moving buffer allocations, or even page flipping or other
  * allocation techniques, without altering the command ring layout.
--- linux-next-20180413.orig/include/uapi/linux/target_core_user.h
+++ linux-next-20180413/include/uapi/linux/target_core_user.h
@@ -9,21 +9,22 @@
 
 #define TCMU_VERSION "2.0"
 
-/*
+/**
+ * DOC: Ring Design
  * Ring Design
  * -----------
  *
  * The mmaped area is divided into three parts:
- * 1) The mailbox (struct tcmu_mailbox, below)
- * 2) The command ring
- * 3) Everything beyond the command ring (data)
+ * 1) The mailbox (struct tcmu_mailbox, below);
+ * 2) The command ring;
+ * 3) Everything beyond the command ring (data).
  *
  * The mailbox tells userspace the offset of the command ring from the
  * start of the shared memory region, and how big the command ring is.
  *
  * The kernel passes SCSI commands to userspace by putting a struct
  * tcmu_cmd_entry in the ring, updating mailbox->cmd_head, and poking
- * userspace via uio's interrupt mechanism.
+ * userspace via UIO's interrupt mechanism.
  *
  * tcmu_cmd_entry contains a header. If the header type is PAD,
  * userspace should skip hdr->length bytes (mod cmdr_size) to find the
