Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564919;
	b=WIMd5FZLWZSupLkiGwKmQ+XhAaUgn+rSJkCbuPyt6fiA04ttOWbNAe30iwXRb8HYq4qx
	 HnTplrvN2QB10e9k07Ju9iNuHjQn+DXHRh20Wh/nKKRxqHJRk3TAfrSW5V8908/8mtk6k
	 9ZikIY7YV/m2/Tz4CK7M+BqfDZpHIS5dsppQSSD+g17g6Hq+3GJoPk9BKw6a+yUHY+Pe9
	 DMvQMwtq0C0UrOe35u/LTo783aD6EliYdANVxg7OA3GuO0T04yZl8IrR0syY8vczsvOce
	 9rNJphdMnTxwIcOg2LJF7rMfSrlAg6LrtXRguNEgneFRV7YEeLM8ejyO55BFjW4or6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564919;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=QtOsdPCKGJ1fBhMqXd/zLQfd50NEx4L7veNiE/G2OUE=;
	b=4jcIE7bz9Fe3k2Zhs2hgpSaANea2qSNfhQmylZ+Gv901ADZ1raJ6DtKH4WQ/Coid4Bb2
	 VsxsWNkbFHMuVpy40uh7QB7uFpvFWA5VMvL/PMuNLdzcf+uL1DFOi497la3EDth0ztsN5
	 0X2sa8oaI22l9EA7D1sMPszWYCeWIpCTtbp+gEx9UFNrh+Eu3GOzVCtq3Ii8lACBCnKce
	 HAfWOP/it65lUgfKc08iD7YNgTBYqe+kg5s8tvtCzohjYg3eNRe2aBQJ21mWBl/Zjkkgq
	 +Cwnxa+1KfgbSGOxL6YsXw8hNCadf3SVnXKZHlWKTYOiOwvPeJigUuOJkjTMCjpkVNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=XokUN4uh;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE650606B13D
	for <target-devel@vger.kernel.org>; Fri, 13 Nov 2026 10:15:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AE650606B13D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=XokUN4uh
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a5036bbac7so3785135e9.3
        for <target-devel@vger.kernel.org>; Fri, 13 Nov 2026 02:15:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564917; x=1795169717; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=QtOsdPCKGJ1fBhMqXd/zLQfd50NEx4L7veNiE/G2OUE=;
        b=XokUN4uhZ5cnIDNPS9kLjfaPp8ZSmyDY7nHz3ffF9uftFGQzzc0NaUd0CPxl6tmm/G
         EB2bqVZrrrQULKzHfxmMlarOF7+NP4G1EuGLp1x7hwkFzcf5DKQIlYH5+zTWTg0qLXK8
         Q27+pu7matN83z4kFimCCYFY9EtcVBpSYh+f+WbPWczzC82gi2dU1+IxENiNgIvD4ssI
         1POQJndyP8zOY9I/drEtHc8Rir/wcokVwFCL8xkdsULqRcKqvw/m2pftg5e6OYSufYMA
         FPm06vn59Z5lYx4UA2FpKr0UjB0BBdejlJLIE+RKFWt9/d0/clXrD3SuYpmwDbHdW+74
         JQJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564917; x=1795169717;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QtOsdPCKGJ1fBhMqXd/zLQfd50NEx4L7veNiE/G2OUE=;
        b=i669Tw+NsZ+21rLxXJz98hyn4vSGjcR4HqfWoLkjWxxbRUDQ7cD4YRojzbcKkjZljA
         MQm/GXNI7ajdsPomFq9kYsRCruPvvc83KpNmmQmThqp+7OciysXK4tNOxSU+UT69ltdv
         J6w7CkDOjsyH1L1lh0Ik1kbAKpM3YCrHG8rA1SNVzYVhocqNiEFJoSsdbhlqdK1qmACP
         5GAfsExWU3eFo5J8TYZYGRZDHYkdHMfDqWyW/08zGN680+8uh8Vrnmc6jzSA7psmkPeE
         j4OmHpPfeBdkIcZgfO/KSwz2kWQ0pSB1+9bTLtkEt/GOxXu43EsuywsEtyMTlZjWR2q2
         MyqQ==
X-Forwarded-Encrypted: i=1; AL+hErGBEe0SihOUa/Fme2mbf2h4gXCxCkNMzsxl1cxZuhIfxOscdOoypDxIy4L+QYP/x7rsTnDPV1snEpNhhP0=@vger.kernel.org
X-Gm-Message-State: APuU4Z+1veZuVVJSRdfGZhncs1k+Euig5e6LD7FRujUqmmn0U0vgU4xH
	nSa4InDCAT5PGsPnJ6fpxVWt0nzjxuoYuOk01XkqsWkThn3StZsl52GZean7tL6VqY++
X-Gm-Gg: AYBFou37M9XhRit+hJpyZnf6a7IdfsBT/ulDpd8FxNZQ6hvm8LEYF65maZLdh6GaGD6
	duC14FjrusjV4sq8AI64BbjfMCxDruUWvPGcUUAWzc+eKZ7Gi54kceN9TNhdAhb1LDBCNjFv1cu
	AqQUWe5Q8jgebErZm5GLWnEprulVxUEZIoWAN6PpSgNaKuCG65RAVTdk3OpseBRG3wLf7O7Freo
	5bCEUiY2m0+n9z5DWCulxNcBbgTAEHWgpPBUZhmetvhS0vZdi9zPAsDqphP899oWeLTGw1k727w
	/PTHuen66AtoZ0DOtShdN6NwjQRNe/RGhTuGGxiHhO8pS7KGVACvgbFUn1XdNKTpWwmFOO7+CGI
	y/0Kf2fxFImS/xQ95bs5zMPgAilXq06MEn8EuSAE+zgKs5C0eJ4MsghdzsaaT5adKpUxpqCE2tx
	gYXjV2lVzbazNKCN7eNdKd4oWPRI2ITHBxvw8U5b+hTyK7dwzWeh7Emtakk5P7QMo3FNpMWgAxd
	yxDn4MaUh8VPrE0JQMSJ1mAbhJ2BnwRQg2EJ6W4pNgHsBr+3ne+RgPunR1J38DXi68te2e2s86D
	kll2OJOXe99SdtKNTnJHu3RvNrt1OMZCclJ45SQ3X8fz1kCVMJhI5ioLR1axlRY=
X-Received: by 2002:a05:600c:4f84:b0:4a7:7f3f:6f8e with SMTP id 5b1f17b1804b1-4bb5599ade1mr43492835e9.0.1794564916955;
        Fri, 13 Nov 2026 02:15:16 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb56680ea9sm31982365e9.0.2026.11.13.02.15.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:15:16 -0800 (PST)
Message-ID: <e2edfa06d185acd86b46945622b6eb6dff97b307.camel@amutable.com>
Subject: Re: [PATCH RFC 33/41] fs: add file_is_pseudo()
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
Date: Fri, 13 Nov 2026 11:15:14 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-33-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-33-4c998976c6c7@kernel.org>
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
> Add a helper to check whether a file is a regular file on a pseudo
> filesystem. Only regular files count. Device nodes on pseudo
> filesystems
> such as devpts, binderfs or the block devices on bdevfs are what they
> are.
>=20
> Look at the inode that actually provides the data via d_real_inode().
> overlayfs accepts sysfs, cgroup2, debugfs, tracefs, configfs and
> securityfs as lower layers and reads of such an overlayfs file are
> served by the file on the pseudo filesystem. Checking the overlayfs
> inode would miss that.
>=20
> No functional changes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0include/linux/fs.h | 12 ++++++++++++
> =C2=A01 file changed, 12 insertions(+)
>=20
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 99caef43ff3c..407ffb6342ec 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2553,6 +2553,18 @@ static inline const struct inode
> *file_user_inode(const struct file *f)
> =C2=A0	return file_inode(f);
> =C2=A0}
> =C2=A0
> +/*
> + * Regular files on pseudo filesystems are kernel interfaces and
> must not be
> + * used as storage. Look through stacking filesystems at the inode
> that
> + * provides the data.
> + */
> +static inline bool file_is_pseudo(const struct file *file)
> +{
> +	const struct inode *inode =3D d_real_inode(file-
> >f_path.dentry);
> +
> +	return S_ISREG(inode->i_mode) && (inode->i_sb->s_iflags &
> SB_I_PSEUDO);
> +}
> +
> =C2=A0static inline struct file *file_clone_open(struct file *file)
> =C2=A0{
> =C2=A0	return dentry_open(&file->f_path, file->f_flags, file-
> >f_cred);
