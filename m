Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564338;
	b=Ia/AOlLOShvx0MpZv44pBTV19C1oWJdQol2Fu4p1BWiXjvV8j52iH+zeM4yzHTQ/qEjk
	 SLQHbs0oOXpHxLzc2L3Do5H0XpClg4xmZbEU7kGF4ytXengmLh81el3UMO7Js7tL2SsEG
	 WvNejj7GEPM8K3M2rZUITS3L5Jee99pphB7cg42TCanVlQnB0wLPIDEgW9RqtGE/fK1Wy
	 4QOscx+IQ8YqFG1FwiqRblk3gmgiFVnxawxzZOAuV1w2hNuLSfV8fMTRSO2C8A91RU0+b
	 3BwKP+Scn0UP0Vw9Y4j0sXpgaBDY2mDfPKVEfeLveXGQo/nF6oFB3no7PbQmp/DXhVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564338;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=/ZNAGjGCHSUHK/hbpNrctHFuArQcFUaSPHFuYTd8W2k=;
	b=skZq51IthqAicYSa/FvdyGr3KmpuDEEOB032iBuMxzQ5SS0rzkDPOXWsBb+24Zochw5v
	 kre5DqgmX/w/Txc+n+9AE+TleqobMVr0f/FLPAJXhgpf2dUn4rDITegiJIzIxh0WtyMra
	 KDExfS9DRZUjW90epXyWbxhP+ZJO2ZWJ5JTgOEVm7+zd0mz14D5cRHqMVayTLbZO+0L2x
	 zIbtIEQm9I705HqUsdS8flBg/6aMx7AiwDNRgyBG6txNiRTqgIuOEGMVr2hNdnbIifQQi
	 fl8ZXEP3vckqjeiBkL7gyGttctGu89Urh3xISBBBhf+Zo8sxn7Mt1boU4YLc5G/VMFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b="BcN8/JZ3";
	arc=none smtp.remote-ip=209.85.218.46
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2080606B13B
	for <target-devel@vger.kernel.org>; Fri, 13 Nov 2026 10:05:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F2080606B13B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=BcN8/JZ3
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c5075fa7ed0so161295066b.2
        for <target-devel@vger.kernel.org>; Fri, 13 Nov 2026 02:05:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564336; x=1795169136; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=/ZNAGjGCHSUHK/hbpNrctHFuArQcFUaSPHFuYTd8W2k=;
        b=BcN8/JZ3o8G8RngOszXG3JTNOcmRF7Y5HhcgHfEFuj8bd59D6/ZB+k5Qh/rpeFRCcR
         ddACGgLLZgU5b3f6uROOjMlLzNHxLpnDWTvmFTIG7dNNkaJHDW07G6TO1gom3Rvc3G6a
         phj31A4a6/nEoCYWD8i1KXLteYhy5qLcfDwMY03tf9yOOPsaa+sC0St/LDVgowIEHsk0
         tZO/CMI2RrlSiK2F32OSWBbCdipxonxIIN0DBtho56nDsRF+fFDKa92VHmnJVt2oHACg
         qH7hz+1dQBsoiVIgFoQGohYiLAIIKP/PCGAm0hHsixZQutOWB167lk9DbkeNw+vQ2Hrh
         L2Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564336; x=1795169136;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/ZNAGjGCHSUHK/hbpNrctHFuArQcFUaSPHFuYTd8W2k=;
        b=Qe8rv1DPsivJf9LxjuNYg0XL5mF9374Xt7+oxzWBhBym6MLy+Q1wA5N/Jp228B1z97
         KhY9Mo264oasv4qVChqWU4EQ7PP6ISD2uUl+1PNIS8Ng29uYXRclLrSPWSrOWIIAUnTF
         9CpeUZSmL3wZV0VxrvGDcmxTVDP19nVxjgHYEIUf4G/ggfldc0IjZ5fz+V5bSxjCtsVi
         mbZT8HQ9HJ5TJ26okE3XIUN8dfgcKaRmvCIPztenzNVNijBTFnhi2dFuq6cB2V5J/oH4
         1tgihoYx40KGgOaoOItq3Ga+wWMwPPd8xCGta1SdFKglv1caQB+O5A8nW1WhhM4pAXgG
         Y3IQ==
X-Forwarded-Encrypted: i=1; AL+hErFxk6ZiyCNkqQTI6oc+d07SQZcSx/9L1Y658D2Xa7GD0u/9juVyG5TeD2lrYrVBQglGUcXmaqs1a9JKSds=@vger.kernel.org
X-Gm-Message-State: APuU4Z80FNKi3fDELFSFV0f6Y8Sw1GU01zzltce3GqNxFtZ3eFVcpq2M
	sYVmyOPeE+YtKSMvN/9XAYONNkigVB1NwJ5cREGDBcWfv02bUwb+1svY2KQEhs8AZWwF
X-Gm-Gg: AYBFou2jNS+YZIhPJy/T64x/MMstWODqKA6xjeyB+7sVUV11hl9HIYmxqINwRqauZnd
	zZJrD4X4VUG13uV7U9i1jcDNX3Ncxamhys3EA6BL1Ei9sal52fFHtxUev+mbCdAumh4szeePSgE
	nRSFY3v6yiK0z1zWJyHbiqgguKEzbXl/YGXyuYcaIYoyFCRRvlGW3sDC1jHLzwbETvDbB+MUCJE
	KcNbtvskw61AeijRaqDbRqzoHEYUPCt38a8WMFDgkTinhZQHvH4Bi3U6cC4lS/O+WOPHcW4OPLN
	KLCp4TBoCyvridgGKEjXiQ3qu/lWOF8ekJhN0V4ck0CxTtH47LnuWqK4VILxDpjhk59dfmqf9Ym
	SHVDnD8xDDLeKg0E6ePfWmj/GHZyKsmJ6b8u4PCYdKUNBRpJr7tySG/AAYFhFf54ME/ABoF4Xkd
	dk/B3dcUdVI1nQ0PMhbXjuM6SJQWFofEujGZzRg/8zrIp0gfp0zhj5XDzmQ6G5RsxJtjp9sdLEm
	x6FBKF71NpNQdo0ieLphFxRl0eGsc6fe/zxOcKpdF3CIUHaXJkAr/ZUBoufwSbtj24bltH49sUd
	ntwGEq7uOBEwivAdLiyu+i0vNequ18d/KlP/xBNXMONYDw2/jQFShArI33ioqOo=
X-Received: by 2002:a17:907:94cb:b0:c2e:3a72:ffbd with SMTP id a640c23a62f3a-c5096389759mr162937766b.41.1794564336347;
        Fri, 13 Nov 2026 02:05:36 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095a5b93csm75365566b.5.2026.11.13.02.05.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:05:35 -0800 (PST)
Message-ID: <8f532a01f6cc2eb73582864343e25be4ec990919.camel@amutable.com>
Subject: Re: [PATCH RFC 14/41] debugfs: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:05:34 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-14-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-14-4c998976c6c7@kernel.org>
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
> Initialize debugfs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. debugfs never holds executables or
> device nodes.
>=20
> SB_I_NOEXEC also refuses PROT_EXEC mappings. The debugfs files that
> can be mapped, kcov, relay channels and powernv's memtrace, map data.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/debugfs/inode.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
> index b4915551ad31..f163f0bc5703 100644
> --- a/fs/debugfs/inode.c
> +++ b/fs/debugfs/inode.c
> @@ -15,6 +15,7 @@
> =C2=A0#include <linux/module.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/fs_parser.h>
> =C2=A0#include <linux/pagemap.h>
> =C2=A0#include <linux/init.h>
> @@ -317,6 +318,7 @@ static int debugfs_init_fs_context(struct
> fs_context *fc)
> =C2=A0	fsi->mode =3D DEBUGFS_DEFAULT_MODE;
> =C2=A0
> =C2=A0	fc->s_fs_info =3D fsi;
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &debugfs_context_ops;
> =C2=A0	return 0;
> =C2=A0}
