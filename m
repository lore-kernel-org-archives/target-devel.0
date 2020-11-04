From: Mike Christie <michael.christie@oracle.com>
Date: Wed, 04 Nov 2020 20:27:46 +0000
Subject: [PATCH 1/1] target_core_user: make Bodo maintainer
Message-Id: <1604521666-16573-1-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Bodo Stroesser <bostroesser@gmail.com>

Bodo knows the code better than me now, has time to review
patches and is excellent at it, and has lots of ideas for how to
make the driver better, so this patch adds him as the maintainer.

There was no entry in there already. Andy had posted on the
list here:
https://www.spinics.net/lists/target-devel/msg14690.html
when it got transitioned to me. I added an entry because
several companies used it and I thought it would be easy for
them to find Bodo.

Cc: Bodo Stroesser <bostroesser@gmail.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index b43b595..65e7814 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15585,6 +15585,15 @@ F:	Documentation/scsi/st.rst
 F:	drivers/scsi/st.*
 F:	drivers/scsi/st_*.h
 
+SCSI TARGET CORE USER DRIVER
+M:	Bodo Stroesser <bostroesser@gmail.com>
+L:	linux-scsi@vger.kernel.org
+L:	target-devel@vger.kernel.org
+S:	Supported
+F:	Documentation/target/tcmu-design.rst
+F:	drivers/target/target_core_user.c
+F:	include/uapi/linux/target_core_user.h
+
 SCSI TARGET SUBSYSTEM
 M:	"Martin K. Petersen" <martin.petersen@oracle.com>
 L:	linux-scsi@vger.kernel.org
-- 
1.8.3.1
