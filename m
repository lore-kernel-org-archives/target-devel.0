From: Randy Dunlap <rd.dunlab@gmail.com>
Date: Sat, 14 Apr 2018 17:51:02 +0000
Subject: target: clean up kernel-doc and add driver-api document
Message-Id: <20180414175106.13760-1-rd.dunlab@gmail.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Randy Dunlap <rdunlap@infradead.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-doc@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jonathan Corbet <corbet@lwn.net>

From: Randy Dunlap <rdunlap@infradead.org>

This patch series fixes kernel-doc warnings in drivers/target/ and
its header files, then adds a Documentation driver-api chapter for
target driver interfaces.


[PATCH v3 1/4] target: target_core_transport.c: fix kernel-doc warnings
[PATCH v3 2/4] target: target_core_transport.c: enable+fix kernel-doc
[PATCH v3 3/4] target: target_core_user.[ch]: convert comments into DOC:
[PATCH v3 4/4] target: add driver-api document


 Documentation/driver-api/index.rst     |    1 
 Documentation/driver-api/scsi.rst      |    2 
 Documentation/driver-api/target.rst    |   64 +++++++++++++++++++++++
 drivers/target/target_core_transport.c |   19 +++---
 drivers/target/target_core_user.c      |    8 ++
 include/uapi/linux/target_core_user.h  |   11 ++-
 6 files changed, 89 insertions(+), 16 deletions(-)
