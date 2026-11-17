Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794904033;
	b=tzakCagtmU/T+vyjPxrTyOZzfvMeCMf3sIhXg09rjBB4yqrvDRSFc50HnigREtPnQLUl
	 m5WFm9T3dJWr0c5JBn/nwp8X5eI5shDBaUckEJEkMCw2D32ZD3eNAygwk8vaD2wMG17QH
	 DC8FcnNePQ0qfA8amLmw4/rcQcV50txeLxQZNt1a4ZCHGQMg9O1LlN+FTKvKw3k+33Wgm
	 oiaErDakD2/VkQrKtJEnxCqnE72hcKqdhMCx3mzqEeBv/AlAOeereFSGD+wmN2eSRNAlC
	 c07LAOWlmDUei1jcjj4WAVWVo7k2dhxXSZcMf9srfDWRZPg5TueqcxkiEAuBzc9g+GA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794904033;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=o7Ds5Sp5DChQJ6GHa3pEkVZuOErJkij7LbLCUPT9+Pc=;
	b=Z3znb31O9c4ziy7xI4DqLOuHrYqdL027J4J/FfBKLAjy1RLw1njETsG4gnCrCmF235+f
	 tik506EwcQ2920q/eF2RgzEZ0jZwUMzC5+17v5WxKhDycVOgEp8XsjaceOPOz7vNtYeMr
	 Ol3Dup4rDMcGqUCgVnMtUusI+Ct74gTkLjkokw/MX7eeWMR2lItqyPZXEx7WjWc4XdbAx
	 FstQirvUFswoklTiXCi6bWmDqoj0szokF8cp3rXTUhUHEHJlf7yXKm2rNeOTTkg03PJZM
	 7K9vxl1QQLn5lSHN3D77GlHar1kWiNQjAr5U3162fP8er0ztAv/QvCWgyP9+WvAVgnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=m3Y+iV2p;
	arc=none smtp.remote-ip=209.85.128.54
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E893D606A32C
	for <target-devel@vger.kernel.org>; Tue, 17 Nov 2026 08:27:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E893D606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=m3Y+iV2p
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4bb64ef5a00so17182725e9.3
        for <target-devel@vger.kernel.org>; Tue, 17 Nov 2026 00:27:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794904030; x=1795508830; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=o7Ds5Sp5DChQJ6GHa3pEkVZuOErJkij7LbLCUPT9+Pc=;
        b=m3Y+iV2pelmutPYORVxza4CHQMpjq7iS5lmecWgDjvax6Coso4uWa+KMaCm+CB3bWY
         yM9xDjlaUDqClL2wfFs+3EgMKFX4Q8fuLgup7VSVEO3iDYFOyh4nyeN0Shri07+KD82b
         UFGbuWvBELdRnXkiKa1GIWjPRb4Wz8WRQUErt4eMboeCaxWHABbQwTZk6BuPw2NopAXW
         5935wwOL0Ggt8LD7VeJmtmL6iC6DgtiD4S4DRbEtkaj1swNFS1XEbe90cWaNyokAE8Lz
         Ulc1c4G0eNVUIpLzTdbViN3HgCOMoyHpu6hnCIZ+utcpbQY02w1kBKtCyN8iaUfGq6tI
         6sqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794904030; x=1795508830;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=o7Ds5Sp5DChQJ6GHa3pEkVZuOErJkij7LbLCUPT9+Pc=;
        b=pxbTnzynvypt2vBZh1CqkHhr3c53MC99v9J1OKa4uIGmrSW5j9xwtWZuWs55ht/xzT
         L8F6BrzGkYUdpXk2Ob4y3IEv9ZvqPEBwl4jZnBwmffewn+NpO937ebN2WzL75tAzP4Oo
         Y4Gv9P+aKkdz5efrd3aW0L6kZTC8aP4W8MvNzuSPkF5nR6mE2tLmikQ8/1GmMgiSa6uI
         eGL7dFC6zyrC6vOzkDwNZtVwAcYjE4aJ/Svpc+zF1YVkteeeGUn45i4Ngew2rSdttVkq
         jdiWXmV9+2FFc8uvGMawfTdxL8cho7KgzmDAE6TUrl7DkcyGv7VYsesARCedsXs1vQP8
         bh2Q==
X-Forwarded-Encrypted: i=1; AL+hErH0Eal18eUKhP1PANEWoVxi9+ilz14CYhefcr9flR+O4f2+9u9GzPNkWEQwUt1ATHCR4KVRgF3Kox0/jn8=@vger.kernel.org
X-Gm-Message-State: APuU4Z8SU6GAk7hNg7gLBMDeE0r3yEDMFeocNMUSksF4dZ7FsX7FQfqf
	pVgDUEfbzHgYhIrWaVrXlz5huWHOOhAfeY5p6i08bdSOtGydyHIbqMFrFsE+Ubn3DK3Z
X-Gm-Gg: AYBFou1gfAji9r+LbDnTDU6lMSrnKcneib5D6C5h1Jz+/sQzdQizUlA6ljqgD7txr+x
	QxiaDC2ISiWTKQT7lRZH4Y/o+RZ0QQAP8WCaPk5Y64DKmMdraJmDAc1ovy7Om+8z69+dJJSJeq8
	qvhw754dyk1wSrHgzYhBe2jS0I1Ii3x8gI7XOmCQiK/Fu3iQqsG1O5SLya+Cdc4GmtFCnwN/8jh
	OrwZiAzymhN4BUy3J5YXzBNJB3ePs6qOt3v6MaW4jHzM4FwXvVaB0BcXpCZlQPk6aFMDk3dc+oO
	uqH61OCow5Tpn/QXIA4d5Cx/4mz+nMW2+tUDMaSS5BdiXTaRLyDZK+Dvtgi8FTLaQWcqWJU5TCq
	arna/Oq3ksiCDbn0QO5GtSZrDWsJzCHFow0MjRO0WPmOO2tD0R0Z4BnrwT64j1JgX04npBH6QsV
	iTzpzJUTJxg2CvmrgTCysNFgJRS3FZpN62lQmsAMGj3Lx5zEg+j6+eDgB62IERm0X8FXA1InY2T
	MYlaBQmn1fE0qUHalRUlKIa2CqaXbCIFhbpwHIVIRm2VRHYNZn/rhdc1pCD6qoneWsBuCOyb5au
	VQb3vJdJYI5kLEEG71XrmEGfvPd8YpzfHaKxq/KSLzMtpmnIyzUAg/9UDlLoB2hGAYPbQFHCif/
	Hz15hChiEugq0O7/MnHpcGDp38YmjhHPCLIo15XluRWcur2PNAbGdkAVF
X-Received: by 2002:a05:600c:3494:b0:4bb:6c71:b268 with SMTP id 5b1f17b1804b1-4bb6c71c232mr134135095e9.6.1794904030378;
        Tue, 17 Nov 2026 00:27:10 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:de4c:6789:33ce:97c2? (p200300cf572c2800de4c678933ce97c2.dip0.t-ipconnect.de. [2003:cf:572c:2800:de4c:6789:33ce:97c2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb7838c912sm45730155e9.4.2026.11.17.00.27.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:27:10 -0800 (PST)
Message-ID: <0ec7b8c90cc456b24e5b19c1db673d497ae43735.camel@amutable.com>
Subject: Re: [PATCH RFC v3 12/44] rust_binderfs: use fc_init_pseudo()
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
Date: Tue, 17 Nov 2026 09:27:08 +0100
In-Reply-To: <20261116-work-loop-pseudo-v3-12-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
	 <20261116-work-loop-pseudo-v3-12-8cbbea1cf34f@kernel.org>
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
> Initialize binderfs as a pseudo filesystem instead of raising
> SB_I_NOEXEC
> by hand. This adds SB_I_PSEUDO. binderfs_fill_super() keeps clearing
> SB_I_NODEV for the binder device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0drivers/android/binder/rust_binderfs.c | 3 ++-
> =C2=A01 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/android/binder/rust_binderfs.c
> b/drivers/android/binder/rust_binderfs.c
> index 5f020226720db..04468c5b5c116 100644
> --- a/drivers/android/binder/rust_binderfs.c
> +++ b/drivers/android/binder/rust_binderfs.c
> @@ -3,6 +3,7 @@
> =C2=A0#include <linux/compiler_types.h>
> =C2=A0#include <linux/errno.h>
> =C2=A0#include <linux/fs.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/fsnotify.h>
> =C2=A0#include <linux/gfp.h>
> =C2=A0#include <linux/idr.h>
> @@ -667,7 +668,6 @@ static int binderfs_fill_super(struct super_block
> *sb, struct fs_context *fc)
> =C2=A0	 * necessary and safe.
> =C2=A0	 */
> =C2=A0	sb->s_iflags &=3D ~SB_I_NODEV;
> -	sb->s_iflags |=3D SB_I_NOEXEC;
> =C2=A0	sb->s_magic =3D RUST_BINDERFS_SUPER_MAGIC;
> =C2=A0	sb->s_op =3D &binderfs_super_ops;
> =C2=A0	sb->s_time_gran =3D 1;
> @@ -759,6 +759,7 @@ static int binderfs_init_fs_context(struct
> fs_context *fc)
> =C2=A0	ctx->stats_mode =3D binderfs_stats_mode_unset;
> =C2=A0
> =C2=A0	fc->fs_private =3D ctx;
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &binderfs_fs_context_ops;
> =C2=A0
> =C2=A0	return 0;
