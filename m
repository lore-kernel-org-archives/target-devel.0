From: "Alexander A. Klimov" <grandmaster@al2klimov.de>
Date: Thu, 09 Jul 2020 19:48:20 +0000
Subject: [PATCH] SCSI RDMA PROTOCOL (SRP) TARGET: Replace HTTP links with HTTPS ones
Message-Id: <20200709194820.27032-1-grandmaster@al2klimov.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: bvanassche@acm.org, dledford@redhat.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
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
 Continuing my work started at 93431e0607e5.
 See also: git log --oneline '--author=Alexander A. Klimov <grandmaster@al2klimov.de>' v5.7..master
 (Actually letting a shell for loop submit all this stuff for me.)

 If there are any URLs to be removed completely or at least not HTTPSified:
 Just clearly say so and I'll *undo my change*.
 See also: https://lkml.org/lkml/2020/6/27/64

 If there are any valid, but yet not changed URLs:
 See: https://lkml.org/lkml/2020/6/26/837

 If you apply the patch, please let me know.


 drivers/infiniband/ulp/srpt/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
