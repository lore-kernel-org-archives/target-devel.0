Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794665575;
	b=m/DUKNWzIsb+rRATP28eCiZ4latjBvgJeqGGtGvxDXVlhjEa/rJd3E9Zt4drhImbD6vc
	 QTImD6nSz1IvT8NWtJSryirOTrCqUYaxDK4VP9vJ/XFTBubM7rRAVO7M9uEJ4DU3NTAmf
	 pxPYfJU07XzAnh4/E5ZwRlWQXyE2hNgSiGCvg7Guen7UgZbnVYe7d1hVg/cnjbkQ3fxxo
	 7njL0KbzocG2GHtMuzKQL1ROAB1tc7bBmv5aE5R6Wgx07EgmFhi/P6sOnK+XjPzbhXqhv
	 sTVVHnCqmo3rRDdbj2sSXgsHPdSy6BiI4iJjjXUJG+ZDkJ+NjN2Cpnhra2NBHyzQ2/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794665575;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=encOT2lGGk5rdoymU88Q4AHYj754IywsJbZgBdkPycA=;
	b=JPjWyDzuL247H6o2Eb7qi36G5M65SxzOI1OBqvI/FAme5WXQ6FG2SvR62o5pocIJ5WXQ
	 N83X6uC9RZocE+i54RYOepj8lekcBi0po+UuToCLkzp4804jtKNa3x/lT4SgpGzWjUHfy
	 RCTKJAGkBicSNdwLqSZLJexS157nnjE0wAPv8leqikiLH6K968i/IeWNn6g5rmjK6Dms9
	 09hSPxUhMhGM1xeEz12ZT0F5nHiGSMhgz91X+XaCqV6f2CMdY/27ikFqiloXUrWZvafiz
	 2VRxnqQ3DKrKqsVdu8UsVNVW1d/vdjnbkFZ5oQmr0hvvG/dLdYScFVZoZwTB1hiOhfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=LyVn7sUN;
	arc=none smtp.remote-ip=74.125.82.44
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA99606A32E
	for <target-devel@vger.kernel.org>; Sat, 14 Nov 2026 14:12:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7AA99606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=LyVn7sUN
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-1b3beeaf6f9so2152650c88.0
        for <target-devel@vger.kernel.org>; Sat, 14 Nov 2026 06:12:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1794665573; x=1795270373; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=encOT2lGGk5rdoymU88Q4AHYj754IywsJbZgBdkPycA=;
        b=LyVn7sUN/NQl7EPDDaa27u7ibbS3NAnWa2SKmdd7T0iZ/OMIXxZ5Ebqoiq2VY4XfLQ
         ZB0zs/tGvA8rx9yOW1EmQYNEALEeBmQ3n78q+gdrkoW1yvwu/4JmYzV1xSHTVh6rhBin
         Z0YA8p+3GPkYATC6XCZO5Dr+S71A+zwg0nMPhX9vO3nFwS7TA98cmOIVIugY4HMSQCOF
         xo7yCWbqj6ir3PZX/ZGetaQQF6hMLyS5C1NzYgPGGlygKRNibDV96zvP8xceiC40vvWV
         c2jnYuz3igdXnG8TuipVbbWmd0aIIWKOKstlqkEo5uGa5fRs7L8kGnQHWZ21hvRCSO1i
         Kt/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794665573; x=1795270373;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=encOT2lGGk5rdoymU88Q4AHYj754IywsJbZgBdkPycA=;
        b=qo3HUAG0fUcVvK5ykHYWnYH6E14dhVRM5UKOWNObY9XNwQtPGWgoxiwjIQovP+iXKY
         d2iVlTQCw2ijTRx7C+rTEX5GUhNI5CI2wDROkkCxnUPARe+uAt7fQmk3Zdd/w0wlB62g
         PPHRDap7Y33rVdANO2gMei9H9QK6gR7A2Oy5xovI/U9HqnHO6ESp+hOJiHmmwLCajGxg
         9//qUEc/2QUtJkrCFVKR2zil5Hm1k4nF9mr2D446lIvQ0XxYvtqg4uV92pIc0aaSItpP
         ro3raA/nimee3JMoLqrz8CA8jegwcJd0mmtrtWRGdJBkYKKx95ega9uFAvq1o68hNWQD
         c16A==
X-Forwarded-Encrypted: i=1; AL+hErG7+3zZ3oSrxydV42ugb/3NQnZOlYBKTUap1mD91DmBbaiJIjwrLP2k6rLqWmwWuQWaGNxaaGaUNO/l4Yk=@vger.kernel.org
X-Gm-Message-State: APuU4Z9cIGj1GkVeweVXrLfcYP3Nm14oGsuZ2qz0VkNZ7el0z5uLd32m
	DWFGyukBa+rdsN73zVP0cpkait5HDDf+gU6PzhktlP5DUyXBQjviQc7TALSFU8MHDqcRjLtQT/m
	n82zQCwM=
X-Gm-Gg: AYBFou0jsiVse6sASRZ6KV1bJrh8VJi/B/TLUbhenWBkeQLs14BvHbkn1pR4SqI0WUN
	ZycEg0rwEZfLJKuzr5Yva3aZNBaX9zu/rMpySafyYeWiHtXSFUpqRjJlUEWiNRuOTDyGdyFJvV1
	xzuO8LLvRBrS/hhR3Z+3dBXVxolzT40THujEMc4lWQ/iCc6fT3a1FfbaQdIRCLDFswRht1BTfRK
	Yg0bFCvrM8O3f/7ncSl31oZ72rlsJR+nEZkz4RcOeJwKfT2oWBBcETa6DiqcLiL+PSRp72bH0CE
	tSesg0pQljGxq5iSDiaKNUB3l1J/JjvuScfAKeBrTWp9zsoLJYJ6PlPsJoK1pLzHXeGe/R1XpCQ
	M9eQKuyCeh97Xpn06sL1KEVku4UOeinIPpnHZl0iOf48KzkrrRgUCkFyU42xkEt+oWFf3waoRGP
	Q0hFQtsHFJLr8z41WtnflB6EiVh6wh6jzhRmX8ygn9rv3UWvDWxsmhmu+rtA9VXjEJHUdCIAqKc
	EN1fWkeO5AKdFNWgon37kUAZ/WX2e0Z74lKvW8IbkYsKFGqGn9h9XrMQ6kTVRD9AMUJZdJYA2SQ
	9H3gpmdOJHYoMrLMwnYmyXYWu/CtDnzkQT4J2Rdb2EKxtlyjaWoCVi9N6JhtmYTE8j9v8b/9pti
	B2vDHBL2Bh7KULUkmQi8RpdEJyzWB+caquMempw==
X-Received: by 2002:a05:701b:271c:b0:1b2:43b0:4794 with SMTP id a92af1059eb24-1b5030d4941mr4325877c88.9.1794665573011;
        Sat, 14 Nov 2026 06:12:53 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:bfe1:56d2:91a4:93d9])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031918c7sm23185178c88.9.2026.11.14.06.12.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 06:12:52 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>
Cc: Mike Christie <michael.christie@oracle.com>,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: target: iscsi: match the login keys exactly in iscsi_target_locate_portal()
Date: Sat, 14 Nov 2026 23:12:40 +0900
Message-ID: <20261114141240.820264-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
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

iscsi_target_locate_portal() scans the first Login Request for
InitiatorName, SessionType and TargetName, and the values it picks decide
which portal group the connection is attached to and which node ACL
authorises it.  It picks them differently from the parameter list that the
rest of the login uses:

  - the key is matched with strncmp() over the key's own length, so
    "SessionTypeX" is taken for "SessionType", while
    iscsi_find_param_from_key() matches with strcmp() and answers
    "SessionTypeX" with NotUnderstood;

  - the loop assigns on every match, so a repeated key leaves the last
    occurrence, while iscsi_check_key() rejects the second occurrence and
    leaves the first value in the parameter list.

Either difference lets an initiator make the two disagree about
SessionType.  iscsi_target_locate_portal() takes the discovery path, which
attaches the connection to iscsit_global->discovery_tpg and jumps to
alloc_tags, so core_tpg_check_initiator_node_acl() never runs and
sess->se_sess->se_node_acl stays NULL, while iscsi_post_login_handler()
applies the parameter list on top of that decision:

	iscsi_set_session_parameters(sess->sess_ops, conn->param_list, 1);
	iscsi_release_param_list(conn->param_list);
	conn->param_list = NULL;

	iscsit_determine_maxcmdsn(sess);

SessionType therefore goes back to 0, and iscsit_determine_maxcmdsn() stops
treating the session as a discovery session and dereferences the NULL node
ACL:

	if (sess->sess_ops->SessionType)
		return;

	se_nacl = sess->se_sess->se_node_acl;
	sess->cmdsn_window = se_nacl->queue_depth;

A first Login Request carrying

	InitiatorName=iqn.2003-01.org.example:init
	TargetName=iqn.2003-01.org.example:tgt
	SessionType=Normal
	[operational keys]
	SessionTypeX=Discovery

or the same login with SessionType declared twice, as Normal and then
Discovery, faults on a QEMU guest:

  Unable to locate key "SessionTypeX".
  Oops: general protection fault, probably for non-canonical address 0xdffffc000000001c: 0000 [#1] SMP KASAN NOPTI
  KASAN: null-ptr-deref in range [0x00000000000000e0-0x00000000000000e7]
  CPU: 2 UID: 0 PID: 128 Comm: iscsi_np Not tainted 7.4.0-rc2-00563-g97d73c825122 #1 PREEMPT(lazy)
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
  RIP: 0010:iscsit_determine_maxcmdsn+0xd4/0x170
  Code: 48 c1 ea 03 80 3c 02 00 0f 85 a2 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b 6d 10 48 8d bd e4 00 00 00 48 89 fa 48 c1 ea 03 <0f> b6 14 02 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 04 84 d2 75 7b 48
  RSP: 0018:ffffc9000087fcd8 EFLAGS: 00010203
  RAX: dffffc0000000000 RBX: ffff88800eb20000 RCX: 0000000000000000
  RDX: 000000000000001c RSI: 0000000000000000 RDI: 00000000000000e4
  RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
  R10: 0000000000000001 R11: 0000000000008000 R12: ffff88800eb20468
  R13: ffff88800e9fdd88 R14: ffff88800ebd4000 R15: ffff88800eb20000
  FS:  0000000000000000(0000) GS:ffff8880e5a9d000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00000000005a1b6b CR3: 000000000588e004 CR4: 0000000000770ef0
  PKRU: 55555554
  Call Trace:
   <TASK>
   iscsi_post_login_handler+0x1ee/0xc90
   iscsi_target_login_thread+0x1e10/0x3290
   kthread+0x2ce/0x3b0
   ret_from_fork+0x52e/0x780
   ret_from_fork_asm+0x1a/0x30
   </TASK>
  Modules linked in:
  ---[ end trace 0000000000000000 ]---

The fault is taken by the portal's iscsi_np login thread, which does not
come back, so the target stops accepting logins on that portal until it is
restarted.  No credentials are needed: iscsit_load_discovery_tpg() clears
tpg_attrib.authentication on the discovery portal group, so the crafted
login is accepted on a target whose normal portal group requires CHAP and
which answers the same login with AUTH_FAILED when SessionType is declared
only once.  The global discovery_auth and enforce_discovery_auth
attributes do close that door, but they are 0 by default.

InitiatorName behaves the same way: with the name declared twice, the node
ACL that authorises the session is the one named last, while
sess->sess_ops->InitiatorName keeps the one named first.  On a target with
an ACL for each name and LUN 1 mapped in the first name's ACL only, such a
session is refused LUN 1 with NON_EXISTENT_LUN naming the second name, is
listed under the second name's ACL as having the first name, and reinstates
- drops - the first name's session with the same ISID.

Match the keys with strcmp() and keep the first occurrence of each, which
is what the parameter list ends up holding, and compare the SessionType
value with strcmp() as iscsi_check_string_or_list_value() does.

Fixes: e48354ce078c ("iscsi-target: Add iSCSI fabric support for target v4.1")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/target/iscsi/iscsi_target_nego.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index b03ed154ca34e9..619a843e3c849c 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -1151,11 +1151,15 @@ int iscsi_target_locate_portal(
 			goto out;
 		}
 
-		if (!strncmp(key, "InitiatorName", 13))
+		/*
+		 * Match keys exactly and keep the first occurrence, as
+		 * iscsi_decode_text_input() does for the parameter list.
+		 */
+		if (!i_buf && !strcmp(key, INITIATORNAME))
 			i_buf = value;
-		else if (!strncmp(key, "SessionType", 11))
+		else if (!s_buf && !strcmp(key, SESSIONTYPE))
 			s_buf = value;
-		else if (!strncmp(key, "TargetName", 10))
+		else if (!t_buf && !strcmp(key, TARGETNAME))
 			t_buf = value;
 
 		start += strlen(key) + strlen(value) + 2;
@@ -1193,7 +1197,7 @@ int iscsi_target_locate_portal(
 	/*
 	 * Use default portal group for discovery sessions.
 	 */
-	sessiontype = strncmp(s_buf, DISCOVERY, 9);
+	sessiontype = strcmp(s_buf, DISCOVERY);
 	if (!sessiontype) {
 		if (!login->leading_connection)
 			goto get_target;
-- 
2.43.0

