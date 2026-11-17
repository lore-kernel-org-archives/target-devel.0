Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794904006;
	b=VGPN+JZMUzsRN0Pq9xhXUTYZdKTqq66XWC6fPxsZmGR8BYulA0QY95m2Q83Y316+yOv6
	 EdknDRLvR5ZM+bDPzHqtyV/7fglXlGEkBV8BWNknPNgMe0tbD/tjC9WcWYmsfspAzVKRc
	 3+myf/iwVsY07chIGw/qD1saVub8S3di2MfjxEZwR/82KtNHetWOrgoUbwaDhHQkNbEF3
	 BGFqwvzp1NuHRBLBEA9BncC5lfUzqfAX3R/QBRNUCTW+Q1TWApa8mhLtZuHkTy4S/W0H4
	 s7aOrEhr9sy1TIfwT8o7vX9r9rYztKusrZCsRhQXkAGWeKKuzvuzSN2BxN4M5SeymzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794904006;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=zuUcsMvbqw5dxN0Fzu67367bPJAUtTqv88LLlRQCTVU=;
	b=CXH33r4yKsig2SrkyZMndcKpm20zn33EF2/cloi6reXRVfKYpGRrvyDaadCSSvGpZ3FC
	 K0tmk71emv2dShNItUxrNRzgzc6HLlowFt4KMW5Kkqda0KKLKyNnGZLVWbbLhig34UHC0
	 k1aJx/Pwu2VpqikhZ1K9Tuhk1rKiiehZXkc3nOf9UVMI4+1Ma7qiqz+TO1jjTQ72FoMTe
	 shwJ0tbTxUhaz9L9Vg+AJGM5EGqsAlCACLatYNGWCceiDJHNu9++V1cLLrZ8l7B7iUSmy
	 0dA4ace4z4cwakhei6B+hiHtfbjyOQaElHGGdqFKjSJ0s6/qUIV0TAxCuQeC9zcHpaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Bh3COd7Z;
	arc=none smtp.remote-ip=209.85.221.41
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CFCB606A32C
	for <target-devel@vger.kernel.org>; Tue, 17 Nov 2026 08:26:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2CFCB606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Bh3COd7Z
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-49412eb1474so2231635f8f.3
        for <target-devel@vger.kernel.org>; Tue, 17 Nov 2026 00:26:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794904004; x=1795508804; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=zuUcsMvbqw5dxN0Fzu67367bPJAUtTqv88LLlRQCTVU=;
        b=Bh3COd7ZzI6TmZdb32Fg462zWvuh7WQNnrUpXucHXcpV5t+t8gMfKKxOWwhkcHBcNt
         zIJKpUT9Ten8K9xmb0ZHj3p/ljeyNVefWtOpjWCo7Igmb/P1wzmYs63YOxLg7f+WXmDC
         wf3ao9cg3f1DrvZE/oBKoQiWFPBKSPnWk+jCT2CGoQgxeoDuJREjXd8oRMM0GizRyDLq
         q7c8W4Fdq61I08pJrjWNPm+S1jXNjmZ2MpEutx4SYZ/JoE6iRzvUZ/uRuGO7TyWDBzw1
         OlncqX8aSwrA8zDhY0Cn+N6eWM3qFfFk2ULf9A0Yk8lhKFDJjJXQbcxKbI+h6RZ2p0E1
         0Fcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794904004; x=1795508804;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zuUcsMvbqw5dxN0Fzu67367bPJAUtTqv88LLlRQCTVU=;
        b=j1MoBiU2NMJUmTlBx+DNzaz3Zu9dBkiKCWLamoGb/MIlUJ+ZapBr0D6s6UHZdSHzJD
         6D1Xl6BAnAwFSxvV9dR+/J5TVVhhQdQi/s489G2TGlU+nrQQ+DRh3zDABkpKcLiqBL4B
         Rhy481oKRbm13xVPlgTLYe2BzBeNdYFvYK45oGcia4MfYI3dG5+j7uedWskrn1YHa+w5
         zRT+k4zIpnOB8dkk0G/pKNnriO+V8U/ckltpQjk9g8eIY81QycuL3XM/C1wOh1uPqxYT
         fM1iSLfrq/vD6Rj55hn22ucMiH5T8yjNnkafNaj1gTqGrVVpq6UwJMW1H5NF2p5HYZTj
         jzNA==
X-Forwarded-Encrypted: i=1; AL+hErG6oCAjXEF2cjBH9oNy/eqmp/ufcvTcbyosFlXs9cae0wYaplLwcj18T/bvsqfaDRmn6VASel2btpNFocQ=@vger.kernel.org
X-Gm-Message-State: APuU4Z/orkuzhnToRshR1BDpqjFUJfXEq9T8lwJ6lC1OhdH/l371eUms
	3GaCUfwl7Seyb9efoEBkh9P6GYfK7ks6OhbXq1M1cTievfnU6qSxdlCEKnilWLLI+tlH
X-Gm-Gg: AZFdTZc458qYXQKTjIloBFB/2atobrOSHIorKT1U3aifLQHtSuTEWUFFmSZLQG8jhPU
	6RM0OvGtY3JE6qgvAnrfNRhWZZqVRxBeikh/fLalYDbMFdLUHhpqcXx5d+RXfHmWKOo136pXy1L
	Deba3R/xYwdXEGdfjFdmcUt+mOXsGtzJ44mGHZnuo5I/wwRSZBv4cnDzYIfcnMFskPRY6CyjbXO
	V2VUt79ZTu4EnYo5E/juNUPpGOIHvDdio1VetTvvvWf7Yi2jjBijEoeVDWgHijhvDLVWL3Pr+t7
	cc8VlSGPv579DkCvhsbBcPAg51PhLpBL8rX6DstLoT2GdsghWeeW8bPOKTVOrnlSZ9XOOthqCYA
	rLa9JvvZ/p5Dh9zInqYfYlG/sk0D5cKcw4cLymKZEtdAcdvzTI84ewSyMelZ63oLsuitPd+w15k
	K7DvjjjQ/XU/Qo/DaM5WX3z30P8tW51WRZfYH6Z5WhFpRB2srMVXUoJMC6Klnda6LDztlJWYewq
	H5VawrTOPLsi7ybKTIDIcTAnTMRMxQn2ybiiwPT1HrYzHbRYAHxTnLJhaEgIALhvDDrCAibe2c6
	MnDEDtGJ3xDXebunulHnL91pM5ab29znyoM3bV7VzozFRQzHzJcdKtHI0blJyFfit+6YqB8fNOL
	OglKLFjudpYkOyG4gWtdr2kDqErefVjoevZaRP//wTYLttgHyyk9hJGdd
X-Received: by 2002:a05:6000:2009:b0:4a5:2e5b:51c2 with SMTP id ffacd0b85a97d-4a52e6a947bmr243585f8f.29.1794904004601;
        Tue, 17 Nov 2026 00:26:44 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:de4c:6789:33ce:97c2? (p200300cf572c2800de4c678933ce97c2.dip0.t-ipconnect.de. [2003:cf:572c:2800:de4c:6789:33ce:97c2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a4de4cb1c3sm977858f8f.8.2026.11.17.00.26.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:26:44 -0800 (PST)
Message-ID: <c43d70badf41f62f8e149ac024bab3df979fa756.camel@amutable.com>
Subject: Re: [PATCH RFC v3 11/44] failfs: use fc_init_pseudo()
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
Date: Tue, 17 Nov 2026 09:26:42 +0100
In-Reply-To: <20261116-work-loop-pseudo-v3-11-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
	 <20261116-work-loop-pseudo-v3-11-8cbbea1cf34f@kernel.org>
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
> Initialize failfs as a pseudo filesystem instead of raising
> SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.
>=20
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Chris Down <chris@chrisdown.name>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0fs/failfs.c | 3 ++-
> =C2=A01 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/failfs.c b/fs/failfs.c
> index 437cdc981c2de..f03334f361c0e 100644
> --- a/fs/failfs.c
> +++ b/fs/failfs.c
> @@ -3,6 +3,7 @@
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs/super_types.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/fs_struct.h>
> =C2=A0#include <linux/magic.h>
> =C2=A0#include <linux/mount.h>
> @@ -132,7 +133,7 @@ static int failfs_init_fs_context(struct
> fs_context *fc)
> =C2=A0	fc->ops		=3D &failfs_context_ops;
> =C2=A0	fc->global	=3D true;
> =C2=A0	fc->sb_flags	|=3D SB_NOUSER;
> -	fc->s_iflags	|=3D SB_I_NOEXEC | SB_I_NODEV;
> +	fc_init_pseudo(fc);
> =C2=A0	return 0;
> =C2=A0}
> =C2=A0
