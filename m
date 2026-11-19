Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795094244;
	b=PROQQVOyTwuySQ8zQGfmakGOTMtoPlS1vFdpFTzWkzhXkYsX8R7WrQdS9ZWwW6YeiBLV
	 Lmx3sCkZWqbZEnf/fLtDzQhWXX/t+1A9cR2rst/JHSv9auTOPW/YikF2gxD9GtcVn/MnT
	 4gVPZcJuM6nwqFZHlZmEEJPj/IxCoGK/wOElFN42kfaTM1lwpJnoIzE4wGDQ7a6doKgym
	 Ac6vDjSqQVU14lVEeno+vajOv/ZzoNEdFJYyrsynMT3DidPuokJZIf/DzdiM/Fl9va45u
	 jvdcIIe1aPs15K4gC6r9VMHOTyfNXvaCvpI2YCaxCWEwM1g1ymNxY4208ZpdJuxa6Hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795094244;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1F5PhsVSMvlAKbqeP5i5JDJo+bg6gq7qbiCDaCKQio0=;
	b=IEug5Pra8/QORDdRxwzelv1oWdw4IdBZtYRGPI1Qor178S5bAv8OgJAstogLWdb0PRER
	 DHaJzmDVk3gFVnZokHZhU/ictPvQoptg9A938J7dhGcLPIm4K/lAb/ETpElLmdK34Dlm/
	 Yk7DdcwdhOkeErCaN5zMc94BzDQhtzhNABenMsYjd0ZQG6fIDob/s6QYE4eF4yfo1OTTf
	 4vnlmxaNHkuCDHWVTgrHLqEsM0ty4iwD6rxWedqTAj53z5lRHqqxNwgAFxXWzYEoqTwTi
	 8IJGluu9Z111JaEd8Zt+4uEme8CRBKRX5cRrjGEPtUPEc9o4VwTX/ubr9WoFUc755CA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b="dMc79+3/";
	arc=none smtp.remote-ip=209.85.210.180
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB2960A2636
	for <target-devel@vger.kernel.org>; Thu, 19 Nov 2026 13:17:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2AB2960A2636
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=dMc79+3/
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8b6b22be970so1038780b3a.1
        for <target-devel@vger.kernel.org>; Thu, 19 Nov 2026 05:17:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795094243; x=1795699043; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1F5PhsVSMvlAKbqeP5i5JDJo+bg6gq7qbiCDaCKQio0=;
        b=dMc79+3/bbz2dq/bJUjd6kyg4QIMok8By+PE3QK8cvP6ZawvYbZUM2YRgN4WmchUGo
         9cMCKmDqt7cBFOeH6A4qxfuGvgJnyvlamjSTmtMkbWxM+xGEcWswf4ZwbqNsl/SvPaXy
         zPCk6pxp4IBpZa9hNMp3Davj09P/kLs6qcW89RuyrDEv4GBJLHhEgHUb3s/9QOeiRu10
         +T1LfJVBnstPqqdz/eTr2mBE0x3w+PivdvlePMqVqEjGmyph0JKJ2Bjvo5h4Ir/IXDbs
         wEqNgxOUUlKXDZICvVHa1OEPQ2Gdn3oAoytRqBZpg4RRBT9Zd6vWlCR1UIjho5DM5SX5
         vbkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795094243; x=1795699043;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1F5PhsVSMvlAKbqeP5i5JDJo+bg6gq7qbiCDaCKQio0=;
        b=uFW+ESZdUJ4zMWIxXp//b3Jgm0xkrATpnJCVfeavwEWKXOGwkhMy6F4wiDENlYp1u6
         5v3/3j7X1YoXRu0Do1LNS/V0GW0JC7lgW6CzoIFiAQc5duzDeidt9y3vHdMwZjIB+uJK
         T8XOMBRHESYyF8trfFdGTAYTfHBQvSesaUAFZ2OUr3mSQjucvPnW84npZrDirvHHGghu
         mVukBLoorqL6jP+fitWKr/CPIhbf6aFlCCA3o/U+hs6DpzS+bf6o6rPsJFWPdlhioDdh
         BFIaHGUX8u97I62KrRv4soCbhK/HDwzrdVGtPJWBNYyxQvMM5FElrmWc7WoI4vy/nHdS
         C8bA==
X-Forwarded-Encrypted: i=1; AL+hErHkzDuAkFMIql/xeknXHDYvOO6kwXkxfsHhT0SkNNfMHF6btGuYidxB2i9ebeTAOBGOPOslUsLvMHofMRY=@vger.kernel.org
X-Gm-Message-State: APuU4Z9QtXkzAhfNywa3vzKISuUhEMULi6l20SErYsuTygSDRyID7c0w
	NcQO9/kfi5NHdg0/HmzXQDK2ttohrVDCcWFdUZemhsYzEHzLWU5c5Wsuor4BOPpg09M=
X-Gm-Gg: AYBFou2Jymm98nzSIsUDniwtROVFEqQeT37B8i9MNa8Fl73kBk1E646D4k4xpwbRBUI
	H11yx0MHnyVUwWpCBFqfRL0CfFs6za46eGSH7hnAwP2y1KVFanJABJhl4gXtsGH4VkAPsti5VUH
	KaoC/UXKpIW6/6N/D6xS+QafyOBBTShrKxaadM2SS/g5kSanxifRcKoyfDBuvFmcv5Nf6N0UEcY
	qc6w4ybOs6YKzpDfdF2J7+/CdGSt15J6ZSWN+gHK2YU6fpTZa6qhRA1MJhwiVWXgXzKUYpf9VXI
	AkA6UGkrKwsSbqgUS9h+q6PF144mDr7E1T838F/iu8+q4WPYHDpVsX6d72XOrh+9zPw23ES9gZj
	39FVn7asRd7YlbP4UgyX4DlxPvV/ulf8v1IJ1Lh9p11BzllbnvIfrqp9ZOz1LbOsh/WVr9Ig2iW
	vdBnEbpj6SY9lLdUEqrc5sDLTMnc9GGYFhTimEwKnIwg9Td9d0GCIPvozpZYnZwiQbiuTCF+GZ9
	TaaHMp/lno3AwkmE/YaS1VtswEKojdOKju+Z3dGaBSD1N6OyVwHRoVyjNqKAkoNkrP//BI1b9XB
	zBICVAj+raThpuFgjCAOTYMk05mPXmB5elEwcAwQbuLoYXTtyOxT3z4IsO8yv1hOw0njgRK0CRK
	/2T2y4rw/WPzBFgORvqQVmdE0zkZOHT8zPlVOzA==
X-Received: by 2002:a05:6a00:230c:b0:8ba:f51a:1bc1 with SMTP id d2e1a72fcca58-8c5d3639dadmr5519001b3a.24.1795094243488;
        Thu, 19 Nov 2026 05:17:23 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:1076:1f1f:dde8:a816])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c5c7f99f91sm2809467b3a.5.2026.11.19.05.17.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 05:17:23 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sagi@grimberg.me,
	jgg@ziepe.ca,
	leon@kernel.org,
	mkp@kernel.org
Cc: linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 4/4] IB/isert: do not leak the receive descriptor of a dropped Data-Out
Date: Thu, 19 Nov 2026 22:17:00 +0900
Message-ID: <20261119131700.2722108-5-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261119131700.2722108-1-yhlee@isslab.korea.ac.kr>
References: <20261119131700.2722108-1-yhlee@isslab.korea.ac.kr>
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

