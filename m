Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794904345;
	b=JL9q+o5UIFspihDdPcUS3S2tinOFVLcw/1XBHsXmRyAQU9BzX0PYC+B4GSnRbuLLiQGo
	 m8JMXuntP8PwyTEaG0Ty9TZjoj4ixFzmrn71n6s0+BkOXGOyAbPZGuTCoibZaNLB0Ec//
	 z1Ado2Q7MfZx+WMnwO1lGJEGS4fQ+pRvHqWbTQ3A2twE0ndx9d6cBrkbIHiDOWseMfMmt
	 q9hhJYK1k3YqtX5ca01ET/euprus/my/Bb9E02Cy2ukQAoCMRfppieweuDZMS4Pr12F8h
	 51unINsjSGg9e5lC3dyvpZzKXwSZTg8H66oRu/vgRuUrGHpDr3LmpfSI2ceEnVLGzXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794904345;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=iGZ2JImQ8AaSp09QdDpLN1PoylGc+Kk+7WphF44IQ4E=;
	b=pZ7bbaKuM8U9/Es+ZvSykuuSJyXUnm07Og7/wzMftGkLPEnG7bfyDapSggju+JTjJ0K0
	 1L+QrDbDxG0L+I/kBFpjDR3HiJO8JpmGlNGCzyMw9aXeM5Q5Nj3WFaGpV/SFfwyp6MR2E
	 cvzdmmjuIEKabE2yqv6rLTH+eZq8Mehxlwx07mkt6EyHLlFvXxWX3zwgbswl547pVW6On
	 B3MI90l9hajvwqWlvIdiZ7pAtd4tD65Nzv//zWDS2sCPfuOve++zka9tIgAXf4J7YvXOs
	 JR6jojopkPtdYJ6FMOlPKQYSe2y1BdFehBvOQ7326udr1nTFAQpZwEYb4yG3ZK/ZxyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=EFPX8Vuf;
	arc=none smtp.remote-ip=209.85.221.54
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA289606A88E
	for <target-devel@vger.kernel.org>; Tue, 17 Nov 2026 08:32:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CA289606A88E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=EFPX8Vuf
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-4a358881793so377438f8f.0
        for <target-devel@vger.kernel.org>; Tue, 17 Nov 2026 00:32:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794904343; x=1795509143; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=iGZ2JImQ8AaSp09QdDpLN1PoylGc+Kk+7WphF44IQ4E=;
        b=EFPX8Vuf7iz+NzEUQG+pPgjK/MbrESqv3n9ATmra3Zopp4tpstszPHFfE2sR6EI1XH
         /MuIqTxoWkMXSLrvcYnqUGQvNVGY6YndEf7Smwels/t/G0PiJAqa5YTB3/XSR2c5vF/4
         5S685rADCuM7kD+KTHsn5xD0Bbvj+kfNJN7h3Eeu6Tgpz77cxc6E5ixV5T0A3r/KAOuP
         +pclbSVYUTOzYQ2RRiRVVs4C5Z7y/NhXCRc6Of4Q0fL8jD/Em4FfidsaQN0h6TdkChBo
         DufH5bn8tmF4fp27j4WWCE7M7sjar8yCORXmuz1wFPQxfWworU2xHCWyEC/YN83R4E+t
         3i9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794904343; x=1795509143;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iGZ2JImQ8AaSp09QdDpLN1PoylGc+Kk+7WphF44IQ4E=;
        b=I9J08ePhrAAnsxCwC42e6Ajp6tWSQs6bbszOQCwfNLoO1rAI2CqPtGQlf89FQ0CVgu
         vyVympee/l4sa4J6ciUb5hXo44+MXKRRm7wlC/HVU+MQp6aCeWLWBccZtUMsvrciZovz
         wBDlazdgyFDXoky2yqgvo/5p64496C8oEVmGYFwZ/DfR6HBxqa3qhJA3KXk1PBQ1F5zv
         xmbNlpOon3B1WS4o6EGPM9JxMiCxxaa8llgk8aJR+V9f0JNs7V3R+G0jFlauPApoS4ih
         ioUIfY/aStE1TN+BCSDgHWhCYR4fc1vukECGQCVzHXrowMvV8+wp/GXxhCD6uIze4Sw1
         dr3w==
X-Forwarded-Encrypted: i=1; AL+hErGeyI4JVjwtodRpy6CDJE1UEznSqoC6QCN7T6oA7z3dq+Mo8O0Wciv+5Za4bgSZrNeL1TTlRClUlzA/+vA=@vger.kernel.org
X-Gm-Message-State: APuU4Z/5UG00BPOATAnNKqIG4s6LjfnNrfbrOr/AFVwz9kXqrOlkaDVS
	ovzfnRY9wJAUNH/8sUEuCGaDi3L6ZESMSv5C8DKLOv/NCECKM9Nj8fmJ2Ub+UvmyeqQG
X-Gm-Gg: AZFdTZelM2oh2/LRdWKaZsSn0QJoaujy89Q2aknrw/9iIGAiBkYm3vSWHKNfLX03hC4
	bO90M5ZZF2QUHVfrON6hcT8Q+nWBUjAOE+/mC7EswjHwEF5ELhW+766/MJf797br0IvT9jCbPvR
	vu/7QYjNQSWSD0X41Npdxp3Ti9JstYC5YIvFXvC22L8n+npXhj8MmOTZE5sx8mxcntHTGeCmz8a
	+x82uyywCGQ3Of3UOBaQICj4H4gXB7BHzZ5We1YneldS/he9luI6pQ2CF2n/ooNLSUvZBUYG4bp
	hkp1nSIrTxgbsPm8TabkPtYv2BBJeYsBXOuVsorgII+Q7OjeABjmT4sEXdX7r+TZq+QxrMpvcHe
	ix0mLAV625uTpQw1vn+BWUnsPobyBbkL76Nw+WNSiCIZLhxJ7MceSjuq5typFvX88JPZPulXVhc
	f1Cih6Hvu5MsiUCt0oal67SR32mcv/39li0sVfw+LjBek94Q8tcuTNvWPMiNwCLm/FOIZPYB3Ru
	XWy0rO1R/U1w3khcTNrKraiV3VhwEqEEH4xXev1cD6MykFbwieykDhrXm7OlKLjozfADkdqZXbd
	x0lMiaVGlPDKODNGlP7A05LY2VzOhaDGvqrf+7qWON33CULGvjdl4ZfOlwx8sNBBXfn+K6Js/LY
	+3dSqr0bCqFlcAKflGrC8l+kWIjDPS1zYbfLvUJjY1FJfD/FLEDaKkjks
X-Received: by 2002:a05:6000:3108:b0:48d:f9dd:e3de with SMTP id ffacd0b85a97d-49c7353c415mr27089117f8f.45.1794904343236;
        Tue, 17 Nov 2026 00:32:23 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:de4c:6789:33ce:97c2? (p200300cf572c2800de4c678933ce97c2.dip0.t-ipconnect.de. [2003:cf:572c:2800:de4c:6789:33ce:97c2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c608d10b2sm43646659f8f.44.2026.11.17.00.32.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:32:22 -0800 (PST)
Message-ID: <fd39200976086130cc82d59699a988fc3e0689cf.camel@amutable.com>
Subject: Re: [PATCH RFC v3 27/44] openpromfs: use fc_init_pseudo()
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
Date: Tue, 17 Nov 2026 09:32:20 +0100
In-Reply-To: <20261116-work-loop-pseudo-v3-27-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
	 <20261116-work-loop-pseudo-v3-27-8cbbea1cf34f@kernel.org>
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

On Mon, 2026-11-16 at 12:05 +0100, Christian Brauner wrote:
> Initialize openpromfs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. openpromfs never holds executables
> or
> device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/openpromfs/inode.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/openpromfs/inode.c b/fs/openpromfs/inode.c
> index fb8d84bdedfb2..6cd02d456bac9 100644
> --- a/fs/openpromfs/inode.c
> +++ b/fs/openpromfs/inode.c
> @@ -10,6 +10,7 @@
> =C2=A0#include <linux/string.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/init.h>
> =C2=A0#include <linux/slab.h>
> =C2=A0#include <linux/seq_file.h>
> @@ -419,6 +420,7 @@ static const struct fs_context_operations
> openpromfs_context_ops =3D {
> =C2=A0
> =C2=A0static int openpromfs_init_fs_context(struct fs_context *fc)
> =C2=A0{
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &openpromfs_context_ops;
> =C2=A0	return 0;
> =C2=A0}
