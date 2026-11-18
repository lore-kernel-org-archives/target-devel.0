Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795001955;
	b=bYKrq282i4REGNHELOreQeUGblhkWSReO4lbEQdfgNzMBRujA9fKAGyN6Lu0ZHwQUBgM
	 YymRsRcmOjslvO1jZvcgoSwDUPzY+h6pL041Q88eDTo6m9cBipPm2qIw/tbtVuVImpXFK
	 Cai0q06aJ8bZkLNdCQMn04G6LjwGbh4PPSR0lJMz49IDaQmwUyIwZWKKN1T3zlZUsqUzd
	 Zj2yFvpbdCXL9Ejetu81KDR40ZuRNNYyMh2L2RV31V3sbjxQT4KEwkSf6uK8ZSQHPJNAr
	 GYtrr/VDWYseeQmbBxMOpzW2DIlJme5yj3vkkke2+pi+JZjz3qqVPANi4JGziDTHaaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795001955;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=OxBkyF7pGKdIKZlrOpVOC8DvLEp6sr2IjmnXmomfKgw=;
	b=Dfys+AeadxMe1btKM+JOzu9cPgaAvuOYMeKWu65+z8aMK0+vz2KoLRgOedxab8G37FYp
	 upicSoXGWz/YJu8LSINfANqB8CuoXm8uqHqhS0SS0wXnpveRVkJAIwRlO7d5cMTBxsMKl
	 wLFH3IU9sV+22pkuFEeBcGArB7AfZce1JDmgjpCQ+YLOzpv+a4FlwgIXMPyOLAXOHBG4e
	 MZ2TQRvEUJipfYrGee5wVSPnXKHncmpEOtDBX1vWHm4UOg/ZeK5Jn+dSIYDplaiGhDswZ
	 JBUL4OLUuPlX9DafXpc09OZHwZXHstJyk7aZlGa8P22ze80mJ3+oqMtMUXGC643kSXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=cALrBnc9;
	arc=none smtp.remote-ip=74.125.82.51
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 063AF606A32A
	for <target-devel@vger.kernel.org>; Wed, 18 Nov 2026 11:39:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 063AF606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=cALrBnc9
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-1a2af4c8d00so1758351c88.0
        for <target-devel@vger.kernel.org>; Wed, 18 Nov 2026 03:39:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795001954; x=1795606754; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=OxBkyF7pGKdIKZlrOpVOC8DvLEp6sr2IjmnXmomfKgw=;
        b=cALrBnc9oRbjaYNx6fvha7dZCbpNiP7EOzDqyWIp9VYzaQWZ9Gt/30ndIbBG8wDp3S
         bRu1KW7NSjgDHAgt/q1SnISlYxjlqgab4KYYDIlQyLPFru+10N/RY5vATQeqhf7UHzgX
         y0AkNEtMkOcnhGuns2ng+/AlTmPD3SJFWHO3H5QA4NtTk2TYUhExTV25NWF2QqfJCKZ/
         G0kqQoCZ+zB70/HAWaE61oEJ2tErjVdP0D69cpRFssQrLlqq8oKto+y7mvc8cP3uGvni
         yVaFpUV9500H7RxoxI+dbXEBqMQaBscryy2iCBNfMfE2Tepu/ad8sAv/84cFk+OWZMdu
         sH0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795001954; x=1795606754;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OxBkyF7pGKdIKZlrOpVOC8DvLEp6sr2IjmnXmomfKgw=;
        b=11ejC4HSpdTXurnyRacdg8oiw8eAdXDNc1RhKCBh+MJdqx5I1lcmTmyxmXwf1UYd9E
         C/IHwq0ltmJlrGXr1ZHLCoT+o12AUYjc0JlXFcW/C15blCFn5lOmCNnULE71JKtDteW9
         KdSFUwXhsrYBSuEseaWAE0ZW/43J2143EQH2lbmpivlpxFourPTFYdabaoFm4nW/C5y3
         5wuvLvZbZN+fPGC7L1NAeg//Gab/dUNf6Q+PyTGy6uvoj8n7pnvdqOHvP17I9aER8b38
         +BgrFKmYKNKR0I92zbTwmNlZi1YJ13k7/P9EU1gD5qGX8cJiJdqQM2dyaR4E8Wcyg3nf
         GtNw==
X-Forwarded-Encrypted: i=1; AL+hErEaI7xJfQhl3jnH4PVlDpf0BuH+V2TRKd/GhX219LJdYxg+O0pH+5IRHuXV+1tdnkbwN23U9s90B35q9tQ=@vger.kernel.org
X-Gm-Message-State: APuU4Z8twSDA4FMYrzn7Kg1YTMxvElDhzwMz5e990LuCGeoHefuuQK45
	fHQ4bECxBwTw55ruC9irG/aHrIbx1f9YPoQcaGHup8d7qVIgdVkAl5+VMFusvG3v204=
X-Gm-Gg: AYBFou1+dw879zLKbxBNYKfPX/8Dw/xRpTE/7eI70S6Ezam5dKxB1tLN45qm+MjMZwL
	YKmG5YCq4PGNbA5DuPetylQOJfjaRez/GZ6IM2Vgk0BVYmlLgm4S+UA83cdYwHWvbS/U32CG0pv
	G+7KbW+jNvC8g5S0L0O8Aq4K3wAuUgASKeQ5jRKlRkI9v9pdP/PBrKO6PzUtL4ECxy0+Lg096AG
	s5/JkAcuMebxni4++Z/dvJoN+z2XMhO5+a4u9HmU4bACNdsYo7Z4PqWxVglJnJfRrcj1VttImKW
	5G9ySZX3g4vQGpdcRVIcEe6N046oBcqBD/bW0D6rce1gQO16/hbkxR2Cm/znmSqQWJWYgzCV8kn
	+XF925Iew4LzAedwa2BhnP3BXYIlNcEA37enUB2Jg1vkl66kxzpLQpFTgj/3Nkkdnmxl6cDfKcr
	B/p4FOU1A/0N24rZtoRqLj+4HIYwsxNAEdOygT6KJghqv3YD9WydetUBxmUMqTWZq0HI2KnjXGn
	d14eJkR2q00cOWfVQZJ9DP++/mJTb7q1ep/3lXJy1JfriOB4MTmcLwCS394mM+Z47BOmWKHyD9U
	de11o9LcQCvGfjKU1uzK4z4QvlGuIpyDkveoLGFlbHo/ntGNj7OVYv3EdJJ1g6EiQxZzsk5beX8
	1QUgDFR6X4PUyYiGmSpGJbkT0hm7XAYpZ6M2BGA==
X-Received: by 2002:a05:7022:f101:b0:17b:fed6:7449 with SMTP id a92af1059eb24-1b543d416ffmr1832099c88.47.1795001953609;
        Wed, 18 Nov 2026 03:39:13 -0800 (PST)
Received: from localhost.localdomain ([2406:5900:1044:110c:e78e:f7f0:2120:34e7])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5446f954dsm6044662c88.2.2026.11.18.03.39.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 03:39:13 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sagi@grimberg.me,
	jgg@ziepe.ca,
	leon@kernel.org,
	mkp@kernel.org
Cc: linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] isert: the commands the target core allocates itself
Date: Wed, 18 Nov 2026 20:39:01 +0900
Message-ID: <20261118113905.2361969-1-yhlee@isslab.korea.ac.kr>
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

v1 was two isert patches with no cover letter:
https://lore.kernel.org/all/20261116101108.1650132-1-yhlee@isslab.korea.ac.kr/

Answering the review of v1 1/2 needs two patches in the target core, so v2
has four.  1/4 and 2/4 are drivers/target/iscsi and 3/4 and 4/4 are
drivers/infiniband/ulp/isert, but 3/4 depends on 1/4: it lets a Reject the
core allocated reach the wire, and without 1/4 first that turns a NULL
dereference into a double free.  No intermediate commit has a double free
or a use-after-free; the NULL dereference is in the base tree, and 3/4
removes it.

1/4 is not about iSER.  iscsit_find_cmd_from_ttt() matches a command by
targ_xfer_tag alone, so a NOP-Out with a reserved ITT and TTT 0 is given
the Reject the core allocated, which carries TTT 0 and is still waiting to
be sent, and two such NOP-Outs free it twice.  That is reachable on plain
iscsi_tcp one PDU after login.  It also gives the lookup's other caller,
iscsit_handle_data_ack(), the kind of command it actually wants.

2/4 keeps the unsolicited NOP-In off iSER.  The transport check in
iscsi_post_login_start_timers() runs once, at login, and
iscsit_process_nop_out() and iscsit_na_nopin_timeout() arm the nopin timer
again on a connection that is already logged in, so it moves into
__iscsit_start_nopin_timer(), which all three go through.  Gating it is the
fix rather than only the dereference because isert releases a command on
its Send completion, so the answer to a NOP-In cannot be matched to it.

3/4 is v1's 1/2 with the fix generalised.  struct isert_cmd is all zero for
a command the core allocated, so the back pointers are filled in where the
core hands one over, in isert_immediate_queue() and isert_response_queue(),
which also covers the ISTATE_REMOVE the review pointed at.

4/4 is v1's 2/2, unchanged.

Measured on a LIO target with KASAN, one fresh boot per cell, arms
alternating; 2 boots per intermediate stage and 5 for the finished series,
on an iSER portal over soft-RoCE:

                                 base    1/4     1-2/4   1-3/4   1-4/4
  Reject + NOP-Out with a
   reserved ITT and TTT 0        Oops    Oops    Oops    clean   clean
  the same two PDUs paced        Oops    Oops    Oops    clean   clean
  nopin_timeout 0 then 3 on a
   logged-in iSER session        Oops    Oops    clean   clean   clean
  200 Data-Outs with a
   nonexistent ITT               128     128     128     128     200
  one Data-Out over Target-
   RecvDataSegmentLength          -       -       -       -      clean
  login, WRITE, READ verify,
   unsolicited Data-Out, logout   -       -       -       -      10/10

Every cell of the finished series is KASAN-clean: 0 reports in 30 cells.
On plain iscsi_tcp, 20 Data-Out/NOP-Out(TTT 0) pairs in one write give 19
or 20 KASAN reports per cell on base, 5 cells out of 5, and 0 with 1/4.

Regression on iscsi_tcp, base against the finished series: the nopin timer
still fires and its answer is still matched, 5 cells each, and login, READ,
WRITE, readback, logout and a CHAP login all pass with no splat.

Still open: iscsit_handle_data_ack() is the one caller whose wanted kind I
could not exercise, so that hunk of 1/4 rests on the code alone.

Yehyeong Lee (4):
  scsi: target: iscsi: match a NOP-In by opcode as well as by tag
  scsi: target: iscsi: do not arm the nopin timer on an iSER connection
  IB/isert: finish a Reject the target core allocated itself
  IB/isert: do not leak the receive descriptor of a dropped Data-Out

 drivers/infiniband/ulp/isert/ib_isert.c   | 41 +++++++++++++++++------
 drivers/target/iscsi/iscsi_target.c       |  3 +-
 drivers/target/iscsi/iscsi_target_erl1.c  |  2 +-
 drivers/target/iscsi/iscsi_target_login.c |  5 ---
 drivers/target/iscsi/iscsi_target_util.c  | 16 +++++++--
 drivers/target/iscsi/iscsi_target_util.h  |  4 ++-
 6 files changed, 51 insertions(+), 20 deletions(-)

-- 
2.43.0

