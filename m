Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793131695;
	b=zIcYq1g04IAhzgkkiAzvMI13naO1H7L6qMFSEx2xnSsoSaatIGlUfjNeGNrKSHiO+02Z
	 acHLTcK/hBx3V7/2dRsggU4FhUZrcCoVSfVw/J+40EFFCy+w0y5CKXfYjYjGx3WjoHKdY
	 ggadBJABuRik/B4Ar5tMquCCYmm7Qio0F/gsAURotvHE8Kk1CNUeozbiHnxwaru6piaWl
	 5nNNWyPteR14acxepj0sLSblSqmfvdVGGAzqUc5dBxvWUf24BXiPmsXOdNX+DwNHAf9J4
	 VmAkm4UF5Pz53rTmSs+DlntvmfKJnT3r2k2peu5067o70GnfbOMS++bgvk+/WNaSDMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793131695;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version;
	bh=1YJHX2FJISPkStTvYFWPCn9XZ+gAuo9LLswhwwgRlLw=;
	b=eZi9OAJRPjAy0aIephx7UqjyN4yt1o8WuLkYMDxdXa/71aR4LkowPe4moRZsjB9g9vgR
	 RCPoh13cCq0pas+zQ6NnuJMOWdunk969qToEZ9JW5kynoupWuo7TWrNKzpTIZ4p+yRumO
	 uFP6d1Vfj/bSpCK+l76q1KOxHoMtcENl791nLTfSst5KsEl5vP65zdLa1mJuA8YjccuL8
	 slGWOxDD1sRCRxFsEc4W3mfiGXtoYb8kvt4Yvf3rByzn9pUjkwmdyR+0F2YKmcW3gU7Bp
	 10Q/qTIClBPSC4cSY+foN76NwgvB73fuqOpc1+BOTYVOo/zwyz2r2CZBVRKayfhheew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Yv1z3r4B;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=q8+kAvfn;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73AFB606A31E
	for <target-devel@vger.kernel.org>; Tue, 27 Oct 2026 20:08:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 73AFB606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Yv1z3r4B;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=q8+kAvfn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793131693;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1YJHX2FJISPkStTvYFWPCn9XZ+gAuo9LLswhwwgRlLw=;
	b=Yv1z3r4BY1h3578Kv1zKcT4hgSQ7kVudMjX/0LssIAygZQf7KKPW0Dt/QhkHp2s0SY/36U
	KgMm0mkeqveTjxZ2/W4WNCkFsCZbAn8dkTocBYrCnsOeF31NS/tLU/AHRM2lRWxXBNj0T8
	Ddi+5HPQQd2Wt/ptoHBf8FjQ4XZAsWw=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-627-NK2TWzlBM2KGx7wkM3DiFg-1; Tue, 27 Oct 2026 16:08:11 -0400
X-MC-Unique: NK2TWzlBM2KGx7wkM3DiFg-1
X-Mimecast-MFC-AGG-ID: NK2TWzlBM2KGx7wkM3DiFg_1793131691
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-5383c05fb2fso7478121cf.1
        for <target-devel@vger.kernel.org>; Tue, 27 Oct 2026 13:08:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793131691; x=1793736491; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=1YJHX2FJISPkStTvYFWPCn9XZ+gAuo9LLswhwwgRlLw=;
        b=q8+kAvfnx8sybzGir6W5dQI4xnjenBkEH9mhZZhY3vmDnaU25E9waAZMqgZ1gjaF7j
         1tA4/kQq6I3ChmaFGydy9MzP4RW+WtSrp+sf48ex+Xbfq8cqnnDHfp1JdJDGSj6a+E30
         04aU0DAQgafipdhLqT/9sr+BY5eWU/i435zBAcHeWZHV+Zc2HqrBYgknqdoePO1sAC6Q
         GkFVr/Gc7Ma2SwDj5AbPYNX7qf/t3Fva3GKVkJ1abRwNengs9SvVMsSX71OeTt6p8Ws/
         +G8mHI6GR/j4vnrABLDvF1uPXkbQmxyYv/MV0+BW8Jniz/s5OIu/jfh411639535HqIk
         nkaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793131691; x=1793736491;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1YJHX2FJISPkStTvYFWPCn9XZ+gAuo9LLswhwwgRlLw=;
        b=msNZgFSEiWBjY5fmcyZ+eFfQFSl7dLpliDCzrT7y+se/bXBotpIeGHtPgqqwstc44z
         l1RSqPeKK0KDSp3NK6tFmY+mphAsn06x9eJRGyXjrLIut32QtwQxCsy9CyDFCi883AqC
         +YlbMY/wuhOpz1DQdGwuGcC3gf3XFI8QY2dCqQLSQ0QoSKb/EJ8z+iZo9/gfQpJkVr/l
         vSf6c4IPRo0kiIGz2RI45yzMuHSNrs5FdXb7ktQ6u2vbsy+rMI2UuiyoinmWOHk4Tlnj
         IvwVrrTdy7nLYFZa5QOrz2iWqAamZx8RMdZShfWzB7i4mbPf7PueDACQd7yFLWkMjatH
         p6wA==
X-Forwarded-Encrypted: i=1; AKwUvBwccpre5qFkQILMaRi4499MWev+dYgMUxkOD17Q7FfoU61Z9J3ct/zc1slQEIKMYjkfJtLr+tthZ5+rMww=@vger.kernel.org
X-Gm-Message-State: AFq9FYKf70gO9qQZVnDq6hqj+2GQgHMDyu/wTARs01I9Sma0EhKUF4Mw
	jUCPT9eET3+18Xaq0gW0IImMTVc5f47IErWKkMufC2kTMCel5oYD7xMJ09lkGKd5NGuceWdv2Uj
	boR3EYl37b1TMog8FRPSmi7XnqAQAFdcHobuQXG/e/NMKK6yugSaDdOyWSmEniq57lw==
X-Gm-Gg: AYBFou3E3W6KJg4ZYxB5Kpzw7teaoyU6eOKti8Dj9zKRynwtUVVn5mMe/EYutbbsJVo
	66PhbgkGkkW6duNq7W3Br2oTZt5XCn2NUEel/rg1tcOQe2mSP+g5BOgvD4u2r5/DprglMeQEbki
	oyo/HtEzZjIfynkCBwp9o/BvM8X2gONCABwobyB8qwH38Otp/18fISvXaA7Vki1EN6AMIlZooyV
	2NenUVi3OUbXqwPgjWzzZXt/tTs28mpeL3PSpKDoQv4A2Bivhv9BXtnWPJbU3Ryn+nS/hS/2K6V
	1n33WH2D5TqGFF6PReuUMzpfb/+I3vOc4zgh5JOwzLGQcO0AZejMoaGxAbLKh7crMl3bpNsoPBY
	b6whrPoF+VTvopkv5tKfQBjNWoHxwvNWFsJDvSJZG6zMTZFnyp/uqKzOH15K7STow/Jvc8PzjiU
	N0NztEgFpVRC7Yruo=
X-Received: by 2002:a05:622a:1822:b0:533:983b:e53f with SMTP id d75a77b69052e-53fcd197865mr6547621cf.59.1793131691248;
        Tue, 27 Oct 2026 13:08:11 -0700 (PDT)
X-Received: by 2002:a05:622a:1822:b0:533:983b:e53f with SMTP id d75a77b69052e-53fcd197865mr6546721cf.59.1793131690641;
        Tue, 27 Oct 2026 13:08:10 -0700 (PDT)
Received: from loberman-thinkpadp1gen5.rmtusma.csb ([96.39.69.186])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53838cf49c9sm87523701cf.3.2026.10.27.13.08.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 13:08:09 -0700 (PDT)
Message-ID: <d7a1701ddc2e7c976ad8ff9ec071d9bfdc86a7e2.camel@redhat.com>
Subject: Re: [PATCH 0/2] target: iscsi: fix hanged WRITE_PENDING commands
From: Laurence Oberman <loberman@redhat.com>
To: Dmitry Bogdanov <d.bogdanov@yadro.com>, Martin Petersen
	 <martin.petersen@oracle.com>, Maurizio Lombardi <mlombard@redhat.com>, 
	target-devel@vger.kernel.org
Cc: michael.christie@oracle.com, linux-scsi@vger.kernel.org, linux@yadro.com
Date: Tue, 27 Oct 2026 16:08:08 -0400
In-Reply-To: <20261027180123.13163-1-d.bogdanov@yadro.com>
References: <20261027180123.13163-1-d.bogdanov@yadro.com>
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

On Tue, 2026-10-27 at 21:01 +0300, Dmitry Bogdanov wrote:
> ISCSI has some old leftovers in the code that prevents passing the
> aborted
> command to the target core to make the actual abort. Such commands
> hang
> until connection is closed.
> So remove those leftovers.
>=20
> Dmitry Bogdanov (2):
> =C2=A0 Revert "scsi: target: iscsi: Fix hang for aborted WRITE_PENDING
> =C2=A0=C2=A0=C2=A0 commands"
> =C2=A0 scsi: target: iscsi: fix hanging WRITE_PENDING commands
>=20
> =C2=A0drivers/target/iscsi/iscsi_target.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=
 19 -------------------
> =C2=A0drivers/target/iscsi/iscsi_target_erl1.c |=C2=A0 8 --------
> =C2=A02 files changed, 27 deletions(-)

Hello Dmitri
Thanks for posting this. I have a series in flight for the same hang:

https://lore.kernel.org/linux-scsi/20261027122837.2148074-1-loberman@redhat=
.com/

Is the revert maybe aimed at the wrong layer, and the sashiko review of
your 2/2 makes the case better than I can: with the fabric check
removed, an aborted command reaches target_execute_cmd(),
target_cmd_interrupted() queues target_abort_work and returns without
changing t_state, the command stays on conn_cmd_list in
TRANSPORT_WRITE_PENDING, and iscsit_release_commands_from_conn()
completes it a second time if the connection closes.

That is the same double completion you are reverting d5869dae5080 for.
It
is not a defect in Maurizio's patch and it will not be fixed by
replacing
it -- target_cmd_interrupted() records nothing when it queues an abort,
so
any site that completes an aborted WRITE_PENDING command can be
followed
by another one. I found this from vmcores on a customer system before
either of us posted, so no argument from me that it is real.

Patch 3 of my series fixes it there, under t_state_lock, for both
queueing sites in target_core_transport.c and for every fabric. With
that
in place your 2/2 is safe and d5869dae5080 does not need reverting for
this reason -- which matters, because the revert is not free: that
commit
carries CVE-2026-97951 and is in 5.10.y, 5.15.y, 6.1.y, 6.6.y, 6.12.y,
6.18.y and 7.2.y.

Two questions on 2/2 independent of all that.

Removing the sense_reason early return in iscsit_execute_cmd() means
transport_send_check_condition_and_sense() now runs for an aborted
command. It guards only on SCF_SENT_CHECK_CONDITION, never checks
CMD_T_ABORTED, and ends in queue_status(); target_handle_abort() also
calls queue_status() for a CMD_T_TAS command, and each drops a
reference.
Can an aborted command with a sense reason send both a CHECK CONDITION
and a TASK ABORTED, and drop two references?

And with the early return gone, a LUN_RESET aborting a large WRITE
waits in target_put_cmd_and_wait() for the whole remaining data
transfer. That is bounded where today it is not, but on a large
transfer it may still trip the hung task timeout that made this
visible.

On the overlap: your 2/2 and patch 4 of my series touch the same lines,
so only one can apply, and I have no attachment to mine if yours is the
better shape. Patches 1 to 3 are core-side and conflict with nothing
you have posted.=C2=A0

Martin, would you prefer those three as their own series,
given both candidate iSCSI fixes need patch 3 to be correct?

I am happy to test either or both: I have a reporter's environment that
reproduces this reliably and 300-cycle runs on it.

Many Thanks
Laurence

