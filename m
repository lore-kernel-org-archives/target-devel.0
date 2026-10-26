Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793045060;
	b=jsZXOB+l9QHSsdbtwsvqYhiR8orfzgZ8LN8hdikZVeH6tt5t4Bo9YPKh00+ooKcOldz2
	 w0OhkYJPJQWtUhSczp7zDU3y6G/TB4ksuLiWjHgn8coV9qPo2QZEGKRVVn9W4GTCPv63o
	 pd504/2+p33V9p+l8mn6f4t1kXB7LkKfhyILEkIoSEXbCJY03PIReEeUnkKeY79VA6G+U
	 138w9UNZAHMTSgYfcyqwHVJBlZYqiWEgMpIww1WWkgPgvXs1ExKMbeMrO6eAYHtLE64zQ
	 1nl3ApvtJ01AMNjOvaWjVRDSscA76uztxaVNZGvnkmOglledvSQE+VMo1rBqumKsK8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793045060;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version;
	bh=EteNQ3QjnOcsX1B3Urg7UJN4lThZVIxHF8GjAs9LfFk=;
	b=mifaf78XgubNfRbTfXmmNCPPEJtN4uiVQpQoHJyaZPQNWINC1vJFtZnG5gExoqDN57iI
	 oeUBALlU+3kNk5mGRWC44e119HetJRVlShPEZ1RJyr2wpnGNDlOYs126vFWHWlFTFSMCj
	 Rsh5ERTRM3qVJW8xzwuGEFPCYTj/NFubF6HSbz4c7Xx/oK55hhfkxpS49OEVPUtXwgYEC
	 o40XhC8NYXBSFLrIxzyv+EecQhSUmgBvrihx7vZO/Wu7N+JJEz/7K1/Lxz56KC7rhe/a+
	 PzYFlI/Y0nzwO84eryQeGEerFOZFcrD6O+9feLsIOMgQc7NBox3cqZEbe2FhmW4l1hA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=OgDeLlyO;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=Tm+SpeAL;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F087606A31A
	for <target-devel@vger.kernel.org>; Mon, 26 Oct 2026 20:04:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6F087606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=OgDeLlyO;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=Tm+SpeAL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793045058;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EteNQ3QjnOcsX1B3Urg7UJN4lThZVIxHF8GjAs9LfFk=;
	b=OgDeLlyOZLrqh6tptOjYWys3P/6C1xwtAX0Kmo8KQ6gRiopavkTUk1LppXSVsKmPfbspsc
	aClBuzR6T+hbn6i30nAZaShlQnrMjUEqKAOqoveOZONQ7BDS8bUKns67kxwj8qAz1hrzTk
	v7/b0WzvgyWnV5P3J7vO/ZUnGQg+vDw=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-639-6QPBHF6BOrGnZwrIdn1M-Q-1; Mon, 26 Oct 2026 16:04:17 -0400
X-MC-Unique: 6QPBHF6BOrGnZwrIdn1M-Q-1
X-Mimecast-MFC-AGG-ID: 6QPBHF6BOrGnZwrIdn1M-Q_1793045056
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-9179a556c43so78475956d6.3
        for <target-devel@vger.kernel.org>; Mon, 26 Oct 2026 13:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793045056; x=1793649856; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=EteNQ3QjnOcsX1B3Urg7UJN4lThZVIxHF8GjAs9LfFk=;
        b=Tm+SpeALQ4P1s0KzSoSHTQNPj4Sm2pHSCvY5+P5JZMiZdFE9Vyz3GmEjHzJVWt3SNG
         kZVsXR2iARpQT+HwtYNrAgZEK+cpoxp05TaQA1l/vsI3FLRFUUnJEJcA0a52msPv6kyK
         ZGLP/QbBc5En1kVmRZifTmJC67K+5RstpcSXVKbyMMJH2t+H3n0AgRzRgBHvXqXnxZt3
         eUArEeJReO7yIP87VBE88BAfton8OGuRIgS40cIi47bPSnpn8Pq1LAaPik2yGRUw9RS4
         BsfJj0iMW0hKNh6UB9ewwSZzPadQ5DhdfV4Sa+ayfBzD3tc0K4+vr2XqM67r6pZtktZi
         NNDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793045056; x=1793649856;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EteNQ3QjnOcsX1B3Urg7UJN4lThZVIxHF8GjAs9LfFk=;
        b=QxowfcEtbMEqNwVyECi1raSndu5QdDMXYgl0YdZ6QtkRpFm1o/ufg8NL21V2jaiCzR
         UmdC4auumvqQLVHfgpqeA/T834fWqfyHy37KrbwobKOsCloTpi6PGiyea4319PT44yj1
         nswVXBnkqYb53+X2qroXr3XeWiYgQL+Om4fEYkwMFyzwPm+mkSMRwDhAXCNGDoG4xIkm
         C/laKTNpzb+bEfnaAhotB/tPalL14xxasEVhR3FmiTu1pLHMWq30QWAxWB+lpmIQwtPc
         Wp9yYKmMNJatSyCahesV+WYCSpS57LOaidbpXb79n+bVcQGPYcu+su9C6DIFU+A2/KNO
         HcvQ==
X-Forwarded-Encrypted: i=1; AKwUvBzu+qMwIyDn0YDJuMa3GwHlSZu0OlrK3q4FchOLsoYFyR+QVSxfgCZaF08eiXSuN9MnLctkDq4BMvlGt+g=@vger.kernel.org
X-Gm-Message-State: AFq9FYJgAlB9cqqYkAqz7GHeQAtxiufcgEoaDAA/i5wGC1SeWu50JfHr
	JDAc2EXy1laQ5iZfCw1vFrBxeZOFfTqsM5HmxZfDjJhzBYovDFIPcmcGVIkaBqKK7B/43n+eep4
	Bdwd3S3YkXc7fxaqgqHNndITWpuwNs5jQxHYehK7zN9WJQZT8GKEETyXJ3gG9SMQ/5g==
X-Gm-Gg: AYBFou0duVH/nhBSy1VtouA4BMAQNmySp+gnS9++3P2Xepyqq0VJL/U4V+/T+u8ovGP
	GE0j9Wps2D6QhfHwzBnwU03POXviZ/ENRYVQh49++SIP3I0FAgZ+MnAWhfSWPqHMa30YzwGc9Go
	GgAFc5FRXNXfpcQtkIm+7k5J8GnBVG0GMRLNJDcmnd/OhLQB4qrKX/RqO89lLuioXDPQooyLl6t
	FfE3RnCeJFui6ouTPfElCDr3MlSXHoFCZ2j/+WXTiZBsmCujBIwG3+EamtvexEDLwuJXW0g4cBP
	Oq3o28mbdZGDGSBkFQbP0BiXQ3oDB5VvhmLgg4bP0VWPht/tJGjBvu0nNXkCtKEvxjG4kcf97jH
	/kND5r7LxPmeesVnmB6R524hF3sZgo74R8r+sSYdkp5I4kygM2p/Vdsl0L/+1SfbEijOwEhFeRu
	jb0bzAO++wrQF8bHXJgrs1sw==
X-Received: by 2002:a05:620a:3949:b0:93e:7192:191c with SMTP id af79cd13be357-940ef91b69cmr1103803985a.17.1793045051612;
        Mon, 26 Oct 2026 13:04:11 -0700 (PDT)
X-Received: by 2002:a05:620a:3949:b0:93e:7192:191c with SMTP id af79cd13be357-940ef91b69cmr1103796885a.17.1793045050972;
        Mon, 26 Oct 2026 13:04:10 -0700 (PDT)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:aa2b:ddff:fe88:da74])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-940f0a7e5cfsm772481385a.37.2026.10.26.13.04.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 13:04:10 -0700 (PDT)
Message-ID: <d0f9945fb5338ef81796e97777a5a8c4b7f8600b.camel@redhat.com>
Subject: Re: [PATCH v5 1/2] scsi: target: Complete an aborted command at
 most once
From: Laurence Oberman <loberman@redhat.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Date: Mon, 26 Oct 2026 16:04:09 -0400
In-Reply-To: <sashiko-outbox-185693@kernel.org>
References: <20261026192835.1431767-1-loberman@redhat.com>
	 <20261026192835.1431767-2-loberman@redhat.com>
	 <sashiko-outbox-185693@kernel.org>
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

On Mon, 2026-10-26 at 19:56 +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential
> issue(s) to consider:
> - [High] scsi: target: double transport_complete_callback() via
> CMD_T_STOP
> - [High] scsi: target: unguarded abort queueing in
> transport_generic_request_failure()
> --
>=20
> commit 9f0a0fc8e2f216b4d0f91c9797ea14d9a91154f8
> Author: Laurence Oberman <loberman@redhat.com>
>=20
> scsi: target: Complete an aborted command at most once
>=20
> This commit adds the CMD_T_ABORT_QUEUED flag under t_state_lock in
> target_cmd_interrupted() so that an aborted command only runs its
> completion
> callback and queues target_abort_work once.
>=20
> > diff --git a/drivers/target/target_core_transport.c
> > b/drivers/target/target_core_transport.c
> > index 927861c30afc4..4896a92392e0e 100644
> > --- a/drivers/target/target_core_transport.c
> > +++ b/drivers/target/target_core_transport.c
> > @@ -882,24 +882,45 @@ static void target_abort_work(struct
> > work_struct *work)
> > =C2=A0	target_handle_abort(cmd);
> > =C2=A0}
> > =C2=A0
> > +/*
> > + * Returns true if the command has been aborted or stopped, in
> > which case the
> > + * caller must not carry on with normal completion.=C2=A0 For an
> > aborted command the
> > + * work that must not run twice -- the completion callback and the
> > queueing of
> > + * target_abort_work -- is done once, under CMD_T_ABORT_QUEUED.
> > + */
> > =C2=A0static bool target_cmd_interrupted(struct se_cmd *cmd)
> > =C2=A0{
> > +	bool queue_abort =3D false, stop =3D false;
> > +	unsigned long flags;
> > =C2=A0	int post_ret;
> > =C2=A0
> > +	spin_lock_irqsave(&cmd->t_state_lock, flags);
> > =C2=A0	if (cmd->transport_state & CMD_T_ABORTED) {
> > -		if (cmd->transport_complete_callback)
> > -			cmd->transport_complete_callback(cmd,
> > false, &post_ret);
> > +		if (cmd->transport_state & CMD_T_ABORT_QUEUED) {
> > +			spin_unlock_irqrestore(&cmd->t_state_lock,
> > flags);
> > +			return true;
> > +		}
> > +		cmd->transport_state |=3D CMD_T_ABORT_QUEUED;
> > +		queue_abort =3D true;
> > +	} else if (cmd->transport_state & CMD_T_STOP) {
> > +		stop =3D true;
> > +	}
> > +	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
> > +
> > +	if (!queue_abort && !stop)
> > +		return false;
> > +
> > +	if (cmd->transport_complete_callback)
> > +		cmd->transport_complete_callback(cmd, false,
> > &post_ret);
>=20
> [Severity: High]
> Can cmd->transport_complete_callback() still be called more than once
> when a
> command hits the CMD_T_STOP path first?
>=20
> The commit message notes that leaving the CMD_T_STOP branch unguarded
> is
> harmless because complete_all() is idempotent, and explains that a
> first call
> to target_cmd_interrupted() can take the CMD_T_STOP branch before
> CMD_T_ABORTED
> is set afterwards.
>=20
> However, target_cmd_interrupted() executes cmd-
> >transport_complete_callback()
> when either queue_abort or stop is true, without clearing the
> callback pointer
> or guarding its execution. In drivers/target/target_core_sbc.c, both
> compare_and_write_callback() and compare_and_write_post() release
> dev->caw_sem
> without clearing cmd->transport_complete_callback:
>=20
> drivers/target/target_core_sbc.c:compare_and_write_callback() {
> =C2=A0=C2=A0=C2=A0 ...
> out:
> 	/*
> 	 * In the MISCOMPARE or failure case, unlock ->caw_sem
> obtained in
> 	 * sbc_compare_and_write() before the original READ I/O
> submission.
> 	 */
> 	up(&dev->caw_sem);
> 	sg_free_table(&write_tbl);
> 	return ret;
> }
>=20
> If a first call to target_cmd_interrupted() takes the CMD_T_STOP
> branch and a
> subsequent call takes either the CMD_T_ABORTED branch (after
> CMD_T_ABORTED is
> set) or the CMD_T_STOP branch a second time, won't
> cmd->transport_complete_callback() run twice and call up(&dev-
> >caw_sem) a
> second time?
>=20
> > +
> > +	if (queue_abort) {
> > =C2=A0		INIT_WORK(&cmd->work, target_abort_work);
> > =C2=A0		queue_work(target_completion_wq, &cmd->work);
> > -		return true;
> > -	} else if (cmd->transport_state & CMD_T_STOP) {
> > -		if (cmd->transport_complete_callback)
> > -			cmd->transport_complete_callback(cmd,
> > false, &post_ret);
> > +	} else {
> > =C2=A0		complete_all(&cmd->t_transport_stop_comp);
> > -		return true;
> > =C2=A0	}
> > =C2=A0
> > -	return false;
> > +	return true;
> > =C2=A0}
>=20
> [Severity: High]
> Does transport_generic_request_failure() in
> drivers/target/target_core_transport.c also need to test and set
> CMD_T_ABORT_QUEUED under cmd->t_state_lock?
>=20
> Commit 2c9fa49e100f ("scsi: target/core: Make ABORT and LUN RESET
> handling
> synchronous") added the same abort handling pattern to both
> target_cmd_interrupted() and transport_generic_request_failure():
>=20
> drivers/target/target_core_transport.c:transport_generic_request_fail
> ure() {
> =C2=A0=C2=A0=C2=A0 ...
> 	if (cmd->transport_complete_callback)
> 		cmd->transport_complete_callback(cmd, false,
> &post_ret);
>=20
> 	if (cmd->transport_state & CMD_T_ABORTED) {
> 		INIT_WORK(&cmd->work, target_abort_work);
> 		queue_work(target_completion_wq, &cmd->work);
> 		return;
> 	}
> =C2=A0=C2=A0=C2=A0 ...
> }
>=20
> Because transport_generic_request_failure() does not check or set
> CMD_T_ABORT_QUEUED under cmd->t_state_lock, if CMD_T_ABORTED is set
> after
> target_cmd_interrupted() returns false in target_execute_cmd(), and
> execution
> then fails in target_write_prot_action() or __target_execute_cmd()
> (for
> example, when tcmu_queue_cmd() sees CMD_T_ABORTED and returns
> TCM_CHECK_CONDITION_ABORT_CMD, or when target_scsi3_ua_check()
> fails):
>=20
> drivers/target/target_core_transport.c:__target_execute_cmd() {
> =C2=A0=C2=A0=C2=A0 ...
> err:
> 	spin_lock_irq(&cmd->t_state_lock);
> 	cmd->transport_state &=3D ~CMD_T_SENT;
> 	spin_unlock_irq(&cmd->t_state_lock);
>=20
> 	transport_generic_request_failure(cmd, ret);
> }
>=20
> transport_generic_request_failure() will invoke
> cmd->transport_complete_callback(), queue target_abort_work on cmd-
> >work, and
> return early without setting CMD_T_ABORT_QUEUED or
> SCF_SENT_CHECK_CONDITION.
>=20
> If an iSCSI ERL=3D2 TMR TASK_REASSIGN then runs
> iscsit_task_reassign_complete_write() in
> drivers/target/iscsi/iscsi_target_tmr.c, it sees ICF_GOT_LAST_DATAOUT
> set and
> CMD_T_SENT cleared, and calls target_execute_cmd() ->
> target_cmd_interrupted():
>=20
> drivers/target/iscsi/iscsi_target_tmr.c:iscsit_task_reassign_complete
> _write() {
> =C2=A0=C2=A0=C2=A0 ...
> 	if (cmd->cmd_flags & ICF_GOT_LAST_DATAOUT) {
> 		if (!(cmd->se_cmd.transport_state & CMD_T_SENT)) {
> 			pr_debug("WRITE ITT: 0x%08x: t_state: %d"
> 				" never sent to transport\n",
> 				cmd->init_task_tag, cmd-
> >se_cmd.t_state);
> 			target_execute_cmd(se_cmd);
> 			return 0;
> 		}
> =C2=A0=C2=A0=C2=A0 ...
> }
>=20
> Similarly, fabric error paths such as tcm_qla2xxx_write_pending(),
> tcm_qla2xxx_handle_data_work(), and isert_rdma_read_done() call
> transport_generic_request_failure() directly. Could these paths reach
> both
> transport_generic_request_failure() and target_cmd_interrupted() (or
> transport_generic_request_failure() twice) for the same aborted
> command,
> re-initializing cmd->work while queued and running
> cmd->transport_complete_callback() and target_handle_abort() a second
> time?

Let me wait on Bart's review but I do see validity in what Sashiko is
reporting. The complexity in this target code is really hard to deal
with but I am doing my best. I will also see if I can get AI to check
it fully first should I come up with a good response to the latest
sashiko review

Regards
Laurence

