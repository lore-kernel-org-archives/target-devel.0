Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794733166;
	b=Q4/OoSTCirboYbY7EN0l4CMJx77ikAUBeURA7kM/LFm0B3fOGRtKCEPz7v4IAGiMP77Y
	 byNFDH7pW4Z4NjQ8IqxH58lLMYnB0vEIw92BsJniNcFUs/HNQJkNZScx5uJCYytEP1zHi
	 xpx1KNWDRCC7uy/wJMdvY3tVWVOuwRP2S7TDk25/dh4lxX3lCHuEusuNyNKA2rY0I1Q2O
	 fHRdMTRHVxkWVd1S/49h3Dpy+MhTmlAqN0IEe4cZdv5+HcQ66AOYEg+JhZa7+nld8gMHh
	 c1kIfI7+41xeYTh06Q6XSL5Pl4zCYTJ2rwO495OKfPdDUYcAGlJ69zdbi6pXJcM+u4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794733166;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SexY85KTBkcPpSSz9lzCXLt6aG4hGRBeEAEDC3GPaE4=;
	b=xMjytRqezojG5l+LKeVdqiPCfYRVGReY1NnOhr7/qiqycthKjkIXlFdFuW6sNCTOF6EI
	 wmYJ0kYqvSQ1nmFlUBJSjemABShpPKFA2YiIbnjnpEDAgoiUu8qIe3A7HHaaIZ2BMmjEd
	 hv4m1JWNmMb7QkaX9uLFUGqStR+edwHAsCo4saZPFe99sqQLkUhXNyaccRAxAnnH9Abbv
	 RisLzhSvAY+yh854xVHffoEhSCPV8DeXtiVoNiIYPqUlfdYn/WaYrGnPHJAVt8MxQ0zGH
	 nbG7RIHno8Fi6v7bu3uRqw27Epx5T8CcpRS5Sp2UOGFIOoQNIMULYdZc2dyACf9WCxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="ufvbUa/C";
	arc=none smtp.remote-ip=209.85.214.172
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1189606A31F
	for <target-devel@vger.kernel.org>; Sun, 15 Nov 2026 08:59:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C1189606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ufvbUa/C
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2e946155442so29416525ad.3
        for <target-devel@vger.kernel.org>; Sun, 15 Nov 2026 00:59:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794733165; x=1795337965; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SexY85KTBkcPpSSz9lzCXLt6aG4hGRBeEAEDC3GPaE4=;
        b=ufvbUa/CyNW0QD0sqLv86lbibrg8v63JuwXnM1pa1hOYQdWUVenxsUMM2kFXbx79Ny
         OAbopnSnMkUkMKjjWSXq4lqymggXuo01tyM0LiselI0JGGsIHkVmVv1naJpqw1KHf373
         QY2R+TGyz5zqKN/cs74io7f3GEBznRH656w7mE0C17ntInTbvIwwKDTpw2PTdlA9WST5
         TxLT/CmdK3E4/3pWOj0kA0iR0rr67q97i+IYdQtqDq5mKshfQGK1GOdqXEYPO8ASF3AD
         klpE2OffPXghSxNUk6GK9J/WKYdaDyngjV+4KQjgBUKyQGFOXuNBfozb+n7p8ycWsNTe
         y3CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794733165; x=1795337965;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SexY85KTBkcPpSSz9lzCXLt6aG4hGRBeEAEDC3GPaE4=;
        b=ZNwkyUka+uKut6vQh6Q6jnmuyucyB2Qw8azlCDCBaqacN3lxKS9dAXVcIdEfUj0pnL
         MBZgtbERFIJAwAiZpL0HNkJiASi1fvb461qV6DbAR7XMEW7BNygVp5eTEcq8192uFyOj
         gTy9+BPPn00Cl82GI6fBR0oimCeErlgWMUuNjSFGACrbQVvZ2h15M3LBLxFdqxFtaw22
         ANAZS58n0dTY3SzJFRSdXQnDD1cCxugtjaCIOl8XNrkKAfWtxWE8hFtWolFQ+J8zQTgG
         1L5ARrmCE8ce15SjvImRSjpmd01++tcrbBTNERTSJalTVD9CfAcuQQphFaHSuv6sCazZ
         IWsA==
X-Forwarded-Encrypted: i=1; AL+hErEiyUzYl8oZkoACAp84EiEJEtzcrW03mHO2VTirOF1E8ImDdiDox6UUC8aXRwG08qkBG58Wu/1VSqhLF0c=@vger.kernel.org
X-Gm-Message-State: APuU4Z//BlOwRd9lQDJtfG8yyNNOYNDdrcpsv8BeyA0q1vAH2G4hVvu7
	d5kVmusyPXSdGPkcCVFLvgcJmHRVBoD87aIWtOO6+dmS9EQFLs3uRoVr
X-Gm-Gg: AYBFou0JNr4ifdGX8cmHmo9zog3fmiS+T+ZIdRSWlF2OvXe1BREnWFgMfqCCJAXtLV1
	LkcBvcXpXyA/xvZt7mIoIfOXypJYwnpsb7p4UAzEgCiVwp/bVHz/dqglUx31LR4G0P2kl3Cje3i
	j4hybVi841HHq9jDr4Y4h97rX0ACtcl3XQM0pvqaQAcGT0cZWySc+9OmpVI7Cm0yLd+uCEIzQ9S
	v4rRQWTUA5GANVutYdTkIHzy82K3OszDmkn9+FoY3hBDL2XBkhtw9n2A0C3KA+ImDIT/bxIEtoa
	hErW7jJ2KlqUUPlSFRLLexShvh6woOMnysbI3o74gRAnVAFVz4JkvDpRECDjWWR4fFh8WP1tjLx
	lUSoljVT+rWuXWERAOJsj4TBloLKDbaBYdJJPhthYH2wXwUNKfg1ImKkFjLGul+GjQ5600qALCw
	cpAQJ/bL7HB3rgJfX9IPqJfRSHD2aQLvvKACBqkoiZmZ1LRP21iEPQ80C+3UOtlRhcv0RapmSct
	zBbD57E4bm2Al46imYv41BVGLNnKOzxrcHIM5hsSTv+/ZZSucdROVJ4ZXLqDnWPc/XRw78uBunh
	L2dClB2rOFEwJiKb/SuYUpXsA0WXr+/insKz5mErSi7AEx0Bl4SHJZKGomMRjMLECQ+SY84kho8
	7haCHbOOHdb5iEed92iTov57ousEXYfxHWuhcld4ZnupQBE7XgWv1FH5jE7cQfQMLAFcE6Rv+iT
	Sof/j9/WXCj7CfTndLFXxcbCQH7/xdz/E7n+Ks7Q6aDsqShU5V1ZtIdH7fKxmiQHVRd4PQyNMIK
	AuTJ1HzTyv65UoitV6pHMgXcUgFHKsvOjU1gAHf84LQVsbk7hcZZyXih1MjM/uwH3IMkhxvDJV/
	aQ3dH67Pbg==
X-Received: by 2002:a17:90b:498e:b0:3ab:4f1:4f76 with SMTP id 98e67ed59e1d1-3b1b0ba0ac4mr7507738a91.24.1794733164961;
        Sun, 15 Nov 2026 00:59:24 -0800 (PST)
Received: from localhost.localdomain (123-243-92-89.static.tpgi.com.au. [123.243.92.89])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b197c6c9c5sm16770310a91.1.2026.11.15.00.59.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 00:59:24 -0800 (PST)
From: Daniel Wade <danjwade95@gmail.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: Maurizio Lombardi <mlombard@redhat.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Sujal Tuladhar <sujaltuladhar1231@gmail.com>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] scsi: target: iscsi: factor out iscsit_stop_kthreads()
Date: Sun, 15 Nov 2026 19:27:44 +1030
Message-Id: <e6199ca99e81a80af4c4c8f43885c628377b22d2.1794732723.git.danjwade95@gmail.com>
X-Mailer: git-send-email 2.39.0.windows.2
In-Reply-To: <cover.1794732723.git.danjwade95@gmail.com>
References: <cover.1794732723.git.danjwade95@gmail.com>
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

iscsi_target_do_tx_login_io() stops a connection's RX and TX kthreads
and releases its thread-set bitmap slot inline on its error path. The
next patch needs that same teardown from iscsi_post_login_handler(), so
move it to a helper beside iscsit_start_kthreads().

No functional change.

Cc: stable@vger.kernel.org
Signed-off-by: Daniel Wade <danjwade95@gmail.com>
---
 drivers/target/iscsi/iscsi_target_login.c | 17 +++++++++++++++++
 drivers/target/iscsi/iscsi_target_login.h |  1 +
 drivers/target/iscsi/iscsi_target_nego.c  | 17 ++---------------
 3 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index c282b6a7029..f4df5518171 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -643,6 +643,23 @@ int iscsit_start_kthreads(struct iscsit_conn *conn)
 	return ret;
 }
 
+void iscsit_stop_kthreads(struct iscsit_conn *conn)
+{
+	if (conn->rx_thread && conn->rx_thread_active) {
+		send_sig(SIGINT, conn->rx_thread, 1);
+		complete(&conn->rx_login_comp);
+		kthread_stop(conn->rx_thread);
+	}
+	if (conn->tx_thread && conn->tx_thread_active) {
+		send_sig(SIGINT, conn->tx_thread, 1);
+		kthread_stop(conn->tx_thread);
+	}
+	spin_lock(&iscsit_global->ts_bitmap_lock);
+	bitmap_release_region(iscsit_global->ts_bitmap, conn->bitmap_id,
+			      get_order(1));
+	spin_unlock(&iscsit_global->ts_bitmap_lock);
+}
+
 void iscsi_post_login_handler(
 	struct iscsi_np *np,
 	struct iscsit_conn *conn,
diff --git a/drivers/target/iscsi/iscsi_target_login.h b/drivers/target/iscsi/iscsi_target_login.h
index 03c7d695d58..02c5f6ecbec 100644
--- a/drivers/target/iscsi/iscsi_target_login.h
+++ b/drivers/target/iscsi/iscsi_target_login.h
@@ -20,6 +20,7 @@ extern int iscsit_get_login_rx(struct iscsit_conn *, struct iscsi_login *);
 extern int iscsit_put_login_tx(struct iscsit_conn *, struct iscsi_login *, u32);
 extern void iscsit_free_conn(struct iscsit_conn *);
 extern int iscsit_start_kthreads(struct iscsit_conn *);
+extern void iscsit_stop_kthreads(struct iscsit_conn *);
 extern void iscsi_post_login_handler(struct iscsi_np *, struct iscsit_conn *, u8);
 extern void iscsi_target_login_sess_out(struct iscsit_conn *, bool, bool);
 extern int iscsi_target_login_thread(void *);
diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index b03ed154ca3..d56b28446d3 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -362,21 +362,8 @@ static int iscsi_target_do_tx_login_io(struct iscsit_conn *conn, struct iscsi_lo
 	return 0;
 
 err:
-	if (login->login_complete) {
-		if (conn->rx_thread && conn->rx_thread_active) {
-			send_sig(SIGINT, conn->rx_thread, 1);
-			complete(&conn->rx_login_comp);
-			kthread_stop(conn->rx_thread);
-		}
-		if (conn->tx_thread && conn->tx_thread_active) {
-			send_sig(SIGINT, conn->tx_thread, 1);
-			kthread_stop(conn->tx_thread);
-		}
-		spin_lock(&iscsit_global->ts_bitmap_lock);
-		bitmap_release_region(iscsit_global->ts_bitmap, conn->bitmap_id,
-				      get_order(1));
-		spin_unlock(&iscsit_global->ts_bitmap_lock);
-	}
+	if (login->login_complete)
+		iscsit_stop_kthreads(conn);
 	return -1;
 }
 
-- 
2.39.0.windows.2

