Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E833C07A
	for <target-devel@vger.kernel.org>; Mon, 12 Oct 2026 00:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791764230; cv=none; b=sF9gPHZimD43Uzrqe4n+tI8G448FZF4cdqqTcFQivOxjBU9HluPCzoWqabWrn4xwwv0WxisLCBGMx2xyTmIqh7Hbr5r4MOW5R257swZEsjAirOHwZM7dEQ5MigUypl7azxvs4L8OPd5UtnjiLeKp32HY3y+s6Qw7gJSPPq62h1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791764230; c=relaxed/simple;
	bh=WR9ZRx0OG8WB8FU8j6N84odGtF7ArWFkBQwxc0m1e9U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Oubg3hovIgoIxYKx7TGZHmGRFZjY4V72SP7GomnlLU4r0w7uaUXlQZjX4/9e9l/q5Vk47kcRYgEWNp2c/SeCUpUdXI21mxiJQ0PUhbpdJZISqDDxBR6l3iIKaHBgWfhB2IhOlEXL7ov3eUeHzZBFUUeRI7TDktvka+kwUA4mSOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=YolhH/3e; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="YolhH/3e"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-88b7d853b11so750976b3a.1
        for <target-devel@vger.kernel.org>; Sun, 11 Oct 2026 17:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791764226; x=1792369026; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=FPB775D8RC545nicueL5zti4cavLO/8DRXwfdsdk1Fk=;
        b=YolhH/3e9/G07Qni4iWC3PYrb4S416WW7z2+GSCpnMvx7USgO+w4qE3Zuh/vSV9SCk
         u5GiX9r97I83jntxX3r5EMDhI/uRpmYv+pCsOe53gznqaRQrw4ogprycbLt9s8O/3NqE
         u5TRXEvC3TWGHjX8DQilYDqWPuIhmnbicEaLUEaAHLH6F1il736YUs5hclRm2mPOEZd0
         5d5h40Jm4VCr9LiMFBp4j8sVtxr7boXlEGUxCXqMo8YOqHL1BABa/607tnKy1fwkmhTp
         A/YxR2iBWKkb9c0ywn/mY5JT/OooE5UyBY9YLZxdQEvJCIZ2THudQ1PgrcIEHjUIcWra
         QUww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791764226; x=1792369026;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FPB775D8RC545nicueL5zti4cavLO/8DRXwfdsdk1Fk=;
        b=j8ce4Z/0V8wAMIktXEgG7TY5Ai6TgK4IHQrNjvfPWvlH8LgGJQFSLtMZgVROZUpGFq
         HeS9URrGzSs5wvQit7GzPwgyighw4/NM2P3nMWfD8vLwvTLIUycZ4eY8psljk5qNVyMr
         VqI5s/dIHTBJYOGL2kosB11K6dohE9OJQCvVJjM8AGl8jilZ7uYepg+SxPA7v0yF0sBJ
         3oIG4KbXZ6EBySL01sKRUpVy3cI1F5oM3jxwjbj9ZkfUSuFh3olXsYx8Tm1ufXKXn0Qb
         ObU1JQ/uDqiBAfaldQGEbf/bfhayCcNYsgoorU4cIUHn0Ks7biMlJ1Z1iK05kMoGWI2E
         uNBw==
X-Forwarded-Encrypted: i=1; AKwUvBztOf7YxI9iCdMszaFRI/jBVAwdvR6W+5IOu1f2HPXLOR4ngR5e6AuTAD5DIPc89kxa4uVlP3ERivQV5F4=@vger.kernel.org
X-Gm-Message-State: AFq9FYL6K8Ok+YrdTA2mYHAWSZi2nZ/0MO57r7ue4CumTQZL3wKQVdbs
	NCXWrQX314ArGB/blJ42ozz5aEj6yoWpAQyHsNB/s7AkTGf4+VryHzlecZIynSrFE6E=
X-Gm-Gg: AYBFou0iunyvQlMwbRi1O842rDxbA5V50+EwD9GkgUa5MRgXRUhtawlW5teVQxjaeb4
	DIRZZXkH2I7mfcjgJJU+IY6lXngWVDwmP64a3huBChDW7Xngs6fNMjlVGf3ux8sfa4csLmHXO7X
	AY2ipsompP3+yKceEft7zeUqybYHPD97IJ2Xp30x9i8jZ0UMxpplfSkKeooT6F7hzEeygUJ+A28
	liW23HiPAAOe1B+vkOAI2+KV2JW2T42Y7tAayfiPz4iUb9dCvgxzMBpeeiCKN04USL1zaEOV5/5
	kp/D+bbsIu2wZif9xXMSfDoC2qLv76s3pUnEF09LHbaNCnBQ60UGRGpQZMbv/4FeSkneNledv5J
	VItcfuDIjMO+vOVfdZjZdbWfUFB90lYoNGcSvcfqtqOJ9DpzjJyheUPKff1CGXYMypDhu5bNTjM
	/Oyq8c2mSVs8xkNyr9E16MyiQdVO5D7F1f8jGIPkhkx0VAgLXy7ZKa3AEAzlZGEH4+GY075Umk0
	lI/5g==
X-Received: by 2002:a05:6a00:178f:b0:886:18b2:361c with SMTP id d2e1a72fcca58-897c3ef946cmr6502691b3a.7.1791764226441;
        Sun, 11 Oct 2026 17:17:06 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-896c49901fesm3378268b3a.57.2026.10.11.17.17.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2026 17:17:05 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mkp@kernel.org,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Cc: michael.christie@oracle.com,
	Roland Dreier <roland@kernel.org>,
	linux-kernel@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: target: iscsi: reinstate sessions only after authentication
Date: Mon, 12 Oct 2026 09:16:49 +0900
Message-ID: <20261012001649.2135743-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When an initiator starts login directly in the operational stage
(CSG=1), iscsi_target_handle_csg_one() calls
iscsi_target_check_for_existing_instances(), which performs session and
connection reinstatement, before the iscsi_conn_authenticated() gate
that follows it in the same function. The reinstatement matches purely
on values taken from the login PDU: a zero-TSIH login closes the
matching session with iscsit_stop_session(), and a non-zero-TSIH login
reinstates the named connection.

So on a target that enforces authentication, a party able to present a
target initiator's InitiatorName and ISID, both of which travel in clear
in the login PDU, can force that initiator's existing session down
without passing authentication: the teardown has already happened by the
time the gate rejects the login. The impact is on availability; the
failed login gains no access.

The CSG=0 path does not have this ordering. It reaches the same
reinstatement only from the authret == 1 case of
iscsi_target_do_authentication(), that is, after CHAP has succeeded, and
the source states that intent. __iscsi_target_login_thread() notes
before iscsi_login_zero_tsih_s1() that it waits "until after
authentication to check for session reinstatement", and before
iscsi_login_non_zero_tsih_s1() that it waits "until after authentication
to check for connection reinstatement"; the helper called from the
CSG=0 path is named iscsi_login_post_auth_non_zero_tsih().

Move the reinstatement check after the iscsi_conn_authenticated() gate
so CSG=1 follows the same order as CSG=0. Where authentication is not
required the gate is transparent and behaviour is unchanged, and
login->checked_for_existing keeps the relocated call from repeating work
already done on the CSG=0 path.

This was confirmed at runtime: on an affected kernel, an unauthenticated
login that selects CSG=1 and carries another initiator's InitiatorName
and ISID tears down that initiator's authenticated session; with this
change the login is rejected and the existing session is left intact.

Fixes: e48354ce078c ("iscsi-target: Add iSCSI fabric support for target v4.1")
Cc: <stable@vger.kernel.org>
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/target/iscsi/iscsi_target_nego.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index b03ed154ca34e..bddbe29da807d 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -982,9 +982,6 @@ static int iscsi_target_handle_csg_one(struct iscsit_conn *conn, struct iscsi_lo
 		if (iscsi_target_check_first_request(conn, login) < 0)
 			return -1;
 
-	if (iscsi_target_check_for_existing_instances(conn, login) < 0)
-		return -1;
-
 	ret = iscsi_encode_text_output(
 			PHASE_OPERATIONAL|PHASE_DECLARATIVE,
 			SENDER_TARGET,
@@ -1008,6 +1005,13 @@ static int iscsi_target_handle_csg_one(struct iscsit_conn *conn, struct iscsi_lo
 		return -1;
 	}
 
+	/*
+	 * Reinstatement tears down a previous login, so run it only after
+	 * authentication, as the CSG=0 path does.
+	 */
+	if (iscsi_target_check_for_existing_instances(conn, login) < 0)
+		return -1;
+
 	if (!iscsi_check_negotiated_keys(conn->param_list))
 		if ((login_req->flags & ISCSI_FLAG_LOGIN_NEXT_STAGE3) &&
 		    (login_req->flags & ISCSI_FLAG_LOGIN_TRANSIT))
-- 
2.43.0

