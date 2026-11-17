Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794904110;
	b=G1A/cO7yL1Yx5HIl9gmyUb23/adTmuzh28hmfeP/Xw+QH/n2Qz3o9AOyToCTrJiL1TTU
	 gJfrXpNg+QKT8YDSuLCZPbMGr7gqzcJBTwEHc37fmL2qlY085y0L0ah3sL8qH2m2+ZWi+
	 dEOrQgeTnr79K4AAJWimS+HRma8bBOIoQxdP3Ros4OlwtCqxe0EdZomH12wFf2SsfLL6J
	 wLGqsHdDXvek0TQNpzronEnlUpusf8n57ipW+YN2gYZbaGW6v8heHvRj9QR+mAVqKw5t7
	 Dxt3GjsVBk0v7iUBE/y+5PKkDU/f1EtCS9hqq4ng/dJV/KvcJmNa6Uh8nlcZMGgmImA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794904110;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=80nJ9mfJsz3UGKSZAnLQ0A7kD85nyx4H/r5vYSV/3QM=;
	b=Bmo92cMQH2SRcHeSTpy1xDA9QsSGLtxcdDc6q9Tn39i+GwqaRURrphLlorxSLsqdSli1
	 YEigQTLm95xz7LcRL2AwmULTM6WoyY+XRoEqBK8DBGQd3iPVEmWA2PaqUeVoAlWt7AtqY
	 PkbMGYbu3mAuvLETmt7LarRLVzRCWpRsSUY6YMxxwm1zmNhCyXT0k0dBiS4uBCGR5FA3q
	 F9s3LPLlBiV8FfRb1sSblGny+jQnBuj2RuHK1Vb7cMsjjz4Pts5ZrXWVviPCmz3mYAAGR
	 Mxiydlz28QowICPLptrIkCibPGFnlswNWOlvWBDgyvCuCivkMmuYkbIHuKgLyGM9VIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b="lDHE/E60";
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDDEB60A2604
	for <target-devel@vger.kernel.org>; Tue, 17 Nov 2026 08:28:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DDDEB60A2604
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=lDHE/E60
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4b79502c27aso36239965e9.1
        for <target-devel@vger.kernel.org>; Tue, 17 Nov 2026 00:28:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794904108; x=1795508908; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=80nJ9mfJsz3UGKSZAnLQ0A7kD85nyx4H/r5vYSV/3QM=;
        b=lDHE/E60fAF7y/GcfWe7zssqpibfABjaDWc4DbPAbANFwY7mipSCQzk/tGna/Yk9Yp
         5M31Ja6Q4S90Eg4jWdoE2GH6TurYV9Y9Yxd6SoBGFySZlSGgcD3Nf8Ac20Morq/IEeLi
         HZNDCkpilOoqmPVEk/N5paMQG+RjNO9OhPzIDtVn6k+5pNMY8rSlnV+zGCrptyxwBw8i
         uHdMwH/Pby0zhrQLCKl2b6izfUmExSZrUoQCnWP4NFP78u9vhGGyVwUcvE3no1VAV9ln
         DDlxdlg3j7mlBLcF1wQFzdXfstbmRKgVspXMjOajtHMeg5NsSNAba7k+RMZ1HFntU+s+
         8A0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794904108; x=1795508908;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=80nJ9mfJsz3UGKSZAnLQ0A7kD85nyx4H/r5vYSV/3QM=;
        b=08XAbiud/tw+nncx5T2pXBCY3yl0ye1ZcyRuXl9eeIVDRddl6uErUoQRYOFvu84xAR
         yEfsR4yYrmkTac5AWJe/jzlt1Oy8Rmb9NCxWU0lKytVtGeZhTDIVZdcpu2vXFPCQCRHy
         Hmtz3xFdUjPh0JoYHygTTo5jGSsqQT+3s770dKR1aGgwIQxioxKWOr9yo2gjioC7t28T
         yOgAe7Jv5/5wtpasiMHbm94sacs0c2qnDvVlsD0SbP15pMqupTeLYjEMUQN94Evr+sOo
         qDwZuPfJseNUT06X0Zn/tpLjcmasZVXaQaHeneMW1AZ8EcB9mDf7l7TwDZDRplbJ1kY/
         /8JA==
X-Forwarded-Encrypted: i=1; AL+hErELHE3KX66Sy3u53rPOTQqUn6igjmpYfuJRGlm7Xi/jfv8P4G5kOz9IaRYCkqc758Wn2Ce2mVg/IvJo3QU=@vger.kernel.org
X-Gm-Message-State: APuU4Z/1WwtwlsJ/PI0U74s1xtk22bwhC6Us5C0K9tcX7k9QpdSgidKS
	X/sp8FxXmNafU+YmvPfSOJNMs+IPCkKfUvT3wdRyuJALkvE6Iupish/Ektvd1NukTw9K
X-Gm-Gg: AYBFou1xgREa7mdVK9OnhTnWoWma8zovu+aa7xEKh8wglpCc4n4++1QJbK9KoldRQc8
	NXdHUVCTI94kTFO5ZdBKca/omYpRJLvp7TWqIcNTJfZd63sN2EeKfUoE9bs7hvLuv9eZsrxMlSi
	u7GsMyT3vNkQkbOJwsWU3X5isBLHK9mYVK/Z2QGt0wtJUXyRaL25SkLY8pA0QawP4vnL5JGGaaD
	QVTFAIbNevLcwhda/Pe5MOMFjE0mnj9AzOwwhYPa9E2Ci9HJmASJdZr+lBJIAmq54MpAt77LBRj
	ltQm0SwoUdSmPD8wxV4TjBQcOvZp2CLXrTWh37CzY/+xTe/pE8TCHIDdjtmGAgyijtwOJNeAnMa
	vs0FX5C8VkXzNhColq55foMNyMaCo26YtceUXa+6O34ddU2ZsbE3MMLMKZz57WuFx/vtlPFgRmV
	X5FPpUiUsMBeunSMRSfE3X+tdH5WWAWB3eeKcvkmzHeSpNE5rj+mH68sjT6e/4R4TiUK1XwWZgs
	3nefrWXxgixAwFCMyujI5BXbFb8wNJAIQoMGN7csI1LlpNjuZ46sFhaO5ho2nEbgXGmaTXc+EXN
	OifAClMm6M7Oyr0zvwXRQICzw+cpJN+2iIBSSOFz8aHSTnMyXQmWGp3c3IKgSoErqrX9VAvGFt3
	ptAuGRoIOVCmvH8pA52q2gIwt9m3vxDRE0xZJedBadasO83A5Loiy25SF
X-Received: by 2002:a05:600c:6286:b0:4a1:7e77:c382 with SMTP id 5b1f17b1804b1-4bb55a5d634mr255399085e9.5.1794904108278;
        Tue, 17 Nov 2026 00:28:28 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:de4c:6789:33ce:97c2? (p200300cf572c2800de4c678933ce97c2.dip0.t-ipconnect.de. [2003:cf:572c:2800:de4c:6789:33ce:97c2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb78422d2dsm75197335e9.10.2026.11.17.00.28.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:28:27 -0800 (PST)
Message-ID: <afc070a816e3ae5eb3c9e2d62d4f25c59ee61df2.camel@amutable.com>
Subject: Re: [PATCH RFC v3 26/44] xenfs: use fc_init_pseudo()
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
 linux-kselftest@vger.kernel.org, Chris Down	 <chris@chrisdown.name>
Date: Tue, 17 Nov 2026 09:28:26 +0100
In-Reply-To: <20261116-work-loop-pseudo-v3-26-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
	 <20261116-work-loop-pseudo-v3-26-8cbbea1cf34f@kernel.org>
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
> Initialize xenfs as a pseudo filesystem. This raises SB_I_PSEUDO and
> also SB_I_NOEXEC and SB_I_NODEV. xenfs never holds executables or
> device nodes.
>=20
> SB_I_NOEXEC also refuses PROT_EXEC mappings. xenfs maps the xenstore
> page and guest memory through privcmd, both data.
>=20
> Reviewed-by: Chris Down <chris@chrisdown.name>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0drivers/xen/xenfs/super.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/xen/xenfs/super.c b/drivers/xen/xenfs/super.c
> index 37ea7c5c03469..aba7d038ed735 100644
> --- a/drivers/xen/xenfs/super.c
> +++ b/drivers/xen/xenfs/super.c
> @@ -15,6 +15,7 @@
> =C2=A0#include <linux/module.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/magic.h>
> =C2=A0
> =C2=A0#include <xen/xen.h>
> @@ -80,6 +81,7 @@ static const struct fs_context_operations
> xenfs_context_ops =3D {
> =C2=A0
> =C2=A0static int xenfs_init_fs_context(struct fs_context *fc)
> =C2=A0{
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &xenfs_context_ops;
> =C2=A0	return 0;
> =C2=A0}
