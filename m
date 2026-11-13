Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794564336;
	b=rUfe1KgJtnSCOjnbrSoMQDmxZEkBPyartvCcYiNFd39gtsVXBbnAfYb4X2r3gvq6ROKQ
	 leSbycJoaFGACRTcS/W5CM8FQtgnIt4aFFyqahWH7xg0kC9ZsrjDLOOzZwuDCb74Xi2pI
	 EYN1TMjOLchyoj91zu+qwMWE6cbmxF7AR6LG2nuL+40sNR/gIl09HRrmuJLAfCF2Kngco
	 hRjfkOZPkpjLU2iTlcsiWRSvmfN9rnHkIT+GytDebt+LfI5UM7qqO1dTGcl1vegVqzXFY
	 6/qxdfLGqo+f5Ch8MiEvaycHP7HRZvcLX5xLG6VNjE9avXSHBM36G9KDge0X+7WHu2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794564336;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=fNM18G1T3F0ezY9f7dMoEwC6d3kOVWk14Z1vuqkOGWM=;
	b=GOqRNPR0rjT5PrOxpwU7BRQwfNP+NIRZGOyJHkBxCgACaHsgywrUNXVaQADIAWF13AJw
	 rK9LA19lHjkZ446B86sY+4QWSEsnCC0Hc2sW9UJcNN8RGwCMk9eirJ4h59NNotYVJU7L6
	 JZ1aY1IkZQM5ajLPCXm7UoH23DB88NwywSfNoShCVVRatUw/5WRNxZDgTUQICX1Vjp1d9
	 ObcOpNgST6AJ84+hR/9LGVIN/jYs2SxAVWEJvuZg4AYUH4xlWYPnqpSJe4uGVode5Jb/A
	 fasCdWTiCdcHlJEoVH2NS8CkLdTN0ngiBMFCXfUIaOwXb1pEmpa/CTQVRCZ2mndzk2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=nN3frtS1;
	arc=none smtp.remote-ip=209.85.218.50
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C401E606A8A2
	for <target-devel@vger.kernel.org>; Fri, 13 Nov 2026 10:05:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C401E606A8A2
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=nN3frtS1
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c247f6687dcso182003266b.2
        for <target-devel@vger.kernel.org>; Fri, 13 Nov 2026 02:05:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564334; x=1795169134; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=fNM18G1T3F0ezY9f7dMoEwC6d3kOVWk14Z1vuqkOGWM=;
        b=nN3frtS1dXU5gnwmqfzT8+bhaiQQmGH+o8SykyblXrC3qld0kuEs+6HEGC2rkpdv/S
         sQV16XdsqqZb3GM8OFjrvrple+atxGtcqxLFVKkGZ0Zd80qUKx/EPhy8mDGrZkmovYLQ
         gPE45P700sVxzONMsyf76aaH6Xk5KYIuezCkWASzF5DvGkP1gh+ZRYmtrnwRu9+hQOqa
         BqpjziGjGsV2LfHal3A39L3aaFb8qdjtC8kgwx4O/4F9AvhElCVGweiPQgw5f+yTyeo/
         j+w9LUu3B6WOr6fOKhMnpx/PfseHq+Dks7TfznRnFDL7kPCQ+qTR2Sh8LdlE9KHj9gsV
         IzpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564334; x=1795169134;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fNM18G1T3F0ezY9f7dMoEwC6d3kOVWk14Z1vuqkOGWM=;
        b=XcMrqCa70bZjetd4S+cY7KjQsXqmHApymLwrZNyFgp7kWzuj+DoqVYrEGMeywiXbav
         zKwf+TWzyyeJBbugwmjUCazp2IMU8V3gDHfj7IVXa/F7pQR/rqmDAOFCXt/kusvo/v1l
         0hujpFgP/Lfed+5CbXC6hxxVb7KM1ITF3c4ofsK1JSV5ZiKd4UtHTLWp+gQ2qpaXNpFP
         kMqHPUDQMdC/hS/WV5rKH/GP9TMdApMWtHVJrByapKx9qzumPid/i945SQz31Rq90DIK
         /QLFQk/vV4YOjlukQK/9E7PkOd6BZE/tVdLuGPnRaPIXnCustJZ41qkCAJmaGZ8BQqjl
         d1pw==
X-Forwarded-Encrypted: i=1; AL+hErEOk93dxRgVKSIALN1nAG/5DKiJ84XPYZEMCDrKOMq290ZslBYsGImAfzpIVebiQd5y/G+0jw8pqZ61JaI=@vger.kernel.org
X-Gm-Message-State: APuU4Z9DOLVhyOs0N13R07ZKUkKNy0EqbfCoh8I9mGLzUvfuy9OL9E0c
	0eX93rek5nmLWVLMi4dOgBulXVe30hpjigtMFv8LhtzowysZBApPm59UOmjUnICRYsNpej1PD+a
	fR4kQdopdeA8=
X-Gm-Gg: AYBFou15wBdXfKldKLpWHYMKfLSp0oRIosuSf31gxbVZHcnr+lD5BBBzQdLQvSQM9+k
	3W4TE+kWvRdIIsu75ur5L1jG2YYBVpRoO7Pe0PW6fLWR3JPo2XipGw/e/CePRyIlunWg3FZwkdb
	IiQBTRSSQCYI6sqP8AMw9Ug8L/5Om7xkEVn3D/6dwEfjbfleM48KG1s/aDYJo8aMomArx86sQIl
	xeSqx9Zhw06YOVqs17IiZ0rUnvrLPKakN6A/qQR7+bWPSbzAxiijSr7Wn93rka7n6vIQBQAar04
	XX9cFBZSFWvLfU7k3UMZSB+ZbjuudfF9arN+89pZTy5mBfqh6qa26tOJY6V6sLNOAUPdmUj4ewl
	hynu0kLTC0xd/eeqHEeXcyJaXFFF5mUsZPojEYcGX7vvd9d5Ini2GYYZXIv3xrzxx9M3QRw2lo9
	xui1jMG6MX8GX6bggt65Gi6PETQDNBBRnB6czMe3cU5bQIq6fkMSmWTgrvFFEADK4w9F/ybtqNK
	AhZFpuAWJVM2vE1ItZwLmWQp9E+UvIzEk9Ku/yW2EdLGUSAUlq2e8pM5FrXKQBifkpfXVk85pbx
	jMKaL9nVhZiPnYc6r/+2Xfh/u6NAVWewtv2BHjcWxitzyDpkxblVQD4ZNN/ghgH9kMFbTphzkTm
	uoOjMq0C7
X-Received: by 2002:a17:907:608f:b0:c43:eae5:ee80 with SMTP id a640c23a62f3a-c5096398b03mr148720566b.17.1794564321873;
        Fri, 13 Nov 2026 02:05:21 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b7b2c9sm75811766b.73.2026.11.13.02.05.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:05:21 -0800 (PST)
Message-ID: <08fa1be263cf4a3db6b3e5ec2847107fba7acfba.camel@amutable.com>
Subject: Re: [PATCH RFC 13/41] devpts: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:05:19 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-13-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-13-4c998976c6c7@kernel.org>
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
> Initialize devpts as a pseudo filesystem. This raises SB_I_PSEUDO and
> SB_I_NOEXEC. devpts never holds executables. devpts_fill_super()
> keeps
> clearing SB_I_NODEV for the pty device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/devpts/inode.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
> index bd1e8eb26edb..47ef12241d92 100644
> --- a/fs/devpts/inode.c
> +++ b/fs/devpts/inode.c
> @@ -13,6 +13,7 @@
> =C2=A0#include <linux/init.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/fs_parser.h>
> =C2=A0#include <linux/sched.h>
> =C2=A0#include <linux/namei.h>
> @@ -438,6 +439,7 @@ static int devpts_init_fs_context(struct
> fs_context *fc)
> =C2=A0		fsi->mount_opts.reserve =3D true;
> =C2=A0
> =C2=A0	fc->s_fs_info =3D fsi;
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &devpts_context_ops;
> =C2=A0	return 0;
> =C2=A0}
