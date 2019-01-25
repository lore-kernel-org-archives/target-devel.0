From: Bart Van Assche <bvanassche@acm.org>
Date: Fri, 25 Jan 2019 18:34:50 +0000
Subject: [PATCH 08/16] RDMA/srpt: Rework I/O context allocation
Message-Id: <20190125183458.220477-9-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Instead of maintaining a list of free I/O contexts, use an sbitmap
data structure to track which I/O contexts are in use and which are
free. This makes the ib_srpt driver more consistent with other LIO
drivers.

Cc: Doug Ledford <dledford@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 47 +++++++++++----------------
 drivers/infiniband/ulp/srpt/ib_srpt.h |  4 ---
 2 files changed, 19 insertions(+), 32 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 0dc2df925f76..d426e01905f9 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1217,22 +1217,15 @@ static int srpt_ch_qp_err(struct srpt_rdma_ch *ch)
 static struct srpt_send_ioctx *srpt_get_send_ioctx(struct srpt_rdma_ch *ch)
 {
 	struct srpt_send_ioctx *ioctx;
-	unsigned long flags;
+	int tag, cpu;
 
 	BUG_ON(!ch);
 
-	ioctx = NULL;
-	spin_lock_irqsave(&ch->spinlock, flags);
-	if (!list_empty(&ch->free_list)) {
-		ioctx = list_first_entry(&ch->free_list,
-					 struct srpt_send_ioctx, free_list);
-		list_del(&ioctx->free_list);
-	}
-	spin_unlock_irqrestore(&ch->spinlock, flags);
-
-	if (!ioctx)
-		return ioctx;
+	tag = sbitmap_queue_get(&ch->sess->sess_tag_pool, &cpu);
+	if (tag < 0)
+		return NULL;
 
+	ioctx = ch->ioctx_ring[tag];
 	BUG_ON(ioctx->ch != ch);
 	ioctx->state = SRPT_STATE_NEW;
 	WARN_ON_ONCE(ioctx->recv_ioctx);
@@ -1245,6 +1238,8 @@ static struct srpt_send_ioctx *srpt_get_send_ioctx(struct srpt_rdma_ch *ch)
 	 */
 	memset(&ioctx->cmd, 0, sizeof(ioctx->cmd));
 	memset(&ioctx->sense_data, 0, sizeof(ioctx->sense_data));
+	ioctx->cmd.map_tag = tag;
+	ioctx->cmd.map_cpu = cpu;
 
 	return ioctx;
 }
@@ -2148,7 +2143,7 @@ static int srpt_cm_req_recv(struct srpt_device *const sdev,
 	struct srpt_rdma_ch *ch = NULL;
 	char i_port_id[36];
 	u32 it_iu_len;
-	int i, ret;
+	int i, tag_num, tag_size, ret;
 
 	WARN_ON_ONCE(irqs_disabled());
 
@@ -2248,11 +2243,8 @@ static int srpt_cm_req_recv(struct srpt_device *const sdev,
 		goto free_rsp_cache;
 	}
 
-	INIT_LIST_HEAD(&ch->free_list);
-	for (i = 0; i < ch->rq_size; i++) {
+	for (i = 0; i < ch->rq_size; i++)
 		ch->ioctx_ring[i]->ch = ch;
-		list_add_tail(&ch->ioctx_ring[i]->free_list, &ch->free_list);
-	}
 	if (!sdev->use_srq) {
 		u16 imm_data_offset = req->req_flags & SRP_IMMED_REQUESTED ?
 			be16_to_cpu(req->imm_data_offset) : 0;
@@ -2306,18 +2298,20 @@ static int srpt_cm_req_recv(struct srpt_device *const sdev,
 
 	pr_debug("registering session %s\n", ch->sess_name);
 
+	tag_num = ch->rq_size;
+	tag_size = 1; /* ib_srpt does not use se_sess->sess_cmd_map */
 	if (sport->port_guid_tpg.se_tpg_wwn)
-		ch->sess = target_setup_session(&sport->port_guid_tpg, 0, 0,
-						TARGET_PROT_NORMAL,
+		ch->sess = target_setup_session(&sport->port_guid_tpg, tag_num,
+						tag_size, TARGET_PROT_NORMAL,
 						ch->sess_name, ch, NULL);
 	if (sport->port_gid_tpg.se_tpg_wwn && IS_ERR_OR_NULL(ch->sess))
-		ch->sess = target_setup_session(&sport->port_gid_tpg, 0, 0,
-					TARGET_PROT_NORMAL, i_port_id, ch,
-					NULL);
+		ch->sess = target_setup_session(&sport->port_gid_tpg, tag_num,
+					tag_size, TARGET_PROT_NORMAL, i_port_id,
+					ch, NULL);
 	/* Retry without leading "0x" */
 	if (sport->port_gid_tpg.se_tpg_wwn && IS_ERR_OR_NULL(ch->sess))
-		ch->sess = target_setup_session(&sport->port_gid_tpg, 0, 0,
-						TARGET_PROT_NORMAL,
+		ch->sess = target_setup_session(&sport->port_gid_tpg, tag_num,
+						tag_size, TARGET_PROT_NORMAL,
 						i_port_id + 2, ch, NULL);
 	if (IS_ERR_OR_NULL(ch->sess)) {
 		WARN_ON_ONCE(ch->sess = NULL);
@@ -3279,7 +3273,6 @@ static void srpt_release_cmd(struct se_cmd *se_cmd)
 				struct srpt_send_ioctx, cmd);
 	struct srpt_rdma_ch *ch = ioctx->ch;
 	struct srpt_recv_ioctx *recv_ioctx = ioctx->recv_ioctx;
-	unsigned long flags;
 
 	WARN_ON_ONCE(ioctx->state != SRPT_STATE_DONE &&
 		     !(ioctx->cmd.transport_state & CMD_T_ABORTED));
@@ -3295,9 +3288,7 @@ static void srpt_release_cmd(struct se_cmd *se_cmd)
 		ioctx->n_rw_ctx = 0;
 	}
 
-	spin_lock_irqsave(&ch->spinlock, flags);
-	list_add(&ioctx->free_list, &ch->free_list);
-	spin_unlock_irqrestore(&ch->spinlock, flags);
+	target_free_tag(se_cmd->se_sess, se_cmd);
 }
 
 /**
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 39b3e50baf3d..ee9f20e9177a 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -207,7 +207,6 @@ struct srpt_rw_ctx {
  * @rw_ctxs:     RDMA read/write contexts.
  * @imm_sg:      Scatterlist for immediate data.
  * @rdma_cqe:    RDMA completion queue element.
- * @free_list:   Node in srpt_rdma_ch.free_list.
  * @state:       I/O context state.
  * @cmd:         Target core command data structure.
  * @sense_data:  SCSI sense data.
@@ -227,7 +226,6 @@ struct srpt_send_ioctx {
 	struct scatterlist	imm_sg;
 
 	struct ib_cqe		rdma_cqe;
-	struct list_head	free_list;
 	enum srpt_command_state	state;
 	struct se_cmd		cmd;
 	u8			n_rdma;
@@ -277,7 +275,6 @@ enum rdma_ch_state {
  * @req_lim_delta: Number of credits not yet sent back to the initiator.
  * @imm_data_offset: Offset from start of SRP_CMD for immediate data.
  * @spinlock:      Protects free_list and state.
- * @free_list:     Head of list with free send I/O contexts.
  * @state:         channel state. See also enum rdma_ch_state.
  * @using_rdma_cm: Whether the RDMA/CM or IB/CM is used for this channel.
  * @processing_wait_list: Whether or not cmd_wait_list is being processed.
@@ -318,7 +315,6 @@ struct srpt_rdma_ch {
 	atomic_t		req_lim_delta;
 	u16			imm_data_offset;
 	spinlock_t		spinlock;
-	struct list_head	free_list;
 	enum rdma_ch_state	state;
 	struct kmem_cache	*rsp_buf_cache;
 	struct srpt_send_ioctx	**ioctx_ring;
-- 
2.20.1.495.gaa96b0ce6b-goog
