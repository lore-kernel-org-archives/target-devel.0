From: Sasha Levin <sashal@kernel.org>
Date: Wed, 26 Dec 2018 22:41:24 +0000
Subject: [PATCH AUTOSEL 4.9 17/35] scsi: target: iscsi: cxgbit: add missing spin_lock_init()
Message-Id: <20181226224142.150866-17-sashal@kernel.org>
List-Id: <target-devel.vger.kernel.org>
References: <20181226224142.150866-1-sashal@kernel.org>
In-Reply-To: <20181226224142.150866-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Varun Prakash <varun@chelsio.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

From: Varun Prakash <varun@chelsio.com>

[ Upstream commit 9e6371d3c6913ff1707fb2c0274c9925f7aaef80 ]

Add missing spin_lock_init() for cdev->np_lock.

Signed-off-by: Varun Prakash <varun@chelsio.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/iscsi/cxgbit/cxgbit_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/target/iscsi/cxgbit/cxgbit_main.c b/drivers/target/iscsi/cxgbit/cxgbit_main.c
index ad26b9372f10..d55261e1d522 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_main.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_main.c
@@ -58,6 +58,7 @@ static void *cxgbit_uld_add(const struct cxgb4_lld_info *lldi)
 		return ERR_PTR(-ENOMEM);
 
 	kref_init(&cdev->kref);
+	spin_lock_init(&cdev->np_lock);
 
 	cdev->lldi = *lldi;
 
-- 
2.19.1
