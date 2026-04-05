Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826783242AC
	for <target-devel@vger.kernel.org>; Sun,  5 Apr 2026 11:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775388447; cv=pass; b=jq8+jKtdtHDzY1z+VSpK4R9QH/bV1nOQXmT2aUdTYoOkNjNrQqf7ks8YBINh40FFEuWKEOS0fOYNEqxz1gj8gWUDzb04po/Ku/EwWqZDA1McoUcB4SUB/3W7B4IbJV1lV+n/T44eHrwkheX+the8JKmKh1qA/RrxgrLAQl1gc0k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775388447; c=relaxed/simple;
	bh=3mKGFGRC8Ir/bEzi2WUjXo1t2+zLxBk0Rpi89ZF+PFE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GejdyHAlvORf0rUH5uFXyVDLTiDaH7OScg/M3IoqGdVacuzxWPumpX5GE4x2FDXo6F3kD32a2bIjK1UZnB0xPAPx+/c5psVBRSe6/78VCgUWxxe1TyTOJ0LGYOAF40sMT8CQHHkvaSIAl7HYD6uDE80T2C5d9O3LTmqI9dSoDsU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=p5+LLAB0; arc=pass smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p5+LLAB0"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-66e8cc714fbso1644138a12.0
        for <target-devel@vger.kernel.org>; Sun, 05 Apr 2026 04:27:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775388445; cv=none;
        d=google.com; s=arc-20240605;
        b=eg9jvanTDFnQ9Mi1clI2EU8XkF2w5aDHx2W426iaGk9KJVgQgz41QEeSZcTh/bkiIi
         N1vkshjLID+MyNX9xG4T+rV95KlSvZXmqbEwUBJjOin1TIpZLFi7+ctDlaVnq7m2AOaE
         vsmBTTbHLNP21ydoiuqgvAdAFsF35hAt5B4W0h9Xcnmhc+iTeRMpPDDp8ycz8DcQU8ua
         0WSpxPFxHeG0vCX2V3TnciFEUqM9JY/+BmMENY9/+dkRGMcNECg0qJeJhHH5PhgbvAQG
         WIV97WzlUZyonZqkKleiL8MlEiuKZ+XRO1qq0MixDhdHF6AEwnp7NwBuj9b32BmDl3ZT
         I3Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=3mKGFGRC8Ir/bEzi2WUjXo1t2+zLxBk0Rpi89ZF+PFE=;
        fh=cNBb9TC9saOpS+NAy8nq2y5EhmBJnSc4d7PewBUmwFA=;
        b=Y+t+2bHctyNb+HjWZrZGDsQTBPhlFP1qnIZ6MBFqQPkE/VqWaPyNJBSvQ9N76X/Dny
         eQW6cy5uf8GvxZqp/r90SVrW+HhzEXDZdjoDed6L1ytnyrgBQuuZiNFPdB7a1QiEG6n6
         P/E95mn2YnkoU0xAhXjluiulW/C/x5A4I+Q+jTzrbumVD8ziJJXnSaMKnlPYIXzbPrhh
         KECnMGRMpXwoPgrqrD+idgwIyXdDYhAVDDtxEOTDAdHa8DvHiRa/VWqc9x6XpxuBTML4
         BPDdx4w4RmbXrMoby2XnVy6d6jTXHBktSk6OTzReYJvl6m03ya+zuhbXqd5OUSZTpe28
         vncg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775388445; x=1775993245; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3mKGFGRC8Ir/bEzi2WUjXo1t2+zLxBk0Rpi89ZF+PFE=;
        b=p5+LLAB0cpEJCu6nFFEj6V8s+vMqQYkWqDAi7A4D6IwaVMw4vKZPtn0G6/DHa48Z8V
         V7w+KongZq9iS/kHDIjna1ZlvaPyLryFtAiCmIHNXYPKZm8akE6joXvGFOxe2RSSD6T4
         hS6fDiJgWHTV2yJn/egDu9orrvyCmXRgVATn9hcvNwFDwczBMdlpo7Pb+kL6zLT+5Omi
         7UMDGcJutJXOxhKaTdYvgLt78p77slExTu2vdGuLJdcwiPdpdgrB2nSJrB2P60BuKa79
         ZbTYC8gJr25mghT7whieK2vboiv5bOdrJzy/RBawF9pTwqmEtso2+wc2TvPOlg/r1cwe
         LNBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775388445; x=1775993245;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3mKGFGRC8Ir/bEzi2WUjXo1t2+zLxBk0Rpi89ZF+PFE=;
        b=KXodKRrKSybt3aT9MDeFO56kqwhb4PYBnvQ5NbXQ9tmZGriTZ0mBPO0SR7odxdiiM7
         rn8qQsfPH9jvhKY/FtOroGvXZv4LCEwXgrIWhhBzTb2939Dg0a5FRUpGrgEiScdk/a+z
         l983LlSRkd+HuL9YySA737uL/wpZWQjXv5XysfD7R7xvsdCda+tk9wZa90dU1EpDNAOY
         tCBV+AklNQBTL3s3Besr98OfHODMoYoKMdxz3jaz1L7OIueZZ5DDw/LAqhus+lKZzP8A
         0uVJbgAO1WvWXRPL2m4kGCgrbfhbcVmxq2Dt7Bjm9vVDUL1E1MTqFSXBX3Wc+yP2oJKW
         J5yQ==
X-Forwarded-Encrypted: i=1; AJvYcCVYWMgJNgChkc54AjMzqCl33ARb+WAkG+/6eXihzC6fXuM7sE5LO1dkZCCTLxN8bfsk8D0ILDn5Hq3apgk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/hK0/tRi6Sj+eHT2eqhlrBkHatOyzFCLp68E5KJbm6dZ3xLyn
	GrVDWq2r4IkGIg3S/4z4TiJasBlWWgwrkgNdpb8hP39P749WNUuiuMWg4BCzqzFTsIu4Z3umBRV
	Rh5lBBiL51ITVNGh6fuGCI++GdluXKw==
X-Gm-Gg: AeBDiesU2Laqs5Pu8kYRrU6fZ85BdBQJL8tGxTfZa53gf1j29wOTM6WOn2eZg590sYy
	MsGyS1XjAbS6oSi7wxCHTfXQc9zQZffj3NDMSAcX7S1uaIfYaVszdZ4gc0T2C1cVyHHqy8IppBc
	w3cdngUoE60vGr7OdNCa2L+gdx7ON0BjddfIp43DqBuqY3dZF5wo/Lvl6G2jttbSmhLhC43PQS+
	8sCv8DRECD7sMEYYzFOlbM6CsfoRQ5Az+CqKvdUc8dvavCsRIlwy0Vmv5cUC3w3IdM+zTs6wkbR
	V6Wlm2+rP+huW0RMJ4FNeAHHcHiaizTuEqwlxaDAxO+ymbRvhyKcI4PRwMYysbpYWz5g6Q==
X-Received: by 2002:a05:6402:274e:b0:66e:dfdf:cf1e with SMTP id
 4fb4d7f45d1cf-66edfdfcfa5mr545956a12.27.1775388444505; Sun, 05 Apr 2026
 04:27:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260403194109.2255933-1-csander@purestorage.com>
In-Reply-To: <20260403194109.2255933-1-csander@purestorage.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Sun, 5 Apr 2026 16:56:46 +0530
X-Gm-Features: AQROBzDs0E7EbtHWRnG-_oRVFkR49Vyn1zNqbc_cUv_MF4CXocoxU69uiac_8Sw
Message-ID: <CACzX3AvwQ87hL4GOBmpiGDYGqvb9O_HVjkS_e+-jLiJGgA7HPg@mail.gmail.com>
Subject: Re: [PATCH 0/6] block: fix integrity offset/length conversions
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	Chaitanya Kulkarni <kch@nvidia.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> The block layer's integrity code currently sets the seed (initial
> reference tag) in units of 512-byte sectors but increments it in units
> of integrity intervals. Not only do the T10 DIF formats require ref tags
> to be the lower bits of the logical block address, but mixing the two
> units means the ref tags used for a particular logical block vary based
> on its offset within a read/write request. This looks to be a
> longstanding bug affecting block devices that support integrity with
> block sizes > 512 bytes; I'm surprised it wasn't noticed before.
>
This likely went unnoticed because the remap path compensates for it:
blk_integrity_prepare() rewrites the host-side sector-based ref tag to
the correct device-visible interval/LBA value, and
blk_integrity_complete() rewrites it back on reads. So for block-auto
PI, and for the FS-PI path that goes through the same remap, the
device-facing ref tag still comes out correct even though the host-side
seed is semantically wrong.
