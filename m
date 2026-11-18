Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036524;
	b=WDUujPcdp1pyY05kTtPwrm4zSDHwO6WaEwa4CXPe10X6vED1G/8nAOkJQzbr77xTN9XS
	 Wm8Oy2cGtQ8eBa7y0UueMPo4Wi3Z3oc/+vD+yUnYtcjDM1sJ+DIPJVS8OUdtMA0QYSDgE
	 o/rXoBA3/O0xXqxmImVsRnmvL38hlZS3DE/l6DjFfLUOUn3cbSJwVWBno9HZUoigXM1+l
	 2nUfCI4XCrW5O3PfyjrRfWpfxb+OGC77niuh5nmwJiATSvtyUsU7ctw8aRUq6RmOYUxFS
	 VLCaqFmWiugdkQ4DnmKVGQpYmfBxMjH12AHZI6/YPPyDge2+lEOlyF6gXdzY503COLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036524;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1F5PhsVSMvlAKbqeP5i5JDJo+bg6gq7qbiCDaCKQio0=;
	b=MpPj5a010ueqljrQSNM2lwLQkLfShByNyY0OGlsFlB/E+lISY1oaWWMZ0PCabagLRPHh
	 Fgz+EUMjXOth5kQjWxdKnX/oSrg4XFDrknK2MQJ+qk4DnVI7RgLeztMGs+cYPRcRWZjfx
	 64Jzjc7yxIaBC1RLMkT3UiWAjkORgkMyYxsRTsNrUIxe5E7fcL06NgkD0oyjtca+7uEP0
	 7zOxu/xDYBkAjdFYx9gZMFoGvw4zdsWRLkzBatlrkD9QGFuYJo7oVLroyrPR/QLY6ykge
	 u2kgY2AmIvrvYZpwoLYpCBMG4gLMiDewvap7vGGst427R2yWe7R8Z8drc7sRgitGWhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=GuGWlwhG;
	arc=none smtp.remote-ip=209.85.215.177
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245E260A262E
	for <target-devel@vger.kernel.org>; Wed, 18 Nov 2026 21:15:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 245E260A262E
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=GuGWlwhG
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-cdb45e96d2bso983924a12.0
        for <target-devel@vger.kernel.org>; Wed, 18 Nov 2026 13:15:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795036523; x=1795641323; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1F5PhsVSMvlAKbqeP5i5JDJo+bg6gq7qbiCDaCKQio0=;
        b=GuGWlwhGz9SBzk1Mj+QMBzfNga5lBR9TA/XAmEkifgkSxr1yhb0Ef+xRkWvbej++aa
         P3FmveqIJSa8QHbXD5bg4orDk5EodifsPEN5qzLf9AvmsvnOYcpBeJwTOyYCHAAbA+6c
         U/SORLAaXeFJEym+tx+fqicc2Y7/UXXMACj5w2GV3TKnvbI/KViG0DzcyYov4FmSpDVt
         bTOf2CYekWLVsl57SS2vj0QEFAvdkjSsj3jgo7I0xaNdwhFiW0c966dyMZBHc/qhxpdl
         PFbNevaH/iNF6+Fqkvi/YxJOAUuIZ5M1125o+LGmK2Co2/JwnIWbphDMlMWHN1z+6orB
         xgeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795036523; x=1795641323;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1F5PhsVSMvlAKbqeP5i5JDJo+bg6gq7qbiCDaCKQio0=;
        b=ZSG7XNMerCMKABzMksEpNE66WbHLCEzlxIgQHCuO5ACtlEyhQAIkh630QtJTEqrXCp
         iFeveZlO84D/DxKKPXsUGqTMjFwlf19DGLKvUM8Dw4GrLftU9N0iayNsliREIwHq19OF
         XhGgS61BxHtvZ7vqHKhLnnLEQT1kHYevZF49bHJctfsMwXwkzEQCEP+JDLVfD1IxXBdh
         rlxoXCbygrKzHBTpvvrt4NpPH9ImA1us7CTKOUYzoZRY7dhyXtrcF/q26wgsrbnKkNv7
         clGPRegswrAZ8ko0BDlt7UQtWE+6Z/GKMbCYYSaQ/S9QXr4Ruv4nrUr/yF3za6LtTDdr
         CVuA==
X-Forwarded-Encrypted: i=1; AL+hErE5Kf25Q5Kw3lM0YH59AAGPMfVhzT+JegvcW90+Pch3fW9psnzc45VEGNo5Cm4/OTPz0Z9q3F/D8zeYS0g=@vger.kernel.org
X-Gm-Message-State: APuU4Z/EsYFZHipaJTKzfQQsSMlOtCddNJdDHMn/AxyOj1vo07lpaY40
	CpuJa/K2orO5kAgRlKeop0sUenCXTFyU3hMGFKOpOKJ9D3Dh4fq+vTH/DFzbisuWsIMKt2TqpLY
	T8ebv9bw=
X-Gm-Gg: AZFdTZddkeTk7D7X8+JFAmr3mhm0n0TC7FKvkUbZQMvb4tA3Mpl48IFYLpe4YhWtNYa
	4wE52zkirZz+/W4duitqoCrEOacZjBEBsitIUqDQlxL5S3vu4B9dhcHuN0fXvJCBDDUyKIQynSI
	Eo2U7zFHCUUJoolZfe38fTnJ7baUsblkFqAG0fHNSI99e1PmcMUF3naOqhfbv9jIoRWIOpbzhYJ
	WhNSkvks1thFrvelL0z3p88UDa1Gs0MqJGtPiycHBx7wlAAVxEgeoOX0y/2YTt8lVyhPKfFGwjH
	TefFsdShOL+nh/dc+0gvUrmfgheeH38pY0DP6cqAs60Wi5sYntbGRUdhP7JzK6uhUj9tEF287p2
	TrMdLOukelo7nj665aXKeCs63DT+hcg+wzOeEtrZhdqoW2jeZZePvyFy4gtpZLHvB9qPyHpf88D
	DsGNy0p9my3DA7x0IkgzG80cqI5oSbdEwUOvDw0rbktC9qcghZ9TkFepcWyXi9HK0edM8LvKQaO
	ICwP5nqOvbI2ngVC05BhNEIp+uAtNACwT3U769PgRZkqmZmn+BROnLfkbm5hHQ+RXoIGY1HZHGe
	G1OWlEfEJT6YX/BM2H25ZLxjw3qJ1Rc+v2Xh6D19kz5zXJSN448aRUkEzMjL4JVtu8/2EHd1H1t
	dHkUYxqp7fOGIRcb0d1qE1FGG5REPj4GB9SvZBg==
X-Received: by 2002:a17:90b:3891:b0:3ad:4bfc:1e77 with SMTP id 98e67ed59e1d1-3b3d082df08mr3830128a91.66.1795036523402;
        Wed, 18 Nov 2026 13:15:23 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:e78e:f7f0:2120:34e7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3d5689adasm2611719a91.1.2026.11.18.13.15.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 13:15:23 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sagi@grimberg.me,
	jgg@ziepe.ca,
	leon@kernel.org,
	mkp@kernel.org
Cc: linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/4] IB/isert: do not leak the receive descriptor of a dropped Data-Out
Date: Thu, 19 Nov 2026 06:15:03 +0900
Message-ID: <20261118211503.2526705-5-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261118211503.2526705-1-yhlee@isslab.korea.ac.kr>
References: <20261118211503.2526705-1-yhlee@isslab.korea.ac.kr>
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
after exactly 128 of them, with no response to a NOP-Out sent afterwards
and nothing logged beyond the per-PDU "Unable to locate ITT" message;
with this patch all 200 are taken and the NOP-Out is answered, in 5 boots
out of 5.

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
index b7dcfc5f88b916..804148ace398aa 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1141,17 +1141,16 @@ isert_handle_iscsi_dataout(struct isert_conn *isert_conn,
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
@@ -1169,7 +1168,8 @@ isert_handle_iscsi_dataout(struct isert_conn *isert_conn,
 	if (page_off) {
 		isert_err("unexpected non-page aligned data payload\n");
 		dump_stack();
-		return -1;
+		rc = -1;
+		goto repost;
 	}
 	isert_dbg("Copying DataOut: sg_start: %p, sg_off: %u "
 		  "sg_nents: %u from %p %u\n", sg_start, sg_off,
@@ -1180,13 +1180,18 @@ isert_handle_iscsi_dataout(struct isert_conn *isert_conn,
 
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

