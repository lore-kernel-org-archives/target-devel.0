Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.36
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794788370;
	b=N/IaLF49Z8vo/u67ASik71iJ7bqs6VXdFRVP0OFU3mH1plJYzsyNiGBhIDPqe5G6ndXa
	 tJidsCOCI02Nczmf7WD0qAs9py1pOwvJz0/9itiQDbZBJ6wNUeTSO94gTT7cI3JcgRner
	 E2c2yPnGHEAHqZ/ninuZ1L4NVDlRQ8PU2Ua89LD/upvie4kA68L/1Rznt+f0/d+3jLSA8
	 lhEiA4lg+m47kdgiBTqLZldMqv1HizX/mRGv/PSFoXVzykmKiIVrVihagHOOTPDyGWg62
	 EXTCWJGFcihEyLyHpaKt6g6Z5KwCguI0dARhh9Ht6akQSMxiKrsCy6L/1Z3uaqQ454Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794788370;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer;
	bh=nhnHtLieQMdo/OcyKxpaCFLTNFcPVZQRcEluKyBdufo=;
	b=ebobek5YO5ohLTjEslUfgUd7TQw4j++Zci+UyrgW+widop/a31A+6BUg6aYmBLY0UzUB
	 q/mo7qaJdxLl5B02ePbJVnzZjKSl98U3JZqJ5wv/uFdGIDvmlfhdzQxnG4vsQCSjNaei8
	 UA7cEO3oROOQjndn0uRrUvQFlDByWBlna6FNO5/rZxRvM6oseiSvNCqIo6OIFiCV1BnSc
	 76XSAmbMcFuWEhchT7iOd23WU8/iyYT06dzW02WhjVD6aJlYIvsIdZgLBGkRgBUmp4FgX
	 iQNuySbrf5QcgjT/YK4AkWvF/TOF5BKNAh4rzUTP8JkKGeDm6+VwNUCTI20TquSJdpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=duLJ6bqq;
	arc=none smtp.remote-ip=91.218.175.36
Received: from mta0.migadu.com (out-36.mta0.migadu.com [91.218.175.36])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC00606A335
	for <target-devel@vger.kernel.org>; Mon, 16 Nov 2026 00:19:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3AC00606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=duLJ6bqq
X-Envelope-To: target-devel@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=GE0AmWzzUkTntY8b3KCGh9uV2eo1z/UgLx990fOkw7c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794788368; v=1; x=1795393168;
 b=duLJ6bqqAim6rotM3f+vgw8STJSF5W/XrYx0D5tloRenWdzJv9k3zC9oyG0UMcDhDUKt6PQ6
 bkRJmrIisLoS75xrTPhUdxtdHePv9tZyrEli9e4v5zYKyq64iuxcoijwEoGUEy4Bx/3LT3m/yy3
 yEdraU59edDItWh0dBvvRuhc=
X-Envelope-To: target-devel@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 9651313902837610;
	Mon, 16 Nov 2026 00:19:28 +0000
X-Mizu-Trace-ID: 9651313902837610
X-Migadu-Flow: FLOW_OUT
From: Qiliang Yuan <qiliang.yuan@linux.dev>
Date: Sun, 15 Nov 2026 19:18:04 -0500
Subject: [PATCH RFC 11/18] scsi: target: uring: Drop aborted commands that
 are still queued
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Post: <mailto:target-devel@vger.kernel.org>
List-Help: <mailto:target-devel+help@vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:target-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261115-feat-target-core-uring-v1-11-28cdc137eac6@linux.dev>
References: <20261115-feat-target-core-uring-v1-0-28cdc137eac6@linux.dev>
In-Reply-To: <20261115-feat-target-core-uring-v1-0-28cdc137eac6@linux.dev>
To: "Martin K. Petersen" <mkp@kernel.org>, Shuah Khan <shuah@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
 io-uring@vger.kernel.org, Mike Christie <michael.christie@oracle.com>, 
 Bodo Stroesser <bostroesser@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 Qiliang Yuan <qiliang.yuan@linux.dev>
X-Mailer: b4 0.13.0

When a command is aborted, the core waits for the backstore to complete
it.

A target_core_uring command that no server has fetched only completes
when it times out, which delays the abort by up to cmd_time_out.

Implement tmr_notify() and complete the aborted commands that are still
on a pending list with TASK ABORTED status. Track them through
se_cmd->priv, which is set only while a command is pending.

Signed-off-by: Qiliang Yuan <qiliang.yuan@linux.dev>
---
 drivers/target/target_core_uring.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/target/target_core_uring.c b/drivers/target/target_core_uring.c
index 0f83bdc55e06a..629419a4c8f46 100644
--- a/drivers/target/target_core_uring.c
+++ b/drivers/target/target_core_uring.c
@@ -175,6 +175,7 @@ static void tcmur_io_start(struct tcmur_queue *q, struct tcmur_io *io,
 {
 	lockdep_assert_held(&q->lock);
 
+	tcmd->se_cmd->priv = NULL;
 	io->cmd = tcmd;
 	io->owned = true;
 	q->descs[io - q->ios] = tcmd->desc;
@@ -207,6 +208,7 @@ static void tcmur_queue_cmd(struct tcmur_dev *udev, struct tcmur_cmd *tcmd)
 		io->ucmd = NULL;
 		tcmur_io_start(q, io, tcmd);
 	} else {
+		tcmd->se_cmd->priv = tcmd;
 		list_add_tail(&tcmd->node, &q->pending);
 	}
 	spin_unlock(&q->lock);
@@ -255,6 +257,31 @@ static sense_reason_t tcmur_execute_rw(struct se_cmd *se_cmd,
 			    se_cmd->data_length, sgl, sgl_nents);
 }
 
+static void tcmur_tmr_notify(struct se_device *dev, enum tcm_tmreq_table tmf,
+			     struct list_head *aborted_cmds)
+{
+	struct tcmur_dev *udev = TCMUR_DEV(dev);
+	struct tcmur_cmd *tcmd;
+	struct tcmur_queue *q;
+	struct se_cmd *se_cmd;
+
+	/* Drop the aborted commands that no server has picked up yet */
+	list_for_each_entry(se_cmd, aborted_cmds, state_list) {
+		q = tcmur_cmd_queue(udev, se_cmd);
+
+		spin_lock(&q->lock);
+		tcmd = se_cmd->priv;
+		if (tcmd) {
+			se_cmd->priv = NULL;
+			list_del(&tcmd->node);
+		}
+		spin_unlock(&q->lock);
+
+		if (tcmd)
+			tcmur_cmd_end(tcmd, SAM_STAT_TASK_ABORTED);
+	}
+}
+
 static void tcmur_timeout_work(struct work_struct *work)
 {
 	struct tcmur_dev *udev = container_of(work, struct tcmur_dev,
@@ -278,6 +305,7 @@ static void tcmur_timeout_work(struct work_struct *work)
 				rearm = true;
 				break;
 			}
+			tcmd->se_cmd->priv = NULL;
 			list_move_tail(&tcmd->node, &expired);
 		}
 		for (j = 0; j < udev->queue_depth; j++) {
@@ -920,6 +948,7 @@ static const struct target_backend_ops tcmur_ops = {
 	.destroy_device		= tcmur_destroy_device,
 	.free_device		= tcmur_free_device,
 	.parse_cdb		= tcmur_parse_cdb,
+	.tmr_notify		= tcmur_tmr_notify,
 	.set_configfs_dev_params = tcmur_set_configfs_dev_params,
 	.show_configfs_dev_params = tcmur_show_configfs_dev_params,
 	.get_device_type	= sbc_get_device_type,

-- 
2.43.0

