Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794686757;
	b=wlYsyjxqoI/ss09aKiRRr9F2iRc6Vo81CYZZUifWIvG23jv8Gw9Lwhx83jRdfxUYiuDl
	 d6Ad2iz+pBJGKjmjgk4v0a2+VNh8nDnB1Ao1K547QNAxGzuqJiCNhCqavwUS6A5Ut3wOm
	 9yHQts/D9JtLM29a/uRqCq7Q1Hpk/zfTt9VCoAwChXmtBgUJI89SRC1E3P90Ua8w2UKrP
	 QUNchSfswULOC+6Oku/EmTnFzFZWIOrOUptOwxirChbU19j+M09smDb1/Lo/XGd/f/59s
	 xa/Q2JYChXvB7BUPBcz9eki43RcEVKaC0Atq8kgmL7qd4iLL8jf9zmRXPUMy86q5dOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794686757;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Message-ID:User-Agent;
	bh=SncZUWGrBOxT9WurRufkDIe8hGFcWm37DANGybHY+fQ=;
	b=lMGL6/DOkg/b3SgIdTSV5z/5EP89iR+5U26Ib49Z0zClzhCtWvZwiivEvPvWGUX3f1Bx
	 NlnoxOZoE0ioJ2g6arz+p999Q+qvzcIe7qYWHzmabKJLZt9y072mfltqjnATDudmcAIry
	 FpMdfYY8t17N0D/d07XsDfpcnU5mpqTjxUjy+V+ZY+hOa1UspgRnrmYKijYjmK0ujznZh
	 g4R53NTfpxLYAJ7K9O9RJKQVCLAGukdvZs1Id01wIT7GYzZIkBlU679YFsjDyFQ+dlDhh
	 gbLO4q1QPAwZEvaVZyWb4kWbIgiYEiL2X39rksSo6jlcGfB+TuDG4V6Lw3D0XRjunjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chrisdown.name;
	spf=pass smtp.mailfrom=chrisdown.name;
	dkim=pass header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=ZNpsvJMi;
	arc=none smtp.remote-ip=209.85.210.179
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7378606A336
	for <target-devel@vger.kernel.org>; Sat, 14 Nov 2026 20:05:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A7378606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=ZNpsvJMi
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-8b5e5e64494so1463749b3a.1
        for <target-devel@vger.kernel.org>; Sat, 14 Nov 2026 12:05:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794686756; x=1795291556; darn=vger.kernel.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SncZUWGrBOxT9WurRufkDIe8hGFcWm37DANGybHY+fQ=;
        b=ZNpsvJMizOoFFuviUq3R3I7xBszXKHR6f+dU2Lhp8+AdJOsuucW/Jpjz4DKxOc01P8
         7Bf2gXYBYorSyL2ypHSps7l13uEx7uOW/BQ3oCjgyM7fn4nszFId/ZhifmOhhkUhMak/
         Krv6vg2ZKrT882kZ97nfZeCj+rR5WiJ1p/wW0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794686756; x=1795291556;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SncZUWGrBOxT9WurRufkDIe8hGFcWm37DANGybHY+fQ=;
        b=tS/M6a6vbnY8sF2QVMQ51BvPxJ2zcNrdRNbY1bxobCGXv3oYJwzfAL4M3MSbCS17rH
         QrdeXX5Of+yDm/HBL24Cp432CptS1QyQ7SASC+g2671M7WwnjbwqZ6AZryghKRY0tINv
         KbeDGYiEnlTogknq/LtrUc4s0skjQgjunan1deTJQRPj+Ke/Deva7g6RDZ60SMY01HBT
         lUoJRxnu3LLXFp90k9kH9MlV0JjRhefvCMYO8I//K1BjY9iMzI+C8kzzFMdV0iRljVRN
         2hGLE7ePTiMK2YjiBbOPxokjXU8n5lAGTay4+N04IgvMx++FFUVyNpmIp2ebHQFuiftD
         4RIQ==
X-Forwarded-Encrypted: i=1; AL+hErEU2X+AGaXf+RogIjZ17vuSKANLCR2wHhxofOhpqfy59nceVUjYRZd0KM7s4yC0OQiLoLs5PULXTEYQaQk=@vger.kernel.org
X-Gm-Message-State: APuU4Z+DvDZcS5onc2blh37Wu9BcI/eLGtj4vjsj9aGRCXED89lMrhvp
	n4dFyZp+NxPxD6+NsINOleTfjy6jfN3z+R3yoSS6J/CuwREMT66NZ1jeLe/DfC3xQpA=
X-Gm-Gg: AYBFou0aNxX/ZvcdBxZ586OnvrSq93gzLm2pqi5BODov6XzXQ6unh6nJ14dPoyF7d+S
	VC4rp6y9/3E8RvPyXqJXjfUvx5uOQ20Hw+XTziluJC8PNWh0OKUK4kYpKUU7MmDaNyv19GkmwOW
	n7zNPIDok11Ea2u8j9hew44YwpE+1aTuYmK9hpcM0HnV/ybiVmYbA3Jpvcsk9seegtpcdwbZ2Oz
	jQJ42sZeMKP0bNUmoFx6Pk9uwosDPemH6xytitJT2R2y0zCRriZA71XPyQO4/WgC6QMswYp4ED5
	cWL9fiEaqyTVzv+F27yQcX7hv109qBf/VIbJ4mBt8DoMqsHfHM3Nncx+MD3vv5e+nWnwGimhlo9
	8R63iJEjmFV7R52VgMQEK2ql2m6frjWbpD81sYe9kwhcnKjG39OHadSdaVYBGGQWOBzNNZ6BHc1
	6eUaC/b/EhMua07uiSGIvX+yystk9Cj6EXiqprLSUEx791iTZZ2Ylj2o4t5FXs/9b2fQGdAzIgR
	sZRSdbo68UcE6X/AvW+uQj0SHXce5J2i3wewYjeGw8ao979SZL7MUYOsF+pMzXRND8OlMcWZM8H
	kCNDVwpodWNXVnGiv8F8q177/aTWAyDX1asebBpiXrMlLuADBpeMBsq/4DGYNiiqNQCObthwQh5
	EcMjY489q2TRZcP4wuRcItEGKamRfdvVvzQWeo2tuFUAdCCVvjzZFy6ZgcX5UH/xDips/ao1RF3
	QjDIcLFKLes3tAt5ehwcBjC0MRJ7AB+b4lyrA2x+tsdXEOz8Wc0uVE0Pz7
X-Received: by 2002:a05:6a21:748b:b0:3e3:37ff:3795 with SMTP id adf61e73a8af0-3f7a4dbfbbfmr5517650637.7.1794686756009;
        Sat, 14 Nov 2026 12:05:56 -0800 (PST)
Received: from [172.22.0.2] ([64.16.22.130])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8bed12a8172sm2271197b3a.13.2026.11.14.12.05.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 12:05:54 -0800 (PST)
Date: Sat, 14 Nov 2026 12:05:50 -0800
From: Chris Down <chris@chrisdown.name>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>,
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	driver-core@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org,
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org,
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-usb@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
	linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org,
	stable@vger.kernel.org, Alexander Mikhalitsyn <alex@amutable.com>,
	Breno Leitao <leitao@debian.org>, Casey Schaufler <casey@schaufler-ca.com>,
	Chuck Lever <cel@kernel.org>, Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH RFC v2 00/42] fs: don't use pseudo filesystem files as
	storage
In-Reply-To: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Post: <mailto:target-devel@vger.kernel.org>
List-Help: <mailto:target-devel+help@vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:target-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261114120550.0c9e73aa12a3072c@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)

Hi Christian,

Patches 1-11, 13-16, 18-26, 28, 31, 32, 34-37 and 39-42 look good to me,
so for those please feel free to add:

Reviewed-by: Chris Down <chris@chrisdown.name>

I've also tested 5, 6, 34-37, 41 and 42. The selftests all pass with the
series applied, and a uid 0 without capabilities can no longer change
/sys/kernel/reboot/mode through a loop device. So for those, please also
feel free to add:

Tested-by: Chris Down <chris@chrisdown.name>

I've replied separately to 17 and 33.

Thanks!

Chris
