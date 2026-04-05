Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 877A033A716
	for <target-devel@vger.kernel.org>; Sun,  5 Apr 2026 11:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775388481; cv=pass; b=rCvYQG8Cj9Q8OgEYYID+vTOtwSoogz2ngZQuB1nzildlrz4EHyBrn5xyf2GL6rdaulL04hSFY0PyDsWnoqfCir07lb00CbqoFMPmtMmaFINTl5w+xlWEZOm1m4pZ1xNhxveWqdgiVLSSWl6cXAl3z8SzrctBDYlzgDfkCHKvpzE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775388481; c=relaxed/simple;
	bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oJZkIF5HzfbXwZojP+oiI01edF++pbpp23Eu5g+oH6Nni2uwwKT8I5jFckCynydwXT50wsxhPKefgNeeoiZny/5vo0K62Kchw2QPpYJWEBTKm49Zgigt9sDlTn0r5op4zXgKz5qIzPcRLphaTFWm+PSbuPBNZEYJpxphbA4xD6M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jjS9Eoje; arc=pass smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jjS9Eoje"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-66c24b42efbso4605541a12.2
        for <target-devel@vger.kernel.org>; Sun, 05 Apr 2026 04:28:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775388479; cv=none;
        d=google.com; s=arc-20240605;
        b=itkGVMwWE+Z7bwb50MEohVr1HAVRNDKKJerSk/Qw/Z3eCBYOQBLJKAEiGOZ+2V0B4G
         jHM21oRsFv8OplTim9Qdb7oFEVvQL0kRNZd6bmQ3mj/yT8UI2uHBR1pXPK5znEneKRvY
         UtKPd1bWBoaoMbUgDbrgFRMgrcoicoAfNo11NBZRo2tKYMHAZmj6GfcPLflMxmnI6jI+
         g9Zo680UZPD406fyku3TS1bI+dN46VpPZY6qKk34TFLsEjEZRASuXPNLTOC+ynp3RQcq
         5dJ65TX9S42+aw06+9dkfFZA4sXt7qTD+H8XMXhmL2r1n96rNzGK4Qveo/QZfUSAbq9s
         SvZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        fh=Ph5gklGEKItNKEIbWcxPsM2MCOTOY8ihMlQN6klVUtA=;
        b=ayjFMDnp/0G9IXjqQ3z3nDaHLdHZIpwq5VkVSyV1PAs/ekzUStHbKCXdznGLHWeckW
         ARgFLPfnOg2b08jIJYSY5Fs8WElhM1+gnl7lxrujDupEF0DVVhLhjJVyZ/goE9Cy2VA0
         DxGPPbgdMxCoobFj3mmZxU0AQzrb558tt/vcp8QqKrGqdUx5rvb1WEGog66haptOwSRa
         kh4y9XZMmz2ch1KOq+cSJPiQZFQfIqFMMFVTo2vQDEQMYxWtuv0Jo5kuN3V4aYybyrf8
         6apaRLimG5G5kDgIRPVSNFuSczEVyk9lIH4eQWf3G5KuGeHNbVKv/Hf7Hvsa1vHH5F1k
         Igig==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775388479; x=1775993279; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=jjS9Eojet1qPR5yY/IjndT2lJaD3dpqe/pRi4GbdvW6C0Du3Y3NIDIX76x9DesnTsX
         sFBJsxpk0Moia6w/r8Eax8/VS75YpHPxo6UaRBApQ0u5iiM2xMWAFyKsn6HdCIrpdUnp
         FlciLQzrVLv+5B7Fh0fobc+7j08vQ/uJIB8d9rmUYRNT1rZS3iSTE/k7Nzsf7J145gh7
         gJC6zBtKeNClATmHUS+MBKCg1/dx8YHgDWjTbMMVKbE7mmtvrMVaCt3ijjbZg4MwbdhV
         N1DqYidKYWPOtvJhHy1VXw4/RauZ365gF868Y7VovIoW0TQoRCyZZdae3b4aRh0jdqrJ
         cI5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775388479; x=1775993279;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=niXia1tEjfBjbdUg90ckmJFAMbnokWz622BfKjU0D/VlJlX6ydIaSqaCzHj4+etDq5
         nZ9LmZdYV/d5JploaPVWYE0RfULC5jzmfO6fqM3zawtG7oB5pFfMVKsihoYWVku+FzZM
         VOH9VLJ6fjln+y8TV3pBIVHJuXzBHgBtZu+PWlR2LEGwo0jTslmejCBjSUH6jIkXxkan
         wqkqaWXnMnNIThYFTjCwy/cJRWoHTuXqF/EimBMSRGOLi/+dC8LoJcOlYzmOFACcszDy
         bZ9Ko2bHH8vzBP3l+Zip1Y+FBjWRjMLUoBvqpCoaR065q0hWF+iMOu+o+6NdRbrW/xhD
         NlBA==
X-Forwarded-Encrypted: i=1; AJvYcCX6ck9hVwvYdjZ3ocZmcaB1dKV/E6nOXWhVxY6FEN0bmRBFMtcmXj36B7O+aE42ssEP+1szM55fYu+aP+k=@vger.kernel.org
X-Gm-Message-State: AOJu0YzHnXpBJ6uFkJ15+swFknNRzxEVUJT+tyQdq34zKnONz6CpdNNM
	EkgllMO/gTmn4jNDDRT3ahxVqJkkqki3yvgjSbdk09bSlTTx4bQ+i0HyP9lD+2HDCbzY23k/ASt
	yC6YnCgGfqCY0d9zISYdBDZCA7HE2Fw==
X-Gm-Gg: AeBDiev6xlW0DwBDPxaIx84F+k3E5XsanutCmvsRZzje7SQCWxWsaaYeUlwQdWSy6Xf
	jXfiUFV4W5AqgsGAw8nsOHQ0Ck7Sh+FDGFKFmJyMY5XGkCPwKq30dLJk51PQvRMYlJEOCtEAYml
	gWIYLSBFUoIYdyHtUoZu+tn1c145ED/8LdOQOKTjuvcty6Bl0P0/elpV8BlfcN5urw2ETTdO7Ws
	bsBmuXlh2wfZOaF5bV1kgudcUc+/RWFwATK7hDBHzb+S0/1CQ4DDRBDh4iJnpKY6nOz29JoEA/3
	i5YzJWM8WLwo8yyVMb86H7kunH2txLkic4eYjYqGTwEm7fwPLlgKRoJtwyqm+FfdbFWP7w==
X-Received: by 2002:a05:6402:1ed6:b0:66e:d57a:7023 with SMTP id
 4fb4d7f45d1cf-66ed57a708cmr577928a12.6.1775388478798; Sun, 05 Apr 2026
 04:27:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260403194109.2255933-1-csander@purestorage.com> <20260403194109.2255933-2-csander@purestorage.com>
In-Reply-To: <20260403194109.2255933-2-csander@purestorage.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Sun, 5 Apr 2026 16:57:19 +0530
X-Gm-Features: AQROBzCwSmUwg2hzQ9ILQEZ1j4iBp-ZNL42-_yQcEJYC_dnQvWOfGvOnI16w6Bs
Message-ID: <CACzX3Auxb=D1PabMdVng1N7G_7zmn5poknRR-k5r-iJU7aWrGA@mail.gmail.com>
Subject: Re: [PATCH 1/6] blk-integrity: take sector_t in bio_integrity_intervals()
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	Chaitanya Kulkarni <kch@nvidia.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	Anuj Gupta <anuj20.g@samsung.com>
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
