Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564824;
	b=Q/wQWnWxJ2wkmz7knUaXc3VmEsHvrEG30Mh/rTwjNC1mzUfuiGwo1L43l7VrrXPjUUcD
	 5B+25RqoTQpDD4f8oWrGvuF5vZQ5+hFB/7EUZQNqmtwXjWrr7JzCQm+Y7jYeuxup7oUsR
	 oJM9WEI7KJGTTGshsdsk114vRk8xOf1zQbDpOrKGzNvAOeAlXcxz2+YBSjrFuQI/eD8Jp
	 EZiTUJxN3BoXWXh3I+kb35nWMPBHBBEfBM0tfp7Cs+MsTIatHhpaXZfqBwLxw4Gd+SOGj
	 kml7zXqisG5G/lx3TDrRrnAY/WIu61Ve6AbcYL5sY49jtSVPn1P95MylSMtYvIQ5ZZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564824;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=ycFr7tcHP3BtNSevVHScuCcUOF/OuOrXOdu+rsUd7U8=;
	b=gjD4GB6g1Myn5klyCEd0HGp2pHjiP6PjO0Ogd/luYkqGdl9R2xIDKJq3Gl8jUVcpObN+
	 BEsR7MsmbSgK3opjrCeRAhfa2aRww/E999nIGAz7fsMSjDGYSnl5snqUxj0/O4tP7Lk0A
	 tm44uzYym1eDSDhvbpkTiUiEoEBXhYAIO3RPgecmwgjrngc1pNIaEagHCf2HZ92G00k2R
	 /if0hUA5F3Q22EwHG10to6YN01lSDDyns8FbUPhGOz3vRaT7Z+YoFeyiW4/qesxQxYf2V
	 fPV04lE3XjgHzH+c5liFGSScL7k0yOou91lJkMZynDW599XtdwNbqAY1rtn3WlxYAWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=tBSDp3uS;
	arc=none smtp.remote-ip=209.85.208.53
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1BDA60A260E
	for <target-devel@vger.kernel.org>; Fri, 13 Nov 2026 10:13:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F1BDA60A260E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=tBSDp3uS
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6b7221c0f2cso1490864a12.3
        for <target-devel@vger.kernel.org>; Fri, 13 Nov 2026 02:13:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564822; x=1795169622; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=ycFr7tcHP3BtNSevVHScuCcUOF/OuOrXOdu+rsUd7U8=;
        b=tBSDp3uSBFgypsbtBQgsadIQZQK7UWodMC4WHZVi1N1ipHHYu6WywVfCa4AZ6QIaRM
         wIcOajhLTVFUJp4yf9/N65gePrg5n4K0AYKI0yA+7KNwnMoUY/irx0jTqY91Kx7jR9xZ
         Pm03fPe9TdsIWGPKhcU7A4Ssshd7c8Dhe1zzS2a/pwsZLiwc6FmAy6ptf2LWGhArJX18
         uzRhPjO9k+hyhG0ceM77HGUPCflD5+7VnbyODCgVUFUm1PdMwYT1gZdGgKWe2z5NHlJg
         Ao5qYJPp+rBAoBURzi6iHuHACVVyoOXqBDLcaaEy2+qVTTu+93IkZN11FbEDMtWMDX2T
         mB4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564822; x=1795169622;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ycFr7tcHP3BtNSevVHScuCcUOF/OuOrXOdu+rsUd7U8=;
        b=mvJqfj4pwq1GH/1OHpVwwbAvlnh6f92Un+tIZ199BcF32JgPSgMldHbHQRLKSNPDFC
         lK1ir10UtnNA5dlOhXudsmaclU1xm+Nb90cw81VOfOBq2uWiO3IZA4lQtPQRziaI1NK/
         33CqBEI6KrXL/7CAJi01Dcv69wMhg4EUcSCHQb7Se4+HSfe1MP4z38vXK2kDfkKG8cTO
         1bZ/pu6i+/j4Qkq6FQXcjlpFfQCuEHZNLPyQVlbt5BsyziuKb20oNDNN47BBAg+jGVJo
         //KcwAURvS4uODkkXINpKPEQxGL9ZGolPuCsYPkidh+NIugLk1SjQUyMOfRMi79JFOr8
         L5Kw==
X-Forwarded-Encrypted: i=1; AL+hErFT50Gn/TPYVZemxsoAH+/XGlo+ujlzk3ZNAbvAwGUC85hsJL9uBZDLxaUZee+7QnLpeBKA7xokKyb1JBk=@vger.kernel.org
X-Gm-Message-State: APuU4Z8oBzTXh5clXgM5blXENlR3S3QNylgiWgPi6b54loSsVraThD72
	TUgJJcbhfkK1twABf+M0ompyQ61be9LqBvZg8IMCkQ62afDq/5//RDfySsmwsCx5YNe9
X-Gm-Gg: AYBFou2QiGOUTUYh4gzMXKkpfx1wGxsccASo97w4AroifWrfXDTj7rj33HAz4uOjcdH
	6K7fB7Mv+pSp0Jt0eCjzqBzOXV+IzxrRL8eFAD1EB7zVllgVZRmrfpQZQrUXq1euLZ9RSJYoukp
	1VI0MOLyn16R3PqCE6/+YVaRBgvML9e0pKMIPgclxgtC/KbqHWgnSlTVCCvvDasYJfo7iJiM6Do
	y7gKK8ZZ+Y03ABt4powHVQvRyDNTLRX9V3vf/XXhk/NW+rTf3aocqwvgRchweV5uoK88j8eR8WG
	8ONvgJDqY6v3W75voBWdSZQhUUCCIC0F+zj4QQXiYiMvRRPLRVoCHqwA/m7c68ZPjMHAWrzq7ik
	Xi3hel1YA457X04j8kOWF08xbw9YAAsXxMrN1VDazytvy+fNKW8w3GSv3KHOaJl3St8MTGfUbey
	CM2EJsl8x6LR2gTj1Z2G4tDxn40JmcH4ihKyRhnrqfpqIw9lKhvUpPgM+wjV3AGTcgH6l+0cubX
	riblg+4+cTlyy0zrYr8oAHILs170gQbGxpdTpo+RpvVahDVM5JVBZSSRTA2E55luRsPU57aeVvb
	w3LRBeOb/pCGC46pw1DzcSkVZHHJ8dWPndBMVr8r6gLL9qNAj+aAEy8x78qH5G4bjlQHai6EXaW
	XK60LHOjV
X-Received: by 2002:a05:6402:208c:20b0:6b5:69f4:e7ce with SMTP id 4fb4d7f45d1cf-6b7c0c62bacmr1415990a12.39.1794564822367;
        Fri, 13 Nov 2026 02:13:42 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c603f4d29sm4332158f8f.35.2026.11.13.02.13.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:13:42 -0800 (PST)
Message-ID: <3546dd28b1d63c1478d391a2015fff4c1b976639.camel@amutable.com>
Subject: Re: [PATCH RFC 24/41] efivarfs: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:13:40 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-24-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-24-4c998976c6c7@kernel.org>
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
> Initialize efivarfs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. efivarfs never holds executables or
> device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/efivarfs/super.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
> index 12746ced6dc6..e598d42c5f42 100644
> --- a/fs/efivarfs/super.c
> +++ b/fs/efivarfs/super.c
> @@ -8,6 +8,7 @@
> =C2=A0#include <linux/efi.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/fs_parser.h>
> =C2=A0#include <linux/module.h>
> =C2=A0#include <linux/pagemap.h>
> @@ -554,6 +555,7 @@ static int efivarfs_init_fs_context(struct
> fs_context *fc)
> =C2=A0	}
> =C2=A0
> =C2=A0	fc->s_fs_info =3D sfi;
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &efivarfs_context_ops;
> =C2=A0
> =C2=A0	return 0;
