Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A83B4AA024
	for <target-devel@vger.kernel.org>; Fri, 16 Oct 2026 12:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792154797; cv=none; b=ObpB8VKYLCFWZlwfzuLQUcAoQpfREsBq0pN+3SzV0YKw12Rmjzx+zlgk3kY2bfUDwTlOwZrWrymP1PH3psK0hAR4R/1HN86gq43r6HyCE6u5QRmMRVL0xnxLdmqgzZweqvCH7qooo0BHyt+nsLskzWuWk6fw9/7cmrVg4hmIncA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792154797; c=relaxed/simple;
	bh=vIltqrhtG3fdcxt1zy5N+jmI+wWd2EFikeosnuR84v0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=M9SovHmXuQZufFnTqeiDx7/ck5ru1BIlh9DJhWdPJK8hfu5xMCyKtVJFm3sujXzw0rj53x7OLjeSrpeYx4tcKuUFGiBKHwxlVlTNxDKJvhrXmvorKp6bhTbYgEt8v9WmZOTxCcTZ3WGdeCFNhIjmImLZPT1CTfEde3UGRdKOczs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Lv3PyXrk; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=BkV7hbi+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Lv3PyXrk";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="BkV7hbi+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792154794;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jXE5vMlJLDULz4QabdUZcN7zMUliDBSGHX5ZEXcYJUA=;
	b=Lv3PyXrkti4wC2L+86ZvIvFs2LpPb6I3ADCx414H5Ti3a8soeQxNnSQeKzIgTrYvDH9Qrn
	dwPKPvx3QCzV/W6mVn+aqyj6gw/5cwcc4ckw9SOkYq8SXui5Bgvau+Y64EwWJPWy1K2ns+
	t6k2yHYO1dVS+ZoKnsPOGJsgltcHpUo=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-651-mCohO146NGy2g3jrcPJzDQ-1; Fri, 16 Oct 2026 12:46:29 +0000
X-MC-Unique: mCohO146NGy2g3jrcPJzDQ-1
X-Mimecast-MFC-AGG-ID: mCohO146NGy2g3jrcPJzDQ_1792154789
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-917a3c27c9bso122167116d6.0
        for <target-devel@vger.kernel.org>; Fri, 16 Oct 2026 05:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1792154789; x=1792759589; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=jXE5vMlJLDULz4QabdUZcN7zMUliDBSGHX5ZEXcYJUA=;
        b=BkV7hbi+z0YY04SX5EPufYveF82/6MXjP19yttAepjm+y95Z6a0HiLSQj649OV7OO1
         ORvJYE1KMKm7IbZkoi1+ZD5KtevEt52r3RTlvY9yXWFOMiaL+Ie90BzTXy0nn5JxTdpM
         QeuUYUz9KSAXstxb0J0FGBeo4j1mVUXTbi8wzicmVE/rPhUbJog6DmZa28fLogRdQBLd
         H2INRYrbLYJx+MvHQ7apdfSBl+oF4bLu7az4NzmbWCuLFLT6aDwqBlgDRZf0pmWugfHm
         oFsnl3MtLWIXbFNnsRoJs567nB5wS0UOS+8KdfoJvB2YGZNEPBrgaa+EQ9OlgxayE8VR
         VJZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792154789; x=1792759589;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jXE5vMlJLDULz4QabdUZcN7zMUliDBSGHX5ZEXcYJUA=;
        b=LPCjSYCjm/URI/lqv3ZcvoCfq2gUDiZnBw8nCKRd4kuPz51tPG18yXosRqkEcOaLr4
         YwJJNrOz0HcuU4gMk3iYsk1Vm0f9ryQ76nKzPnniXqYajvKa3UTemFxptc8EZzJpoHCr
         HQwRg0zi8etschglh2U/hd4nNaVqCZb7hgRGXwuKejX0FGTSu12R4ryJ+C9anCF+8YMn
         9FfwXIZinysgK7ixbRPjaiPLf5IxnAGH6YZu+ZgWrUuB96UNfzmTlHL/xXsffkkuHPwP
         rU+Q2r8+8EKfDzX6LMoVaPOLBo7ejhqLB9HZuHzyiPP9Avmo7RhnF3hQlrXn9pN9Pk3H
         Q9QQ==
X-Forwarded-Encrypted: i=1; AKwUvBwPyFTJGXTsvO5Idxab5BZCHee0/ifU5S99vD9P8YfYXJ3PQoYwuVUOjYqUsfGCw8JjnxxmbChfPVy4Sq8=@vger.kernel.org
X-Gm-Message-State: AFq9FYJYWduijWWOdKvn5NaCRIX5vrxbCAvDa3sZV6h45Spci2Y3UrYp
	SUlwCi4HSETKl2ZnzmApC4L/KqxONE7ZDzxiWYzpKdCB/TTbD+6UDTEVPeIdqOBgUqFcktZmWgs
	RMNohQBHaD3zn0MGsWJSB5f7o1CRa3YGTWuZgmAMHrEGGVOf9fS5/b7czf3xOGD96Hw==
X-Gm-Gg: AYBFou1wlAr5UQ/xb6UjtvMBtndscZ6QOVFWUjOEnl+37t6KhzeuKpEJU1AiKtqyxsg
	3mxtH/t4p/WeTdEHwHqpZwgy7a+azSAxCF1vKxpnzV74D4JHs1/ThTY+rE2yDbWwGk7/6qoLIxf
	r15X+2Z0QXlY/3S0iTRTej261e4N3dJdYDcniXK2/kq2hk16ibG/endPQ1DXGTNZo5DsnQSBkCM
	kOfCoT79mH7AGDflcrxhV0cZ3Vwk2/1NjIBWT+37ptnhY20CMEXkyz8Fvk1nfYvuL1QA7ItKGQL
	wa1AZ7p/NbE//wGGJsSeTFuNLjaxLHRvQKWqoLHGvSjVeV1gGdonaHJAcOaQ1cySkYyGXx5A+pf
	CG6lAQMO8Zjgptbs5Bz+CToYmR55bNG3obdY=
X-Received: by 2002:a05:620a:198d:b0:93e:66db:69b9 with SMTP id af79cd13be357-93ebd23ab8emr3416424785a.55.1792154788387;
        Fri, 16 Oct 2026 05:46:28 -0700 (PDT)
X-Received: by 2002:a05:620a:198d:b0:93e:66db:69b9 with SMTP id af79cd13be357-93ebd23ab8emr3416418785a.55.1792154787746;
        Fri, 16 Oct 2026 05:46:27 -0700 (PDT)
Received: from loberman-thinkpadp1gen5.rmtusma.csb ([2600:6c65:2440:d8c:929c:b769:6def:faa3])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f1a16b5e4sm201356085a.14.2026.10.16.05.46.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 05:46:26 -0700 (PDT)
Message-ID: <8e325cc7ca21d607b3664debcaa5f14b273b91b6.camel@redhat.com>
Subject: Re: [PATCH 1/2] scsi: target: iscsi: Complete an aborted WRITE
 stuck before the first R2T
From: Laurence Oberman <loberman@redhat.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Date: Fri, 16 Oct 2026 08:46:25 -0400
In-Reply-To: <sashiko-outbox-171458@kernel.org>
References: <20261014143932.39453-1-loberman@redhat.com>
	 <20261014143932.39453-2-loberman@redhat.com>
	 <sashiko-outbox-171458@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2026-10-14 at 15:10 +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider:
> - [High] iscsi: double completion and workqueue corruption for
> aborted WRITEs on DataOut path
> --
>=20
> commit 7b04f6989363db2c2b75d8c212ee852153982c8d
> Author: Laurence Oberman <loberman@redhat.com>
> =C2=A0=C2=A0=C2=A0=20
> scsi: target: iscsi: Complete an aborted WRITE stuck before the first
> R2T
>=20
> This patch resolves an issue where an aborted WRITE command that
> arrives with
> immediate data exceeding FirstBurstLength gets stuck in
> TRANSPORT_WRITE_PENDING.
> It accomplishes this by completing the command in
> iscsit_execute_cmd() and
> introducing a new iscsit_claim_completion_locked() helper to avoid a
> double
> completion race with iscsit_release_commands_from_conn().
>=20
> > diff --git a/drivers/target/iscsi/iscsi_target.c
> > b/drivers/target/iscsi/iscsi_target.c
> > index 124ff269b8e75..aab9237a67768 100644
> > --- a/drivers/target/iscsi/iscsi_target.c
> > +++ b/drivers/target/iscsi/iscsi_target.c
> > @@ -4198,10 +4198,18 @@ static void
> > iscsit_release_commands_from_conn(struct iscsit_conn *conn)
> > =C2=A0		if (cmd->se_cmd.t_state =3D=3D
> > TRANSPORT_WRITE_PENDING) {
> > =C2=A0			/*
> > =C2=A0			 * We never submitted the cmd to LIO core,
> > so we have
> > -			 * to tell LIO to perform the completion
> > process.
> > +			 * to tell LIO to perform the completion
> > process --
> > +			 * unless iscsit_execute_cmd() already
> > did.=C2=A0 t_state
> > +			 * stays TRANSPORT_WRITE_PENDING across
> > that
> > +			 * completion, so the claim is the only
> > thing that can
> > +			 * tell us.
> > =C2=A0			 */
> > +			bool claimed =3D
> > iscsit_claim_completion_locked(cmd);
> > +
> > =C2=A0			spin_unlock_irq(&se_cmd->t_state_lock);
> > -			target_complete_cmd(&cmd->se_cmd,
> > SAM_STAT_TASK_ABORTED);
> > +			if (claimed)
> > +				target_complete_cmd(&cmd->se_cmd,
> > +						=C2=A0=C2=A0=C2=A0
> > SAM_STAT_TASK_ABORTED);
>=20
> [Severity: High]
> Does this code miss the DataOut paths?
>=20
> Because target_complete_cmd() is called directly in
> __iscsit_check_dataout_hdr()
> and target_execute_cmd() is called in iscsit_check_dataout_payload()
> for aborted
> commands without setting the completion_claimed flag.
>=20
> If a command is aborted on the DataOut path:
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
> Because completion_claimed is never set, target_complete_cmd()
> delegates
> to target_cmd_interrupted() which queues target_abort_work but leaves
> the command in TRANSPORT_WRITE_PENDING.
>=20
> If the connection drops before target_abort_work removes the command
> from the connection list, iscsit_release_commands_from_conn() will
> find it,
> iscsit_claim_completion_locked() will return true, and it will call
> target_complete_cmd() a second time.
>=20
> Can this double call to target_complete_cmd() cause
> target_cmd_interrupted()
> to re-initialize and re-queue cmd->work while it is already pending
> on the
> workqueue, leading to workqueue linked-list corruption and a use-
> after-free
> when target_handle_abort() runs twice?
>=20
>=20
Thanks for the review. I verified the mechanism and it is accurate:
target_cmd_interrupted() queues target_abort_work and returns true, and
target_complete_cmd_with_sense() then returns before reaching the
"cmd->t_state =3D TRANSPORT_COMPLETE; cmd->transport_state |=3D
CMD_T_COMPLETE" block. The command is left in TRANSPORT_WRITE_PENDING
with nothing recorded to say it has been completed. The window is also
not narrow: iscsit_release_commands_from_conn() holds conn->cmd_lock
across its entire walk and iscsit_aborted_task() needs that same lock
to
unlink, so if the work item has not run yet, teardown is guaranteed to
see the command rather than merely likely to.

Your point about target_execute_cmd() is correct as well, and worth
spelling out: it calls target_cmd_interrupted() before setting
cmd->t_state =3D TRANSPORT_PROCESSING, so an aborted command taking the
DATAOUT_SEND_TO_TRANSPORT path also stays in TRANSPORT_WRITE_PENDING.

However, this exposure is pre-existing rather than introduced here.
Mainline at that site today is:

	if (cmd->se_cmd.t_state =3D=3D TRANSPORT_WRITE_PENDING) {
		spin_unlock_irq(&se_cmd->t_state_lock);
		target_complete_cmd(&cmd->se_cmd,
SAM_STAT_TASK_ABORTED);
		continue;
	}

The call is unconditional, so a command already completed by
__iscsit_check_dataout_hdr() or by target_execute_cmd() is completed a
second time by teardown as the code stands. This patch gates that call
on the claim, and for a command arriving from either of those paths the
claim succeeds, because neither path claims. Behaviour for them is
therefore identical to mainline. The only change is that the site this
patch adds in iscsit_execute_cmd() can no longer be double-completed.

So the patch removes one reachable double completion and adds none. I
would rather not extend it to cover the two pre-existing sites: this
series has 300 reset cycles of customer validation behind it on a
reproducer that previously failed at 95 and 196 cycles, and widening it
would mean shipping code that validation never exercised. I am happy to
post a separate patch for the pre-existing paths, on its own merits.

The companion finding against patch 2 is a real defect introduced by
this series and I am fixing it in v2.

Thanks
Laurence

