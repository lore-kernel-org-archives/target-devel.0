Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11552931C0
	for <target-devel@vger.kernel.org>; Fri, 16 Oct 2026 12:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792154878; cv=none; b=dcQLYhyBMLcHMh2Foc9IjgY1TVClywgHTKGgStVhRuNk7/o6Ss88AHCNsWZ9A4+/JtKFFCgD6cdCfiAmDihzeS4+OeINaEKPrUpuP/D/fHWtQBMlptN4eB4+Lj4P737fINDwecUvfeCfCNwYc8MNSTeeFOfmnp6An9Gx/rVPVTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792154878; c=relaxed/simple;
	bh=RtR2kz7qz30JVH45MnZuD7Tt4pcBoGmgqSHzEiVw1To=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=l1xWcPPj6yFik8RIDGk/KRNKTIxMQS9NW4qn1n9RxfbMPbzdPhiKAoe3/90XZMTCyY1rfl2poGxlXw5Hjd3JgCxHegdgNkzrMm8j9fmznFMTDAgSeJQLe6juxNnuDBgKXGiTfvM6KFCJ5KUq+QYcC9h7g20tFFUxP0z4EB3zcFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ayi8mrMa; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=IfUdHryv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ayi8mrMa";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="IfUdHryv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792154875;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3Vb6qcm8agLiGe0PZ+zUn2KiSsmzJFEb3kjQ/6YcLrk=;
	b=Ayi8mrMa8Y6aasu4/1xiVr5pifV/51284ACFE/YgbqIwKphMR61Yzr7x7YCeE81SACFDib
	b1/g8DmygiGu0nDwwK+VcpKRLkSe+87sgEGPSJRHQV65DseAVRts0+sNWlXq88x9gLNneV
	NqRa3mLSKEEko75+cTXX3tEaAZNT0Bw=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-398-0MeTse3ePi-jzN3X0fjQSQ-1; Fri, 16 Oct 2026 12:47:47 +0000
X-MC-Unique: 0MeTse3ePi-jzN3X0fjQSQ-1
X-Mimecast-MFC-AGG-ID: 0MeTse3ePi-jzN3X0fjQSQ_1792154867
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-91b7e7d5f56so119279836d6.3
        for <target-devel@vger.kernel.org>; Fri, 16 Oct 2026 05:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1792154867; x=1792759667; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=3Vb6qcm8agLiGe0PZ+zUn2KiSsmzJFEb3kjQ/6YcLrk=;
        b=IfUdHryvLHM94XR9hXGcI7uPxKAIFaazI5Iz8ZHrsvVVYiRODSLoLQgNaMj5NbAMn2
         p4oWsGvFK1oCV15HwumNTqRCoihlEuZCbeS7zJrMzdytKR+fuIgNV7+UwlNxipcxk+/v
         KJq4A7JLSGWVJ/v5kF25DnugXZgx0DNMClUXj/Rxoc7FpnZCJpby8ixcJ6Z7VZAnbE2r
         1ZtBbW1BElWhJmlB5lAGk4GlIOuVEUpTPldEdwmhHzSwfAkYL/+wDbJnn4q2zqt35k7I
         NeqVaDZfzjkph0WbdY8lKQnR3BV7ZjV97SIvRydPaZdf2n1rwpiqg1KgkFfh/To8aTzo
         6lzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792154867; x=1792759667;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3Vb6qcm8agLiGe0PZ+zUn2KiSsmzJFEb3kjQ/6YcLrk=;
        b=tQlYCKRQNyXm1PZpx/mBIqxg3Ivkey1qP+AeWUcOCR9Gz53OrWxYav5I5W5genyoUP
         w2ZCNh+X1tuSdDOsbNHVKQ1NYUQqpRkko5hAaQ1QJuouCwtuLOZ0Rj6fXmZoRtDA74NW
         xRpvy3gE24OGpD3Q+9SDq5ZBqcJz+veAcT4gd8C3UOq3D54lcs0Vjmvzq2cW1MSiz8uO
         uSy2FEps7sDzx9+iXspQWTF5ObKl/g1QLfY46768Jx3viweWWGG/26kT2NIWSX9cVG6x
         g7cPp+Cm1TlckMxlQo1VjVeydjceBM81Qbg0NYNUyY3Me1/gDn/Ect9SnmaU+eE6yn/J
         lkfQ==
X-Forwarded-Encrypted: i=1; AKwUvBykJ0GQa43b6tfJ/dyHWbnhUpYKiza8aRZdFE7WMz7AEl+yfMGZQcuq8VCJsN5dqH2aeCJiadw5wInh8Ao=@vger.kernel.org
X-Gm-Message-State: AFq9FYKuTy2axXaH7XxmJYeuFAocMPK1bA7ePMcNHCgDS87WW19qiCY5
	2GHgwzShqMy5crm3UzS1BonlMx0fDDmblLW5I1u3IRfnWRo2ZbTVvcQ/Gh4/FiGqL6lvRicfwcJ
	mLChP8m1f8KAGmfBBdCSGf4fWgMGIX1rXICxxgcmphWp+b/qwdSDnImJM3b3G2ustug==
X-Gm-Gg: AYBFou0x9QnIMaoXfBA6L+maeZ0qssb2OqxoKRa9E6C5Lq/wo8L7Jp3MQja0Gt9ehVh
	1ZFqhE1ihaQshT+p7Tl/t95jfu+kB1+WJCM2oMoRyXLlnuEcu57yybYzZK3Rk3XTEGshBUWEuaT
	Hm8EW5nEyea3En4lxqnyz9f00YPB/siyur9IAAPPaozoI67cOm8W7HZcrj1J1W+vkiqVdOqw9dJ
	3AQGfhIY+j/TmVIZeCd2XXyASaxceGynrUu5dwscFPd62XLJLiMihClB0ZgPjInOx52vKSYVfYY
	tJFgBHRYS51EAGZlW9fMCnvyIMUbcshuU2j8L2VZYRhRlw3shhY193/9w/apbI91a9Q7rMhKZJL
	EharinJnq8pfdJ+hAi52ACRZfc1Q0J47fOmg=
X-Received: by 2002:a05:6214:b6e:b0:91b:8870:3931 with SMTP id 6a1803df08f44-91b88703a2amr244836616d6.34.1792154866847;
        Fri, 16 Oct 2026 05:47:46 -0700 (PDT)
X-Received: by 2002:a05:6214:b6e:b0:91b:8870:3931 with SMTP id 6a1803df08f44-91b88703a2amr244836066d6.34.1792154866215;
        Fri, 16 Oct 2026 05:47:46 -0700 (PDT)
Received: from loberman-thinkpadp1gen5.rmtusma.csb ([2600:6c65:2440:d8c:929c:b769:6def:faa3])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91bcbae22d0sm22168846d6.28.2026.10.16.05.47.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 05:47:45 -0700 (PDT)
Message-ID: <bfe54bc7b8fdc023903933410c851576c00bea16.camel@redhat.com>
Subject: Re: [PATCH 2/2] scsi: target: iscsi: Complete an aborted WRITE when
 a new R2T would be sent
From: Laurence Oberman <loberman@redhat.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Date: Fri, 16 Oct 2026 08:47:44 -0400
In-Reply-To: <sashiko-outbox-171452@kernel.org>
References: <20261014143932.39453-1-loberman@redhat.com>
	 <20261014143932.39453-3-loberman@redhat.com>
	 <sashiko-outbox-171452@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2026-10-14 at 15:00 +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider:
> - [High] iscsi: workqueue corruption via double completion of aborted
> cmd
> --
>=20
> commit 1cef49db01d5c1eb5e9670fc6f016dfd14ddd5cd
> Author: Laurence Oberman <loberman@redhat.com>
>=20
> scsi: target: iscsi: Complete an aborted WRITE when a new R2T would
> be sent
>=20
> iscsit_check_dataout_payload() hands a command to
> iscsit_get_dataout() to
> request the next burst whenever iscsit_check_post_dataout() returns
> DATAOUT_SEND_R2T, without checking CMD_T_ABORTED first. This patch
> guards
> for aborted commands by stopping the dataout timer and completing the
> command.
>=20
> > diff --git a/drivers/target/iscsi/iscsi_target.c
> > b/drivers/target/iscsi/iscsi_target.c
> > index aab9237a67768..87b215b18034e 100644
> > --- a/drivers/target/iscsi/iscsi_target.c
> > +++ b/drivers/target/iscsi/iscsi_target.c
> > @@ -1669,6 +1669,25 @@ iscsit_check_dataout_payload(struct
> > iscsit_cmd *cmd, struct iscsi_data *hdr,
> > =C2=A0	if ((rc =3D=3D DATAOUT_NORMAL) || (rc =3D=3D
> > DATAOUT_WITHIN_COMMAND_RECOVERY))
> > =C2=A0		return 0;
> > =C2=A0	else if (rc =3D=3D DATAOUT_SEND_R2T) {
> [ ... ]
> > +		if (cmd->se_cmd.transport_state & CMD_T_ABORTED) {
> > +			if (cmd->outstanding_r2ts < 1) {
> > +				iscsit_stop_dataout_timer(cmd);
> > +				target_complete_cmd(&cmd->se_cmd,
> > +						=C2=A0=C2=A0=C2=A0
> > SAM_STAT_TASK_ABORTED);
>=20
> [Severity: High]
> Can calling target_complete_cmd() directly on an aborted command
> bypass the
> synchronization wrapper iscsit_complete_aborted_cmd()?
>=20
> Because this bypasses iscsit_claim_completion_locked(), could
> concurrent
> session teardown or other abort paths also claim the command and call
> target_complete_cmd()?
>=20
> This concurrent modification could lead to target_cmd_interrupted()
> executing
> INIT_WORK(&cmd->work, target_abort_work) and queue_work()
> concurrently on an
> already active work item, which might destroy the workqueue linked
> list.
>=20
> There is also a preexisting location in the header parsing path that
> exposes
> the same unsynchronized completion race, which appears to have been
> copied
> here and left unfixed:
>=20
> drivers/target/iscsi/iscsi_target.c:__iscsit_check_dataout_hdr() {
> =C2=A0=C2=A0=C2=A0 ...
> 		if (se_cmd->transport_state & CMD_T_ABORTED) {
> 			if (hdr->flags & ISCSI_FLAG_CMD_FINAL &&
> 			=C2=A0=C2=A0=C2=A0 --cmd->outstanding_r2ts < 1) {
> 				iscsit_stop_dataout_timer(cmd);
> 				target_complete_cmd(se_cmd,
> SAM_STAT_TASK_ABORTED);
> 			}
> =C2=A0=C2=A0=C2=A0 ...
> }
>=20
> Would it be safer to use iscsit_complete_aborted_cmd() in both places
> to
> ensure the completion is safely claimed?
>=20
> > +			}
> > +			return 0;
> > +		}
> > +
> > =C2=A0		iscsit_set_dataout_sequence_values(cmd);

Thanks for the review - you are right, and unlike the companion finding
against patch 1 this one is a defect this series introduces rather than
inherits.

The new completion in the DATAOUT_SEND_R2T branch calls
target_complete_cmd() directly and so never sets completion_claimed.
After it runs, the command is still in TRANSPORT_WRITE_PENDING and
still
on conn->conn_cmd_list until target_abort_work reaches
iscsit_aborted_task(). A connection drop in that window lets
iscsit_release_commands_from_conn() claim the command successfully and
complete it a second time, which is exactly the sequence you describe.

v2 will route it through iscsit_complete_aborted_cmd():

	if (cmd->se_cmd.transport_state & CMD_T_ABORTED) {
		if (cmd->outstanding_r2ts < 1)
			iscsit_complete_aborted_cmd(cmd);
		return 0;
	}

The helper already performs iscsit_stop_dataout_timer() followed by
target_complete_cmd(), so the claimed path is unchanged and only the
second completion is suppressed. It also gives the helper a second
caller, which it should have had in this version.

Worth noting for the record that instrumented kernels logged this site
firing zero times across two independent 300-cycle validation runs, so
the change does not disturb the path that was actually exercised during
testing. The validated fix is the iscsit_execute_cmd() site in patch 1,
which v2 leaves alone.

On the pre-existing location in __iscsit_check_dataout_hdr(): I agree
it
has the same shape, and the lock context there allows the helper
(iscsit_stop_dataout_timer() sleeps at that point, so t_state_lock is
already dropped). I would prefer to handle it in a separate patch
rather
than fold it into this series - it is a distinct pre-existing race in
code this series does not otherwise touch. I have replied on the patch
1 thread with the reasoning.

Thanks
Laurence

