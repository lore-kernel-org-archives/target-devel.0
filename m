From: Maurizio Lombardi <mlombard@redhat.com>
Date: Thu, 29 Aug 2019 15:59:25 +0000
Subject: [RFC PATCH 0/4] iscsi: chap: introduce support for SHA1 and SHA3-256
Message-Id: <20190829155929.27701-1-mlombard@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cleech@redhat.com
Cc: mchristi@redhat.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

iSCSI with the Challenge-Handshake Authentication Protocol is not FIPS compliant.
This is due to the fact that CHAP currently uses MD5 as the only supported
digest algorithm and MD5 is not allowed by FIPS.

When FIPS mode is enabled on the target server, the CHAP authentication
won't work because the target driver will be prevented from using the MD5 module.

Given that CHAP is agnostic regarding the algorithm it uses, this
patchset introduce support for two new alternatives: SHA1 and SHA3-256.

SHA1 has already its own assigned value for its use in CHAP, as reported by IANA:
https://www.iana.org/assignments/ppp-numbers/ppp-numbers.xml#ppp-numbers-9
On the other hand the use of SHA1 on FIPS-enabled systems has been deprecated
and therefore it's not a vialable long term option.

We could consider introducing a more modern hash algorithm like SHA3-256, as
this patchset does.

A pull request for the open-iscsi initiator side implementation has been
submitted here:
https://github.com/open-iscsi/open-iscsi/pull/170

Maurizio Lombardi (4):
  target-iscsi: CHAP: add support to SHA1 and SHA3-256 hash functions
  target-iscsi: remove unneeded function
  target-iscsi: tie the challenge length to the hash digest size
  target-iscsi: rename some variables to avoid confusion.

 drivers/target/iscsi/iscsi_target_auth.c | 218 ++++++++++++++---------
 drivers/target/iscsi/iscsi_target_auth.h |  13 +-
 2 files changed, 147 insertions(+), 84 deletions(-)

-- 
Maurizio Lombardi
