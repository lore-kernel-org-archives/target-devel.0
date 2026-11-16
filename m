Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794830457;
	b=tIzl1D5BYVJiLSTLOMfHm9thj7M6TpOVsEMlyNB5e6Pdjx9Fpv1LMQx0nKOJLwFwc7rY
	 Zt6ePMX7yALgHyyw7zfc38pgLQRYMFdJdLTkBM63DvetKJ8SJQYox2R5r8U5mg6TXWBfD
	 AU//eYftzUNypWqaswfLD/QRraw7/iBZAI7ZB2cOkdFqbgR8srTazn3hGKueEL/o3+hHV
	 fcYfPgOgl2cyy86/PlAWw/lZlFxD1MEGHdqpun1VFWL6MiNXMAVndEzZt5D4+sbGrzW40
	 zIHh7JXQHWBlRksjt9vp1uSidQ2jv2hMuNsQy6WYqE/HermyOtrEYdxFvLjUdh03kHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794830457;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=kLAz6sn1EqmF7aJ7KDEBtraVgj4ybxLcfJJY1MY6K34=;
	b=TJEU16WNdDZtUSKp8rp6tqcWwy7hNnT3dkQv5GsMwvdo8rqgiVwJ99dUGuiVKr4sY7f+
	 j7RVSzxiE/LlzOonJ4qCQMWqXKkvHny22VEocz9yKAm1jXDbrxHofDE4JbNf+HcMYXI3T
	 Hy0rQPRNFk86/3M+kTeCb6Zln84yayS5J6rHYLsZNSz8BKvJS092oGBSzewrh0CdnK5I6
	 hluAJAi3yaTZAONSVLR/ig4YY8mM5R2JmcMDRA94JuhHQWzj4SIDIX140afRToD2bgUz6
	 tB2Oeu78R8zW4MsymndgCwPxkYF0NPDDkd3w8LGZPPimFX/l2IqOs8PX7tXoiTM7jbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=O4rHL3AM;
	arc=none smtp.remote-ip=209.85.221.69
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B12E606A335
	for <target-devel@vger.kernel.org>; Mon, 16 Nov 2026 12:00:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2B12E606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=O4rHL3AM
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-48e0461e040so2973437f8f.0
        for <target-devel@vger.kernel.org>; Mon, 16 Nov 2026 04:00:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794830455; x=1795435255; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kLAz6sn1EqmF7aJ7KDEBtraVgj4ybxLcfJJY1MY6K34=;
        b=O4rHL3AM8g7HMj7xZzkNnKWsQ68P7OhGhMaTci2p92KRiCQKBRod6d2IiBWvipb+DC
         vxIULYuCXp15OPRCoakat7UXJvZIlTm3l608ZOpeQ2tSQXP8F1JduWNlJvmJluBhwx82
         /zjz5RQKsdngqWq2MmIuxSHyh06B4MAfnWmvKvQxetAbGOpMt4tj9yv1/rUEGuXhF3Op
         l1j81S/wHFyKHwmHIqKvzrYEnY13ONP2ciqmD/iT3Hmn84+4ykJqyBiqChsToNXVzSp+
         o+ANBoTZBCPfy4AMYnFAKcCDqm4IN6I9woJSAZjp0OJbMp9884FpNNs3o+ebUrN8UDGH
         OZVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794830455; x=1795435255;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kLAz6sn1EqmF7aJ7KDEBtraVgj4ybxLcfJJY1MY6K34=;
        b=jpTIolkQ2dU+QkvqM6e7YG3jb0LKwJqfrw4BzcPwmOzQiQk4mwfsOc8sRX+XMoADN2
         Swja63XKCg9GkUJTlzK/pqdYQY4wOARZFgEDSWL51cZe6kxWSPGUZiBtE4KRLmj/Q7ai
         y0h7QwMS28gHzd51ECCHmjx/GhcAi2A9blRhnG80au6shY2sVgephQizX52qPewyaLtI
         oBA4opuOBxj3+uL780UYgGwhHDzdaOIc7hQousQAhbfPzRl/oUO0br+xsBaRhCzopQPy
         A2s35UhCcO66mqequ6OUbsSJpu/kXUnEq4nwenGKR8P3o3CfdzE4terxQxerYWMPAmu4
         FHaA==
X-Forwarded-Encrypted: i=1; AL+hErHGVBEAE8458X/0TonmVLcqJ2MYWbk0FOL49rV1YAERAMoDrbXC6yCIgNbK7x3grpgF9fuppwWviH5usVs=@vger.kernel.org
X-Gm-Message-State: APuU4Z+qB8EsIGbNnhSQD90iCU9XiyoRCJE9ud9kBB6cKdNgjRPlNNo1
	7ebFjaj53Ajw6mu4c7Kf6oJS6rFenCaIuMZS7ZR2uAdAHS1D7y3tphF5qr155LQA3UtPvuPboi7
	bgmrzj2HQRd88hvYtZg==
X-Received: from wrso13.prod.google.com ([2002:a5d:474d:0:b0:493:3d97:6e88])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:adf:e007:0:20b0:48e:3697:708d with SMTP id ffacd0b85a97d-49c70ed8e41mr16698595f8f.12.1794830455230;
 Mon, 16 Nov 2026 04:00:55 -0800 (PST)
Date: Mon, 16 Nov 2026 12:00:53 +0000
In-Reply-To: <20261116-work-loop-pseudo-v3-12-8cbbea1cf34f@kernel.org>
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Post: <mailto:target-devel@vger.kernel.org>
List-Help: <mailto:target-devel+help@vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:target-devel+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org> <20261116-work-loop-pseudo-v3-12-8cbbea1cf34f@kernel.org>
X-Mailer: git-send-email 2.56.0.611.g1030f0b940-goog
Message-ID: <20261116120053.371591-1-aliceryhl@google.com>
Subject: Re: [PATCH RFC v3 12/44] rust_binderfs: use fc_init_pseudo()
From: Alice Ryhl <aliceryhl@google.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>, linux-fsdevel@vger.kernel.org, 
	Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, netdev@vger.kernel.org, 
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org, 
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev, 
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-usb@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, 
	linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, Nov 16, 2026 at 12:04:45PM +0100, Christian Brauner wrote:
> Initialize binderfs as a pseudo filesystem instead of raising SB_I_NOEXEC
> by hand. This adds SB_I_PSEUDO. binderfs_fill_super() keeps clearing
> SB_I_NODEV for the binder device nodes.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
