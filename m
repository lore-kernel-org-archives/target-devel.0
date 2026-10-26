Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793045727;
	b=XHRZbUQG4ZPlLOn0wC0jHRKr2mxt06foEsx7x0uwudWhPV4rMDke4OlXETqmudGmec9a
	 VuQ21liTq2tgsotos51q//bvUA28rGP4+VfRMc22DkKK+MEZHpVukDm8ZN+IR+zZ5tocs
	 gvenjBQRA1BsmZZ6NjdviuUohPie0RN81Bc55lk2bOV87Nbk5IemrgTbjkrL9pAa1IH3q
	 igY9d7UfBj3nDbkLk5956hLDk6jvbv4qx2FKPezzw4XZ2k0l9meRgYHGn5GVr2sOThnjd
	 ktnRxhBBmUP1/D1+6t5Ng47UJbRQHz3exQbki8ZgqzLINuPjUS9Q7948D8RYM9c9EMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793045727;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version;
	bh=qBc5XRyll88oDqHTAiSqDmpJCercJbqZIVuAcy1oYe4=;
	b=iUO1JZ+ibjL7GDe8QGqocE5GonH48BVAhCicFqeHFMNsZoDCAcTNQsWFCwfxSVtG7t1O
	 jBx/pnMIkOaBBdZ64NlWRsej2/FQ60f7PpGdKAuiz3oSnrrjgrl0fzD1EsELzJjUiUA+5
	 bwc6e6HrK0czmSSH+FBlGrBFojQmKs/5v+0DqVLcZZ6iei/jknUBQcVi7sXTPw86EwDwg
	 wv+9It+rj6s0e/Fx7IsZXZJYik9xzr5CrZ/gszz5ixKKxWznVqkk0F1ttbS0nSHfuaYBn
	 Uwi6GeRjSBBAjaq9Tvk3IfEBgNg3rr8UG0QNegC5RItBDI7Oa8yrNJH3hNmIuCYaJXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=MSSVQVBt;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=cyKqIJYC;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59011606A31B
	for <target-devel@vger.kernel.org>; Mon, 26 Oct 2026 20:15:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 59011606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=MSSVQVBt;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=cyKqIJYC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793045725;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qBc5XRyll88oDqHTAiSqDmpJCercJbqZIVuAcy1oYe4=;
	b=MSSVQVBt6zsveX7nHWSzyBTyoGElaNkXZsFU4R0wi3sQKH7x6xQKqdf/Ds4n4es9MNV6nL
	ex+wDyB179/LCin6IjW87l+7fXqi+lrUlwOCmm2nIixRd9cZwWWuSBI1dSfv0MF20C2eNw
	X0rrCacooCBU6nlnH/YUM3sj3NmSK5w=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-426-YaOqz30yOmKlCRvGAtYF8A-1; Mon, 26 Oct 2026 16:15:17 -0400
X-MC-Unique: YaOqz30yOmKlCRvGAtYF8A-1
X-Mimecast-MFC-AGG-ID: YaOqz30yOmKlCRvGAtYF8A_1793045717
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-9179743a76eso6458296d6.1
        for <target-devel@vger.kernel.org>; Mon, 26 Oct 2026 13:15:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793045717; x=1793650517; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=qBc5XRyll88oDqHTAiSqDmpJCercJbqZIVuAcy1oYe4=;
        b=cyKqIJYCnycbWcjalufXNwSjoJesqByuW8tNde6ueRnJX9ZD7FJYkHjVIqmiq3J4lw
         +eB9usZaZaXZM9OP1WqjYOn69V0a8Esz1aid+48K6PBzrHVp8aMl9Zja5whDPB6hc9Rc
         3LaEx0VasSvWnln/fVYDTK3geHbqlnQ/AxzGL6aYRzV6DozqqQeSk4rUtq83IY0OZJaS
         tDRIHMiuF9Q9aeFYJrd5QUHKsFUwMs28qck5jAlLRDu+DEcCZSGe606dsJk9FZ2vTJTe
         4lGxZjhzMHQwRJorcdcxGPkdGdpRkRgaqpyJIdxX+0hvbJ0eRepoviMIg36bnFp+XP4M
         hEag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793045717; x=1793650517;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qBc5XRyll88oDqHTAiSqDmpJCercJbqZIVuAcy1oYe4=;
        b=15d5qMWQAiGhDh+B0I1RTlSw4AZAuAT/ChQV+48aSwsZHqCrkRKSwE71eP8+9PHfNJ
         f7X+KV9I5ouceSVFT8pygCB5DPk10njDkF+WBARr8n0I/U9zsBgXwPG/QPyn9YejEnUk
         eVmfsij+X/B9Alyw55LWPrIeodN0IWqoCfAgyq0uCKusHYOB5rCc104ehvPpVcv1OoJc
         tMyCqe2bdXnEAgTPj/Km9tBQy2hdIgpl8mJDcg/WDcNlVCnxGkg4JLy7NevxkSaznwLq
         OGNWOoTyWMaxGIwX14YTTOlSyIg+iUaJiwJu2L4Hf2ykrxXbRrgrmeSTrJ/JzJoAL5EA
         0TyQ==
X-Forwarded-Encrypted: i=1; AKwUvBybg3ccvxtXMBRnhAwje43FtezInenFgty0jS3WGxt8a4cC3ePNH3ofef4SVDxnpfMk2/31zVh0epGvLrs=@vger.kernel.org
X-Gm-Message-State: AFq9FYK3i8vwUqAxStNMhlGtEFyS83A2CThXtI6n5S1iRyp7nywQ/jRx
	oNdYJvtnK5yLK4GZjawk5qQYQQ1Li//9VlHXSc9OQNLf3reFrTACnHde4MwUgm8GXKEOXay5Nqr
	4nqzYU9gHPQpJD8Sg6j3mipa9qjspVuKYnjPaWAC2uDl8HmWifZPGpdGtSUc1eUG08Q==
X-Gm-Gg: AYBFou39ExogJGGSqDinTpzjIrV4gZil1ew0sjZUWIcA/0JK6Bj4zfVK/vU+GLK9lfp
	1vIPxUcPPXzfxUks5sngEefJSClgk/jq48n3BrKGjWhMXI0n0/8vSHBb+dtOFURlVz9TFKXqcaa
	Xl3v+Vt4SO7+2TGiFuOGFnaVS5wuxPqvc/4H7ZeZ6WGF3rVl6/7+sLArV2/Xp4kjtOoP8IBHE6G
	MsKiS0U7GUKo9whAsV3QJLUs1Q6R8I/u2freV2IIXYufOyrtc1NhzrrDyZMbDZHCjTPebO0iHSW
	H+NiEe7oNAva+D8nxxR7kKX7JzXbeuqBfyozS3duYk6p90L4ccE3pk0o4JxQaiZ7BU3w+JgESBo
	5xHJJ1010uwJZMM/xARjQdYK7+T69R2ycjPd7rduaqGljg2lmllSA6+BKt7nV5zhZDHOaaMTCSj
	ZgWVyH64+ydJcHy65toQABaQ==
X-Received: by 2002:a05:6214:8447:b0:917:7e2b:d732 with SMTP id 6a1803df08f44-91c6d30f601mr9080126d6.21.1793045715291;
        Mon, 26 Oct 2026 13:15:15 -0700 (PDT)
X-Received: by 2002:a05:6214:8447:b0:917:7e2b:d732 with SMTP id 6a1803df08f44-91c6d30f601mr9079356d6.21.1793045714566;
        Mon, 26 Oct 2026 13:15:14 -0700 (PDT)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:aa2b:ddff:fe88:da74])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c47c129b2sm81631796d6.20.2026.10.26.13.15.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 13:15:13 -0700 (PDT)
Message-ID: <caf736526f8ff4dee2fb4e05200844ec02d641b6.camel@redhat.com>
Subject: Re: [PATCH v5 1/2] scsi: target: Complete an aborted command at
 most once
From: Laurence Oberman <loberman@redhat.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Van Assche,
 Bart" <bvanassche@acm.org>
Date: Mon, 26 Oct 2026 16:15:13 -0400
In-Reply-To: <d0f9945fb5338ef81796e97777a5a8c4b7f8600b.camel@redhat.com>
References: <20261026192835.1431767-1-loberman@redhat.com>
		 <20261026192835.1431767-2-loberman@redhat.com>
		 <sashiko-outbox-185693@kernel.org>
	 <d0f9945fb5338ef81796e97777a5a8c4b7f8600b.camel@redhat.com>
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

On Mon, 2026-10-26 at 16:04 -0400, Laurence Oberman wrote:
> On Mon, 2026-10-26 at 19:56 +0000, sashiko-bot@kernel.org=C2=A0wrote:
> > Thank you for your contribution! Sashiko AI review found 2
> > potential
> > issue(s) to consider:
> > - [High] scsi: target: double transport_complete_callback() via
> > CMD_T_STOP
> > - [High] scsi: target: unguarded abort queueing in
> > transport_generic_request_failure()
> > --
> >=20
> > commit 9f0a0fc8e2f216b4d0f91c9797ea14d9a91154f8
> > Author: Laurence Oberman <loberman@redhat.com>
> >=20
> > scsi: target: Complete an aborted command at most once
> >=20
> > This commit adds the CMD_T_ABORT_QUEUED flag under t_state_lock in
> > target_cmd_interrupted() so that an aborted command only runs its
> > completion
> > callback and queues target_abort_work once.
> >=20
> > > diff --git a/drivers/target/target_core_transport.c
> > > b/drivers/target/target_core_transport.c
> > > index 927861c30afc4..4896a92392e0e 100644
> > > --- a/drivers/target/target_core_transport.c
> > > +++ b/drivers/target/target_core_transport.c
> > > @@ -882,24 +882,45 @@ static void target_abort_work(struct
> > > work_struct *work)
> > > =C2=A0	target_handle_abort(cmd);
> > > =C2=A0}
> > > =C2=A0
> > > +/*
> > > + * Returns true if the command has been aborted or stopped, in
> > > which case the
> > > + * caller must not carry on with normal completion.=C2=A0 For an
> > > aborted command the
> > > + * work that must not run twice -- the completion callback and
> > > the
> > > queueing of
> > > + * target_abort_work -- is done once, under CMD_T_ABORT_QUEUED.
> > > + */
> > > =C2=A0static bool target_cmd_interrupted(struct se_cmd *cmd)
> > > =C2=A0{
> > > +	bool queue_abort =3D false, stop =3D false;
> > > +	unsigned long flags;
> > > =C2=A0	int post_ret;
> > > =C2=A0
> > > +	spin_lock_irqsave(&cmd->t_state_lock, flags);
> > > =C2=A0	if (cmd->transport_state & CMD_T_ABORTED) {
> > > -		if (cmd->transport_complete_callback)
> > > -			cmd->transport_complete_callback(cmd,
> > > false, &post_ret);
> > > +		if (cmd->transport_state & CMD_T_ABORT_QUEUED) {
> > > +			spin_unlock_irqrestore(&cmd-
> > > >t_state_lock,
> > > flags);
> > > +			return true;
> > > +		}
> > > +		cmd->transport_state |=3D CMD_T_ABORT_QUEUED;
> > > +		queue_abort =3D true;
> > > +	} else if (cmd->transport_state & CMD_T_STOP) {
> > > +		stop =3D true;
> > > +	}
> > > +	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
> > > +
> > > +	if (!queue_abort && !stop)
> > > +		return false;
> > > +
> > > +	if (cmd->transport_complete_callback)
> > > +		cmd->transport_complete_callback(cmd, false,
> > > &post_ret);
> >=20
> > [Severity: High]
> > Can cmd->transport_complete_callback() still be called more than
> > once
> > when a
> > command hits the CMD_T_STOP path first?
> >=20
> > The commit message notes that leaving the CMD_T_STOP branch
> > unguarded
> > is
> > harmless because complete_all() is idempotent, and explains that a
> > first call
> > to target_cmd_interrupted() can take the CMD_T_STOP branch before
> > CMD_T_ABORTED
> > is set afterwards.
> >=20
> > However, target_cmd_interrupted() executes cmd-
> > > transport_complete_callback()
> > when either queue_abort or stop is true, without clearing the
> > callback pointer
> > or guarding its execution. In drivers/target/target_core_sbc.c,
> > both
> > compare_and_write_callback() and compare_and_write_post() release
> > dev->caw_sem
> > without clearing cmd->transport_complete_callback:
> >=20
> > drivers/target/target_core_sbc.c:compare_and_write_callback() {
> > =C2=A0=C2=A0=C2=A0 ...
> > out:
> > 	/*
> > 	 * In the MISCOMPARE or failure case, unlock ->caw_sem
> > obtained in
> > 	 * sbc_compare_and_write() before the original READ I/O
> > submission.
> > 	 */
> > 	up(&dev->caw_sem);
> > 	sg_free_table(&write_tbl);
> > 	return ret;
> > }
> >=20
> > If a first call to target_cmd_interrupted() takes the CMD_T_STOP
> > branch and a
> > subsequent call takes either the CMD_T_ABORTED branch (after
> > CMD_T_ABORTED is
> > set) or the CMD_T_STOP branch a second time, won't
> > cmd->transport_complete_callback() run twice and call up(&dev-
> > > caw_sem) a
> > second time?
> >=20
> > > +
> > > +	if (queue_abort) {
> > > =C2=A0		INIT_WORK(&cmd->work, target_abort_work);
> > > =C2=A0		queue_work(target_completion_wq, &cmd->work);
> > > -		return true;
> > > -	} else if (cmd->transport_state & CMD_T_STOP) {
> > > -		if (cmd->transport_complete_callback)
> > > -			cmd->transport_complete_callback(cmd,
> > > false, &post_ret);
> > > +	} else {
> > > =C2=A0		complete_all(&cmd->t_transport_stop_comp);
> > > -		return true;
> > > =C2=A0	}
> > > =C2=A0
> > > -	return false;
> > > +	return true;
> > > =C2=A0}
> >=20
> > [Severity: High]
> > Does transport_generic_request_failure() in
> > drivers/target/target_core_transport.c also need to test and set
> > CMD_T_ABORT_QUEUED under cmd->t_state_lock?
> >=20
> > Commit 2c9fa49e100f ("scsi: target/core: Make ABORT and LUN RESET
> > handling
> > synchronous") added the same abort handling pattern to both
> > target_cmd_interrupted() and transport_generic_request_failure():
> >=20
> > drivers/target/target_core_transport.c:transport_generic_request_fa
> > il
> > ure() {
> > =C2=A0=C2=A0=C2=A0 ...
> > 	if (cmd->transport_complete_callback)
> > 		cmd->transport_complete_callback(cmd, false,
> > &post_ret);
> >=20
> > 	if (cmd->transport_state & CMD_T_ABORTED) {
> > 		INIT_WORK(&cmd->work, target_abort_work);
> > 		queue_work(target_completion_wq, &cmd->work);
> > 		return;
> > 	}
> > =C2=A0=C2=A0=C2=A0 ...
> > }
> >=20
> > Because transport_generic_request_failure() does not check or set
> > CMD_T_ABORT_QUEUED under cmd->t_state_lock, if CMD_T_ABORTED is set
> > after
> > target_cmd_interrupted() returns false in target_execute_cmd(), and
> > execution
> > then fails in target_write_prot_action() or __target_execute_cmd()
> > (for
> > example, when tcmu_queue_cmd() sees CMD_T_ABORTED and returns
> > TCM_CHECK_CONDITION_ABORT_CMD, or when target_scsi3_ua_check()
> > fails):
> >=20
> > drivers/target/target_core_transport.c:__target_execute_cmd() {
> > =C2=A0=C2=A0=C2=A0 ...
> > err:
> > 	spin_lock_irq(&cmd->t_state_lock);
> > 	cmd->transport_state &=3D ~CMD_T_SENT;
> > 	spin_unlock_irq(&cmd->t_state_lock);
> >=20
> > 	transport_generic_request_failure(cmd, ret);
> > }
> >=20
> > transport_generic_request_failure() will invoke
> > cmd->transport_complete_callback(), queue target_abort_work on cmd-
> > > work, and
> > return early without setting CMD_T_ABORT_QUEUED or
> > SCF_SENT_CHECK_CONDITION.
> >=20
> > If an iSCSI ERL=3D2 TMR TASK_REASSIGN then runs
> > iscsit_task_reassign_complete_write() in
> > drivers/target/iscsi/iscsi_target_tmr.c, it sees
> > ICF_GOT_LAST_DATAOUT
> > set and
> > CMD_T_SENT cleared, and calls target_execute_cmd() ->
> > target_cmd_interrupted():
> >=20
> > drivers/target/iscsi/iscsi_target_tmr.c:iscsit_task_reassign_comple
> > te
> > _write() {
> > =C2=A0=C2=A0=C2=A0 ...
> > 	if (cmd->cmd_flags & ICF_GOT_LAST_DATAOUT) {
> > 		if (!(cmd->se_cmd.transport_state & CMD_T_SENT)) {
> > 			pr_debug("WRITE ITT: 0x%08x: t_state: %d"
> > 				" never sent to transport\n",
> > 				cmd->init_task_tag, cmd-
> > > se_cmd.t_state);
> > 			target_execute_cmd(se_cmd);
> > 			return 0;
> > 		}
> > =C2=A0=C2=A0=C2=A0 ...
> > }
> >=20
> > Similarly, fabric error paths such as tcm_qla2xxx_write_pending(),
> > tcm_qla2xxx_handle_data_work(), and isert_rdma_read_done() call
> > transport_generic_request_failure() directly. Could these paths
> > reach
> > both
> > transport_generic_request_failure() and target_cmd_interrupted()
> > (or
> > transport_generic_request_failure() twice) for the same aborted
> > command,
> > re-initializing cmd->work while queued and running
> > cmd->transport_complete_callback() and target_handle_abort() a
> > second
> > time?
>=20
> Let me wait on Bart's review but I do see validity in what Sashiko is
> reporting. The complexity in this target code is really hard to deal
> with but I am doing my best. I will also see if I can get AI to check
> it fully first should I come up with a good response to the latest
> sashiko review
>=20
> Regards
> Laurence


Hello Bart
I decided to send this along to get some guidance before I finalize
something to deal with Sashiko's latest report.

The Sashiko review of v5 found two things against patch 1. I checked
both against the tree and the second one is a real hole in the patch,
so v6 will follow/

1. transport_generic_request_failure() queues target_abort_work too.

There are exactly two sites in target_core_transport.c that queue
target_abort_work -- target_cmd_interrupted() and
transport_generic_request_failure() -- and v5 guarded only the first.
2c9fa49e100f added the same pattern to both, so guarding one is half a
fix, and the path the review gives is reachable:
target_cmd_interrupted()
returns false because CMD_T_ABORTED is not set yet, execution then
fails
and transport_generic_request_failure() queues the work with nothing
recorded, and a later target_execute_cmd() -- from
iscsit_task_reassign_complete_write(), say -- queues it again. That is
the
re-queue-while-queued this series is supposed to prevent, so patch 1 as
posted did not hold up its own subject line.

v6 factors the test-and-set into __target_claim_abort() and uses it at
both sites. Patch 1's subject is now "Queue the abort of a command at
most
once", which is what it actually guarantees.

2. transport_complete_callback() is still not one-shot.

Also correct. It runs on both branches of target_cmd_interrupted() and
again in transport_generic_request_failure(), so a CMD_T_STOP call
followed by a CMD_T_ABORTED call runs it twice, as does a failure
arriving
after an abort has already been claimed. For COMPARE AND WRITE that is
a
second up(&dev->caw_sem).

This is existing behaviour rather than something the series introduces
--
mainline runs the callback on both branches today -- but patch 1 cites
the
caw_sem double release as part of its rationale, so it is fair to say
the
fix does not match its own description. I have not tried to close it in
v6, because the options are a second flag alongside CMD_T_ABORT_QUEUED
or
clearing cmd->transport_complete_callback after the first success=3Dfalse
call, and the latter affects target_complete_ok_work(), which calls the
same callback with success=3Dtrue.

Bart, since the claim is your design: which way would you want that
done, and should it be part of this series or a follow-up? Patch 1
describes the gap explicitly at the end so it is not left implied.

Thanks as always
Laurence


