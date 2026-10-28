Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793197843;
	b=tgwkkbDCIOINXTuBXudlucf3LKFQcZxVYB2zkOYrjzYAwO2OEQYloEN1KPmE9DBXEb7K
	 LXT/07ylwx2ValEN8U0TBevUqwK5kK2jnRxAThb9Y30RYWxBlNfhnU4Unx+HgQbFmPZQy
	 JTiIr2Z+/YpY+KDcDn+2VdF+TJnYyg1n6Y40brV0kH4/l+CD9EOXSdlVreeI0KMtK/wjz
	 SBKM0XMCbwfRZNwqwro2ZSGjDvsicrSjp350d7GYTb78ZgktWlWAcj4F07Kben8aoVyKc
	 8fiOdO0HzWgED6iBFNM0Bu5dWOdxxTdbkgTNgDJg+nM8LD2NkMCZ9jSmOF9d/nRSU8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793197843;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version;
	bh=Sv/iTPs4xlWjnrYC4tMYxP+iSSAMw3Kx4oBZaMa50nw=;
	b=RNd7U06gDImBjxXi3VSFogODCFZIofYtkQN0MbF/q3pJEw9f4LO3edJacEk/qkTUO49X
	 LEdSIJW0fmQfuZh5uV8Ge3uAPOd6y/C2QBNFCKsHX6TOc7xy7leODJ/fr1jbNgBPtgCIT
	 eKyNazGLpYIm3Sj5vLOp+IkAVhWkVSxPesspAALogxpF59dZpvEOyJ4xPRCb/Y+OaLQPD
	 uKKmvXlMPKgrhULvaJwx3ZCHnR1phY4Mg5gLSkzAkCUx0VVBbg9L0xtT5NsF1lJ9gWnNk
	 hfz4f3AkAWrv2i8g71hESOfR5QE7zqRsIzBfxNdJsO/GsUhUw5iAK5AAexDpw3JijtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=aQHn9TsG;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=n+C9b9sE;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF8F606A31F
	for <target-devel@vger.kernel.org>; Wed, 28 Oct 2026 14:30:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6CF8F606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=aQHn9TsG;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=n+C9b9sE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793197841;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Sv/iTPs4xlWjnrYC4tMYxP+iSSAMw3Kx4oBZaMa50nw=;
	b=aQHn9TsGrEXCmBUPbz4ruTyirrH9FDL2gRRhTHwGAQN8dR/NOig76SneA0HsnepVfp/Kvy
	lASwuFtqOVmqwAewDwKxiGdtxHaAVwM1JRMRrB92D5/PY3WLZVKM34O2A6IFepE7rDxtcd
	ixVPSCxshWxHzup52oNKIJMhi+OSLIg=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-690-F4_GMXaLNEyNkg6hofhbTA-1; Wed, 28 Oct 2026 10:30:40 -0400
X-MC-Unique: F4_GMXaLNEyNkg6hofhbTA-1
X-Mimecast-MFC-AGG-ID: F4_GMXaLNEyNkg6hofhbTA_1793197840
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-9197553d398so25409196d6.1
        for <target-devel@vger.kernel.org>; Wed, 28 Oct 2026 07:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793197840; x=1793802640; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Sv/iTPs4xlWjnrYC4tMYxP+iSSAMw3Kx4oBZaMa50nw=;
        b=n+C9b9sEa3XjHzF2sXvkteJo1Vssemo5MeFCwhFzxSO4nBMtAK4G/dNt0UR6l73e02
         g7NQGUDWSuCQ2nSwMkdlWC9rT5rjsOF9AvTT6a6fFMFcDqC2OkdYsQEE39WBLxNQufnE
         R9ZnctroVLrZaNrlVG2QmGMbeX/N8jXehRZGfP8UdK0rCEFhxK9p8BTZvioq2zhnoMWy
         B5EMaDxYBSE0egWwwRhfYGfcv3z6LxDGuaiTsic0/oLS36jIB+vDFsxWosuK4/hOcFMk
         Xgy+stfS5oa4cWfi6pbWVuDmDnuF/KkWfUFC6dzI1lCCpjt92eNw5WdOx1hw6Zje8miJ
         egfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793197840; x=1793802640;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Sv/iTPs4xlWjnrYC4tMYxP+iSSAMw3Kx4oBZaMa50nw=;
        b=L7QU822SBOQNkyiMy56PJmjg8+HYvL7WETHFqmnrtEMrOsvjuKcod3mMsAhbb2Uzre
         O8R7i50x7RLTdkMkzzbZ6QWQUomphxwufVYKpjHspJKOBBm392zo8SwOWgM62XflVq0t
         74SBlMtm+vyxPdl0xsDYuxGhx1bGsX4G/Ug+6sFOnyZDd/HJc06MgNFDUjSFmUbqhmVi
         LKJmdd0LbcU+D1XIXKB/icPpHIDK/ziodQTS72FL8vENNz223rUuI/JfMVF9/8LGZTgf
         pfCc9RnnhCAmZRqDBVO0yxlnn17SUCV+KRkQvI718NUN/Bwj5uMs13EWilMwnvHm/+N5
         isww==
X-Forwarded-Encrypted: i=1; AKwUvBzRvie4vdXVkoUAb70jkED415bMjfXPJISRZ0nCeiP6SkgiOS3zNZPMdFgXPAyluYALsrnrZ+rDFFUQ1BI=@vger.kernel.org
X-Gm-Message-State: AFq9FYIb5fzapNqwVRJUwf0YyW51r+AD0iVkf2xQt1JOB+krRQPxt4AU
	JyuB31/35c2uMJQkLmGP6ahHePtZwq+BPHAgMr3tox8+54fk8MpOrcIbQ9jzTiGRiPLYwch3n+5
	t04U+bvuW49pGfEXAHmc07LrtRiMYUF2asaE4ILfTTxeoOOMrGQWM+tPAnjRBO/I2pA==
X-Gm-Gg: AYBFou2V46Jl5E13g1G/4VOdh/W4bb7YLmuLHRRRJIGRJpsynCQc23cdv/45XgrwIRp
	0Xf6UyqtivUBF/30gkJlNgjv3e2KwMk1BA94uR9Sdn91CjOI4QHhsIJNqFAazaJfgKXBSEkATf3
	UCapj6o/23N6uLv+E11MGZrmx/JyHp57WHJFGQY9oWXRE2B4/4J+qH6LTAasVCo5xY2GGpPplkk
	ysUskeKmEEODxE/hjcZsANNfxcCy4UR+C+Ei2XbJHQIRUTnQZxveNBtnGot++y07slsayZQ+rX/
	Cv63jHHhQQox170EJJGg7uKRr4vp+yXfd2n9fcciG/ngvSIapxVDfgDWHArjR8+Z3dbh5MWxdEx
	FNO1Z5epn8dnLqr1b0CJ/TXonDToLV8wI7ykBVyRpVCIsmwxrJVBwv9V+8ZHdO4aSLjrrBO3Ibk
	uS1EeP5Y0zX3lbf5LaERpMz8yOOzk7Z+meMhlPdQ3sF8Et9mbQxkxQxNT8zqFlEvZL5Z2eIPo=
X-Received: by 2002:a05:6214:450c:b0:91b:ec1d:1746 with SMTP id 6a1803df08f44-91c7d216835mr39651766d6.55.1793197839251;
        Wed, 28 Oct 2026 07:30:39 -0700 (PDT)
X-Received: by 2002:a05:6214:450c:b0:91b:ec1d:1746 with SMTP id 6a1803df08f44-91c7d216835mr39650396d6.55.1793197838400;
        Wed, 28 Oct 2026 07:30:38 -0700 (PDT)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:aa2b:ddff:fe88:da74])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c47a6d598sm131076236d6.3.2026.10.28.07.30.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 07:30:37 -0700 (PDT)
Message-ID: <f4cbbca9e8b743da07902e97b09e49ac7e1cc5fb.camel@redhat.com>
Subject: Re: [PATCH 0/2] target: iscsi: fix hanged WRITE_PENDING commands
From: Laurence Oberman <loberman@redhat.com>
To: Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc: Martin Petersen <martin.petersen@oracle.com>, Maurizio Lombardi
	 <mlombard@redhat.com>, target-devel@vger.kernel.org, 
	michael.christie@oracle.com, linux-scsi@vger.kernel.org, linux@yadro.com
Date: Wed, 28 Oct 2026 10:30:36 -0400
In-Reply-To: <20261028140221.GB32229@yadro.com>
References: <20261027180123.13163-1-d.bogdanov@yadro.com>
	 <d7a1701ddc2e7c976ad8ff9ec071d9bfdc86a7e2.camel@redhat.com>
	 <20261028140221.GB32229@yadro.com>
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

On Wed, 2026-10-28 at 17:02 +0300, Dmitry Bogdanov wrote:
> Hi Laurence,
>=20
> On Tue, Oct 27, 2026 at 04:08:08PM -0400, Laurence Oberman wrote:
> >=20
> > On Tue, 2026-10-27 at 21:01 +0300, Dmitry Bogdanov wrote:
> > > ISCSI has some old leftovers in the code that prevents passing
> > > the
> > > aborted
> > > command to the target core to make the actual abort. Such
> > > commands
> > > hang
> > > until connection is closed.
> > > So remove those leftovers.
> > >=20
> > > Dmitry Bogdanov (2):
> > > =C2=A0 Revert "scsi: target: iscsi: Fix hang for aborted WRITE_PENDIN=
G
> > > =C2=A0=C2=A0=C2=A0 commands"
> > > =C2=A0 scsi: target: iscsi: fix hanging WRITE_PENDING commands
> > >=20
> > > =C2=A0drivers/target/iscsi/iscsi_target.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 | 19 ------------------
> > > -
> > > =C2=A0drivers/target/iscsi/iscsi_target_erl1.c |=C2=A0 8 --------
> > > =C2=A02 files changed, 27 deletions(-)
> >=20
> > Hello Dmitri
> > Thanks for posting this. I have a series in flight for the same
> > hang:
> >=20
> > https://lore.kernel.org/linux-scsi/20261027122837.2148074-1-loberman@re=
dhat.com/
>=20
> I know, that is why both you and Maurizio in To: field. I want from
> you some comments. Thank you for review.
>=20
> >=20
> > Is the revert maybe aimed at the wrong layer, and the sashiko
> > review of
> > your 2/2 makes the case better than I can: with the fabric check
> > removed, an aborted command reaches target_execute_cmd(),
> > target_cmd_interrupted() queues target_abort_work and returns
> > without
> > changing t_state, the command stays on conn_cmd_list in
> > TRANSPORT_WRITE_PENDING, and iscsit_release_commands_from_conn()
> > completes it a second time if the connection closes.
>=20
> As I said in response to sashiko-bot, that is the current (always be)
> behavior.
> It is not introduced by my patch.
>=20
> > That is the same double completion you are reverting d5869dae5080
> > for.
> > It
> > is not a defect in Maurizio's patch and it will not be fixed by
> > replacing
> > it -- target_cmd_interrupted() records nothing when it queues an
> > abort,
> > so
> > any site that completes an aborted WRITE_PENDING command can be
> > followed
> > by another one. I found this from vmcores on a customer system
> > before
> > either of us posted, so no argument from me that it is real.
>=20
> Not the same, d5869dae5080 greatly increases the probability of the
> double completion by calling target_complete_cmd() which is allowed
> to be
> called only once for the cmd. Calling it twice is wrong by nature.
> Fabric
> module shall call either target_execute_cmd() either
> transport_generic_request_failure(). target_complete_cmd() is for
> backstore modules. That target_complete_cmd() at the iscsi
> connection release is not so good too. But it was intended to be the
> last(and the only) call from fabric driver for the command never be
> in
> the target core.
>=20
> >=20
> > Patch 3 of my series fixes it there, under t_state_lock, for both
> > queueing sites in target_core_transport.c and for every fabric.
> > With
> > that
> > in place your 2/2 is safe and d5869dae5080 does not need reverting
> > for
> > this reason -- which matters, because the revert is not free: that
> > commit
> > carries CVE-2026-97951 and is in 5.10.y, 5.15.y, 6.1.y, 6.6.y,
> > 6.12.y,
> > 6.18.y and 7.2.y.
>=20
> My intention is to not create a situation when there a race is
> possible
> instead of fixing those races.=20
>=20
> > Two questions on 2/2 independent of all that.
> >=20
> > Removing the sense_reason early return in iscsit_execute_cmd()
> > means
> > transport_send_check_condition_and_sense() now runs for an aborted
> > command. It guards only on SCF_SENT_CHECK_CONDITION, never checks
> > CMD_T_ABORTED, and ends in queue_status(); target_handle_abort()
> > also
> > calls queue_status() for a CMD_T_TAS command, and each drops a
> > reference.
> > Can an aborted command with a sense reason send both a CHECK
> > CONDITION
> > and a TASK ABORTED, and drop two references?
>=20
> No, transport_send_check_condition_and_sense will change t_state,
> send
> status and decrease cmd->refcnt and then unblock wait_for_completion
> of
> ABORT/LUN_RESET. Both the commnand and ABORT of that command will be
> completed sucessfully.
> Noone calls target_handle_abort().
>=20
> > And with the early return gone, a LUN_RESET aborting a large WRITE
> > waits in target_put_cmd_and_wait() for the whole remaining data
> > transfer. That is bounded where today it is not, but on a large
> > transfer it may still trip the hung task timeout that made this
> > visible.
> =C2=A0
> That is a idea for a future discussion and improvmens. This patchset
> is
> narrowed to just to fix the stuck of WRITE_PENDING commands.
>=20
> The abort of WRITE_PENDIG command in the state waiting for DataOuts
> currently will wait for the data completion. So, my patch again does
> not
> do worse.
>=20
> > On the overlap: your 2/2 and patch 4 of my series touch the same
> > lines,
> > so only one can apply, and I have no attachment to mine if yours is
> > the
> > better shape. Patches 1 to 3 are core-side and conflict with
> > nothing
> > you have posted.
> >=20
> > Martin, would you prefer those three as their own series,
> > given both candidate iSCSI fixes need patch 3 to be correct?
> >=20
> > I am happy to test either or both: I have a reporter's environment
> > that
> > reproduces this reliably and 300-cycle runs on it.
>=20
> My patch is more than 2 years old in customers setups, but certainly
> it would be great to test it in other environments too.
>=20
> BR,
> =C2=A0Dmitry

OK Great, reverting d5869dae5080 and applying yours and getting it
tested. If it passes than we can revisit my patches 1-3 for a later
series.

On testing: I will build revert + your 2/2 on a RHEL9.8 based distro
kernel and put it through the reporter's environment -- an Oracle RAC
cluster where this reproduces reliably and where the earlier candidate
fixes failed at 95 and 196 LUN_RESET cycles. The pass mark is 300
cycles, which is what my patch 4 cleared twice. I will deliberately
leave my core patches out of that build so the result is about your
series alone.

Thanks for all your reviews and assistance.
Laurence

