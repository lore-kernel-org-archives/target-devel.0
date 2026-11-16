Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794850650;
	b=W4Fz1eduExol2K7QUS+YMkYeeVg9yM6muVjvIU4b99wb4Dfmb9DEeLl65nKORHypoTB1
	 h4QkwlINA7ux5PfdL9Jqtf4SpCQEr8z1XFlXS2mO+Lx1cZeFrWR+oxMSibTszmJomI/bT
	 bC7SRtWhVuEajnXkIkFavtuoJiqRT6QG2Nq6h9L/C0hc/MPOhzwR8PcyGL+kjoE1rgKMg
	 5vxcMo/qitsMlbkhtMvtRZ3F+gSSnPKJQT1aTl1XfKizu3rdt95UZ5M8b6Wscaydm+LTb
	 3y5Wo28Qx6IYO1InqSNzlME//p7i7cJs/b9JjkqX5avc/wMZ1zYMpwIF3bKqr2XeGgA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794850650;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=ASqD7yYrxwRTXpvky24aSldHzEJHTNv4OUWKJ01NHN8=;
	b=YLShEh4a0+BZ6nwEagxtY/57qyjPtw+oVQM2Jqroc70AZsy2TxZ9C12jNhQ0h5iJINpn
	 GUTimeUmAQIRacRLhU9V8it+g/ulwToMsure3jjJPg6tSCo1FXka8sDSBdJ02I7hE2S8e
	 Cba3vtR7slYV8mkChV4p7WHS6npVGnwy7sphiTX6rOkaRQQucc5UsHG6U+YmA2InFJVyf
	 itl33ordi+qHV2cTjmdB+iH36Kl7dAsObr0YPrgo900XouVcJztLfdORn47TJokmQkkRC
	 /7rOjOMlif8mqRg5NriB3PfnIgpOiVGBCsOgORl2A+VSNj93L+udolWCFG7ejGSTwnQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Wda5m4T+;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.49
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5068E606A890
	for <target-devel@vger.kernel.org>; Mon, 16 Nov 2026 17:37:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5068E606A890
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Wda5m4T+
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6b7245ab5e2so105384a12.1
        for <target-devel@vger.kernel.org>; Mon, 16 Nov 2026 09:37:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794850648; cv=none;
        d=google.com; s=arc-20260327;
        b=mJF7FduPd37GuaqBUBMQzjXNu69UOcw5b2JkMPYrrSbfo0Qih85kcZgEsYV0KQSqMo
         H6tppu9gjHP+BWjNrhIqGjFx5iYMqZK9oMHEIJqhGytkkojZHN0zcRqNjBtSOBs9FQa3
         sb0schAnrflfpggtGpxXA+iQBJNyxTvN0B1W43VMM6uqPwHsXa5DpuzWtIJYqpnqoPla
         Z3t9ry3hqqbp/Lj5uuJvs0auU929U9jFvrZgVT75j4fo91+1oPgKLQrrO9avItg6igF6
         XncW6H/CbWKMNGiFDvnbtxwLOv87oTkRRsxBAdtxRzjCuOCC14zvh0L3cS4WDCFbo/ZY
         66bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ASqD7yYrxwRTXpvky24aSldHzEJHTNv4OUWKJ01NHN8=;
        fh=QmXa+ffUYKPWxpF+knDlXEjaxrdh43B7JmV8WcaxCyI=;
        b=LUWa0DPAYvTlN5bArgHOMOUzJf4yHKBtQo2iC6BrZSv2yX4idQuW4bRuE5hCNqW6Wf
         vEG0jXmdH7mZCKkUalLYHlrqAv6eTP1A+LJHxLB4wmD7L12D4QWl0Zrw524fVA+sR4a3
         wVhrlv8N1rLHmNMvKDypdSYYJIAejyeLPqIwLWH4GoZR9zNeeSBans9jn16y6vABSDBk
         yMmoUFBjAlss6bzhqxTMxdxaCfEFHl5Au7sVEYGZW4ortLgvGrB2Wy7pX9ZlTCjJWSdo
         subeV5TYeebOsQhjS3oSSTQZW00WN/ny5onpzDa7hYKvg2aIlG3SLJ5dxf42yvemIKP7
         fQ7g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794850648; x=1795455448; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ASqD7yYrxwRTXpvky24aSldHzEJHTNv4OUWKJ01NHN8=;
        b=Wda5m4T+Og74YNLartpajMnAcctT7hnb5haqi9hjLlBRa67TYcEPjf80gw45qsgIx7
         FMobW/aC2ZXQsUmoaLilVLeaESS9ODytholTX6ZkGdI39Z50BqAMQuVm0upEGdU/eTIl
         KzXBiwaEJY7eqa6p49n+ZePGE0YUDeVtz78JPQJb7w7ae3zRsyAfYOAEtJq8eS6befDe
         ANfoXo4rOnrr9cTK5CEQbvEa19yD1CMimOfBL7pxwr0U+pGpN6RB970vgsC2xV+kB6BG
         DqloDFELm5xz1LM2zdKvbUwHIwogDmvmrNVDo81Was00uh+K9TR8cjrFQWZvFUjBWrt9
         3Csg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794850648; x=1795455448;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ASqD7yYrxwRTXpvky24aSldHzEJHTNv4OUWKJ01NHN8=;
        b=woM4nPOVaNVz7xa7OsNVP9uMcKPNCHgPGeA3Xx/4eQ5wlLkq32erLvsmLd+8Xp2SL8
         dK0HyrwdYfSZuo2ypFHIS7rzyQzvdQZk5iZacLpZQMsgThmAoZ2s+8V9gi2tSzMPNgxW
         IcoItjjFxmMAwgnk7VYz9bqo+XO653ZdzWorCA1LbZxN96uPTCfVfuc2QE2zn3UVIxQu
         asYRtCR3qg2mfnBchwBZ3KHc9gmrdLAVwHvc+d1ATT/v61K5lcLVJ75Rw1xm6hhsjAdW
         t0atCWF3NpX76UoqvlH1u9aT9lfWkXO+tLg7oT9EFLUFIpU3KOZt/qnlNUb2CrWB6bMS
         meZA==
X-Forwarded-Encrypted: i=1; AL+hErEUq2svZSEFoIj3yF3NJa1HUbB1wifHuacnFmlPxR9UU2kq0KqVwmcqkNgntJQKw/E7yJwDG29jjVnOpNw=@vger.kernel.org
X-Gm-Message-State: APuU4Z8G20TOf+5+BotDrPRLfK7NBIW/r+gMa395HCqFmXSQCeGMRPjF
	tSUFDlwXbNXxRyWtI2K19jDQXxLjhtPSwibt2yEmt0QKM3p3cvNZFBgNW9Eyk5wXkdyTXGyPF2i
	1p+kQykItsGbEy5ijroyS+ZH6dHaw7ns=
X-Gm-Gg: AYBFou3SKCfp3Dlv2Ba9z3xnw2htbVoTHJwflKGnUErQyRHpCvA//66QiUX4VPGTbv7
	OaP73ZcvYJ27paiwFA6dRnM0ug4QZA4MQAFQlYDngBcchODqh+k+BUxjh5+xD0eWSbsoToDoObC
	jRCrtgv+BSqb9ofCVC3Qo6Ka/45q7whDHd9YRK9zVquvTQCMznWhrykJ15BIY47DC0cmVKWB2QS
	0H26jvvQPE/WCUBzLr/Or5VmngEoNm0K76zjAaaE2XGPpp1ufBrdkiBRLTFBrQ65WBXazBX3GKV
	yg3lCvyu7LMBBDEx/zZYF1r4ACzrL+B1kPsQu0OxF6tuKlfW1LbZfjTn0E9+pL8SmwAbNPoSTTA
	hQdBea8aVp2vwP02fH54/0QQU91FcJazwfFco7J+a7YAhr3VrhLqcDMnkUwGLDrFohi9iQQ==
X-Received: by 2002:a05:6402:1598:b0:6b5:7250:d621 with SMTP id
 4fb4d7f45d1cf-6b859ae1a00mr134291a12.15.1794850647426; Mon, 16 Nov 2026
 09:37:27 -0800 (PST)
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Post: <mailto:target-devel@vger.kernel.org>
List-Help: <mailto:target-devel+help@vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:target-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org> <20261116-work-loop-pseudo-v3-33-8cbbea1cf34f@kernel.org>
In-Reply-To: <20261116-work-loop-pseudo-v3-33-8cbbea1cf34f@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 16 Nov 2026 18:37:16 +0100
X-Gm-Features: AclHuK_sKnxFPAK3k65pZhjyZC94SJD4eZ9z2j_P12s3kyb9TMw6hurQcjyq55Q
Message-ID: <CAOQ4uxgPerkkG4ie0SyHVXaBD9VZN2wYfQpEAEi4hytn=ara3A@mail.gmail.com>
Subject: Re: [PATCH RFC v3 33/44] ovl: refuse data-only layers on pseudo filesystems
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>, 
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
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

On Mon, Nov 16, 2026 at 12:10=E2=80=AFPM Christian Brauner <brauner@kernel.=
org> wrote:
>
> The data of a metacopy file can live in a data-only layer. overlayfs
> doesn't look that data up when it looks up the file. It only remembers
> the absolute redirect and looks up the data lazily the first time
> someone needs it. So until then nothing can tell which filesystem holds
> the data of such a file.
>
> But a data-only layer has no business being a pseudo filesystem in the
> first place. All it does is hold the data of metacopy files and the
> regular files of a pseudo filesystem are kernel interfaces, not storage.
> So let's refuse data-only layers on superblocks with SB_I_PSEUDO at
> mount time.
>
> Data-only layers can be added via the "::" separator in "lowerdir=3D" and
> via "datadir+" by path or by file descriptor. All of them end up at the
> end of ctx->lower. So a single check in ovl_get_lowerstack() covers all
> of them.
>
> Note that regular lower layers on pseudo filesystems are left alone.
> Stacking overlayfs on top of sysfs keeps working.
>
> Suggested-by: Amir Goldstein <amir73il@gmail.com>
> Link: https://lore.kernel.org/all/CAOQ4uxhGxpBtMZ5kfuzR1tQAewiecoX7UjXQRo=
91QjJHH9T_Yw@mail.gmail.com
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/overlayfs/super.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 39d4d57dec230..719c2569dfeaf 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -1237,6 +1237,14 @@ static struct ovl_entry *ovl_get_lowerstack(struct=
 super_block *sb,
>         for (i =3D 0; i < ctx->nr; i++) {
>                 l =3D &ctx->lower[i];
>
> +               /* Pseudo filesystems don't hold data for metacopy files.=
 */
> +               if (i >=3D ctx->nr - ctx->nr_data &&
> +                   (l->path.dentry->d_sb->s_iflags & SB_I_PSEUDO)) {
> +                       pr_err("filesystem on %s not supported as data-on=
ly layer\n",
> +                              l->name);
> +                       return ERR_PTR(-EINVAL);
> +               }
> +

How about we make this just a tad more restrictive:

                /* Pseudo filesystems don't belong in composefs setup */
                if (ctx->nr_data &&
                    (l->path.dentry->d_sb->s_iflags & SB_I_PSEUDO)) {
                        pr_err("filesystem on %s not supported along
with data-only layers\n",
                               l->name);
                        return ERR_PTR(-EINVAL);
                }

I could send this as followup patch, but since this version is simpler
there is no real reason to have the intermediate "only ban datadir" step.

Only the commit message needs a little more flexing to justify this.

Thanks,
Amir.
