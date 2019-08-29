From: Michal Suchanek <msuchanek@suse.de>
Date: Thu, 29 Aug 2019 12:32:02 +0000
Subject: [PATCH 3/3] scsi: ibmvscsi: tgt: Fix fallthrough warnings.
Message-Id: <7a621bd1a818c76c320cfd69ab13a17369e3c979.1567081143.git.msuchanek@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <cover.1567081143.git.msuchanek@suse.de>
In-Reply-To: <cover.1567081143.git.msuchanek@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linuxppc-dev@lists.ozlabs.org
Cc: Michal Suchanek <msuchanek@suse.de>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Michael Cyr <mikecyr@linux.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, target-devel@vger.kernel.org

Add fallthrough comments where they are missing.

Signed-off-by: Michal Suchanek <msuchanek@suse.de>
---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index 7f9535392a93..57475dbcae0f 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -1581,6 +1581,7 @@ static long ibmvscsis_adapter_info(struct scsi_info *vscsi,
 	case H_PERMISSION:
 		if (connection_broken(vscsi))
 			flag_bits = (RESPONSE_Q_DOWN | CLIENT_FAILED);
+		/* fallthrough */
 	default:
 		dev_err(&vscsi->dev, "adapter_info: h_copy_rdma to client failed, rc %ld\n",
 			rc);
@@ -2492,8 +2493,10 @@ static long ibmvscsis_ping_response(struct scsi_info *vscsi)
 		break;
 	case H_CLOSED:
 		vscsi->flags |= CLIENT_FAILED;
+		/* fallthrough */
 	case H_DROPPED:
 		vscsi->flags |= RESPONSE_Q_DOWN;
+		/* fallthrough */
 	case H_REMOTE_PARM:
 		dev_err(&vscsi->dev, "ping_response: h_send_crq failed, rc %ld\n",
 			rc);
-- 
2.12.3
