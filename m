From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Date: Fri, 03 Apr 2020 14:32:12 +0000
Subject: [PATCH 0/2] target: make TRANSPORT_FLAG_PASSTHTROUGH_PGR/_ALUA changeable
Message-Id: <20200403143214.18303-1-bstroesser@ts.fujitsu.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hi,

By making TRANSPORT_FLAG_PASSTHTROUGH_PGR/_ALUA writeable via
attributes, this small series of patches will allow to have full
passthrough in TCMU including pr and alua.

It also allows to switch off pr passthrough in pscsi, which enables
pr support from core.

Best regards,
Bodo
