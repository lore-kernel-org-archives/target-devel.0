Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564808;
	b=T+vJfNHBN9DO4LiqTNUrkFjIaYEwU/v00K0QNCt3cBNglCt/uAmRIiAX4qVmI+gzctr9
	 xtGoanz5DFA0a+TwzlxFNylLyrFpbc0md+FgtLKz64UnW6DAoYYz75g+IRZiCoXfVWcUv
	 Q056B2XO8rKcBE5Ubgiv3nDAQJ978eqRBnm2WX3X5rUFE6ZGRHcUoi9dexlsLJNFhbNxG
	 HbgNFHIiNZ7umaX9IqXYTays/bYAoPeSHHx7Byd4fV7/NfUcfb0T5CmX9VjMt4nKOsHTN
	 /3yAeeZbiktd/7hjS/O19fB4Mc2Hq8TC+VyBgi5sKPkVxvrPVdyTbrH0cHa8bnw9+0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564808;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=UX3uQO58FXw3i2m3kzI3o8uINYIcsljrdUAfEKBly4o=;
	b=Hui/ITPrsQOksm0GL07Pw2AqYK/vOLThiW9fj0KXWym7VVT6XJN7F+Ma5Qd33MtTctIW
	 sZHtJClhyRJFFSZ1oIfFEMH3Rr6CCKo3No9yq04jStSjlk4ylTSS/YcYxcYTJJOizd2du
	 dgScLNfpp8ADgm97anrW5WWnxNbXlnYVid+DOH64uzBSh3j2U/BImvDST4bIgdQJfUhKC
	 TaHazIg0uBfwVHYzqJ5oVW3msAMu2IGaJkEBxhaeHU9Oi1g7hbFHtFNBujUKmwXW2beOm
	 5MUSaigw2fNz6Amfw23TO+e1nhVJZhZQcOCoOS/vt6RtUvl/Yo7bjHfiaGbHMZPCDrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=rqBNEWhe;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A3C606B115
	for <target-devel@vger.kernel.org>; Fri, 13 Nov 2026 10:13:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F3A3C606B115
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=rqBNEWhe
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a140e7405dso10214345e9.3
        for <target-devel@vger.kernel.org>; Fri, 13 Nov 2026 02:13:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564806; x=1795169606; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=UX3uQO58FXw3i2m3kzI3o8uINYIcsljrdUAfEKBly4o=;
        b=rqBNEWhefqtER2dpEJNVPTElbe19fVdkNyIzbVbNULqUnWk9JP4TtodfrAxZg35Ufq
         +ciPTMXXDC3Fn73QdDq1nxL10hoZ0LEMTSuk+HTluWLCH3mNQBpp5ecm/W/Lr1PQghIv
         NQThaRjLVubmwKFzY9W4H2pkvpw752j1vTd8XwcKuq70wsUgwzLrChjclsxLFe4j6CXh
         P2+zI4RYwkyiSmtYnxi7mmM5Yw0kfqLENKBervoD5JNkytp6QIULxp+qmuf3k5WOFN+d
         HC6ACfaHkSpUVoBZwd9XYoAangfmrtxV8FymQjjH9iY0qoozDauX1oxEdXhYxV5zTWYW
         c/fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564806; x=1795169606;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UX3uQO58FXw3i2m3kzI3o8uINYIcsljrdUAfEKBly4o=;
        b=JvE9mpvRBa4DK/wrr8Xo0Db2oE3/GLKVy5WE2rXJxvC4GekVBgHYNk+NUJKadWVRRu
         LHqbEGjLV3cRFtMZVYjibMss6Ew/Trk9FOW1yhBoblqlmlJC7JmOoMRlriKG5qKnyafM
         9SPZTHgQDviyjrpaNAAfHI6qwBhRwwa5ipg5NNSm+J0UmpUvbalyT79Rd2bagm/Ge11f
         v27zhXQ1GcU9kYExRxfcYl0i01vJHA6oYutF/sFCnXW5T6eS98jB3fqsV9/p3sx0E2HG
         kXKwLNVbo4CQDwORd8L0myQWQrkORG0fTQ3f0784LEOowqdYAT7kPVBUV62Xz8bASXVu
         NXkQ==
X-Forwarded-Encrypted: i=1; AL+hErGVBQw3ibLsL5ItKjUtP4E336cTX3Tf5g9ZCCMcs+601plipr11/oSROfuTwVGqY5yq+2nbsOPMtC7ELdU=@vger.kernel.org
X-Gm-Message-State: APuU4Z+9uERU+BXbGMO0o0MI0YqEK6oO9DgNvAR7mhIuuQ5Cpp7eUkjX
	vol9RGgcoeAXIS19CfibdbhumHghP1uvM+AnmFNU/K2lqH8l72Z4wVp0oMPu94m/vpzi
X-Gm-Gg: AYBFou1vEqCvNqYNi8GQn6pNYr7D/2uVeyNjm1ZglJXYyDuf7yJ+klyIHr5Hd8bqP0V
	1WEUl91mfxyVQ6g4DcfHyGu8sVUOanZgfsHghSgS4a4/UIj/Pe5WZjy9K+7DNZljPam4Z6uZeQj
	yIZ8JSxhTJgFVewinOI0/VJxmx3kj4AcidDbJQXC0tH5+kcIRISDALu6L0ZfbbX7fwaP/X+OGLF
	XIvCqArBXER7XY4v3RQvW4TKdtgBH7MrKLau2QQ84jW66FUk5qRAKQaak6ROe13GL9R23sU3T8K
	hLa+VrN8JCZsTwlVGZtLzkysx56PlsdJRrqSOxogH+brA1SbjqwM34HXzxgiR3z0snIarYQvKnr
	MUiZKtAr2ZL7r6rSGSJn130U/6ax7uvkBF7/lHthRZxlWRbHHO5Fh7PjFkHQsWsxXgZn4pNcaWv
	pRC7JdbKeLyPXSG8sbOSUy00ZWfbSQ8IxL5m8WdS3RdISg7jfHQdJONuDux6cGnIV8EkN1YWK9D
	TfCqSKgt65g6T6Yu/fq8k8qHC68E/EoYzlag4KyWc7jU+QXGid5HIO064w3L/A6dlGksNDaCdg0
	kYOtHupOzIrT3ttKZSNC7cmR0XExj/zl11CPTA33/e1T5RGntbZLNOnZj/sZL94=
X-Received: by 2002:a05:600c:45d4:b0:4a0:23f:8b0d with SMTP id 5b1f17b1804b1-4bb559f6f31mr43583035e9.2.1794564806374;
        Fri, 13 Nov 2026 02:13:26 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c609c8a77sm4362275f8f.49.2026.11.13.02.13.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:13:26 -0800 (PST)
Message-ID: <23edc29c421f5d4c1103004f79e104e9f94d42c2.camel@amutable.com>
Subject: Re: [PATCH RFC 23/41] fuse: use fc_init_pseudo() for fusectl
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
Date: Fri, 13 Nov 2026 11:13:24 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-23-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-23-4c998976c6c7@kernel.org>
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
> Initialize fusectl as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. fusectl never holds executables or
> device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/fuse/control.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/fuse/control.c b/fs/fuse/control.c
> index 21ffde596d61..4497362e7df0 100644
> --- a/fs/fuse/control.c
> +++ b/fs/fuse/control.c
> @@ -10,6 +10,7 @@
> =C2=A0#include <linux/init.h>
> =C2=A0#include <linux/module.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/namei.h>
> =C2=A0
> =C2=A0#define FUSE_CTL_SUPER_MAGIC 0x65735543
> @@ -334,6 +335,7 @@ static const struct fs_context_operations
> fuse_ctl_context_ops =3D {
> =C2=A0
> =C2=A0static int fuse_ctl_init_fs_context(struct fs_context *fsc)
> =C2=A0{
> +	fc_init_pseudo(fsc);
> =C2=A0	fsc->ops =3D &fuse_ctl_context_ops;
> =C2=A0	return 0;
> =C2=A0}
