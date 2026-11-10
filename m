Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794280218;
	b=5TadtQE2p8ZQzhNffpP69/IUtOZNyod5k7Qhjmb8kCLulvthJBFHkwIE8LiJae7PB4XF
	 +voxOA5MtccoaOiQvReZMkH5yxgCuHZ5+5+5P4QK1p0fEbe3cNePMUeIc2xKIgJKdUJvp
	 95eExTYOtBR7BRrnp9+TyQ41smPzju8qcs6E5NSvnJqMesIidl+nuw/+BZ6t6kG9aygd6
	 mAMB7MpoiZ5kTSZbDqyR+mD4cd2/1P/otgFJ85vAmZRBVH6wixw3CGOW3v+euK2z5CyfP
	 wQ0GQJb8Fkxxs7ih0AnOU6NmKN9/j4+Opm12bECIrpk5/chmyfbdptMIKhRjy6m6OYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794280218;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n3sfGKW7S9id4w6EJ1yBLSVpVy17lWswp5agSoZ8nvI=;
	b=MF/4NeQFqP6bvMaAYx4a1iOGYCt3ebRrKrQsaepGUUSqng66gQYBMxpsEfzd2QW+lsWZ
	 FzjMIWb3Mtd193lBq8wwngLXWOfO5fNV5sw3Kx3uapzEtE3ZjJ7CxlWEAlFxE+ZFoYgCh
	 Yx61E1bijDqgSzm9p9J0wu2sLEcziE6Z+Es1xf+Sekoq5OxmQI8Wxq4nV9FOxxoZFS8bk
	 iNkf1EuBzprwDpKiWGlEacOqO2rp01aLVv9y42/vPeQoXdEgEgXtxLer633Rh9WXrTopG
	 3CqoMUeGbgPHJjFIl+Fd4475pJ2uvz2rgOPHkjUSuY6zRTzZ7nvZ3TS6YP50PZFCotg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DYpm3Hpn;
	arc=none smtp.remote-ip=209.85.210.180
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464E4606A335
	for <target-devel@vger.kernel.org>; Tue, 10 Nov 2026 03:10:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 464E4606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DYpm3Hpn
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-89d6bd67045so783147b3a.0
        for <target-devel@vger.kernel.org>; Mon, 09 Nov 2026 19:10:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794280217; x=1794885017; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n3sfGKW7S9id4w6EJ1yBLSVpVy17lWswp5agSoZ8nvI=;
        b=DYpm3HpnJ+GzIwSECRt5WR39dUsLBo3DTMselW6Zj3ZQjnSK/25qvLf+DxdTelq+Mz
         pUYKNlXEe7iDHrX6QoX8QFmxgfjV6diDh8sRgYR5gkBGeUqgI+AOcifvgqT4qFcfIpH7
         BjR1DDaD5ZUYYPJsSwINXE0JwgEUIR8Lk0R2NcWsXbrvekrll7UItUNWO9VPT3XQcOTa
         4ipLv9+uYnMcIlzfA0zTJ1Ru50EGS49Xqm1y2pKemiG7QmMd2Bp4WCBzlx3kHZJWfvEN
         yerC9JHPW4Ba8Bj2GRXkXNgPwMW5R0og4UJCHQ0u+PR7twNDzOdus4biyT+Tl1x2MbJE
         YevA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794280217; x=1794885017;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=n3sfGKW7S9id4w6EJ1yBLSVpVy17lWswp5agSoZ8nvI=;
        b=U5G/sPXE6wPNXjv4jaSIzgNdV5kuvQZKJQbSVmjqKP3ZCQiDSfR4OKt61WfAr9l5Cw
         uZ4GQhcJcq+sYUMU+2Pm9aSsiWagoQHV1x/7y+I/gYf4zeYqdwLO+t//Bwwan4cq3gME
         H8lUUvXEAbL3sdgsMBwleRC6KJhsAuVeAI7VJPT1MKwMAusdAR/K7aMY9iHm34Eh+u4+
         1CSmqldaGIW5iSEVtf3Vss5xmLqY49niVE+/FBg0U7l8n5m0WY7oUcPlykVzv8GSugg5
         59YwZjscyf8j4+JAVgO25wU2xbPFdScaNiWEhbOEpWV0qTRFZHC8C5bbhJU009ZiH/nn
         5itQ==
X-Forwarded-Encrypted: i=1; AL+hErEJsHfYxkePFhTRhaH3W3W8VJS+QhkggBgc0SalXrUZlqVWAK0xhzayEr3oeuzuwkvJHxJR+l6LGvuTBlQ=@vger.kernel.org
X-Gm-Message-State: APuU4Z8rkizFOZXY7ObKN7B19tVTQPRzubRDbMMXu0pxqC6VC8sjBPBJ
	6mRlT3V9Or+JYueQ/oIa3TSlDib9zDVk7lDQWiXfg0bXoQhEvO8aGjhs
X-Gm-Gg: AYBFou385DRBF2f9GKYGHRjNsqMUQQ4OFPoAoXhtZhWp8YjK/Bt8h7U2pB8vH26tHk6
	jkqiQno7nUC1mnLilpSXKQCn2fxQKXvM+x+D5oHmWVNPBBJAR1ApPSYvnxmTHZWw85IisUlFMa4
	tKVkinnNbcjdCgL+YGEKhX2Kg5L5aqHDxFt4MR+tyhswgHYnjwX6KhmVITAukD9Ps4y3lXRygOj
	aMzVo1phcMpOX3vx8kzTQ5EzA6RStPGgXGgGF1HHCcXZ7MAjyHe+hmleZpe+sUZrXUxpoYYqSHL
	9Sf/fieAvHf47MOtUi4klDvzBMsOoUIeta22wcMeEXGCFwR8g4eJngH7JkDA8mAutvJ2bPyGIkK
	Xmre/pv0D1p+fx2aQx0fLlhIq/WdlNcV1G+SgJpIp5h09KT/r1mYp/YIFWCu+jF9pozss2d76m0
	FwrI7V3oNIhnlvfsY6g9IwXikICk3M6ngpIS3SNbP5Cbi0/KfkxA42yf5W59uPqe0UCBB1y7EE2
	F1HAS1vslYD88bbSZx7kDVdJITnckienCWc5kgFZy2d+J75xk9MaTFY/bx709+rYGxMWq1npPJE
	dhfaLMSgUfe8wW7A0q2B6Gir2t6lA8iPYGmA/s9KSkY=
X-Received: by 2002:a05:6a00:4009:b0:8b5:b292:85e2 with SMTP id d2e1a72fcca58-8ba95e80f66mr929417b3a.26.1794280216611;
        Mon, 09 Nov 2026 19:10:16 -0800 (PST)
Received: from localhost.localdomain ([183.62.176.219])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baab8dffb5sm308939b3a.55.2026.11.09.19.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 19:10:16 -0800 (PST)
From: liuyong <pkfxxxing@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	security@kernel.org
Subject: [PATCH 1/1] RDMA/srpt: Limit read data transfers to the command length
Date: Tue, 10 Nov 2026 11:08:06 +0800
Message-ID: <20261110030809.913063-2-pkfxxxing@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261110030809.913063-1-pkfxxxing@gmail.com>
References: <20261110030809.913063-1-pkfxxxing@gmail.com>
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

SRPT builds RDMA contexts from the initiator's buffer descriptors before
parsing the CDB. For a READ underflow, target core reduces
cmd->data_length, but the prebuilt RDMA WRITE requests still cover the
full descriptor length. A backend such as rd_mcp fills only the shortened
command length, allowing the uninitialized tail to reach the initiator.

A remote initiator with access to the LUN can therefore read
uninitialized target kernel memory beyond the requested SCSI data,
potentially exposing sensitive data left from previous uses of those
pages.

For a READ underflow, limit the data SGEs in the RDMA WRITE chain to
cmd->data_length before posting it. Preserve memory registration and
invalidation requests, and retain zero-length RDMA WRITEs beyond the
limit so that work-request accounting and resource cleanup remain
unchanged.

The issue was discovered and fixed by Qihoo 360's Tulongfeng multi-agent
system.

Fixes: b99f8e4d7bcd ("IB/srpt: convert to the generic RDMA READ/WRITE API")
Cc: stable@vger.kernel.org
Signed-off-by: liuyong <pkfxxxing@gmail.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 43c3ff1ad..2f7857ef4 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2913,6 +2913,26 @@ static void srpt_queue_response(struct se_cmd *cmd)
 			first_wr = rdma_rw_ctx_wrs(&ctx->rw, ch->qp,
 					ch->sport->port, NULL, first_wr);
 		}
+
+		if (cmd->se_cmd_flags & SCF_UNDERFLOW_BIT) {
+			struct ib_send_wr *wr;
+			u32 data_len = cmd->data_length;
+
+			/* Keep MR operations and WR accounting unchanged. */
+			for (wr = first_wr; wr != &send_wr; wr = wr->next) {
+				int j;
+
+				if (wr->opcode != IB_WR_RDMA_WRITE)
+					continue;
+				for (j = 0; j < wr->num_sge && data_len; j++) {
+					struct ib_sge *sge = &wr->sg_list[j];
+
+					sge->length = min(sge->length, data_len);
+					data_len -= sge->length;
+				}
+				wr->num_sge = j;
+			}
+		}
 	}
 
 	if (state != SRPT_STATE_MGMT)
