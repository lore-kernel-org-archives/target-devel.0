Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794733174;
	b=mSD6tvOeX6s3QYRn5mVw5B64633eqGImhmsjZQT2xx00qZbvHQ9jxxwuTBeBmjkWuuCi
	 Uh9R03vChGwroW+J2LZ/cWkNqFO3CfYferOpe9w2y1+uo4FTUrfKn88Q8ykSdBFFWYbpU
	 Hnp63nxFSrLZ7nR3gQ+6lcvcT268by0co+ri4RwIjuUB3alE9uJTG2LjupinftqhGNNjF
	 aLfVl3MvVmg1DVJdZCAk5HxRAOHvTDVpPJFv7rG8hZWGo3pNenU2VwhCfkWn1yPdL1Bgz
	 pCmIM7bM7b/B5JF/isIqNCRc5TfNBfUI8NidcYvaNQp6aYedpPHvKW5Lj0TB8M8S0wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794733174;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bfgcvzbcu0GB8A+loCRLH2fTP7BpBf7AqSBWg6Ca8TU=;
	b=szKBoqEOVyLjp/eqHQ8OE7WMWh8SJcB91SsrWUGOgJbwCsfvrT4m2daIBQ6FkM88AizX
	 HQ+F3uzUO7Mt9U4fFPVdAq55IXz809F8wj3Nwv8aX9m3HjsgS6NyRuQB1iWFkN5bRUMDq
	 vNETGI/NWXYp+6vfWcnO6r+nwer9oRv3kXVIPkONj4TxFQXmCL0B09SjHgUFLEuPf7B04
	 L1gx4EGOgj6CWXcHx4JPvw8D/x+b9U666bOjdctUVkR74n23czT/xBoBdMHmv7nV/1j9P
	 kxcSs8FFgnlnhbrd9tUgYz8O4HyRjGoE7shZeEMfJr5mMFBYlZ7TIkQ0/yVWw6HOuTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NsnscGB0;
	arc=none smtp.remote-ip=209.85.216.54
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FDC8606A331
	for <target-devel@vger.kernel.org>; Sun, 15 Nov 2026 08:59:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0FDC8606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NsnscGB0
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3adac5c10e3so1354292a91.0
        for <target-devel@vger.kernel.org>; Sun, 15 Nov 2026 00:59:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794733173; x=1795337973; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bfgcvzbcu0GB8A+loCRLH2fTP7BpBf7AqSBWg6Ca8TU=;
        b=NsnscGB06RsAuOm/sNj/84bZQPVJ+3VLasXoa6KyppDCjtdGh0rkP6IPnYq2I4SA9q
         tfniGtsIdp3YG8bYDOB8mTeD1bK13SSuxNaOvpqRJRvMHlOAqYDlp32PLFIe8dM8pyz9
         ONMZ5myb4J//ehiFcMmQDo0yd70sKKStGS4dPm8ltsuICobX1CuVPpbiVsxsPtHVmIt2
         RAaly/cOwcEor9glU+cuZWi9dcWykqlpViMQbFzLXM9IzCaSGmy5idx5rM6vjUTUmhbu
         UwAIoemHRR4Fy9IcZsEWCEdgo75ohHZacPYiWXG1IuRrTAIFkZGsVCW6c27yTrJ3tnvT
         K9Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794733173; x=1795337973;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bfgcvzbcu0GB8A+loCRLH2fTP7BpBf7AqSBWg6Ca8TU=;
        b=up/Lh8m39HSZhGUuuR92fq9BVfCfXx8tBI36WTIVj3m6V7hQkeln8paSZi1u1euZD5
         XBoTr/RHrp2WYJEpoN71nbTvJIB+7BN9Pceiz5jUve65kKJcfIhZCKjN9hvI0Fl198Ym
         0kfdF6KrgkkeMEt2p6UQR42+GbTPB8f0pQM9WUwEfKmDlbyR22JKyFumo9VwoMcpfgzR
         StJyNvQKvXz9WICXsxxcUGUkQR3UPaBhhmO50tW3cZSzPAbBiVAxJ2svQckw42rQOhXw
         CsWFT4IN6/qeccs26yfqF0VEse56kMHoltUA9u7amcItdWdUFJoRuSqHNzm4dItyWL2g
         oMSA==
X-Forwarded-Encrypted: i=1; AL+hErET03/Wtz46TfLKaJXDXemzBbmKX3nFmMB5YNxfir0eES3KRAy+ppmCKKKPOauFvkU5GoRgvUoKJum9dLk=@vger.kernel.org
X-Gm-Message-State: APuU4Z8LtiiyHx6ZyOl9+eL7Mp5cyuOK602E8hAYyiz6u7wcLLqBgNKs
	KBlFMdZWssBiV6/tXO0jShPtsVhKKf3ENlyUdxT4TWf81WqUTwynB5FE
X-Gm-Gg: AYBFou3SOlsVVV1bQXmhOzZd/oTG12KsrO3yosTTvPjOJI7RdpHn+QBv1sdEJTkoxZ+
	8sT33eoRq67TwRHNRl5tWJFrITHondP6b1gFEGzn1PWP/YDE+6MvCHUDKyL922Sq7LZEHeQ2lX5
	Qqe9wmVdAFKkndpnIkHMrIP7zxkgjzYkRRE/sdOt6lNHb78Ddv4fyBuuiwIG/uy+IsQtqDevX0Y
	IC22glSzsWJi4bEtz3wnMEWnf6cUIxW8D+R1mknL8yBAiSCUORwNKps/b58LKvp6+SZUDN9d4Z3
	JPtKKK+w8s56UI3HVu3uL8E+KBW1A4b37IDqWc2y+vDsbnLx5G8cYKKyUMhNl1RchgQVVFH43l2
	V2tXEW+xtLS6CqzP/NHg2wYEjX3NbcVGyGVGik6jkl3M/zhuwsH/Mz1/hDlGMgvhQU2qix94MZv
	U/z4mTmwN+KbIaIf3AY9gd6xSHFJNQL2QORwSAzKoh17eJXm7b6BAe6jtqjUPdPeQkI6DGXiEah
	rJBRavanTIO6eXauew0ALVd2vJAhyMOf+mmIbGY8QzoRIdl/IEOZvatMP4kuiSLyfjzpIjm6E9e
	S04GB+po6mylL4nvJ6egqij3TCX7x9g9S2LWaleD3Kw056xxJR1nlouFBiEt/njOKA/xItmv/vb
	bV1iObsnu9FKwcsfc63TmlLie/22WxoVf7gf1BHvUBbiuXPixyJy/rzUeADw2J8CT3rKrmFRIOj
	zfADgBpqux+iQJqiUGfQaqLdPk5OVmh5UqkD0EYRwVtK527CUxufeAWa7rAjzYFWdqcxERgiCZ9
	p9FqYQQ6scM1fPfzC3IxO+uW1VgfG9tNw+1nwRixLXde9CrAvgFolKFaIOkSu4T7aORpQJYfWL3
	vL++dzBW1Q==
X-Received: by 2002:a17:90b:4e8f:b0:3ac:7749:2f0 with SMTP id 98e67ed59e1d1-3b1b0b52e04mr7258091a91.44.1794733173431;
        Sun, 15 Nov 2026 00:59:33 -0800 (PST)
Received: from localhost.localdomain (123-243-92-89.static.tpgi.com.au. [123.243.92.89])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b197c6c9c5sm16770310a91.1.2026.11.15.00.59.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 00:59:33 -0800 (PST)
From: Daniel Wade <danjwade95@gmail.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: Maurizio Lombardi <mlombard@redhat.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Sujal Tuladhar <sujaltuladhar1231@gmail.com>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] scsi: target: iscsi: don't re-arm Time2Retain on a closing session
Date: Sun, 15 Nov 2026 19:27:46 +1030
Message-Id: <e43c5b85225ade84c13948ebc6eafb9c583115d5.1794732723.git.danjwade95@gmail.com>
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

iscsi_target_login_sess_out() re-arms the Time2Retain timer of the
session whose login just failed.  In the window closed by the previous
patch that session may already be on its way out: iscsit_close_session()
stops that timer, then sleeps in iscsit_check_session_usage_count() on
the reference this path is about to drop, and frees the session as soon
as it is dropped.  A re-arm therefore lands between the stop and the
free, and leaves an armed timer on freed memory.

->session_close is set before the free is committed to, so test it here
too and skip the re-arm.

Fixes: e48354ce078c ("iscsi-target: Add iSCSI fabric support for target v4.1")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Wade <danjwade95@gmail.com>
---
 drivers/target/iscsi/iscsi_target_login.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index de0cd95aff0..1f41e5274f2 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -1168,7 +1168,13 @@ void iscsi_target_login_sess_out(struct iscsit_conn *conn,
 	 */
 	if (!zero_tsih && conn->sess) {
 		spin_lock_bh(&conn->sess->conn_lock);
-		if (conn->sess->session_state == TARG_SESS_STATE_FAILED) {
+		/*
+		 * iscsit_close_session() stopped this timer before sleeping on
+		 * the usage count this path drops, so re-arming it would leave
+		 * the timer armed on freed memory.
+		 */
+		if (conn->sess->session_state == TARG_SESS_STATE_FAILED &&
+		    !atomic_read(&conn->sess->session_close)) {
 			struct se_portal_group *se_tpg =
 					&conn->tpg->tpg_se_tpg;
 
-- 
2.39.0.windows.2

