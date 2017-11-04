From: SF Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 04 Nov 2017 13:14:07 +0000
Subject: [PATCH 0/4] target: Adjustments for four function implementations
Message-Id: <27e27d42-473d-e8db-fe9e-803fed646881@users.sourceforge.net>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 4 Nov 2017 14:09:09 +0100

A few update suggestions were taken into account
from static source code analysis.

Markus Elfring (4):
  Use common error handling code in three functions
  Combine two condition checks into one statement in target_xcopy_do_work()
  Improve a size determination in three functions
  Delete an error message for a failed memory allocation in two functions

 drivers/target/target_core_xcopy.c | 69 ++++++++++++++++++--------------------
 1 file changed, 33 insertions(+), 36 deletions(-)

-- 
2.15.0

