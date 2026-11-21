Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795279145;
	b=1+yZtjDJnyEcutzY9rR/3j6/LKgnoez6oSRW98JGGoKPG+bvYu9UTNOYIljk/d+UK0Le
	 JAhJjpVb1IwN7Xhc/KvjixwQSFIWwDSRwvvOTx5662v5hg8R2ffZRXtUfQtNt32l3UD5v
	 R3PT5m66segwllWt3MPMi5ryAwoWraFFejdDQEhmoAO15vFDqyB0r7uDuXi3lhOmOpRZ7
	 vB27j1Tj7SaWMsRAPveLC2PqFpcGoFUmwLNFXd4MwhhoCeerTfgD+v8trJbiDjFwNgKpz
	 v5c4i+kOOj47hXiIBKLhceWxA9ehZzTxrmQH9KnjSusEEY8tVSbVABsVvJiH/UlpAYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795279145;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Subject:From:To:Cc:Date:Message-ID:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=UvpOy7GOb9rkObKegTI8SaLmn0rbNgwEAUXCgiEk9Sg=;
	b=I8xXA92QMsQFNBjAsbaYlzMOBAogh4wgQ2CuJYvC7nMFvPInv5FDtV1lds5ikc5aSagk
	 Y/ph8wn+9vpXRQQ1sTYZgyKWvbQaq4+YdSlhWepnr7qaplrdhrQI3VViZ4xdBd1aF5jTk
	 FEOJvHIW4L2EwuRWiKnPq+sEq4hSCzF/CEGYOgOb/RxMTNYJdNdzUE51AKA9KJrzV2fL4
	 nd9XEalng1v8pZA79rLd/0O69j4vl5AznfOs/XabejNgu1T7Lsw7BEJF+I6BpH2E0yLfK
	 q5TnWoEyhbLoDwDJsR1AE8BUinltcJe1/ScV2iOgJDLQEu1wopk1wOhQ0wCsp1jW6ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=f+MzvHFf;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9E0606A320
	for <target-devel@vger.kernel.org>; Sat, 21 Nov 2026 16:39:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EE9E0606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=f+MzvHFf
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a214c5c4c0so17672685e9.3
        for <target-devel@vger.kernel.org>; Sat, 21 Nov 2026 08:39:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795279143; x=1795883943; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :cc:to:from:subject:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UvpOy7GOb9rkObKegTI8SaLmn0rbNgwEAUXCgiEk9Sg=;
        b=f+MzvHFfqQ9WcbUSNKxJj1Ic+3RE+07hDar/TjwNI5eDF9Qio/PkinckXvA/B9AC4q
         SQZJsP69aC01AzYvoojV9pj8fpG7bmLXfjM83jVrB2QwD/3JahcKWGlzGFztuyk0SE4l
         C9Wbx73I5pQxtxIQRauurGKZZZyWH5csSjD/6BUu7b12cLSa3ufRkyAOlSZ1VFUUp8yh
         kOCQ65OkPWm/SEe+z7C3wxy37KuDBaElNZeOtipOTXYGi8uAczrYwqeotlRWPxz+64i1
         Y4I2dkkPzLS8XuAQt+7hkD3x8jdYamrzMoUaPT6rjiwk4aNIvDAIqodTht+Mnk96mZA4
         IbjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795279143; x=1795883943;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :cc:to:from:subject:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UvpOy7GOb9rkObKegTI8SaLmn0rbNgwEAUXCgiEk9Sg=;
        b=QG9iMaYk9QSXlM/IHyYcIfhHJywpUrlmvSpD/Thj6sZ8OF2YkdTsoKUrikB+CFT77A
         +Dlpim9aiZQRnSBQpMXE1I2ZgZwZIzCnBr+WWFoW/BzdA+x5+EqVSCwyNYzZ86dg05tC
         4cz9M6VlPePjhQGWR95VCSYpfHEYKkTB3F7QBeIdj6ItjY//5HD5cov92lptu4Aq6ciz
         pIGdLQRVNnaCNZ5bLZ1USz4vtmQN2eCxZg52Lo6Zjb+bUjwTTtBkElG3EPBuKFnpLAZ1
         jQ97szOHhFYCCPBXOOlFs3AnfCYsdNJboBchMCAzWE4rn5tmJxBigOXn7gMoTee0OP6X
         K+Cw==
X-Forwarded-Encrypted: i=1; AL+hErEWr3OnTTTKYutcvZ8+/r14IQDw76ZiqZ9hHjqDFCRgKisRQsTa5xjFuzpKSUzjMcbKtgT+rT4p6apEBp8=@vger.kernel.org
X-Gm-Message-State: APuU4Z8hkLfBeCSmsLdvdQRipABKmnJWvmU5zu1yTA8h/bzaG9rBQ11W
	PGZinePbkF9BvAULKJbSc9Ze70L0HPVNYwiUHcIORPCYU8cnZTohGzra
X-Gm-Gg: AZFdTZd2Jo2jZl8EOfaXdyja0AjM3zA88KXOJtsztQ6H4iLxf5zmbMjekT7iQFHPdgj
	Bin53h6d+h3Oz3w7A0Ftca41tOV5JExpgFhgAoGrR6ecISiMBjlaM5kOuQFMs0qv/OutLXFa6/Q
	S/9J8aEQROi602JjcPYX8CvKKaOmycj2QPtc3pQhS0z42VAaEG5Fai+9c7I1A8Ujy+4PfZmqAWO
	5pOdcNJ/KdVALm/ODp7lBNuA0x+xZbiKPHmbVA8PcB9Tbc5lMjWs4i05GUGZug9tlheUq2B1yvk
	jaQIKzIAY0sCYs44OY1RNmCyJ+4bCFsI8PEgCSwt+1TXaR6N+AWMYXt6lfZk1IZvHCO6wKxMgUi
	3tOGNNj4X4/onCbiunNZ29+ExXqNIjoQ9L56QUQpPiPLQ2YxJMIBxF8zNf349CTiYWJLooVanh8
	4lcqnLhbAkxBJT5e3lkDrGFsA40FUVQ8cueokeDd0z9XNmB64bMGwNh3bETFbBiSkTwEFVTBoVy
	3IZz27D0M2QNd8kOdkRDGszuymbrrPN1PFGJSsgE53cbjx9Sl94qtJIerJli1HHFvfm/0+cYm0t
	6liNr7Tvq+QoP2iCrNIdeLQ3iyJ8mdN9sGuYR84hpDvb
X-Received: by 2002:a05:600c:5246:b0:4bb:60ba:49e0 with SMTP id 5b1f17b1804b1-4bb88930707mr157734315e9.26.1795279143087;
        Sat, 21 Nov 2026 08:39:03 -0800 (PST)
Received: from [10.77.1.44] ([94.188.8.172])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab69bf61b8sm11212895f8f.19.2026.11.21.08.39.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 08:39:02 -0800 (PST)
Subject: [PATCH 0/1] scsi: target: iscsi: fix use-after-free in iscsit_stop_session()
From: Vitalii Dodonov <dreamer.two@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: stable@vger.kernel.org,target-devel@vger.kernel.org
Date: Sat, 21 Nov 2026 19:38:57 +0300
Message-ID: <179527913740.32224.2426414360492240680@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Post: <mailto:target-devel@vger.kernel.org>
List-Help: <mailto:target-devel+help@vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:target-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

The iSCSI target panics with a general protection fault inside
iscsit_stop_session() when a session that has more than one connection is
torn down while another thread closes one of those connections.

iscsit_stop_session() walks sess->sess_conn_list with
list_for_each_entry_safe() and drops sess->conn_lock inside the loop.  A
connection that is being shut down concurrently runs iscsit_close_connection(),
which removes itself from the list with list_del() under the same lock and
leaves LIST_POISON1 in conn->conn_list.next.  Pinning the next connection with
iscsit_inc_conn_usage_count() keeps the object alive, but not the list links,
so the following iteration computes conn_tmp = list_next_entry() from the
poisoned pointer and passes it to iscsit_inc_conn_usage_count(), which takes a
spinlock at *(conn_tmp + offsetof(conn_usage_lock)) and faults on
0xdead000000000004.

Crash, 7.3.0-11-generic, LIO target with MaxConnections=8, Microsoft iSCSI
initiator holding 8 MC/S connections, graceful reboot of the initiator while
I/O is in flight:

  Oops: general protection fault, probably for non-canonical address 0xdead000000000004: 0000 [#1] SMP PTI
  CPU: 0 UID: 0 PID: 9028 Comm: kworker/0:2 Not tainted 7.3.0-11-generic #12-Ubuntu PREEMPT(lazy)
  Workqueue: events iscsi_target_do_login_rx [iscsi_target_mod]
  RIP: 0010:_raw_spin_lock_bh+0x18/0x50
  RDI: dead000000000004   RBX: deacfffffffffcb0   R15: deacfffffffffcb0
  Call Trace:
   ? iscsit_inc_conn_usage_count+0x1b/0x40 [iscsi_target_mod]
   iscsit_stop_session+0x7d/0x1b0 [iscsi_target_mod]
   iscsi_check_for_session_reinstatement+0x1e1/0x290 [iscsi_target_mod]
   iscsi_target_handle_csg_one+0x135/0x160 [iscsi_target_mod]
   iscsi_target_do_login+0x32/0xe0 [iscsi_target_mod]
   iscsi_target_do_login_rx+0x2d2/0x420 [iscsi_target_mod]
   process_one_work+0x1dc/0x3f0
   ...
  Kernel panic - not syncing: Fatal exception in interrupt

The same fault is reachable from the logout path:
iscsit_stop_session <- iscsit_logout_post_handler <- iscsit_response_queue <-
iscsi_target_tx_thread, with the identical 0xdead000000000004.

Where it was first seen (field report).  A Proxmox VE host (7.0.14-9-pve,
later 7.0.14-28-pve) exported zvols through LIO to Windows 11 clients using
the Microsoft iSCSI initiator with MC/S.  The host had been stable for 95 days
with MaxConnections=1; after raising it to 2 there were four panics in one
night, all with the same general protection fault at 0xdead000000000004 and
the logout stack above, and the journal of one of them contains "Received
logout request on connection that is not in logged in state".  The panic also
reproduced on 7.0.14-28-pve, so it is not tied to a single build.  The module
carrying this fix has been running on that host for 9 days with
MaxConnections=4 and 72 active iSCSI connections, without a single panic.

Reproducer (any MC/S-capable initiator; open-iscsi does not implement MC/S, so
a Microsoft iSCSI initiator was used):

 1. LIO target with MaxConnections=8, no CHAP, generate_node_acls=1.  The
    value lives in configfs and is not exported by targetcli:

      echo 8 > /sys/kernel/config/target/iscsi/<iqn>/tpgt_1/param/MaxConnections

    With MaxConnections=1 the extra connection is refused with
    ISDSC_TOO_MANY_CONNECTIONS and nothing happens, so the target has to be
    configured first.

 2. Initiator: log in, for example on Windows

      Connect-IscsiTarget -NodeAddress <iqn> -TargetPortalAddress <ip>

    and then add the remaining connections to the *same* session, one call
    per connection:

      iscsicli SessionList                 # take the "Session Id"
      iscsicli ListInitiators              # -> ROOT\ISCSIPRT\0000_0
      iscsicli QAddConnection <SessionId> ROOT\ISCSIPRT\0000_0 <portal-ip>

    Repeat until the session holds MaxConnections connections.
    AddIScsiConnectionW() does the same thing programmatically, and the
    "MCS..." button in the iSCSI Initiator GUI (target -> Properties ->
    Sessions) as well.

 3. Bring the LUN online, mount a filesystem on it and start writing to it.

 4. Reboot the initiator gracefully while the I/O is still in flight; repeat.
    The stock module crashed on the 2nd-4th cycle (2 panics in ~20 minutes).

Results: stock module 2 crashes in 8 cycles, patched module 0 in 118 cycles
(the target stayed up for the whole run).

Patch 1/1 takes a snapshot of the connections, with a reference on each, while
conn_lock is held, and then works only on that snapshot; the order in which the
connections are reinstated is unchanged.

Vitalii Dodonov (1):
  scsi: target: iscsi: fix use-after-free in iscsit_stop_session()

 drivers/target/iscsi/iscsi_target.c | 68 ++++++++++++++++++++---------
 1 file changed, 47 insertions(+), 21 deletions(-)
