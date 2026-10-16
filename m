Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F09C3BB66B
	for <target-devel@vger.kernel.org>; Fri, 16 Oct 2026 06:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792133728; cv=none; b=Rtrjj8zUNhKfXk3wu8W0RQTvgwAtUHCizeQjl/4orpANXN59EveYhbQZRaj1NnstYig9GbTM/yoPZZSpZiiSbd0POpfBsY2KBpXxOhTPjsQSw/B68comel/EjfY4qj4d8ziqsP1MNAXvEQYLyNJDzmQdyR3RiMrpQO4+UUgiTCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792133728; c=relaxed/simple;
	bh=ncpy0EnqF9l+kQ2Pf1jg0Ciz5YvWnfAlYtwJOLPYna0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FfjmgG3xzof7pz0IyHyidXoY6C2D97Vrl3p84eZXpNbgL89CRjqO0XDRNX8UYK+VWdexDYCpJkA2Wm4n59CYdF+yc+fqs62ORmuML2NErHzSrFHJWD3MeSsjjtLrX3nXTf6D5OMXNKaTz+vXEFi90So+/6iGL4fDcKnxYf6wdKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hLn/hfzi; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hLn/hfzi"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3ab752f6244so1869183a91.2
        for <target-devel@vger.kernel.org>; Thu, 15 Oct 2026 23:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792133727; x=1792738527; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=UMdZI/opS9rHJksOsCM3YzUdT2OraHcd3NLiwvXbxvE=;
        b=hLn/hfzijn/ylmdOL+lzYRX0C3FeEsZbPVvuNexcC8RqrRG5GWSD5JePdbhSgui6zK
         q+EUmZCEdvQSRNHF71Ac5BkTwFZa84KkvZfkuhnz80+k7zEOUZ7AaCfIB0HAEyyiN4oA
         OzVADtPJYXScu/Eis2zAir+WhDWISXXINItVMYQBG0wdtx2pjlA8ltASAuOtVcf0VEe9
         bi+ljTW5TcQnthMC0uGWgtqwIwK411hj9sOYhHuhQ+TFLIK+k039vqm7BOTGxWOV1iXr
         uZ+HbNRKaqMmYth6cGp7IAmsjary8PMWmiA+EjibeX2m1GAJ1KE2cXSkDjvT+ZAYBKbL
         Vs2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792133727; x=1792738527;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UMdZI/opS9rHJksOsCM3YzUdT2OraHcd3NLiwvXbxvE=;
        b=uUvLoYBDSU0k9A3Wu9Fuzi+Rw/3jM7oemzyHTKQxZIyhlNt2JVHtRoN1TCv3zI9G5a
         VEAjpZytGnRaxr5rajB7IUniIr5lS7Qmyj9sahr3Iv1VOb9qFYe79YMJ/PEcWoPeU4fb
         nPjU1os+pfi+VUiVQWs5Fh6ICstplxVA5F8ZYMaQ8OiZdAxgthLeTqhk0Jhe6M4VR73J
         6nxVci6GfaHwvTByiU2UmeCGjFSf2rzMrLC4YMv2jlpiQ8PFeNRDMMCcmTsPFdzkcqr1
         uWyuiGl5YB951DGtKC4LThI7EGUslSLWKP4TPg7Ol+86Qz4nSzdpw/PUCqwJIQVX5puJ
         26Ng==
X-Forwarded-Encrypted: i=1; AKwUvBzla+mi15jBqYDhGuGbwml5kRrSQdcOq1xd6xryUnf1ReZq4TuhbI/Uej9DlidiILWPUyroQgZ6A/nlTjc=@vger.kernel.org
X-Gm-Message-State: AFq9FYKDTjBrJVtYLYMlsfpSGesBin3WGWBx474Gys1kDIapHuIf4Nrj
	xby21AbzW0Z2lT9HaL02R+HMMd65FdNMKqbSqyb8Xi6aWHWOiYT8cClw
X-Gm-Gg: AYBFou005wt5WUDrhMrvqedNjspE3jWwM8RcbiGXa26U2wd8a+56uW7jq/sLPpgGWBl
	YYVPUsOxqZZob6NCb+ini7DCutSeDnLnWrYwS5ymbfnFwt7I0IAocoOZy3tjEFJce9vFkwJECtB
	9nmTjipxHgUo9muWaJ1xaNlQO1ocDQKPhJYKtg9jjjEJyeemy6JlNznoQNliimSTWYMUcYuNrHk
	qDLPYMf7g5r61CcYqqEW5dBuJdGpc6Ovdy1ObkVNGorANF+Hu52ZMuRxacZ8o3N86BXpka/TPtC
	m4ehSMp2pyRPUNtSHTPeDorGhQGDgO3D36wVzY4c+emiiyRdBTA9mWPmenPJ5x/UzX4hhp5Rn4K
	10BWAVc+/2FK3SuuAgRvLl9FPkBfIlkPVzkuYT/OlmuDGsuToyDA5M12j0ah+Qj0FdEWcMQwJmB
	BYB1BfzVX0RbjlwltYqqXUUnCIHxc4FHsGH6WNorIDMCN37j/znvJvEOcI2cMG4ggQ+gxn7sGSX
	iE0S7gKJrEv0N0XAEYsaNJYFcOtOBVQXmDvWjD0r+DznOC9Xl6lI261isFP2/R8blK32ctbrGVz
	Wt0pxnDovPyMi/fKlo0Z15FTrCFFQwm1qrQYpjLylB8zhl+GbsBxcC799Sp+
X-Received: by 2002:a17:90b:1b02:b0:3ac:80de:44f0 with SMTP id 98e67ed59e1d1-3ac80de6793mr6477432a91.4.1792133726731;
        Thu, 15 Oct 2026 23:55:26 -0700 (PDT)
Received: from EAIT-H54D9Q2FJQ.eait.uq.edu.au ([130.102.10.249])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acc9a40720sm1110434a91.1.2026.10.15.23.55.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 15 Oct 2026 23:55:26 -0700 (PDT)
From: Yu Zhang <yuz08559@gmail.com>
To: Mike Christie <michael.christie@oracle.com>,
	Dmitry Bogdanov <d.bogdanov@yadro.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yu Zhang <yuz08559@gmail.com>
Subject: [BUG] scsi: target: iscsi: connection-recovery (cr) double-free / list corruption in ERL=2
Date: Fri, 16 Oct 2026 16:55:17 +1000
Message-ID: <20261016065517.91750-1-yuz08559@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

struct iscsi_conn_recovery has no refcount; its lifetime is governed only by
sess->cr_i_lock / cr_a_lock, which protect list membership, not the object once
a pointer escapes the lock.

iscsit_get_inactive_connection_recovery_entry() looks up a cr by CID and returns
it after dropping cr_i_lock, with no reference taken:

	spin_lock(&sess->cr_i_lock);
	list_for_each_entry(cr, &sess->cr_inactive_list, cr_list) {
		if (cr->cid == cid) {
			spin_unlock(&sess->cr_i_lock);
			return cr;
		}
	}

The caller then runs iscsit_discard_cr_cmds_by_expstatsn(cr, ...) with no lock
spanning lookup -> use; when cr->cmd_count reaches 0 it frees the cr:

	iscsit_remove_inactive_connection_recovery_entry(cr, sess);
	iscsit_attach_active_connection_recovery_entry(sess, cr);
	iscsit_remove_active_connection_recovery_entry(cr, sess);  /* kfree(cr) */

Two contexts run this get-then-discard on the same session with no
serialization between them: the REMOVECONNFORRECOVERY logout handler
(iscsi_target.c, per-connection tx thread) and the ERL=2 implicit logout on
login path (iscsi_target_login.c). If both obtain the same cr (both find it on
cr_inactive_list before either removes it) and both reach the cmd_count == 0
branch, the cr is unlinked and kfree()d twice -> double-free, with a list_del on
an already-freed entry in between -> list corruption.

Reported-by: Yu Zhang <yuz08559@gmail.com>
