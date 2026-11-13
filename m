Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564223;
	b=Si+9S62FIwbBHzysxE6ng+RwjOp58mSBOpZVON0rmp7iAr2BNJ4O1nUbm/KsR1a2vAho
	 jtEvrlr8lDbdrSGdZQjGd+aYVIjRUR7enepR8MAnEeKkIFguoPjtiqxh4OMnhMHLVPMIw
	 7O4fQLM/aQbrY/OdUI2pzR8zr+pXCp1Msx78fGaK9GlChge4G2S3qGhEGlHn3gn0cKCUS
	 0Aij4ifLNLTPmVXpE+YJTn6kPLHTD5idmh5Cy/lKRaHLktH19NhZYlhRu3vduaJUTc72w
	 R8hmkvyblDGDTYL/cP3qG1mIqebqUPjx63ABAwXJ6mFqRqfpJkoALw/BBbJ7bRRD4NQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564223;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=6cN8hpP/bnwcYzPsZf0cUkd2pk5Vve+UdRh8Jmnig90=;
	b=v31CUhZO26KnzG2OLW5t81daTXaASGdpxjLtkU3qouhFszdkVeBzBcn2A3QycMCjo8zD
	 sq5LnsD8OL2RRqa2nA6ZZ/xukrFFN1R++Mq4lxZBoVkXEq2Ay46n8P7rB5WQVJ+m8cbce
	 5J6N7kVZhv2IjrK14e4q9T2M6f0KYeRw8+Mv16zcUaXjIYdOH9JaBIB22oYpHUaQ3JjSA
	 me4DALm/ire0PXuSE/wz9vJ6fD0Lan2Hnh0ruw8eqOJ60fyCTjtg5Us7Qhcs0guQnBrcO
	 zTZ6YwSUZhq+61ybch4tC1Z3p4iTW1KWkhqen92J7PdLDozs2klmh/K2OmWuYfuNxWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b="YppAuU/f";
	arc=none smtp.remote-ip=209.85.218.51
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE6260A2628
	for <target-devel@vger.kernel.org>; Fri, 13 Nov 2026 10:03:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BBE6260A2628
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=YppAuU/f
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c169ae1cb26so172963066b.1
        for <target-devel@vger.kernel.org>; Fri, 13 Nov 2026 02:03:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564221; x=1795169021; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=6cN8hpP/bnwcYzPsZf0cUkd2pk5Vve+UdRh8Jmnig90=;
        b=YppAuU/f77eWMTZ8F/Y/RTjltBDd6igz4EttMolmckndL9mvAt3euwqVCnUFPcnj1L
         wpVFClVgg0YlcE6bTABHQT1NnQyujG09t70SZ+IGoHQq0qQgGGwB+4JQikI2kaQwvi8W
         H3KupRONVF9kXu90kRN/xwbfNoANJajav9pnhnb3IMIJ4A6DWEq+8017kOKRrUT+YN/m
         jRUDmGHXRq1c+43Y1O2K5XEGEQl+nQ8YkAZ+/5vrEItOhIamTuHGEOkZUAeGsE8baOwB
         Dj4haSBpRwT/bMXANPqkevI0ogqYaGkZDRE/CPrkXlmZ9T16K5sayD5Snik8DtXgYcT5
         haBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564221; x=1795169021;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6cN8hpP/bnwcYzPsZf0cUkd2pk5Vve+UdRh8Jmnig90=;
        b=yC1DuMnVZu/libRz7FzvIo3+WJFI9HQR66UlW9KgVY7c10zOw0/hrVa/wMXgCjWkFf
         OvMZQBumCERe1DeoQf4xKkHoynfS3Xt10ys4o/hCDhBSZVXTF89JGxC3i0M0y9iVSQJE
         juINTIKUMLshPDCWQUuM6QcaKEHMR5UT45McbQNnsLmGabL00bspwg/yG6EaET3P5bzz
         MebJLiaS/ZIXzTjX8RbKJQMm91t6s3jqN3+MdoadzlfN0CxIAwlRVOmeRzRl++B1KhjZ
         x2W5vs071eF77w/EDDpSu+4bacLq4gO12DHKUNdh4ePoitKCp4ezeHC6HO6nGfwwzFoy
         /S9Q==
X-Forwarded-Encrypted: i=1; AL+hErEZWQcCqZrtrhDcK3tQyRZSiZ9ffnXhwT2cfa4PlfWfZFDCqYdLso79UaoTnjII29MxvLoXBym637ZiTKY=@vger.kernel.org
X-Gm-Message-State: APuU4Z82J7xVvx9rh4tsSxG4GsR2sSTVYuc8IAUZ8ZyfHMZ99kdF6+Ix
	5ddhWHnUf8Soez3kep0eULo6IVz8U0TMaUWcKDPhWX1ZYmMY1TT1RdhxXV3ncpyxnsod
X-Gm-Gg: AYBFou0JkzXIe9zcjXHWSmbtLwBS/0yWqE8SBopaffaFI725/eH11WoUvg25knFPOOE
	IoT9RVtM2wlWmE85fF5BImypOqKN8oyTjROjWGXM4ZKctMlT+ReLD3pQ1Xxrebd9/X5SLuDSjat
	n+XUUIegHwRR6wXNAVRU2hXaD5tCtrU8LlZ4b7HT0Wo4ymB6i9FN+NqiKczxf0X0vyMCcfB8c1/
	BBIjUVGp9iji9debftEuze0QTvUgUOezTaz19PpeC1/syeaVtdVHJYlInzUtpX9xJWmHgcr+NXk
	v9gZRPLOaMovEA6tXvoOE0S2LqpxYWaAWt1l7mSFkdeqqvbhCydsCawhBD6XfnHl68BZxvv2wex
	zmlF42gAKgUKjTBojSNkFMgJByFNkMFBD1KJAs/aefc+SLojLqQQu8/2RpvjYzgNw4VTWKw4o//
	zZS5mUb4c4QeItE43FYlFq5o01C2QSzwJSgjzuQS/ELMSJpI5TbucYgHcNHW/xCoUcd2E9crq0O
	kwxVJv6Qg6iusnXt1m3Jmeh7qAxALMlUwknsgNV08Ln+ma/CSdIqd9ktd1A0iA3TIUfXUKCMRoT
	/TgVw5/XCC0XpXOewf+dhhYJQn5ScIRnwWGHVkWxfRBfoep6tY3nRqEVPOFOEvs=
X-Received: by 2002:a17:907:7b8c:b0:c42:bc58:f21 with SMTP id a640c23a62f3a-c50963856f2mr175546966b.15.1794564221164;
        Fri, 13 Nov 2026 02:03:41 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b23b3asm74752966b.27.2026.11.13.02.03.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:03:40 -0800 (PST)
Message-ID: <cfcbef5caf7651b63774549fa1999d34981c78a4.camel@amutable.com>
Subject: Re: [PATCH RFC 09/41] bpf: use fc_init_pseudo() for bpffs
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
Date: Fri, 13 Nov 2026 11:03:39 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-9-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-9-4c998976c6c7@kernel.org>
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
> Initialize bpffs as a pseudo filesystem instead of raising
> SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0kernel/bpf/inode.c | 4 ++--
> =C2=A01 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
> index c6f328e4752e..57cf3775c076 100644
> --- a/kernel/bpf/inode.c
> +++ b/kernel/bpf/inode.c
> @@ -15,6 +15,7 @@
> =C2=A0#include <linux/namei.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/fs_parser.h>
> =C2=A0#include <linux/kdev_t.h>
> =C2=A0#include <linux/filter.h>
> @@ -1197,8 +1198,6 @@ static int bpf_fill_super(struct super_block
> *sb, struct fs_context *fc)
> =C2=A0	sb->s_magic =3D BPF_FS_MAGIC;
> =C2=A0	sb->s_op =3D &bpf_super_ops;
> =C2=A0	sb->s_xattr =3D bpf_fs_xattr_handlers;
> -	sb->s_iflags |=3D SB_I_NOEXEC;
> -	sb->s_iflags |=3D SB_I_NODEV;
> =C2=A0	sb->s_time_gran =3D 1;
> =C2=A0
> =C2=A0	inode =3D bpf_get_inode(sb, NULL, S_IFDIR | 0777);
> @@ -1261,6 +1260,7 @@ static int bpf_init_fs_context(struct
> fs_context *fc)
> =C2=A0	opts->delegate_attachs =3D 0;
> =C2=A0
> =C2=A0	fc->s_fs_info =3D opts;
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &bpf_context_ops;
> =C2=A0	return 0;
> =C2=A0}
