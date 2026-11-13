Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794573510;
	b=NKVdlvgMH2JsKUPsUV4xvPk0AuMFWYOB+9/N1doTDjq5Cqi6FMElzvKqyTlx5JB560mb
	 fYNlseQsgJhWrsmotXjrcGInms2gVA0771y4o9g8d3w5JDNhIVcNPFKljqu8eIs1tPHL5
	 Nx9U7kj14Kq0vYAVAXafQfV8ljB2Zi/WL0iy1GmWianTN+RYX8NNFFvZz3bJh14JKeoCf
	 z8Mu1SdYKW8uiXogdv2YD8UZ49kdmGY1Fyu1q3L4RI7umymKpMXmpBVBdPEBiaTLpjhem
	 sXhZXBeNtfyaZfjKou5hsGjg6lGi0pg5j7GXXy0/w1Yjd7Igm0SIHPrPUzpjPTc2svQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794573510;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=Ny+1veWg8VD0eIDxFJ1X48Kguf5Oe9PbJZTpbcgMiOk=;
	b=wL/GJBCuMQZ9kMndBwZq7Q4KWlp3WttHztjWDgG7u0Cgh5bgcjllM/t3W1Vb3nCSYeby
	 NurK3yj3mmHg9L7j4y0UldMFSHHhwDdtjHoYog9yGnhGpd/2sl/xNfmSijE95U7HC96UG
	 DcLnqFZaF6pyzKMDFOFHVEDEcZwPSPWX8idzEekwDxiJ/mPVj1FqIX6a/vrfzzCeLpn3u
	 DT3cq9zvZlxIqhTKxIbhuesC9VljAatUsYw/eM3K6W+Ip9WDv9ZHc7Mp8Kdpk6lZ2sgV9
	 lNUW2W+RpVtY/ctfpGgzfz/G09S/5pspWAA3pywM0opNJAIAsd1W7jR77jBWK3vAGKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Bz2+TnPI;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F9B606A331
	for <target-devel@vger.kernel.org>; Fri, 13 Nov 2026 12:38:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D4F9B606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Bz2+TnPI
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so9108175e9.1
        for <target-devel@vger.kernel.org>; Fri, 13 Nov 2026 04:38:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794573508; x=1795178308; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Ny+1veWg8VD0eIDxFJ1X48Kguf5Oe9PbJZTpbcgMiOk=;
        b=Bz2+TnPIApHKvsf08kyiSuJZ5AWViHONwTwuNXVAuo2u8JGXjKnEoxSd3hG/r/h3b1
         tdsUEBtaZSOWfU3+mD3LjyqvBKt9Vc6RBsvkZZTD05u5eCDGhnWto1Wbu/C0r64DVVdd
         h2TGnt6meedDH7Iwjf2Hw2JxWOY8jwAvEAcAC10FURsf5jjp4p/KJzFYjzuPwuYFNKea
         Iij0h8HoPs5opXKf2XwMBJpd5hsYSV0+BHP/DvKdCCgwNFtbeIFAwqDf2ag0NBOCbqs2
         OXWiZmXbdGCixyOlqQBMgrkFkrhg1VmbSdmvvBdeQ4Vz+QMvhYl+k9AO6FJ5UW1pg6b2
         DVuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794573508; x=1795178308;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ny+1veWg8VD0eIDxFJ1X48Kguf5Oe9PbJZTpbcgMiOk=;
        b=uMCuNc3mZTUJg/q62gPCyyPDJyO554Lxyz0qM6QCTCACazDXnTc9VKWBwXHukV9Sc4
         oJWOsHgwmTWUQwbH6EKcq3w54KMYI9MHLf/sbfO+48F7dOfTk97d8mWrpHxIlNnZekdK
         AZ6N7xMmwep1y6BU4VKLKy+Xin0toyRPIY69tR1A9/633n8m9KrzJw4bpFIYERT1Zr9L
         Czl6GnNU2ahw/FQ7/ytBvb61iQLaxK4f2/xrCeKl/1mjaIT2bM4j7Y+MH2SGtpckpiFB
         esjY14eEBrYATx8RZMVLJf7drLcSpN2dpU2CSfVItEbFUvYSNFPdkehRAdyp5q4x5Ina
         GGmA==
X-Forwarded-Encrypted: i=1; AL+hErGZHeJh2iG1FWSCvksoQJjKo1v0KEuQ2CGjiHDkuwwtozNqJUoSM8zZm+HYA8X+7WXhRuB/xPAFVsnXtBg=@vger.kernel.org
X-Gm-Message-State: APuU4Z8ac5JX2vjybuKD3ca7lvvuWc9xsfriPpmvO4mWgbSdz1x+BbCp
	q/BJ6YD0dH55MEMdVut95ssGSVVmmNb/fOtRmce9RV+klhNHhXshHK4WsACY3b4cYqGDz08kPvW
	DANXTQ9BZNPY=
X-Gm-Gg: AYBFou25omKca4rw42lznZvtSEcHAqDgzC9h+BxTdansqd8uWcuCucawHCBvQDakAT+
	CdvYexgUQCcAKwxAW2+3vMPfF0eslBinV95qIIsVnxUjX7ruwGUXA3jc5jfMOr4wNAprAiMV3jY
	7zvogliPftzQO/EAidaJ/yzYmiZPOdRB/zDPgckpPYYs1LDx2OtDUSUJuo8DBnnmg50HlvYuJVN
	A5wokBDvQjBgjGiCPrbiN0UAnbQR+XlHxMhbYLTC2WWjapjjiQ4t+16Sv3QMyPUemr7E9JlirMA
	BUB6ejw1Z2Jp3b0wlL/BtD9FaI4wI1zbmvlNoQoM705QXHoAO0ZrnKe6p4gFBy6ymIhRGbRp6G2
	dhkaIlkqzPvy+jdYmJRMjv+UAHW7xjU3k7eGjFYoVc6ylFE0S/oJ7a6DkHibQuVHSmhNBojMT/h
	7VgTpYjsKWTl26ndCZ+Fj/wL3E7ViraQOmWfilxTPEoSC11FfJ0dxzUqPzT7PNcaMMrRSdZtek3
	p9BA9YkkXvqKtjrOcBfgmg7ubJZhwJgL3X4tn2CQVv7JJsM6741T8J6nmKxdEQ0p2qhGhbQ4/2S
	PcDJp8Yu0RO5VrDiJM9UgOUS/o0zIAZTY8svsJwVxY9QTklzpG2MR1toap15YFM=
X-Received: by 2002:a05:600c:a596:b0:4b5:d95c:2380 with SMTP id 5b1f17b1804b1-4bb55a86fb2mr24790785e9.11.1794573508217;
        Fri, 13 Nov 2026 04:38:28 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb571cfa2esm48348475e9.2.2026.11.13.04.38.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 04:38:27 -0800 (PST)
Message-ID: <28a33fa649dcaae2eadcc934ec49fa591ec1c283.camel@amutable.com>
Subject: Re: [PATCH RFC 20/41] apparmor: use fc_init_pseudo() for apparmorfs
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
Date: Fri, 13 Nov 2026 13:38:25 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-20-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-20-4c998976c6c7@kernel.org>
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
> Initialize apparmorfs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. apparmorfs never holds executables
> or
> device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0security/apparmor/apparmorfs.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/security/apparmor/apparmorfs.c
> b/security/apparmor/apparmorfs.c
> index a99366467217..351ea3a7120e 100644
> --- a/security/apparmor/apparmorfs.c
> +++ b/security/apparmor/apparmorfs.c
> @@ -21,6 +21,7 @@
> =C2=A0#include <linux/rcupdate.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/poll.h>
> =C2=A0#include <linux/zstd.h>
> =C2=A0#include <linux/string.h>
> @@ -263,6 +264,7 @@ static const struct fs_context_operations
> apparmorfs_context_ops =3D {
> =C2=A0
> =C2=A0static int apparmorfs_init_fs_context(struct fs_context *fc)
> =C2=A0{
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &apparmorfs_context_ops;
> =C2=A0	return 0;
> =C2=A0}
