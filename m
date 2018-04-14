From: Randy Dunlap <rd.dunlab@gmail.com>
Date: Sat, 14 Apr 2018 17:51:06 +0000
Subject: [PATCH v3 4/4] target: add driver-api document
Message-Id: <20180414175106.13760-5-rd.dunlab@gmail.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180414175106.13760-1-rd.dunlab@gmail.com>
In-Reply-To: <20180414175106.13760-1-rd.dunlab@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Randy Dunlap <rdunlap@infradead.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-doc@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jonathan Corbet <corbet@lwn.net>

From: Randy Dunlap <rdunlap@infradead.org>

Add a driver-api document for target/iSCSI interfaces.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org
Cc: target-devel@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jonathan Corbet <corbet@lwn.net>
---
 Documentation/driver-api/index.rst  |    1 
 Documentation/driver-api/scsi.rst   |    2 
 Documentation/driver-api/target.rst |   64 ++++++++++++++++++++++++++
 3 files changed, 66 insertions(+), 1 deletion(-)

--- linux-next-20180413.orig/Documentation/driver-api/index.rst
+++ linux-next-20180413/Documentation/driver-api/index.rst
@@ -34,6 +34,7 @@ available subsections can be seen below.
    edac
    scsi
    libata
+   target
    mtdnand
    miscellaneous
    w1
--- linux-next-20180413.orig/Documentation/driver-api/scsi.rst
+++ linux-next-20180413/Documentation/driver-api/scsi.rst
@@ -334,5 +334,5 @@ todo
 ~~~~
 
 Parallel (fast/wide/ultra) SCSI, USB, SATA, SAS, Fibre Channel,
-FireWire, ATAPI devices, Infiniband, I2O, iSCSI, Parallel ports,
+FireWire, ATAPI devices, Infiniband, I2O, Parallel ports,
 netlink...
--- /dev/null
+++ linux-next-20180413/Documentation/driver-api/target.rst
@@ -0,0 +1,64 @@
+================+target and iSCSI Interfaces Guide
+================+
+Introduction and Overview
+============+
+TBD
+
+Target core device interfaces
+==============+
+.. kernel-doc:: drivers/target/target_core_device.c
+    :export:
+
+Target core transport interfaces
+================
+
+.. kernel-doc:: drivers/target/target_core_transport.c
+    :export:
+
+Target-supported userspace I/O
+===============
+
+.. kernel-doc:: drivers/target/target_core_user.c
+    :doc: Userspace I/O
+
+.. kernel-doc:: include/uapi/linux/target_core_user.h
+    :doc: Ring Design
+
+iSCSI helper functions
+===========
+
+.. kernel-doc:: drivers/scsi/libiscsi.c
+   :export:
+
+
+iSCSI boot information
+===========
+
+.. kernel-doc:: drivers/scsi/iscsi_boot_sysfs.c
+   :export:
+
+
+iSCSI transport class
+==========+
+The file drivers/scsi/scsi_transport_iscsi.c defines transport
+attributes for the iSCSI class, which sends SCSI packets over TCP/IP
+connections.
+
+.. kernel-doc:: drivers/scsi/scsi_transport_iscsi.c
+   :export:
+
+
+iSCSI TCP interfaces
+==========
+
+.. kernel-doc:: drivers/scsi/iscsi_tcp.c
+   :internal:
+
+.. kernel-doc:: drivers/scsi/libiscsi_tcp.c
+   :export:
+
