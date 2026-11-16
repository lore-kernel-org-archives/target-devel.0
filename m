Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794823880;
	b=K1Nf/d/m7oRTbWMBFE6ileVVs5tfdki+wGFPqvooW/K24N1AnoFUWide+TG16OF8GQIT
	 DLa+iqqF3DVdSpt3Od/FwKVw72rZrpw5wi5yOsfVTk8EmBsyvDnNjp4MxxKIzuEbRXLn+
	 tc38jgVKE9NPbWowhqrX45dJTN2MvSFS049foEFSXwuCB9T6Oj6wf4roVQdACdLxoqL0P
	 F9+rdAHo2CKke8yP+qvv/91nBXHKNI1Z1rVKXgftfmUQbZKHODqB6IvnYW/8VXQEAVMfs
	 J0R15dAT3KPk17ejJzC9MzjHLSlb/QqS59GzIaBVIxWLIYk8Q6Qw8H/Izcu6+5x4Mug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794823880;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gIfgCrbgWP+O7J1dWGPslYkeZ9aFum9ZTgaeYRl4oTQ=;
	b=sCqUMJRzjqbRmMm5chJdDvXfMJD9LBypCAdisGJJSk6EebaE8P5HPaKFdZ9cfbjdPuOp
	 0uDanNpGjPZTauYW7H39/eFl6SpSTbfhAacBO5HDSuZ+nQ8Qcj8G43/WFT+yhuH9ECWla
	 NHK06iHfkUxtMOZIuauhZP+Eb1J3MNZmB1pVb4JPC0Y5mW5cpNR6B9Qp3Og1PZYJvSgPJ
	 v2NEZS0Sc8rQy/XAo0KH6kclUdafFYGE1gnmpuPUH6ZsvUsLMeBJgxXP/e/ksDj4+masx
	 DQu0k6YKs8m6LCg1E3hEkNWUCHaXRhnHlLcfkOitFOPH3jS+eCEFaEkDTTuTWaLeu4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=OCB6XAfd;
	arc=none smtp.remote-ip=209.85.214.176
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51240606A337
	for <target-devel@vger.kernel.org>; Mon, 16 Nov 2026 10:11:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 51240606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=OCB6XAfd
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2ed11653a91so18612385ad.2
        for <target-devel@vger.kernel.org>; Mon, 16 Nov 2026 02:11:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1794823880; x=1795428680; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gIfgCrbgWP+O7J1dWGPslYkeZ9aFum9ZTgaeYRl4oTQ=;
        b=OCB6XAfdUc5s0FIoYt6+yjDyITD7EIoOFHulkz03GRmgPZdWkYgAmmFPBLmBgISuvG
         dlm0YB3Ij428Uz5sPUHFyOUKLsyIo7SHUka78fzxljkttoUrDaVHoZDRdk5fY8JtJWno
         T3JKboSNGx542jV1xu1WEQiTlVNN3hH7WH2TyY9TyLGsCyCvnLyHlMTE99OoDi8bvLDQ
         Ann8xa9PcUJqFYKCASqGQuj8HXd0SDUAgdTNpUmxkkJ7MLVxvwK411y2HvGro+Vqhurc
         IVkkFiCDoK1hu3kvAIx30RQR5MRUm6h7Y+Ja7TphHPuXQ/8vP4JeKsBp+99Eckmu9xpI
         1LDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794823880; x=1795428680;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gIfgCrbgWP+O7J1dWGPslYkeZ9aFum9ZTgaeYRl4oTQ=;
        b=SppooL7uRvPCEHgU6YtNucadNEVW9cksSFzqI+gw+go7Ee2V0fy0nDRsR5Iy57sCBS
         jZjvOe6uHX37YCz6m2V4HatTNRaMCcwN2za1uMnRciAzTH3S7lc9ZFS61M9VcQhNqEiA
         KoseBn0jEzpYOIO0zISYciQ2hkoIRknZOISZiGsYPLuVTrosmRGOXeZb90x/ZaevukaS
         ADOrW2DjhqJFZna3Gv+6OkkQlWdKz63jtmhGFN/nCQzn6emSOvwPKILJeZN/oGnOZclp
         wiawt6PSujM1KzDo4JHeBnb+podQxKDjO8zQQtHJaWQa0IMJsc3yFWtOQUKJ2rihybc4
         6VAQ==
X-Forwarded-Encrypted: i=1; AL+hErFHQokiWwrH/NxgT3DJXvxS3HwxGnCf9z1ggqSNAJGg8bwLCFA4Q++R4QfqM5d+gwdMLaHLjqAHkeNzf3s=@vger.kernel.org
X-Gm-Message-State: APuU4Z8LpDXcRCuAf95Uo902XAtXu+8H9Fa0+dW/LlBpClvq0U4CwRnJ
	+EyC8+1RftDIPQbJCBFisexrScEUlbNzzP1YCKGLPJfe4SqQEs77CBqp9/syenJaLh0=
X-Gm-Gg: AZFdTZesKt5FlWqRUkMYKZ/C0H1lN8pnspAqTSilPhPeg3HtQ7LsN0tfla3Xmoz4kVp
	/FBGN2CBY6XUuO/Yeg7fDH3Bc1xUVv4UAMb0xhEGQUcv2Q8530rk/s8MG7Fe90Y8747xJLmDFe8
	8WfTPTCsf4T0O/a+urFUTme3n2CwYmG2b877mUaYP7A/5eHUfLIriVcUc+ueE9k4EmdJMywi9HP
	BqDnlEDOOzZBG1osRvqAYrLO6czeN4iOEL24vAQMm3hHSrRF3eVR0JpRsIOU5hdAHCVGMrhgL4D
	3E1Cxil8mEOXxmw2ERfJM2W/jY1n7YMH2VMNPWn2HUdKfuyS/W+NVKeIM7T4FSCzIXGUKSWQaAc
	LJFKSe9e6kNss0gZFq2ZqvhMpdxt+uVITM51ZCVGc1ZVqZHEqcTmRlTZzNaTwbcgXLkLVdwMXt4
	R7vMaBnwdGgNWMgt8/n39zaLg2f/VJjliQPcNk6Rb8DA06GEKr5R3dmsFFTd42w0dT8Ch9cy8C6
	cQfz3tjpmkYCzUyLIB2VR115D3HbYijyV1OvZFnIwl0opM/4NdjPeIuXogUF5t/zDqf9GgxY7c/
	znBJmImofEcn1mIs4ZCXXRx3xLDyTDSIfPTRLfXQWlOVhG0f471cv/Wfgy8EXECY2AoTESWOv17
	uOMlWp/Lp5B6pzQMy612X91XJbSxnzLVzWNjmxg==
X-Received: by 2002:a17:903:1446:b0:2ed:56ee:af8f with SMTP id d9443c01a7336-2ee0d65fb69mr101733635ad.2.1794823879687;
        Mon, 16 Nov 2026 02:11:19 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:35d0:694a:1071:9bae])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ee0f7e5055sm35533795ad.39.2026.11.16.02.11.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 02:11:19 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sagi@grimberg.me,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] IB/isert: do not leak the receive descriptor of a dropped Data-Out
Date: Mon, 16 Nov 2026 19:11:08 +0900
Message-ID: <20261116101108.1650132-2-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261116101108.1650132-1-yhlee@isslab.korea.ac.kr>
References: <20261116101108.1650132-1-yhlee@isslab.korea.ac.kr>
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

isert_handle_iscsi_dataout() works on the command it finds by ITT, which
holds the descriptor of the SCSI Command PDU and not of this Data-Out,
which is why the function posts its own descriptor explicitly when it
succeeds.  None of its other returns do, and isert_recv_done() ignores
what the handler returned, so each such Data-Out costs one of the
ISERT_QP_MAX_RECV_DTOS buffers.  That includes the returns where
iscsit_check_dataout_hdr() answers 0 without a command at all: 200
Data-Outs carrying an ITT that matches no command stop the connection
after exactly 128 of them, in all 3 runs, with no response to a NOP-Out
sent afterwards and nothing logged beyond the per-PDU "Unable to locate
ITT" message; with this patch all 200 are taken and the NOP-Out is
answered.

So give isert_handle_iscsi_dataout()'s other returns the same post its
success path already does.

That one function only.  Everywhere else a handler returns non-zero, the
command isert allocated still holds that descriptor and the response
posts it from isert_post_response(), so re-posting from
isert_recv_done() would post the same descriptor twice; the second post
is skipped only while the descriptor has not been refilled, which is not
something the receive path can promise.  iscsit_handle_logout_cmd() even
returns 1 for an ordinary logout.

Fixes: 4366b19ca5eb ("iser-target: Change the recv buffers posting logic")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 81164881dcc241..8a57c880335cc3 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1130,17 +1130,16 @@ isert_handle_iscsi_dataout(struct isert_conn *isert_conn,
 	int rc, sg_nents, sg_off, page_off;
 
 	rc = iscsit_check_dataout_hdr(conn, buf, &cmd);
-	if (rc < 0)
-		return rc;
-	else if (!cmd)
-		return 0;
+	if (rc < 0 || !cmd)
+		goto repost;
 	/*
 	 * FIXME: Unexpected unsolicited_data out
 	 */
 	if (!cmd->unsolicited_data) {
 		isert_err("Received unexpected solicited data payload\n");
 		dump_stack();
-		return -1;
+		rc = -1;
+		goto repost;
 	}
 
 	isert_dbg("Unsolicited DataOut unsol_data_len: %u, "
@@ -1158,7 +1157,8 @@ isert_handle_iscsi_dataout(struct isert_conn *isert_conn,
 	if (page_off) {
 		isert_err("unexpected non-page aligned data payload\n");
 		dump_stack();
-		return -1;
+		rc = -1;
+		goto repost;
 	}
 	isert_dbg("Copying DataOut: sg_start: %p, sg_off: %u "
 		  "sg_nents: %u from %p %u\n", sg_start, sg_off,
@@ -1169,13 +1169,18 @@ isert_handle_iscsi_dataout(struct isert_conn *isert_conn,
 
 	rc = iscsit_check_dataout_payload(cmd, hdr, false);
 	if (rc < 0)
-		return rc;
+		goto repost;
 
 	/*
 	 * multiple data-outs on the same command can arrive -
 	 * so post the buffer before hand
 	 */
 	return isert_post_recv(isert_conn, rx_desc);
+
+repost:
+	/* Nothing else owns this Data-Out's receive descriptor. */
+	isert_post_recv(isert_conn, rx_desc);
+	return rc;
 }
 
 static int
-- 
2.43.0

