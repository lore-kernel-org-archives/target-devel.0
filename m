From: Mike Christie <mchristi@redhat.com>
Date: Tue, 28 Nov 2017 18:40:26 +0000
Subject: [PATCH 00/15] tcmu changes
Message-Id: <1511894441-8626-1-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hi Nick,

I rebased/tested the outstanding tcmu patches against Linus's tree.
I did not use for-next/queue because each branch was missing something
and Linus's tree seems to have the big timer changes, tcmu patches
from for-next and queue full/misc changes from the queue brarnch.

The following patches allow the user to configure how much memory to
use for the ring and how long to wait for it, and it fixes a bug
where we would get stuck waiting for memory.

The first patch is a bug fixe patch that was posted on the list
and should go into the current rc if possible. The rest of the patches
are ok for the next feature window.

