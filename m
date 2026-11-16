Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794859450;
	b=EXJHW3KtGKuQyK2SYqewMhShyicxy0HZWobeKpgloS3zU4yfFGfQh3cXwFejA0wv4duQ
	 PiiIEPOCKMuVYhEOqu5B76v+8fFEEfZ5/v5BRYgKOAPTRlk4EkWyd19hhGGDvANlhUv1M
	 Hr8+YcnT2+/ebByOaSDMLNm5sbJEsurKiLYxR/wLBVEc4vte1+drGA7ZjVzuykMyF0fNa
	 nFzdGe4/W0y1CqH8oI2SU1EhdKQndUxk1J3KpyziHRdOmgusuJXj4SmXZc94tCy5zXT4h
	 ag84a/ESED0iJ12bjVr4Xuuo7CsRcdhDaxlv/a6gDbsQnwV2YyeosXy7wK0jDfVkzSA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794859450;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=FEtpE65JhLGyAYaL/FOW2ebUIws2WwBZ/4Zy8VNXUuw=;
	b=ovXiyjALwQtLXuI/KzuxFhHMx/uQltIFtppgNOYwb5rDNzfB/9jgUzdW09z/42plOBqJ
	 lp40EudBIZIfFtLBLdgyFeP1LgkNQNZQGE4fg+KZQm4oIATqbnj53Jvj7Lm0xJ9swOSHF
	 oirIfAjcA+ePq5gz9hrKrxTnjma3Fy4XPNJIHLGsx3dB1husw0S6k68nSZkuPLFO2OcT1
	 QcFwSCOdoL7usvqR62/BlgMN3K/Iy+Nv3Hp3tCh/d23HV/wTIUvA8JCTgK+kVyBt/tkNh
	 huLQSkzKfpDuqYUGZrtW1DflKZrery6hm8RWoLGpMePziORhWmm+FIHGH8m7lZPDIGw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hnqDx80H;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.42
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D928606A323
	for <target-devel@vger.kernel.org>; Mon, 16 Nov 2026 20:04:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2D928606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hnqDx80H
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-49a92144733so1559080f8f.0
        for <target-devel@vger.kernel.org>; Mon, 16 Nov 2026 12:04:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794859448; cv=none;
        d=google.com; s=arc-20260327;
        b=TsxkOhAl4wnwvJp+3m5w/7kziqkgQFHC8OwfadTxM3LM7yo/4gTZIjcMx+FfMLFeY8
         dpWIghvnRxmgwM6VpCvUGLU34EwKGq/XclFVUOXSbGgXFOaVlbvq6rhbkZ8u9kOigPNz
         Ancpa7uZ40Pws7+BGV2xoSbeUdBxEpxwuTDQGlpaTLBVrwbr5ygEPBH1U8EwNU/Vcx5c
         qFrgzF0qgqa19Z/RmzQTLLjJAVqpGZrv9l4fB6kUf5VkACE3c52u0emozVEKtT5oCnAg
         TVQMtwF+VPVfOE7VCsw41ntB2u/EyYWPSsM1ToKJfSpxhMbI0opLVrT/Y7BfShcVMZFq
         vNfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FEtpE65JhLGyAYaL/FOW2ebUIws2WwBZ/4Zy8VNXUuw=;
        fh=Jo+Rh6+7W1egqTQp92qICtBok+lYLF9B6sYecBzUj+k=;
        b=ZqSqHPkcjTHPEsM2TYS9QVsxRwZHaQGhUCbahfsJBb+pkRAjKgFmi2Ka29LfDYdBkr
         YFP/lzJrBpNP2KZneSbOz2TcwZ8tsszjNsziB6EFa3AFv4nC8lU2QGfA8O+1tepqaf/2
         7Ub2AcR0CL8wmmF4BztuV9kVFub7LhtYpDhrnm+kHLeejaGrBRC5ZUUocAYgXkSTo1fN
         nJkF7w/N76Cf2k1krKKcRcecBdTbdnPRrPqoRlCwgpaJtvU9brB4E203/GkVbedVO11V
         4DqSJzpKZORcK87MVJt+QXxo0MPjanz+LxZ/u3EKdroiUdSfjpadmw7phCo0Y1FIQdY0
         wJ4g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794859448; x=1795464248; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FEtpE65JhLGyAYaL/FOW2ebUIws2WwBZ/4Zy8VNXUuw=;
        b=hnqDx80H1BHGMZ+jCw863LQE2wm4hG6wTw//ziQNWkZpZIjdyNNCtFJNcbykSvuJWZ
         RrqgQGru9l+9Rlw9NCoAO7RXSeH6CHzRwb+h6TsbT77V+vTLtC7o5AslWzWJ8+7yhciq
         sbJxN7Yoz6y6VYO91QUyEDVlXVHt5e/uzOZriYhKEljZIduQH6pNfhdOY5sHlJFueOxf
         bN/uTLfuNBjnHaTZ+WukZQS/Wa30tWyiKsfqEPmOKtkcPCgN1gGIeLsa9pfco/3ZvP3P
         koo3Bb9/+esUnHdHS2hTd5qtXE/k/xctadMJUuU/zchcL0VDKvTRNofZgdIQ6mLOou9W
         X5rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794859448; x=1795464248;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FEtpE65JhLGyAYaL/FOW2ebUIws2WwBZ/4Zy8VNXUuw=;
        b=wPLoVJYlMvCxDxU1DOCk9cALWcI07l1twmcEgaTqIGiIrGugO8+ndkJEMBJwWWqQZP
         hVofHnFgnE2SU7MzuZFd+kgnbDizlbDCFaX/jM4UZLHluWmCPVkV+Rmoze3EAO/jy0F7
         wnJpNXfeXbBwk/udHOXf0SNUKjWwefQgTIo27iI/xJLeEen/IPaEAwh5/m4s6Abe9q5h
         nI91ox/gY4eAHaugH6TVw8FZ0Y8RIwaBJH7Izmj5HTmM+k1J5UW7/HU+Arald+z9QDwj
         b7CR3hVALQjxAYQ6HDYjLhwF2ur8cUBN0DIKJ4wTYYelXybl0YWKzfVx6EgBASoFr29E
         1q9g==
X-Forwarded-Encrypted: i=1; AL+hErEJ/GzJzDT1yzDQKkd6VJMGciEoNDeGyZLhTS8xfe2QTgE9UdBeBmB9KXRw4JtFexLCorCLpbmnO1touK0=@vger.kernel.org
X-Gm-Message-State: APuU4Z9osLebz90QNjHDlvEk0eS8mCiWojt9VZN00YjM9l80GlRjM3JI
	o/SgurM3Dx4BhH3z0N0c7G2Juqs/ce6q2fQFRB3UIf9+Nd3Ae//1wvyzqvgBkCF1af4KT+ZW57B
	yjU8eLk8uk/2xvSChaAgi0KR0l6GgQSQ=
X-Gm-Gg: AZFdTZfGBolIk5FC6SrLEVSl0JJrVDphwVsj71ejs4FESCecKelaiVaonnp41nbYJII
	bQe6024RiPBFTSclZ17khLC4CLAv+8nrcFQTqOMVBSzZ7pFCLZoqvitbH9K+TMGBEr86SFqkkLE
	ldp9kLZSW1wxbGsOoTR+3l2HtQp8lOvPsfaYva35aONUUXv+I9YJwUF+JzFhulokl9QNHvvkAqj
	NxMsJRYl/NebpVC6koeeKGw4w2EQvPDbOU0xAjKvyq0/HaU+bjk3JCN3/xNnFNiabFkn4cvwzEB
	YUf6GYNzn7epg7LBpISYMwekJt1AaBrvl8GOfQ/cRqw3CnJZ2CdpJIoRAjKSmbNccJ3hXvMV6mR
	Hc4N8kgVUN4ouFs1TBYx321IGAl40Qyz6w8GrrI3IYVfmLugl3gnYs0pe1x/28pgVhdMqFBnezp
	unVx4EPYxCQl6WrkhcPvA=
X-Received: by 2002:a05:6000:4692:b0:491:3fdd:af34 with SMTP id
 ffacd0b85a97d-49d61c80db3mr13343868f8f.36.1794859448335; Mon, 16 Nov 2026
 12:04:08 -0800 (PST)
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Post: <mailto:target-devel@vger.kernel.org>
List-Help: <mailto:target-devel+help@vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:target-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org> <20261116-work-loop-pseudo-v3-9-8cbbea1cf34f@kernel.org>
In-Reply-To: <20261116-work-loop-pseudo-v3-9-8cbbea1cf34f@kernel.org>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Mon, 16 Nov 2026 12:03:57 -0800
X-Gm-Features: Aa3M54q6P4M0RFDCKQ8HHGNCWJafItTSPdWR1qNwVGtToDAv2VOv8vDfWHzYR6A
Message-ID: <CAEf4BzbLFVawibuX0wk=8uzy0WZSYHbkgK55d7rqLab2qAM1Fg@mail.gmail.com>
Subject: Re: [PATCH RFC v3 09/44] bpf: use fc_init_pseudo() for bpffs
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
	linux-usb@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, 
	linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org, 
	Alexander Mikhalitsyn <alex@amutable.com>, Chris Down <chris@chrisdown.name>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 16, 2026 at 3:21=E2=80=AFAM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> Initialize bpffs as a pseudo filesystem instead of raising
> SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
> Reviewed-by: Chris Down <chris@chrisdown.name>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  kernel/bpf/inode.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>

Acked-by: Andrii Nakryiko <andrii@kernel.org>

> diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
> index c6f328e4752e1..57cf3775c0766 100644
> --- a/kernel/bpf/inode.c
> +++ b/kernel/bpf/inode.c
> @@ -15,6 +15,7 @@
>  #include <linux/namei.h>
>  #include <linux/fs.h>
>  #include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
>  #include <linux/fs_parser.h>
>  #include <linux/kdev_t.h>
>  #include <linux/filter.h>
> @@ -1197,8 +1198,6 @@ static int bpf_fill_super(struct super_block *sb, s=
truct fs_context *fc)
>         sb->s_magic =3D BPF_FS_MAGIC;
>         sb->s_op =3D &bpf_super_ops;
>         sb->s_xattr =3D bpf_fs_xattr_handlers;
> -       sb->s_iflags |=3D SB_I_NOEXEC;
> -       sb->s_iflags |=3D SB_I_NODEV;
>         sb->s_time_gran =3D 1;
>
>         inode =3D bpf_get_inode(sb, NULL, S_IFDIR | 0777);
> @@ -1261,6 +1260,7 @@ static int bpf_init_fs_context(struct fs_context *f=
c)
>         opts->delegate_attachs =3D 0;
>
>         fc->s_fs_info =3D opts;
> +       fc_init_pseudo(fc);
>         fc->ops =3D &bpf_context_ops;
>         return 0;
>  }
>
> --
> 2.53.0
>
>
