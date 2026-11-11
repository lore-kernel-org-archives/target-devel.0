Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794380102;
	b=tvczoImhTsQpwUIzKNbIbZyYCksMDQGHdh0JzO5BX53egxkdd+4LprVuvb6mhM9ne8c+
	 8DePi/oV6q+fctOwMkopO23kAyGNjoW4eEh4BQHX94lc/XLTo35yVuNwx944CzKNsFh7u
	 LiSPm/3cgWPnA25DhD2ubASRjCBd+v4vmr5IFdRl06zacyo9zUlOouztOSscY3KayqqfN
	 u1isN3kE3UXfEQpC4Aii/inOhE8dBHFKrq4E0LVIaAdiUnSWBn7QSrYrRY00CgL5mtYc9
	 yrLqd5FHGbV9HMQYk0nXIZ0z94/LnvXV1T+Q0nr1sJsl2fpZUCS/WQRtavOMs/T/1wA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794380102;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9y/PRy7+nn0Am7DVlgAQyn6v6XmW7DI9L6qaUnk45TM=;
	b=getrGnyLgjMu4h6SKMpTHPeiEQCmhqOuqok8Axz148nnTeGkuHeeVzt4RuDdJsVHi3Yf
	 T9BmHBSCUfN+PDUUTa1xIi+ikPFQPnGyirvbz7MlKUYWysiLUzrydSHtl/IVPH3Kk5zl4
	 9zYDeMhx4VNYLqO0Xk6C3gx0fDiLywABHFH17d5YfY8fv6nR1s7gnpJJMj4jZQHjoZVUo
	 xH0IexIgoGBkrKw7GLxiul4PHTe/+qVM6CDZm0N5CWKAWdrbqCxF8gjYxy4JD0ivmjn49
	 iVcMNrGV9XLBUjx1HY8o6GZnKx9RGuJ2iInlQKHsZheXDaK1+cehH+WeaIZxFORwqwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="qfir/WSl";
	arc=none smtp.remote-ip=209.85.210.177
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74756606A31C
	for <target-devel@vger.kernel.org>; Wed, 11 Nov 2026 06:55:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 74756606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qfir/WSl
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8b66d1a08ccso2483536b3a.1
        for <target-devel@vger.kernel.org>; Tue, 10 Nov 2026 22:55:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794380102; x=1794984902; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9y/PRy7+nn0Am7DVlgAQyn6v6XmW7DI9L6qaUnk45TM=;
        b=qfir/WSle2PM9SFMTVzJehNsGJvWTuGeMycVEmpy2+bdv/B0nrlOe5RUUZjk8cUW/a
         1A/ZS2jNZ3zVO/0stmHXKxQK9U1VQknXoRvX7kApCr4l9rZvYeS6x8mYKl1Scku1CAXM
         fqNes2GIgQZ+P5UQToLEVP6sE0f3+BuPEBwz3q3yGkJd/XKPdgqekYnZXlWxjU8W8MMz
         ssFpYHnuGVERcem7iTupVyNHIzG8E2IqvWezS4/CpU61fHyFYXNQ7lai19/sAb2cmT41
         VkVfoLlc+XICqatPd7AbkOalN1XZbv9+YZx/+8GeCYmNehPi32nnFuKcff3lAij/1DQO
         cjLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794380102; x=1794984902;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9y/PRy7+nn0Am7DVlgAQyn6v6XmW7DI9L6qaUnk45TM=;
        b=w9KItEYSMnCyy0fADErL9av/gZQWZFtCQ1oU0G2sEzpUvqPH15GwFgKBEeSOLWytRL
         1SZKCnz6JNXvfQfaG8laMh9a5APOfRE/7FVomB6ezTnR8nPbsvzv2/xfJ7X1vSautQ08
         9AtdPFGP+2XPlnNM0nCGlJ8CTDmmF2UtOrEjbkvsPr5o0bkpbGMBzKRzFOAsTs2FT38Z
         qemzLVVGJ9lkF+Qs/s/UtLmdHRybHlN9clrbh+OhgyiITPiwLUYvexCtxK6W1EOZdCOs
         7AFMIbkwx2W/O3dqndf2DP2HDWjNrzmr2c8q730+EKX2qeygdzVOZJEZNnFgtYXjBAO1
         O9og==
X-Forwarded-Encrypted: i=1; AL+hErEM2vYNz9fDbQFOy3Xwi7YEVdbaHAEqQo4DBGZq34XG/j5mvP1N5sr4/yQSa0AJROdVtea8icrNDVor1LM=@vger.kernel.org
X-Gm-Message-State: APuU4Z9AKO9g7AzntO3JwaHbsJzJ5q4kKiox96K7xIV02bapzQYMYuuS
	aUqCvCZVswB67GsQ9wvLieT6cuJSse+m4JEYwZr6GHyNkFGRELy1idOI
X-Gm-Gg: AYBFou2DXbcnyZ3L3b2gE4kYOemjDibwlUq0kBtzdk+GkHbmY08EzZedNBSCgIaAvjY
	YGsA50WLQtzWCkDGgQyDX3uyZRygpktMWxvuzEaFi+x/BIllrkeAPgZNqwSQ4cJ1pSX9fGfTSv0
	A+enR7WYRNOatFwtEaLfhv8GvjcNNnJAH2dhMdsXLHRCy9onIR7Tmrvx0G4Cg8e9IG3fgZrm0YQ
	45mQXMr7b79qiKltwY1UyEa1uAsLkGv/MM4QsnlNjk6bWygDFO3GJHROp9IP9qzGnKtyldamp7D
	dkWmeQJrhlKW8rIqEKhI/7NatVc50zSpXC1DQwFSzzN8FqA+y/ullSsmorefAqG9cRfSRwVMkoA
	ZmV9SEV6uh5C07sbfgy2fREMwzCasqxXZ4H4HB1Dor26gqfvkMazBaLcD223R2wFO/RGBb1PgCY
	TTiIELSLVShz1veZISl6DI2svtKchJJQ5oPJoT5cplwXwBEKuA9ObxKm47r2ADEVM/ezTEwgbk/
	0IIapFr11t56eqYLEtx88FAWBVQBfUwu0YuBlSogFrEjeyEvda8nQAYEY8Mf7wcFlM+egD68PbZ
	QuFdbKNkH2PCAVbqBca8AZmwEfl+WRvtZciWMIj31Hy1G4Ay50N/FuRdcwQMViU=
X-Received: by 2002:a05:6a00:21cd:b0:892:e080:4edb with SMTP id d2e1a72fcca58-8bc1d9122a6mr1712975b3a.60.1794380097046;
        Tue, 10 Nov 2026 22:54:57 -0800 (PST)
Received: from localhost.localdomain ([183.62.176.219])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baa7bf82b1sm1823362b3a.8.2026.11.10.22.54.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 22:54:56 -0800 (PST)
From: liuyong <pkfxxxing@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	security@kernel.org
Subject: [PATCH v3] RDMA/srpt: Prevent uninitialized read buffer disclosure
Date: Wed, 11 Nov 2026 14:53:40 +0800
Message-ID: <20261111065342.1282709-1-pkfxxxing@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261110052827.963143-1-pkfxxxing@gmail.com>
References: <20261110030809.913063-1-pkfxxxing@gmail.com> <20261110030809.913063-2-pkfxxxing@gmail.com> <20261110052827.963143-1-pkfxxxing@gmail.com>
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

SRPT allocates read buffers and creates RDMA contexts from the
initiator's descriptors before parsing the CDB. When target core reduces
cmd->data_length, a backend such as rd_mcp fills only the shorter
length, but the prebuilt RDMA transfer still sends the full buffer. This
can disclose stale target kernel memory to a remote initiator with
access to the LUN.

Reject indirect descriptor tables whose direct descriptor lengths do not
sum to the advertised total before allocating RDMA contexts. Also
initialize commands rejected during descriptor parsing so the BUSY
response path has valid callbacks and a command reference.

Save the original buffer length and zero any read tail beyond
cmd->data_length before posting the existing RDMA transfers. Synchronize
each mapped SG list for device access after zeroing.

The issue was discovered by Qihoo 360's Tulongfeng multi-agent system.

Fixes: b99f8e4d7bcd ("IB/srpt: convert to the generic RDMA READ/WRITE API")
Cc: stable@vger.kernel.org
Suggested-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: liuyong <pkfxxxing@gmail.com>
---
Developed against f66469d9905b39d2c260a15d7d6db450f4db67c1 (7.4-rc1).

 drivers/infiniband/ulp/srpt/ib_srpt.c | 41 +++++++++++++++++++++++++++
 drivers/infiniband/ulp/srpt/ib_srpt.h |  2 ++
 2 files changed, 43 insertions(+)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 43c3ff1ad8..0bef01e20c 100644
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
@@ -2866,6 +2879,31 @@ static u8 tcm_to_srp_tsk_mgmt_status(const int tcm_mgmt_status)
 	return SRP_TSK_MGMT_FAILED;
 }
 
+static void srpt_zero_read_tail(struct srpt_send_ioctx *ioctx)
+{
+	struct ib_device *dev = ioctx->ch->sport->sdev->device;
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
+
+		if (!ib_uses_virt_dma(dev))
+			dma_sync_sg_for_device(dev->dma_device, ctx->sg,
+					       ctx->nents, DMA_TO_DEVICE);
+	}
+}
+
 /**
  * srpt_queue_response - transmit the response to a SCSI command
  * @cmd: SCSI target command.
@@ -2907,6 +2945,9 @@ static void srpt_queue_response(struct se_cmd *cmd)
 	if (ioctx->cmd.data_direction == DMA_FROM_DEVICE &&
 	    ioctx->cmd.data_length &&
 	    !ioctx->queue_status_only) {
+		if (ioctx->buf_len > cmd->data_length)
+			srpt_zero_read_tail(ioctx);
+
 		for (i = ioctx->n_rw_ctx - 1; i >= 0; i--) {
 			struct srpt_rw_ctx *ctx = &ioctx->rw_ctxs[i];
 
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

