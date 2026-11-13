Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564657;
	b=bQvW9vKbjzIhU1+Z/awaA2lU8F8jV0v/9auiV7KNy0Q3R5BTyleHBgcau/9jP2XqpcAm
	 jmy4m2uBlvtypJJJO6zIE/UeNOpkr0TYnHUIWxzykgMUCPBDteYDKpVSqCuNwcQTAVyw5
	 bcSJfhuZQLoHftPyurQZbF5ZJY8H7/0f8zeIhYVRxmELNWlNvaKHxhSY3znTvj6W9139l
	 4H20oCxuoph6XX0Dr7Higxv4NZhhDRDfnyON1xcQCuE/gSneT8hAOQOkVsF6lP/n2ZkdL
	 MqdoEI4AMEFKuNNPk3jNd27VKioFJk17k9sh3KXDdlg3uQm90EKI+3rdhExYhIXHJsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564657;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=RUn5HyOzv5zK74OCIfLVACQcizuS/sHn5qpIQd0Zvv8=;
	b=P/llNz3eONSXeeaWPIe+nH1HC5ffywRAmofHufggNZ43eb0YTpvsrfWdv8VH1m1HrSmq
	 gXpCS/IPd39dbOOZdTbcLSxtRKfUVylH6QgmlTy4OtueWgXq3bYFYW19GJ28fnhw4q10f
	 Pf2SPb1wUFdmAGNW5Lq7zfELJzlqGfJsDiv6LV2K/Xb7dJATvVbFLKI7dUZlG+857Pyp5
	 6D75N0DDiwesVm5vLEKkX/qssePlM8E3H9Y846Bd5ZVNPu+AiTnfv3iyA1HBaXjUGGhGY
	 mziZcQnlLS+RW+tF/oBEkI+uPx9iYJfLYxnXHzDq0DDijek8ZaCelmWA/HTrCo1CMFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=afSYRRYW;
	arc=none smtp.remote-ip=209.85.221.49
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195B7606A339
	for <target-devel@vger.kernel.org>; Fri, 13 Nov 2026 10:10:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 195B7606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=afSYRRYW
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-490f38e9688so497681f8f.0
        for <target-devel@vger.kernel.org>; Fri, 13 Nov 2026 02:10:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564655; x=1795169455; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=RUn5HyOzv5zK74OCIfLVACQcizuS/sHn5qpIQd0Zvv8=;
        b=afSYRRYW0Lzg1RjNF5a8Z8fp4FTD8+wBAkqEEgX+uXVLN6iB/1Oe+S3s3pjBsHkfPy
         t+OYs+BeBV0n1jEyBb10NVx3dBSZolIBqoZV0sAqk1NmAyPkc8BtADcPrCcEDzdTW4+p
         zgkm0FzjpTOQt7I53MJB0zmRNwJ5JPK+9oiFhFL/qPiFq6x22bgZ8fSq9Se2ho9ikF+q
         rg0gx4TedCmdQu2h6zCkoXcFHWmQ+ZQsRVeKTv2sVCXhncyHGZ2k8DCVvoh7926dtvhd
         5w+l12l3Dd1UCqA4z70s6tomNhqNtGqcJuf3lRDB60cxVt/wNhZpOgzeegjchzcaCyfn
         tojQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564655; x=1795169455;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RUn5HyOzv5zK74OCIfLVACQcizuS/sHn5qpIQd0Zvv8=;
        b=zBOqtsPPKb878pNhTkJ1aHuEhMfRpb5NX65rDF1yuwQx4aLcwF2uDRJi1hqgRwSBni
         utLlXKuox5oekosDQkiEduPiV4/RmlkClqxhZmOVQ2o9uoXL4mz7Tg0nbGOm/PGn3f58
         U3OZPpQI1MWl0QK87701yjZjiirhnYu39f7PBHYLQfzw/SjpfdqFbmFPQoEC75TfVZE0
         VlcnhQQOhg0tpxJh8JyAJThXXSfsKZCYGfOjtJunkAQCJhl0e0hwn4vZLjqmviv6SaL4
         VPnkve7G0XB5lkVIB/KPJlAEJRRno2O+hTLkzv+S4xY1xfpS0CCf55ougike/saNcMnW
         f20g==
X-Forwarded-Encrypted: i=1; AL+hErHZ+i7H0O0BlE9fBHHzTyqUIjRfnY2so4d/Av0kYU8FQ6fWe+HzSzyJwuhrwswFeRpKseDJvEJw0UPqaTU=@vger.kernel.org
X-Gm-Message-State: APuU4Z/zefMx32wk7h8PvgBsD7MQvaM902p+pEU3hrqAiDX1318/JtsC
	2B14jk7jXQ7TlontJ9MLeFFxWC1cBnf47KEYZ6MGG/k7SjtsZwEsevVpcY0ZABQWmkBg
X-Gm-Gg: AYBFou1MNz4nlLFt0Xj5uoP/KHGor1j8Z3iHMksxngt60W9K8/xaL7BxyiDqCgCKIy9
	2agf74Jg5uagQQU0+JjrKehwQaSlsIHR6YAqmGk7RiBPvdljkITDa0moUD4HiU3OJxNvoT4X8yg
	jpOll6lDa3nTD2nqtbkWwe4Y4lpq+t2Qkh2ufJ25I3N5+y1R3ILM7vrwWk7wYntxUxejq6D0syi
	g/MBBHJV3CPkhDfYHFa8bPwx5Xv5ZFQC+wIImTjqXKOnyoVY8+lhLpsjoHF772PWLNkUeLLnClZ
	smUqLUx2iqF/1knROswx2mLrexDnvqzoExrpDVbg6vIFGr/qH74XkZXS7MU7TbbXmdYtabF78Qd
	gJqcukv87LV6IQ6pN6P5diJjeqebopqTn416QUpJOrO19vXK6lwdg9J1HbTekBG1LtckGfq3b+O
	bp/Ku9OUun2iT/YaG7Z1YGuFGsppwDH8g+mUgtNh0gou7RrQlRkk4U4WbKQlYb4ZaxP14FuRTvA
	Z8hemo8hFiXr9yUJ7cQXuQp5NBMjBfqNR+k4zROk5UQD4rcYCJh4I+FdaXSE+IEsS+rIwaAeeI1
	gQT2vnyPtR+ioC0yXmOaKYucjXkkQGqjDO3UhUlqTsJrWN0IPa1pl8alNSVNbBA=
X-Received: by 2002:a05:6000:470e:b0:499:ffd4:f519 with SMTP id ffacd0b85a97d-49b02d4c2cfmr11662822f8f.23.1794564655454;
        Fri, 13 Nov 2026 02:10:55 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5a32d336sm4988050f8f.0.2026.11.13.02.10.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:10:55 -0800 (PST)
Message-ID: <0894c601b3f3c5b92008c6c399faaa539b658307.camel@amutable.com>
Subject: Re: [PATCH RFC 17/41] securityfs: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:10:52 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-17-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-17-4c998976c6c7@kernel.org>
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
> Initialize securityfs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. securityfs never holds executables
> or
> device nodes.
>=20
> AppArmor puts a .null device node into securityfs but only ever opens
> it via dentry_open() which doesn't care about SB_I_NODEV.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0security/inode.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/security/inode.c b/security/inode.c
> index 080402367674..93997a9f16fc 100644
> --- a/security/inode.c
> +++ b/security/inode.c
> @@ -14,6 +14,7 @@
> =C2=A0#include <linux/kobject.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/mount.h>
> =C2=A0#include <linux/pagemap.h>
> =C2=A0#include <linux/init.h>
> @@ -64,6 +65,7 @@ static const struct fs_context_operations
> securityfs_context_ops =3D {
> =C2=A0
> =C2=A0static int securityfs_init_fs_context(struct fs_context *fc)
> =C2=A0{
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &securityfs_context_ops;
> =C2=A0	return 0;
> =C2=A0}
