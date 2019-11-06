From: Chris Leech <cleech@redhat.com>
Date: Wed, 06 Nov 2019 03:26:51 +0000
Subject: Re: [PATCH V3 0/3] iscsi: chap: introduce support for SHA1, SHA256 and SHA3-256
Message-Id: <20191106032651.GA7899@localhost.localdomain>
List-Id: <target-devel.vger.kernel.org>
References: <20191028123822.5864-1-mlombard@redhat.com>
In-Reply-To: <20191028123822.5864-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Mon, Oct 28, 2019 at 01:38:19PM +0100, Maurizio Lombardi wrote:
> iSCSI with the Challenge-Handshake Authentication Protocol is not FIPS compliant.
> This is due to the fact that CHAP currently uses MD5 as the only supported
> digest algorithm and MD5 is not allowed by FIPS.
> 
> When FIPS mode is enabled on the target server, the CHAP authentication
> won't work because the target driver will be prevented from using the MD5 module.
> 
> Given that CHAP is agnostic regarding the algorithm it uses, this
> patchset introduce support for three new alternatives: SHA1, SHA256 and SHA3-256.
> 
> They all have their protocol identifiers assigned by IANA:
> https://www.iana.org/assignments/ppp-numbers/ppp-numbers.xml#ppp-numbers-9
> 
> Initiator-side code for open-iscsi has already been merged:
> https://github.com/open-iscsi/open-iscsi/pull/170
> 
> V2: adds SHA256
> V3: rebased on top of 5.5/scsi-queue
>     PATCH 3: renames initiatorchg_* variables to client_challenge_*
> 
> Maurizio Lombardi (3):
>   target-iscsi: CHAP: add support to SHA1, SHA256 and SHA3-256 hash
>     functions
>   target-iscsi: tie the challenge length to the hash digest size
>   target-iscsi: rename some variables to avoid confusion.
> 
>  drivers/target/iscsi/iscsi_target_auth.c | 235 +++++++++++++++--------
>  drivers/target/iscsi/iscsi_target_auth.h |  17 +-
>  2 files changed, 163 insertions(+), 89 deletions(-)
> 
> -- 

I've tested this latest version against the latest upstream Open-iSCSI
tools and verified that all of the new digest modes negotiate and
function for mutual CHAP authentication.

Tested-by: Chris Leech <cleech@redhat.com>

Note that configfs in 5.5/scsi-queue is currently broken and you can't
actually configure the target subsystem with first applying the patch 
"configfs: calculate the depth of parent item" from Honggang Li.

Also, I didn't actually put the target system into FIPS enforcing mode,
becuase that kernel failed to boot due to a FIPS self-test failure for
ofb(aes)
