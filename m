From: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Date: Tue, 18 Sep 2018 00:09:46 +0000
Subject: [PATCH 0/3] vhost/scsi: Respond to control queue operations
Message-Id: <1537229389-16176-1-git-send-email-bijan.mottahedeh@oracle.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patch series causes vhost-scsi control queue TMF requests to be
explicitly rejected rather than implicitly ignored in order to prevent
a guest virito-scsi driver to wait indefinitely for a response to a SCSI
TMF request.

In addition, control queue address notification operations
(VIRTIO_SCSI_T_AN_*) get an effective no-op response.

Patch 1/3 implements a control queue handler modeled after the existing
request queue handler.  There is no commonality between the two handlers.

Patch 2/3 factors out the common processing code from the control queue
handler into separate routines.

Patch 3/3 modifies the request handler to use the common processing routines.  

Bijan Mottahedeh (3):
  vhost/scsi: Respond to control queue operations
  vhost/scsi: Extract common handling code from control queue handler
  vhost/scsi: Use common handling code in request queue handler

 drivers/vhost/scsi.c | 422 +++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 326 insertions(+), 96 deletions(-)

-- 
1.8.3.1
