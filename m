Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A828027057D
	for <target-devel@vger.kernel.org>; Sun,  5 Apr 2026 11:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775388620; cv=pass; b=opLUkf8TVf3xfEL8h7NFDS8s0zMxILbj7QtlxXJ+0PiqKfiSF3iJKEkv8zk8v8QVW5Aa7VifMYwxHQYE2VhLEl1/rICI0huT50BRkvR/gOOlhwAUpkoNrrj4/mWWNBZ6IH/vFv09hK10+mrFprKfG4X7qT+MTuUCgPZbV1NC4oQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775388620; c=relaxed/simple;
	bh=DvF0YtJZCPbcobMdQgE3+ZNHa9Fjrq28Jh3rCZ4Bn5k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RY86izX0JO4eoHxPJ5BLaubTaME9f6lkHSLzSxMntXhEzzd9veFG3bZZ2qRdY+v0MFeH8cd9BDkTQfCyim8+qcp9s4MeeID6xcy1y+FV/l6z0WY9cV6JLPTW5RCkRpzzfB+oIn972jHc9mvYv8WbNWFs05irFCXpAXe8ACMX5yw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a+629FMc; arc=pass smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a+629FMc"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-65c0891f4e9so1490387a12.1
        for <target-devel@vger.kernel.org>; Sun, 05 Apr 2026 04:30:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775388617; cv=none;
        d=google.com; s=arc-20240605;
        b=WDry/x1upY00AM9x/EBbn4b/m1pxssk3S5ZHL8MbY8BP2xCb4/4rTkTexXERaUVAk0
         PJt8t3+atm4nqk+pJfbMFgMLCObm7ppIu7rrTCqIM1ekC8Hd6EX9UJ4HkOnLpzwm0dSF
         jf6i/5sKaPUZwteE7KfURqEr3Yy5tEfJ1tNW3SWLKfaIYvG0B+/Hs/Icc3Sd2kP/EbPF
         Dntk5X9RSVQgohjTR3fO8y76IUFVTDTpTkWfkoChQC8rskSIg7oo3uaqcfmLSB4y1Xmb
         Zmh0C3ZZaXLuj7FV6oyhT729ycMoEOeT2P6kmoF9sec+f0G3Wb0XsNmEj5Jnp7oZHWXV
         zAJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=DvF0YtJZCPbcobMdQgE3+ZNHa9Fjrq28Jh3rCZ4Bn5k=;
        fh=GiQ3tfD/f4pabhE5ytutH+xAhpjs0jI/8oOX8BUNoF8=;
        b=JfHtT/PGvZNM0TjMQoEXICauodHhxw1VBcKhX4DHoVK1EAnsVCGqkMHd6Y4APsu6sm
         hV5jYvIdwu+rgymhEmW6igLpZllZWxRtR/zOGhpGeoTB0p5zgUD7HSS5buOyb/PKBtVi
         lyLKmAz6B0j63CHh6+Tt8frSjJjZJgsYSAo/+Wcbkcc55myGyAAxWGdKtDOXTPgsvD6a
         nP5QzR67T+E+8Daj0wJN3kkeeTBb1DJ9PgYmlKpOpikue6PZ+dCB92CLCxmvBhBRBZal
         hHGHngQd1NSipB6HEBiLuv1bT9yqcNohhCFiUsQAQUZr3fLBfJ8wdbF+6L6k+hYhUjaP
         D/JA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775388617; x=1775993417; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DvF0YtJZCPbcobMdQgE3+ZNHa9Fjrq28Jh3rCZ4Bn5k=;
        b=a+629FMchi6KQ7gsXOapCt+K5NIEeVvHgtNI+Pf6DhtT28irjcfAi57toEJQqFY583
         1Z7vPU4+BzTeWrBQkWe5iXd+pkATi565F9dOZfVnsThA3n7zg1ZaspPgVw2Yb8M32Arq
         oKeRw+T+cjgivu7GZRlmMMzBB3jqCLPrvg0Lw2X6ojyf5kVw6lkkS2G4aWNZpVrAw3t9
         H3KLWrs1S2syd9aw+AwTTdBl1JEZph3O3UsL4C/azc1Jn9JZNO0RfZEfsesM/fEqQcYx
         4+xHEE8OWH9XFRFZoJKbFaMDGD9r4QkOeoeW2ZIjbDeqsfeOiMDALE7OrDJakbHGiiKy
         CoHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775388617; x=1775993417;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DvF0YtJZCPbcobMdQgE3+ZNHa9Fjrq28Jh3rCZ4Bn5k=;
        b=QgEtlVz3TaW+RnBhC7k9UFKRT2OoKpwxIoyJKWVFAqvVeIKfQOUA9hgnR7OADf4g3h
         ZTLXtxAdrVXLMwBDB3AhcBuBl4mAqEHamG+8amBs2uMiuLPuwHbRpX3JW3SCYeksSRm3
         t9acwAiOzVpsRPIXWzoI9vh5SHk8Faitjavzv5Bb0x7MNQ5CyluApwrA7dgvRf/JL2j4
         qWqrWgtASUffOYmnjloajCQT1S9nF0srkHnq4PMfLJ0zjJB5KiRAmHD+oPOrXNwpQ+L0
         KlFXDGN31wZ14QvpE09/uB5bdLZvr/TPfN8EaT4N8zkx8OtkFRrBns29EpHkM5YsO+ug
         6TWQ==
X-Forwarded-Encrypted: i=1; AJvYcCVVTb/64/+3lZ1eY8GuGnayuY8llY6aj05lfm3/2QuC1e3HG+1tIewXg9xDnBsjjpohHvYTyOQ9lTez+fM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXHUclKHc7Ba9Q4P061Vdl7UMlxZFr4koYIECPFcLdi0W32V1o
	eP9wewBBLv+/imAuBjJlNgcLheweuX3ACIxOMG7H5dHG9UI2EpHo4lyjHZO9WCND+HXxu9MTprB
	rFsrajmQm5nRj+tUTyTDguAZ52M5aSQ==
X-Gm-Gg: AeBDietdciOE8wdc41ko44n3o3Wn7IignnX7VhXa0ot0YQd4qTCfJabIOgDFPRjQcuk
	o/bNKJKDFOdJmkD/+zh5XHTG0RjrXipOo6RKJdG/hyAyGSW/X1aWhTCRhaa2JVuPqYiRJQzMCM2
	lElIwsoTj+fiKi7Nl5JqElhGDPOAMkz9bGtU0xWAvWBFWBM9od85iJWholT5K7OPxWx5rPxyjWz
	Vqn3vx3V7wMqMbVX8MLCSLwbOwnQYBafj1U3+RXPDJZ+hU+53oY1v1zd0KmgBMe4oT1yisplx8g
	XOiZdaiK9wfc8iqX36/ptpEAk/RYSSjcxMwK2h3IoZf3iCt/5FQRC5dXW/VBvQm60rWkwg==
X-Received: by 2002:a05:6402:324c:b0:66e:df62:8826 with SMTP id
 4fb4d7f45d1cf-66edf6288a7mr338829a12.8.1775388616842; Sun, 05 Apr 2026
 04:30:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260403194109.2255933-1-csander@purestorage.com> <20260403194109.2255933-7-csander@purestorage.com>
In-Reply-To: <20260403194109.2255933-7-csander@purestorage.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Sun, 5 Apr 2026 16:59:38 +0530
X-Gm-Features: AQROBzA2rcbT0pZ0-7PJWuNuCAXgpXg-lAQtO03rLOJpR9_lw8vMvBFgqpf-qwE
Message-ID: <CACzX3AsN9osGEHdaZu-qKpKhR+JGTxaSvx3PhqWt4N9HSbj63w@mail.gmail.com>
Subject: Re: [PATCH 6/6] target: use bio_integrity_intervals() helper
To: Caleb Sander Mateos <csander@purestorage.com>, Anuj Gupta <anuj20.g@samsung.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	Chaitanya Kulkarni <kch@nvidia.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Looks ok to me.
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
