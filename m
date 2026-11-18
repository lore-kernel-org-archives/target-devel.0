Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795001967;
	b=a/VRtbG/GfjTdY+icaXqhmBITVVgsomlF824v8eidj4cwVHiT4qVYCO0NEA9Aj2O8xN1
	 BU1GWszUPEkoWc9750GXNZUa0sTNXRn37jI7WUtnk7qKlOiY+b0U+nFLTJ42W/vuBGPkK
	 AH1fs22J48rOlCYDHJw56nKdP7xZsbRcIb00+FKY7Qhm6v0h9MzXrN4fe5tYmvJius1sd
	 Ycd1hoa7LSC1ccpMQD7p1BkybSQ98LqP27EuHjc/+wGr4S1fRkVLZ9BtVpjaM06rFIUPU
	 IZCyHXoXuE+ykl5ds+F4Blm9NBfomn8Se9h5ekndeVaIE/xFqRvBPsYai9k7CMJCY4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795001967;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1F5PhsVSMvlAKbqeP5i5JDJo+bg6gq7qbiCDaCKQio0=;
	b=NEXp3Jhrmk7/AMSYNhJdlOCl6UQzTtsHHaQnMOj3GKj97Q+BnOl/3/U4i5hOvam5w+Gf
	 M2R1g0Pn9jd2GHUWB7q1gKCGfacIVeD5NegORQ5lFMnxx5hC0Jnz7TOTOdOqVp3VGB6ps
	 SBMv0+toy1Oh38tpXG2KAsejS1iO77WHksxNrawmF0hWmDigxbeJbPFmiavvnY3Gf05yJ
	 8e9GgEJFrX0OfaxhvbViMNwcqAtF5qFaH6y70FNsb8Mk2bLKxdWRtklsJKwM3jLPw9XgJ
	 QgaixJ3ZrMbH8q8cOZqYuXfZXQN8n+hQpH5Z6c2iT27+9a6ybkJWpHw8N362OI1pnUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Q47akWcP;
	arc=none smtp.remote-ip=74.125.82.47
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3D9606A333
	for <target-devel@vger.kernel.org>; Wed, 18 Nov 2026 11:39:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DF3D9606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Q47akWcP
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-1a2af4c8d00so1758687c88.0
        for <target-devel@vger.kernel.org>; Wed, 18 Nov 2026 03:39:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795001966; x=1795606766; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1F5PhsVSMvlAKbqeP5i5JDJo+bg6gq7qbiCDaCKQio0=;
        b=Q47akWcPtA5FiPd6ZuJYeD3bZtbUIIDPkSCk+a0Ar7dv6cLiUvyNqhidnDc8QI/d//
         0WOL3fLcco1KOikDVg4p2tKn59d8u9TbkiMLb5FBoSS0Fy49p3PxtcMkVkk4WzUsGcb0
         y5h5gmKD1Gn/hMF0R8gqLXou/uVnQrx5LNIoPDEIZyjtIK/fNSk4aTCAAMrlacEBh5wP
         3c3WNfS0I9lBNriwo2iS84p8ENJUu+Mhfp00C7fbtc2hMpmMqnO7++0LNP6MBL6Al0sv
         Xr1cOh8eYDJjJ4mX1k0XaNphFuicghaf6M6FjXjKMOAdX3BJYfqmCnol7xUwTdQ9oX7o
         P3fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795001966; x=1795606766;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1F5PhsVSMvlAKbqeP5i5JDJo+bg6gq7qbiCDaCKQio0=;
        b=Drvfu1+rbfwL/aZ7/yJeqCYiKiKlNYVnAKGG41DieSsQsCNoWREZFPJaintMHTY6dY
         2nUNCw1PCKsVM3gt4jnNIlB8ZnbsggkdNSulyVJuMwX8Rqp+SQeivFhDsk+1TlykpKWV
         DgtooVOQ2bBEUMQjTen+CY3NxkTibDlIb2T1oZPzdlTY8fjkD2W+Zgqm77JibqF1IeZB
         9BLWsbrqJZjBOkl4E6mtkEZy+zLXwh2HX41Kqv+nVLlGm9HnrsHJac0G1ozwzFZ485IX
         RVc1F18I1cZHNNOh2lUqTT4nhvFqqlkqntJIB1K82XUr1Lt/PgrxbxqO6HwVgIfoWRfR
         x1pQ==
X-Forwarded-Encrypted: i=1; AL+hErFEF62m0i2IEumHNIhHGkbZNGYhdT0iYYKaxQQ6o73vW/FUh4NjTU6WlL2/uuWkE7x2BJKoGBbHblc1LLo=@vger.kernel.org
X-Gm-Message-State: APuU4Z/l1+79t8hZDPByHeZK4t/QEWOlSQH5LLlvgSEuNBqpq6dh8S5J
	CZi7F7ZKMyFvW/O8C5wOoHn8u+JpeKm5s3FFRqwEIzHP3wPNYQzMLrNb2HBo1QP3hQU=
X-Gm-Gg: AYBFou3WSDLU1bujudd7Zt8xq/0gIBrRVOvC6fduTIHIUXIb3KfR91BnQmgZHOVLss+
	Go702NNZrv2EMBxlnDUORwt81/sls6Y6VN9jKgQBsVHljZvSQArAr+BSakCLe52xMtl8KeGBCuA
	xFCKrziJwrLxPS0RMlKi0LT9Rj10XJGnKoN306qCRReKv3/a81rFIidyjSknhgHAa5sgeMd+21e
	mXKuMWRzB4EOotfyh51fRWStINTcVrjDjwF7+MzEkF3oazoZ+TWA409+nkselfvpWElyOGWM/oy
	SnUOF7SCxvAFsXgN71EriLnEX3fLaijGYiuZFCyxtLacoFEeKGNUQsMa6sSH9rZaA0jWzKQybMj
	OhuIYnj+0kkaF/rs3wwHK3WZkNzdOnTTEr16/+AvzK7LLe7jJ/ruqdN2ZHYueMNrzkR8NNY7X8/
	xDEEkZYqNnOZtmhWXJDbUCJpMa+y9LIXuhu4DenXu7sGeIbzDUk6B6CxsUAC9rTBWWDwm5+PRDu
	gVtD7oyefMiip3srTkCNDjXLLf03haKUbanUrocdwNNPnvIJFfoVX9TDii8fCZl1fFQyRRYxOLr
	tPUhMp4HgVfXd2oSlWGVLQftzte1MCM2t7qSgMRQJXrnK3XsNHusf4AEO8YUi5TtvUYWe3wBptp
	uupsNj2Yxwfk6taKZzoXV+Tp2w5te4TwZQmHtDw==
X-Received: by 2002:a05:701b:21c5:b0:1b3:aee5:20c5 with SMTP id a92af1059eb24-1b543d02824mr2306544c88.22.1795001965044;
        Wed, 18 Nov 2026 03:39:25 -0800 (PST)
Received: from localhost.localdomain ([2406:5900:1044:110c:e78e:f7f0:2120:34e7])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5446f954dsm6044662c88.2.2026.11.18.03.39.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 03:39:24 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sagi@grimberg.me,
	jgg@ziepe.ca,
	leon@kernel.org,
	mkp@kernel.org
Cc: linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/4] IB/isert: do not leak the receive descriptor of a dropped Data-Out
Date: Wed, 18 Nov 2026 20:39:05 +0900
Message-ID: <20261118113905.2361969-5-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261118113905.2361969-1-yhlee@isslab.korea.ac.kr>
References: <20261118113905.2361969-1-yhlee@isslab.korea.ac.kr>
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

