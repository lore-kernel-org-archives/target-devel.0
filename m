Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 895B121B9F5
	for <target-devel@vger.kernel.org>; Sun,  5 Apr 2026 11:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775388509; cv=pass; b=u8o6cvN7lPLQvvsacOCQuVGfCsF27R4g+5WYJcj/sVwOtNAhgc4WKWg5I5QcWd9rHrnHS7tyXymB3uaibeFw6K501HEkTcz9uczGQ3HipPp2OtK7jYH6EGjvP9DDI/QpoL6xxas3z+UW8DJjUhpMG522xl4m0GYOceFPZhcvXB4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775388509; c=relaxed/simple;
	bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K8mzJ7sOzpKw1MQazVsN1jU2q7/wkNfTvB+lD/D5l9spTVwbernZ+BSju5iO+5ckamWR0dn+39qtFmqYeCxqTrcSDwAfdDBS60o/Kw48NeN1VWARKWQZkGTNLZNdZSVXO5yxz0VBXYeWsV76404XGNa0UHgZT8AONZLiZLklLik=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eiWX6n8/; arc=pass smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eiWX6n8/"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-66c17372965so5857860a12.1
        for <target-devel@vger.kernel.org>; Sun, 05 Apr 2026 04:28:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775388507; cv=none;
        d=google.com; s=arc-20240605;
        b=acE2TuzVlO4dmzo6kYSMe7DTe4NJJ9IvQtKRmPE8rNK88+O3Had9x3irWm/Ci7yo3g
         2B/tUiOzOHRPA+YpQAx9Aa0k79ORn4diAFYkROV0ujjCSoYlR3z922tyw4llpGL6+zLT
         qPwDRykNRRoNwRyWS6ulCqh5x/tJ3jpWBdFpBCghRzdeGHBDbw9JkJerXCRAiT/+OD1i
         AKTclDNv5etT6y8yeE8KadeRZ3cQx7FTWi5XdqLRKewB4ZWPMQb1pk1fkIAXbwiIxi4l
         WXW1u6/HWmlRqvH03ipTtP4Oyexnf+BefIAcZBHsXwC+hf8rHpBhVuNa4jQETHuZkgWv
         H38w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        fh=Qug3FOavMZChV9ZtDocEr9WKpT9GkBil+YyVWaTv0uQ=;
        b=QSmBS9G//pw4j5PXRmAGRsYUjbQPr8jXvCsam393A3qiWIyvxF1i9C+/uy1Ba5wNji
         2zuVqiKmMB3unq9QYbQDf34w0RdNoY5I/ujm+YkjecMXn1x/Y5A6hBh1jlbgS6rImUn6
         k6PzE9w59FPPkMJdGBAJ+oC/yPaOxyVTHKXsRfpK+2C6hmeEOPP1UyyNXtyVVBgckhka
         1mdMDXTn6kRB7y/M6+rIsHt5rphntdBKKKg9/ZHaYh18HQ/M96ribm+QdXWjN/iKIZ5r
         r5oiCgAfMM/qlXC3jrMk+os/hvuSqxlEb9UypEDcmkz38PNII3O7pRWvywzoMHSIL4qr
         bC4Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775388507; x=1775993307; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=eiWX6n8/dvQP2epzag+YOiOJKImwBf0ETOFRZpxjC1rfx2fIJn7MwIyhhxwEbXmV0P
         9OhNwTVtZ3EAiOuT0enMlxKRW1mnF++pITBf6ykD4l7mDgmVZ48drY31swGtS02HskNh
         Elt1Zlqr2ohEkg4Ekrdt0gu+YaYNTZC8lf5ZnAydk1huj7gEQ4xfT6rbejcP4gd2gVTC
         JpW6WxBgEd+F2j5017dD+4LTHGLR6qU+PTdO30NGJQ/+70vONaJea+d40KxMPhuObiOl
         Pd6rL10zgz6GHhHRlnMXmJlOCf6mghUDiTX50gl3H43rFuqbRdxiZl8TNQj2cb1ZTW1b
         S77w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775388507; x=1775993307;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=rGskFqPAgL2m23u/Xog3kQZlEMFcLoy4Wru3F405y8fgQSnp6YU74g8U4/hRuWDvtB
         uwcES7VtPfS/uykLwHopMftBPY7tgCxUEel4x4uYRfwXL9dSsxoCDYgmqKBluv7GiaoJ
         gY7AI102T2HKj02epIvHlaNG5WDxwsaPe7+BphV5bHTyEzggdc0OxN4QZQib/ksf1Woi
         K3Pb2yjdkR6FHiw2B06IhLa2Y8BwaHpLJHL3c+FY6Hx2gd436DPEpG5/zC5molOTyVnu
         x9MFSl/iBlqwMBwrlFaASRD5g60BPVL3QcHgv7JWzCvE0qpoeqffm6Zfqkg9HXJNVM6F
         eGgA==
X-Forwarded-Encrypted: i=1; AJvYcCWIokP3IScQMRLBLqMIVY0ZSaITKZ3nQQn1NKEzZ2WPTCYunZbo+ww67A5DGCeB41VPzng0nsM6Yhn93KY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCyZnhidZ2aNECDEbfxz93bd6GZymD7Ro3w+l4Hh1vJhFS7mgb
	n/h2DA7mH2H2g6TNs539Si/AfjNIsGDrwBLvQ9vjQKoXwUyHZen8/+ASzSO3h6L9QXNlnKaHPYE
	rZp/Fj2g/ytspxvOKRyhl6lQJvrvFlQ==
X-Gm-Gg: AeBDietx4v32NskDM4t8kSEbY6N/Ux4oP6t7VAemCXs1WFMY3nr2jkM421Npa0sZI1O
	ZHA7QIOnMqsWb/uRGVTVNwl03YVAgiikUIRez9f957/wmN/W4fS2BwyjLFuuq0UQl4Hb+vLnl0J
	s+oy7KHLzNPq5R0jh+1NhHKIk/2uY6Bxx6KVXM+CGSVAosUVKQ2pmWET3YfcNIdzmvLVxTdz9jO
	O+sT8L0mNcsY3QKMq8ODEd0mFaq5qWp/8mZiji4AKESw0cmsUf6qgbLTGttfy3vTvAs4nm1/sov
	CpT9dn0lIIA+uyNNqRg+UvS5h2nzGhwMhQdeotXrM1aA72pQ+6CjXXi8uy2slDzKwomyBA==
X-Received: by 2002:a05:6402:510d:b0:66d:eb3c:e33a with SMTP id
 4fb4d7f45d1cf-66e3f3cd75amr4391626a12.1.1775388506893; Sun, 05 Apr 2026
 04:28:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260403194109.2255933-1-csander@purestorage.com> <20260403194109.2255933-3-csander@purestorage.com>
In-Reply-To: <20260403194109.2255933-3-csander@purestorage.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Sun, 5 Apr 2026 16:57:47 +0530
X-Gm-Features: AQROBzB7BsO7HtCIFo-YLrsx_ROEx0YM6hJF0_8-6yyuGMvlIZYevxnPKzknkJw
Message-ID: <CACzX3AsJbxpYdVPiSeY8bjZVVWDfMuzGSH_dsTqzBvGGbkvx8g@mail.gmail.com>
Subject: Re: [PATCH 2/6] block: use integrity interval instead of sector as seed
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	Chaitanya Kulkarni <kch@nvidia.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	Anuj Gupta <anuj20.g@samsung.com>
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
