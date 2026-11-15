Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794739241;
	b=MCL6a+CJ+sBCrjP6eIBRVLVsixopb9Yx8EiBmPlrPte9FfTKswO0cpBQMUyrxMwCHWuQ
	 TbP44rR49WFzPiKHV0N553kOhmCiehwdVaOSGx4DhY5MDvogk7wwyw0r4bJIVnBZFWugG
	 mNN0ZOCCKXYnYnLm2IjHWCEIvrpFNHTZ4iqjMsQppZC2LxCycVuWAeZEDPOTuy66lE6VG
	 MQSKZrhcDK13Pcqk+4jPxodE6kBeAMYvya0ze0Jj8dhOoiR4qA5/eDdsBepQjlHU8PEiT
	 zIPMYXNlu0zZcxtIePi/16ezx24aX05+q7J5ryBiIJwd3gjL7j8PgAqu0LuisLsYopg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794739241;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TENXDxvv5jFBPerWep/Z3nZ9UwBvzf2srmB2t0s0Ufk=;
	b=ccKH/nmjAOK0/3GfT6zT0okuKN25py1d2RG7aP8FFcH270+/Q7De9fdBSa102kq74NrV
	 jOoCy1QDxurdmgAeRUeRqFywq+SF9LrmHiW6/33INNJDW29yjPV2lSE72gyFUFbKzuHfY
	 OyzB86eSH0MwQqeEEDkP5hqbieea14ABievW2rpj+hrIJPvmtgKqUuZ0oAJvurr9gCaLP
	 /KrG3S0umnsbgzKSueyVfIDPvMcqSSw0ocDvWkgpz2Zwu3PQzUi0Z07Gy2Gp51ftfDfZO
	 waxsaW4RoLwgtYAtb8+Gyflfyxjpbabzsqs5Bpe/HnETtfTCM8TFrYr1Xey58/YY19g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gEiVyM34;
	arc=none smtp.remote-ip=209.85.214.175
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98CB6606A89C
	for <target-devel@vger.kernel.org>; Sun, 15 Nov 2026 10:40:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 98CB6606A89C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gEiVyM34
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2ed11653a91so15839585ad.2
        for <target-devel@vger.kernel.org>; Sun, 15 Nov 2026 02:40:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794739240; x=1795344040; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TENXDxvv5jFBPerWep/Z3nZ9UwBvzf2srmB2t0s0Ufk=;
        b=gEiVyM34NDSCp2pkPQHpI928xWtg0jAwkU/EloJQ/g0yaZba/6kxQadtViGi3+wEah
         XOrg+w2+flKHeBdmIll0ru5ewMNgL4UoLb0RnByBBV7Y446WgYVAdR3Pij0H0+1Xcm6X
         IC+nF9rftvRryg2AavPmqTPIbi8FlSXGWXsGTnC20i//w23MXZI6AevHv4382SPCJsty
         8iww6oTppF0lhO9rBUdEwsxbwRyTR7dUPk21OQLfsTfER8oT5xaSmHn1hdxTqsIVx6NF
         yEBraZpvbudueMgbvLmMMBYU7VhjebE58m50l/7Y/BybISts+0BzEQF6TqXd1SRmwh7U
         5Qmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794739240; x=1795344040;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TENXDxvv5jFBPerWep/Z3nZ9UwBvzf2srmB2t0s0Ufk=;
        b=t3USE8pTJSc2vHNVmswXF3NOTL61sjChH9DrU6aCcCGdWC1Zm3dCT2yCGH9KkcEXdN
         HGUMGBmFz2RElEvbjNfR0rGURvt2I65kMD9zPJbtWKy7AvlSG7FAS1yQII1WHdF4ydXS
         qJ3DBvA1nYzd3SVAVm00o9xR6RfEcnz00RpTsH6x40dcRO7qMtnUIlqFhBTFRXeDyQ+6
         xbFYUhTPnHooeJ3qDYCXEYg1wDkA5qPyhK0Odo9YTj+PxoAx5Uig1ip0rhnkvVYwazSE
         3ACg1dPCuOGYpe3bHfIR9WoKEsSBV86bsSBGim3AoLVO9nd6+CQVR3k3l4iqduu2Pg/L
         b+9A==
X-Forwarded-Encrypted: i=1; AL+hErFcljsODDSzTJ45bcX/88iFLxAxRbbE2Xeg004q4zZGTClgmldjGlcnVXpxDC2ZYUhrnNRH2zK2OPjy2/4=@vger.kernel.org
X-Gm-Message-State: APuU4Z/AA5AhWixo54wxp4uobJG7jmbBybaeLcFF1eGmATU+3l1Dch66
	WplQG9R9cJZl3MvDYgWMarU5LC/py+9WmZdWVTeSMQuzy0HIyI8uytidGa1YB3CmDvyNWITu
X-Gm-Gg: AYBFou1OjozlP9hpkskbCGxIBhnauzy6PmN2cjeqH7eKHXb/PqLevO6CpZoRqdCbKan
	k+yD1WZoC6o1WUOkL0G+IRL54snJ2azNw5DUf9Nvc6Pz0DnbLyV6RB9yMK5z1f2QhSPODA5A3My
	JdKzelhcFHRec2O5gWqQLlU7TDSvtkCYG+OtIFxDf1G3gH/zUprfOXe9lsLrpuznaHyccLUSF72
	kKbPrJFEW9IzLf9ie9xfsq+RUwqFZGjuNclMAcoqseZqvEzBLydyY8LuoGLTrotZ5s+fW6lDYbj
	KT3VcHgr+TpQld+SuKaDjxvCZhDjA5Wd2iP4xCYH0Bc8JxbHi5uyHN0gPooz0Ub0ccKVdfxfkwI
	TopBy6KJt8SSp+jh5aBKj6tg2pPNnzrJgJ7M3keTTn+By5/snrC7MOB2T7yKrfMnPpV9dlqgEMv
	4WTsKChw6p6a8uO7/i3/+nw1SQZVlV4kXnp6zmkFRrRdXBlE8Cyl1lz/i7liQUFV5s3nVYhRbA7
	Dmfu57lU7a/IclngV+dIZicjg+dwYcLbLCk3wfK9gc2wCHlYgsA3XzoXq3Bnzgl0fvEnboVz7Qw
	HTlrZX4IZjNdhH10VwqJxSfk9T0vJUHOCWgovTxkFDu+0FaNYhMQcRhEy4ugqJC5L0YG5x/pkcP
	r799139p8m5B3ilxaPHwQ7oF40Esvz6IMZYsPIN+zeDYrbb/V1fcCvWHl1XI1HfKKuLBvgAYSyw
	vkdlrRvpBzVMLuzlJqXanMh1qVoY2gAOj7yfHVNinNNDLkdFyez6ycBLejwhL2RQZ4OpQPWuiyN
	QbJsCExBhgEiaJMPp/jvYzculL9aveVKiPBLL+inqIduZ6qP41VPf2AZ8TBY1YB
X-Received: by 2002:a17:902:e88d:b0:2ed:acb:aa96 with SMTP id d9443c01a7336-2ee0dad0247mr91339425ad.24.1794739239813;
        Sun, 15 Nov 2026 02:40:39 -0800 (PST)
Received: from localhost.localdomain (123-243-92-89.static.tpgi.com.au. [123.243.92.89])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ee0f8d4612sm26739145ad.57.2026.11.15.02.40.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 02:40:39 -0800 (PST)
From: Daniel Wade <danjwade95@gmail.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: Maurizio Lombardi <mlombard@redhat.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Sujal Tuladhar <sujaltuladhar1231@gmail.com>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] scsi: target: iscsi: don't re-arm Time2Retain on a closing session
Date: Sun, 15 Nov 2026 21:10:07 +1030
Message-Id: <6396b9a2d459b956e4081fa080e194d2df0b2a6a.1794739041.git.danjwade95@gmail.com>
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

iscsi_target_login_sess_out() re-arms the Time2Retain timer of the
session whose login just failed.  In the window closed by the previous
patch that session may already be on its way out: iscsit_close_session()
stops that timer, then sleeps in iscsit_check_session_usage_count() on
the reference this path is about to drop, and frees the session as soon
as it is dropped.  A re-arm therefore lands between the stop and the
free, and leaves an armed timer on freed memory.

->session_close is set before the free is committed to, so test it here
too and skip the re-arm.

Unlike the previous patch this does not need the other teardown flags.
Every iscsit_close_session() that reaches the free is the can_sleep=true
call from iscsit_close_connection() and has ->session_close set, while
iscsit_handle_time2retain_timeout() passes false and re-arms the timer
instead of freeing when a usage count is held.

Fixes: e48354ce078c ("iscsi-target: Add iSCSI fabric support for target v4.1")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Wade <danjwade95@gmail.com>
---
 drivers/target/iscsi/iscsi_target_login.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 556ae5d2d50..124c9903fac 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -1177,7 +1177,13 @@ void iscsi_target_login_sess_out(struct iscsit_conn *conn,
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

