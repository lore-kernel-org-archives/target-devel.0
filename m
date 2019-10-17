From: Maurizio Lombardi <mlombard@redhat.com>
Date: Thu, 17 Oct 2019 13:10:34 +0000
Subject: [PATCH V2 0/3] iscsi: chap: introduce support for SHA1, SHA256 and SHA3-256
Message-Id: <20191017131037.9903-1-mlombard@redhat.com>
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

Maurizio Lombardi (3):
  target-iscsi: CHAP: add support to SHA1, SHA256 and SHA3-256 hash
    functions
  target-iscsi: tie the challenge length to the hash digest size
  target-iscsi: rename some variables to avoid confusion.

 drivers/target/iscsi/iscsi_target_auth.c | 232 +++++++++++++++--------
 drivers/target/iscsi/iscsi_target_auth.h |  17 +-
 2 files changed, 161 insertions(+), 88 deletions(-)

-- 
Maurizio Lombardi
