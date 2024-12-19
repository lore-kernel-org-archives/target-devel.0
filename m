Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFEC5222592
	for <target-devel@vger.kernel.org>; Thu, 19 Dec 2024 10:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734602948; cv=none; b=dWSUJUXtfjtYI7vCHJAdViN4mAOlQliOK5OSmfbLIqP5jLczwMwOHG1iJkcHvWeJ3r8eywAb3hUpm5mbaAukhRXAycxneohYXmMLteNuAPWAxfnt46uC62+SxdsZm1LU8tGU+i1n4V9xgFbaerH/y3N9B7qCFC+1cg0FrAgEKqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734602948; c=relaxed/simple;
	bh=2gDH687Y+RbAzf35eofEUfdXtMWrVfNMD6crZe1I8Z8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D3wcw+nILmTv5TDkrzDaKB0+ZXWJpixqtaDzBkQlXjvw4Ye5ZOICoIqYI2ymrxtiBMNkt8Jv+kyNfYuK1kukvsMjrw+j1axeSehOYUmbAwiprYjm+ADU920z6qHBkRRG4BlddnQ6Twdbf7r8/x2t6pZBrCyO+0mhYAMQ9LhdMr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BzOwAfCW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BzOwAfCW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734602944;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T98mqp2bW2iDbPQ1pjYih/rvPbjnw2C5T7MaMia1oug=;
	b=BzOwAfCW6lafuIYZFIxhldK3dS6VAAVxYQGBh1rHpTmZu+sju/Ef9bmCPkpudbWXedSlG1
	HD8E7jOUQp4SxoGRI1Q81NLveOCZIAezbCBW3aJeWQOVX9lAD5D1s8TvfR5rodpR6OMTVI
	weGD3staeBPn+lqEYNmamqLnOusaUDM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-166-m0eCHXerOO6tGNMbCdneeA-1; Thu, 19 Dec 2024 05:09:01 -0500
X-MC-Unique: m0eCHXerOO6tGNMbCdneeA-1
X-Mimecast-MFC-AGG-ID: m0eCHXerOO6tGNMbCdneeA
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43635895374so8576375e9.0
        for <target-devel@vger.kernel.org>; Thu, 19 Dec 2024 02:09:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734602940; x=1735207740;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T98mqp2bW2iDbPQ1pjYih/rvPbjnw2C5T7MaMia1oug=;
        b=CN4m1PjSw8ZnJQnsGwymzhVP9lBGHroVDFp8bxMHyDXZd4j+Vq+fW3jyBcDEWH7YNh
         na/FJjGdDY9CW5D6eCaCG4BcR3biXX++1b5eivdUWLHGC2oGuxuiz1T3uSgasqt1FYba
         7twZF5gfmR4RxSDT313H0BZOXXt9uiCZGHBqW39jaIQo51r2zv9jKWfrvbz4h16vu9qF
         Kfs02l6X/xXrF5RAXQV3QErIvYKrD5mrH7T5ToQyaendMOtVtPNXpj9+FiMNpbxkR+ei
         gbObbGLdP6eBv7NnjM3lnFcSGCSB62L7u4PmHoQx/10EvPbH1xMTRWZP7kr0xMT3yI/Y
         OmOQ==
X-Forwarded-Encrypted: i=1; AJvYcCXyCX3KYusaUq3G/Bv+OT+sCWyelR/eDugYKWBQ0N/n85LY6/7IhycAa0FtvUOfZF2OAx/NPnn0jvNzRKI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxF5z3Jxff1p81F6HobV9cRhNFX4OaQmZFB/0g9hpi7wFmhg69e
	VicnrigMDF4lXYnzURSxRRNUq4p4omXI+Pr4PAhW5VGlcMzkz8tD/5zfTjgT8gkxs/jcbeY60iV
	TJdlv1/PI2cf64eIE0VIxtYcpS1xY1iYFMd6PxL9fPegymnSGuVir5B+E7t2FZg==
X-Gm-Gg: ASbGncvaEDnXHejk5T6csVC5btU/1hmWeQmCkliju8eUey6kL6Jm/U/hyaNaGDZXUZK
	6Hb/6h9eKr/qGJ2kjhmb/RXbpYEtxLkkU5l14SLwYDYDLwmiGJYgJiOYj3J701FGY7F/w1itt7A
	a58XUQdFveNypG8zZOn7yRWoA5uzCA2jqNVN++PJZp8F5SBvY97bx/apVELYRzucFKBvvP/4BR1
	GOTlGuBZU8zG9tyRZVoSyHw+bayGnoPKhgc+Vdbrx9SOgJcTf2GupQDyyTEgZcOwGUu8eHehcnl
	2v3dcrtbbQ==
X-Received: by 2002:a05:600c:6b6d:b0:436:51ff:25de with SMTP id 5b1f17b1804b1-4365c77510bmr22352245e9.7.1734602940186;
        Thu, 19 Dec 2024 02:09:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGirXoXRQE0r5vB0TfkeqRe7MfB/RkGpoRNVbjNqtlwjyADuUYTSVPC9u5W6B0bBw1vsjY5kg==
X-Received: by 2002:a05:600c:6b6d:b0:436:51ff:25de with SMTP id 5b1f17b1804b1-4365c77510bmr22351795e9.7.1734602939835;
        Thu, 19 Dec 2024 02:08:59 -0800 (PST)
Received: from [192.168.88.24] (146-241-54-197.dyn.eolo.it. [146.241.54.197])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c89e2d2sm1189392f8f.71.2024.12.19.02.08.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Dec 2024 02:08:59 -0800 (PST)
Message-ID: <badf281c-cccd-41be-9cd7-bf6637c981f0@redhat.com>
Date: Thu, 19 Dec 2024 11:08:57 +0100
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] net: core: Convert inet_addr_is_any() to
 sockaddr_storage
To: Kees Cook <kees@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Simon Horman <horms@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
 Chaitanya Kulkarni <kch@nvidia.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Mike Christie
 <michael.christie@oracle.com>, Max Gurtovoy <mgurtovoy@nvidia.com>,
 Maurizio Lombardi <mlombard@redhat.com>,
 Dmitry Bogdanov <d.bogdanov@yadro.com>,
 Mingzhe Zou <mingzhe.zou@easystack.cn>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 "Dr. David Alan Gilbert" <linux@treblig.org>,
 linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, netdev@vger.kernel.org,
 Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
 linux-hardening@vger.kernel.org
References: <20241217203447.it.588-kees@kernel.org>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20241217203447.it.588-kees@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/17/24 21:34, Kees Cook wrote:
> All the callers of inet_addr_is_any() have a sockaddr_storage-backed
> sockaddr. Avoid casts and switch prototype to the actual object being
> used.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Simon Horman <horms@kernel.org>
> Signed-off-by: Kees Cook <kees@kernel.org>

It looks like the target tree is the networking one. If so, could you
please re-submit including 'net-next' into the subj, so this goes trough
our CI?

Thanks!

Paolo

