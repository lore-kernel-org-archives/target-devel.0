From: Maurizio Lombardi <mlombard@redhat.com>
Date: Mon, 28 Oct 2019 12:38:19 +0000
Subject: [PATCH V3 0/3] iscsi: chap: introduce support for SHA1, SHA256 and SHA3-256
Message-Id: <20191028123822.5864-1-mlombard@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

iSCSI with the Challenge-Handshake Authentication Protocol is not FIPS compliant.
This is due to the fact that CHAP currently uses MD5 as the only supported
digest algorithm and MD5 is not allowed by FIPS.

When FIPS mode is enabled on the target server, the CHAP authentication
won't work because the target driver will be prevented from using the MD5 module.

Given that CHAP is agnostic regarding the algorithm it uses, this
patchset introduce support for three new alternatives: SHA1, SHA256 and SHA3-256.

They all have their protocol identifiers assigned by IANA:
https://www.iana.org/assignments/ppp-numbers/ppp-numbers.xml#ppp-numbers-9

Initiator-side code for open-iscsi has already been merged:
https://github.com/open-iscsi/open-iscsi/pull/170

V2: adds SHA256
V3: rebased on top of 5.5/scsi-queue
    PATCH 3: renames initiatorchg_* variables to client_challenge_*

Maurizio Lombardi (3):
  target-iscsi: CHAP: add support to SHA1, SHA256 and SHA3-256 hash
    functions
  target-iscsi: tie the challenge length to the hash digest size
  target-iscsi: rename some variables to avoid confusion.

 drivers/target/iscsi/iscsi_target_auth.c | 235 +++++++++++++++--------
 drivers/target/iscsi/iscsi_target_auth.h |  17 +-
 2 files changed, 163 insertions(+), 89 deletions(-)

-- 
Maurizio Lombardi
