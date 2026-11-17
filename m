Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794904513;
	b=y/BGbW9DWvZ65zDQHr9Er5Q0d52wCV9Gaz51Ffl815xA7T7EdKOPZqcuOt74KgzH4EXy
	 QVj4JHT7uDdhU/kpm0TpKduJl6nWPmZ48h+GYXWNX0ZET8A+wt4v1hz9WyF0Wpu63Ta5T
	 hPfVhK2fKedgpCb/YPBSUpKgmJPui7sJYsGwl5UREU7bSplWSPsOvNTidQeqTVD6YJDW0
	 AjeqhGGQiL4op9gZoBVKYaR/LMoCcNKDu0jrPkGyjzS6drFN+Io7E5wGR1L1Vb+dGZ2yf
	 c6Fm9HKvLX8CJOHo2ebtWM5nsRMS8TP2OaCcAEoClEeZ+m7UzOxa883PRb+AyaA2Xyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794904513;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=+cVfVc99Mj9JzDjRqkRlx7bbwk4z1TaP6S9xba6j1G0=;
	b=226SEud+G8gO4qLdCx8iCX4a7ZmDYWdz031ryuZjz1UFf4m3LQL2oEKDgR8yDa424z8Y
	 hfvZMk/2hi7JOPtYVhqOYF8FolLe1O0aos4dOCAuwH+I/UjYYRGYFktLc0RD3rE5Qarmf
	 ejTGmqncho+EU6gEyuDJvO+8mCbrTc8LH1qZAI82UCpIHagp4PpSLh0nyBqecmvXmxAdH
	 3pOwrOhv50PZEmHQGsnCw/c8/72d6rTqTXArBweDUcOoh/os6M5MgXhQ8yo+GcLKhwtjg
	 5pbcX1t4pOOlI0Y3u8Ahtma26w1SG3P7QXx1OqYCl+tjtCqcFo15iVotADx2WFGeX2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=asHWLUHh;
	arc=none smtp.remote-ip=209.85.221.46
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91572606A89A
	for <target-devel@vger.kernel.org>; Tue, 17 Nov 2026 08:35:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 91572606A89A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=asHWLUHh
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-4a33359c1b3so506525f8f.3
        for <target-devel@vger.kernel.org>; Tue, 17 Nov 2026 00:35:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794904510; x=1795509310; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=+cVfVc99Mj9JzDjRqkRlx7bbwk4z1TaP6S9xba6j1G0=;
        b=asHWLUHh9Osx9c7ISjHVvBK+jrwM+bEKiKQ5ZLUG8jHeL8cbDrdmay7aq+azwtlrvN
         q7YkHw224WJQO7TnM1AyMygFYXrlY29jKpq3C9XROr0oTqsA+UK4p+WS5GMy+xx9DTRb
         nuDA+OEO8+ykjkDq/RDjAwEfWgenycj+snq2KkG6mulygb6NKchr6plM71+t8W0/+aGL
         LigMC+giRqQ92TsunABClmE52NWQSdRqhQeez7lH76lemvGh63Ic8nud3Qte/9KpQmbQ
         YrdviXjfG5hlS64KIE7Iq0kMRVYmtZMNK2hkMRb6Cz1tihRk5N+J71aJKPK+K5E0SOED
         KbHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794904510; x=1795509310;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+cVfVc99Mj9JzDjRqkRlx7bbwk4z1TaP6S9xba6j1G0=;
        b=xGQJU5JSMiJzFzFPCzuRNzyX8gtt5X9HsBCeKBwcwH7EuK4UeAM39DD++UviAeYZcs
         bpZiNgwRu4Pynkgz07uKyel1s8VUSaC3xcj7lC2jvgmkq5H1ItXUxCQkzlqfKfAKsSIl
         hM3vSR/G4NumrUvZhi+Fqqqd4CI+fLTqvL9WN+ysrjSN3VY8QWuSNLQxk4davkicopPg
         ZSTtbaRzUqeakJJrhhpBpsFY8F9po1RWFV+w+ujExYJWXbJhupTe2RRJDrEFUL1FjVYS
         FOIClnP2NH0XhsU7pOmVmBcUkvzYqt8RQhMsJM8P0/8ZhTxYEH/w0rQLr0nVxYFqdj0t
         XrGA==
X-Forwarded-Encrypted: i=1; AL+hErG6dfiKqh2qEvyR7rwjq0lXq2meMr9c8XN/k38fbYPwrB6lP0F9Sg1qjR7rG2d5nJ6HBk8xiFKZzOPCZVk=@vger.kernel.org
X-Gm-Message-State: APuU4Z/g7CkeG/aGB2vOY+ZT6INmlVvxfumxgd6+/dcS5xegQDzBaB/K
	7O3U1Hd9zTmVNoUVWxccIy0YSdqT4DnYXN1LZdPbayanbK2pG/oFWLSNAUYj54YlWe59
X-Gm-Gg: AZFdTZeUaVS8Os+jCahmbDmepa73LujNvtKvLiF3B1ctR/9vR3DtfuiQ9Wg7Kwd5dYc
	L1CzfDr7GRViL7mKzB8SWUU2N4PecvvL2DFCo4g6jvmIcJpsH7OHODSZCUsMmW29B0cZZfEeS2x
	jrUhGQ4K9cfONWOFnsOtg5E4WS5GmbZRDca+nYTkv/7W4hw2Ubz3DjX/RbFZFm1ILzOFbyQnE6R
	owT5xPzmGf3zqncYItNaWtC/HgumEYfVTvr15IKeyFjHhf+8SfF/cPnleKP9Ey0eILm6bkZhuWj
	hr2URQDxFQymWZBoPVAt55Ut/DDVZayPOhFAi6n7a9UqwJo881ZevRy81lsctcwrcP7vPfPpSDF
	RPSOCd8HfdurEcFffKY0gbPrZ5akWkFY6zd77EIHbYijPujrIzu0Jwv0ezY7qGXslU+xu1VGdLq
	fkhIGLzYElf0AeKZta+UZ65pzM9E4AwvQttlgDsoql61H7/QvRbAiRzZ8adqeITg2Uf2dos47rW
	zl4ap3LcCc1cVrJb2x9U6X2ilo4G04fNUM3Lvy2EVi7hry3bRC6nm4i1sm03ctNqRT0ql3WtdIv
	rsnbde0nD+PfLSTiMVj04skF+6hGw5RGmll5uiGPQ5MLoK+PQvMZagsxsZtDlxx5cPez55Du6eT
	EfHUmZRq48Z12qlX/dbrXR695zhcgmA7ZTzzc4PWTuEg/vPvSeSeSLMt/
X-Received: by 2002:adf:e193:0:b0:48c:7306:18e9 with SMTP id ffacd0b85a97d-49c728c6e6amr26569239f8f.43.1794904509932;
        Tue, 17 Nov 2026 00:35:09 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:de4c:6789:33ce:97c2? (p200300cf572c2800de4c678933ce97c2.dip0.t-ipconnect.de. [2003:cf:572c:2800:de4c:6789:33ce:97c2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c603f4e2esm26338505f8f.36.2026.11.17.00.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:35:09 -0800 (PST)
Message-ID: <b0ec2cd8f9b7a6a2e4a54c6df2fa897bce068cbd.camel@amutable.com>
Subject: Re: [PATCH RFC v3 28/44] ocfs2: use fc_init_pseudo() for dlmfs
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
 linux-kselftest@vger.kernel.org, Chris Down	 <chris@chrisdown.name>
Date: Tue, 17 Nov 2026 09:35:07 +0100
In-Reply-To: <20261116-work-loop-pseudo-v3-28-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
	 <20261116-work-loop-pseudo-v3-28-8cbbea1cf34f@kernel.org>
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
> Initialize dlmfs as a pseudo filesystem. This raises SB_I_PSEUDO and
> also SB_I_NOEXEC and SB_I_NODEV. dlmfs never holds executables or
> device nodes.
>=20
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Chris Down <chris@chrisdown.name>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0fs/ocfs2/dlmfs/dlmfs.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
> index d3bfcada3e3bf..1789ec96dc130 100644
> --- a/fs/ocfs2/dlmfs/dlmfs.c
> +++ b/fs/ocfs2/dlmfs/dlmfs.c
> @@ -21,6 +21,7 @@
> =C2=A0#include <linux/module.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/pagemap.h>
> =C2=A0#include <linux/types.h>
> =C2=A0#include <linux/slab.h>
> @@ -563,6 +564,7 @@ static const struct fs_context_operations
> dlmfs_context_ops =3D {
> =C2=A0
> =C2=A0static int dlmfs_init_fs_context(struct fs_context *fc)
> =C2=A0{
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &dlmfs_context_ops;
> =C2=A0
> =C2=A0	return 0;
