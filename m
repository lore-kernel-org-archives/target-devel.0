Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792502452;
	b=AA2tKnca4RTHDVDFR4PF2fuFItFeZW9dxmVkcork3DhtUs0CS28SDw2vttd4v3Q4Mbhz
	 a19SQEbqLN0d1NqDCesXOjPvpImz1y7V/Y7DfuMQ98/hF71wsj8eHeghwFCKB1yV3+eHX
	 FefEUQ3pPSVaMgFZXiprRKFgQ7yMaRyuraJ8nsVwFlvij27IxmKhwnPAfnt/1W4v95Bcr
	 bAxQb2VsW3oErSHg4arOmixSFM6at4bqXuVd7ersHF3E8HltTXPVjXmpB4mTdw/QD+4F6
	 5kO+h1GYL3xJmDgGWaEV0wryv/vUwrFOy+KaQOsrg66SRN2Iq5X+84t3SEBS4UG6fAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792502452;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=1aDjPA8RRZSC5RYtmkxavzjaFEuPSiecALjC0nZN+Aw=;
	b=iSt7rW7ciymxwtn69N1iWF91pIOsXVed+Ve6nufRhzzEWrN9RVcQJ2frf/q2BWGfhAfj
	 El1c77LKnVCoNZctYEtY0rlmgczcTw5Z7foHDedPu81h7fcTVkpYzTXZggPZr72rq8apf
	 hYnSuq2eQvVqsKeTQFdbeegeg34gOrSuCIxDFOm7zSKAnj78LpXW9+pYnvAUOogsV/KxU
	 miuGe1z+dpt+KCGSzLUvyiWrm64b5+C7b9408Saz1kpE0TXxg9MCbFlmNPUdnt3hz2/y5
	 ioIt3mmtRc87T487A8uktZNMGhNmqgXZtkB5bv9g2AbiLA52JeS4TJU6HZA+UrtPEkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=rcwmCASu;
	arc=none smtp.remote-ip=209.85.210.177
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9023606A319
	for <target-devel@vger.kernel.org>; Tue, 20 Oct 2026 13:20:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D9023606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=rcwmCASu
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8a070755c8cso871264b3a.0
        for <target-devel@vger.kernel.org>; Tue, 20 Oct 2026 06:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792502451; x=1793107251; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1aDjPA8RRZSC5RYtmkxavzjaFEuPSiecALjC0nZN+Aw=;
        b=rcwmCASuLgxsbEPoDfm/Ukh0cXl0rSSVME+BUp10XnjMBdJVdNVCtwU5mcYvOEFGEw
         KJ+cPp9W8g2LCGh7UAFHAdbD1bL+Yv0PT2xDja4cF4vIaU4uJIWfA5rJojhsZrTurdI0
         bFaROH4CPUUbzDBV5Ak39vvvXhJhDa5UWSx+hl9iUTVMJWbHafdvJjiuFBlQpziQSMj8
         FaCC5V/D3shcxw15FLRDY9FXDHVXkr86HaLFtDwfnBbUdgc8Yh9PKLvArVg1c2NoEYZS
         VBou7r0GqJPNcGgKjMExQ86x7x/Np1eOQ+Va9kSFrRblfyG0J7pGJxX/mZpcmPrDl2Fg
         KdMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792502451; x=1793107251;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1aDjPA8RRZSC5RYtmkxavzjaFEuPSiecALjC0nZN+Aw=;
        b=IyUQZzKYvAOM+XRz7EVQeCbF8CcqqcpA0XMGSxPfuIaZQtg4NM5Jaj4Pvds865TeAc
         Gyz6RDAZpUPFXiolvUf89YH09P2mZ8YAEVGvwkTszshvMF8hbXIoeT8mW+IZShLf+CKb
         HZiK8ztbF3ZB0ORmeSOazdN8iYzpkyo6rIzkBCLB/742SDjaKgzQUCeRj0plAk1/ClLQ
         1QxapRmmrhvV6hKEwmCLvj3oy5YXlbSHXQYh0HyfV2A+sS5DOz4v1QLoWbgC5R65oOy6
         dOw23MbW/LKepJFeeqYxXNA1N6DngaPPjNqRB9ZG9RHfEq046DjbYRxY8DZSigw7d21j
         CCMw==
X-Forwarded-Encrypted: i=1; AKwUvBxMMK5Q/hkCjQZJaJIOJGgMiarqVXKgsIw0iM4MVy/hcxKtFd8Pn84n+070Ando/fdtQxCHWZ7oUzFL2jo=@vger.kernel.org
X-Gm-Message-State: AFq9FYKYr1Y0zXffoLgy2jd3j12NR/yQ/6DZ3jayGyWzK765sBe2NQAy
	Jif96oPbB3sdkrzX03favEJM8KNdwH1IbEuNxZKMBTNKlSFS/J1rdz8D
X-Gm-Gg: AYBFou1yrfnguNRjZ8L3PtPs6VVSH+zG6155aYPWl0PClyHin7szxAQj/pa4KovqlVY
	HUdOuDq3tSvZNX/ZFHzQndviSzKvn6fJpYQgMtxVI0D9Yvn/63vOlXPVHpzmvUEivZH9deeODBW
	HzTEV4zvdklQWMZDsgEqc4mfbOh4MWpvZNoxLcwFTpglASPPNDUt+nvXoo/+TTpb4mpF2aIEK3H
	rO5KHSRq4T+3odBpgIu4VU8KgNEMPayg9NE63jGDo0nZLhamRFnfIzq+ierlgPmwpSed8sdl8gZ
	ZGOy+2Xy5bA/BDtvq4IAocAFzjow5mM3nfZX3phnmhy9h222h+23mxLWW0x4dFhzLc/ac4iXTdv
	sNUFx11ScihHCT/RrB97q5cV9alNWXLvS+9Kg33pkJZar4xLsUtjEF1xAZ28/MfmUr3MB/CnYzu
	KWZE6HIfZGZg7kVfoOwcOEvaS8UhuL8kWT8tfknHxkndYJYuzY1QGPb7wgaMC7XEh692fzYcPUv
	QJGYcJ00NmFb997pRHYHvaFdgB4ZcF/UJUcUGWmbKuUGh3zKaJWG+jNcB2rAuL6U7rgRdS0G6du
	A/ODGqRaTQ/N+tIWl3z/LyLVjrPP68XlRuD0tAsx0ei/85xk
X-Received: by 2002:a05:6a20:6a2b:b0:3e0:eae8:7525 with SMTP id adf61e73a8af0-3e22605a105mr9382056637.64.1792502451093;
        Tue, 20 Oct 2026 06:20:51 -0700 (PDT)
Received: from EAIT-H54D9Q2FJQ.eait.uq.edu.au ([130.102.10.249])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd654a0cf97sm4846882a12.24.2026.10.20.06.20.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 20 Oct 2026 06:20:50 -0700 (PDT)
From: Yu Zhang <yuz08559@gmail.com>
To: Mike Christie <michael.christie@oracle.com>,
	Dmitry Bogdanov <d.bogdanov@yadro.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yu Zhang <yuz08559@gmail.com>
Subject: [BUG] scsi: target: iscsi: Text/SendTargets command reuse -> NULL-ptr-deref / UAF in iscsit_build_sendtargets_response() (remote)
Date: Tue, 20 Oct 2026 23:20:43 +1000
Message-ID: <20261020132043.99594-1-yuz08559@gmail.com>
X-Mailer: git-send-email 2.55.0
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

A remote iSCSI initiator can crash the target (NULL pointer dereference in the
TX thread) by sending two Text PDUs that reuse one ITT.  The same reuse also
yields a use-after-free and conn_cmd_list corruption.  Everything below is
against current mainline (drivers/target/iscsi/iscsi_target.c); the paths are
unchanged from v6.x.

Root cause
----------
The ISCSI_OP_TEXT dispatch, for a Text PDU whose TTT != 0xFFFFFFFF, looks up an
*existing* command by ITT with no state check:

	case ISCSI_OP_TEXT:
		if (hdr->ttt != cpu_to_be32(0xFFFFFFFF)) {
			cmd = iscsit_find_cmd_from_itt(conn, hdr->itt);
			if (!cmd)
				goto reject;
		} else {
			cmd = iscsit_allocate_cmd(conn, TASK_INTERRUPTIBLE);
			...
		}
		ret = iscsit_handle_text_cmd(conn, cmd, buf);

iscsit_find_cmd_from_itt() returns any command on conn_cmd_list with a matching
init_task_tag, regardless of its state.  A SendTargets command stays on
conn_cmd_list after its response has been sent (i_state ISTATE_SENT_STATUS); it
is freed only once the initiator's ExpStatSN acknowledges it
(iscsit_ack_from_expstatsn()).  So an initiator that does not acknowledge it can
hand the same command back for reprocessing.

iscsit_setup_text_cmd() then frees the text buffer and clears the pointer, but
leaves the previously set ICF_SENDTARGETS_SINGLE flag on the command:

	kfree(cmd->text_in_ptr);
	cmd->text_in_ptr	= NULL;

iscsit_process_text_cmd(), seeing a NULL text buffer and a non-default TTT, takes
the empty-continuation path and re-executes the command:

	unsigned char *text_in = cmd->text_in_ptr, *text_ptr;
	if (!text_in) {
		cmd->targ_xfer_tag = be32_to_cpu(hdr->ttt);
		if (cmd->targ_xfer_tag == 0xFFFFFFFF) {
			...
			goto reject;
		}
		goto empty_sendtargets;
	}

On the TX thread iscsit_build_sendtargets_response() then dereferences the NULL
text buffer, because ICF_SENDTARGETS_SINGLE is still set:

	unsigned char *text_in = cmd->text_in_ptr, *text_ptr = NULL;
	...
	if (cmd->cmd_flags & ICF_SENDTARGETS_SINGLE) {
		text_ptr = strchr(text_in, '=');	/* text_in == NULL */
		if (!text_ptr) {			/* checked too late */
			...
		}

strchr() dereferences the NULL pointer before the !text_ptr check can run.

Note that LIO never assigns a target transfer tag for Text (it always sets
cmd->targ_xfer_tag = 0xFFFFFFFF in iscsit_setup_text_cmd() and rejects
multi-sequence Text in the same function), so a well-behaved initiator never
sends a Text PDU with TTT != 0xFFFFFFFF; the reuse path is only reachable by a
hostile/buggy initiator.

Reproduced
----------
KASAN kernel, demo-mode LIO iSCSI target on loopback (authentication=0,
generate_node_acls=1), iblock backstore.  A custom initiator logs in to Full
Feature Phase (normal session), then sends two immediate Text PDUs:

  PDU #1: F=1, ITT=0xaabbccdd, TTT=0xFFFFFFFF, data "SendTargets=iqn.<x>"
          -> allocates the command, sets ICF_SENDTARGETS_SINGLE, links it on
             conn_cmd_list (harmless, normal SendTargets response is sent).
  PDU #2: F=1, ITT=0xaabbccdd, TTT=0x00000000, empty data, ExpStatSN not
          acknowledging PDU #1 -> finds the same command, frees text_in_ptr,
          re-executes it.

The target panics immediately:

  BUG: KASAN: null-ptr-deref in strchr+0x13/0x50
  Read of size 1 at addr 0000000000000000 by task iscsi_ttx/3430
  CPU: 0 ... 7.1.6
  Call Trace:
   strchr+0x13/0x50
   iscsit_build_sendtargets_response.constprop.0+0x18b/0x950
   iscsit_build_text_rsp+0x94/0x380
   iscsit_response_queue+0x3b3/0xd50
   iscsi_target_tx_thread+0x2b6/0x500
   kthread+0x211/0x270
   ret_from_fork+0x333/0x590
  BUG: kernel NULL pointer dereference, address: 0000000000000000
  Oops: 0000 [#1] SMP KASAN NOPTI
  RIP: 0010:strchr+0x13/0x50
  Kernel panic - not syncing: Fatal exception

Because SendTargets is how initiators perform discovery, and discovery sessions
are frequently unauthenticated, this is reachable by a remote peer that can open
a session to the portal; with panic_on_oops it is a remote crash.

Two further consequences of the same reuse (same root cause):
 - Use-after-free: if PDU #2 is pipelined while the TX thread is still walking
   g_tiqn_list for PDU #1, iscsit_setup_text_cmd()'s kfree(cmd->text_in_ptr)
   frees the "SendTargets=iqn..." buffer that iscsit_build_sendtargets_response()
   is reading -> KASAN use-after-free read.
 - conn_cmd_list corruption: if PDU #2 carries a non-empty "SendTargets=..."
   payload with the same ITT, iscsit_process_text_cmd() runs the unconditional
   list_add_tail(&cmd->i_conn_node, &conn->conn_cmd_list) on a command that is
   already linked.

Note for a fix
--------------
Guarding text_in before the strchr() in iscsit_build_sendtargets_response()
addresses only the NULL dereference; the use-after-free and the list corruption
come from reprocessing an already-processed/linked Text command and are not
covered by that guard.  A complete fix likely has to reject reuse of an existing
Text command via the TTT != 0xFFFFFFFF path (LIO never hands out a Text TTT, so
there is no legitimate continuation to honor).  Exact approach left to you.

Reported-by: Yu Zhang <yuz08559@gmail.com>
