Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794788358;
	b=k229O50MGH5e9w/9Cndi0Yo1mSvHKVI4O1czqglyjAYGuea1pAvE7vjuRmgvZ0ZoshQJ
	 NQneP2/TeADeGa8PbuXznA+qytqoTnItN0fbld9+npwk+p7SpmYlc0oZkN/ojH92ZHfEg
	 FLmkUUsrno2umxCjlwKZKrpF3Ss5VBbXdP/z5K7uqLO4+Sh1lmr0tUvgi3jPwbRSXU+Oz
	 7/c/1dnrU2CcpEKrtQrS6o/v2XM5hqC3T8r4gn+kCRIFlH3XZQRw8pEqe14zZcpHa9STN
	 XyppMdMIMxWfxQLC0TGcQ4TRclXZqP8Tf6rbpM9qvLxJa7kNIVvKtfE3K9KQLnkVYGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794788358;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer;
	bh=nIOxEG+XJtxJt4zKTpuYPQLm0Ri3DrIUO+hTzmr3w3Y=;
	b=VuGQsqmeP4ODaJbdDpEKbRGkiktlNLmcN6VfgL/96HMPa20KXZBVOLndb+FxOrGl+86K
	 b+NtKDs89IX6ZZGtAPfErBi2HmEXtOJHVtdvMkhO/bBJ2YMWSL8JaOx84MoQHp3lNmDlL
	 IM2dAHDBs0dZfV4aPiti2YiagSEN3eJBAF1UR665QkNtq0p91MiWHJLdZhDGYwtJEzJYN
	 dNMv8uk91gqhWmCEgYGKvLUkbcLgWqBIgSg1kgRRkZ1go2qh8zkK9UVYiAFV51/HX9YtV
	 L1z2uxkAEIuIFkL0poShx8r/YuDuBgckxg8CreEN1VsI3TBp5bZcjWam3TqwuOQRhlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=rN+Rl7cf;
	arc=none smtp.remote-ip=95.215.58.177
Received: from mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963C3606A330
	for <target-devel@vger.kernel.org>; Mon, 16 Nov 2026 00:19:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 963C3606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=rN+Rl7cf
X-Envelope-To: target-devel@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=sOT2KT5q9S6Ar9Kx6p7S+PohUDFfinM2HhTOMnwKD1I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794788355; v=1; x=1795393155;
 b=rN+Rl7cfvcxV1FCLo2jTkuEtyn3aR40H56D7PEyVfniATkpfgOmi+2WAlIQlzy6vXThEWXqz
 N3uACaUz8DR/dIZFM336rdU9HQaiq8KtHBYpnYCFuOdx3SGtZtUCTk+SSiVSlrw3L+AhceLEQio
 B8DTQhfu1Jx8ZhHWajoj2JNc=
X-Envelope-To: target-devel@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id dbc87a1e82f9bb3a;
	Mon, 16 Nov 2026 00:19:15 +0000
X-Mizu-Trace-ID: dbc87a1e82f9bb3a
X-Migadu-Flow: FLOW_OUT
From: Qiliang Yuan <qiliang.yuan@linux.dev>
Date: Sun, 15 Nov 2026 19:18:02 -0500
Subject: [PATCH RFC 09/18] scsi: target: uring: Fail in-flight commands
 when the server exits
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
Message-Id: <20261115-feat-target-core-uring-v1-9-28cdc137eac6@linux.dev>
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

A tag of a target_core_uring device belongs to the server from the
moment it fetches a command until it commits the result.

If the server exits or crashes in between, the command never completes
and the tag stays owned, so a new server cannot fetch on it.

Fail the commands the server was working on when it closes the
character device, and give the tags back. Commands that were not fetched
yet stay on the pending lists for the next server.

Signed-off-by: Qiliang Yuan <qiliang.yuan@linux.dev>
---
 drivers/target/target_core_uring.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/target/target_core_uring.c b/drivers/target/target_core_uring.c
index 3a6f8d25d28e5..2978dd08c99cf 100644
--- a/drivers/target/target_core_uring.c
+++ b/drivers/target/target_core_uring.c
@@ -153,6 +153,16 @@ static void tcmur_cmd_end(struct tcmur_cmd *tcmd, u8 status)
 	tcmur_cmd_put(tcmd);
 }
 
+static void tcmur_end_cmds(struct list_head *cmds, u8 status)
+{
+	struct tcmur_cmd *tcmd, *tmp;
+
+	list_for_each_entry_safe(tcmd, tmp, cmds, node) {
+		list_del(&tcmd->node);
+		tcmur_cmd_end(tcmd, status);
+	}
+}
+
 /* Hand @tcmd to the server through the tag @io */
 static void tcmur_io_start(struct tcmur_queue *q, struct tcmur_io *io,
 			   struct tcmur_cmd *tcmd)
@@ -509,6 +519,27 @@ static int tcmur_ch_open(struct inode *inode, struct file *filp)
 static int tcmur_ch_release(struct inode *inode, struct file *filp)
 {
 	struct tcmur_dev *udev = filp->private_data;
+	struct tcmur_queue *q;
+	struct tcmur_io *io;
+	LIST_HEAD(failed);
+	unsigned int i, j;
+
+	/* Fail the commands that the server did not commit */
+	for (i = 0; i < udev->nr_queues; i++) {
+		q = &udev->queues[i];
+
+		spin_lock(&q->lock);
+		for (j = 0; j < udev->queue_depth; j++) {
+			io = &q->ios[j];
+			io->owned = false;
+			if (!io->cmd)
+				continue;
+			list_add_tail(&io->cmd->node, &failed);
+			io->cmd = NULL;
+		}
+		spin_unlock(&q->lock);
+	}
+	tcmur_end_cmds(&failed, SAM_STAT_CHECK_CONDITION);
 
 	clear_bit(TCMUR_DEV_OPEN, &udev->flags);
 	return 0;

-- 
2.43.0

