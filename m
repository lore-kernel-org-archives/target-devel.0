From: Laura Abbott <labbott@redhat.com>
Date: Tue, 11 Sep 2018 19:22:26 +0000
Subject: [PATCHv2 2/2] scsi: ibmvscsis: Ensure partition name is properly NUL terminated
Message-Id: <20180911192226.3620-3-labbott@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180911192226.3620-1-labbott@redhat.com>
In-Reply-To: <20180911192226.3620-1-labbott@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>, Michael Cyr <mikecyr@linux.vnet.ibm.com>, Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@redhat.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org


While reviewing another part of the code, Kees noticed that the
strncpy of the partition name might not always be NUL terminated. Switch
to using strscpy which does this safely.

Reported-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Laura Abbott <labbott@redhat.com>
---
v2: Switch to strscpy instead of just strlcpy
---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index b3a029ad07cd..f42a619198c4 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -3477,7 +3477,7 @@ static int ibmvscsis_probe(struct vio_dev *vdev,
 	snprintf(vscsi->eye, sizeof(vscsi->eye), "VSCSI %s", vdev->name);
 
 	vscsi->dds.unit_id = vdev->unit_address;
-	strncpy(vscsi->dds.partition_name, partition_name,
+	strscpy(vscsi->dds.partition_name, partition_name,
 		sizeof(vscsi->dds.partition_name));
 	vscsi->dds.partition_num = partition_number;
 
-- 
2.17.1
