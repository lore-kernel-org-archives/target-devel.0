Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794904088;
	b=NU9BBVxL9Y1PzpeX/gbPuWcG2p2N99TsOXA7Sk4+hvzOI+8yCeLamP68B1m7XaxfHxkl
	 AEu0fXhgumV5JVex8fh4a12ptrZJvdxdLLu5ymFtJlvI+1u4w/f1DS3ufWCXJ6fKL9ZOg
	 VrOsztsVEHvxf+Riba/yPy7DRrPwFq1yP3na8vWDDvWVBHPRmZuUuED5u3MtlxBTO5wR8
	 qarUDo+SnxhQNuABmeWb5ihvV1el3oD7urwB5cTv3CeC0+P8XEQNy2ICeL7KYstTtIqi7
	 WUtfjlzj6sta52aIXsEqNv/NB/pY+KBzMxFAFDGwVbJfoSdbC8pSan66QoAQqmzhbqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794904088;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=AET1JHslkSzLNTOs00e5qdhXA33kuZnL+yhN5Q6hFHY=;
	b=Yb1FmY+Yn2VJaJamfqF+OGu/PPKP086Uf5Ju1b1xYJmC9Tcelj5fDusfb3iFCMVnQPsR
	 m+RhnbSUGGgpS60jM27klWhx9bRCXbYXH8jufOz/HqOJSA8+7llzcaQORzWhey5XxqI5L
	 ghf3ZGHOQHa7zLqSBPo1A1UMLjsqMrfw16I4at1AIzhAzCzZQR3olI4wvYfZnf36eU0TZ
	 nGpZqlJCoAcC7FYJRyc4LPrUyNzanffhwHONKVTgE52BTijcpyEGHijUU6csTcJAVK2fB
	 r7IVNQzTgSzWtnE6DgYpImm4tG/G0IN987kxN5qASDNBdqhHeKPJYt1tZniE7bzEK+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=G5kPAzk6;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160F2606A89F
	for <target-devel@vger.kernel.org>; Tue, 17 Nov 2026 08:28:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 160F2606A89F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=G5kPAzk6
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a3517554f7so47025585e9.2
        for <target-devel@vger.kernel.org>; Tue, 17 Nov 2026 00:28:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794904086; x=1795508886; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=AET1JHslkSzLNTOs00e5qdhXA33kuZnL+yhN5Q6hFHY=;
        b=G5kPAzk6YKyHaocuCdT5IFslrUJH5/ldhNVhV6xYWUthrOIppv7Y8kBtZdevqAkpzI
         BDRFsu2jrF+YCozPia7EV1j3KLeZC6Lnc8BgBdPYFaePytvbOESC0m4eRkryqhoEbPxE
         WM5n2Fa2IGRg+WkSIkgfyoTemIrDdEbfzZV+2Eacmamzzj+t+HuCPRqV+GPswkKxuMa/
         2fm9UdrHUV6v7jtlgmqycAcrxGUcSbURHcUFMMj9LS/XjgTFJtp8hDDDARovdS596Fjm
         xwkar34XXNuYsLWY+RNo1AZ45FE/L69efZRvwjPbSAF3CGRgr3AaMHZz6Kf/cz8pCVs/
         RhpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794904086; x=1795508886;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AET1JHslkSzLNTOs00e5qdhXA33kuZnL+yhN5Q6hFHY=;
        b=TdiWW/B8r96/7lRvmhsTLNM8CAXSm21tHg54KiFNN/i/HKEg+YrrPn3gxlXBYF5v87
         zb86sNoIFbKNQ2JvO5dnKgbX+SZk68GoXjsPXryA0AbUd7k7jO+UfXz0af1Uw100cnii
         vcN3Ocp6aRJDeePm6eEzMdKDeSHyk7npg8sAiHLCAPa+HP1n+82Q05xl2P9jb3CARl4R
         XtisdyMl95hXSbeMGAJTQ2ZIxkTtwyzD5CKTj0tz960JsdqxuR1cX9Rt1yTEGXA1Olrn
         Wc0XPS+QbCBu9aXWU7jrNzGwa6WmxVrbWA7M4eLPpJnZD/qhiYpTdxP3KeOsf0iDJAFQ
         MM/Q==
X-Forwarded-Encrypted: i=1; AL+hErFkTD4mVitilwv6ZeNvDtMpE5PpLe/mjhHlQ1rO27Jz9rfrhJp1qnIaB8aKPcsdhpz4oM90qvNrTcUzkpk=@vger.kernel.org
X-Gm-Message-State: APuU4Z8TCrbsMZLDqhBUCPzPAN+2lUH2vPgz3VIP7VuZTm0ed2frlg8z
	s/fMcNUFfUSpAqbnij7eZBtPlfPhIzeIYZXipSP32q+4ghB4jVIJu8GyuyQiUXcO68o1
X-Gm-Gg: AYBFou3mWzjbs7RHYzMI18KLRsXjDumhGrLkFTasHTuv89FUX8CcubUqz8q2WrdWn+Y
	D9URUrxMNaeWzP2j8/RGCoIJbsosKf7wzkcdLpUw7zwd2I6KWnkba3FyqOhg2nOaLgU3aCjhvmr
	1erL8OcBE5vyohBe4glnVNnUSGDCUSEr5fcvqcvGLVkrDM8Ue902a4ucgehcu2UvudQawKkO8kM
	mUh0a3xFQDoiP8WlJUtc/bEBC1X7WFX2RQzLeqTZ5Pf5dZmLuI8p7hf6FyQ5FeJks6FgMPF6H8A
	GM9FzZuc3foS7eDtWayFIIduainGLvZDEDv4YRO4EZeAtlxiwqXQjWEewx6QZVr4pfXf1IJfn90
	JFsBq7mwJEM6CkI/79ztsN39JMAjFJoxQUufFs7gSPKwcwZWNCsFrsK4G/VwxoQgekVo8rseLHW
	W+0/I919mCtKD2EJihui9ne6ognjKYmX8VfpWxqeVpgfY5jWJ6MjP2jnS1jAK0OzvjtPCd3bjFI
	JCo/uvBCNfHWGaz7Z7V18ncuFET7T1wt+BLRXPPmC+WXwsG2e2uDgkmoio3gYda5gL2Jd58/zYT
	URFY3+BVmGqD4ztE2h9hLojLCha0tCzObURdz0hatBpeAFGBhvgQb2N7cAXGk3+7bPk/tHkTTMK
	giqv7+OCw5gjBtLV2ov8NCcEcv1O92xUBS8aOQZnj/dyvu8WttsEzcogJ
X-Received: by 2002:a05:600c:512:b0:4a2:a9:ed87 with SMTP id 5b1f17b1804b1-4bb55a5aa47mr209766355e9.19.1794904086313;
        Tue, 17 Nov 2026 00:28:06 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:de4c:6789:33ce:97c2? (p200300cf572c2800de4c678933ce97c2.dip0.t-ipconnect.de. [2003:cf:572c:2800:de4c:6789:33ce:97c2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb78418853sm74782845e9.8.2026.11.17.00.28.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:28:05 -0800 (PST)
Message-ID: <fa0ce0f7ecdbe91cc6773bcbe86be137d2129944.camel@amutable.com>
Subject: Re: [PATCH RFC v3 21/44] nfsd: use fc_init_pseudo()
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
 linux-kselftest@vger.kernel.org, Chuck Lever	 <cel@kernel.org>, Chris Down
 <chris@chrisdown.name>
Date: Tue, 17 Nov 2026 09:28:04 +0100
In-Reply-To: <20261116-work-loop-pseudo-v3-21-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
	 <20261116-work-loop-pseudo-v3-21-8cbbea1cf34f@kernel.org>
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

On Mon, 2026-11-16 at 12:04 +0100, Christian Brauner wrote:
> Initialize the nfsd filesystem as a pseudo filesystem. This raises
> SB_I_PSEUDO and also SB_I_NOEXEC and SB_I_NODEV. It never holds
> executables or device nodes.
>=20
> Acked-by: Chuck Lever <cel@kernel.org>
> Reviewed-by: Chris Down <chris@chrisdown.name>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0fs/nfsd/nfsctl.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
> index f32311f2d7cf9..ce2666deddbd9 100644
> --- a/fs/nfsd/nfsctl.c
> +++ b/fs/nfsd/nfsctl.c
> @@ -9,6 +9,7 @@
> =C2=A0#include <linux/namei.h>
> =C2=A0#include <linux/ctype.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0
> =C2=A0#include <linux/sunrpc/cache.h>
> =C2=A0#include <linux/sunrpc/svcsock.h>
> @@ -1375,6 +1376,7 @@ static int nfsd_init_fs_context(struct
> fs_context *fc)
> =C2=A0{
> =C2=A0	put_user_ns(fc->user_ns);
> =C2=A0	fc->user_ns =3D get_user_ns(fc->net_ns->user_ns);
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &nfsd_fs_context_ops;
> =C2=A0	return 0;
> =C2=A0}
