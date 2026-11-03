Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793711299;
	b=o4fOJtF2vv9YsF8+WNVnfxI1Qro5LHJbsMP9+9RyJ0Fb5EvS6+GULClTG+LiR18y6Mqe
	 oC1j8JIzqJUQ+3PsBSdJaBsVD2riS70tHO8DyeK+8Et7Bl+OA/9vI9eTxp/Y1rVV+c7qc
	 Ylkl1I+8hpQeSIqwELLhlfnGO73o93B2eD62ei09nfnBn/PoIJw6kuN6dA6VzM7Q/77QY
	 dU7uqdDLF0PCJnK7ef4U3dxLSHosZqCU+uAHeQu/6JHF2dhrpN+5QvU9m0bBgLiqFXhTa
	 eZ3tVz8rchcmop9VFD0vqBP+W6C3HOCHtM2buTboygUP3zBy+CxDd6N2GVAp4TJHOng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793711299;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version;
	bh=JweHxHOgQQEqqfkoSADQQDEsVhp2wjrIIS3nJ/SiuXQ=;
	b=RY12fuwKfXAnOpTRvqchvDAyT5o4n4EGlMCl16hG1xOIiSa/l0VtwTJSUQ+w6HTgf2TV
	 0rXktnwwU1MYFECWqd61mM32aSSyogYAwHlhjQ6CWY22sOVnxwDe8wtr2KNZE3vGJO+AU
	 xzZtOQKmggYbdNAHSOPTlYiiATIZJLa/gdIIpvKIsRMKxYK5HFl0tVP7hlwvMhFjBTdLd
	 4YIvH/tfR0Jo6m4UO3+i4ftimoU7YV/vlhfdUKVo3dVH9WdX2iXCROgaj080csRFumGbo
	 KjPlzha0lPQNA9yadpNQXBcErFiizeZoKbhDEsc0VhDHbw19I/e9hM+mvnp3AHDPCpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=OIWqTT5x;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=jJNFasLn;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A9F60A3801
	for <target-devel@vger.kernel.org>; Tue,  3 Nov 2026 13:08:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 55A9F60A3801
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=OIWqTT5x;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=jJNFasLn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793711298;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JweHxHOgQQEqqfkoSADQQDEsVhp2wjrIIS3nJ/SiuXQ=;
	b=OIWqTT5xIz+OMMRxF8vRkAU0Mg2QfbSdzBU7p9cuaDguqup8+7X6VZ8hNMH6n1MMlwyk3k
	9mAfbUS3qwXJTH3ZLfVvlCY5+XgrxTjYs18HcWeZdPLW7GRYoWa11WBEqjhi+Io4tWRXEh
	BVLU7j82vhY/0OdA8kFpcHyt1lAdPVI=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-171-RBvjIU7OM9Kkfb915DxQcw-1; Tue, 03 Nov 2026 08:08:15 -0500
X-MC-Unique: RBvjIU7OM9Kkfb915DxQcw-1
X-Mimecast-MFC-AGG-ID: RBvjIU7OM9Kkfb915DxQcw_1793711295
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-5363b06bcb2so90120281cf.2
        for <target-devel@vger.kernel.org>; Tue, 03 Nov 2026 05:08:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793711294; x=1794316094; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=JweHxHOgQQEqqfkoSADQQDEsVhp2wjrIIS3nJ/SiuXQ=;
        b=jJNFasLnPFgVUoIbgSmxWV9GI9i4fXZ6rS2uG8pzprDM7VrAl9ReYR5z4wu/igf7zJ
         cuhsAuKuAefdwCBnl0+5Rt/jzGr0UVEgtyD/g7eBx+UidUkrX7eRu3DZGymqE9AQh55q
         rKbtktWr16RMJq+NYsX5pyp97jrss99sMNDPAkOABCDbAM+SYmGEf0+PIDzHwSZrr1va
         boOba0RJ2Jqu8+pc0aN1A+b7FRwYj9IhwjRVdypGXvrmFjStzsVWDxo0YEJl7NNVvoMt
         l148lZASkAEn+z2L0OiyMA2cZxvz73NPbMZUGBTc1+mWY1NQFzFZboeLNc0lkWZ9ik5U
         pfxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793711294; x=1794316094;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JweHxHOgQQEqqfkoSADQQDEsVhp2wjrIIS3nJ/SiuXQ=;
        b=KdT15892LxlAdxU+4ZXYOrCgZNpBt/QC+6MhAqxEzGRu3a979qHmbaE+LE1d4AP03E
         AVUd6pM0YHuksEAFILCDM2Xd+aIT3zF3WP6mMvGM7oNJ9tVvgTgqye43UemGuzyHLuhY
         WRcS6mN3VlmXnsND9CfX0QiUtkguZpG5u7A8NLiyJqj2oBUVCsxRSHbCC66Nx7cj00lj
         2MHHBV2lFUgyy599eLgJF6fa5VkaTHIsada9LAb/CZU2dF4N2MS0qzYlt7zPOtrzAqUi
         uS/c22LDmCkWEEsxSX8u9ndKNfcoTRKXWiLtoSQuc7ORsT7cXd7yP6t9DOEyYZHFZFM1
         q3BQ==
X-Forwarded-Encrypted: i=1; AKwUvBz7MmE5aZ5M73ngOwKRDgUMQYiA9kVW1dGjqcepvWxxQe+uCQa7NLbGGIA8CimZYWwRMd0RAgCykW2Z1kk=@vger.kernel.org
X-Gm-Message-State: APuU4Z8WDeI/v/rFUzlcHcOzT8ydlULVM+XqDR3trjemxDA9sMx3/JSk
	20b7NewkYvDQw5fytcESzVI+9R1PByKgZCRIhqcVcFU/5RSxx/6HybRZysLPfgMAZYcM5rxpjDv
	8o/7mlQWy0eOZiaPyE3TkHsx+31Lta3CFgc4HaGih7UpPEoaSjbzDaB2Jc81ob/V9Rg==
X-Gm-Gg: AYBFou2M7UJARpMT4PfGlw9OwYk49uFnpXpZjk8/2RP6zRuI9xcMPj2DHxGguG1jSSt
	zPlJLu3jNCJuZqLVcZeJ8oAuZ4/N4FI45OVDpFinQxv/y8z44BOoxGTDMrBbbPJZgdsamcydmRI
	+Mb8ySoB0TIPUiyGrpylTmKGINt9vyJcsTF1+lgRwu63r0XpaSoIAJWyv16hlaf+/t52o+vNm2z
	ohi59497R0wiRIQRXXTZoKqj1mwe0hVLcTxwEkqmdqhZ2FJ2LH6BCKY+kDdsUrdozpCwuvDY98r
	6nPSEuVGyZhBv0YdBfTtkyGFrNTHxvpI2FQdHViWxJxx8eMZDZAJEdUjap1ZIQxPxsZYI+4SZrP
	JX1X5eIJpeO7Tc2KP5DNdCZjfbujBfGM/eIqTmfcRU4INcAQNFcxp2/w+BDesOx1eHPPYqrueGC
	pEf5K3sUwQssof5TCPUZa5wD6FazzvE2zAACfv5BROLH7sT6wEChNhVVY9B7fA8SGCIq86gBk=
X-Received: by 2002:ac8:5d14:0:b0:533:4da1:b5d1 with SMTP id d75a77b69052e-542b659318bmr211569841cf.23.1793711294306;
        Tue, 03 Nov 2026 05:08:14 -0800 (PST)
X-Received: by 2002:ac8:5d14:0:b0:533:4da1:b5d1 with SMTP id d75a77b69052e-542b659318bmr211568931cf.23.1793711293406;
        Tue, 03 Nov 2026 05:08:13 -0800 (PST)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:aa2b:ddff:fe88:da74])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5498b49d829sm25499641cf.8.2026.11.03.05.08.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 05:08:12 -0800 (PST)
Message-ID: <7e08a1f08defd24b42722ce0ad52326ff59236cd.camel@redhat.com>
Subject: Re: [PATCH 0/2] target: iscsi: fix hanged WRITE_PENDING commands
From: Laurence Oberman <loberman@redhat.com>
To: Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc: Martin Petersen <martin.petersen@oracle.com>, Maurizio Lombardi
	 <mlombard@redhat.com>, target-devel@vger.kernel.org, 
	michael.christie@oracle.com, linux-scsi@vger.kernel.org, linux@yadro.com
Date: Tue, 03 Nov 2026 08:08:10 -0500
In-Reply-To: <f4cbbca9e8b743da07902e97b09e49ac7e1cc5fb.camel@redhat.com>
References: <20261027180123.13163-1-d.bogdanov@yadro.com>
		 <d7a1701ddc2e7c976ad8ff9ec071d9bfdc86a7e2.camel@redhat.com>
		 <20261028140221.GB32229@yadro.com>
	 <f4cbbca9e8b743da07902e97b09e49ac7e1cc5fb.camel@redhat.com>
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

On Wed, 2026-10-28 at 10:30 -0400, Laurence Oberman wrote:
> On Wed, 2026-10-28 at 17:02 +0300, Dmitry Bogdanov wrote:
> > Hi Laurence,
> >=20
> > On Tue, Oct 27, 2026 at 04:08:08PM -0400, Laurence Oberman wrote:
> > >=20
> > > On Tue, 2026-10-27 at 21:01 +0300, Dmitry Bogdanov wrote:
> > > > ISCSI has some old leftovers in the code that prevents passing
> > > > the
> > > > aborted
> > > > command to the target core to make the actual abort. Such
> > > > commands
> > > > hang
> > > > until connection is closed.
> > > > So remove those leftovers.
> > > >=20
> > > > Dmitry Bogdanov (2):
> > > > =C2=A0 Revert "scsi: target: iscsi: Fix hang for aborted
> > > > WRITE_PENDING
> > > > =C2=A0=C2=A0=C2=A0 commands"
> > > > =C2=A0 scsi: target: iscsi: fix hanging WRITE_PENDING commands
> > > >=20
> > > > =C2=A0drivers/target/iscsi/iscsi_target.c=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 | 19 ----------------
> > > > --
> > > > -
> > > > =C2=A0drivers/target/iscsi/iscsi_target_erl1.c |=C2=A0 8 --------
> > > > =C2=A02 files changed, 27 deletions(-)
> > >=20
> > > Hello Dmitri
> > > Thanks for posting this. I have a series in flight for the same
> > > hang:
> > >=20
> > > https://lore.kernel.org/linux-scsi/20261027122837.2148074-1-loberman@=
redhat.com/
> >=20
> > I know, that is why both you and Maurizio in To: field. I want from
> > you some comments. Thank you for review.
> >=20
> > >=20
> > > Is the revert maybe aimed at the wrong layer, and the sashiko
> > > review of
> > > your 2/2 makes the case better than I can: with the fabric check
> > > removed, an aborted command reaches target_execute_cmd(),
> > > target_cmd_interrupted() queues target_abort_work and returns
> > > without
> > > changing t_state, the command stays on conn_cmd_list in
> > > TRANSPORT_WRITE_PENDING, and iscsit_release_commands_from_conn()
> > > completes it a second time if the connection closes.
> >=20
> > As I said in response to sashiko-bot, that is the current (always
> > be)
> > behavior.
> > It is not introduced by my patch.
> >=20
> > > That is the same double completion you are reverting d5869dae5080
> > > for.
> > > It
> > > is not a defect in Maurizio's patch and it will not be fixed by
> > > replacing
> > > it -- target_cmd_interrupted() records nothing when it queues an
> > > abort,
> > > so
> > > any site that completes an aborted WRITE_PENDING command can be
> > > followed
> > > by another one. I found this from vmcores on a customer system
> > > before
> > > either of us posted, so no argument from me that it is real.
> >=20
> > Not the same, d5869dae5080 greatly increases the probability of the
> > double completion by calling target_complete_cmd() which is allowed
> > to be
> > called only once for the cmd. Calling it twice is wrong by nature.
> > Fabric
> > module shall call either target_execute_cmd() either
> > transport_generic_request_failure(). target_complete_cmd() is for
> > backstore modules. That target_complete_cmd() at the iscsi
> > connection release is not so good too. But it was intended to be
> > the
> > last(and the only) call from fabric driver for the command never be
> > in
> > the target core.
> >=20
> > >=20
> > > Patch 3 of my series fixes it there, under t_state_lock, for both
> > > queueing sites in target_core_transport.c and for every fabric.
> > > With
> > > that
> > > in place your 2/2 is safe and d5869dae5080 does not need
> > > reverting
> > > for
> > > this reason -- which matters, because the revert is not free:
> > > that
> > > commit
> > > carries CVE-2026-97951 and is in 5.10.y, 5.15.y, 6.1.y, 6.6.y,
> > > 6.12.y,
> > > 6.18.y and 7.2.y.
> >=20
> > My intention is to not create a situation when there a race is
> > possible
> > instead of fixing those races.=20
> >=20
> > > Two questions on 2/2 independent of all that.
> > >=20
> > > Removing the sense_reason early return in iscsit_execute_cmd()
> > > means
> > > transport_send_check_condition_and_sense() now runs for an
> > > aborted
> > > command. It guards only on SCF_SENT_CHECK_CONDITION, never checks
> > > CMD_T_ABORTED, and ends in queue_status(); target_handle_abort()
> > > also
> > > calls queue_status() for a CMD_T_TAS command, and each drops a
> > > reference.
> > > Can an aborted command with a sense reason send both a CHECK
> > > CONDITION
> > > and a TASK ABORTED, and drop two references?
> >=20
> > No, transport_send_check_condition_and_sense will change t_state,
> > send
> > status and decrease cmd->refcnt and then unblock
> > wait_for_completion
> > of
> > ABORT/LUN_RESET. Both the commnand and ABORT of that command will
> > be
> > completed sucessfully.
> > Noone calls target_handle_abort().
> >=20
> > > And with the early return gone, a LUN_RESET aborting a large
> > > WRITE
> > > waits in target_put_cmd_and_wait() for the whole remaining data
> > > transfer. That is bounded where today it is not, but on a large
> > > transfer it may still trip the hung task timeout that made this
> > > visible.
> > =C2=A0
> > That is a idea for a future discussion and improvmens. This
> > patchset
> > is
> > narrowed to just to fix the stuck of WRITE_PENDING commands.
> >=20
> > The abort of WRITE_PENDIG command in the state waiting for DataOuts
> > currently will wait for the data completion. So, my patch again
> > does
> > not
> > do worse.
> >=20
> > > On the overlap: your 2/2 and patch 4 of my series touch the same
> > > lines,
> > > so only one can apply, and I have no attachment to mine if yours
> > > is
> > > the
> > > better shape. Patches 1 to 3 are core-side and conflict with
> > > nothing
> > > you have posted.
> > >=20
> > > Martin, would you prefer those three as their own series,
> > > given both candidate iSCSI fixes need patch 3 to be correct?
> > >=20
> > > I am happy to test either or both: I have a reporter's
> > > environment
> > > that
> > > reproduces this reliably and 300-cycle runs on it.
> >=20
> > My patch is more than 2 years old in customers setups, but
> > certainly
> > it would be great to test it in other environments too.
> >=20
> > BR,
> > =C2=A0Dmitry
>=20
> OK Great, reverting d5869dae5080 and applying yours and getting it
> tested. If it passes than we can revisit my patches 1-3 for a later
> series.
>=20
> On testing: I will build revert + your 2/2 on a RHEL9.8 based distro
> kernel and put it through the reporter's environment -- an Oracle RAC
> cluster where this reproduces reliably and where the earlier
> candidate
> fixes failed at 95 and 196 LUN_RESET cycles. The pass mark is 300
> cycles, which is what my patch 4 cleared twice. I will deliberately
> leave my core patches out of that build so the result is about your
> series alone.
>=20
> Thanks for all your reviews and assistance.
> Laurence
Hello Dmitry

OK, your series looks great, we passed 3000 reset loops so we should
take your series in ASAP.

For the series:
Reviewed-by: Laurence Oberman <loberman@redhat.com>
Tested-by:   Laurence Oberman <loberman@redhat.com>

Regards
Laurence Oberman

