Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792939422;
	b=eK6F1RI0Yr1z34PyUNlumQtkUIVrnQUuSK9Pca76GrGRcVqfZoHA48S7iMMoN1Dolc8E
	 yiqkzmBbgw3IsZjxb9qBQgcnqg79i2t8O5JG56SSTPGRZP4HGqTm07/AT0/3v8fi5rP2q
	 FXeWuAOHUndGyGiJNJO4RZE+3SDNEMHg4E8jcwrHdjxyYTx7Fy5FDs69C7sJizmfSqqV/
	 lfIa8anns4yIbn9VfN7fE7oLndNv59PteBsu8Z5RP89WvYZEIiq4u9QStTkPaVCEWvklG
	 Tf4KzFBHqOPNRxiiyzicfbvhbbixZRGKofBdwbpNFstTKeS3F1wKwEIr3aAsBbfzUHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792939422;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Subject:From:To:Cc:Date:References:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version;
	bh=10Wn98wCYjGze7UfrWdQv3o7MdZOhneadzomG6iUcnw=;
	b=wqD4tIIZWf2X4LmJmL0prBaz/9XVmOCX7uVadeIR5tV8XNn9tYm5E525DEmgTXxhwCmj
	 +Oaex1JY/Y3mJQqLBt//dWGNjndASIlAWjEwYoLX0yLva+K6iZx+GVzCX0O+XsHE7KLYs
	 4kcQwdqkmqgNrzebLJcd2CpJN1NfxIoXybcJizrlKlq3rH2dW961LjnDnBsGvl8ScAVIg
	 T2ItAhoGmAUH2y17qeOvhBpdV4fYgpp4kjCdP8jw+0IIPz6Y/P3n+ny31hqyC6DilamBA
	 x1egHIz50Xn+KPYvRUXVhSVsjAP/OSOaxbY3oKLF3g0WCMuad72gHdHJqVZiqA+tzuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=iSkvP56O;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=LZ6VZpXX;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D365D606A31A
	for <target-devel@vger.kernel.org>; Sun, 25 Oct 2026 14:43:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D365D606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=iSkvP56O;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=LZ6VZpXX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792939420;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=10Wn98wCYjGze7UfrWdQv3o7MdZOhneadzomG6iUcnw=;
	b=iSkvP56OB5I1M6u+7ChOCNdqySSgPXHBEQ0GMfvsD81Akm0XKgN6W/y/IbpAQ8Qlu3yJ85
	8YAIzdsNuCguQCOvBXSOBBLjujc1EbVZ+lUchFR3e8Hi6rMpJ/y9GfhAQmZNg3ggpZqBnY
	fkFHReA3ETsPSAj215S8/QAsLtyHcYY=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-537-5BYpseAaO62iMh9ePGgykw-1; Sun, 25 Oct 2026 10:43:39 -0400
X-MC-Unique: 5BYpseAaO62iMh9ePGgykw-1
X-Mimecast-MFC-AGG-ID: 5BYpseAaO62iMh9ePGgykw_1792939419
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-92e82060977so520197685a.1
        for <target-devel@vger.kernel.org>; Sun, 25 Oct 2026 07:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1792939419; x=1793544219; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :in-reply-to:references:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=10Wn98wCYjGze7UfrWdQv3o7MdZOhneadzomG6iUcnw=;
        b=LZ6VZpXXYJPBh7Eo/6JLPcahSa91lQyu+TLZsV1dIjIT0vyK1vwGSS0zpxKYXVPyJr
         tbZl8scZ9lgWeP4KaiOd2Dezc8ce3nNus+q/BZQpRcVDqBP2OlGTu3DdyhONKR9+xFPi
         L93vgLuv2MiT+W9eswMDd9LB/7SaCxnLp/SH2AKx+rjI9MYsPjbrBXUaAwi2UI5OHTMd
         Ywdxbw4SCFz2S7CU6orzFpaQZ8VApWSo6bZqadUj0hLbBhfZmYDOUs6xRWRqc1C1lIRf
         TxUDjcHkfLiyGyGcHY/pEWI1wFpeIMgxG6RgT9duyiPUQDmqvYzwZkUpi2Z8l0h1gzqx
         tcvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792939419; x=1793544219;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :in-reply-to:references:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=10Wn98wCYjGze7UfrWdQv3o7MdZOhneadzomG6iUcnw=;
        b=GWAm4xxF7OIWoUlV7fR5QfY6wTMCh9gKx9GVshFGK4SE7yORBpprPybPCrH3QixJdL
         222OMClLanwGLd+DNKyXVhgqUQ5qcn54keow3jcl9jFZDbI0AG99M1kLyirRPUpIusiv
         vNc0CmvlCns5NGoRU1KETiWgjFGBYEyCpaKuevPN9MmIXX4PlgEaRXxNrPVylJ7InCoO
         WBHCSIzpaH/AwXHi4zyFLe7nCKJCsqLub/rZXoEv9IB2Vwff/wZl8OqtNLb5XUKoPcXw
         VHkwJPLj3TCfQ4OkxyKvsciDq5kTc66o39TS98ndeIpJQX/gu0UiLl7Ur/6vqLoVe/qY
         EgeA==
X-Forwarded-Encrypted: i=1; AKwUvBxSt6i71a4VC5fhzpF0hsPirxqdaB6lIbZMXk+5Fl1guHUJidVGwpEL9jBC6VCBHBYvdn8n4levqPLyYPs=@vger.kernel.org
X-Gm-Message-State: AFq9FYJ/D2qOlu2NxfgCrm5qluw97OuzVDXVUIUh5BjDPSuKX/tws+rt
	CQoMHy8drnTUzcxZjtG/c5v5yH7Q/9lxtcxwQocDGjkGTYgiYROtFeNxAZM6Ngtz1uE5XpNVOCw
	okLQ91N5R14IKg2KYRblwMp4y8lxne4JM+vvY3zhP9gCXeiU3Xr33PuAA+Ia362qZQw==
X-Gm-Gg: AYBFou0oHDRN98M1dyUhVFagzk4V07Yc0PcSEjFef1o/2QJM4n5LZsfPHNVMW3FfQ1C
	7itdWH80+l98ltMollVu/K+wR4zGD90hJvvwRuf9kR1HVGsm3wIDFPkrxV9h42hL/9GA1WavM9z
	64j64miF6kiCwHDVYNAS7EOqY5LUaqdgh8FPYMLRiiURPqVgRlF2/k/9TLUpVXRPCNUwQ0n1eoE
	qW6jnOlxLueiSkgM05nPqvQUhIIoD7tmEghsKGx8iJjzFtdMQPsp3z4BDDHw4PlgbEYgah8xSTR
	hR80WxQghGJ4XombQ+ZQMR4UG5SZRzg7+u8nIRpP9L2ADECLbx/Kphqngp3SHfVCfJ+IEVs5XIA
	dFMBZT7BIAiURRm40Bp9k3K8x7IV+WjFqfOI4A5OiJvsDMc28KmWvk4lyPr5NX/83XLp63k9AEG
	vXBvpefX5Z7qSHrbKI4H1s
X-Received: by 2002:a05:620a:4543:b0:93f:21db:851a with SMTP id af79cd13be357-940ef9f050fmr591914285a.40.1792939418664;
        Sun, 25 Oct 2026 07:43:38 -0700 (PDT)
X-Received: by 2002:a05:620a:4543:b0:93f:21db:851a with SMTP id af79cd13be357-940ef9f050fmr591911985a.40.1792939418182;
        Sun, 25 Oct 2026 07:43:38 -0700 (PDT)
Received: from loberman-thinkpadp1gen5.rmtusma.csb ([2600:6c65:2440:d8c:929c:b769:6def:faa3])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-940f0669112sm436834785a.10.2026.10.25.07.43.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 07:43:37 -0700 (PDT)
Message-ID: <60cf407142a0663a811a2ccd64cf387cb71808ab.camel@redhat.com>
Subject: Re: [PATCH v2 0/2] scsi: target: iscsi: fix stalled aborted WRITE
 commands
From: Laurence Oberman <loberman@redhat.com>
To: mkp@kernel.org
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	mlombard@redhat.com, michael.christie@oracle.com,
 linux-kernel@vger.kernel.org
Date: Sun, 25 Oct 2026 10:43:35 -0400
References: <20261016175351.126373-1-loberman@redhat.com>
In-Reply-To: <20261016175351.126373-1-loberman@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Post: <mailto:target-devel@vger.kernel.org>
List-Help: <mailto:target-devel+help@vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:target-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Fri, 2026-10-16 at 13:53 -0400, Laurence Oberman wrote:
> > These two patches apply on top of=20
> > commit d5869dae5080 ("scsi: target: iscsi: Fix hang for aborted
> > WRITE_PENDING commands").
> >=20
> > A WRITE command that is still in TRANSPORT_WRITE_PENDING has never
> > been
> > passed to the backend, so when a TMR aborts it the iSCSI fabric is
> > the one
> > that has to complete it. That commit fixed the case where the final
> > DataOut PDU for an already-issued R2T arrives after the abort. Two
> > more
> > paths can leave such a command with nothing to complete it:
> >=20
> > =C2=A0- Patch 1 is the hang this work started from. A WRITE that arrive=
s
> > with
> > =C2=A0=C2=A0 immediate data, aborted after that data has been received =
but
> > before
> > =C2=A0=C2=A0 the first R2T is built, is never completed by anything: no=
 R2T
> has
> > been
> > =C2=A0=C2=A0 sent so the initiator cannot send more data, and no DataOu=
t
> timer
> > is
> > =C2=A0=C2=A0 armed so the ERL=3D0 timeout cannot fire either.
> > core_tmr_lun_reset()
> > =C2=A0=C2=A0 then blocks for as long as the connection stays up.
> >=20
> > =C2=A0- Patch 2 closes the equivalent window where a new R2T would have
> > been
> > =C2=A0=C2=A0 sent for an already-aborted command.
> >=20
> > Patch 1 also adds a one-shot completion claim. Completing the
> command
> > in
> > iscsit_execute_cmd() introduces a second site which
> > iscsit_release_commands_from_conn() would also complete during
> > connection
> > teardown, because t_state is still TRANSPORT_WRITE_PENDING there
> and
> > target_complete_cmd() on an aborted command records nothing that
> > would say
> > otherwise. The claim makes sure only one of them does it.
> >=20
> > Changes since v1:
> > =C2=A0- Patch 2: route the DATAOUT_SEND_R2T completion through
> > =C2=A0=C2=A0 iscsit_complete_aborted_cmd() rather than calling
> > target_complete_cmd()
> > =C2=A0=C2=A0 directly, so the completion is claimed and cannot be repea=
ted by
> > =C2=A0=C2=A0 iscsit_release_commands_from_conn() during connection tear=
down.
> > =C2=A0- Patch 1 unchanged.
> >=20
> > v1:=20
> >
> https://lore.kernel.org/linux-scsi/20261014143932.39453-1-loberman@redhat=
.com/
> >=20
> > How this was found and tested:
> >=20
> > The hang was reported against an Oracle RAC cluster on two-session
> > iSCSI
> > LIO targets, where one node's LUN_RESET aborts WRITEs belonging to
> > the
> > other node's session. It was not reproducible in a lab, so the
> > diagnosis
> > came from instrumented kernels in the reporter's environment,
> logging
> > every
> > site that completes or waits on an aborted command.
> >=20
> > Across two hosts every stall had the identical signature given in
> > patch 1,
> > and the stall only ever ended when the initiator gave up and
> dropped
> > the
> > connection. 217 of 222 LUN_RESET drains completed in under a
> second;
> > the
> > rest took 46 to 54 seconds, which is where the hung-task panics
> came
> > from.
> > One 53.7 second stall recovered on its own and the host ran for a
> > further
> > 19 hours.
> >=20
> > Both patches, backported to a 5.14-based distro kernel, have since
> > run 300
> > reset cycles with no hang, in two independent runs: one
> instrumented
> > and
> > one with the tracing removed. The same reproducer previously failed
> > at 95
> > and 196 cycles. The code here is equivalent to what was tested;
> only
> > comments differ.
> >=20
> > One thing to flag for review: patch 2's window was never observed.
> > The
> > instrumented kernels recorded no completions at that site in either
> > run,
> > and the reproducer never reached it. It is included because the
> same
> > reasoning applies there, but it has no field evidence behind it,
> and
> > I am
> > happy to drop it or send it separately if you would prefer.
> >=20
> > An earlier attempt at this fix completed the command from
> > core_tmr_drain_state_list() instead. That is not safe: at that
> point
> > the
> > initiator may still be sending DataOut for the command, and the
> > result was
> > a double completion -- re-queued se_cmd->work, list_del corruption
> > and a
> > refcount underflow. Mentioning it in case the same idea comes up in
> > review.
> >=20
> > Laurence Oberman (2):
> > =C2=A0 scsi: target: iscsi: Complete an aborted WRITE stuck before the
> > first
> > =C2=A0=C2=A0=C2=A0 R2T
> > =C2=A0 scsi: target: iscsi: Complete an aborted WRITE when a new R2T
> would
> > be
> > =C2=A0=C2=A0=C2=A0 sent
> >=20
> > =C2=A0drivers/target/iscsi/iscsi_target.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 | 28 +++++++++++++--
> > =C2=A0drivers/target/iscsi/iscsi_target_erl1.c | 10 +++++-
> > =C2=A0drivers/target/iscsi/iscsi_target_util.c | 46
> > ++++++++++++++++++++++++
> > =C2=A0drivers/target/iscsi/iscsi_target_util.h |=C2=A0 2 ++
> > =C2=A0include/target/iscsi/iscsi_target_core.h |=C2=A0 5 +++
> > =C2=A05 files changed, 88 insertions(+), 3 deletions(-)


Gentle ping:
If anybody has bandwidth to review the v2 in this series which also
handled the sashiko concerns.=C2=A0
We have customers waiting on this series.=C2=A0

=C2=A0As always much appreciated=C2=A0
=C2=A0Laurence Oberman

