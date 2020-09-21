From: Mike Christie <michael.christie@oracle.com>
Date: Mon, 21 Sep 2020 18:23:00 +0000
Subject: [PATCH 0/8] vhost scsi: fixes and cleanups
Message-Id: <1600712588-9514-1-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com, stefanha@redhat.com, virtualization@lists.linux-foundation.org

The following patches were made over Linus's tree, but apply to
Martin's 5.10 queue branch and Michael's vhost branch on this tree.
The patches fixes a couple issues with vhost scsi's cmd allocation
and completion handling, add support for LUN RESETs, and perform
some cleanups to the vhost scsi flush code.
