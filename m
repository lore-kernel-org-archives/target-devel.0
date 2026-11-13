Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794565073;
	b=KfcQ2kOJ2uAizNKd4y1p2WCnr89mEkkYRO2b/02uiHQvgbQK55xAyuFeSTM3BnpTkXfP
	 rFkV7PAL79GkJIch2B7FeDIur8NlLL/FXZXibeQQKnnbhEiDV+CakO2uk7gjpuGMo001w
	 t6Q7OCKFm18/Jd/4CkHzVlP4lMXzTECXFnxEu0Sz6tgHG0p1xLGF0qOecOFvLs2Q0OrSy
	 2eNEig9BkkneDQEUpMaredsWyYrZW83XrvUu8H+fID4sxPxvA6UtxOCIag4LlWwU8hO6X
	 RTwgYGlycbRRa7zZKECPWz1hEoseRBGO0jE9ip9Hd3Tct/V3LFp3auKrew5XFA6Iv6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794565073;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=zqPqkCGOaO5RL/5NE1UeXRxAO7AqEHmUDDsiHSGxDsA=;
	b=VkJw00RVdSuywJpe+fHTUeyKNe77MDaLNODFU+caOE8JWb0HvAyiSW8mhD8xKumN3tsx
	 my4PtYKyak2DqalhVUQgKi/YAeSlTwDEuyAg4or9kg5DT2iZi6iuAm8CWqrgn7IZsenGV
	 rcU208Mc0u4rBDFv3+wrPzn1mbzmYRKEmOpquMGVyxYjJ/Yd9OONJBV2KH8O78sDWG2Oa
	 YVZdvBorqhmQHLmZbNmdQhEt0xYqqLaQldBif/Y2Ow7UMRlKV2I5AR/4sUmge1mJxwN/l
	 EhQ7dBbzVFOFtdF1btygKFUsSSXcY5Si03lRAFpIL1ynBt84SPruHlriQGkquSMpkEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=hEEG7fG6;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ACBA606A885
	for <target-devel@vger.kernel.org>; Fri, 13 Nov 2026 10:17:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6ACBA606A885
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=hEEG7fG6
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a1b07c3c5fso10701225e9.1
        for <target-devel@vger.kernel.org>; Fri, 13 Nov 2026 02:17:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794565072; x=1795169872; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=zqPqkCGOaO5RL/5NE1UeXRxAO7AqEHmUDDsiHSGxDsA=;
        b=hEEG7fG6RzQkOoGSL66zkn+hWpy0b8TxpW+CxGFBwGxbhLfdgmFqwESmbjaY7MScGa
         1TTEC4ZDzMo/nTmQbATUq4OC5CVK8FiegRjrCOceUr+V68t+3IyOPEhrmauT/typpuMH
         7BtZ7bLX9twnpc3pST7EzNdPnkg3BFhqHXhYG5RTwPNXEKUOMAEYxir+CLBCGEbp4xnq
         ot2tG8XA7sYEn5cZCga4RcL6w3I4tCQX2A1rGgTmCQohN7lvb4NCOhavzOt0i7fRXz7K
         0fiOYrUI/s1Mo3f+qCL5v2ciULr5WU1WUhy3OFmgCMCM2mU4bZM+JgAT1J65gELN03wt
         2Tdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794565072; x=1795169872;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zqPqkCGOaO5RL/5NE1UeXRxAO7AqEHmUDDsiHSGxDsA=;
        b=qszRGpijhOREdaBPk8gcR/8doulUIDXICtPU70w8gi1C40pcEjYlGiThBTzV6+NAQD
         CLq2FaGzu1Ip0nnegBKgnnF/x+pTGsQfSxAm9m4HAwPSsG5pY3z6HFs1egpDA15IEfFY
         0AkDdyaVZxmrsp7RjwCi8rV4WNkMowDDSbdcSZiCnCt1c6l6LBprU2Hk9GXmdcAT6ge/
         tDm6Je3e2xTzyynoetRXnaATaWSuxRD695Ic41ZbXwp6we4MQrnbiGCaIxMs5RZHN+wY
         Q38EHKB/gdgI0v9hoqAtI4ETgXac7rOjm0U7b4nLKRfvx2MAgOLPLKt1sHH2cH9PV1lM
         ppDA==
X-Forwarded-Encrypted: i=1; AL+hErEnMepR4sPuW8OPo3E8tffN7xPODZORQF2sJJx/vSCeEUMfdgASlty8TkCSS8jSnUFIRJBLIxjYDGIrCHA=@vger.kernel.org
X-Gm-Message-State: APuU4Z9SHCSVJt8JbdD2bZ3pItW/s5pfMSvBaqeKxTV9JjcYn50Q1kBQ
	Zb1EKz1FBvjdH/IVO6MkJ28m7IupL4qdg/fKAMqPBLkETZSTQulNY5HzH0OyAESVERVO
X-Gm-Gg: AYBFou1Qo5N+XHxNMp2ROtB6qOVfec4ZmYmyCjzdcF+gswysSp69lDlaLKJTHccUs/7
	kB6BvcDq3lCo15K7FuVy+oSmX9lPx+GsL/VOxQznIX/IkmBbh34Z4gB3dfIF1qYcgt9d2qXU+qA
	WvObjSxT6vjr2QQXV+RrI5xH4V0Efx67+/jQAleeV50lXObxQhHyhuBY4motjHogz2joOg97d6q
	XKRVxirYGtyX+UL3bMK4O2Fn3quzzd8bwSdDU29qATrLnHkg9RoT/qqjL8uIm1fAt/11kyS54jn
	06m9tuz9ReM+4FowEOv428eNOz7J8VcW5srtIDtEdTDSxznmO0FksFZun4oRkHgKAfhx2A0RmpA
	ULs1xQScMdNGN35MqiPJ7pSkv8iMJIpPg4bxXuYIHfQm6wTMu8yr9LTpddCcu0HO4UiFk0zTDxh
	yOEYA+NbrAb3qcXArMHBcCMiF8X1M0dfDrtiPZSU7PESg5LDDGeACn3lrP2WhnbAhoKLSNPXGa7
	okJfbhVIiJu0OjfJ4asNjhGBhmM+8SPyYt9koFDYJ6x2j74c6VTzeoCs/nyobm4nQtQZBJXEnXy
	MUwQqFnKgSBaCfmz3cv53fpe61/PrS6DpTC5nnC+XDfikE4eCoMMh6PTANsUBl0=
X-Received: by 2002:a05:600c:45d4:b0:4a0:23f:8b0d with SMTP id 5b1f17b1804b1-4bb559f6f31mr43851425e9.2.1794565071804;
        Fri, 13 Nov 2026 02:17:51 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c7da37b19sm3937770f8f.5.2026.11.13.02.17.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:17:51 -0800 (PST)
Message-ID: <7cde6f3091f9d90593e4a6441723b6b889cc4024.camel@amutable.com>
Subject: Re: [PATCH RFC 35/41] zloop: refuse zone files on pseudo filesystems
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
Date: Fri, 13 Nov 2026 11:17:48 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-35-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-35-4c998976c6c7@kernel.org>
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
> zloop opens its zone files by name below the base directory but a
> bind
> mount can put any file there, including a procfs or sysfs file.
> Refuse
> files on pseudo filesystems as zone files just like loop does.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0drivers/block/zloop.c | 5 +++++
> =C2=A01 file changed, 5 insertions(+)
>=20
> diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
> index 65634a39b0bf..dcc06dd47b04 100644
> --- a/drivers/block/zloop.c
> +++ b/drivers/block/zloop.c
> @@ -1137,6 +1137,11 @@ static int zloop_init_zone(struct zloop_device
> *zlo, struct zloop_options *opts,
> =C2=A0		goto out_fput;
> =C2=A0	}
> =C2=A0
> +	if (file_is_pseudo(zone->file)) {
> +		ret =3D -EINVAL;
> +		goto out_fput;
> +	}
> +
> =C2=A0	if (zlo->block_size) {
> =C2=A0		ret =3D zloop_get_block_size(zlo, zone);
> =C2=A0		if (ret)
