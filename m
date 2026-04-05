Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0AE33A716
	for <target-devel@vger.kernel.org>; Sun,  5 Apr 2026 11:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775388589; cv=pass; b=VDk0EKjqNHiAAOtOa/8lP5WKMe77uMJ/aMRhY5jXJlxdvGlCFEB76f5AjmWxiTq59embvgaFThhaZbM8MRDDOTa0/YhWAFCjetPdgWAoqdWdPCeNVKJD1bYbgRNaNQ2DWB5vIRWEpLVb1n8cbF7ivhxH2Y741Mb5lh73rt7XgqY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775388589; c=relaxed/simple;
	bh=DvF0YtJZCPbcobMdQgE3+ZNHa9Fjrq28Jh3rCZ4Bn5k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GX7Ee4bIFSqfpsACEy12Wwtlg5Z0/yQHJUlwwUK/UkGzqZuRXtydvfwaANRniAEUnYSi9PPhZ8kptmbgVp88NZs46cE7nMCTR8KC+4v4jqPfuAaznzR//gFIcTZrCyd5YQAeounRNtOXMpDux/W38axB915hN9uxwaR2jHVC7h0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pE95XAwt; arc=pass smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pE95XAwt"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-65c0891f4e9so1490171a12.1
        for <target-devel@vger.kernel.org>; Sun, 05 Apr 2026 04:29:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775388586; cv=none;
        d=google.com; s=arc-20240605;
        b=YIBQLDtm2bwYMAyt3IY8yovxZ9CKXFdNjACuKEdjqWzC/Ux8jN7nxOk2CaEWMB0vkh
         gbVQT1hOeSH3mGF6b8phInqja3qe9Osyf0r3IOytb1gJ52zZI3zAA6ZlgpWl2b7qekyp
         zUCCCqyyONgYtIC/8KKz/i30gO+j9gYN3iR1dZznuFfDtIRI4m42fnyg51RACXnz1QZY
         1Xi8BUkNlNveGeHcpYu0mWO21+gATDk7sNfDFg6TQUdtGWrRufUMnqu1sfb8xfMePoGy
         R5hmiO2dtmmDA4HxCrzfs927oyrqWNTUsI+fKqosr7iAu63g2/P2fVaTvXYPIa3IxuoN
         XjvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=DvF0YtJZCPbcobMdQgE3+ZNHa9Fjrq28Jh3rCZ4Bn5k=;
        fh=c2eYCyZk3kulVlJ3M1fQ313MPM/f5khpX1+9SYdnu/k=;
        b=af7UhFi2hwVn1IbWJEaVhBkn5XznVN43pnFnmN/f4Zk67pNkthk94rjw3uN85HYY94
         DyaqmPXHx+MgjToQKYKG6Oj+OosqLW0L8Y+C0OdIfcOeAtGlAKHKSgPXQrWx9PcooCIW
         DHqPvD53pgfpxjTciSS5qQ5Xh9d9oXYq/VYgj8VNc73D/7EiARh3thpFrXGcrl/2HF7U
         UsaGJKDoO8a25OFdY66wQ9cWTFjIDSwkja8SZG1Jb2ktl6/rQCJociXSrjExLPMBQZWv
         IsWoSuTiGMoQaYeoa5YooO6pn3ZDZD2BWVyLA/41DDji5azHBgp7d508Bl2l9rE6Q2BZ
         UA1Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775388586; x=1775993386; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DvF0YtJZCPbcobMdQgE3+ZNHa9Fjrq28Jh3rCZ4Bn5k=;
        b=pE95XAwtwxOXbJ/Z4BDWhFnqXZrLB7gEIp1M05dFOC8azSmLghypBFD5OslO0PS7iS
         qYaDO+CqoNPe9bcUOOB6BRcQUrEiD840y906gHgC+wR+Vjfydyjm6mi9YuKMb9G8HW1P
         fw/zKydgp9y0OPidnEyJO6UZLps8f2OirwXkwWcexuUhdMRpAX6W+704jzNBCaWj0l9b
         GvEo3aOywqVu6erIrdla4764jBFkKpPF0klBbJlTVqnE8pi+rdy3A/cUV33MuJYQy7Tq
         8CiMVHKDMjDrVvCVjYpEw6UJpYwuWBUwdT6GS7A98SAYwaB61Lmw4vS7EpkfxyTsxQkH
         qCLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775388586; x=1775993386;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DvF0YtJZCPbcobMdQgE3+ZNHa9Fjrq28Jh3rCZ4Bn5k=;
        b=AZdd3PHNBEi9PYvw7IkY0Ll5JYjwo/im2XIuxtUYdV7vvmcpVLboN/ujMnVzg42PgV
         2qbzTdTXEbpFaGbNX0IAFHPqalUz0CDGcGCxE1HMGKKZzuzsKeJH0eQbl2GcwPESRFsm
         w+d7kKIH7MXlHvkskUuY/IdBi4tRVy2zPdWG1bfILFh7G2wyPz8s+lZSQCrBE4N9RkFf
         w+y0382MIJoNTtz9pC0p0dY7808a9b8m0oX7cq50mIw2OTTXpIQoemYqnuiqwdYnGkFc
         WLeb06p1DvbCVoMxGeEvxrs/xPjAFDAo8pJ4bOfCSt/ykg26/eeCWo8B1YffaIpPj5Lh
         w4gw==
X-Forwarded-Encrypted: i=1; AJvYcCXXatICF8mYDCe1LMSKc9vo4LxlJMd+5apRddV1kHNolvo84QV0pZ0mOsjAw7+nRZq2O8Y20dbvWuyr0B4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyV8J6KEiD+DIdbJoTUZb14dXAfNFj0jxmMImYzOSHckFT5knlP
	Tq+HxFIBkRuOothiZt9X21eX2gbmx5TG/Xe4eEnA5KDRzebcm9iD/aY26NebwNqUXP6y89psOXa
	h22Bt/pOWFLyxydTs189FL+5aeMP0xQ==
X-Gm-Gg: AeBDietiLEAECob+entQcWSgpFgwn7mKfUYPdIv2JuI15D0LxYBDxIYgKNP4wx1ogT2
	BaHhvOAIDg8kCRI55ziGjImt0mAmVhYLt6zrFRCsJhKbZkVgW8FZNvjbM+FnoXacQsiDUvIAwan
	l7RCJAa9pzp5ivz6vzKP4lbcFcEH7tRfmXGexRVdQV0IoCCxI3Oimxlr9jPa5WVt9faoPgzeDMl
	NxtbqPluFmHcG2En99+i4OaPgN3xvIQ/2mmq4OK2MMvH1m0QvO4b/Sj2anKPeA2dNCiARP1xTYN
	3VQyChshokq4HVgbfMgE3aAYkXQmlaH42bQAYY7/QD+16bLeWjxCJrdjja9TsKoo8GxWZQ==
X-Received: by 2002:a05:6402:3593:b0:66c:204:5d05 with SMTP id
 4fb4d7f45d1cf-66e3eeded1dmr4265550a12.4.1775388586173; Sun, 05 Apr 2026
 04:29:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260403194109.2255933-1-csander@purestorage.com> <20260403194109.2255933-5-csander@purestorage.com>
In-Reply-To: <20260403194109.2255933-5-csander@purestorage.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Sun, 5 Apr 2026 16:59:07 +0530
X-Gm-Features: AQROBzCtWGel72grOiSfI-Erz5HUztph0xDvnagBcgqetrQpIdqD-KiXs-24Oas
Message-ID: <CACzX3AtoogGGYdJVhbea55+XfAuQLd4BVzsjwp9Q2R5_SugDHA@mail.gmail.com>
Subject: Re: [PATCH 4/6] bio-integrity-fs: use integrity interval instead of
 sector as seed
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	Chaitanya Kulkarni <kch@nvidia.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Looks ok to me.
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
