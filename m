Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793018669;
	b=MGKGPTqrrNAWpw4YxTR36Y1au7lYkuHwK7cTI3u5viUqrSnTSS6wa7+J60IC2Ytt9m83
	 WNap1yyaZFTOYqEv3mj4cKw8FYcDJFpASGZtwUz3VVpsxti+8c7Czk+ceDRN4KFJGVeN6
	 ARygZfakuVgvAxBgw6Yuoe5Nh3IZiwH/Q2rLOOzXQGe7GmZQMT7nheEsVSJJFFLIi5oeF
	 yWHQ95iOdnViliU2n0r3sEAJUkqEWkOgKsZwShbNxREBPNsp9JJCdUVlpreLhecye3cCn
	 e34AW5HpQyC5tcODc7PuQFldxzp+UlweqkawyXwffoYOBcC8KxJlBfHVM4l3BS24lWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793018669;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version;
	bh=+Wq76IOoqC9Xs53xPZFbGa8lUXZBI88ZO79pfXsG86A=;
	b=YPkaxQ9E6mReDMo3PwWlS5Kewom9OQBRENoIz/EV/06dbz24xMRBgcmtSMwMPVtqHiM0
	 L29n9NiEPrHLxdQwVgEzO+iDGoPXw6FyfXYDuzsKQnWlXmUPDDL+6fA1OuZ2j+aL1Rm2b
	 7As1IwowU4EnUN0AXmouA+pDDHA3zdOeQTObJVeIrlgE4PyynisJLzwuOL5v1x4/zxVVV
	 nCAzpvA+56ovuBLCHKAxymFVBDBPCgPxAEhH+1NzqAcunQbUh9yavIip4mr/WgLSSyhJE
	 8ih7kDcQpKqoxLjBrDS1a+MzMTB2RjuXQPHWsv53NEMjJDNiWsxhgj9vwxqc7xrYlfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=NILu7kjf;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=JqSj1Kw7;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB147606A326
	for <target-devel@vger.kernel.org>; Mon, 26 Oct 2026 12:44:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EB147606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=NILu7kjf;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=JqSj1Kw7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793018668;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+Wq76IOoqC9Xs53xPZFbGa8lUXZBI88ZO79pfXsG86A=;
	b=NILu7kjfL3DtN8jfwCEWfd65DzzHvECYIWOFer2qqC27qlWEbTAVgq9Pq7jWrzYi/WcECk
	EED6Rs6JBu/sSLG+Yj/mT5Mb71Sfen9gtrdDGHRZfyChQ0UyiLgnSZCnR8j1KnfNzNwQIZ
	JHMGSqUTbe/SXdG+KBUPfRbwnEDFpwY=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-633-C4lAA8GfOAa9nh3ipzKw4g-1; Mon, 26 Oct 2026 08:44:26 -0400
X-MC-Unique: C4lAA8GfOAa9nh3ipzKw4g-1
X-Mimecast-MFC-AGG-ID: C4lAA8GfOAa9nh3ipzKw4g_1793018666
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-535252004e9so63642731cf.1
        for <target-devel@vger.kernel.org>; Mon, 26 Oct 2026 05:44:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793018666; x=1793623466; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=+Wq76IOoqC9Xs53xPZFbGa8lUXZBI88ZO79pfXsG86A=;
        b=JqSj1Kw7P+a4kQQ3sVuHoaKXaciUwav2HfMVrw9DryU1sm/MM9uQ7gZce1tZEbwmON
         cuBFEeJ4Wor6J2hWEVxZ5+a/lMQ0WqjhalBONLnLzDKaE3LLyWS8CiOPpu7Zrh0cAzNC
         CITjrznqmgMLv03evOgYekovttGwYwd8LUb5dbsaI95ZlQVGXSuOuodSlbGW5wkzP0Lm
         3yuu18LGe06xEn5fHMMfhHQ1pDKXRla0cdsqs7h/SEutvMY8mLcyZr+Nobwo3AW8ipUb
         tX/9a5tnscbtfdR4nwaVHrWJlsoWTt03NWn8vmAjv0ALrqsUm8zrfi3gcCWZmH17yb3X
         hQGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793018666; x=1793623466;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+Wq76IOoqC9Xs53xPZFbGa8lUXZBI88ZO79pfXsG86A=;
        b=YOYNMwbVMczmF46qp3xqOVSNd0a0IGRoCQjpDDiR4Ak8t/txQz1erwmwC6vJHe77ea
         jgbxG2yu8sJqlKLHO6WYGv/pluxQTtq2N9WdO/vM/gjMIu9v9HtlMWZzDBMBWD9USj9Y
         bCDUBjMuW/v1pzYpfqJlziS17T1YOIiUTr5eVljmvxWItj1bCtzgVZz0lQdNc3fAG0Fd
         F9MKTxf0ktOy9IS+NflYmIXMjzQTX/gy1PKwE3SI+oGb7gtgqEMZ+p6lvPCKWP3b6Wu8
         wqani2A27JMhtztf8wZDkeECBTtSliuZ5mbdbVxqTV4m2sfka8F88UOvlihU20g/vM8h
         UDcA==
X-Forwarded-Encrypted: i=1; AKwUvByYJ4xS/3VXhnwfVO2nqAPmDqsEkOXuxVV78XfwiTEXaIomEq3A+pVN9sTbrrT9NnEli+dz/eJYfbST3ZA=@vger.kernel.org
X-Gm-Message-State: AFq9FYK63GO13w+pNTeIt9yn94GaiGJIxXgCuMVT+zzJ8jOF/yRVtS3f
	7GRKqDbVzGZlLZOtq4O1GNgoHrXPig5vtjicRw0qQRCqHmf0Dm+u2UeLi4egwypy2F694jHwNe7
	n6nb7WUbPCX8QI2OaAOtOguruILrqVo7sOH9NZmn7Np9ZO4b4rROlqiYlNY7H8wAZJw==
X-Gm-Gg: AYBFou0UIULU8dF13sTHEd3nki1k141eAIM6yoJBf+GYi0RWYcaVIBireQm7gPRZNoO
	X3RTeeUcv9flktg3Q8bDI82pF2Qk3qSrTCO+Na8XAeBE/q76vGezwaxztgI8mQNh0eML05EBPQX
	vFCPZJ9SxmhkF3rqm1IfLkixTkdrWnJcAF3I5fMlim4TYzYHD/2QDw2PqRpux4EtmD1bL1HUpGH
	C7xsjE4ZVGBZ0mjeplJ9pN9/m9kWErRwdlc2gXbb/G2zxrEiK/mBJRgt6l+emy09+kfqu9ISro5
	Vu1wcGcUUyzImFefIexKBJQjLIHSG0pHS4fei0Ukm1k3mJTYsnKWv50j+jx4uvUAtSiJPhzEMUZ
	WxYrWuIINkXODHt9BY8arPHb0J77N1S/2gEVN5j/z1qBAnDkDw+uOyxJLsosYiY9LCEWz68BQVS
	xZXA/yMEi+7TXvlWfi/q0oQw==
X-Received: by 2002:a05:622a:578e:b0:537:d4b4:3617 with SMTP id d75a77b69052e-5383b36f9c1mr95685761cf.6.1793018666197;
        Mon, 26 Oct 2026 05:44:26 -0700 (PDT)
X-Received: by 2002:a05:622a:578e:b0:537:d4b4:3617 with SMTP id d75a77b69052e-5383b36f9c1mr95685281cf.6.1793018665567;
        Mon, 26 Oct 2026 05:44:25 -0700 (PDT)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:aa2b:ddff:fe88:da74])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-538394f82cfsm53606071cf.13.2026.10.26.05.44.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 05:44:24 -0700 (PDT)
Message-ID: <bcf0cd314f3c4f061a02c802f0ea9ec4b6e25cff.camel@redhat.com>
Subject: Re: [PATCH v2 0/2] scsi: target: iscsi: fix stalled aborted WRITE
 commands
From: Laurence Oberman <loberman@redhat.com>
To: Bart Van Assche <bvanassche@acm.org>, mkp@kernel.org
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	mlombard@redhat.com, michael.christie@oracle.com,
 linux-kernel@vger.kernel.org
Date: Mon, 26 Oct 2026 08:44:23 -0400
In-Reply-To: <8a702a89-ad21-425e-9850-d9771fcf7c31@acm.org>
References: <20261016175351.126373-1-loberman@redhat.com>
	 <60cf407142a0663a811a2ccd64cf387cb71808ab.camel@redhat.com>
	 <8a702a89-ad21-425e-9850-d9771fcf7c31@acm.org>
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

On Sun, 2026-10-25 at 09:40 -0700, Bart Van Assche wrote:
> On 10/25/26 7:43 AM, Laurence Oberman wrote:
> > Gentle ping:
> Please take a look at the attached review report. The report has been
> generated by an LLM. As known LLMs may make mistakes.
>=20
> Bart.

Hello Bart,
Thank you very much for using your LLM review this. I am following up
with a v3.

The report was right about the one thing: the claim in v2 did not cover
every site that completes an aborted WRITE_PENDING command, and my
answer to the Sashiko review wrongly assumed=20
iscsit_check_dataout_hdr() checked it. The upcoming v3 adds patch 3 for
that site and patch 4 for the DATAOUT_SEND_TO_TRANSPORT path, and the
cover letter corrects the Sashiko answer. The comment reword and the
patch 2 commit-message cleanup are in there too.

Two things in the report are not correct, in case the same tool is used
again:

d5869dae5080 is not confined to 7.3/scsi-staging:

  $ git tag --contains d5869dae5080
  mkp-scsi-fixes
  mkp-scsi-staging
  v7.3
  v7.3-rc2
  ... v7.3-rc7

It went in via mkp-scsi-fixes during the 7.3 cycle, it is in released
v7.3, it carries CVE-2026-97951, and it is in 5.10.y, 5.15.y, 6.1.y,
6.6.y, 6.12.y, 6.18.y and 7.2.y. That does not change the conclusion
that the gap belongs in this series, but it is why patch 3 has Cc:
stable, and why it may be better taken standalone for those branches,
none of which carry patch 1's helper.

It seems aaa00cc93c1d is yours from git history.

  $ git show --no-patch --format=3D'%an <%ae> %ad' aaa00cc93c1d
  Bart Van Assche <bvanassche@acm.org> Tue Nov 27 15:52:02 2018 -0800

It is the right Fixes: for patch 1, though, and patch 1 now carries it.
git log -L on that hunk shows your commit replaced a
transport_check_aborted_status() call -- which sent the delayed
TASK_ABORTED status -- with a bare CMD_T_ABORTED test and a return.
That works where the core can finish the command itself, but a WRITE
still in TRANSPORT_WRITE_PENDING has never reached the backend, so the
core's abort path is itself waiting in target_put_cmd_and_wait() for
the fabric. The other three commits touching that hunk since 2011 are
cosmetic.

Thank you
Laurence

