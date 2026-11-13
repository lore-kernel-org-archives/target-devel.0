Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564140;
	b=atjnKSQpHGSixkVVFimt3a9BHzetOG3XsQhMuiSoL9zvrwHXq9cgRLlqlRqnTm++tXtd
	 5mHnE8pkL1du3wkY4h9nqjqtm5h2sBdHS3oLC6hJNVTjSlP6rGT9FibYoZqiSbRIuc0AW
	 yPWW9baTsfvsP0pu42x5PbdptdHQv3llk3lQkeJyppWs9AOO0dJpq1VNm1t9pFTR8dJTC
	 Twvs3qjzVJ8EWy3Lmi3mB1g0omAZCIprApvTUsTpa8vjC3aRfTDgs+JvW55q/1JD3Nuoz
	 kAZyCKGbp15Sf50sRhFAb1RKLwY/QcpU6YQSVywtgOFDkp1YAjCOFSMJkFxel5O+H3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564140;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=Ee4ggwaa7pvqsvjnONVsvhhjx7Blw4b1QTFG8P7u7TE=;
	b=hsuasmrR1jQ6jXX8sQXm1AoXE1ejibBbV3jDgFD8U1sSpfsIH0CiTfk9flkfAJncu4uS
	 K+RZin0gh2fALeuJM7KKkCjNhKcy653Lzf+3EtorU6/wnctPH3mBMljdbiUr/fU4t/VjE
	 NU2cbLEzKOuFz5Akj0/CB0vJshuiiJMs3Ae3boCVowl5Gnx5jywcUvNtTVcHBYSOVaFka
	 J/bun2zmuqpX6yOcsZg03lxM9UfGNnrHlmwKgDHRqnvgOJcQDqyJnUkjZtVC7GXhwVejF
	 4gUnY0AjEakny6lqXMz+1zA2gI+J8xCQs75RdDuxvkraUiNjaWSPbgh+kLCR/BvSqWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=mxnEK0OE;
	arc=none smtp.remote-ip=209.85.208.53
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B6F606A337
	for <target-devel@vger.kernel.org>; Fri, 13 Nov 2026 10:02:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F3B6F606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=mxnEK0OE
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6b7bffb5b8fso1233860a12.3
        for <target-devel@vger.kernel.org>; Fri, 13 Nov 2026 02:02:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564138; x=1795168938; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Ee4ggwaa7pvqsvjnONVsvhhjx7Blw4b1QTFG8P7u7TE=;
        b=mxnEK0OEI7AZoc/CfUYBfL7b57vnPAty4yH1m7TS29a3jfzgxF6O21C+4eoAVH56Q9
         piX6TGhock7wjcI74HawyxxvBGzm9YxMDwhPO59HW6wNIzGY38ltasaZh4hFELwGRqEv
         EACaW/+rYd6+QPU5/79gIyHIHlnigPDAQAFlfCT0ngxFbKNdFkIgPJ4AQQVbJxYRU4kd
         sGda4OaUFoBKprw0qaI3K+cYJzK6vhQ24s+osuqJwxviEyFLXhcz7lQ/DUhHhDlN7iYr
         P/EQDWGz9doNbLrGEB0hB+YKjuFHlmGHIGpXLhiZ/HiYA8bpaS50WmEcn/ZjJ0UCEMyu
         vVpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564138; x=1795168938;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ee4ggwaa7pvqsvjnONVsvhhjx7Blw4b1QTFG8P7u7TE=;
        b=xUt1tDUej8gSa1/vnMmjGUlVEh0oNksrZkSnKJEoEWX5RWssR6JI5q/aqjvjdRDFEK
         X3YsT8/PhuwzRBl5CPxZdHPj03YIEvZCdwHhwN02CjkVce8ODTfOdsz/TuS9UXRRddVc
         BV72iWbdUrUbntJgYrYCX0G/lKFqAEzHGtwr+/hDalPEL93TCXhSGTP15+UiYHBKIzrB
         JT6X0WU5ZlNKZa7+/kyuzc1iH/NdsFmLDayJ4xjWDMOlWt2R1F3QQ9kq6KPnPrR9+5Qu
         55SXoffqQ4E+fdj7XFh8V9nwnFLOS7q4DnAJ+YDe0sdifjYk0aXqW4anzaSNuTlZ1V1C
         syAQ==
X-Forwarded-Encrypted: i=1; AL+hErGoH1sFOLrPfhASe9QRg7Mp+4ye3gduwV9kQxX1GNBwCnxUCKO60j3A1OHW6J3TAub3snxwD7pfX7O1leo=@vger.kernel.org
X-Gm-Message-State: APuU4Z/FQP/6G1o6CFDDt0Hrm20ImlAj0vO99G1gka8YKLQI7qSkOCox
	o82UUyBIVGgFh7ejAAOqpVHHyml8Le/vtoaTcJatthDE6sRncneCrxF2Va5J/w4LXLgL
X-Gm-Gg: AYBFou1B3VSWccaYEF1cdvT9OHTYY28+tw8sNLZz/d9qlygclUsjh8tWuIcBPxBqWpv
	toXsYxHaUCc7cgFew9+N8Hw0v0856SWqL+4qreNzGQtvgNYiwL0Vib8nOjWmLeDVDsAkVGUBcD1
	pL6rGoRyvO7jKMITsf9t7z6xdK2nwpDnaEMlcIOPZiHtn7Yx2Ykmjr33bBeJp4y54Nm97StC0HG
	OVCjB6uU09GfqGUl1oGUzp0EAcPRbnzTz51P6qHP4cobtW/D8QcLOqZonZXO7ZuR+lxMRhwAJZ7
	Byfqg+YYiYEeUDxhtZFC2z7+OtK+OG5PEA+OgpJMwIg6JmtptVU3PAM1ZBUW8NmnQiaF3mlE3R8
	NBZ/Ye8hIxuCm4iU44kPM9Bio+H0CBYA8Q7oNXc8X3iUjtPjrM6DuBmSrWZI2f3CevqEZBpKi5Q
	6wzTPPEHfRYoVRhabws4wqNORLfG+RdynlDLvqWIw4kdRYmzVZ6nyuTmcjRwdy0b6NuJyZMEx3X
	SimWO2R92qB7j/Rs5OAExbPHLkbpb+O0lCTClgEd+lhZ6bamT49XrEWSSyBEwbVwciBWxW/ukEZ
	XX9DQ0eyA0CUMETTChTlzXWtGltw4kilpbp+fWGMzWY8r9/8x6FgHkbSS0UukxE=
X-Received: by 2002:a05:6402:c4e1:10b0:6b6:eefc:ae7a with SMTP id 4fb4d7f45d1cf-6b7c088f8ecmr1236733a12.4.1794564138223;
        Fri, 13 Nov 2026 02:02:18 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b7c23c672asm734155a12.15.2026.11.13.02.02.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:02:17 -0800 (PST)
Message-ID: <f4ce8239f22046e90cf4807853282a570c73707a.camel@amutable.com>
Subject: Re: [PATCH RFC 04/41] fs: add SB_I_PSEUDO
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
Date: Fri, 13 Nov 2026 11:02:15 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-4-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-4-4c998976c6c7@kernel.org>
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
> Currently, there's no way to tell whether the files of a filesystem
> store data or whether they are kernel interfaces. Files on pseudo
> filesystems such as procfs or sysfs generate their contents when
> they're
> read and writes to them are commands to the kernel.
>=20
> But a few places in the kernel take an arbitrary file and use it as
> storage: loop, zloop, the nvme target's file backend, the scsi
> target's
> fileio backend, fuse passthrough, the usb mass storage gadget and
> erofs
> file-backed mounts. At most they check the file type and whether the
> file implements ->read_iter() and ->write_iter(). That's not enough.
> kernfs provides both for every sysfs attribute for example.
>=20
> Add SB_I_PSEUDO so a filesystem can state that its regular files are
> kernel interfaces and must not be used as storage.
>=20
> Pseudo filesystems also never hold executables or device nodes. But
> currently each of them decides on its own whether to raise
> SB_I_NOEXEC
> and SB_I_NODEV. Some do, most don't. Add fc_init_pseudo() as the
> common
> initialization point for all pseudo filesystems that raises all three
> flags and switch init_pseudo() over to it. The following patches
> convert the mountable pseudo filesystems.
>=20
> Nothing checks SB_I_PSEUDO yet so no functional changes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/libfs.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 2 +=
-
> =C2=A0include/linux/fs/super_types.h |=C2=A0 1 +
> =C2=A0include/linux/pseudo_fs.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 11 ++++++=
+++++
> =C2=A03 files changed, 13 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/libfs.c b/fs/libfs.c
> index 96a6e9b1535f..8c8789489fdf 100644
> --- a/fs/libfs.c
> +++ b/fs/libfs.c
> @@ -735,7 +735,7 @@ struct pseudo_fs_context *init_pseudo(struct
> fs_context *fc,
> =C2=A0		fc->fs_private =3D ctx;
> =C2=A0		fc->ops =3D &pseudo_fs_context_ops;
> =C2=A0		fc->sb_flags |=3D SB_NOUSER;
> -		fc->s_iflags |=3D SB_I_NOEXEC | SB_I_NODEV;
> +		fc_init_pseudo(fc);
> =C2=A0		fc->global =3D true;
> =C2=A0	}
> =C2=A0	return ctx;
> diff --git a/include/linux/fs/super_types.h
> b/include/linux/fs/super_types.h
> index 72f4288e16c5..472200bdf081 100644
> --- a/include/linux/fs/super_types.h
> +++ b/include/linux/fs/super_types.h
> @@ -359,5 +359,6 @@ struct super_block {
> =C2=A0#define SB_I_NOIDMAP	0x00002000	/* No idmapped mounts on
> this superblock */
> =C2=A0#define SB_I_ALLOW_HSM	0x00004000	/* Allow HSM events on this
> superblock */
> =C2=A0#define SB_I_NO_DATA_INTEGRITY	0x00008000 /* fs cannot guarantee
> data persistence on sync */
> +#define SB_I_PSEUDO	0x00010000	/* regular files are kernel
> interfaces, not storage */
> =C2=A0
> =C2=A0#endif /* _LINUX_FS_SUPER_TYPES_H */
> diff --git a/include/linux/pseudo_fs.h b/include/linux/pseudo_fs.h
> index a651e60d9410..0ca408aa60af 100644
> --- a/include/linux/pseudo_fs.h
> +++ b/include/linux/pseudo_fs.h
> @@ -2,6 +2,7 @@
> =C2=A0#define __LINUX_PSEUDO_FS__
> =C2=A0
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/fs/super_types.h>
> =C2=A0
> =C2=A0struct pseudo_fs_context {
> =C2=A0	const struct super_operations *ops;
> @@ -15,4 +16,14 @@ struct pseudo_fs_context {
> =C2=A0struct pseudo_fs_context *init_pseudo(struct fs_context *fc,
> =C2=A0				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long magic);
> =C2=A0
> +/*
> + * Common initialization for all pseudo filesystems, mountable or
> not. Their
> + * regular files are kernel interfaces. They don't store data and
> pseudo
> + * filesystems never hold executables or device nodes.
> + */
> +static inline void fc_init_pseudo(struct fs_context *fc)
> +{
> +	fc->s_iflags |=3D SB_I_PSEUDO | SB_I_NOEXEC | SB_I_NODEV;
> +}
> +
> =C2=A0#endif
