Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564190;
	b=V+ZHbKU4KT+zWhTvkOh89e20v1Qf+AfyCJ0dWJ0ebHNdnlngPVC1mdRU5vVK2Y3/y6R2
	 6YrtS0DWrv2dUtF9XMmPP/pd3N5Zm5yOhb6Uz2J0R6G/RssDL9aZBQBBhhuujTX7GaXZz
	 gUFRdaiRTgLy1mCGaBqcgWIq5DkTRw1H4p9l/MiD421fpj2XS3WuWLLtAoqItdDedkH+k
	 HwXoXkTOd7LKxv4kzl0g4bodBfLl77iqY31pyGwSQQJ/aqUM/U5kuxMOHsbM5eDZ4cqOt
	 En6EkRawidFrhvbcF3Mij1qDsUECIoPinSLMjUW5C4mL7yFYcE3h5C/vTVtgIGmyq0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564190;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=SoW/gPie2WRRtXdhiV6ow6HDYwH4jtR4w1oiMzBwW74=;
	b=WNiWcflUnKeuG2j1vYdOiPZzTCvoXtOnEFR8nUlvNrzuOOlbOa1bv17QEcWqm34ZegZ2
	 IOvcXrSf/dOS6QfB6laFddkzUux36uAqemitOuojgjVDsTrd3G4yKt5uPqoNsheYE7ex5
	 szjGG7Ss1Z2ewk8btFN5RtTdM3i4UaFzwqUVFkX2W7y70HHt6B0wFATZFSIgMF19xrwHA
	 hlO1Mh7k/ggHRih9BGMFAKV57b1N8Yc7oGyIVSLjjG9XnQSI28tW33PeuDNX4ih2Og88M
	 RrimdR//awUcWEEOxMq436Pbf9VTe8ykQgeHsvBMVOXDG4sdju2x40SQbM/GoTD64Bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=PwLaWWEZ;
	arc=none smtp.remote-ip=209.85.218.44
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D421606A8A8
	for <target-devel@vger.kernel.org>; Fri, 13 Nov 2026 10:03:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6D421606A8A8
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=PwLaWWEZ
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c4d581da0aaso117517066b.2
        for <target-devel@vger.kernel.org>; Fri, 13 Nov 2026 02:03:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564188; x=1795168988; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=SoW/gPie2WRRtXdhiV6ow6HDYwH4jtR4w1oiMzBwW74=;
        b=PwLaWWEZlovk3BcnO0ZG64105bcHT1OuSddm6BbnvIqxbrPzt9auj7esmk6BNbh6fX
         VcVz0Fb5EO25ZFbwJkkdsGMVKdakOQPzqU2f6LPhtUiDBhEZmXH+cAuxyn5j0/PSwsaT
         RO2aU2TU8aCmd84MLoXz7vnHjZWZq5qT0/Sc6gtTAg3UhyfQddRWFsH5ep7YUVPW4oOS
         ZJYdPFjeA/srAxsT7bXr7CLtpXwYO3HrhRePJ9C+1IlKmxOGPfhyvFsMUb4DHUYdYyHA
         n68GAxpj0xAii+OfqqKyb+8UpP8WFZF+WeKZ9rpWrZ/4EfgHnKqz0J1mnDjnDglQmq1u
         ISGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564188; x=1795168988;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SoW/gPie2WRRtXdhiV6ow6HDYwH4jtR4w1oiMzBwW74=;
        b=Q0vYHoWwgH+SpwRZq39IVmNmSYBy5HASnR98zFryVocyFPR06HUiQqUL0qARxGa4ll
         NAA8BRNoHwa70KqCSFOx+684/KXffjlOJuU7Lqzg2fqt2U2l6PUJkH6fiWJibGfEoiG6
         Du7LYazZXtl/rhcphhrxq19vZ0esQc3oQUM9EeaUdTnE0I5TPxnurDeTmUqRVlTVLERR
         WDZWpL8iM/6SqeJUL30triOcjBqVO/A1PQsQzafZS7lxVM8qLAef8SRRrHxGjvvLEKdU
         DZQN0W8gSUtxo/dozfZkX7gIY7NIlhf+PV+Sq0MyTQBkbqG3mTqe5qF77/OxJ9OU4Kg+
         q0Vw==
X-Forwarded-Encrypted: i=1; AL+hErG0fpWv8Fc2oB2qh4BTHc0zF2LYB8G7h2dDRZRJ08A3CxWhCPdfbW99DpiW3bYvq3dcEa5/uhyBj4xRUR4=@vger.kernel.org
X-Gm-Message-State: APuU4Z9DhTo3ajS2ISd/aCeypinw4qxhWrZT9CgR1kDc+ymwyp+CXp20
	v9ofgZCEUh+iYF56gUFvikuE3f3nuqCPGu9BLW1Bd3+KGdNHhN8If6uufwrrMXn5j0rs
X-Gm-Gg: AYBFou3a5HieYGlnDSk0hROIJNOG61cyfdaakKhNj07PVKguN6Cv8BddiMpllvOlmAh
	VkW10hQyTp9RXHXk3ff+JxnIrew7ywOQ92ePFHmIcZ71HkGJPuNIHR68kecqT8sNinV/dkkUA9z
	pEZJ+/ifPa0+iFL1VgHlJKd1vy1b7kjHSEzKwDhaPkxkYLL6htfcBgE1dtzs41O4OU0mQk8H5I2
	Ixm+I+kYLDgoNSvYcD2wt0S5w9/IY56g2rKkEvGnS4YvkucGOARS8YQP34URjO5Ns3hUBROhKbR
	PE0lGQtowcbQ0uij6HL1zgTnsnVzmSY/MHaRjbAVIhD7rZaPQzH4Vz1jrp9YhiddB5MJbHE5Dyk
	mOPS3AI81mL7OZAT5rIny0/gJYoOBKSnJDJj8/d8vb8NPXE5USr4GOaofb81YKxgdLO2LsSlHxJ
	h3LBUKKzpchEPvLZrfkONxr38ZKFnJhBWP/JD4wuOL7lQTP0q0PCvmiIFOoY5gCGlS7qBirX78d
	CBAX/dWAl/yLYcynlQB1ilb5VQgqmL+PyjxdCUcheS1jhi4hqnrp+RH/hGnXFIg4gRj58t9Q2oV
	GveC1CIJz3VnsfWUn6DrMf44xDBqMj3+a3nZkNA5oYRPqAtD
X-Received: by 2002:a17:907:d12:b0:c4c:b4fe:c9e8 with SMTP id a640c23a62f3a-c50963dbee5mr161853166b.38.1794564187801;
        Fri, 13 Nov 2026 02:03:07 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b3dbaesm74933966b.32.2026.11.13.02.03.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:03:07 -0800 (PST)
Message-ID: <fffc4f7f87fd5f03d1ef409df76f71ddad552213.camel@amutable.com>
Subject: Re: [PATCH RFC 07/41] binfmt_misc: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:03:05 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-7-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-7-4c998976c6c7@kernel.org>
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
> Initialize binfmt_misc as a pseudo filesystem instead of raising
> SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/binfmt_misc.c | 5 +++--
> =C2=A01 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> index d945b4f6e158..7dc233becd98 100644
> --- a/fs/binfmt_misc.c
> +++ b/fs/binfmt_misc.c
> @@ -22,6 +22,7 @@
> =C2=A0#include <linux/file.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/init.h>
> =C2=A0#include <linux/kstrtox.h>
> =C2=A0#include <linux/limits.h>
> @@ -1575,8 +1576,7 @@ static int bm_fill_super(struct super_block
> *sb, struct fs_context *fc)
> =C2=A0	if (user_ns !=3D current_user_ns())
> =C2=A0		return -EINVAL;
> =C2=A0
> -	/* Never exec off this instance and never let anything stack
> on it. */
> -	sb->s_iflags |=3D SB_I_NOEXEC | SB_I_NODEV;
> +	/* Never let anything stack on this instance. */
> =C2=A0	sb->s_stack_depth =3D FILESYSTEM_MAX_STACK_DEPTH;
> =C2=A0
> =C2=A0	/*
> @@ -1660,6 +1660,7 @@ static void bm_kill_sb(struct super_block *sb)
> =C2=A0
> =C2=A0static int bm_init_fs_context(struct fs_context *fc)
> =C2=A0{
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &bm_context_ops;
> =C2=A0	return 0;
> =C2=A0}
