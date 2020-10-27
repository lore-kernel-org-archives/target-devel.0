From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date: Tue, 27 Oct 2020 09:51:24 +0000
Subject: [PATCH v3 20/32] IB/srpt: docs: add a description for cq_size member
Message-Id: <df0e5f0e866b91724299ef569a2da8115e48c0cf.1603791716.git.mchehab+huawei@kernel.org>
List-Id: <target-devel.vger.kernel.org>
References: <cover.1603791716.git.mchehab+huawei@kernel.org>
In-Reply-To: <cover.1603791716.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>, Bart Van Assche <bvanassche@acm.org>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Max Gurtovoy <maxg@mellanox.com>, Sagi Grimberg <sagi@grimberg.me>, Yamin Friedman <yaminf@mellanox.com>, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, Brendan Higgins <brendanhiggins@google.com>

Changeset c804af2c1d31 ("IB/srpt: use new shared CQ mechanism")
added a new member for struct srpt_rdma_ch, but didn't add the
corresponding kernel-doc markup, as repoted when doing
"make htmldocs":

	./drivers/infiniband/ulp/srpt/ib_srpt.h:331: warning: Function parameter or member 'cq_size' not described in 'srpt_rdma_ch'

Add a description for it.

Fixes: c804af2c1d31 ("IB/srpt: use new shared CQ mechanism")
Reviewed-by: Brendan Higgins <brendanhiggins@google.com>
Tested-by: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 41435a699b53..bdeb010efee6 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -256,6 +256,7 @@ enum rdma_ch_state {
  * @rdma_cm:	   See below.
  * @rdma_cm.cm_id: RDMA CM ID associated with the channel.
  * @cq:            IB completion queue for this channel.
+ * @cq_size:	   Number of CQEs in @cq.
  * @zw_cqe:	   Zero-length write CQE.
  * @rcu:           RCU head.
  * @kref:	   kref for this channel.
-- 
2.26.2
