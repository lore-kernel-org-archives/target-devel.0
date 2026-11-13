Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564237;
	b=jIq8yKQKBmiL7LWLI2YaAM3zK9prQMaTzEvZgl+Eda4nAuLuH7hJ1nvOBWPB25Wqd9K7
	 Fnx+3zWAayi0hEktktTiI7AvJSGUZBC//4y1FTbq2gYCo9pOqo5xom4Ayqb5pzawwnuuE
	 k87r6hHSUILDkvY+2kbdTeKpEuXk3damy5bp60dIoNufQWxCXbA0+BNtfnrGLpuj9p97h
	 8IoNjtCCzDvGQVIyoVFEcel4rM9FMyfX5/pk6BKnOrcTua3tOqkBCCmV5EpUnGDU+P25R
	 3exTbw1Bh7Ud6ImDMTXCg8EVa/dloaxtJLPHtVy6w3eqyw4STxwRMyao1UVX9GkNFzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564237;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=isfwHOSFEU1THdAtyjNR/BymwB+TGu4CpGjFt5oul8o=;
	b=KXmPY/N08vKI2MOahUGIpeJPbMn/esXgYGn53TOE+mapKV3Nt9II8YTwBkTF7tAySyfk
	 Q+XQVVBswH24Q6MbAn5FTwSDAH0LMYQIszDI6rF16onTPtbS3Z+lplPf7fiBnSLdAuK5n
	 /vlMgXTJNTn8PuuBlFOtmgJK/lE5yIzxW4SG+E7b0KN6r/vM5h0pDKSgQzqlQ27ymyJyy
	 1QtvgCumOkHaglt4Wrvs38Gk3m3VyxZjw/KWp7gxATimMQtXeiXy6MnVSFz1bJDTuM+7O
	 ddx2/451xbEouxl219NWv8rdvqA8B9t8dIoV12hRdTkT9zNCzi6Wh8MkCg29HcyZ3oA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=HmOhZp1a;
	arc=none smtp.remote-ip=209.85.208.47
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0F5606A881
	for <target-devel@vger.kernel.org>; Fri, 13 Nov 2026 10:03:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BB0F5606A881
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=HmOhZp1a
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6b56c428212so1145031a12.2
        for <target-devel@vger.kernel.org>; Fri, 13 Nov 2026 02:03:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564235; x=1795169035; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=isfwHOSFEU1THdAtyjNR/BymwB+TGu4CpGjFt5oul8o=;
        b=HmOhZp1aysVRSGcApaAZDLI81xyeSldeu7ePLUPKkH54FsFfnK+QDVFY4+VQQZDD5I
         H2HloBZm5LZmO+0yz1W9rfEhaL+YICMUwpLNmuFaGXNfAv5LYB2fsAN36refSeHGX9fO
         cryYVQ+kM2KCw8u+OcP3112ltvgpCHGvfl9d9GfdLtqmNcwNDmKz3KTPAT46qO03zj8M
         uuWZNkUaGTWe7Ooua9eiEAKQiiHx3qf0rn/l3lNWMOa2sfege5hzg+R5XNTSj8AN0bpY
         dCBAZCrR4vjcQdomnF2hzC3FA98LaruL1WYTiCQ1DC9kzlEXZqoLyeQdM7U6VrMRD1VV
         Lr3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564235; x=1795169035;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=isfwHOSFEU1THdAtyjNR/BymwB+TGu4CpGjFt5oul8o=;
        b=1KJtiMt7dqHV9Qm1FKPTPtvBzWa4aPcdNfOP2xKWK+uNRa0Xp3VQpZAgljpT/KjFkJ
         8R9siK2z5oZ11yR1/lmcluVyITyeoCLBLdUuGkEvBMYdHL2Pd6L/hJTHhtdNKiK5WMCb
         ap8YUMUEEa2uPgFvkXFAe/NXeY3lJTtsOF6f1ASwfiBbP6KcTfz28j7/XL9xz0d7debO
         TzZAkAD/I+tS9JFvJAI6HpGsLHOE3HZa2B0T3qTK6cOceEwkg7R4FmVIjsIEh7pVLIvt
         vyoB2JbeX8ctWzWRRVR6fD6KV9hjUfSLqTC7Oi6uK9SBtIUIi1qmQo2XTqSImqMbYLUK
         zxIQ==
X-Forwarded-Encrypted: i=1; AL+hErH8tWvEvnv5/fz/FIhzEdFTpjuO34woCqgyYx9ZNNYPDLQ9pw57ua0rrdJAH4/yYz8yTHjdpgXqF7vb2tM=@vger.kernel.org
X-Gm-Message-State: APuU4Z9Lp0FnDx/zDvYGDrRy1x8UiBs8H6eqGtnPJeqDyDrMcx3PCVP1
	DwGNs3VIUXwDatH1NoA92yr9HaQXnSviJkb8dvLMGhZgeU68kp40Mef2xnNp8RzcXwe4
X-Gm-Gg: AYBFou2uUECX9CsiCE3EIXXCoAlyfUm9Vi3UQdIs74S1kFXqIrLvRmds09H5wjlntqq
	ADlPK72UGp8gRJwxZVyWlm56MeIUqZsDT78nr0o3SS2dYyyZCoZ6hTBsAAU+MK+1u4WCKdBk9p5
	uNCCmYiEMC6MixXKv2mN79nL48VPM7TQAbsu18s0349lwf3dZio3EJT/WvCreiik+zW6vmdtkUp
	OFODaglPgLBfY1hJJc8fn/WTqXNCPztf8MUwe+c7oFx3gFCEbnWoMqFeeWR4/dnaQRUPzdEodO5
	R1hGYO94CM9OyhRV7xnogRgJTE2r7YTa7obHzNx2AWDSSW+Qv3w2UHPyTptA6tE+ix6M31DCL7f
	v0Pay3h0hJcP9UUjV4wBLW/qy+ZTdviqghIzsKGC7QzY30ggrdgENs8h+rpk7l4580JEKQ4CWBp
	bKpC9gImPXhClRatGKK6BxP6ITQsT5RNmLpt6dfhawtAILx+EDhIk9qlM2pbGyX1OJTYc0TEV8k
	4jeTnqZHvLSEHrJTPV71c4Bx1kYGs8c+0d1O06lC+9UUWHWtNGcKsknM2YDns4SUF/gVJMLGHB4
	EC/2zLuJBv2ilq6WeIgzl5+LGsaSDaa4eAEp6KYwboV+mrlrbS9QPA9qHfrbeus=
X-Received: by 2002:aa7:d556:0:b0:6b5:96e9:ae97 with SMTP id 4fb4d7f45d1cf-6b7c0ccaafdmr1234919a12.34.1794564235160;
        Fri, 13 Nov 2026 02:03:55 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b7c23611casm766458a12.9.2026.11.13.02.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:03:54 -0800 (PST)
Message-ID: <16dbddeb5cbb9613dc806b43fc681eb26aa3b0dd.camel@amutable.com>
Subject: Re: [PATCH RFC 10/41] nullfs: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:03:52 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-10-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-10-4c998976c6c7@kernel.org>
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
> Initialize nullfs as a pseudo filesystem instead of raising
> SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/nullfs.c | 3 ++-
> =C2=A01 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/nullfs.c b/fs/nullfs.c
> index 319c2f5c5a67..2fe24cb97160 100644
> --- a/fs/nullfs.c
> +++ b/fs/nullfs.c
> @@ -2,6 +2,7 @@
> =C2=A0/* Copyright (c) 2026 Christian Brauner <brauner@kernel.org> */
> =C2=A0#include <linux/fs/super_types.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/magic.h>
> =C2=A0#include <linux/splice.h>
> =C2=A0#include <linux/uio.h>
> @@ -174,7 +175,7 @@ static int nullfs_init_fs_context(struct
> fs_context *fc)
> =C2=A0{
> =C2=A0	fc->ops		=3D &nullfs_fs_context_ops;
> =C2=A0	fc->sb_flags	|=3D SB_NOUSER;
> -	fc->s_iflags	|=3D SB_I_NOEXEC | SB_I_NODEV;
> +	fc_init_pseudo(fc);
> =C2=A0	return 0;
> =C2=A0}
> =C2=A0
