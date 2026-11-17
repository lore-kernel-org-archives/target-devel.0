Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794904595;
	b=HLUHlJXz0T4qw/DKNY1RGS0GItcGL/+jRkI+qjXBynJ67BxgYMnSabrUTI/Fm92DXWwE
	 gaMVNAcS3mTDOB+P7sYgGlMeTfSleJdn63PCophxPF3sei2MKRLzxXjn6cXTBgFhv92MO
	 /M09R9+rAIHtMjrjB0xWcEcGF2lyjdUy8dFpnRLQgnVLRkFSOgkcRW2FdLtXb28vkMpY0
	 EjQwo1gPlyauQorUTCaj8uK3r+oewtifLx/OBpmyV5L+S+1wIUs9NubUdkFRnmTD+wch5
	 L0Uk+al1BH6Q2wW/3zOnakqomWphbkL4tWdp3s8oqW1fpqHJO756auhxN4P16VOi7CQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794904595;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=u/hxpfxH2Ygjpkkpn+gEQ4NFMpeA+YPAHTw9d0qdSc4=;
	b=RmJv62G01yxQt7Hpu3M3vdmCeJ9IqT66+nvu6o+/K1iHNCAEONX1uulSvPcEaZQnrOxP
	 1dWmqkDFGlSminglY2vr4zUPVvZ+lGQ31ouOnPDlIrLU5+b0BwlE58+32zxGCXsO4adtT
	 Nmh9IlUtG753cgVLvKWUWlEL+TRSwKjeRuXv6uGQ+6CCu/Z6BoQM4Z+TiXlaToLN1g/O/
	 2MDhuR00B+XD8ZEy3yJ6ieT+Y3RJjdR0DKYXlRWlJ6RpSaqip2Dmq5Q4B2LMvaiKhbIhh
	 zEo/xtjhxm/C1FrKzuHVf9EqvxOSUaDITdBwBKBUgYsInOCVkEhNyFLuSyZgWUzFcXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=VB84C1sh;
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE51F606A89E
	for <target-devel@vger.kernel.org>; Tue, 17 Nov 2026 08:36:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CE51F606A89E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=VB84C1sh
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4b467581b98so39088915e9.0
        for <target-devel@vger.kernel.org>; Tue, 17 Nov 2026 00:36:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794904592; x=1795509392; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=u/hxpfxH2Ygjpkkpn+gEQ4NFMpeA+YPAHTw9d0qdSc4=;
        b=VB84C1shjSG034pSk2oK3egXlQwWjuu3VjrdbAKPawk/Twv4Yif6yhPlbROFWtMgPQ
         3tz2NQZOgPBk3fq0QRZC/paJXFCSb8aJt/mhh+A0iXMTZvR4a2C4xo37cxqDT+bS5wyK
         cFfqQ64HX4H+WtOYlqmaNWk53bLD4rVzH3Dam/22N7EldMgTIeT60YiznWNjIzN+eEJD
         Zc6kl9xoD3REW2KAU35dfm9/7zuNgWUL6hteTTxoqyJmYKiacM/NYuvwNSKHsMwzezat
         1L4qftGlpMPZouPAaee8sA2dATEpRVvU+RzrgkUS2mvSj/+KFRi5Npjbd19v9tUdsF88
         Zbrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794904592; x=1795509392;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=u/hxpfxH2Ygjpkkpn+gEQ4NFMpeA+YPAHTw9d0qdSc4=;
        b=wU/y4Vi6bpFTErlhGTYmULAKkBMQ5lQ7OIcEsAKwRksUBkPHuxOGSOq8MRRUhVRLTX
         gGBL9coIYJ68Dt52+eDp4hGHvwc2rljSXWVtizsZ9vwmhQnD0dk1fQyQN7nVkGDI1G3f
         h0f4wBp4vUn1TIDTg4PF36tE9GbSvLtShgHRt9wVct9QK/dTEuG0wyHhIhWMdLraDaDD
         CjY3qPCPSoGpLYPDaEIYntNX/ZxefLqSFfqn/AIKRJPwVBXq5B+ZhbezX+NSa9ZgUn1h
         YRvXBa5ASEt3UomgwiZEG/RnZuo8qo4CByt24NMIiSVQd9s5bi9b6GSnmfBc5lOTGES2
         wSkA==
X-Forwarded-Encrypted: i=1; AL+hErEiFOYO8JaZEY4uX1wEH3Vr2Rz+ePvTkG5SVK2lnteJNJPxunANEZ07aeRMCHSXZYKDI8pJvoCroBup2Yo=@vger.kernel.org
X-Gm-Message-State: APuU4Z8PU6LTlOmYy7JK5BereYj56y4S/e0aRPPpQPfCShlYF6SS87XK
	Po/HXp449RFIZRfVKyJSm1CbX6o+B53eerb1hp+snzvnl0kFCVReDHbPgqhnrksXZLcR
X-Gm-Gg: AYBFou3qXeR7DBQFEl8gfiD1fwj+Ux2wg9e4FoluaNisz9HZdAPLM1VetLn1/ngEQN6
	keWf4V4RhLnxmUlGKKRXB8HIV124wA4JwMh0UXvwR2YoiDFsGc64O8f3K7IZBOmynpUbWvUCTur
	N4+Pug+eMZvWzydDA56lU6KyhwwJ8NjOfaMh6KLp//XkiO3/kn0ylMaNB5I5RiT4BeYNH9ncpfG
	dPOxlEjUrapitoG/On5uEsVcfj+J+PC6mSAFwnigpe3KN+tnFAmmFEodKc/Ov5334wof4imsFnW
	B2uNcCEgIM0caVHb3Ws/amSGGobewN0Y4h7XdbwchpX37PIdoUq/Qh62rwW4HJTRPXFfSUHYNJm
	hzvGmqOP3BUyXPsgzFiF/uo/XwLd4Ybo56q0Sp+OPPvwHr/iEO7rcZFpYAE8RTkN1Hs+VE4jJH3
	s3UtWstE8XDEEddrQ3rGEqeEdk58niSRB5fQwK0PBXjUrKdB/B76SKRysmJbfHFs/ileAUQMPec
	GT40Ozz/JSWN6J7Z4XntAmabJWgxN3QqWo6HX4yUDOgxomtJ2SarhwWTy1K+B009w07Q9Hf4Pwm
	mazUow074GcdC5k7ZNX/ZZdqvFLHJPJvesOcZxYwfIuu9DMMXGHbAsrcjVQdVDgWDWdRqm8DkAy
	0E4eRKj3xiOg8EB03g1BVvHaDA6CXbVoZguocIP2/qvnyy4sOUWYYCYjZ
X-Received: by 2002:a05:600c:1f90:b0:4a7:76fa:87e9 with SMTP id 5b1f17b1804b1-4bb55ab281bmr266345525e9.21.1794904592167;
        Tue, 17 Nov 2026 00:36:32 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:de4c:6789:33ce:97c2? (p200300cf572c2800de4c678933ce97c2.dip0.t-ipconnect.de. [2003:cf:572c:2800:de4c:6789:33ce:97c2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb78430752sm52548565e9.12.2026.11.17.00.36.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:36:31 -0800 (PST)
Message-ID: <411502f9a4f940c223b2b88d7e19fafdce63172e.camel@amutable.com>
Subject: Re: [PATCH RFC v3 29/44] s390/hypfs: use fc_init_pseudo()
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
Date: Tue, 17 Nov 2026 09:36:30 +0100
In-Reply-To: <20261116-work-loop-pseudo-v3-29-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
	 <20261116-work-loop-pseudo-v3-29-8cbbea1cf34f@kernel.org>
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

On Mon, 2026-11-16 at 12:05 +0100, Christian Brauner wrote:
> Initialize hypfs as a pseudo filesystem. This raises SB_I_PSEUDO and
> also SB_I_NOEXEC and SB_I_NODEV. hypfs never holds executables or
> device nodes.
>=20

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0arch/s390/hypfs/inode.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
> index 559b011e68800..8662169de477a 100644
> --- a/arch/s390/hypfs/inode.c
> +++ b/arch/s390/hypfs/inode.c
> @@ -12,6 +12,7 @@
> =C2=A0#include <linux/errno.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/fs_parser.h>
> =C2=A0#include <linux/namei.h>
> =C2=A0#include <linux/vfs.h>
> @@ -301,6 +302,7 @@ static int hypfs_init_fs_context(struct
> fs_context *fc)
> =C2=A0	sbi->gid =3D current_gid();
> =C2=A0
> =C2=A0	fc->s_fs_info =3D sbi;
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &hypfs_context_ops;
> =C2=A0	return 0;
> =C2=A0}
