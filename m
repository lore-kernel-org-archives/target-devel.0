Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564728;
	b=NiY3EKJ2UvTmBpVSV9crh1aJR8KHpNAecySsMOo9yJR85eT3oAmlpbe0esXodvchMMOF
	 sKffM20A1c2qg8/MrhAiJQoOcSIpXc/z6jD2asDZ5sDQnrXjkEK9tpXzamWX/rs7/qLp0
	 idcsZXl7972FBAil9jUq/F+wlVyRS8JwvHs8Tf1m1NADX1f9gNl0kv6CRqa6PUyKCJeTt
	 RvTMcDYvYdpbPxGMmX5bZ8T/73LShEDG7YYfs809WP23ujmsK3pXAbI6LF2MFynd1reNK
	 Qoqh2oHze9Wouwn283mihex1cuD8tyvmeAmN5cIdrXbG4dS2G7DBVR3RsQCVfF7mAkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564728;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=C9TZKYRayQVC7UyXoancZRI4bPIYIHY06/n7s/4tB9k=;
	b=YnaDoe/eGErFCuNRJUo9Sc2YLGem1Gdj6DH/4gnlDiQIJD1/bCneCM3sGXsyLJKuzZPx
	 Dzrd2Jsq41BpiWMP92Y9Xj1EEezPIRZCViQ+U+8FcJqZMlxMdf+qLiFJyU/99t9Wer8dE
	 l6BhKiAdAZKtAdi4/1CUiG/1FK5R4TeAiyq9Dq7dxBMVUe0joUnG7f16V0m/achsVPrT7
	 L4aEUlXyDv3HGXAOskZC7GoXiASuls/uRQLqPsDOfHm/M+W/iyGuq/eSwIcHGhMlemwfy
	 EQg5lQKlntWbHYKl0I6kZ6DOKb0cYom7S2qLhNr7Jb/3aO7P7cRK1igW+B1hjJc1rfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=JofFrwon;
	arc=none smtp.remote-ip=209.85.128.54
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0297606A881
	for <target-devel@vger.kernel.org>; Fri, 13 Nov 2026 10:12:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C0297606A881
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=JofFrwon
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4ba013938d7so10449075e9.2
        for <target-devel@vger.kernel.org>; Fri, 13 Nov 2026 02:12:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564726; x=1795169526; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=C9TZKYRayQVC7UyXoancZRI4bPIYIHY06/n7s/4tB9k=;
        b=JofFrwonLml2YmEXhdcViuKQhdgodt9TPfkjQoH5bRE5MuhkX9eapeBcuLoN9BMOMG
         mg62x7tr1NIo2ce3//xfxGBo2Glw1JnMwrRUE5PKg9cgXRmANAsmerUzgfn4I+APSoic
         nLUkrr6h7Ej/6ZnsBOEx8OEPXrCx3CvMaGkTszs9w9WOs3gF62hftbL3MH/tr8iwAkM5
         IEqdn+20vI39qrHT5Lu5B20ux21tBPJwfptIyU9tNUhlU5QyFDk51k8ZhbiJowoQswf0
         13eatahih0uhEB44iQMwucAarD0vNvZBAG3aTkRmepVuKD8cgol5N6Bgv+DPTP+kX4Yt
         YdFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564726; x=1795169526;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C9TZKYRayQVC7UyXoancZRI4bPIYIHY06/n7s/4tB9k=;
        b=fpd9SBF3YppbMMLRdzXb2iG+Iy2NJeUU96DlBBbUh3gBEVnvOppAffQ4+eb9i4NZy7
         vB87gKMo3QrOK6ApUuSScYNinYimEX2KzDeQPbr1FCTPx87zBUeXIAKwRaEwYD+QNhmv
         dy6P+claapzqWsgnvmkkOc2SbZK6Lw8HbJpRrU7dSL7GQ6XSl9U7LyHLvN+jaOpbEmnn
         B/J7XLihKEUnMbt6z66L6XvWbjAQAznl6rW8tXu1qs2US4W/GX9J54kRS1Xkp/ikraF/
         D3Gh3BEtTO2UGrbx+I8/o8obmIRWS6k0nU6fosRjuHdGML8sI7hNSovfmZWbzgALW3sx
         Jqzg==
X-Forwarded-Encrypted: i=1; AL+hErHDK1qIS7hBr52zU4y7+ip7Sc0aXD+IP7VLyAb4N+vvEMUMPgT8CrU5PQLw5PFeGrmG34Y3gEr6PzP+bnU=@vger.kernel.org
X-Gm-Message-State: APuU4Z9MLd6+hH4/FIEgn0qxGvDjXOfXdcxuTWorW7JgTH1ZfwvguaSx
	tkq7LnxZ/X7XPY7prB7oUcbEgOaPVAvco5kKagMQE0ZGyKPCjOf07y97Z8CXBFST4r30
X-Gm-Gg: AYBFou2WiNSB/hCu6KlqnVucpaMWR1mniZNWUabFAUYWSANfmdgg1O7GE2C4wGDUgkf
	lO5UzKysZDfpm/OT64Ja03h+uo8eunH6tjLinQXISGtze6hGTl2+PLSRgrp/rwtu5qvQb5C9ZsK
	FAJYBB9OTh4noK8ojDZ42xZrJnblDpAYm3NvDGUXCNwCB1zHMrcRiKz0j4Sol4j+HjihecgZg+M
	Er+EJjtcRNG0n97pt3Aj3sRVmtAifOVuECMebt4VV3XERv2DrnbiDinLSENdwLI8RmL1j+/2RrO
	ejVwApYBSDwbad8VXPZc+wpx6uvsL/M7IqiEaMMquSZQ7PU+dO9ihAlM/LLHYtEMS49pg5QlCia
	/tX3oLh5HqdhuwVQRJQmFFynKFSHl+0GShbDLkAZQq4p7XdsKno6QdGSiy3F+MP/Al5tHR/+dFM
	r1BHkvaEYsaP9KtIIUCuQXMGEQuScaBeT/MNDh79S7deFzZUZe4yTN6kMffQmcd1xs6hLv8NheZ
	U9fe+o5ztOkqeNElZOeoDNxtMhOz50PiAugPMmdd2rDJAivWfC92KWV3HK81UGe5+t/24PbVg8a
	igEXJ12EvcUAMr0Zr6lJzraXLTc38pi3vOeJZXc0prMQbTYeOC3p5nZxPtJx0wF0Nlefjo/eu3A
	eBv4d2Ke2
X-Received: by 2002:a05:600c:c4a3:b0:4a1:6992:f861 with SMTP id 5b1f17b1804b1-4bb55a02932mr40317635e9.1.1794564726124;
        Fri, 13 Nov 2026 02:12:06 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e2842e6sm142085915e9.4.2026.11.13.02.12.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:12:05 -0800 (PST)
Message-ID: <82d691d2db7579d9630bf89f73132e36124bf74e.camel@amutable.com>
Subject: Re: [PATCH RFC 19/41] smack: use fc_init_pseudo() for smackfs
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
Date: Fri, 13 Nov 2026 11:12:03 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-19-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-19-4c998976c6c7@kernel.org>
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
> Initialize smackfs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. smackfs never holds executables or
> device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0security/smack/smackfs.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
> index a72bc7fabea9..4a56bbeaeca3 100644
> --- a/security/smack/smackfs.c
> +++ b/security/smack/smackfs.c
> @@ -25,6 +25,7 @@
> =C2=A0#include <linux/magic.h>
> =C2=A0#include <linux/mount.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include "smack.h"
> =C2=A0
> =C2=A0#define BEBITS	(sizeof(__be32) * 8)
> @@ -2880,6 +2881,7 @@ static const struct fs_context_operations
> smk_context_ops =3D {
> =C2=A0 */
> =C2=A0static int smk_init_fs_context(struct fs_context *fc)
> =C2=A0{
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &smk_context_ops;
> =C2=A0	return 0;
> =C2=A0}
