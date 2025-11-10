Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41667234964
	for <target-devel@vger.kernel.org>; Mon, 10 Nov 2025 09:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762767976; cv=none; b=q1bCXNy2dVRkKENyCwnamZy4PLSRdBzfz43BdysVC+8ykuO74jbwWPx3whnnT5l2Jvyh2Cw9IE/wAPBR2kfvgyAB0LlpVvPU+rAg/wGOOTkTtn6truUIreb1b3FMTjN9F/Ih8+ZkSDrfKmq2Dhr01r/NHTnR8g6na7ud/Z9XfpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762767976; c=relaxed/simple;
	bh=G8FyUb4ahZ5DaUZfNRANTrYRf6oD8kdXRJpCHUd06PA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QcZ2wQ/kB3PKTVVSbc6TBhkr2dYzxBfuXP3lh1lfnLrlnUFZwC330076wSTxa+xJQLGO5wz/iD36uSZt3dCXYXmy/kPPgiWhrJMl8vz5NOnevowbDqhZb7f/9iFGYqzerRaFHgQon9Mt/ME4fn5uU6FJ6yqDWwSb5DF42oWUnYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HYTErRMq; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HYTErRMq"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5943d1d0656so3568477e87.0
        for <target-devel@vger.kernel.org>; Mon, 10 Nov 2025 01:46:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762767971; x=1763372771; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GaXS6m3NcTkH+l9Uwp9vlSWhXICs1XAI8l9sEjUIZu0=;
        b=HYTErRMq42J6I7OM51UzHsne0kRDistQ1SShANn/IFd2+HgUL8BxHoeDnF6jTPOs1R
         oXQ1Hkgurq+ud29XGAIWUpVQ7Pos6R2Hf881n75NrfRkEMUwYttipgQ+TtAr2Mif2FwR
         oZ5tJyQyA7CCdFoB9tj05yWMpRz2ihTFTyO8lkEY53ONb53XWZj3Tp6ljEqPA5y3jnKp
         rDsexGTeW3iurEem1PqFIYUZRVBPU/nGEAgSo9T4f8MxJXTpU54uoMqIiud1P5vivVAN
         XYqGdBy1U4YyIJmYDh99ipBpKENBBE3XYxnUSdq5uTI2LqLtIKTh0fJBb752ma4vv4OB
         QViA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762767971; x=1763372771;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GaXS6m3NcTkH+l9Uwp9vlSWhXICs1XAI8l9sEjUIZu0=;
        b=fRrrj6QzE0MQkvdxu/ImzMalr6Cte+BdGko9/15uFE3ISlZWetxbGHlXFc+WSdpPGY
         98/S+TFGZwWKPF5NWnkL4c/rbma508nb9u89M5qlDfAWFeC1MnIcRXjmdZQO2TV+9k0U
         oyk7GzkaJfZRzeVj/FH3k3nnAClwRQShXxsKIHFFQFqswr+ZnB4FyIFx3l1JTWM9ukuA
         GfTOdaVSLU/9NKpik7SuR4FGpjNFytKINxfueI6tjkQBRtw5xIydAyfJKhin0a41Imbs
         ZFGisVlmqFlS88+wTTvquPXD8CchBWpQLApFJog9QYrDGOJOGv+gM3/tJgy7QezP/PNI
         iLeQ==
X-Forwarded-Encrypted: i=1; AJvYcCX5miTy4AkQIDLuC09i8/yBd+H7x1R8nwfdCwEg1RtTkJ7wV54zrzBhJNlzsJYJirJN0DG2UIEM7HM/KqA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzgiThHWSZq5K0ylrDnbDK3padUFHskQvM7NCMu0ruJt7u7nTdZ
	BxS3AkagQnAcAklff/MBUm4iGA+WZ3hSAq96ifHFQ5ATICbI+pxmWGe9CRvHepV6Xkj1CpZVShI
	dREAWbOetEHovVt6RVWXrEMiRc/yy9JKgFlmJasR2ig==
X-Gm-Gg: ASbGnctaT88HKq4G5A9RZn4evKluv0Pg5qhpWfPKSVOadlGUezlA8hGEdk1xH6p3GTE
	ljOgFmCz0JrpFsATgwszF7+wyYrY3dVS+OlLKrDGkFcHx1Km5JdQoBzisnDwqCcacAuuNg2L9Qf
	Hy2qdteeELza65rTq5+sDU8CFQvKrHDhwYfX7muciZQvbkRdgR4dX7DlhGNUMF7dcV5sm9ONzRt
	oXHBqD45foOWGz2YDLLCci4ZvJQ/jntxRvzeWPafBjRLSKMhl4xlXSP1sgP0grlD5pWPqwi8ZXK
	7zh2zJHC+02fY+3J8yI9Vo/ocNtB
X-Google-Smtp-Source: AGHT+IFl1HIzxhu+5+xHMGe9KG/BTowlyYL1X4kciQxoixfdv4RCOTF+DqBRORHhpwcj1OT/9qYIy2M7s4tgYPW892U=
X-Received: by 2002:a05:6512:39d2:b0:594:339d:8b8d with SMTP id
 2adb3069b0e04-5945f1cbc64mr2296242e87.54.1762767971378; Mon, 10 Nov 2025
 01:46:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251107133626.190952-1-marco.crivellari@suse.com> <176268787482.581844.7324846885016543491.b4-ty@kernel.org>
In-Reply-To: <176268787482.581844.7324846885016543491.b4-ty@kernel.org>
From: Marco Crivellari <marco.crivellari@suse.com>
Date: Mon, 10 Nov 2025 10:46:00 +0100
X-Gm-Features: AWmQ_bnrAuDTTrwaWs2Ag0G5kodCMZnaZYI4o0vDoMUA-msokQy6U766q6ZjZ9Y
Message-ID: <CAAofZF6smnssmFpg9KpLzQH=sxB4bC8Vq0SpgQkrNh8O8n741Q@mail.gmail.com>
Subject: Re: [PATCH] IB/isert: add WQ_PERCPU to alloc_workqueue users
To: Leon Romanovsky <leon@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, 
	target-devel@vger.kernel.org, Tejun Heo <tj@kernel.org>, 
	Lai Jiangshan <jiangshanlai@gmail.com>, Frederic Weisbecker <frederic@kernel.org>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Michal Hocko <mhocko@suse.com>, 
	Sagi Grimberg <sagi@grimberg.me>, Jason Gunthorpe <jgg@ziepe.ca>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 9, 2025 at 12:31=E2=80=AFPM Leon Romanovsky <leon@kernel.org> w=
rote:
> [...]
> Applied, thanks!
>
> [1/1] IB/isert: add WQ_PERCPU to alloc_workqueue users
>       https://git.kernel.org/rdma/rdma/c/5c467151f6197d
>

Many thanks!

--=20

Marco Crivellari

L3 Support Engineer, Technology & Product
