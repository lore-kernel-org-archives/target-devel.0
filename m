Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794476554;
	b=R66OJIW4pKnb8TqQ97ek6WXPCbyFePV3djRJHfK3nNSWXzZIyCtr28Qh5VtDYcGblPON
	 fCqArENUlXKtBNhY9QPFMEE2zCTJKH4At+OoAAyfQvaeFP3YxtAkH04eFCsve47vYW0+i
	 LEmMkWHaEukxf8YXG4qySNyVGQ0fo3ZMGVMxG275dQaXr6s0RvcmeaLVDWiJG66kklwTm
	 1BjJoRWjtMbSliGykt/R3WD0wqz7vgDU2ShUcBVM0orOaPMOC/IOQZ7og7M3hvL3Zj/2f
	 inl7UDlhV5315VdD/gl89bDKNSPizetcxFqZ50/F3fybHGO9VVZbQXrVPB9tFfDePWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794476554;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GTBA18JOWQoqxmchbhKPxOkv4PhMrzj8DppFkmldNNY=;
	b=L7pO/wHUb2VbKhHNHbkGq6Jguj6OzioBmkuiKL0rNqBpIGovycniCZyt01ng7JmFC5gn
	 tNg44O15ST64vy59IXNcI7Cf9yb8nosF4h88Z04y2zgWMs6soYzyzKnVLi18mctwa9flp
	 2HFAWiXRaaS7qrh0Cq3hkYks1emTMtWBcDJvmxmHAhD8BfGLVdLGB3gBVMcuOf3nxEe0E
	 Pz+Ud8u89rEij4Ug72SdHo7xcja4xbGFvHb+r1VSY2UzZPVH4GSh5MhF3TGqqMgz4B++f
	 NOD7NM5Ko6dDIzvEJPDLmMeMnNavHP6mktWykbKXqr+tls11n8sAB7sGlhGg+DAGLAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rAPFnoHI;
	arc=none smtp.remote-ip=74.125.82.41
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E07606A32A
	for <target-devel@vger.kernel.org>; Thu, 12 Nov 2026 09:42:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A1E07606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rAPFnoHI
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-15dd124bbe7so6423933c88.1
        for <target-devel@vger.kernel.org>; Thu, 12 Nov 2026 01:42:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794476553; x=1795081353; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GTBA18JOWQoqxmchbhKPxOkv4PhMrzj8DppFkmldNNY=;
        b=rAPFnoHIsbGNfDSv9jotfyB0/qKorAoRbkeKBXmB4EXsH71j8nZ1gKX8EOOos0Sowt
         WDxjVN3kjS2r4mbBevm5WsXOc/d/bok51BYDgqsVa1SxuIdSevDfTE/fgPr2mRw99Spw
         TSDq+g8KcP8aH8EOAoEF61W/kplwlov9Vcf25USfDpPti3KUNDk8Zk38SPTUboK0EJhs
         uSY5iWq21wueHBK46vJ6pxoPYuKVxCMdBSDiN6b8NPHNTlfGYjFa2grMGeWkNRUTXQ5v
         6VTXJ7BSpGQah8nckly4oIA3MipYmkUywvxpTbqnTpc5VU2O02xDnxX4ze9CvPc+dNxi
         RT9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794476553; x=1795081353;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GTBA18JOWQoqxmchbhKPxOkv4PhMrzj8DppFkmldNNY=;
        b=VLe6NG8wQfNlUZQcovR4vHwOXRcnsMTxRUOh7FmSnL0yIPAIbdMKOHTWwlbVk5LItF
         7QnnH4TxHs/Yqe39Zqh17rnKu9xQnKTEl+LyOrQK9xfYOylURatOoP4OWd/1EJ+vttsN
         A+nQSbGP6MbmWXqITfxCPpXqmIJt7yOa9nddkDKf1Z/9xL70XAElXWqMJMVHEgtK2nH6
         Mp5Y8s92Yb+MNHtmM/wm7KyVIgDbdbQHBZlS8nCUDp0hB1uZR7d6K7m1rQrw+40vfxRy
         JWaecaARx/o1V4geUn9cfZp8mYHGsg+UNR/qGkkDYhQTW5s67AkoMyXa96E2qyF6t6rS
         TWIg==
X-Forwarded-Encrypted: i=1; AL+hErHmGOIlMFsbIr0XmQhdDP6UbjGcBITIlDTPEtB9rDd0cTHXKGlrgOf8gMsr+1dC99BW4SuJ47y19zq0OMc=@vger.kernel.org
X-Gm-Message-State: APuU4Z+VPUOo4fqpou1BQR89XX0CRwswKvfeZxfU0h6f0Unow0lErkk1
	AEaY7+WJoxQ0ErFAh9ytq4jL+Z1QQvT8RhknyZgZ5TixgvrVmzZGkISX
X-Gm-Gg: AYBFou37Gqxl53vBBNAmIfalKCxMsZKwatnM0nvweD4E95GoeNbOgnOT1Ynoqbgo0DD
	gvmK3ACUKqOa4GJrmlxJuYhPQZ2eRwKa9dMaduFINceuRXlKqneARUzJ4mRdTBL/utGmms+f1CJ
	dVmm2AJkPIN1obKJEgFqn1kX/b/2rKKwlaiSDjIAXMs6aV7ZVyHFe4Jm3lGTdEXsGfR+kLqoYHZ
	Tw+wkPG2dKDTPE3rJtchclrL9Byz/i3NdgHFgq1B8+s8u81PUY12z/FYbl29Ml57va6o0ITchyj
	tDIzvylwXaz3VMFLa4sWLMbpE2Bi8PCiCDwQUAFSCfOgJIx8wUH+SxSIM6MFBLlV5GMGUvBaQP7
	LHcQWLNEe5oV81W4qPFbrGncAU+mFUYa9NW9WerXovpW7iI2llTGv/mdJc88UW3nk/PUNXy6nu8
	nY+1qUpsODcVvfhNk3enTx+5WFl10nrTZbtjTniSsRFSzMnBS9Phx+vc9nT+ug13/Rf8Hx6YA7p
	2bTlML4rjzGFS1dLMj+SDZDG/sw1L/NVR2YLKfQUW+2x74KSJ3ZkscqqQEeb1rIpbPh3h9APY/R
	3ITEVVMgOzUFyvqUgUN1cDfLhUH1//1OLu4uBLI=
X-Received: by 2002:a05:7023:888:b0:1a7:78a3:bda8 with SMTP id a92af1059eb24-1b3c0324732mr4909368c88.27.1794476552314;
        Thu, 12 Nov 2026 01:42:32 -0800 (PST)
Received: from localhost.localdomain ([223.104.79.0])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3b5b20c55sm22293829c88.8.2026.11.12.01.42.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 01:42:31 -0800 (PST)
From: liuyong <pkfxxxing@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Yong Liu <pkfxxxing@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	security@kernel.org
Subject: [PATCH v4] RDMA/srpt: Prevent uninitialized read buffer disclosure
Date: Thu, 12 Nov 2026 17:41:36 +0800
Message-ID: <20261112094138.1390409-1-pkfxxxing@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261111065342.1282709-1-pkfxxxing@gmail.com>
References: <20261110030809.913063-1-pkfxxxing@gmail.com> <20261110030809.913063-2-pkfxxxing@gmail.com> <20261110052827.963143-1-pkfxxxing@gmail.com> <20261111065342.1282709-1-pkfxxxing@gmail.com>
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Post: <mailto:target-devel@vger.kernel.org>
List-Help: <mailto:target-devel+help@vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:target-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yong Liu <pkfxxxing@gmail.com>

SRPT allocates read buffers and creates RDMA contexts from the
initiator's descriptors before parsing the CDB. When target core reduces
cmd->data_length, a backend such as rd_mcp fills only the shorter
length, but the prebuilt RDMA transfer still sends the full buffer.
Control CDB handlers can also leave bytes within cmd->data_length
unwritten, while target core only clears the first SG entry of these
preallocated buffers. Both cases can disclose stale target kernel memory
to a remote initiator with access to the LUN.

Reject indirect descriptor tables whose direct descriptor lengths do not
sum to the advertised total before allocating RDMA contexts. Also
initialize commands rejected during descriptor parsing so the BUSY
response path has valid callbacks and a command reference.

Save the original buffer length and zero the entire control read buffer
before command execution. For data READs, zero any tail beyond
cmd->data_length before posting the existing RDMA transfers. Synchronize
each mapped SG list for device access in the response path.

The issue was discovered by Qihoo 360's Tulongfeng multi-agent system.

Fixes: b99f8e4d7bcd ("IB/srpt: convert to the generic RDMA READ/WRITE API")
Fixes: 8b8807b9e982 ("scsi: RDMA/srpt: Fix handling of command / TMF submission failure")
Cc: stable@vger.kernel.org
Suggested-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Yong Liu <pkfxxxing@gmail.com>
---
Changes in v4 (addressing the three issues reported by sashiko-bot):
- Zero the entire original control read buffer before command execution.
  Limit tail zeroing to data READs and synchronize mapped SG lists in
  the RDMA submission loop.
- Use Yong Liu in the author and Signed-off-by fields.
- Add the Fixes tag for the descriptor-parsing BUSY path initialization.

Developed against f66469d9905b39d2c260a15d7d6db450f4db67c1 (7.4-rc1).

 drivers/infiniband/ulp/srpt/ib_srpt.c | 48 +++++++++++++++++++++++++++
 drivers/infiniband/ulp/srpt/ib_srpt.h |  2 ++
 2 files changed, 50 insertions(+)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 43c3ff1ad8..0ec230950b 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -41,6 +41,7 @@
 #include <linux/kthread.h>
 #include <linux/string.h>
 #include <linux/delay.h>
+#include <linux/dma-mapping.h>
 #include <linux/atomic.h>
 #include <linux/inet.h>
 #include <rdma/ib_cache.h>
@@ -1115,8 +1116,10 @@ static int srpt_get_desc_tbl(struct srpt_recv_ioctx *recv_ioctx,
 	} else if (((srp_cmd->buf_fmt & 0xf) == SRP_DATA_DESC_INDIRECT) ||
 		   ((srp_cmd->buf_fmt >> 4) == SRP_DATA_DESC_INDIRECT)) {
 		struct srp_indirect_buf *idb = srpt_get_desc_buf(srp_cmd);
+		u64 total_len = 0;
 		int nbufs = be32_to_cpu(idb->table_desc.len) /
 				sizeof(struct srp_direct_buf);
+		int i;
 
 		if (nbufs >
 		    (srp_cmd->data_out_desc_cnt + srp_cmd->data_in_desc_cnt)) {
@@ -1128,6 +1131,11 @@ static int srpt_get_desc_tbl(struct srpt_recv_ioctx *recv_ioctx,
 			return -EINVAL;
 		}
 
+		for (i = 0; i < nbufs; i++)
+			total_len += be32_to_cpu(idb->desc_list[i].len);
+		if (total_len != be32_to_cpu(idb->len))
+			return -EINVAL;
+
 		*data_len = be32_to_cpu(idb->len);
 		return srpt_alloc_rw_ctxs(ioctx, idb->desc_list, nbufs,
 				sg, sg_cnt);
@@ -1304,6 +1312,7 @@ static struct srpt_send_ioctx *srpt_get_send_ioctx(struct srpt_rdma_ch *ch)
 	WARN_ON_ONCE(ioctx->recv_ioctx);
 	ioctx->n_rdma = 0;
 	ioctx->n_rw_ctx = 0;
+	ioctx->buf_len = 0;
 	ioctx->queue_status_only = false;
 	/*
 	 * transport_init_se_cmd() does not initialize all fields, so do it
@@ -1597,9 +1606,13 @@ static void srpt_handle_cmd(struct srpt_rdma_ch *ch,
 			pr_err("0x%llx: parsing SRP descriptor table failed.\n",
 			       srp_cmd->tag);
 		}
+		target_init_cmd(cmd, ch->sess, &send_ioctx->sense_data[0],
+				scsilun_to_int(&srp_cmd->lun), 0,
+				cmd->sam_task_attr, dir, 0);
 		goto busy;
 	}
 
+	send_ioctx->buf_len = data_len;
 	rc = target_init_cmd(cmd, ch->sess, &send_ioctx->sense_data[0],
 			     scsilun_to_int(&srp_cmd->lun), data_len,
 			     cmd->sam_task_attr, dir, TARGET_SCF_ACK_KREF);
@@ -1613,6 +1626,11 @@ static void srpt_handle_cmd(struct srpt_rdma_ch *ch,
 			       GFP_KERNEL))
 		return;
 
+	/* Control CDB handlers may leave part of the response untouched. */
+	if (cmd->data_direction == DMA_FROM_DEVICE &&
+	    !(cmd->se_cmd_flags & SCF_SCSI_DATA_CDB))
+		sg_zero_buffer(sg, sg_cnt, send_ioctx->buf_len, 0);
+
 	target_submit(cmd);
 	return;
 
@@ -2866,6 +2884,26 @@ static u8 tcm_to_srp_tsk_mgmt_status(const int tcm_mgmt_status)
 	return SRP_TSK_MGMT_FAILED;
 }
 
+static void srpt_zero_read_tail(struct srpt_send_ioctx *ioctx)
+{
+	u32 data_len = ioctx->cmd.data_length;
+	int i;
+
+	for (i = 0; i < ioctx->n_rw_ctx; i++) {
+		struct srpt_rw_ctx *ctx = &ioctx->rw_ctxs[i];
+		struct scatterlist *sg;
+		unsigned int j;
+
+		for_each_sg(ctx->sg, sg, ctx->nents, j) {
+			u32 skip = min(data_len, sg->length);
+
+			data_len -= skip;
+			if (skip < sg->length)
+				sg_zero_buffer(sg, 1, sg->length - skip, skip);
+		}
+	}
+}
+
 /**
  * srpt_queue_response - transmit the response to a SCSI command
  * @cmd: SCSI target command.
@@ -2907,9 +2945,19 @@ static void srpt_queue_response(struct se_cmd *cmd)
 	if (ioctx->cmd.data_direction == DMA_FROM_DEVICE &&
 	    ioctx->cmd.data_length &&
 	    !ioctx->queue_status_only) {
+		if ((cmd->se_cmd_flags & SCF_SCSI_DATA_CDB) &&
+		    ioctx->buf_len > cmd->data_length)
+			srpt_zero_read_tail(ioctx);
+
 		for (i = ioctx->n_rw_ctx - 1; i >= 0; i--) {
 			struct srpt_rw_ctx *ctx = &ioctx->rw_ctxs[i];
 
+			/* Make CPU writes and zeroed data visible to the RDMA device. */
+			if (!ib_uses_virt_dma(sdev->device))
+				dma_sync_sg_for_device(sdev->device->dma_device,
+						       ctx->sg, ctx->nents,
+						       DMA_TO_DEVICE);
+
 			first_wr = rdma_rw_ctx_wrs(&ctx->rw, ch->qp,
 					ch->sport->port, NULL, first_wr);
 		}
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 506c11b843..78bba74148 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -204,6 +204,7 @@ struct srpt_rw_ctx {
  * @rdma_cqe:    RDMA completion queue element.
  * @state:       I/O context state.
  * @cmd:         Target core command data structure.
+ * @buf_len:     Original SRP data buffer length.
  * @sense_data:  SCSI sense data.
  * @n_rdma:      Number of work requests needed to transfer this ioctx.
  * @n_rw_ctx:    Size of rw_ctxs array.
@@ -223,6 +224,7 @@ struct srpt_send_ioctx {
 	struct ib_cqe		rdma_cqe;
 	enum srpt_command_state	state;
 	struct se_cmd		cmd;
+	u32			buf_len;
 	u8			n_rdma;
 	u8			n_rw_ctx;
 	bool			queue_status_only;
-- 
2.43.0

