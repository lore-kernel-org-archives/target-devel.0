From: Roman Pen <roman.penyaev@profitbricks.com>
Date: Mon, 04 Jun 2018 12:29:55 +0000
Subject: [PATCH v2 0/8] use ib_client API to wrap ib_device
Message-Id: <20180604123003.24748-1-roman.penyaev@profitbricks.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hi all,

This is a second patchset which uses ib_client API in order to wrap
ib_device with a specific ULP device, which is created on add() callback
and destroyed on remove().  Patches change initiator and target sides
for NVMEoRDMA and ISER.  Changes do not bring anything in terms of LoC
but extra mutexes and lists are vanished, since ib_client API does
required locking internally.

Also would be nice to avoid refcounting and synchronization in ISER
case, but ULP ib_clients remove() callback is called before cma_client,
thus ULP device should be alive till last reference put (NVMe queues
explicit delete works with workqueue flush, which guarantees us that
nvme_dev_dev_put() puts last reference in remove() callback).

The following are the minor fixes since previous RFC:

  NVMe:
    o Keep IB_DEVICE_MEM_MGT_EXTENSIONS check in nvme_rdma_alloc_device().
    o No WARN_ON if nvme[t]_rdma_alloc_device() failed, just a log output.
	
  iSER[t]:
    o Rename ib_client.name from "iser[t]_rdma_ib" to "iser[t]_ib_client".
    o Move all refcount changes to separate patches.

Roman Pen (8):
  nvme-rdma: use ib_client API to wrap ib_device
  nvmet-rdma: wrap raw kref_get/put() with corresponding helpers
  nvmet-rdma: use ib_client API to wrap ib_device
  IB/iser: use refcount_t instead of just a raw integer
  IB/iser: use ib_client API to wrap ib_device
  IB/isert: embed mutex inside isert_device structure
  IB/isert: use refcount_t instead of just a raw integer
  IB/isert: use ib_client API to wrap ib_device

 drivers/infiniband/ulp/iser/iscsi_iser.c |  21 ++++--
 drivers/infiniband/ulp/iser/iscsi_iser.h |  14 ++--
 drivers/infiniband/ulp/iser/iser_verbs.c |  73 +++++++++++++--------
 drivers/infiniband/ulp/isert/ib_isert.c  | 109 ++++++++++++++++++++-----------
 drivers/infiniband/ulp/isert/ib_isert.h  |   4 +-
 drivers/nvme/host/rdma.c                 |  82 +++++++++++------------
 drivers/nvme/target/rdma.c               |  87 ++++++++++++------------
 7 files changed, 227 insertions(+), 163 deletions(-)

Signed-off-by: Roman Pen <roman.penyaev@profitbricks.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Steve Wise <swise@opengridcomputing.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Doug Ledford <dledford@redhat.com>
Cc: target-devel@vger.kernel.org
Cc: linux-nvme@lists.infradead.org
-- 
2.13.1

