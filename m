Received: from mail.ltx.eu (mail.ltx.eu [95.169.169.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825725B670
	for <target-devel@vger.kernel.org>; Tue,  5 Mar 2024 10:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.169.169.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709635355; cv=none; b=S+wfemvNhtze197jW7GLvvKJzyb2IkQr/GJE5+WwEpfieL7450XSWBmuFntO5TKLJ2x/svoSUYFAHoOGotPiieSq5UGX8clRHSxnAkhP6h4Qzla5+RJaZRIcVaKAG9HtUcKB5kmgCsLAxNatpu1AI5V0Bqjx6sZhbLPe+j+v0SM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709635355; c=relaxed/simple;
	bh=QlyPnw59Q55yEQsZVzhkDGrPkH2Lr78uVSdq3C2tn6k=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:To; b=uANhZ9S631t6HByGIBtYTmxbxmzmpnCi+PEh8hnNcQWL7MhxMV9C+RFUYYiGbQhAd3Qo8YKdLU/PIOUqoGTuXMt1M87kAnPB2DUdVUKavyFztWSUJHbeyS1qAkTZ97l5ZrnJ2SomrROV3S25xHmGO48nRrRc60d527zKdnNr0Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ltx.cc; spf=pass smtp.mailfrom=ltx.cc; dkim=pass (2048-bit key) header.d=ltx.cc header.i=@ltx.cc header.b=s6xURRAp; arc=none smtp.client-ip=95.169.169.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ltx.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ltx.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ltx.cc header.i=@ltx.cc header.b="s6xURRAp"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 5B7EF6A0115
	for <target-devel@vger.kernel.org>; Tue,  5 Mar 2024 11:36:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ltx.cc; s=dkim;
	t=1709634989; h=from:subject:date:message-id:to:mime-version:content-type:
	 content-transfer-encoding; bh=ucJc7nqaoVbxU8iTI3dEUCrS65cctmm/nds6jCgsgPA=;
	b=s6xURRApzt+yebEazrJ/GOqYS0rDevFWXYjqdTQrziyNbiseavCky4owwaIdfy59bi5wv5
	6cSMg12KwUhOiiGFkrcgFXY4JvPrVdwK9fgaS/0kVeuQCWGx+xdKWpZWZ9NjmY+/tKr1lH
	xejnrWCiszgmB+JqwMGgUYvzrFka/Zm/iaN1Mg7lHWkcEvRsvCMA7MmXoAv3f6kKW+ivzO
	4dXTwox4MapVbffeahYKcFykTgSkA5eekdKOAehCXuM/v63AIdWE9U97XuoPaBKd/oOpBc
	ZawsGVMq48Jyeha4gIJiI4cBH0miM/7astZ7Z3oybRahJXM+77zAMAJkFnsO8Q==
From: Holger Amberg <ha@ltx.cc>
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.400.31\))
Subject: Unable to recover from DataOut timeout while in ERL=0
Message-Id: <EA1BF689-4BEB-487B-AB99-D4D2275D0F0E@ltx.cc>
Date: Tue, 5 Mar 2024 11:36:06 +0100
To: target-devel@vger.kernel.org
X-Last-TLS-Session-Version: TLSv1.2

Hello, everyone,=20

i am using a pair of Ubuntu 22.04 AMD EPYC 9124 servers with DRBD =
Primary/Secondary and iscsi target configuration to serve VMWare ESXi =
hosts. Everything was working a few month, but i have had two complete =
freezes recently within 24hrs caused by stuck iscsi targets. Only a =
complete reboot or failover to the other node can fix this issue. The =
problem is starting with =E2=80=9EUnable to recover from DataOut =
timeout=E2=80=9C and then causing a set of many other issues errors, =
hung_task_timeouts, kernel stack traces at the end. Any idea what might =
cause this problem?=20

Environment:
* Ubuntu 22.04
* Kernel: 5.15.0-94-generic x86_64
* DRBD: 9.2.7
* 1 CPU EPYC 9124, 32GB of RAM
* Asus RS500A-E12-RS12U/K14PA-U24
* 4 targets with 5 TB each backend by DRBD and LVM

Mar  4 18:23:08 km38033 kernel: [32853.081205] Unable to recover from =
DataOut timeout while in ERL=3D0, closing iSCSI connection for I_T Nexus =
iqn.1998-01.com.vmware:km38112-6f3c301b,i,0x00023d000001,iqn.2001-09.com.c=
ustomer:target2,t,0x01

Mar  4 18:23:13 km38033 kernel: [32857.897105] ABORT_TASK: Found =
referenced iSCSI task_tag: 756708339
Mar  4 18:23:13 km38033 kernel: [32857.897144] ABORT_TASK: Sending =
TMR_TASK_DOES_NOT_EXIST for ref_tag: 756708339
Mar  4 18:23:14 km38033 kernel: [32859.382095] Detected MISCOMPARE at =
offset 20
Mar  4 18:23:21 km38033 kernel: [32866.464749] Detected MISCOMPARE at =
offset 56
Mar  4 18:23:22 km38033 kernel: [32867.481244] Detected MISCOMPARE at =
offset 13
Mar  4 18:23:23 km38033 kernel: [32868.000291] Detected MISCOMPARE at =
offset 13
Mar  4 18:23:23 km38033 kernel: [32868.335822] Detected MISCOMPARE at =
offset 13
Mar  4 18:23:24 km38033 kernel: [32869.176568] Detected MISCOMPARE at =
offset 13
Mar  4 18:23:28 km38033 kernel: [32873.047201] ABORT_TASK: Sending =
TMR_TASK_DOES_NOT_EXIST for ref_tag: 157801725
Mar  4 18:23:29 km38033 kernel: [32873.901843] Detected MISCOMPARE at =
offset 13
Mar  4 18:23:35 km38033 kernel: [32880.495731] Detected MISCOMPARE at =
offset 28
Mar  4 18:23:36 km38033 kernel: [32881.012692] Detected MISCOMPARE at =
offset 56
Mar  4 18:23:36 km38033 kernel: [32881.013909] Detected MISCOMPARE at =
offset 14
Mar  4 18:23:38 km38033 kernel: [32882.886672] Detected MISCOMPARE at =
offset 14
Mar  4 18:27:46 km38033 kernel: [33130.878094] ABORT_TASK: Found =
referenced iSCSI task_tag: 263906787
Mar  4 18:27:46 km38033 kernel: [33130.878118] ABORT_TASK: Sending =
TMR_TASK_DOES_NOT_EXIST for ref_tag: 263906787
Mar  4 18:27:47 km38033 kernel: [33131.879914] ABORT_TASK: Found =
referenced iSCSI task_tag: 756717268
Mar  4 18:27:47 km38033 kernel: [33131.879943] ABORT_TASK: Sending =
TMR_TASK_DOES_NOT_EXIST for ref_tag: 756717268
Mar  4 18:27:47 km38033 kernel: [33131.880389] ABORT_TASK: Found =
referenced iSCSI task_tag: 756717269
Mar  4 18:27:47 km38033 kernel: [33132.179400] ABORT_TASK: Sending =
TMR_FUNCTION_COMPLETE for ref_tag: 756717269
Mar  4 18:27:47 km38033 kernel: [33132.180525] ABORT_TASK: Found =
referenced iSCSI task_tag: 756717304
Mar  4 18:27:47 km38033 kernel: [33132.180748] ABORT_TASK: Found =
referenced iSCSI task_tag: 209408054
Mar  4 18:27:47 km38033 kernel: [33132.180783] ABORT_TASK: Sending =
TMR_TASK_DOES_NOT_EXIST for ref_tag: 209408054
Mar  4 18:27:47 km38033 kernel: [33132.181353] ABORT_TASK: Found =
referenced iSCSI task_tag: 209408082
Mar  4 18:27:48 km38033 kernel: [33133.234828] ABORT_TASK: Sending =
TMR_FUNCTION_COMPLETE for ref_tag: 756717304
Mar  4 18:27:48 km38033 kernel: [33133.234932] Detected MISCOMPARE at =
offset 20
Mar  4 18:27:49 km38033 kernel: [33133.568484] ABORT_TASK: Found =
referenced iSCSI task_tag: 18127
Mar  4 18:27:49 km38033 kernel: [33133.568507] ABORT_TASK: Sending =
TMR_TASK_DOES_NOT_EXIST for ref_tag: 18127
Mar  4 18:27:49 km38033 kernel: [33133.575026] ABORT_TASK: Sending =
TMR_FUNCTION_COMPLETE for ref_tag: 209408082
Mar  4 18:27:49 km38033 kernel: [33133.845133] ABORT_TASK: Found =
referenced iSCSI task_tag: 1434712138
Mar  4 18:27:49 km38033 kernel: [33133.845159] ABORT_TASK: Sending =
TMR_TASK_DOES_NOT_EXIST for ref_tag: 1434712138
Mar  4 18:27:49 km38033 kernel: [33133.845273] ABORT_TASK: Found =
referenced iSCSI task_tag: 157803718
Mar  4 18:27:49 km38033 kernel: [33133.845307] ABORT_TASK: Sending =
TMR_TASK_DOES_NOT_EXIST for ref_tag: 157803718
Mar  4 18:27:49 km38033 kernel: [33133.845344] ABORT_TASK: Found =
referenced iSCSI task_tag: 286437689
Mar  4 18:27:49 km38033 kernel: [33133.845522] ABORT_TASK: Found =
referenced iSCSI task_tag: 157803719
Mar  4 18:27:49 km38033 kernel: [33133.845531] ABORT_TASK: Sending =
TMR_TASK_DOES_NOT_EXIST for ref_tag: 286437689
Mar  4 18:27:49 km38033 kernel: [33133.845967] ABORT_TASK: Found =
referenced iSCSI task_tag: 286437691
Mar  4 18:27:51 km38033 kernel: [33135.654498] ABORT_TASK: Sending =
TMR_FUNCTION_COMPLETE for ref_tag: 286437691
Mar  4 18:27:51 km38033 kernel: [33135.654987] ABORT_TASK: Sending =
TMR_FUNCTION_COMPLETE for ref_tag: 157803719
Mar  4 18:27:51 km38033 kernel: [33135.655087] ABORT_TASK: Sending =
TMR_TASK_DOES_NOT_EXIST for ref_tag: 286437697
Mar  4 18:27:52 km38033 kernel: [33137.235524] ABORT_TASK: Found =
referenced iSCSI task_tag: 263906810
Mar  4 18:27:52 km38033 kernel: [33137.408856] ABORT_TASK: Sending =
TMR_FUNCTION_COMPLETE for ref_tag: 263906810
Mar  4 18:27:52 km38033 kernel: [33137.409000] Detected MISCOMPARE at =
offset 56
Mar  4 18:27:52 km38033 kernel: [33137.409320] ABORT_TASK: Found =
referenced iSCSI task_tag: 263906811
Mar  4 18:27:52 km38033 kernel: [33137.409522] ABORT_TASK: Sending =
TMR_FUNCTION_COMPLETE for ref_tag: 263906811
Mar  4 18:27:53 km38033 kernel: [33137.584808] Detected MISCOMPARE at =
offset 56
Mar  4 18:27:53 km38033 kernel: [33137.584843] Detected MISCOMPARE at =
offset 56
Mar  4 18:27:53 km38033 kernel: [33137.584877] Detected MISCOMPARE at =
offset 56
Mar  4 18:27:53 km38033 kernel: [33138.289566] Detected MISCOMPARE at =
offset 56
Mar  4 18:27:53 km38033 kernel: [33138.289721] Detected MISCOMPARE at =
offset 56
Mar  4 18:27:53 km38033 kernel: [33138.289903] Detected MISCOMPARE at =
offset 56
Mar  4 18:27:57 km38033 kernel: [33141.720127] ABORT_TASK: Sending =
TMR_TASK_DOES_NOT_EXIST for ref_tag: 1434712401
Mar  4 18:27:58 km38033 kernel: [33142.940133] Detected MISCOMPARE at =
offset 56
Mar  4 18:27:59 km38033 kernel: [33144.323760] Detected MISCOMPARE at =
offset 56
Mar  4 18:27:59 km38033 kernel: [33144.323965] Detected MISCOMPARE at =
offset 56
Mar  4 18:27:59 km38033 kernel: [33144.498569] Detected MISCOMPARE at =
offset 56
Mar  4 18:28:01 km38033 kernel: [33146.244787] Detected MISCOMPARE at =
offset 56
Mar  4 18:28:01 km38033 kernel: [33146.246893] Detected MISCOMPARE at =
offset 56
Mar  4 18:28:01 km38033 kernel: [33146.246931] Detected MISCOMPARE at =
offset 56
Mar  4 18:28:02 km38033 kernel: [33147.476180] Unable to recover from =
DataOut timeout while in ERL=3D0, closing iSCSI connection for I_T Nexus =
iqn.1998-01.com.vmware:km38116-369efe55,i,0x00023d000001,iqn.2001-09.com.c=
ustomer:target1,t,0x01
Mar  4 18:39:28 km38033 kernel: [33833.544517] INFO: task iscsi_np:27427 =
blocked for more than 241 seconds.
Mar  4 18:39:28 km38033 kernel: [33833.544952]       Tainted: G          =
 OE     5.15.0-94-generic #104-Ubuntu
Mar  4 18:39:28 km38033 kernel: [33833.545254] "echo 0 > =
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar  4 18:39:28 km38033 kernel: [33833.545547] task:iscsi_np        =
state:D stack:    0 pid:27427 ppid:     2 flags:0x00004004
Mar  4 18:39:28 km38033 kernel: [33833.545550] Call Trace:
Mar  4 18:39:28 km38033 kernel: [33833.545552]  <TASK>
Mar  4 18:39:28 km38033 kernel: [33833.545554]  __schedule+0x24e/0x590
Mar  4 18:39:28 km38033 kernel: [33833.545560]  schedule+0x69/0x110
Mar  4 18:39:28 km38033 kernel: [33833.545562]  =
schedule_timeout+0x105/0x140
Mar  4 18:39:28 km38033 kernel: [33833.545564]  ? =
__kmalloc_track_caller+0x181/0x340
Mar  4 18:39:28 km38033 kernel: [33833.545569]  ? =
iscsi_update_param_value+0x28/0x70 [iscsi_target_mod]
Mar  4 18:39:28 km38033 kernel: [33833.545578]  =
__wait_for_common+0xae/0x150
Mar  4 18:39:28 km38033 kernel: [33833.545579]  ? =
usleep_range_state+0x90/0x90
Mar  4 18:39:28 km38033 kernel: [33833.545581]  =
wait_for_completion+0x24/0x30
Mar  4 18:39:28 km38033 kernel: [33833.545582]  =
iscsit_stop_session+0x18f/0x1b0 [iscsi_target_mod]
Mar  4 18:39:28 km38033 kernel: [33833.545589]  =
iscsi_check_for_session_reinstatement+0x1df/0x280 [iscsi_target_mod]
Mar  4 18:39:28 km38033 kernel: [33833.545596]  =
iscsi_target_handle_csg_one+0x128/0x150 [iscsi_target_mod]
Mar  4 18:39:28 km38033 kernel: [33833.545603]  =
iscsi_target_do_login+0x71/0xd0 [iscsi_target_mod]
Mar  4 18:39:28 km38033 kernel: [33833.545609]  =
iscsi_target_start_negotiation+0x56/0x100 [iscsi_target_mod]
Mar  4 18:39:28 km38033 kernel: [33833.545615]  =
__iscsi_target_login_thread+0x2f0/0x620 [iscsi_target_mod]
Mar  4 18:39:28 km38033 kernel: [33833.545621]  =
iscsi_target_login_thread+0x24/0x60 [iscsi_target_mod]
Mar  4 18:39:28 km38033 kernel: [33833.545627]  ? =
__iscsi_target_login_thread+0x620/0x620 [iscsi_target_mod]
Mar  4 18:39:28 km38033 kernel: [33833.545633]  kthread+0x12a/0x150
Mar  4 18:39:28 km38033 kernel: [33833.545636]  ? =
set_kthread_struct+0x50/0x50
Mar  4 18:39:28 km38033 kernel: [33833.545638]  ret_from_fork+0x22/0x30
Mar  4 18:39:28 km38033 kernel: [33833.545641]  </TASK>
Mar  4 18:41:29 km38033 kernel: [33954.376305] INFO: task =
iscsi_trx:588744 blocked for more than 120 seconds.
Mar  4 18:41:29 km38033 kernel: [33954.376560]       Tainted: G          =
 OE     5.15.0-94-generic #104-Ubuntu
Mar  4 18:41:29 km38033 kernel: [33954.376811] "echo 0 > =
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Mar  4 18:41:29 km38033 kernel: [33954.377065] task:iscsi_trx       =
state:D stack:    0 pid:588744 ppid:     2 flags:0x00004004
Mar  4 18:41:29 km38033 kernel: [33954.377067] Call Trace:
Mar  4 18:41:29 km38033 kernel: [33954.377067]  <TASK>
Mar  4 18:41:29 km38033 kernel: [33954.377068]  __schedule+0x24e/0x590
Mar  4 18:41:29 km38033 kernel: [33954.377070]  schedule+0x69/0x110
Mar  4 18:41:29 km38033 kernel: [33954.377071]  =
schedule_timeout+0x87/0x140
Mar  4 18:41:29 km38033 kernel: [33954.377072]  ? =
__bpf_trace_tick_stop+0x20/0x20
Mar  4 18:41:29 km38033 kernel: [33954.377075]  =
__wait_for_common+0xae/0x150
Mar  4 18:41:29 km38033 kernel: [33954.377076]  ? =
usleep_range_state+0x90/0x90
Mar  4 18:41:29 km38033 kernel: [33954.377078]  =
wait_for_completion_timeout+0x1d/0x30
Mar  4 18:41:29 km38033 kernel: [33954.377079]  =
__transport_wait_for_tasks+0xd3/0x140 [target_core_mod]
Mar  4 18:41:29 km38033 kernel: [33954.377088]  =
transport_generic_free_cmd+0x14c/0x190 [target_core_mod]
Mar  4 18:41:29 km38033 kernel: [33954.377096]  =
iscsit_free_cmd+0x58/0xd0 [iscsi_target_mod]
Mar  4 18:41:29 km38033 kernel: [33954.377103]  =
iscsit_release_commands_from_conn+0x1cd/0x210 [iscsi_target_mod]
Mar  4 18:41:29 km38033 kernel: [33954.377109]  =
iscsit_close_connection+0x3bf/0x720 [iscsi_target_mod]
Mar  4 18:41:29 km38033 kernel: [33954.377115]  =
iscsit_take_action_for_connection_exit+0x86/0x110 [iscsi_target_mod]
Mar  4 18:41:29 km38033 kernel: [33954.377122]  =
iscsi_target_rx_thread+0xba/0x110 [iscsi_target_mod]
Mar  4 18:41:29 km38033 kernel: [33954.377128]  ? =
iscsi_target_tx_thread+0x220/0x220 [iscsi_target_mod]
Mar  4 18:41:29 km38033 kernel: [33954.377134]  kthread+0x12a/0x150
Mar  4 18:41:29 km38033 kernel: [33954.377135]  ? =
set_kthread_struct+0x50/0x50
Mar  4 18:41:29 km38033 kernel: [33954.377137]  ret_from_fork+0x22/0x30
Mar  4 18:41:29 km38033 kernel: [33954.377139]  </TASK>

Many thanks in advance.

Best regards,
Holger Amberg

