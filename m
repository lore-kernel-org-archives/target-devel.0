Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794739234;
	b=MTI1/W+WurwkBmSYsveZTUyZH1MS123XCcDmk6eLSDcOViHLbNCQguIU75i+Yi2Xpzit
	 JNGv9Tk7n+zy9+1BAI5XtwpHHmMiP095MAkglSlrcX1vtFCGNkC+uyaa5O4Rhhg/QjtBy
	 bS4iwUlac4pby17yz14w729NjtBzR9a7ghiHxk9I9GLKkp91OZYM2L7XsL6PJ9oAiXF3j
	 eNwcQaGmqLI1X7YzEPxEN7vw3tnEOTVN0RRLAa45VPH5+TRQ4u6qOf+aynRh74HpEF1Bz
	 9VU0ZHgV9yKpru5efvN6J0vwwhFb87DW4cbWwPSC70S5SCO10JJVRSY+kvHaNR4ZlYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794739234;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SexY85KTBkcPpSSz9lzCXLt6aG4hGRBeEAEDC3GPaE4=;
	b=WrWG2WwxLBOF7wF0rLKezKfIeW/WeQ4lFAZ+cnnoD54h1Q8VFYoHUe4tK89cTQ/6nLo6
	 gLMBEPrJv4piHKesrJzn9kCmFQuVistKmnMCrYNoBHXxhb1n2iGa+0epsrBKlqtPxedVN
	 5Uc8quMfCqob6u2tqSHX1j1Cvvyh1kOvTeEbwkRV4JpAx9Dvwn1X3vY0vNikUaU5m763p
	 jIYCvCbwNVSHGRJWeQGNG9PMotFlE5+Jftk26cIL6ft0n2EGA3r/AB9kFVnSTzkftGWHQ
	 yFvhH0USoLAJ89WetAjF9r8RpQ4g60P8paqqycyNsg8VTNvVAc6T/RUvHmXfEWHJl2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=aJz93gn6;
	arc=none smtp.remote-ip=209.85.216.42
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2127606A883
	for <target-devel@vger.kernel.org>; Sun, 15 Nov 2026 10:40:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E2127606A883
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=aJz93gn6
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3b155f50c24so3599372a91.3
        for <target-devel@vger.kernel.org>; Sun, 15 Nov 2026 02:40:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794739233; x=1795344033; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SexY85KTBkcPpSSz9lzCXLt6aG4hGRBeEAEDC3GPaE4=;
        b=aJz93gn60oQrWRhk19r5rrqgl8h5ouq1q2TpxrDF7I6W2npEFiCPrMR0obV/dLg3Dh
         A34f8HBYPYnaBH7KUORMLnYN2Lp9fJO722RkkKVl0Du9O1Ra/Vb9Jh/UGHCvYGoYO8h+
         9P9mVa2mvaSXPAi+kkVW1K4ZvvQ/oec4lA0DehAdTrQB5M6nefO0QGxW5UPCUo1+t/Ae
         /aS2wv3XadJ5jkgluS49wzJGuifg0EkX00tfBSQipRiFTLNAVeItRIG4Dpk5yez0yaDi
         6Xs/Q7tXzW+qfUbCtuE30eGn8Pv+Hj9mPIoVojsvsNsAV3z5uPuFwe7ywT/o1okGjF0e
         psQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794739233; x=1795344033;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SexY85KTBkcPpSSz9lzCXLt6aG4hGRBeEAEDC3GPaE4=;
        b=TAM5WE26HuP0OJQtORP5eMDTLh7tMkgirsjJu/+OjOXHKWiyqIMTlyzObwhY7XmuwJ
         AEHG+uA52VVDyl4M1XvLRFkpQcXeikDz7c4pow7ioiC3HA84Yd0eS5bZvddr/TbMINOC
         APz13HsB6FkMjlQnzrZD5Omn92cW43Fw1v38/Ws742i7CWhbJr/nRgc5zwJA4YaeiikK
         ViHHsAXEjEFjK8BSiHbKOQTp/NdQUYZanc09jHpKNhmM6q6mP7ufJ+dN7OXtjsyG7sBx
         ZIdpCvCXxU48/LHN8uSlkimxy6v0R9vF1bGwUCEju0eH5e3sOwQerlhw5qJNhYR25mAC
         gXag==
X-Forwarded-Encrypted: i=1; AL+hErHNLiP1plsLILuV+WE0kEZIBpSE9lwTUt8IzXlVMbnkvRTJoI5E3Y9bjAg8G/PTEeEr3iqtOFEYlXgXwMs=@vger.kernel.org
X-Gm-Message-State: APuU4Z+FgRFyJ3wtzBCLaRGR+chyTct2XuW6CPRPudQRn0g4oJD2aFxv
	C57IfmOesS5ZsAnfcpsdfW+VJi58qT6m/AxDYOx3Ah1OScSUzTw2GniH
X-Gm-Gg: AYBFou0D8mD4dvY9HI4yJVf1qhUkunOUH/sUbgssRcx0bNiglpdS8FR8g0kXVNoSuh9
	0EZX28ORFZ3n2ZkT7MuM+sKJpQxEYqSbA98bRqZFrquD6SCAOHyArh4ZssMmCpgPUfwj2qcg2+7
	M9/kjtMi6OwCCdLxr0FW7fiEII9ZKbPCGRhUTiuoVgOl7iUmhfvI+ZqzSPXzoEevKD6d1L05y93
	DI8Axqvy4/twZKVLuBChRzl3dvEPVwUIygaE0+uqkXSVcb2/ZncVC7Qil8kj+ordPmI5/oRt2z1
	2Wktx33ne9LsJxMCrPsTG/bGNTMC6GouFccWnpnWl0kEU2NHOGEgenBpHSgTGBmy5OVNeJX75cV
	ch0+cnYcMWa5s73O2dF1/ZkfZfFkS/fw+x7AHguPChaRQG7YFD2LBjc1e/EYICPqeG3mE4gT4Mc
	ax1q3MskZVpIRTHgeCfqIpInTccPeNvBsgWsUmHyAFtlf5j+LLJbhOk3NBUWxnrr8Z/og6ca0lZ
	FWZsznrAFjEQu71r6LUrzEqxIZQyMuuFGUYNEFt4YfCpszb1Xy8aUPMaOJqVwdufCppXnoy57qz
	W6+FQ7CAS4NUfls47su/Lpr3bXT99DmAu3TSls6if2vhBu0n6niRGwuZZt+WFRbsPRmJWPyO91z
	iWi7GLlJEhY28MYpugUyFVFP1ZQD1kcL2MosUN7Sqq/cEexTHRJ8VM/hgQqd9AJgGzWYiLIeeXB
	ixtibD01tdnfN7r3q0SwCw5vi1uFAAN/wC0W2TB607ZNZEacXoOU+e6Uik/xD+fmLDAqZ6saoTs
	CthmASsT4EHQP6dGVO0C6bT83mIJlEET1JuGWt6vkiTuYFMs01zHV4krJ1ZgSXm
X-Received: by 2002:a17:90b:5107:b0:3ac:9d83:885e with SMTP id 98e67ed59e1d1-3b1b0d06feamr7368179a91.52.1794739233252;
        Sun, 15 Nov 2026 02:40:33 -0800 (PST)
Received: from localhost.localdomain (123-243-92-89.static.tpgi.com.au. [123.243.92.89])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ee0f8d4612sm26739145ad.57.2026.11.15.02.40.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 02:40:32 -0800 (PST)
From: Daniel Wade <danjwade95@gmail.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: Maurizio Lombardi <mlombard@redhat.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Sujal Tuladhar <sujaltuladhar1231@gmail.com>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] scsi: target: iscsi: factor out iscsit_stop_kthreads()
Date: Sun, 15 Nov 2026 21:10:05 +1030
Message-Id: <e6199ca99e81a80af4c4c8f43885c628377b22d2.1794739041.git.danjwade95@gmail.com>
X-Mailer: git-send-email 2.39.0.windows.2
In-Reply-To: <cover.1794739041.git.danjwade95@gmail.com>
References: <cover.1794739041.git.danjwade95@gmail.com>
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

