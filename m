Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564785;
	b=RxwcxssVWzotudjZzIbYW54Uf0lO5MtSDXvIOZuyxQN7yR7QRdwCxGdRE7TGKIZ0YdIy
	 xisxI1UZzdxO02JIdDZ4rzk5dSS+BF778JKWLXXflAzOoFpw1HmvFIzlcYT1Pg7LtpqTY
	 JZE0jUfHSicjW3O5kpBqCgcAuB9XLgLInF7bUKG512m+KoPfZnTfwlteBdjU3PCX3Syb+
	 PNhluJm2BWctbjZoHia5KAs2EDqgtGtbFS93RkxBVCo6EDpQWK+YGKrcvJFRGBpcsFllo
	 btDKjX8yGwbnrTZclLVhtboLfcXkX4CH+96UlBCb+0e6eaRQfv4VoJN3LJYckI1mV7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564785;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=PGZ86VpI4/X6bkLIqgY54HnsW6MSps296zHbeFwxlLU=;
	b=htYctjuUIBuTwkOAcgnwlPmtH5zUZFjWXKvNHNkHiwq8zfvWrH2JbJyvC+7swVGzs1GB
	 3+a2v6XK9XR1iPZROzI79Qao4VDgC2GD3O7Wtmc4WYDaXxxAKQYJk99ri/Pr3MJNLsFwr
	 RCiDtRc8sJwInX4kYipmZPZQN5spa3lpY/GhsPU1vDXVwqU4yaJ3phRUadsr9CkTu/HpP
	 Il/p8p2B/XAcrjzTbZQ75Z70BVeWuzxzSh6anr064qGg+akuugbzfApEawcUo50k1XxIQ
	 FaFbW0uSZwL9viqLUOKnhwXQyH3zdu3wOvTxYk49rjZrUIiIQ4WHI8G/H/V4dIs46Sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=qhgXZLcH;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97624606A88B
	for <target-devel@vger.kernel.org>; Fri, 13 Nov 2026 10:13:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 97624606A88B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=qhgXZLcH
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4ba013938d7so10467105e9.2
        for <target-devel@vger.kernel.org>; Fri, 13 Nov 2026 02:13:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564783; x=1795169583; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=PGZ86VpI4/X6bkLIqgY54HnsW6MSps296zHbeFwxlLU=;
        b=qhgXZLcHEG/xp1ftPxi4Y+VtkR5xPsdZusiH6E7v1UVOpu+pQQwW0vkLZszWZiEzcA
         +BIaLUI7scE4yUL73wk7QDgrWayWPrLwdz+Upaai9wvZdfIC4mpAyM7/MboFd4cm+sgl
         6S6dsMSsgGsAMWrOW2SdAqPT3x/sY2fNDxpywpmU57N6cPKU4MQNdvXTLk3fPNzTNPjQ
         TN2vMd0rw8z+5ZJqFwtlFaNorLJKFpgZtePYZzAG9uux/UTV4iwPxrV7Aluh/WlU8Te+
         mKwCC2bzY5T7ZateqcC/h9wnCcfLq6dmSfmWCE2kpyRSPYXephvqiHzXHW2gW5l+Jqy/
         ZrPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564783; x=1795169583;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PGZ86VpI4/X6bkLIqgY54HnsW6MSps296zHbeFwxlLU=;
        b=dgVZptSVlO+8cVWxHrMrACs6Os6f+sYHzAirCkz95enn90r6mlf/a05YzCgNPdeukT
         VFYcx7WrBvYH4KavfHrr5r8AJ3DzpQKYxmsV8B9NT9ark9+89wFLaOv3JMZf5D0+xiMZ
         A5+iuPraOuc+WNe+B4A7y1ogzxgmCZSM3k7ICM+nZFT/z+C26dvreT2hxofHTAyYGANs
         9npgyrbQlt0SwtgH3U/Ykb6xNy1NPjjkDGVKYGAQmZBmY1HEDgjG1Ea6Mh7xbDpbLe3Q
         qqMAkcO7Q5CsmfVOmP1SRdcm4rZVP1zWZk7JvxkmdBTEhDKvR6nvRbsTFW4aqL1l84Cn
         d0Ig==
X-Forwarded-Encrypted: i=1; AL+hErGIvz9lkY+ndPK7SoOF465hE+tA8SUsEpvG7l4AjDj5SHoz85+Pk649NyIUnnsh5nBksn4s9Ukq+evQ2qI=@vger.kernel.org
X-Gm-Message-State: APuU4Z/Sey76TRxkSZ7uInsZEOLWc2ZZ3SL1WYrE4EG6w0X1fnwLF2zd
	aUO5sroCUTL/c+YAer3asSaOFn0yBsnU1zdvoKVArhOxh+TXNCHpEYiZ4SNmRC1IayAf
X-Gm-Gg: AYBFou3RzsM7bdDKWRrdEPFYLQJUqwRn1Sw2ge8N6X1duDLlRTpQNjJK7tWpdYAkpgF
	V0jd7r1+NMXCdBYCgZNwB/7dBFpZ3E9dFpK06amiPhJmBGBhtdowwLiirXF0zNFGDMx9gurorXA
	8pWnS9y7rtcEvKXNClnr4MAODa/LT9Z4WM2cTbbzFEVioKHvY/X7k8aI6LJjdlaCMN/zBeO+0nj
	ZM+ut/J6QbCFX0xxV0OxsBnlgBP2KzYgNz/7MJSm2swzqZSg1nJB3jvkTbAT6Klqyw9zWs4VLra
	ZkqXy+Hk3bMPK1l8kqAsTVHsl87y5dedw55okLup9AOLhlTBydZExWZG7SvlMOa204SkipvYtfA
	/We4ZM35sUUUYGZ5dGOQrHvLOyNvqZBXzj/3wOnSrz+H7pHG3QZYYqGtWoQ1qwYDfi+E5/Zussp
	sWzuITDatHEFnyijrXtnfBAev598XYb1KZp528/eJttXGyAL3lCRzkd/ij9z9Cg9NRu2+tiYUT9
	AuCziUWGCV1+YSinJrDnWKTV50IwDHblPILBTL9N8ue2G3VQ6pWS4b+FPTXGjZ1dkwFmd6qZbMH
	rxKf5jGJ0QsvvEQ0mEb3zOAV2Bv6NuSVUIFoHbvP13VAFTj0GTQsWVNO9C4vk7S6
X-Received: by 2002:a05:600c:4f90:b0:4b7:6c16:7b43 with SMTP id 5b1f17b1804b1-4bb55a47602mr36814615e9.10.1794564782834;
        Fri, 13 Nov 2026 02:13:02 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb5d2872edsm4056955e9.12.2026.11.13.02.13.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:13:02 -0800 (PST)
Message-ID: <94dfa5ec75f4479663dd79f3ce05c1dc6c080185.camel@amutable.com>
Subject: Re: [PATCH RFC 22/41] sunrpc: use fc_init_pseudo() for rpc_pipefs
From: Alexander Mikhalitsyn <alex@amutable.com>
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, Josef
 Bacik	 <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, 	driver-core@lists.linux.dev,
 linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org,
 netdev@vger.kernel.org, 	fuse-devel@lists.linux.dev,
 linux-efi@vger.kernel.org, 	xen-devel@lists.xenproject.org,
 ocfs2-devel@lists.linux.dev, 	linux-s390@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, 	linux-usb@vger.kernel.org, Amir Goldstein
 <amir73il@gmail.com>, 	linux-erofs@lists.ozlabs.org,
 linux-kselftest@vger.kernel.org
Date: Fri, 13 Nov 2026 11:13:00 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-22-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-22-4c998976c6c7@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Post: <mailto:target-devel@vger.kernel.org>
List-Help: <mailto:target-devel+help@vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:target-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Tue, 2026-11-10 at 10:14 +0100, Christian Brauner wrote:
> Initialize rpc_pipefs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. rpc_pipefs never holds executables
> or
> device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0net/sunrpc/rpc_pipe.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/net/sunrpc/rpc_pipe.c b/net/sunrpc/rpc_pipe.c
> index 9d349cfbc483..37277a6d2415 100644
> --- a/net/sunrpc/rpc_pipe.c
> +++ b/net/sunrpc/rpc_pipe.c
> @@ -15,6 +15,7 @@
> =C2=A0#include <linux/pagemap.h>
> =C2=A0#include <linux/mount.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/namei.h>
> =C2=A0#include <linux/fsnotify.h>
> =C2=A0#include <linux/kernel.h>
> @@ -1181,6 +1182,7 @@ static int rpc_init_fs_context(struct
> fs_context *fc)
> =C2=A0{
> =C2=A0	put_user_ns(fc->user_ns);
> =C2=A0	fc->user_ns =3D get_user_ns(fc->net_ns->user_ns);
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &rpc_fs_context_ops;
> =C2=A0	return 0;
> =C2=A0}
