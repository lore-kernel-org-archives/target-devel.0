Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794686759;
	b=DQBsvgk6M/CYZh7QUmp/avucuejuiN6F+N3zvnQZk5YhdfTd2KR3wskBBa66dUeqS/Gj
	 j7MIHqTdhkzAchGBStqBxMU3u+f5fSQWKarHEX6gA/FIJPUalK0rWxjNfgWxfhwe35mtk
	 B2CGuWUCqvITyz7Lq7z5zpEXXhsd5r1xSzQrAuCLIzLDBtSjTBMV4kZCo8B63398EQmoE
	 9+1y+5S5T+7Ee+Myf+Lk03I1LsyGF49y8muaqYYI18WD7vkKVZ1H0B446jr24LyvDq034
	 x2N4YDEjz1brn/3DeRFl03zdJjMlNKiVPeOKEJ+n99iE6fzYJ50txl7ytT5fxcWi4Yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794686759;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Message-ID:User-Agent;
	bh=cEK0v6G1yB2cz/8630PKsjvi8Z78P9QyctaIU0ylRW4=;
	b=QEjuHtEuwn7mrvctuymcJ/r9kS+OoQPV17wuR9M/1FAsn+IhUwVeL6T5W6my27GI7/YB
	 EYebcV/F/FQQrf7Puiqof8AVmCKsuHt09x+4T1wmIPIiBYEl4TfyvxXda5DJCpPe05k3R
	 twn1YYm6zgz7wucBnzqTnZG7Oj5+SlnyTmj+F883Q0oe44NCVzzyCBrwH6R1USOHtBVDF
	 Cx9JqkWxbXAF/jC9RbdpQmvuEipNotPakuhWz3CftRVMJXecoqWWjbBd8aYCzpyfFVq7a
	 G2qz3Gp/fB3AK5epekoI0zIWM563/VqeY7UAyvAk8P3xkiS5u8587Seci++D0waxCng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chrisdown.name;
	spf=pass smtp.mailfrom=chrisdown.name;
	dkim=pass header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=t4xxtvlP;
	arc=none smtp.remote-ip=209.85.215.175
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1F7606A8BD
	for <target-devel@vger.kernel.org>; Sat, 14 Nov 2026 20:05:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2E1F7606A8BD
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=t4xxtvlP
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-cc4be0e5351so814322a12.0
        for <target-devel@vger.kernel.org>; Sat, 14 Nov 2026 12:05:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794686758; x=1795291558; darn=vger.kernel.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cEK0v6G1yB2cz/8630PKsjvi8Z78P9QyctaIU0ylRW4=;
        b=t4xxtvlP4RAICjpBIWPIkESb6EJJVOcRd9+LEytv251d1ZQsfD2pYblwETMOf/zroc
         BDzAo5elUgpAiRA0oYEfExHYSjjGywxztBxThvGs665InMbo4S8LytfXKr2B4Cw2IX6x
         hCl30XcWjOl3zGKKK0Vny1KN9lt2zjyLiPz3U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794686758; x=1795291558;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cEK0v6G1yB2cz/8630PKsjvi8Z78P9QyctaIU0ylRW4=;
        b=U8tptpnHauHsNJSb/fTIK70Wi0C7pizd7kCqeETodtNtgUKiAi0X4tAVbwuNJtQSm3
         wk1nWLf2RKpb6CnEalB3wkfMF5s/bFu7ZIiOIyInVWbPt7o0+vFMtJniT7okXZalEhPd
         S2pgLReSYJxiJGU1qc2xaJh5LqDoFqbKouF4uQcfsEg+1V3oyu4bYlsDJZSs0hvcGqGw
         5o926s2VXNzelw2ZVbcHGWtdipAbNAFexZLhbjy6YLBZcJCc1Xo54QG1UHk1+NijImXh
         RxsWY8cPGbL5CDpLk2TA2zGSqAo4JBHqIbZqv/FYAhKGgmvgXcN8Gc3wbyy/RaFsjb2b
         3eYA==
X-Forwarded-Encrypted: i=1; AL+hErGKXUzc45Xf6d2mV4Rfbm7Nkh1YpHhNIhM4d4IPDfnV7/DFS/I34WSOSHwqi4bTHKr1T0GeZE7VXIrPc1g=@vger.kernel.org
X-Gm-Message-State: APuU4Z8URwWvJ0/qCLVLpChn/nu2Ma9Xsdo+O2B3ZRB/aFTrezzexw7/
	CTP+xKMBsw6f5DFuouSyPL13JOf2YS+xHc18OkGNoVBAkYmKXksJWgFkqglebQa/XFw=
X-Gm-Gg: AYBFou1pYKnOokMDPmbYUDv2T/hr8QdlrmQFwx0Kjbg5bGv/DhSY0R5qxlMrvSKu0Gl
	iSinmGgyrzL8WOQb7vsT2sL+vrxyGA5Boniqn64hRdKmPKVp8kseGL0v/Ezs5+ExNDn8q8LRTKv
	XnjzECoZYYDaHL++cCEv+Hg1dSMGFPodPYZL9srn+Urar1iaTssRLxP+Ti0rDGJwetTRkl5Lb9I
	Ds4mT8GybMRyh7+3CqujUdjmm56IKmflo7umXYaDWFZGDSelaiO2HyDmDxxG9Np7vocHFPnFC1k
	vo9V4QGG4c8KYwBA+ewhW680cf0gC7NZdTdBEpx+XMWBwNMFLxfaRmKjn8afrDamP8E/O3mL/QI
	B5vGd3ltzZwLQ9dwA4gJTCtl09AoMmALeK4GxQ2rNBxLKZ1hmZeAVZXtEQWaERUNxPwxzDeN/pd
	IayRwnH7wsw4YVDI5wCJzfS4kBCxs1D2tlChS8LdluZiohoJeYmTa15vb7x8Sv5RkTcMr9eaHxk
	ylt3P9DcFaleBOuqI8tQOAK5fzhhifOf331psmLK/eKCKAKL3gpN5UNiN+vW40djz6Fa0KjQb9X
	8g/+8XgaVtgDrSve8I38MKXYwnZefxxX09iCZcU6Eh6vtta1kloZbHj6J5oHfrUzEXUgdDmvDvk
	WwQhq4tWk4jW0UovWEXSd1+1QcS0pej/d80UxSzSJiswrhHsHkYN0Xl9Re9aAMBhLVYchfaFWcc
	f4yHjP2/qxr+1MVtKsj1CtzEzYilACtceU6xejbzNZmwi9IvA3er7onk92
X-Received: by 2002:a17:90b:3b8a:b0:3b0:9f53:e8a8 with SMTP id 98e67ed59e1d1-3b1b0b5f2c1mr6192503a91.52.1794686758572;
        Sat, 14 Nov 2026 12:05:58 -0800 (PST)
Received: from [172.22.0.2] ([64.16.22.130])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1b266d873sm4654869a91.1.2026.11.14.12.05.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 12:05:57 -0800 (PST)
Date: Sat, 14 Nov 2026 12:05:55 -0800
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
	Alexander Mikhalitsyn <alex@amutable.com>
Subject: Re: [PATCH RFC v2 17/42] securityfs: use fc_init_pseudo()
In-Reply-To: <20261114-work-loop-pseudo-v2-17-98639a2286fb@kernel.org>
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
	<20261114-work-loop-pseudo-v2-17-98639a2286fb@kernel.org>
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
Message-ID: <20261114120555.cbfaf8ab8a92fb25@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)

Hi Christian,

Christian Brauner writes:
>AppArmor puts a .null device node into securityfs but only ever opens
>it via dentry_open() which doesn't care about SB_I_NODEV.

Not a big deal, but userspace can see that node too, as
/sys/kernel/security/apparmor/.null. Opening it by path works in current
kernels and fails with EACCES after this patch. Now, I don't know of
anything that does that, but selinuxfs gets SB_I_NODEV cleared again in
the next patch for the same kind of node, so I think we should do the
same thing here. If not, it would be good to have a line in the
changelog saying that opening it by path is meant to stop working.

Once that's fixed, please feel free to add:

Reviewed-by: Chris Down <chris@chrisdown.name>
