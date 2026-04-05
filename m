Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD8E381AE1
	for <target-devel@vger.kernel.org>; Sun,  5 Apr 2026 23:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775432651; cv=pass; b=ZG1W2+bnwg3Iv+FjqpVfA+25GcpHasbkMKPIxK7qmkt0ojweF/ioem286eC2bjxj8FrC86dYoc7AtK48Cc49/TtUjZmTT6ZCECyctSY/4+DS9yR7J+PM0YC83qLox4w76WgkmEcXOvuzOIKmzUDVYDSiX2SEzjjEnkmkVMzoAgg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775432651; c=relaxed/simple;
	bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nBLAkqb/noA+Y6zI645v1MRC3GDlW5d1hIWATGivxgjV5KfdGpGTNXPJJOiVfxMdhE/A/L/iovLXlMqPjB8aSuupNQQTu7+1uB3ioiv5OPvB7nuJtu5HTqsHSZuksxfb+JtSw7QZueTiWgo+vAUpUA8fo1PsoHfwZV71uiEsLhE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KRy7bNIt; arc=pass smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KRy7bNIt"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-66e8cc714fbso2134125a12.0
        for <target-devel@vger.kernel.org>; Sun, 05 Apr 2026 16:44:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775432648; cv=none;
        d=google.com; s=arc-20240605;
        b=AlNuC1/sU3ZF2GauYGGnoDV0hojWTO430rsTt6jkgA2GSQl10vXINPwrZA5HjjZ2p3
         tQBUI6PjssZQFpjxH9b/f0U4QeXZ8ViXF2lD2mn5oj/SC9QXj8kUjoaUqAAwNASrCgeI
         ky8GDoGP3VVdaH62gG3GSnHLHy2rO7SvzanYwrBxQSfe3/HiDaSZL1PL/PgrN3rup4PX
         UJtjHv1dqZRXPhDNL7aMKjum7xKS+16eIQo1a4PsXveZiCm6t/3x7X8tQ+rfTd8SR7n1
         klVZpFiOeseNrATDbQ43RP+yFF1B2f6neQQr6zm5yd7pbR2Gyloztp/IyobqlY/ylfUc
         +/kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        fh=qyTlRled3SVdXro/fLQKzLce9WnHyj0yenrcoufF9CI=;
        b=US9skFw3hC+cyEqTgIxFKd4ysxmw/Q4HTm4sM/Rvd6Pa115NlcquWgaPwmh/F2SNrN
         A8bBs50VksZ+so8LXx1ImWR0QzvZjE8e8EN09kfiZOm7RVoqd4iIpBwkzXCoEuiioc6h
         pdw1tbSCypWJkglO/IPqVpd4THGeQ03Vx5d9K5lgc6wPNFndIwUQpRMMEnw7qONu3P56
         Abm3CJUPG5PpB7nGeNxuofngmyB7Ag5RzWUu4VYyojUyW6/jQjjQxtL9fTNDbI0OI1kd
         1G+cTVT6vvMhoxRW+rwDFXpbUEefRqu9iMB7YUlOPJGKT2KHkhjPyWWWFFEtEGJ5U014
         o8dw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775432648; x=1776037448; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=KRy7bNItuCMjRdhQoDNXmvbrUzsJ/EQuIgectE/2nVrOvHXbxXJ7Qv8UgDHuYfkY1/
         vHf7uRCN0nuZrK5x0OMSNHgPQTpoccJlPwNv9HFLWDmhlARIhVmqRciFrzzDYxifwjL5
         udsGHiQPcPEKcVvraB0avyXDnTsGkpXPkjR+o+kHz/vQ4bGr1wHD4nFPVdU4+IIFachM
         XjFYJoBIkM7dRlAz/LiL/aMthXyxznCmQ6myhdArXSmod+VOkJEP6gcfOXt/JfrPbXdO
         v3WEPlCuKnDFA1J7jZnDHld6xjg2nUtv3ZNb4p2TuBJWNcymrz0vus1KC4orXYifThNO
         ga3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775432648; x=1776037448;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=AI+4TTzsgx3kAlaZzW1MkQOhTmBudo1f5VWE/+QIFlLZfWG81ne/rJ+Jz0GWiWTl1v
         PFuuYnI0ji1+6ESNWDpAy09ovHv65zUgvxZdvDPWhJpC5I9U67cw7gzEaRuZNDwUC6n4
         HINPJh0qYkXHn8xwSiyEhDknxG+1RgUluJ81b3D7QSmdSk3E+jXeOKrKwy07ncsAIJbn
         xszCcSa/Pd0NEIhl5z0SvYKaKIQpi8MHLzfktDBjHoxWGMrwVXRel0jnQ2nSzozh5jVD
         NXa9Pae93tdqzbnS5QsPwfIKCbWjOmzO0KrlhkqEWADLNgnUz/AL/3mV6qZtKFqGe39K
         TPgQ==
X-Forwarded-Encrypted: i=1; AJvYcCV/JbvAlc5TAOPbr3O/x8kZb6Ro4orP7EjagWFcetmq6XxPpWzgFadBsODWVSDB2i9vwT9EtvPsYnCXzYA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHnmQfr2Z1txTZrIfHg4GqdRaqLrvX+BAxO2Uj8Z+0EnqSZn3j
	kaQYTjsvCBzqIbvmK65L6zNTKWVDEhSShg4UD/byANAGe0xZhojj9Mq0MwoyGnjvad5uVlXVfUa
	03NklJ5afpBvlBPPKhoL3NppLXRI/oQ==
X-Gm-Gg: AeBDievHStLbY2f3Wc8grO4RGIGesl+0to+hkQUbZ5NJLuVA7WMYvCGElSFRAjZnGZM
	ffg4ePmXHD+2oXLOtZak2U4P8Ck+YMnHk51GhbEZ5jCj5cFI6vOv9DCKS/CHM0EpZJW30HNSZAd
	BT8VyzxjCiFNcNVZ+h3K/F0pXr36mMHuqtQIaL5uI9hGnD7EqxWE8LJaiXvZCU24i4CRXIImfkt
	kJF3AbIzmn4PHF+bsbN8TKG189Fqcg00danXMNHmIGdUiEM5DT772waw1xMbSIrQsl/RbdXBGcV
	mQdDe/NRJ4ksxDRlz/r0/eah5rVLnnDbgoWn1StXZCIxBhNsadOgTiRXEZPxbIGIjn/vDQ==
X-Received: by 2002:a05:6402:430e:b0:66e:f4c0:c365 with SMTP id
 4fb4d7f45d1cf-66ef4c0c656mr717744a12.10.1775432648191; Sun, 05 Apr 2026
 16:44:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260403194109.2255933-1-csander@purestorage.com> <20260403194109.2255933-6-csander@purestorage.com>
In-Reply-To: <20260403194109.2255933-6-csander@purestorage.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Mon, 6 Apr 2026 05:13:30 +0530
X-Gm-Features: AQROBzAe_pR1JdvPMRMED5Vbpy-Io1YSGKtG2B-bIRotwUzCJw2tWzJbmfKAgHw
Message-ID: <CACzX3As8NN6n3uCvOPhejzZCs4fTnXkohKvZw787+OyP=tpnNw@mail.gmail.com>
Subject: Re: [PATCH 5/6] t10-pi: use bio_integrity_intervals() helper
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	Chaitanya Kulkarni <kch@nvidia.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
