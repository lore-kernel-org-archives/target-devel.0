Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793022128;
	b=349Ml5GiHoXcmk0lTNPglXClWhq1PbwCyt9OTbg6G+xPHci8ZAnQpBlagUjtCcutW79J
	 MuZh+QeZH4nuU2E7NllOUCNJ8ycWnoNl1Ag1AR7bkuVQ9vAHk/pEJQXGX3FRRp+Od6Va+
	 wBQuRftVrefLmzVw751kPO9kMA926HsSPgQqbsehmUeWPZ2v70kbR5/ALow497PbK64kK
	 Qz9jWA6qpsV7tGYPxz4INSu8dVdeic/FCFqtu/CUV/NXNHC4w8/5oUjQt12XWMxqmFIKv
	 APo6mOWIgyO1xYETS/vHRnT13/QhLBvzZe9Vf7g1Y+EX+Sls4XjWnGV73hgZprkfFBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793022128;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version;
	bh=ed+PX3IGkbk+mTJa3PsZsNtkAoyqu1J1xwHAA2Xtd+g=;
	b=zuQgTRgur6ip3AeFq1vQ/CmmAnTZPYbFRRN5/OkQ37z25mkw/yvot9ef33mBaMTHTIPk
	 6X6S+FjJ5D95Kh26ItMFg/B4B0aEd6jFNOJ6dNnntx9SDPCWdYPsW8v5TzC7wA1nEe7yY
	 uWK1JQf3TlNIpauWHfIWfmXlfkyw7sC5p5u78D+Kw3tfanSITmMNBMtjABtvo0aG/NKJc
	 tmbvpu4r0niVHrEt8AFAZB7/lUBc7ryhDO+MhjdIseIkGxiz7n78Ido6pxs3wRfxo4MSn
	 5Ee6dzC9zVAfOTZeHXC/3fxkkQMaLSAn9c//kt7kU6MyV04LE0VR9WdqA7Ax5npq3og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=DuCB7E9I;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=G7ZTZeYQ;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673BC606A31D
	for <target-devel@vger.kernel.org>; Mon, 26 Oct 2026 13:42:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 673BC606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=DuCB7E9I;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=G7ZTZeYQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793022126;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ed+PX3IGkbk+mTJa3PsZsNtkAoyqu1J1xwHAA2Xtd+g=;
	b=DuCB7E9IIlpWmNJhC2RX1Pb/+Queovc3QgbjBnG/i9m2yAq4OOy3RdrUDUYVZBLb2YlPtK
	FEgRTGbjQ32c8EgFG6POCI6MTkROXIoV/pcSYSdIjKtjxMhrRniyRDQdi/fcL+fKItpqBy
	c8UJ26bwyEVrLuN+fmiLdmMAz0wTyR8=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-358-jajuq2gxOj-ljypXJeVhdw-1; Mon, 26 Oct 2026 09:42:04 -0400
X-MC-Unique: jajuq2gxOj-ljypXJeVhdw-1
X-Mimecast-MFC-AGG-ID: jajuq2gxOj-ljypXJeVhdw_1793022124
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-5365d95f4a1so55205181cf.1
        for <target-devel@vger.kernel.org>; Mon, 26 Oct 2026 06:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793022124; x=1793626924; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=ed+PX3IGkbk+mTJa3PsZsNtkAoyqu1J1xwHAA2Xtd+g=;
        b=G7ZTZeYQJYorU01gUtWuu+yTEdSH3kcBwNtL8ucR/cmmnfyzWMQrm/efjcpAJEV0F0
         rZUvLImHohR5jD4cvr76unwT8PKCslUhpqcYKMXPf/TKhGtox6nBr0M6m/053PzcTvnA
         Dv4gB5XNeUW4WDB0Q7W1CMMPTBVKRZBVv80H08PsePwZn6voLNoBVH3Db1czWK4GFXeF
         hsUtIzuYCXFYjBTvmhT+5ABjhRMZDlDUsC9535Bb5k5yhZC8wCPkO1HrnOYIYcvhagbt
         hyYijZyTq4K6SQMCkHnG3+l2OpV7GsiyZ6SdTsIzj6Y+r6e41mx5JzKATcXC68smlWhQ
         b7UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793022124; x=1793626924;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ed+PX3IGkbk+mTJa3PsZsNtkAoyqu1J1xwHAA2Xtd+g=;
        b=mupvB0cCJYOKivRH9TIB/jzlh2X/0FZKRr3y+yza32aLZMy5788WwmD3AXtAa9qbZp
         xeGbAl2MfN/K/lZqTwkXrMoa0S9cb/tt7jdn2zGyso1Mm8aFXZGzqPwlgvpIo7FWLOtP
         l4PM5H40KSZbHtlRgV7m4iKDOnNS7B8rwWOrDaRdOG5cYoV/UZs0s5i6Cq8hVsrWwZa+
         e4apNMjVxM3WkEW7Gf4YAljftaCULTkdMMVk+ZkTKeS0kJXnQ+S6NgoSJjvI4A+2ttND
         I/Aq/2/9kVD5JWmWoOy5bN4keDLk64IXDxr4CWFUZEmQD8Yz+sFpWiyBZM+rBZJun2Q3
         cDgw==
X-Forwarded-Encrypted: i=1; AKwUvBx4Tmud/LnNOXBReq0aK+FTLD+aJux+n7kHevOHQhyH3d9Q1PSRV2/BBL7xRJmssNvu6KptBoelutSIFQw=@vger.kernel.org
X-Gm-Message-State: AFq9FYJG1BHWLrhGe41uM5CD2KAOEvAuQk+QurN6YetOYFyX4XMUSRKp
	VtUKCHBlIeMK1vT66ke8FrFeJ3qwdFpxkFkNmMtoO8bq9bgvzkb+myIOmO9WCx8IL5qOE8FiCpW
	sXoh+ag0AMpVHAzokzIuTCbF62v8Xudkg/lSmmcNAhggFSoH27K82+QpXq0d/ETuhNw==
X-Gm-Gg: AYBFou0wLqg6zHCWjiRv1pHaGQtCI/BwiNW2cFSIWAtOnLNP/YiJPfTU2bmwB0oRFnm
	MYIvdPyFOlX86gGmCGeNqr86TR3o9bZg043dv+0Z163FCoe8qk2xk6q1CDz600MbBx8gLUEXof7
	4xXnbMJ/tW5InOn/JxmA9hSSqe1RSckHMsdZn/KVG5s0TUX6eEGL1UoMgqVQ9ZQqlxGbxItrcSi
	gnF//n09dd2ICrYdaOtBXDGKnz8S8vOpTs+qxVlgsk42EgS0lspImgJQkSpZB/tNV/P2Y5CjXzp
	JAuT4/8J3w7gc27Q7bDAWEi4w/VaJrW/CW+dBmZSaXgLjzg3KtGQz9Oi6TSk+wAvAyaDKausrvb
	tVzIRft0/blqjcmqf32Mi3ufR0WGjGpeVLlMtHkluhOT8pGKzulZmh4zaN6WkP2i59tlHlFjtJp
	aqZyQGNvTYlUzQofDe66h8gA==
X-Received: by 2002:a05:622a:5b0d:b0:536:575b:8dd6 with SMTP id d75a77b69052e-5383af13431mr89884431cf.0.1793022124178;
        Mon, 26 Oct 2026 06:42:04 -0700 (PDT)
X-Received: by 2002:a05:622a:5b0d:b0:536:575b:8dd6 with SMTP id d75a77b69052e-5383af13431mr89883771cf.0.1793022123494;
        Mon, 26 Oct 2026 06:42:03 -0700 (PDT)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:aa2b:ddff:fe88:da74])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c47c53fdcsm72863586d6.27.2026.10.26.06.42.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 06:42:02 -0700 (PDT)
Message-ID: <3e2a63af147ce884e84cd3aee1e456051265d7bc.camel@redhat.com>
Subject: Re: [PATCH v3 2/4] scsi: target: iscsi: Complete an aborted WRITE
 when a new R2T would be sent
From: Laurence Oberman <loberman@redhat.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Date: Mon, 26 Oct 2026 09:42:02 -0400
In-Reply-To: <sashiko-outbox-185289@kernel.org>
References: <20261026124344.745124-1-loberman@redhat.com>
	 <20261026124344.745124-3-loberman@redhat.com>
	 <sashiko-outbox-185289@kernel.org>
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

On Mon, 2026-10-26 at 13:13 +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider:
> - [Critical] scsi: target: iscsi: UAF of OOO cmd in
> iscsit_check_dataout_payload()
> --
>=20
> commit 93e4d74df05b6ac07e171f5586d09d2036dc2494
> Author: Laurence Oberman <loberman@redhat.com>
>=20
> scsi: target: iscsi: Complete an aborted WRITE when a new R2T would
> be sent
>=20
> This commit completes an aborted WRITE command via
> iscsit_complete_aborted_cmd() in iscsit_check_dataout_payload() when
> iscsit_check_post_dataout() returns DATAOUT_SEND_R2T and no
> outstanding R2Ts
> remain.
>=20
> > diff --git a/drivers/target/iscsi/iscsi_target.c
> > b/drivers/target/iscsi/iscsi_target.c
> > index aab9237a67768..3dad7f69f3bae 100644
> > --- a/drivers/target/iscsi/iscsi_target.c
> > +++ b/drivers/target/iscsi/iscsi_target.c
> > @@ -1669,6 +1669,22 @@ iscsit_check_dataout_payload(struct
> > iscsit_cmd *cmd, struct iscsi_data *hdr,
> > =C2=A0	if ((rc =3D=3D DATAOUT_NORMAL) || (rc =3D=3D
> > DATAOUT_WITHIN_COMMAND_RECOVERY))
> > =C2=A0		return 0;
> > =C2=A0	else if (rc =3D=3D DATAOUT_SEND_R2T) {
> > +		/*
> > +		 * A new R2T would never be answered for an
> > aborted command.
> > +		 * The CMD_T_ABORTED handling in
> > __iscsit_check_dataout_hdr()
> > +		 * does not cover this: it only runs for DataOut
> > PDUs
> > +		 * belonging to R2Ts that were already issued, and
> > +		 * iscsit_dataout_update_r2t() has already
> > decremented
> > +		 * outstanding_r2ts for the burst that just
> > finished.=C2=A0 Guard
> > +		 * on outstanding_r2ts so that with
> > MaxOutstandingR2T > 1 the
> > +		 * completion is still left to the last R2T to
> > drain.
> > +		 */
> > +		if (cmd->se_cmd.transport_state & CMD_T_ABORTED) {
> > +			if (cmd->outstanding_r2ts < 1)
> > +				iscsit_complete_aborted_cmd(cmd);
> > +			return 0;
> > +		}
>=20
> [Severity: Critical]
> Can completing the command here cause a use-after-free of cmd if
> ICF_OOO_CMDSN is set?
>=20
> When ImmediateData=3DYes and InitialR2T=3DNo, a WRITE command can arrive
> with
> immediate data and expect additional unsolicited DataOut PDUs in the
> first
> burst followed by R2T-solicited data (payload_length <
> FirstBurstLength <
> se_cmd.data_length, so cmd->unsolicited_data =3D=3D 1 and
> ICF_NON_IMMEDIATE_UNSOLICITED_DATA is set).
>=20
> In drivers/target/iscsi/iscsi_target.c:iscsit_process_scsi_cmd(),
> transport_generic_new_cmd(&cmd->se_cmd) is called before CmdSN
> sequencing:
>=20
> 	cmd->sense_reason =3D transport_generic_new_cmd(&cmd->se_cmd);
> 	if (cmd->sense_reason)
> 		return 1;
>=20
> This places cmd->se_cmd on dev->queues[cpuid].state_list in
> TRANSPORT_WRITE_PENDING. When iscsit_get_immediate_data()
> subsequently calls
> iscsit_sequence_cmd() and cmd->cmd_sn > sess->exp_cmd_sn,
> drivers/target/iscsi/iscsi_target_erl1.c:iscsit_handle_ooo_cmdsn()
> queues
> an entry on sess->sess_ooo_cmdsn_list holding a raw pointer to cmd:
>=20
> 	cmd->cmd_flags			|=3D ICF_OOO_CMDSN;
> 	...
> 	ooo_cmdsn->cmd			=3D cmd;
>=20
> Because cmd->unsolicited_data is set, iscsit_get_immediate_data()
> then calls
> iscsit_set_unsolicited_dataout(cmd).
>=20
> If a concurrent TMR aborts cmd while it is still waiting on
> sess->sess_ooo_cmdsn_list, __target_check_io_state() sets
> CMD_T_ABORTED on
> cmd->se_cmd. When the final unsolicited DataOut PDU of the first
> burst
> arrives, __iscsit_check_dataout_hdr() takes the cmd->unsolicited_data
> =3D=3D 1
> path, and iscsit_dataout_post_crc_passed() clears cmd-
> >unsolicited_data =3D 0
> and returns DATAOUT_SEND_R2T.
>=20
> In this new DATAOUT_SEND_R2T branch in
> iscsit_check_dataout_payload(),
> cmd->outstanding_r2ts is 0, so iscsit_complete_aborted_cmd(cmd) is
> called
> without checking ICF_OOO_CMDSN or removing cmd from
> sess->sess_ooo_cmdsn_list (unlike the adjacent
> DATAOUT_SEND_TO_TRANSPORT
> branch, which checks cmd->cmd_flags & ICF_OOO_CMDSN).
>=20
> Once target_complete_cmd() schedules target_abort_work ->
> target_handle_abort(), cmd is completed and freed via
> iscsit_release_cmd().
> When the missing ExpCmdSN PDU later arrives,
> drivers/target/iscsi/iscsi_target_erl1.c:iscsit_execute_ooo_cmdsns()
> will
> dereference the dangling ooo_cmdsn->cmd pointer:
>=20
> 		cmd =3D ooo_cmdsn->cmd;
> 		cmd->i_state =3D cmd->deferred_i_state;
> 		ooo_count++;
> 		sess->exp_cmd_sn++;
> 		...
> 		iscsit_remove_ooo_cmdsn(sess, ooo_cmdsn);
>=20
> 		if (iscsit_execute_cmd(cmd, 1) < 0)
> 			return -1;
>=20
> Should the DATAOUT_SEND_R2T abort path also account for commands with
> ICF_OOO_CMDSN set before completing cmd?

I will drop patch 2 for this series as this turns out out be a real
issue and follow up with a v4 for the series. Dropping patch 2 will not
affect the validity of the fix with the over 300 reset loop tests we
ran which resolved the original customer issue.

Sashiko complaints for patches 1 and 4 are pre-existing and wont be
handled in this series.

It has taken many weeks to get to stable outcome for a customer that
included multiple long vmcore analysis tasks and instrumentation.


Thanks
Laurence

