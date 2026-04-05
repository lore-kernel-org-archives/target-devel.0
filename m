Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8493112AB
	for <target-devel@vger.kernel.org>; Sun,  5 Apr 2026 11:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775388564; cv=pass; b=g2r5+QIsWxIUHqPpGbp+vTSJA7CkedGeqv7/e9itesBuV+IXLQEJdHDCjlg98Y4+RUjoH6pGoP8SkGpZYyxwVLbVesSLZhJKAN6ERxLqxFJGh3gx9AIx2vDFMLYOB3N7tevFAuhNpjpF7PgzvdSeuWXFDqjgtItOmQ7twdArX3A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775388564; c=relaxed/simple;
	bh=DShwsFfuiYCMrn3K4etN1h9yvssJ5Zz+2dg4zhc0vIY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NRP0Lh4Osx6Z6bsV02PNIRtQ7gdvEtOilXvt3uMQTc2XCi5N0zupkAR4BtKvxCqQ1Tqf3LaP8W/uheKgc8jY5leCY2esn4ZcfoIU+mgLesyNiDceJQbZf3bAPb8vlQDapqOscRP7l4PP+8I5xmpn7kTU0p+7j6neKTuBznajN6w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JRwA5s6U; arc=pass smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JRwA5s6U"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b9c745e18a0so414960866b.1
        for <target-devel@vger.kernel.org>; Sun, 05 Apr 2026 04:29:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775388562; cv=none;
        d=google.com; s=arc-20240605;
        b=AgZx2J1AhYeX2hwK9S89DotdWF94HBtUL6y1RpQbyST55x7GB2x4m+J8EqMo908fAt
         xK6Em+w8FO/o6tBK4X1tyJkFar5RvhZ1L4DhkhhARHF47TeczLPMaSY6UI+5S4O8YBDr
         UiPsPFGMoispaJBEeFO8BREnQUPOuAWwax/hyN/X+2ohjMZCnyE+nWR97r5QwV3tsoxS
         h9QZ2x+75zpc3XErBaRHP5u1/uQN5xgaoDD7N2PCn40jv86fusKjZlX9Azl5GXab5Cr9
         VQBxFGDJOHwzAeeD1Mmv9rJJG9iQUrcGmEpYstz0oCd+ZFMt0fstz/EM/h9T9wKIvaaR
         U/TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=DShwsFfuiYCMrn3K4etN1h9yvssJ5Zz+2dg4zhc0vIY=;
        fh=xGjkTkbNoHbddJ7w/QHc3DnWXJykwlJCIZKoqoL1y9s=;
        b=GVjhNmIstW0njdHxtZM6IQKNHj7YhNJYzoMeXzr6F3r1yTQX86Bqot0E00TU+pdb2O
         3q1onEPRFzeC3kVTvdzxiIDQpE9sgdgGdGBys5koX2fbV/PG+Ja7DNiTIdrU8OoHTlM1
         DXWIgynRFJCjdMk+fG6YfF7035P+POxxRSIygSdXRHudrlZchByDBiH6vx3MGut9bgAC
         Mu2Rcp/SZmDiCrp4MZbZ/S2lqso7HhhXNNNuUlSAGV+crM6YOLScwFzn57hMSZdApI+w
         ZRkKVKdirhTNTeBo/Kgeh0EubK16suSs65RPOyqFbUaW1jl2By6h2ZrNtMu83ssjHYzs
         kB+g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775388562; x=1775993362; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DShwsFfuiYCMrn3K4etN1h9yvssJ5Zz+2dg4zhc0vIY=;
        b=JRwA5s6Ulbe0lLrICQqrynQmDhtzK61AF5XFyUCmO6fy/fO1YsALAQe9WI+BMKVe3j
         RsUkW72bGHd42EfGq+3Sbg8RWfHn6QYDc9nD5axgVL8VuZM1Rf9ubELQUbqMfuh3l4GK
         AOHbwJHX4oLILy6EySOwINOllVqC4nJdt1JdxAWlHJBaQMAuDoZc7I7LPpVLhkyg0qzW
         cCSe8hLKbtmHjg4l6ylW+RN7yiEzJSpWDssteT7WzIicA3m5Blv7oigqfqeATzWh1cJK
         QgRQGxkbUh/ujn4QA4tBhI3nLBEVABlq8J2TiSwDguWL8TXFEpOm6YH5Im0f3oKSuu2n
         c2gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775388562; x=1775993362;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DShwsFfuiYCMrn3K4etN1h9yvssJ5Zz+2dg4zhc0vIY=;
        b=smS/BE7A15XHTP0g57a/qfLkVIF/pT0rXN0ZSVlt0Vkj0s7WkFVfep0AEgy027UfJQ
         JvorOqsrQCsKNHY3NQpsrK4A5um9bxkAC2q6oeoqNwKogSI+seNNUBie1NkbHu/1cmRA
         uOG2+RsVrxP/nA/wAeN0Nj0jP1Exu6qEMePr2PVpS1VRYef6rWotzic30ytH/ZpT/cBy
         cPajOftxYG7w7NFTa0N92XhIGu1HN+jMCMxJOYqYXiFSuCcl+zxH3Gb2ginIeFMn1cx8
         F0DUXvEvhWQoiB4MzjS4LGmf7w7MRRj1BCMLkgZ+IUIPTDZwpadsaMvsEJBYzdpSkatU
         TYUg==
X-Forwarded-Encrypted: i=1; AJvYcCURi8oaz6btUtzCqi+JTG+H4tIYOe94bXGdTwOs37/3tAOLIytj7Ms1ZJM7xxnARVtzLRPXO0WclEZXdhw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6/t60HRj8hkl6xbDs5hq151JXUL+v3cEgRyEXHI4zShGsc28k
	HarM3BD+hJwoOtWMG+R4DY6xSAd6q75N7aezzm5CbHSNy052TXelJPIJkC36rsc3NBuAvcIo+b7
	WLQQErnjPoIGD4+XGcPnb6k3XpmDZYg==
X-Gm-Gg: AeBDiesqkU4hbkcWvasgLniVpn6pjA6p9fiMOKlJj8xD+DX2U3rmBmmeQ80Jk1OHAD6
	NdcnAdaZ1FxTEclP7HrBpGwoJNwaMr4Y/1VszA3RkBGX//TA7VZTCOSFipI6tlchpMye/bx+VpK
	4Zh4YFsK5y9Sdh4cueyuKan47ggao7bwDPdnp591eg+XxJR4SPuC+88MB6V7DBMWkNBWm2gmL4I
	KjADIIzePfdmrpAwc4pCnkIbsof8+y7XUeJmK4BhyNjoah08dDq26PHEeOwon7SdtUdaysITMII
	Dw3U1qPAQEU3bmwHZnKTRBNC4ilpHL/lmumRyeeGr3kxcWyPxZ3wZDMA7TVafJWXqQ7wPA==
X-Received: by 2002:a17:907:96a0:b0:b97:b149:4e72 with SMTP id
 a640c23a62f3a-b9c4713a360mr613633166b.28.1775388561627; Sun, 05 Apr 2026
 04:29:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260403194109.2255933-1-csander@purestorage.com> <20260403194109.2255933-4-csander@purestorage.com>
In-Reply-To: <20260403194109.2255933-4-csander@purestorage.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Sun, 5 Apr 2026 16:58:43 +0530
X-Gm-Features: AQROBzBzw9s6pxMkbcgpTMX5W8n4QANeXDJvCU5tpcGpnilon7LOxG0WvSR_FnA
Message-ID: <CACzX3At16V+ZLqoWh4UNEJ6p60x94x66HxzTtPUuJ+KWxs4AXQ@mail.gmail.com>
Subject: Re: [PATCH 3/6] bio-integrity-fs: pass data iter to bio_integrity_verify()
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	Chaitanya Kulkarni <kch@nvidia.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	Anuj Gupta <anuj20.g@samsung.com>
Content-Type: text/plain; charset="UTF-8"

> bio_integrity_verify() expects the passed struct bvec_iter to be an
> iterator over bio data, not integrity. So construct a separate data
> bvec_iter without the bio_integrity_bytes() conversion and pass it to
> bio_integrity_verify() instead of bip_iter.

Good catch!
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
