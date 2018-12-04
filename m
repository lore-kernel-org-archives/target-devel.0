From: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Date: Tue, 04 Dec 2018 00:48:19 +0000
Subject: [PATCH v2 0/4] vhost/scsi: Respond to control queue operations
Message-Id: <1543884503-32281-1-git-send-email-bijan.mottahedeh@oracle.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

v1 -> v2:

- Use copy_to_iter() to send control queue response

This patch series causes vhost-scsi control queue TMF requests to be
explicitly rejected rather than implicitly ignored in order to prevent
a guest virito-scsi driver to wait indefinitely for a response to a SCSI
TMF request.

In addition, control queue address notification operations
(VIRTIO_SCSI_T_AN_*) get an effective no-op response.

Patch 1/4 implements a control queue handler modeled after the existing
request queue handler.  There is no commonality between the two handlers.

Patch 2/4 factors out the common processing code from the control queue
handler into separate routines.

Patch 3/4 modifies the request handler to use the common processing routines.  

Patch 4/4 uses copy_to_iter() to send back control queue responses.

Bijan Mottahedeh (4):
  vhost/scsi: Respond to control queue operations
  vhost/scsi: Extract common handling code from control queue handler
  vhost/scsi: Use common handling code in request queue handler
  vhost/scsi: Use copy_to_iter() to send control queue response

 drivers/vhost/scsi.c | 426 +++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 330 insertions(+), 96 deletions(-)

-- 
1.8.3.1
