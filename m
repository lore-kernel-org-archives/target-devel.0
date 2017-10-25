From: Mike Christie <mchristi@redhat.com>
Date: Wed, 25 Oct 2017 16:47:10 +0000
Subject: [PATCH 00/20] tcmu update
Message-Id: <1508950050-10120-1-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hey Nick,

The following patches were made over your for-next branch on target-pending.

Patches 1 -3 are ok for the next merge window:

- Patches 1 - 2 are misc fixes/changes.
- Patch 3 is just a cleanup to use the proper macro.

Patches 4 - 20 were posted later and have not been on the list
for as long and so maybe are better for the next-next merge
window.

- Patch 4 fixes the SCSI value that TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE
is converted to. It is needed by patches 5 - 20.
- Patch 5 - 18 fix bugs in tcmu's ring buffer code.
- Patch 18 - 20 allow you to configure the size of the ring buffer
and how long we wait for ring memory.


