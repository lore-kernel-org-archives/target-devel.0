Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=209.85.208.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1794698411;
	b=rQtnhpKMSILWgsAgcTuQDyd1zZ7QVpT1AiZ6PHQKv/ZycplRdzxkE8txYmJT6X8k2mQl
	 UnpuZxa5e+Bn9kKa0sBAl8pRf7ImHwa2Hs+rcw2ycfiEqSoeNL6f8zED8RfPDuECPj9Rd
	 Dvmhdi+y1o5VqjNu36JBbdx956XqLyLkZM8Iye2MZHxxyf8hQ6Q8WTTFnk7Tw/dtnI3OZ
	 qnupFF0M86hwGTuxljm1pvSLKTR1AM4iIiXAiVFGdXzYDT69ZS835a4gqOO/Qjh3ihqA/
	 0hkQn5P2iMx/Px4y2/kePdKVyAWCnqnE1A0dHnqukiLRc2YlR2UhwJm8qVlaWWCE3Lg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794698411;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=98mXXJR5XCg4Z4S2yqrizowpYg4fQiN0pgPOU/BiUFY=;
	b=uBQMId3HB5co7sKh809EaryixAK96OE4hEn8yX5PNpez8zYQ5i3wKPVOefX/HOhI+L7E
	 Lq4gPBlFubpAqPKMMyX1CD2kEvU9un3TPXQzgmAd2dS/U9lFPvIdVnxckhyeiYvBakob3
	 e3ZX75O0O76tqFCvlZUJF5JN/DT1YXYtWtfmJmeagtDunAaUNim/ac/Cyzvqec97f5AG7
	 PPvCUPX9ZGLOxrFbl360O7ZhZNBFeMZ+LY+/IvIsZVGyNBTXSEtfCwvL9o6B1iykLg5iU
	 uluaEYUkEivbwm8aAoXexThC/qCPVjlVDRUICOzF0rDAWxoz6NaYLQJeQyr8aOiMyTQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bZ4A5V+6;
	arc=fail smtp.remote-ip=209.85.208.54
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB42606A334
	for <target-devel@vger.kernel.org>; Sat, 14 Nov 2026 23:20:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EBB42606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bZ4A5V+6
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6b70192ebceso4502091a12.0
        for <target-devel@vger.kernel.org>; Sat, 14 Nov 2026 15:20:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794698409; cv=none;
        d=google.com; s=arc-20260327;
        b=EgGGK8YpTv8t3nCvS2mw25WmURcSgFV5uZug01GJtCGb15Da6qZFTENVyt42Sck0iP
         96MYurr7t1nmkQHjhWJMEOC4pOWBtlSFtAmTRSE+MHvEgTs310HcouFbep9DLFr+ozj/
         clPNqnptBLv/dn49Rz7XP8C0VxnaMEOMr6uafxGBBGGxteIYJtHumTaKoLdahqyQaneI
         kd/5rLKpzXyEIkDtBfWGFxXg9iOmBpAOa2ber8MK5rFpGE3G2Fmomar37iyHJJjoY/gD
         SLkiuSybmO8f7dnFA2c9XVxSs6dJVRHKPXUx18yGc97fKtquONFy9PJHsyOCLgKITOZL
         JIZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=98mXXJR5XCg4Z4S2yqrizowpYg4fQiN0pgPOU/BiUFY=;
        fh=FNieAcvxKrfI8IjI4fNEDGLjQut5Qo7JpSfY307mSzw=;
        b=BC4AazCcEuXVP6+hqZzBz6FFUMZyX8MQj8RrxYN7/o8/4iSKWdbKuzZMIENqNpFVW8
         RwzsBceLPCmy0J3rKbHNyPqKkZzGjLqHN6VDcxI7yceeXfsRwOhAT9mJJ2OhAytkc4Dh
         pEqZpXEmjv8zzcpiyAv69RXbarogFAUju7vHLGEQ9I6Xi8QNaqceZRczeWb08vzc20da
         FkngUt66RQsUUTc4TERuHtjHKGKEJqnEahhCAMNj+lPZrwd2LlEr2ifILxqgoPWWfhwy
         cWGw13luupjpU+9pCqekft6ymKiQSbsxeDHz12yN8twyH8pgrO/cYiG954OjzD6pkqUk
         BaEQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794698409; x=1795303209; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=98mXXJR5XCg4Z4S2yqrizowpYg4fQiN0pgPOU/BiUFY=;
        b=bZ4A5V+6Vs4HKIPLNbCXlaoHg6GUiZAgPE1CoHup/u8F9XnmCFMSb6naMqQFAl++mw
         +LZR0jt78s/FhrwMU+95xN0Ho10rZ/g9p6M/dfGpr9SfvlaOXM2WfiTCtO0CejnyefhK
         5gg17lDjyCI6S+pTTK/DIWzHtcTY1JHkLI4t/I/Teu6/Lgz9A0oKfkx231Ay53Fdu4Kp
         zCo0ecwmPzO3ZOIddRCFMjOjLH94BU3oXsC8cOhJgJSeLFwZkZlFyxo1cq6JVw7hHb6A
         21NW8PziNlBat7d4DfM9UgO0YIScpglsDnmQoGQNIOQhlOx3hw76q6t8+8jTPfBn24eS
         FVGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794698409; x=1795303209;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=98mXXJR5XCg4Z4S2yqrizowpYg4fQiN0pgPOU/BiUFY=;
        b=M0j1P/slYBieGUy0z6gurTMd+LnbvhNoFPTkFxL3zEjsg2BssC9P+SehkVwftYkVa3
         Yu8DXjHK3ftvIYO0ZFFdtO/LOU1kp81hFVR/DghAktIdlNpkRegZmsLcKM/rdIEny0sD
         sSu28ANY1WEGe79+/zXFz1V2zo6pC3sHllEQAbw/p8wXTyHVYXtMvco0BNVIGsYDbYGK
         XlrlMY7HyR9N5fj7A59lBKdBo5cvcbXkzQyvPvCZ8k673MCzHH/fFEFLPA7R9TUk4pM7
         IxR9MeSEOVK3tAV0nx1M1Ol/OilJi6yAXQ+GgFxRf4sm+Scq/yoO/lyUwNDeYl2nvCnp
         S9BQ==
X-Forwarded-Encrypted: i=1; AL+hErHq3k5QtLhYaTro1glV9A2tK4C7CE08ZIM45pw1P3VWGR5o9q1VcjkSmiaF4SmWAwqWSk6tKA50j/IyZas=@vger.kernel.org
X-Gm-Message-State: APuU4Z/rEVRXrZaCTP38OPyrzIL094VoIiYpRRP5ec8cxW9LNkeW6xh9
	03hqSvUKcQutmgU63oviFk6Utij104kzrSRCaOpS8Fxnr0KCnacYgrArnRAOwyXhfMUc/AQgNnu
	d4Sc52TBIEBmCi8OVvZHAXLENLr7bziY=
X-Gm-Gg: AYBFou13HZKnVm1Ky9mQszsgC5fBv8SROqjlBZfcrmOCN9QQn3+veHtwE8dU5HcYlI9
	FChJrnyvznTONvcJmy1O30vzwFPLzmxiZi/bUeH8ANTVeDIKGGt02tl1EcKawZvDAXl7vZk6kl5
	sFi8be/YmaJQFQL18Z1jy3t0QUL+cHQH7NhYf5gmS3lyaFeZ+6e8u0qifsP5FQbY7COEX72kgmA
	BRKQKGMux5Czx2Ftv7up3x8seIeeYG3jdaWuQ3rl/IcqtUSYx8kEKtqrw7bdr/zprEDcaMU/nPZ
	HPhkGcf1TrTurIooC+C8kms2kWXaXVl/KbWSNIgk3wW7596dGU2RTJ9VZNOz5uoYji+Z9sE2NtW
	kgGr8bSk2+byRmKke2Q1trXnlFQVoad+uHwCR+HTIytUBTRQ9pFW5kf0qA+GvImg3aLCtpA==
X-Received: by 2002:a05:6402:e10:b0:6b7:f00e:5e56 with SMTP id
 4fb4d7f45d1cf-6b7f00e5f37mr1542816a12.1.1794698409123; Sat, 14 Nov 2026
 15:20:09 -0800 (PST)
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Post: <mailto:target-devel@vger.kernel.org>
List-Help: <mailto:target-devel+help@vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:target-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
 <20261114-work-loop-pseudo-v2-33-98639a2286fb@kernel.org> <20261114120557.4bc1eb6e57218cdc@chrisdown.name>
In-Reply-To: <20261114120557.4bc1eb6e57218cdc@chrisdown.name>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 15 Nov 2026 00:19:57 +0100
X-Gm-Features: AclHuK_YVxhIpv6JLzeNAX5mX5IHGfu05WS6uQ-TCKewxE3JKeci2PyA-UDMCbo
Message-ID: <CAOQ4uxhGxpBtMZ5kfuzR1tQAewiecoX7UjXQRo91QjJHH9T_Yw@mail.gmail.com>
Subject: Re: [PATCH RFC v2 33/42] fs: add file_check_backing()
To: Chris Down <chris@chrisdown.name>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
	Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, netdev@vger.kernel.org, 
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org, 
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev, 
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-usb@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 14, 2026 at 9:06=E2=80=AFPM Chris Down <chris@chrisdown.name> w=
rote:
>
> Hi Christian,
>
> Christian Brauner writes:
> >+      /* Look through stacking filesystems at the inode with the data. =
*/
> >+      if (d_real_inode(file->f_path.dentry)->i_sb->s_iflags & SB_I_PSEU=
DO)
> >+              return -EINVAL;
>
> This looks good in general, but what the bots said about O_PATH files
> here is real. With FMODE_PATH this is reached for a file that was never
> opened, so on overlayfs nothing has been through ovl_open() to look up
> the lowerdata of a metacopy file yet. ovl_d_real() then does the lookup
> itself, and when that fails it hits the WARN(1) at its end and returns
> the overlayfs dentry, so the check passes as well.
>
> Only fuse passes FMODE_PATH, so it takes CAP_SYS_ADMIN to get there, but
> it's easy to trigger with that. From a quick test with a metacopy file
> whose redirect into a data-only layer points at nothing, registering an
> O_PATH fd of it with FUSE_DEV_IOC_BACKING_OPEN gives
>
>      ovl_d_real(/f, 0): real dentry not found
>      WARNING: fs/overlayfs/super.c:79 at ovl_d_real+0xc9/0x210
>      [...]
>       file_check_backing+0x308/0x5e0
>       fuse_backing_new+0x219/0x4a0
>       fuse_backing_open+0xe8/0x390
>       fuse_dev_ioctl+0x53a/0x7d0
>
> and the ioctl still succeeds. A normal open of that file fails with
> ENOENT, so nothing could have used it as a backing file anyway, but with
> panic_on_warn this is now a panic.
>
> Maybe ovl_d_real() should just stop warning when the lookup fails, now
> that it has a caller that isn't trace_uprobe?

Yeh I guess that this needs to be a Fixes for lazy data lookup.

The correct fix would be to teach all the callers to deal with an error.

> The check would still pass
> for an O_PATH file whose lowerdata couldn't be looked up at that point,
> though.

One observation relevant to this patch set is that a datadir layer has no
business being a pseudo fs and that can and should be blocked explicitly
at overlayfs mount time.

The other observation is that fuse_passthrough_open() should probably
check the backing_file that was opened for io in addition to checking
in fuse_backing_open(), which could have different FMODE and specifically
could be FMODE_PATH.

Thanks,
Amir.
