Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793041029;
	b=uWpuw7M2tGXlE1KDDYBj4FE8OfSi+proNIbZV5KRwNP1NfFct8q62mHlnFLyW9BnOFrA
	 6ftLAPtYBK1xKrMwNtXs7jPWfJqXN4VzyKd+sxeUA95H57CiJX0cb7Lp9uQBBGpuQ1abn
	 L6wTv+LYMlbERct5O1/sSsiLKGh/KTc1rPl7CXTkLG8vGE7dJxANjvtSwY2G+VKca13D1
	 Qdf4p6QnyWJBYwHWbcIt5wcZUHtfG/BzU1X0ZLznWtG/to1GuoreYngf8xjr3hxUKdv5A
	 dWWr69bWWz/tICPvlpwO8WyXrwKmnnRzwzDCsZmBXNKJJRDpZ2MvOURJ2+yaaEn4klA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793041029;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version;
	bh=bWlVFKk/hA3IhLifvlVvVb0OqBSStw22ybdS81uZBv0=;
	b=rVBfRbM1S6KQEi/If892tE+CKGrx8qA866LXskENDJUqelj4U1Rg0JZdCjhfOVrSRtMg
	 2GrEbxl0xub24n/FUfpzARROyQVQDiyEG3LIaE+jCbqSiLtTlc43ZzAzOOt+FJ7gAW3Py
	 55jKxAW9Du+RfyPCbs159RClbL1NrDWxTO7Fp6jLliKwq13/95C2YkGT/ngafcSV1jEfu
	 VP3bLnAm+NVBYXQ+tnFRlEDX1ct2wVD2Qp5RD6wmohxfJR+WkUPpG8QUKKL50o6uMvQYu
	 PHsDgzaQ78MWq37CMaKkAHv88fGXBiF0MEsNhcC619IsPDGIIIPXXN54kdHzOzFcA2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=XCffbO5I;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=eVKkmdjZ;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD42D606A31D
	for <target-devel@vger.kernel.org>; Mon, 26 Oct 2026 18:57:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BD42D606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=XCffbO5I;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=eVKkmdjZ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793041027;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bWlVFKk/hA3IhLifvlVvVb0OqBSStw22ybdS81uZBv0=;
	b=XCffbO5ILWrUuFHAx5NVFERneuSB/cFwFRSPzIUpZ7Ya9OUY/Ue1budbUAXDjUNhjfUeow
	M6GQn/DGtlWLrY2zEpe+QlRnoKkKXKVkNOFA2MvihLu58PBqKou6eOJqnY6gHZNJx+YzR1
	W2XGvMeKxkzKmmRoxb0X4rMv+SLgLyk=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-594-84DypiaWN_yDez4fozp9-w-1; Mon, 26 Oct 2026 14:57:06 -0400
X-MC-Unique: 84DypiaWN_yDez4fozp9-w-1
X-Mimecast-MFC-AGG-ID: 84DypiaWN_yDez4fozp9-w_1793041026
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-93caf6c528aso544326085a.0
        for <target-devel@vger.kernel.org>; Mon, 26 Oct 2026 11:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793041026; x=1793645826; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=bWlVFKk/hA3IhLifvlVvVb0OqBSStw22ybdS81uZBv0=;
        b=eVKkmdjZXIfl1EbKxJKCtX4YZ/S7YtWVJDgJrYGVtSim9FJcF9tWiDyzIxd6aHclFH
         Mntc+reNjLfL4GGQyeUyu6pkC91+NRG32xPi2U9e4QGDoIZjwY0P4GKFiUF6ytd66Lzv
         IDByNf0OtDPAUXgZYYVqaeElHqMovGt3bpqjSfRmPJh4kd3z4OZ/FdtRpMCWBtsWQv/6
         oEtgexJXnpg2oUV/LDCI/NIQRa3N4aN7trnt8Za/9rIIlYhm2/5xXJFHiJKVX+FuprDD
         LXhkjwFUf8qBMA8mzlJ75XCM3g3DhiE1mh/akoK0p5HqB4Ow9CXec+JQMDdwYv4f2dBf
         LA6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793041026; x=1793645826;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bWlVFKk/hA3IhLifvlVvVb0OqBSStw22ybdS81uZBv0=;
        b=Z8hzDCZj3ETlK6JtB3DBz5e00ZYWnD9++d1huXYPmJ4zD396L2ZPktMMu8SrNwq8Fe
         ue7TDHUR+stpGYnM7agUdhYyVtSNqagWFmzL5krYolipCLvc/J9YGavEIMEzqTmkfuZa
         6dSxaPuWb7ExqYS5x/n8DqVlyRGGLGqUjlCbpQ9Hip5jy5QNDTBxWsmOul1zfIHf3OQN
         e8Mfw6AebJV6IN287uG2YHFOTTmoGFP3k5SyBfXGEYV19cEKTtTTEMpAPZsQI7zj+xfF
         isK8i8tLohGqvWlJdDTzFBdaJQdfDFgOX+C+BCnfjd6jeEQtPijUXSPRPxU8eZIrm2Ks
         scpg==
X-Forwarded-Encrypted: i=1; AKwUvByLQSFN64htDZMgA/54aV9P41nlmAPLBupMQQxAoaApdyp5xj+h1+kDmH+TK/9E8u+yzB24bz2wX4DRt3Q=@vger.kernel.org
X-Gm-Message-State: AFq9FYJZhYM0zaxauBFJQ0TIQRReyUzp7nrHVgjb5ygpugVySPFB5PUh
	c0bPZa7XWVZBh3k59I1v+S58E9+dowGSFjQoIRj5ylqnfTGmgtICRmqHUNZjG9LKIeu+xAm8nON
	eUh03ep47qt8I8ZdYSGsK91XQPyb6ogSlScIfoWDQIYACbqGUlS7ol7xHtnWKEU239g==
X-Gm-Gg: AYBFou15xB3XhLoZ5ohVWFLVTsme2S147LSy/IxUzrQ0/CmKvf70e4XgMH2CDLbVRNp
	FEoMwgVWZxPnb/I1JPUKpWMsgzBbKsu9HGh6DOO9P3QWBMfjMuVUNLYQylEGq0CR8kucO/NwJPh
	MjSpsM9WyS4N4+tCzQFq7SpaPwPqhujmJNS0dlMv5fDU1KuVkjI08+VkdWTMrFAPM2/1yai7fZG
	5qYHY1pGREmmz/w6CPAMRaS8RtAgqFX1MRkJlNVdTUW/dAZKPGVT5J4LL1sQCM3CtvhOz8MqqEu
	1jS096YALVazPeMAmYpsA3rherYd4L3/N0zMZN+psrkOb7ius/ofu636DPlcKPhIUQhw4lYqofs
	vMVC0AtstFD5U/kqzBaYmZ1ituGWqoZauFWZAvOmNbitVDNGvRjzv3JrSEDB2iBoPWgnlZyiCrU
	bJpKPpOyRr9GfshUW6YXMtzg==
X-Received: by 2002:a05:620a:3714:b0:93f:c3d:7bf6 with SMTP id af79cd13be357-940ef7d3964mr1197184185a.6.1793041025574;
        Mon, 26 Oct 2026 11:57:05 -0700 (PDT)
X-Received: by 2002:a05:620a:3714:b0:93f:c3d:7bf6 with SMTP id af79cd13be357-940ef7d3964mr1197179785a.6.1793041025086;
        Mon, 26 Oct 2026 11:57:05 -0700 (PDT)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:aa2b:ddff:fe88:da74])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-940f0a9720csm765520485a.42.2026.10.26.11.57.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 11:57:04 -0700 (PDT)
Message-ID: <698f6e4ff260d9480316c68ea30a63af05c936f5.camel@redhat.com>
Subject: Re: [PATCH v4 0/3] scsi: target: iscsi: fix stalled and doubly
 completed aborted WRITEs
From: Laurence Oberman <loberman@redhat.com>
To: Bart Van Assche <bvanassche@acm.org>, mkp@kernel.org
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	mlombard@redhat.com, michael.christie@oracle.com,
 linux-kernel@vger.kernel.org
Date: Mon, 26 Oct 2026 14:57:03 -0400
In-Reply-To: <ea77fa74-3290-4685-b1d7-24c45ca1286c@acm.org>
References: <20261026150710.1063511-1-loberman@redhat.com>
	 <79480408-8403-4a93-a2dc-c5f01864a20c@acm.org>
	 <8d705915480f6cbe6a1b37c2cd06eb98727b3207.camel@redhat.com>
	 <ea77fa74-3290-4685-b1d7-24c45ca1286c@acm.org>
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

On Mon, 2026-10-26 at 09:47 -0700, Bart Van Assche wrote:
> On 10/26/26 9:12 AM, Laurence Oberman wrote:
> =C2=A0> If the guard is one-shot across both, a second call that would
> have
> =C2=A0> taken the CMD_T_STOP branch is suppressed too, and I am not sure
> that
> =C2=A0> is safe -- a suppressed complete_all() could leave a waiter in
> =C2=A0> transport_wait_for_tasks() stuck. Should the guard cover only the
> =C2=A0> CMD_T_ABORTED branch, or do you see a reason it is safe across
> both?
>=20
> Please limit the guard to the CMD_T_ABORTED branch. The only things
> in
> target_cmd_interrupted() that must not run twice are in that branch:
> INIT_WORK() + queue_work() on cmd->work, and the
> transport_complete_callback() call. For COMPARE AND WRITE the latter
> releases dev->caw_sem in compare_and_write_callback(), so calling it
> twice would release that semaphore twice.
>=20
> The CMD_T_STOP branch doesn't need a guard. complete_all() is
> idempotent and t_transport_stop_comp is initialized only once, in
> __target_init_cmd(). Suppressing a repeated complete_all() wouldn't
> strand a waiter either, since the completion stays done. However, a
> guard shared by both branches would be wrong for another reason: if
> the first call takes the CMD_T_STOP branch and CMD_T_ABORTED is set
> afterwards, a shared guard would suppress queueing target_abort_work
> and we would be back to the target_put_cmd_and_wait() hang.
>=20
> Something like this (untested):
>=20
> 	static bool target_cmd_interrupted(struct se_cmd *cmd)
> 	{
> 		bool queue_abort =3D false, stop =3D false;
> 		unsigned long flags;
> 		int post_ret;
>=20
> 		spin_lock_irqsave(&cmd->t_state_lock, flags);
> 		if (cmd->transport_state & CMD_T_ABORTED) {
> 			if (cmd->transport_state &
> CMD_T_ABORT_QUEUED) {
> 				spin_unlock_irqrestore(&cmd-
> >t_state_lock,
> 						=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 flags);
> 				return true;
> 			}
> 			cmd->transport_state |=3D CMD_T_ABORT_QUEUED;
> 			queue_abort =3D true;
> 		} else if (cmd->transport_state & CMD_T_STOP) {
> 			stop =3D true;
> 		}
> 		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
>=20
> 		if (!queue_abort && !stop)
> 			return false;
> 		if (cmd->transport_complete_callback)
> 			cmd->transport_complete_callback(cmd, false,
> 							 &post_ret);
> 		if (queue_abort) {
> 			INIT_WORK(&cmd->work, target_abort_work);
> 			queue_work(target_completion_wq, &cmd-
> >work);
> 		} else {
> 			complete_all(&cmd->t_transport_stop_comp);
> 		}
> 		return true;
> 	}
>=20
> Notes:
> - Please use spin_lock_irqsave(): target_complete_cmd() may be called
> by
> =C2=A0=C2=A0 backend drivers from interrupt context.
> - Call the callback and queue_work() after unlocking t_state_lock,
> =C2=A0=C2=A0 like the current code does.
> - A repeated call in the aborted case must still return true so that
> =C2=A0=C2=A0 callers don't proceed with normal completion.
> - Please describe in the patch description that the second call is a
> =C2=A0=C2=A0 no-op by design and that fabrics that complete once are
> unaffected.
>=20
> Thanks,
>=20
> Bart.

Hello Bart,=20
You always take the time to help me and I appreciate it very much.
I am following up shortly with a V5 that I think addresses your
concerns and also limits this to only two patches.=20
I am back-porting to RHEL9 and will get it tested the same way there
too but I expect it will be fine.

Thank you
Laurence

