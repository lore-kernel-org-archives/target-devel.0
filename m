Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABEFD15DBAE
	for <target-devel@vger.kernel.org>; Sat,  4 Jan 2025 22:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736029676; cv=none; b=kc4GS/8OBxg37FgBjjkw84cCNVFHPDre2adzYzDJHJLi9Zc2Y3GXAi4kOFqJ/b9xBtGX1cJ2LYUqA7Tx8JxYMmX6u9VItMTCWHxjk2D05IcxPCQpHDip1v1GqVyOYkLasLVuNY51MwmpTh/A6A7MsOd2H8qCqCQqEy4aHMsoniw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736029676; c=relaxed/simple;
	bh=dbW9sZ4K4CVni2WzfS5PIhq9YPepuP+wgQlHyfd4Js0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=EOhU1g1k++mVjH1XGZy4jPFKq2QxFUobQIjeOZUPdSx/VW2AYJX5Cqb6nd35tUV1u3yxcaHkcRBQaU8MTs85zsvRooXT+Npf/6G+xzqRA8xQAAkauZ0jp5yWcj/Vztb8u9mRXzaRME6VXlFF6EbW9BZ+XE3MK+M+rxfbnZde5fY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=xoYooiqn; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="xoYooiqn"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2166360285dso188588005ad.1
        for <target-devel@vger.kernel.org>; Sat, 04 Jan 2025 14:27:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736029674; x=1736634474; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ydW0TG4z7XBo7HBBH7ij90+wnNI4JxxB1fs88STRyos=;
        b=xoYooiqnsEbhRX7oNLMe+4zSKtiFsQwy8/aciLwR5MW3a6ReCHKk8eZipkbBAx9V5X
         mHYHz7rcg1tUUyQ6Yqf8fi4GmvZcQbh2o/byeXJiT0EvxL88mAJvZ4zYPx1HaVPufL7z
         572+GXzuEpX+yVbDLRp7jRi3O7IR9AIjcCmnmNqZfHWp63qdaBqFhhGUDljGkfj03OLr
         DqFHc7rwsLT3E2pTPGVxrCl6xKYiB53u2lFSVi1L84K1Cnl0XM6YKWhHZ3wy1+h7Y6mQ
         /+5vIRZlags29GTRIJ+fRIdig73iwZHSd2gEIkrp7K+yhrt6woslPZ5YYeER5UNv6UHS
         aOdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736029674; x=1736634474;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ydW0TG4z7XBo7HBBH7ij90+wnNI4JxxB1fs88STRyos=;
        b=ruC2b7ghY3bkF3HIFuL+N2UbMLooGZMIKt2cMIYuhYHe5PuIVF+tTLgVRi4nyXKNgx
         EmcQbUMW4dXhYhCMb12EFBRwzZpyEkcViYCa6updXiNr7xcdT42iLR5LMLpMBODY/VNX
         kWAfFrq6tMWC+s9VEo8mP9iS9zss6ZccSdljDhrFWipl3zUq5BJ2AlygdnU9IDCsQgRM
         9Zxlz/r2Faceb8PmudusnytxcfEXEctvO7kR0fWnvDF/rp1Fkl96B1+uHJ1J5ArLBkHs
         qldB8oWxF79lLJS4LFHSEZNfQ1Cof+lWdfxfEBGEkm287YzardfsWbugMgYDgFzkGHQT
         Vywg==
X-Forwarded-Encrypted: i=1; AJvYcCWNhGm1m6B21A3MdEEMoV0zKwoqRJALaSyg6DI/tiHR+LovLHjdXrzYRTO6iySwR8zXaUFA9w154snZ7d0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNPI+Mxaoi1wBlXxmL38GuyE4gcPksgqnPjmt3bc6nWniO6NY4
	Sy1CeRTqK3JGeS2Fa2TbRqi85vK7bXc7P9QU4MNogrncx4ULyX71dfN6IOiAUUk=
X-Gm-Gg: ASbGncvuzjsSOsLvRLe/f36HletrBz/jVXgBMXxDCwebX4h3yN0GK/++z0L87YvLP/8
	XvtLF/z5eL9R+kBor4vufP4bNJ8Fg/NcpPmK+WJgCpFEAEZA23rbSAL3CIje0H9G5Eq5oGpaZxK
	U0AbrWVHl2123B5GpolCkNFg+fYD6b5eiRrGF4abi6D5U5Ify81JKrXSWflEa5WSx94Q82YYyir
	OWfFxtB/oOPn5matC3Qme9Wc7KHy/tUrvONkWv7YLW1xZeL
X-Google-Smtp-Source: AGHT+IF+L+86xLxNKDCy3NJpJ1Whra//RstFOL/I1FY0ppQLvIlzdnb8Hv8hv/Dxi+bSvhcBNsb4Ww==
X-Received: by 2002:a05:6a20:6f06:b0:1e1:b014:aec9 with SMTP id adf61e73a8af0-1e5e080c77fmr83798682637.29.1736029674019;
        Sat, 04 Jan 2025 14:27:54 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72aad81641esm28451472b3a.3.2025.01.04.14.27.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jan 2025 14:27:53 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, 
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <20250103073417.459715-1-hch@lst.de>
References: <20250103073417.459715-1-hch@lst.de>
Subject: Re: simplify passthrough bio handling
Message-Id: <173602967287.135972.1134077263108813311.b4-ty@kernel.dk>
Date: Sat, 04 Jan 2025 15:27:52 -0700
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-14bd6


On Fri, 03 Jan 2025 08:33:56 +0100, Christoph Hellwig wrote:
> this series removes the special casing when adding pages to passthrough
> bios in favor of simply checking that they match the queue limits once
> before submissions.  This mirrors where the zone append users have been
> moving and a recent doing the same for a single optimizes passthrough
> user.
> 
> Diffstat:
>  block/bio.c                        |  107 +-----------------------------
>  block/blk-map.c                    |  128 ++++++++++---------------------------
>  block/blk-mq.c                     |    4 -
>  block/blk.h                        |    8 --
>  drivers/nvme/target/passthru.c     |   18 +++--
>  drivers/nvme/target/zns.c          |    3
>  drivers/target/target_core_pscsi.c |    6 -
>  include/linux/bio.h                |    2
>  include/linux/blk-mq.h             |    8 --
>  9 files changed, 57 insertions(+), 227 deletions(-)
> 
> [...]

Applied, thanks!

[1/2] block: remove bio_add_pc_page
      commit: 6aeb4f836480617be472de767c4cb09c1060a067
[2/2] block: remove blk_rq_bio_prep
      commit: 02ee5d69e3baf2796ba75b928fcbc9cf7884c5e9

Best regards,
-- 
Jens Axboe



