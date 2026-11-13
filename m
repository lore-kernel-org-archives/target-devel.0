Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564378;
	b=sO6mknLX5igpZnl7CLDQSAHIcPUrWRfR2RLH92cGkCR1hcGvgJeVuZpNqi+0NW7SVtzs
	 FGbq4WoyuK6KGWIsL2Gi/cdifLIcDaTpJppeSsA1jhv0wla4ntxH2r3lS0ceez2DeQJOk
	 FkSVZsOEwm73BfVy/afxCIeTXgtn4SgHX3zuDo2Bua1JkDVTWFf7+/55jisn9tvDY2Fj4
	 IciPq1xDB0gZEPNu1reJvgj260Md+thYtH/BsKpwVy+4VC9eoR7ylxutIRfY+MOGaRbM9
	 VBqBIlXM2FOvgrM59ukUfeSAidzF/NidXqj4vsOkexuifFA/7ZGS10Cyv0Ks0tnIkmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564378;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=oBVCWZMOabVq55k67Q8GIm9NBAOJHOxllLRlvncSbis=;
	b=dBoEbtbmb2lcZiFAIimcyHarUL0Ru9UYxNxp4ebT4PyG4ZGFjDoSTZs0jAl+QMWpXsk8
	 jqIEqes569mP3nQH5SrvR6PxPSpAu0VwhqJLM1lrdcDdIjY+a4AlvKkVWBGQ5v6Q5uLFV
	 oxNJMFUwfKqso5DDbxoJKfHwrDQ9e8QxY+1dpY47KlhBYSCbLwQRAsCzvtl0bnwhb5oRu
	 /w4ctUifQjKFJy8E9oe+LNBzm6aCCBjumWSgkrFtToBuAACFh2Tp66NoH3KdzY6ZrtfcB
	 KzBiutJ5URWWxkY/JVW5sroWtEj+YEtj37dGC4OzZ960Pl+CeX2X89PIDSdc9G+m7yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=WDdVkHgl;
	arc=none smtp.remote-ip=209.85.208.43
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13A0606A897
	for <target-devel@vger.kernel.org>; Fri, 13 Nov 2026 10:06:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B13A0606A897
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=WDdVkHgl
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6b4bd3d98bfso1517182a12.1
        for <target-devel@vger.kernel.org>; Fri, 13 Nov 2026 02:06:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564376; x=1795169176; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=oBVCWZMOabVq55k67Q8GIm9NBAOJHOxllLRlvncSbis=;
        b=WDdVkHgloKbBDmiudlEZ3ZWe+zg0BVZ0Jxwgdy+X6nc8ZJ9FIVi7F/SYJVqBRxNf3G
         3Gnq29xgDZdSKYiYaDVmU8W0xCuGm4Eu82rb/A8U6D5iLEOgHTmlDog4vSfdCU82B9rm
         qMGycG7Kl4j8h61zt+kqUkohzwqy0DPARMdjq2hKw51hdb6jylA1cwqwSD8nreSBsEB9
         DkDXk5ueYK99P4pH+jY8EwMoZnNW6BehoecLG+1JSq6wWJXsZMYgAdKGybKKFJkxuO0p
         O8Ri4u2My3QdIqEe8fwKAquZP0382+IuLTCd4KpBNa7znuGAHwPb5rxafjOggGTtG7Td
         r9hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564376; x=1795169176;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oBVCWZMOabVq55k67Q8GIm9NBAOJHOxllLRlvncSbis=;
        b=ta/B57uapzcmiqf+EUUgnU8ifLNrOQUJgUexKRW6rQm31UNqsjdE1gk9GFuQJkn16K
         6FvnunV0cytf+box++tDxDDcIpovxDdOTohrnEBidY1352Jmq5d+0LEKGvVtOUrrJeGg
         YhPxsDsyT8uvw9tV7tSgd/VUMXlf+xp6oxA8hg8LfDLfTbL03O7b0qLY3akPV4g/I+QF
         Ry6w+Sj7P72JgHIIndBVGgme6sqS/nH4orDiBDPHM0WLtq/ECxRymCK8y403wtGtB9Po
         0H93VTI7z20LIV+b7qbGJSZHvTL3ti8BEoFJFiVukDOt5Wp7C+00taAwXxNJSVf0IcNj
         /rWg==
X-Forwarded-Encrypted: i=1; AL+hErFbyZT/YaNmLuTO+7LtmiSdARHFYO2gFh5leIpaG14wdbI+f5K+cMus9jj+ZfZfZOxqCEsK/WCzuKlN7vw=@vger.kernel.org
X-Gm-Message-State: APuU4Z+wN/jR+bw6KiFyhDgku+N1qiu0uv+Eqjqh/vAKtd1WleFejT+9
	hFe35Xn84VHq83pwBINBVu7tg2fdmWqu3ZuqZOqa7pHr8hOVFLjuuRQx1qjD4yyK3L2w
X-Gm-Gg: AYBFou1kQdfG7L7XBDqpRMKlikR4ihDoLE9tGWXeZvztkyQEeA1paRAYHurGof6fGnd
	FYMZLhrEP81oN+Afj3TVFSvtQ633N8YFODIo81HDM1djwfAoEpSpLuIY91AbQYTiMbSpskvi5dm
	Ygv5r5m7I8x5JmTTjetH8T3WlQyuP9UcjoBWZM8Cxk/w1UMZIjl9qcWPADphvgYWH99/Pzj+RxR
	zztHjszux/U5WQ96YD7Qb/AEmFZZq5efAVoiMBAGTunhv6zNHc+U3tYedOd8R3gwq43Gh9bGrRA
	YyEudFSSYGdj4XY0aG0sqTGK+LYAAs3oAsFQwDb7m8krP7NaaeZ+lVUmBN5Qz+yhptmLM+n0tnZ
	bITLo6wXXoYbHCOLc/1EJ6Hq2GytiMgsi8SYB9TKOpb19eip421YQVJmmhhVrQ1UDLO9Ch+1c14
	6NwDw0w/TjgHpcGhtD2ZuBcSnen2qiAhRiAhfHZe23tw8EEJ/R/B3Y+FQEM6syxPfgoSj4yuNIR
	hivjXHovIsH2oVD7R8qF56X6Prl48KpMuTSJkSDT+C5sBXKUwTqmlKuLKGUV78omi4hgX/5TVfv
	fsPybpvnMqSnkGYOEQC/XSffbecgElaqwoltSu0YyUGadKXJQ5Bk76YdEWGO8+I=
X-Received: by 2002:a05:6402:280d:b0:6b6:4dcd:967e with SMTP id 4fb4d7f45d1cf-6b7c0bbc394mr1685420a12.20.1794564376161;
        Fri, 13 Nov 2026 02:06:16 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b7c21b1b5asm706711a12.4.2026.11.13.02.06.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:06:15 -0800 (PST)
Message-ID: <4dfa19dd41ec1a202182284d9617926a259288a7.camel@amutable.com>
Subject: Re: [PATCH RFC 16/41] configfs: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:06:14 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-16-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-16-4c998976c6c7@kernel.org>
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
> Initialize configfs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. configfs never holds executables or
> device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/configfs/mount.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/configfs/mount.c b/fs/configfs/mount.c
> index d8cac1cbf3bd..60ba24e7ae2b 100644
> --- a/fs/configfs/mount.c
> +++ b/fs/configfs/mount.c
> @@ -13,6 +13,7 @@
> =C2=A0#include <linux/module.h>
> =C2=A0#include <linux/mount.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/pagemap.h>
> =C2=A0#include <linux/init.h>
> =C2=A0#include <linux/slab.h>
> @@ -106,6 +107,7 @@ static const struct fs_context_operations
> configfs_context_ops =3D {
> =C2=A0
> =C2=A0static int configfs_init_fs_context(struct fs_context *fc)
> =C2=A0{
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &configfs_context_ops;
> =C2=A0	return 0;
> =C2=A0}
