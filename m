Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564841;
	b=rY6u3lUQPZDND/w6px2uzVWs74SM+u4x4u8/ah8hq4DTxaYeq4nR33zN+dfQoDvJcb06
	 jNBzqqlDM9bFS5dj9weQPfHhuawmub1QKuUNiE+stg0OTeX2Y8Ad1CRa1uh7NUjrmwxfq
	 W2zeOXZhDGDyYp04UyrkklTlAW6YAWcis4FxNgfRLQIXl+goA1V8iiPAPUh1Z8SX17vmj
	 1WgdxVpfcnmrL2I7W3Kes+u8VT5kCnq0PkduiUR6z6yUjOCbqNkgWG7vM8vJOPJzFD0P4
	 +oWtD9LbnvQhoL3DNFTBbEOi2+WMif7nYuwjCInndjyP/GF8mEi5ATXwcG/QMAjB0vA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564841;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=LWRhkHq/o14g3eGvU8PB/2eVsiZ8AcgjQiitoPu4Uko=;
	b=bSRYHLiXpOkHvXSuiVM8ULf3i8HLOkn+2o7Fnzf2Elu9b+HQc2ncXL9PH2vMsNgXG48h
	 nB/9bkz7b5f/NxziOmWJQ9V04xFAuUA0mW7ZpIzW+hVPaELwTtfk7RHajETHvWQx3R7tz
	 GCbfKpdqUQIL/KF2yRqOLSy63GnLDTZ9go2KIb8NdQ1iAL6GMINMosU2BHWTb+5MoaK6O
	 rKb4ChVgKr3a5aw4ZV/MyqSrjGYoch98WxwvQeC8xKtrTVvXh3khdOIBLa7IES8YB3bN5
	 Ih7hTJP8EW7wkpMNd8T6JLUDHHRlAZDFDluoIbbNOSOAQsyDCWMiu0dvbEoS4ShEbuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=fgkfOyvU;
	arc=none smtp.remote-ip=209.85.221.50
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52528606A8B4
	for <target-devel@vger.kernel.org>; Fri, 13 Nov 2026 10:14:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 52528606A8B4
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=fgkfOyvU
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-491d1f66968so207275f8f.0
        for <target-devel@vger.kernel.org>; Fri, 13 Nov 2026 02:14:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564839; x=1795169639; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=LWRhkHq/o14g3eGvU8PB/2eVsiZ8AcgjQiitoPu4Uko=;
        b=fgkfOyvUu8xf6W8q9zChbNscxyQBBGlOoHgKBKJ1BkQkWvPVGihrF+rRK/++Rh9GyG
         JHspcfYOBNPixo8oPKNP4HMqn4Pm5ECxNu6WadiPSEV1Ef7s5pMOTmdpp1h0qheNYCAL
         reGCPjjBuRkeLgJtvMnJj51efD/XBAnW7OBUZupe3DEOpiY9mIzToOLvbGpl9PZAiITD
         ja/hKOWfLJ2HwVqW5WbU5vpLe4u/8sEd47rKsdelsOgJDSYM8eMKS9Bg+p1Lcupp+2o7
         A8nYundFQzH4qm98PvOkGZvKdsA4h3jxn0f8A/jmsMNUP8nMz4irJ6DT1xabl6IkGIEw
         iw2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564839; x=1795169639;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LWRhkHq/o14g3eGvU8PB/2eVsiZ8AcgjQiitoPu4Uko=;
        b=qWJs0SUi/DP0J6NDDB5X5OPhD6HWsJjHWgX/Ro/QekqB5lZXEEYxoe1wj0NzUQVF6c
         fLF4a36CgP9TCLfnXX4Md1Jek0CDcDnRqhy8N8TOjG+xHcmrJNHVLfphiohN/DOt1ls6
         u2HYzfjeDHc0T9AX2wARYLfGaqTPDPF8FiNVUJZ829zRz/rd6v/wILg1KcKQ+QAUgFHj
         0h5hEkRvt2774wyMuFNtyRYO/iFHuj2nR0S5p00oWv9q4AVw4kH1nyjMynv5P+HfEWWc
         NVnFcYku8e8PZbBF2IFUQPAQbQ1NP8h3H5XHFYqiNqSWr53JFihmP2d6A8/uKlc29/6v
         YXuQ==
X-Forwarded-Encrypted: i=1; AL+hErH6Nt9uJzOIDpToFsPB7+W2XsbmRr7QiHRZVFCmobRejlYya5bGy4IG2MX76oIhKgtV6LxdwDV2Z3GYk4I=@vger.kernel.org
X-Gm-Message-State: APuU4Z840D22JklCh41HTvrT9cEJb9CMc8YVN+8GMMuYNN72XQlH5QtS
	DrFRZHkZyhSPjqqDs5kA38mYfDk/QnGhBJ1xvfNOQQK9a2N/lp9vGyj/+QNrEeRdEkCH
X-Gm-Gg: AYBFou1mvOnXFwC+tiB30GtdzWxW4b0y5KqCHs5XYEXXnoMqbjuVRZ+yJf4kJTrA39R
	XAEb+s9JJzMgFxa7R8+e83jgMX/7cc39/Osy7fcrC27Rfd1eaxc5jRL7MGaxoyBH98//J7qG2dw
	MSzOuDNCGov0t85vWV9n8C2vG3qR54UQ5bSrrdtE2WLOEJO4nVOmc34V3BS6ba23ffAo8pdf03C
	E26uznsrP/ft5l8wxRHptFc9kQ2/veXJpKgd4TcxgU07okkRbeZ8BxY3UBqUWXAqCk9p0LpWC9I
	Su9l6uIhlFSBWcJeq+VXtEkmmeiqnVq67y0JEHt8ZpaARuAruFYIIpO1k9zEv2SJDTX6ieYoCLK
	bS7Yd1T7VBjEh2BtRpu95XfJoPsjGVB5VaF4UoeK70fB+SgNIcQR89BNaP1F4suJxdZqXZ6eANQ
	4lyV6UVODYKv7bEtlno+RL8IYlElGU3y/jJHII2l3M9fFOrLqQXcEGE30Iyd6WFRoWireQipzfa
	Bxh5Yc0e+eGlsdliKio6PkrbjiRysfCi1/wM/KrtMoAhI86h5xnmJEKRPETOhQm5A/t1cHm4izu
	iP13ztj64d8GN0pFWQtA2PYxMUDlb3+gQxvWk0MCVbRGUQIsqBBKST5RoGIlZWo=
X-Received: by 2002:a05:6000:993:b0:48f:bc59:ab9c with SMTP id ffacd0b85a97d-49c6fd932f0mr4358101f8f.12.1794564838578;
        Fri, 13 Nov 2026 02:13:58 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49d673ce75fsm190118f8f.55.2026.11.13.02.13.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:13:58 -0800 (PST)
Message-ID: <77855be3fb9f0e1888c6dddc56d73a1683c820f0.camel@amutable.com>
Subject: Re: [PATCH RFC 25/41] pstore: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:13:56 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-25-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-25-4c998976c6c7@kernel.org>
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
> Initialize pstore as a pseudo filesystem. This raises SB_I_PSEUDO and
> also SB_I_NOEXEC and SB_I_NODEV. pstore never holds executables or
> device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/pstore/inode.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
> index cf499ba72702..4658561cf90b 100644
> --- a/fs/pstore/inode.c
> +++ b/fs/pstore/inode.c
> @@ -18,6 +18,7 @@
> =C2=A0#include <linux/ramfs.h>
> =C2=A0#include <linux/fs_parser.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/sched.h>
> =C2=A0#include <linux/magic.h>
> =C2=A0#include <linux/pstore.h>
> @@ -491,6 +492,7 @@ static int pstore_init_fs_context(struct
> fs_context *fc)
> =C2=A0	ctx->kmsg_bytes =3D kmsg_bytes;
> =C2=A0
> =C2=A0	fc->fs_private =3D ctx;
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &pstore_context_ops;
> =C2=A0
> =C2=A0	return 0;
