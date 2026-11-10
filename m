Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794314342;
	b=ByMlyCfNZWnwAOvT+7yaZ04y0Gul0R7EoMwT05MDazljFVcvYEQX09IKXjoecNVhgqte
	 gjV1TTS93V+0bJgZR0BkiRZySeTZ4n7ffAeLonEiJMaTWa4ju0NUHj1QBiko7MSLgmt96
	 FQQK9y46MaZmZ3O7v1pJE7whn3QmcqgkZUsUxOYkRi+cZAdmwQ9Br/H1Th0oVgvBWPWj/
	 Voi5jB8oIOfPtedy8AqwWWbmef/UodVUK8+WJp2ndN614OWRrk81iOc+el4dBOubUPGWP
	 wKhPHyZFuDi2Upal4dQWoB7nU2aNJF4zg7/kVe7Zs/PVGKJvMdA/Cfcxi3WoCn5uDmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794314342;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version;
	bh=8B6P+nC3/DhYkZRyIwUpOtQEzwhLB9wHUHWGEVELp1w=;
	b=hH5oqvX6gYG/LEIpodgOTTy8/4izSY0isUyo6sXw5CzYjSwdJVdFcqc0Dr65t2nLs3Yh
	 qzPkO1mHMZccGESPJjtb44ILKJjzBJQ/AI8ymk5DWe0vbO/Leg1cwOwfqGfFF0sVfvtk5
	 LkGfLxFekyvedB/uZQcPv4dZxG/c8yttFao6zweTXUN86rDRvnUwekNfx/y0s/M1lKnOd
	 CDd7UEiPBfohOX6BnUtL6a7hV7uC33kk6K0Yh418vKyMgSejSc+PuhAz/bN7rqRKl72Tu
	 qi5Yyiv6TCo2y9dH7koqxwqenBYtrNu2KJs7VfyUNme+81z0za50VxG7T9dEIXBC+VA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=VQJg7ekj;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=myY2LugO;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688AD606A31C
	for <target-devel@vger.kernel.org>; Tue, 10 Nov 2026 12:39:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 688AD606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=VQJg7ekj;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=myY2LugO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794314341;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8B6P+nC3/DhYkZRyIwUpOtQEzwhLB9wHUHWGEVELp1w=;
	b=VQJg7ekjwyrKDFGl+vk+EEUkhTInjylkY3tbJyyyoawPyz0WFJw6xc8Mxofo7hTeWHO2u+
	dU2M37/MXoXD89lRiXQuB7dp46aWf06wgApwrM4p64FYaGZ2bOe2IMCRDoZb14xrv+fga2
	wwtJ/xeh0KTsp5XU69oOrOxrS959VUc=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-423-_9caTQLHNwWkHkBzN1p_qA-1; Tue, 10 Nov 2026 07:39:00 -0500
X-MC-Unique: _9caTQLHNwWkHkBzN1p_qA-1
X-Mimecast-MFC-AGG-ID: _9caTQLHNwWkHkBzN1p_qA_1794314340
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-5363b06bcb2so43030591cf.2
        for <target-devel@vger.kernel.org>; Tue, 10 Nov 2026 04:39:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1794314340; x=1794919140; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=8B6P+nC3/DhYkZRyIwUpOtQEzwhLB9wHUHWGEVELp1w=;
        b=myY2LugOZOapQLXruA++AQfKXzuHeWuZNBFUn0528th/tKzDrjD4WTy1FGOQz0o+9Q
         WLsuZkRgnqM/w9fJZMgyZqiqstkoBURvVWzfpoRLJxQHlgWNG+NAnIpeROIyOBznY/Xg
         DlLhzxlRjjtAC6hGAPDuuQAFCi2rP8/3Pwee5NKeYLsruPOo5aOKPZllZc8MvtGNKiQ2
         6grgpM5N83vMQgI78GQvK2HfpBUpM7XPT5VnBoHoCAwadI3kCIGOBTygCzR1NmUhotxo
         4OPDhtzXKvdWatuLxQ8NOFKGaWlDmgUDp9DoYoOKExE1PkvwRSyFkL1H3xF6mOT/1xxe
         DPjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794314340; x=1794919140;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8B6P+nC3/DhYkZRyIwUpOtQEzwhLB9wHUHWGEVELp1w=;
        b=DF090TGYjjJekrO1wzkMfxLXdAjRWnG/v5HY+Vh5wtWUTU1nZ/DDTpkLjF8RO+FCAK
         XpoQqwHf3ZAxg1cLLL6z9oyo+f/YNU92XA9EBD6dPE0btozO+Fn57cR+AhoxEYzMEFrO
         NVkk+o7Fe9KWqKozMjBadCEWeJLiO216xobSsksh5aVJZ/lq1a8RYV7W2wMXCgM75zCv
         NI03VP2aX9TjwCciZbk3t7zYgYSCshZWXtzyCjraTb5ZTNvn6RKTyvKVK7wbMls06Jum
         A8TqrksLalSKPkxi5M9zGr580gD81XR7E9s3flMXl6ffHA1T7ew2QIEE7wRcXUwjDGc5
         B8FA==
X-Forwarded-Encrypted: i=1; AL+hErEkufFAOBy+yX2wU8V7IxzzQKHRgsZTDR9G5EOdJh7TRrOVikotUR+Qt/x89Kv86zJmXje7auMyYDkIy20=@vger.kernel.org
X-Gm-Message-State: APuU4Z9cwvi3VeG6/BZfxTsC1uUvVs1dBXtDBfqLnnXCb6jCYbE+595U
	aEhvGGDdguxSTmNSiITeAD1n4ODqcfwoe9TQYyuwBAm2Bmee+w86s3FFQgUzVSU/4faLbACE/3q
	5wd1QTxPtaq4RHdtWqn4BS3XfcCHG017wp8kKYzgP0jK4Qjhnl3W+gka31U1RsYxwng==
X-Gm-Gg: AYBFou3nNtXSRbThRUJn0X2E7jLyn2Dvg1KYfa7nI1faiw2l2iQYjMQCtg1ArvM1rkh
	+8y5ecP6g/hACxmHAGhSWYVtx1iPJr4QVt0d0RYE/1HahmdaNs9WZcvcrGJ+FFRVJLDMd/mJO4F
	pLHlTyhP15KvRRyIwiT8D7P0J6PE7Pinr4w2CEsXTlJmMlIO5NXCWQMShqqGVQUv6aj02bec/dT
	bbW9+rFvYwNI5FeaQSWSsbd+O9aEuWsT4GCf/Ex7lpLdzxH5PgXoNWfB+eJXPOfxriAGTX3fVSj
	cfgGj7oKFChvrm6hfNy7LUYa6fZwmH5igrEkq4FuLkt9FyihpC9S66QtFuJsapF+82+Ge26nyGD
	L35XFZURB9OXRAIM4bk/F5pul7lccFl+k3S4ZdOdMHe7j9LMIBzL5N65/iCJ7D4Rt+YrWrnWyHv
	teiYcXPd8AnwFdFbhDCx5100brJK0n5DAbDvzrtgPdI0MHiS0HugEplVthGApazCrfTOM+VaI=
X-Received: by 2002:a05:622a:343:b0:536:725f:588 with SMTP id d75a77b69052e-5552b93e67bmr33006471cf.76.1794314339392;
        Tue, 10 Nov 2026 04:38:59 -0800 (PST)
X-Received: by 2002:a05:622a:343:b0:536:725f:588 with SMTP id d75a77b69052e-5552b93e67bmr33006111cf.76.1794314338725;
        Tue, 10 Nov 2026 04:38:58 -0800 (PST)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:aa2b:ddff:fe88:da74])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5550bd33340sm22952721cf.21.2026.11.10.04.38.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 04:38:57 -0800 (PST)
Message-ID: <4a028851191efe6a45f746bc65754a50503c330b.camel@redhat.com>
Subject: Re: [PATCH 0/2] target: iscsi: fix hanged WRITE_PENDING commands
From: Laurence Oberman <loberman@redhat.com>
To: Maurizio Lombardi <mlombard@arkamax.eu>, Dmitry Bogdanov
	 <d.bogdanov@yadro.com>, Martin Petersen <martin.petersen@oracle.com>, 
 Maurizio Lombardi <mlombard@redhat.com>, target-devel@vger.kernel.org
Cc: michael.christie@oracle.com, linux-scsi@vger.kernel.org, linux@yadro.com
Date: Tue, 10 Nov 2026 07:38:56 -0500
In-Reply-To: <DMPRS0MF3KC3.1H1C97P5ES18@arkamax.eu>
References: <20261027180123.13163-1-d.bogdanov@yadro.com>
	 <DMPRS0MF3KC3.1H1C97P5ES18@arkamax.eu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-3.fc44) 
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Post: <mailto:target-devel@vger.kernel.org>
List-Help: <mailto:target-devel+help@vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:target-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Sun, 2026-11-08 at 11:50 +0100, Maurizio Lombardi wrote:
> On Tue Oct 27, 2026 at 7:01 PM CET, Dmitry Bogdanov wrote:
> > ISCSI has some old leftovers in the code that prevents passing the
> > aborted
> > command to the target core to make the actual abort. Such commands
> > hang
> > until connection is closed.
> > So remove those leftovers.
> >=20
> > Dmitry Bogdanov (2):
> > =C2=A0 Revert "scsi: target: iscsi: Fix hang for aborted WRITE_PENDING
> > =C2=A0=C2=A0=C2=A0 commands"
> > =C2=A0 scsi: target: iscsi: fix hanging WRITE_PENDING commands
> >=20
> > =C2=A0drivers/target/iscsi/iscsi_target.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 | 19 -------------------
> > =C2=A0drivers/target/iscsi/iscsi_target_erl1.c |=C2=A0 8 --------
> > =C2=A02 files changed, 27 deletions(-)
>=20
> Sorry for the late reply, I was on vacation.
>=20
> I like this solution and since Laurence tested it and confirmed that
> it works
> then I am completely ok with reverting my patch.
>=20
> Reviewed-by: Maurizio Lombardi <mlombard@redhat.com>
Hello Mike,=C2=A0
Gentle ping for an ACK for this so I can move it along into RHEL.
Thanks as always
Laurence

