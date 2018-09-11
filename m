From: Laura Abbott <labbott@redhat.com>
Date: Tue, 11 Sep 2018 19:22:24 +0000
Subject: [PATCHv3 0/2] String fixups in ibmvscsi
Message-Id: <20180911192226.3620-1-labbott@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>, Michael Cyr <mikecyr@linux.vnet.ibm.com>, Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@redhat.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org

Hi,

This is (hopefully) the last version of the string fixups found in the
ibmvscsi driver.

Laura Abbott (2):
  scsi: ibmvscsis: Fix a stringop-overflow warning
  scsi: ibmvscsis: Ensure partition name is properly NUL terminated

 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

-- 
2.17.1
