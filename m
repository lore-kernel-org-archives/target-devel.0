From: "Alexander A. Klimov" <grandmaster@al2klimov.de>
Date: Mon, 13 Jul 2020 21:48:26 +0000
Subject: [PATCH v2] IB: Replace HTTP links with HTTPS ones
Message-Id: <20200713214826.42487-1-grandmaster@al2klimov.de>
List-Id: <target-devel.vger.kernel.org>
References: <20200713135031.GA25301@ziepe.ca>
In-Reply-To: <20200713135031.GA25301@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: sagi@grimberg.me, maxg@mellanox.com, dledford@redhat.com, jgg@ziepe.ca, bvanassche@acm.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, target-devel@vger.kernel.org
Cc: "Alexander A. Klimov" <grandmaster@al2klimov.de>

Rationale:
Reduces attack surface on kernel devs opening the links for MITM
as HTTPS traffic is much harder to manipulate.

Deterministic algorithm:
For each file:
  If not .svg:
    For each line:
      If doesn't contain `\bxmlns\b`:
        For each link, `\bhttp://[^# \t\r\n]*(?:\w|/)`:
	  If neither `\bgnu\.org/license`, nor `\bmozilla\.org/MPL\b`:
            If both the HTTP and HTTPS versions
            return 200 OK and serve the same content:
              Replace HTTP with HTTPS.

Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
---
 Just drivers/infiniband. There's nothing for include/rdma.

 drivers/infiniband/ulp/iser/Kconfig | 2 +-
 drivers/infiniband/ulp/srp/Kconfig  | 2 +-
 drivers/infiniband/ulp/srpt/Kconfig | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/Kconfig b/drivers/infiniband/ulp/iser/Kconfig
index 3016a0c9a9f0..6ba73ae1291b 100644
--- a/drivers/infiniband/ulp/iser/Kconfig
+++ b/drivers/infiniband/ulp/iser/Kconfig
@@ -9,5 +9,5 @@ config INFINIBAND_ISER
 	  that speak iSCSI over iSER over InfiniBand.
 
 	  The iSER protocol is defined by IETF.
-	  See <http://www.ietf.org/rfc/rfc5046.txt>
+	  See <https://www.ietf.org/rfc/rfc5046.txt>
 	  and <http://members.infinibandta.org/kwspub/spec/Annex_iSER.PDF>
diff --git a/drivers/infiniband/ulp/srp/Kconfig b/drivers/infiniband/ulp/srp/Kconfig
index 67cd63d1399c..c33f4e5fa4d7 100644
--- a/drivers/infiniband/ulp/srp/Kconfig
+++ b/drivers/infiniband/ulp/srp/Kconfig
@@ -9,5 +9,5 @@ config INFINIBAND_SRP
 	  InfiniBand.
 
 	  The SRP protocol is defined by the INCITS T10 technical
-	  committee.  See <http://www.t10.org/>.
+	  committee.  See <https://www.t10.org/>.
 
diff --git a/drivers/infiniband/ulp/srpt/Kconfig b/drivers/infiniband/ulp/srpt/Kconfig
index 4b5d9b792cfa..f63b34d9ae32 100644
--- a/drivers/infiniband/ulp/srpt/Kconfig
+++ b/drivers/infiniband/ulp/srpt/Kconfig
@@ -10,4 +10,4 @@ config INFINIBAND_SRPT
 	  that supports the RDMA protocol. Currently the RDMA protocol is
 	  supported by InfiniBand and by iWarp network hardware. More
 	  information about the SRP protocol can be found on the website
-	  of the INCITS T10 technical committee (http://www.t10.org/).
+	  of the INCITS T10 technical committee (https://www.t10.org/).
-- 
2.27.0
