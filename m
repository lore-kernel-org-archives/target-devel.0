Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794559235;
	b=wOvjM/cMhlkeOltzeCUnNBrJOCbKVkipE5wDvv8pMMSxqJ40kcRqHJf2nN9+rEn41KWH
	 iOhLKJS0RW8kZeNg0pmu/9ZjL6XpTS2Q/rmN8VBNIdFdfP8+i5OiseMVwvlk1bk9P1tKu
	 3MAHbp3L/VlO71F8Ur/24cmyfOWjlmWZ1DDmnN1Uho+izzex6CGJzPw0SKPlqaLexGqKK
	 ad0u1ik4tJVUmwecOSNM3CculJYlSewvhDW+zS335n9cqkI/YJb+GRRfn5NFZHgED3X4g
	 wAM+BvxJdpwa0zeOiIfjpkPaYBl1XSDuODiQpd/tRAxoKpiFo3n2v0Slsy9GkypP8tQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794559235;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BBnWWtBKdgI2TAwNesV0oCYOVTkjWDyFP80ZcpwkwoA=;
	b=WleOSZeDEdA/OoEtEuw4ldsC8T2BNyG8EhccyYIAEekC9Dm1cvdctplwoGs3urBiHtKo
	 7q4XbEIxhoWK9ZhZ/hoN+t0GbIaM382l+tShhGnih0n8fT1y1P/Ex/MKCoYD+JuZghjT5
	 higjQVVQwdPktKrz69xU0eTz78W3xPS3SopByEIG4g/jqGam1ms8OqW2WgizC+2t78vIl
	 ayICDF2f2vv9P9xt0pSpWLJpy09ZPXEYHo0zgeJzjddda9zDw6KIL2w3xSap0RNbzoJ/F
	 f+OSELV2A70nLGZaCrda+m5VMDYskzmzBjuF+z4mjA3q4SXAiQmXIVWMpLFG0pqKKkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="gV4GU//8";
	arc=none smtp.remote-ip=209.85.215.182
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF5D60A2600
	for <target-devel@vger.kernel.org>; Fri, 13 Nov 2026 08:40:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2AF5D60A2600
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gV4GU//8
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cd8ba7c2694so262993a12.1
        for <target-devel@vger.kernel.org>; Fri, 13 Nov 2026 00:40:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794559234; x=1795164034; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BBnWWtBKdgI2TAwNesV0oCYOVTkjWDyFP80ZcpwkwoA=;
        b=gV4GU//8b5UXX3fB1poHfcWwaF8yDwgTfBZ4FxVwCSyE/RGh9w7pN/L5D3TScLNDi/
         2Hj1ADK0phlUcLRUVdPQusQbLg1Xp7NyLGLcWQSxKZIaPr8x/OlUnwChIPoPIYSYCMXO
         atg6k6g1mVkciyLuzJEAg9vUaqGj0+Zg2TvFqWVw4hkbfVOTKHHwBeNG15jcsimGwakG
         yNuxR2g5R1lScr84PeUGpjCWwF1rNWq44FVyeKuZp+A3puhg8VWswtnqHZwRa1Ur0z9Q
         T1TzaiGy2U/3HBaK2ZwVhrT8EyOR5WWO/si+Pq73UfiBk/6+dJwzYqw59ZR+ZDsyMXC3
         G47w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794559234; x=1795164034;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BBnWWtBKdgI2TAwNesV0oCYOVTkjWDyFP80ZcpwkwoA=;
        b=HEnTd4hUo2skfwcGuh8cEUczyys2MHb6gbk1snZSx6zuWa9AYKsTeVjzTwJet//EjC
         eQFDPOYulCxlB8iB+N/JK9av8XIE7WYBenhGDBg66UTDd7Pb9tvTwmhuJ7BfnQYhdQkU
         QaUyZCCSd2VxCXIqXRe6UhR1p4e539KfFLdsjuquLAKq6CjkWth8UjAGfi7Nmqaz32Mc
         SP1hdPUPevEUtqul4irCwnXXUqAVFPwoSvnPPD/OTdmcJyL0p87MWIX+wzlUKczcqnrb
         YugQtcnYapT8/e9F13XZr+Mixt7sDloCXkbtjPkMwM/QiOV2m8P9sd2tcSa+ukTHG3Sm
         I5+g==
X-Forwarded-Encrypted: i=1; AL+hErF2LZtpZPGcqS7U8Y17du9k6rZf4YFK7iuGYS+D193PjcdWnn2dvwp+TXaUO9bZdGvZVaprTrAqNe3MKlM=@vger.kernel.org
X-Gm-Message-State: APuU4Z8SpNfXEvOR/wTT94Enl5uzW0tRdR00t2AhcCAyTe/2GPn9AtME
	hU+uj8rxy2QYUTlTMNL/i+unrf3Je1A5OdsgP0DBdQ6J6v9CCXv0ZBvx
X-Gm-Gg: AYBFou3d8FZF0uPvzg2NUs+VhSLApBin9JjMUlXkSDmgJOi3iudeIzW9IPGIu/yKcPj
	5QoS0OwCRtZWhKRPUCQkzL2moiHTz9ivrYYMKDH8pcDMXc+8WbUqpy7DsKWZdLFBJNexCrkFzUz
	LNbNZu3F/zpM6/Wyo0Fk5Dz7ETmYsuMC7S3YWrfLEpKvt/6FxzOvCm4UKC84qMrSYiHyHB0uner
	sIsuvAPo1j6AaAovbsWmD5QWBbrLbZ8Erks9JEMo6kFyUyszyGT4FZhPESzSB//h25u9/CDo1tY
	PgzrB1fOfaBqbX4s0DGCHc0/jJxj4hO+Y1l7L7VLPkjTtYk4oDW40oIWS7J/CzAa3pph+o0EVcR
	FMWzrbzGf8qtx6CosUgp244cLYm8kTYhbIfOZK1zGMlG/c1KV0qKzcEhgoBwWvQIVcjQe0HVITN
	TOmEvfOcDInrC13ywUJF2EjlXjEekDAWv3KJCR+vCpMHpZMBiGHPJQpK+Hz3Odx1ZO+3nOy6qhm
	Ok9kWRvB72FvnT+/H2y27NevdCeHjFLV6tWDk5v7PJCZg1ILCqOU/JSUWU2d9fEPzi3PKR4/yYQ
	HHr28P1jCc77fzpUHBJ6IChEWqMNH7+hFbCJr8lYYw==
X-Received: by 2002:a17:90b:56cb:b0:3b0:a9de:9880 with SMTP id 98e67ed59e1d1-3b1b0a3c5e9mr1581124a91.33.1794559234473;
        Fri, 13 Nov 2026 00:40:34 -0800 (PST)
Received: from localhost.localdomain ([183.62.176.219])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1b25a365asm1264855a91.1.2026.11.13.00.40.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 00:40:34 -0800 (PST)
From: Yong Liu <pkfxxxing@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	security@kernel.org
Subject: [PATCH v5 3/3] RDMA/srpt: Prevent uninitialized read buffer disclosure
Date: Fri, 13 Nov 2026 16:38:42 +0800
Message-ID: <20261113083848.1517595-4-pkfxxxing@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261113083848.1517595-1-pkfxxxing@gmail.com>
References: <20261110030809.913063-1-pkfxxxing@gmail.com> <20261110030809.913063-2-pkfxxxing@gmail.com> <20261110052827.963143-1-pkfxxxing@gmail.com> <20261111065342.1282709-1-pkfxxxing@gmail.com> <20261112094138.1390409-1-pkfxxxing@gmail.com> <92a82300-a454-4ee5-a191-0ce5a2ee58c7@acm.org>
 <20261113083848.1517595-1-pkfxxxing@gmail.com>
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

SRPT allocates read buffers and creates RDMA contexts from the initiator's
descriptors before parsing the CDB. When target core shortens
cmd->data_length, a backend such as rd_mcp fills only the shorter length,
but the prebuilt RDMA transfer still sends the full buffer. This can
disclose stale target kernel memory to a remote initiator with access to
the LUN.

Reject indirect descriptor tables whose direct descriptor lengths do not
sum to the advertised total, and log the mismatch before allocating RDMA
contexts. Save the original buffer length and zero the tail beyond
cmd->data_length through the chained command scatterlist before posting
RDMA transfers. This applies to both data and control READ commands.

The issue was discovered by Qihoo 360's Tulongfeng multi-agent system.

Fixes: b99f8e4d7bcd ("IB/srpt: convert to the generic RDMA READ/WRITE API")
Cc: stable@vger.kernel.org
Suggested-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Yong Liu <pkfxxxing@gmail.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 17 +++++++++++++++++
 drivers/infiniband/ulp/srpt/ib_srpt.h |  2 ++
 2 files changed, 19 insertions(+)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 127f256c6e..fc530ddf48 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1115,8 +1115,10 @@ static int srpt_get_desc_tbl(struct srpt_recv_ioctx *recv_ioctx,
 	} else if (((srp_cmd->buf_fmt & 0xf) == SRP_DATA_DESC_INDIRECT) ||
 		   ((srp_cmd->buf_fmt >> 4) == SRP_DATA_DESC_INDIRECT)) {
 		struct srp_indirect_buf *idb = srpt_get_desc_buf(srp_cmd);
+		u64 total_len = 0;
 		int nbufs = be32_to_cpu(idb->table_desc.len) /
 				sizeof(struct srp_direct_buf);
+		int i;
 
 		if (nbufs >
 		    (srp_cmd->data_out_desc_cnt + srp_cmd->data_in_desc_cnt)) {
@@ -1128,6 +1130,14 @@ static int srpt_get_desc_tbl(struct srpt_recv_ioctx *recv_ioctx,
 			return -EINVAL;
 		}
 
+		for (i = 0; i < nbufs; i++)
+			total_len += be32_to_cpu(idb->desc_list[i].len);
+		if (total_len != be32_to_cpu(idb->len)) {
+			pr_err("SRP descriptor lengths total %llu does not match advertised length %u\n",
+			       total_len, be32_to_cpu(idb->len));
+			return -EINVAL;
+		}
+
 		*data_len = be32_to_cpu(idb->len);
 		return srpt_alloc_rw_ctxs(ioctx, idb->desc_list, nbufs,
 				sg, sg_cnt);
@@ -1304,6 +1314,7 @@ static struct srpt_send_ioctx *srpt_get_send_ioctx(struct srpt_rdma_ch *ch)
 	WARN_ON_ONCE(ioctx->recv_ioctx);
 	ioctx->n_rdma = 0;
 	ioctx->n_rw_ctx = 0;
+	ioctx->buf_len = 0;
 	ioctx->queue_status_only = false;
 	/*
 	 * transport_init_se_cmd() does not initialize all fields, so do it
@@ -1607,6 +1618,7 @@ static void srpt_handle_cmd(struct srpt_rdma_ch *ch,
 		goto busy;
 	}
 
+	send_ioctx->buf_len = data_len;
 	rc = target_init_cmd(cmd, ch->sess, &send_ioctx->sense_data[0],
 			     scsilun_to_int(&srp_cmd->lun), data_len,
 			     cmd->sam_task_attr, dir, TARGET_SCF_ACK_KREF);
@@ -2914,6 +2926,11 @@ static void srpt_queue_response(struct se_cmd *cmd)
 	if (ioctx->cmd.data_direction == DMA_FROM_DEVICE &&
 	    ioctx->cmd.data_length &&
 	    !ioctx->queue_status_only) {
+		if (ioctx->buf_len > cmd->data_length)
+			sg_zero_buffer(cmd->t_data_sg, cmd->t_data_nents,
+				       ioctx->buf_len - cmd->data_length,
+				       cmd->data_length);
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

