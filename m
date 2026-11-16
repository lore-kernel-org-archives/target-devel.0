Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794859648;
	b=d0isPUcM2QFAt/am586O6ZSO+g3Ib85yeY9qa17EpmBrYRdPdUR2mEJGmVBo1orys5d/
	 Pmz6J+TqYId6iCc2oYTQXz5qDRGsRAO+TlUYvp3aE/4qsh5gGn6eo34Dk+q8fXVgStJ9L
	 9QW5JOacZ3F80PJNP1VqGwthZcabazv9KzG36mtlA7nBjsGxjxffGKtFJRAgqlsdyzgpt
	 FvI72UqyRygAh3uUmHRz+TslDISplyNL6/34L42rjqr+Yy/QA3gzxhP07FQTPrWtOWgkE
	 CgObjQUT4T2YxEnCA3Vd4A7V4WdfKH9ibdPv8DVdBH4WaBB0uP535uKy22Ru/HQ8tWQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794859648;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=EZDAQV8yhgMyPQgwR3U/5djFDS4+SZxlS+9+Esw/bYc=;
	b=m1Z3Wb7LL3jnBwb2ggkNqnQq6zK7NT0jqr6cRdIWGpimJ882r9S1U+jagzB1BW5YSL9Z
	 ZUHUqVxJONe89S1vMjokcfoi9G5+pVv6d92bE92t/EHZ42G5ejyqdcUGKN9M3+L+eRRvO
	 WAbPAelxf4p6RJ35y4T1ZAsvD/nNLFGWOzpUCuGuB84cNP0JpmII4QcvasCQMAAhGWE2g
	 r4Ffcg/lcHybzy9bcQKPHxRZukmGEi3DujPPNgh3F7Hp4IqVYko14+AaCPnXKBXxBpMpQ
	 yJ7z1YkbYX2YzcK0YJQDngSQdoIdt4OfJkiDv3e+kDnZYite5Dw7q92cVfz/HCFiY7g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XFDBy0c2;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24113606A887
	for <target-devel@vger.kernel.org>; Mon, 16 Nov 2026 20:07:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 24113606A887
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XFDBy0c2
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4bb72b44a97so9382365e9.0
        for <target-devel@vger.kernel.org>; Mon, 16 Nov 2026 12:07:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794859644; cv=none;
        d=google.com; s=arc-20260327;
        b=AncsbOFTq142QaBpMZirSaOxsjGrMV9Uw/0blCHe5KzBOzjEUcNUJEcT+aX+Q/0D73
         0eY4mr2knyh30kLTSyIkJIOpfsiIqBy25ZEW2h5oUE0Y6TjzE7mNcAecDaod5joorRZ2
         JPVcD4bft4H3eQ0RDr1N/QuRU5lghseP1+bnCbS1Ms2FWgmL1jMFtVxr8glE8f6Zh2l1
         huVgFi12pDj0nGwgbiz9S1zF9ppdxXqTpZnBM9bo69qmXcmSwmeZ6efdakwNwEUPOYt2
         pHu/uhuD9TQLOsXZmO6uXB31+Bxk6dsGGcj5zOUYQA1gyFrpco4tE2YRuHh7ZIfEL2hY
         kXEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EZDAQV8yhgMyPQgwR3U/5djFDS4+SZxlS+9+Esw/bYc=;
        fh=aXvlgnIWyQDxI14Z5h4nCZBoYKBfJNPvQmtpq31v5Fo=;
        b=ltgDGwoA4bmVzS3zli2316iizN9a/ksB8gbqkQwLvKuQlN9LYS+Y26OJ0i09VM509Q
         y4MQqXGo8uA+95t7aMtoyl8YEGLi7bcqLeTU9vtHVRlsB9KaFKEzlrg7/RUujL1i7ZR4
         /8E6398C6871zP1ZgGfttOkuMgxAlVj8Fri/rrrpQaOpD/oVvZ0W5Zfvrhd3DSqhlJZH
         9RgYgs+EMOoQdII/t/38rNWMo20oQ9EN8xtkiy4q1ElkO7KE2QgRHsTb1vJvxzGjPC5k
         iBPkd9kbn7Y/Ur1OLJsgDADZBJYpzeLlTdtjsWCICpnHKn/I/hJ3bZEVqz9GHjz8kNAd
         R4vA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794859644; x=1795464444; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EZDAQV8yhgMyPQgwR3U/5djFDS4+SZxlS+9+Esw/bYc=;
        b=XFDBy0c2q6nTYiJ4dwLENH1mguXX/IcFF58gOeYQArjps79P1XpkrhGZpUclTyZwpS
         r/ZYwRoOG8WhRg+8JvLZN08T5FQLHs7jA/CzeQCQsJeulI93s02F+iYtli/pBjYHG+CR
         W2MoU0n/+grSPpLZW83MAsn9WQiLh5CCwtBf/0GxLqRHC416IFZ4i13TeIFhLxmbz0il
         NPxDzLDOL7N17VVYsTOL0jDLDvB5woBcjlvcU+oGB0Wrnz6q9rCc3VHuwmdjl71ac6+n
         fuvYHmykPJU4vuSvTSKMetyKY9BqLddb2of0qXOJ87q21uNxSrudqkhk+T/+cyqihyd7
         2YNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794859644; x=1795464444;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EZDAQV8yhgMyPQgwR3U/5djFDS4+SZxlS+9+Esw/bYc=;
        b=ZafjUvvi1a89cwzPT78k5cYm68qBRO27lAULdXDAK1dVwy18Lp0Pyv2EH5f7ByXhZZ
         FbaHGgLraxvs/BAinl3Znss7lzXKRSU7GuL1T+a48TeS4ymCyQh/bDueQ0L9+v9qOAmA
         Ue8AHj2cPYs3vd5CbFbGdtqjB1Q0TQkGVUrVnvZsx5GZ/3feHMz2ASg3fGn0D3Er/7y2
         JtZYw8VIB5g1OtsJKuo7djnhYgyJltNLK0xPs0kiXfTHIne8ghOBebzA858Iug+xqfL5
         jetr1d3bZVoJ6HXGcaG0DiQ91ywzw5bhxqQHb/OC6G4DeykX9FkA4mp3Wp0HU25ULACl
         qdvA==
X-Forwarded-Encrypted: i=1; AL+hErHgMbkjDgxKDhIl4Xh2ACXKH/J6CexUoMV+1hZJBJTa4ki6uIWAyD9SIUBeJ9sDj9i1F3EZRKX/xCaCx3I=@vger.kernel.org
X-Gm-Message-State: APuU4Z9hlJSgj6SQUvkaOvw0uxsIFtZBOnbdSwfHDxP74dJk+3qvT6Y9
	/gSxUrQFWZMdtTmaH4sprIYU0vzx9rqYMRfpfzoYdbcLCbC/c7894z50zO8K4gjVA0asri7BfKR
	APse1RjDOBiMeziPk0yoMN4j+WJeDVQI=
X-Gm-Gg: AYBFou14HjZzWTCavDfVMnU5kNgSDaM1lY7Sz1sTmkxvXNd9XedyXqMshfZQ0LeBpLN
	IoAEzs5pLput+gjYpTQjFvyEDd8Yly3MJDLJLnqm1lzTDRafSX0Ww6BeC/3Z/QV3F5jOY1k9yjO
	c2eZAt6vrO/4z+vsBN9ZVLYWuEMsoH3EkepC5Ea+PJS4YMmegHJTJ46hiM6crkJfsZX5HTctrS8
	Mm1avheI3jC1lUbuVBklCxk7oy3QUvf6bocJX7cdUn8Uu22Xh64bgs2KrYHEps1CKFnQ+hOKu4U
	WYdB+EifIdoY+0631Vsq1XujkOSi5bCd2bKgqVU1VFHs+etmMq6GiFy4XWk63azLvZuwZBfe7dO
	ETt4ciOxiSYK4qoAbIQzENAYoHrrJlCdazLmw33Ag/8DBf9cSF4NevIvM/4d6dNjoD04aMih/Be
	YDP95ugj9nTz3Ul7Kv4w==
X-Received: by 2002:a05:600c:506:b0:4a1:f377:5c6c with SMTP id
 5b1f17b1804b1-4bb55a5d6bbmr165067875e9.10.1794859644313; Mon, 16 Nov 2026
 12:07:24 -0800 (PST)
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Post: <mailto:target-devel@vger.kernel.org>
List-Help: <mailto:target-devel+help@vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:target-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261116-work-fs-frozen_writes-v2-0-ecc4a2aac40e@kernel.org> <20261116-work-fs-frozen_writes-v2-13-ecc4a2aac40e@kernel.org>
In-Reply-To: <20261116-work-fs-frozen_writes-v2-13-ecc4a2aac40e@kernel.org>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Mon, 16 Nov 2026 12:07:13 -0800
X-Gm-Features: Aa3M54rpWiCplKeR8o5TX-NbYGDID_36BWk-3VAyUzdEoXSYZ7J-t8pfWvm9Fcc
Message-ID: <CAEf4BzYANM9vtQ8L9-rJPQC-tTcw3YUGsw=qnCaoym3+EU=DBg@mail.gmail.com>
Subject: Re: [PATCH v2 13/17] bpf: fs/xattr: take freeze protection in the
 xattr kfuncs
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org, 
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, bpf@vger.kernel.org, linux-nfs@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 16, 2026 at 3:13=E2=80=AFAM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> bpf_set_dentry_xattr() and bpf_remove_dentry_xattr() go through
> __vfs_setxattr() and __vfs_removexattr() which leave freeze protection
> to the caller. BPF LSM programs call them from sleepable hooks such as
> file_open where nobody holds it. So a program can modify a frozen
> filesystem.
>
> The hook may already hold freeze protection or locks a frozen
> filesystem would make us wait under. So don't wait for a thaw. Fail
> with -EBUSY if the filesystem is frozen.
>
> The _locked variants are only used from hooks that run inside setattr,
> setxattr, removexattr, unlink and rmdir. Their callers hold freeze
> protection already.
>
> Fixes: 56467292794b ("bpf: fs/xattr: Add BPF kfuncs to set and remove xat=
trs")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/bpf_fs_kfuncs.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>

LGTM

Acked-by: Andrii Nakryiko <andrii@kernel.org>

> diff --git a/fs/bpf_fs_kfuncs.c b/fs/bpf_fs_kfuncs.c
> index 35ccd98a4de64..7f61e2efa08ba 100644
> --- a/fs/bpf_fs_kfuncs.c
> +++ b/fs/bpf_fs_kfuncs.c
> @@ -295,9 +295,13 @@ __bpf_kfunc int bpf_set_dentry_xattr(struct dentry *=
dentry, const char *name__st
>         if (!inode)
>                 return -EINVAL;
>
> +       /* The hook may hold locks or freeze protection already. */
> +       if (!sb_start_write_trylock(inode->i_sb))
> +               return -EBUSY;
>         inode_lock(inode);
>         ret =3D bpf_set_dentry_xattr_locked(dentry, name__str, value_p, f=
lags);
>         inode_unlock(inode);
> +       sb_end_write(inode->i_sb);
>         return ret;
>  }
>
> @@ -323,9 +327,13 @@ __bpf_kfunc int bpf_remove_dentry_xattr(struct dentr=
y *dentry, const char *name_
>         if (!inode)
>                 return -EINVAL;
>
> +       /* The hook may hold locks or freeze protection already. */
> +       if (!sb_start_write_trylock(inode->i_sb))
> +               return -EBUSY;
>         inode_lock(inode);
>         ret =3D bpf_remove_dentry_xattr_locked(dentry, name__str);
>         inode_unlock(inode);
> +       sb_end_write(inode->i_sb);
>         return ret;
>  }
>
>
> --
> 2.53.0
>
>
