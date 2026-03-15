Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367CD2701D9
	for <target-devel@vger.kernel.org>; Sun, 15 Mar 2026 22:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773615430; cv=pass; b=umKJkRV1fOsUx9OSa3E5nhhqLIYfKpTfyC9ud/1halqKHMlhOPrehNDyIsT7sTCbdpap7OniSYpZvdeBGwlGiI4n0h5Xg5OVckES7Gy9QilP+orTAHQriATP57P5Cc8w5BoxrmMjaqKGUxL1JfPZtSJaF6mXi4U0zZbKfRjuiz0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773615430; c=relaxed/simple;
	bh=N757Y417PUVmBRoZCQ0NlAOx/jmlSMjJ+pd868QTWSI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=toW4IcyOM/9SR+k64/AD7RNBvUY66EhT456RuQjRSmGRc6tv1aABamLRsnPDJbgWVRQsq33c/vpxdbqqrDDu0ATjJPwIZl0uq1c4flPzCrCWJ6pmJCRkfFYg1wKAG1pelPTBMSs0OZ94DDJBq7i434NM8eRw9jq6ciAp+iwtuPE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VFH0yDcJ; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VFH0yDcJ"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-50906a98ffeso710701cf.0
        for <target-devel@vger.kernel.org>; Sun, 15 Mar 2026 15:57:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773615426; cv=none;
        d=google.com; s=arc-20240605;
        b=JhzacNUCMPxP+D1L8yFuu8DHNgtuJyE7t+hBYYrnuePQXlbII1q69f0uOXE1jFfdRh
         c7sfWpordQ8glQtmwJLra7sVFQ7I+l5IG9MTDQXAme6KUiGXldzU6oq9s5Hd9pJjQo4e
         x7hFj4iv2S/LkvSsgu/hHfMUsweYZjALSotBWX/8xeRVnpIglzdSvKLgkUonnwWX/w9U
         0Buh5iljZvP01PTDX0YbiDko1OrNYrZ6fmSB5zK1miPrPh85t+DejgKzKywQH8qTlYkr
         UuBbXYuQMK7HW+dP4ati9xX+q1uYKNgX2SgaX0UoCz3SKqU19EUn+g9iei7Q3cTrvIaD
         7KBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uCXOqQYTnzGNhQPDiApCXbqWFijYEREGO2671+swbzA=;
        fh=uHLVCl+ypEvJSRstUH6LZQbjG19lKz0+1h0EXF6diLg=;
        b=TFvEAkr/KEaGjrVS1k0yjPtFNuc/Jbxw7kX273lAbekz68hIhvn3rXY+QV6eJAYmwE
         McbaG1cecq9BTQbtRfSQWPfa75S14vE8aNPqAJ/qfU9F3n45DVpRWyapB93oOD2+eGs6
         Uz6CTSecNzabbmptM4XwI+PYflXMdMlTTGg7ffgOwVaXO4Zgc1mt/1PEc4XjTySRX0fJ
         W8GneY/m5N4pmkvhAGLQTcHVUKgciB9g/wg5y+Ek6PyxsZZnLNUUpZ6WtrPNiFwcDgL6
         YoX8RjVHAUN2FsKj/E2L/sy4QRGAahVhWGM2NOIlGZSPSs31T2jET0Dht/EJJC76koqw
         AadA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773615426; x=1774220226; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uCXOqQYTnzGNhQPDiApCXbqWFijYEREGO2671+swbzA=;
        b=VFH0yDcJJr+Lxf1MfPElUlNs506geNjcH6TxEVzpFRW6rAuJu/8QZvdn5AbVkje1Jz
         wdiLjEvxNvNqf0kDSmdxSD+2pqjt1x0SqWtpYFH8r2BZVvkiAi6ScuRqDgF9Hk//1Awz
         ZD4V7exQBOxr4q0qFoOZMuPY8eJ67CHGovob4u5QYeRdvDQwZ1M3eMGMt+qXNvtPN8Gm
         yxSpeZ+w1BaLaiSZdbvFk6Cj8EZ++QzIWMmRnmT49p7I9AcVwLmd45u2JOeVrCdlnIOs
         z5s8lI0cYyyHs20Ee2pgQpsaejbVTFIuu3doXOMrjXJYZ9qqAXE3Qq1k2kO1AsT2Gz79
         Z8hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773615426; x=1774220226;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uCXOqQYTnzGNhQPDiApCXbqWFijYEREGO2671+swbzA=;
        b=brBmobyGAEQJCmS3MWvkUK7GYTopJiRJ4Nl62wdQWmCHOEEeI8vhFvkb+IYWtCI0z3
         n3dcGl5C8dJ+0ZRy1wqhGs7hVzGi1sUhZLy0XDtCiD71rHcty1zoKUPj+EylrDpYg4VF
         NrzlbENmaKVE+AVFJHJezHCsZ6i+9nx/nA8cf+FKSgJEA9kGfUuIQYDfv1gCf5MKPEwH
         KxsHlrnKWei0+3k1qPnRn5qayJTu0ilayUhLfVliSeb/4M3SZJOgck+MWEGVp6Uolnic
         Txpl+hgFMINFjykh5g0bPgrJRriKEDCoKTT+mSPQSAdBsVfX5kFsU/PW8Fgnueu/9Y3J
         uhUw==
X-Forwarded-Encrypted: i=1; AJvYcCUZ/Nsxs4Z0jIAC+WQEXDFhtQRQoPv+TIWlSKw7HVp33vi7DU9akxp9/Ak1HeksaBP2tncEgRH6n6gsYmo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBNdXC/y9ZEtO7wNlyS4QcpBhfk+nsoNQl0+65McFUPUjJTJyR
	+zSHD32lTq37irnSJgYG5kGJc+ZJYTwAkpyLu12VtH5EuX2/3yvHIP0p/NFKTpjcJKMJD2UfWdf
	Xh5LD34SbtOakZDQhhF7dywln6XZmFNZDr6jqAmpk
X-Gm-Gg: ATEYQzxodRhAOJ61N6f1xWUXXfnKDyYRlChGAJe15u9T/o0OtUo4jr35XQ4Cq128I+T
	HA3qG2ZhMCt/KfgzKIfphVsAPF+XSMEUSUp3m6lbD5BzFgf5IdPamWNisosI1ZNuYUTsjRxv3Vc
	biIenmBXh+azYJTl7zbOw2oV5KO9sXhJoG8txMwvE9tPXZIoUIpLB45qCW8y+fjChbfSU4nf+/E
	gbu4JQM8iCB4rnY6I1r/lC77oBbCuusnNrY4DfoCRmexjzy9LWWGI588mnVCtEo3HxzpJ6Ek763
	olWHJDjccVXWt3Aq
X-Received: by 2002:a05:622a:1648:b0:509:72a:ae59 with SMTP id
 d75a77b69052e-509694c63a6mr20842221cf.10.1773615425456; Sun, 15 Mar 2026
 15:57:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1773346620.git.ljs@kernel.org> <56372fe273f775b26675a04652c1229e14680741.1773346620.git.ljs@kernel.org>
In-Reply-To: <56372fe273f775b26675a04652c1229e14680741.1773346620.git.ljs@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 15 Mar 2026 15:56:54 -0700
X-Gm-Features: AaiRm51Rev4ufazINlivV2AzV3ufvB013bFH7aap69X4pIxh6gJw0EUx7qrVlHk
Message-ID: <CAJuCfpEsCrFEYNkkTfRLGojGOYAAx1=WOojOhpBb_=WZBr6bnQ@mail.gmail.com>
Subject: Re: [PATCH 01/15] mm: various small mmap_prepare cleanups
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	Clemens Ladisch <clemens@ladisch.de>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "K . Y . Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Maxime Coquelin <mcoquelin.stm32@gmail.com>, Alexandre Torgue <alexandre.torgue@foss.st.com>, 
	Miquel Raynal <miquel.raynal@bootlin.com>, Richard Weinberger <richard@nod.at>, 
	Vignesh Raghavendra <vigneshr@ti.com>, Bodo Stroesser <bostroesser@gmail.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, David Howells <dhowells@redhat.com>, 
	Marc Dionne <marc.dionne@auristor.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, David Hildenbrand <david@kernel.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
	linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org, 
	linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, linux-afs@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	Ryan Roberts <ryan.roberts@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 12, 2026 at 1:27=E2=80=AFPM Lorenzo Stoakes (Oracle) <ljs@kerne=
l.org> wrote:
>
> Rather than passing arbitrary fields, pass an mmap_action field directly =
to
> mmap prepare and complete helpers to put all the action-specific logic in
> the function actually doing the work.
>
> Additionally, allow mmap prepare functions to return an error so we can
> error out as soon as possible if there is something logically incorrect i=
n
> the input.
>
> Update remap_pfn_range_prepare() to properly check the input range for th=
e
> CoW case.

By "properly check" do you mean the replacement of desc->start and
desc->end with action->remap.start and action->remap.start +
action->remap.size when calling get_remap_pgoff() from
remap_pfn_range_prepare()?

>
> While we're here, make remap_pfn_range_prepare_vma() a little neater, and
> pass mmap_action directly to call_action_complete().
>
> Then, update compat_vma_mmap() to perform its logic directly, as
> __compat_vma_map() is not used by anything so we don't need to export it.

Not directly related to this patch but while reviewing, I was also
checking vma locking rules in this mmap_prepare() + mmap() sequence
and I noticed that the new VMA flag modification functions like
vma_set_flags_mask() do assert vma_assert_locked(vma). It would be
useful to add these but as a separate change. I will add it to my todo
list.

>
> Also update compat_vma_mmap() to use vfs_mmap_prepare() rather than calli=
ng
> the mmap_prepare op directly.
>
> Finally, update the VMA userland tests to reflect the changes.
>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---
>  include/linux/fs.h                |   2 -
>  include/linux/mm.h                |   8 +--
>  mm/internal.h                     |  28 +++++---
>  mm/memory.c                       |  45 +++++++-----
>  mm/util.c                         | 112 +++++++++++++-----------------
>  mm/vma.c                          |  21 +++---
>  tools/testing/vma/include/dup.h   |   9 ++-
>  tools/testing/vma/include/stubs.h |   9 +--
>  8 files changed, 123 insertions(+), 111 deletions(-)
>
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 8b3dd145b25e..a2628a12bd2b 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2058,8 +2058,6 @@ static inline bool can_mmap_file(struct file *file)
>         return true;
>  }
>
> -int __compat_vma_mmap(const struct file_operations *f_op,
> -               struct file *file, struct vm_area_struct *vma);
>  int compat_vma_mmap(struct file *file, struct vm_area_struct *vma);
>
>  static inline int vfs_mmap(struct file *file, struct vm_area_struct *vma=
)
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 4c4fd55fc823..cc5960a84382 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4116,10 +4116,10 @@ static inline void mmap_action_ioremap_full(struc=
t vm_area_desc *desc,
>         mmap_action_ioremap(desc, desc->start, start_pfn, vma_desc_size(d=
esc));
>  }
>
> -void mmap_action_prepare(struct mmap_action *action,
> -                        struct vm_area_desc *desc);
> -int mmap_action_complete(struct mmap_action *action,
> -                        struct vm_area_struct *vma);
> +int mmap_action_prepare(struct vm_area_desc *desc,
> +                       struct mmap_action *action);
> +int mmap_action_complete(struct vm_area_struct *vma,
> +                        struct mmap_action *action);
>
>  /* Look up the first VMA which exactly match the interval vm_start ... v=
m_end */
>  static inline struct vm_area_struct *find_exact_vma(struct mm_struct *mm=
,
> diff --git a/mm/internal.h b/mm/internal.h
> index 95b583e7e4f7..7bfa85b5e78b 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1775,26 +1775,32 @@ int walk_page_range_debug(struct mm_struct *mm, u=
nsigned long start,
>  void dup_mm_exe_file(struct mm_struct *mm, struct mm_struct *oldmm);
>  int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm);
>
> -void remap_pfn_range_prepare(struct vm_area_desc *desc, unsigned long pf=
n);
> -int remap_pfn_range_complete(struct vm_area_struct *vma, unsigned long a=
ddr,
> -               unsigned long pfn, unsigned long size, pgprot_t pgprot);
> +int remap_pfn_range_prepare(struct vm_area_desc *desc,
> +                           struct mmap_action *action);
> +int remap_pfn_range_complete(struct vm_area_struct *vma,
> +                            struct mmap_action *action);
>
> -static inline void io_remap_pfn_range_prepare(struct vm_area_desc *desc,
> -               unsigned long orig_pfn, unsigned long size)
> +static inline int io_remap_pfn_range_prepare(struct vm_area_desc *desc,
> +                                            struct mmap_action *action)
>  {
> +       const unsigned long orig_pfn =3D action->remap.start_pfn;
> +       const unsigned long size =3D action->remap.size;
>         const unsigned long pfn =3D io_remap_pfn_range_pfn(orig_pfn, size=
);
>
> -       return remap_pfn_range_prepare(desc, pfn);
> +       action->remap.start_pfn =3D pfn;
> +       return remap_pfn_range_prepare(desc, action);
>  }
>
>  static inline int io_remap_pfn_range_complete(struct vm_area_struct *vma=
,
> -               unsigned long addr, unsigned long orig_pfn, unsigned long=
 size,
> -               pgprot_t orig_prot)
> +                                             struct mmap_action *action)
>  {
> -       const unsigned long pfn =3D io_remap_pfn_range_pfn(orig_pfn, size=
);
> -       const pgprot_t prot =3D pgprot_decrypted(orig_prot);
> +       const unsigned long size =3D action->remap.size;
> +       const unsigned long orig_pfn =3D action->remap.start_pfn;
> +       const pgprot_t orig_prot =3D vma->vm_page_prot;
>
> -       return remap_pfn_range_complete(vma, addr, pfn, size, prot);
> +       action->remap.pgprot =3D pgprot_decrypted(orig_prot);
> +       action->remap.start_pfn  =3D io_remap_pfn_range_pfn(orig_pfn, siz=
e);
> +       return remap_pfn_range_complete(vma, action);
>  }
>
>  #ifdef CONFIG_MMU_NOTIFIER
> diff --git a/mm/memory.c b/mm/memory.c
> index 6aa0ea4af1fc..364fa8a45360 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3099,26 +3099,34 @@ static int do_remap_pfn_range(struct vm_area_stru=
ct *vma, unsigned long addr,
>  }
>  #endif
>
> -void remap_pfn_range_prepare(struct vm_area_desc *desc, unsigned long pf=
n)
> +int remap_pfn_range_prepare(struct vm_area_desc *desc,
> +                           struct mmap_action *action)
>  {
> -       /*
> -        * We set addr=3DVMA start, end=3DVMA end here, so this won't fai=
l, but we
> -        * check it again on complete and will fail there if specified ad=
dr is
> -        * invalid.
> -        */
> -       get_remap_pgoff(vma_desc_is_cow_mapping(desc), desc->start, desc-=
>end,
> -                       desc->start, desc->end, pfn, &desc->pgoff);
> +       const unsigned long start =3D action->remap.start;
> +       const unsigned long end =3D start + action->remap.size;
> +       const unsigned long pfn =3D action->remap.start_pfn;
> +       const bool is_cow =3D vma_desc_is_cow_mapping(desc);

I was trying to figure out who sets action->remap.start and
action->remap.size and if they somehow guaranteed to be always equal
to desc->start and (desc->end - desc->start). My understanding is that
action->remap.start and action->remap.size are set by
f_op->mmap_prepare() but I'm not sure if they are always the same as
desc->start and (desc->end - desc->start) and if so, how do we enforce
that.

> +       int err;
> +
> +       err =3D get_remap_pgoff(is_cow, start, end, desc->start, desc->en=
d, pfn,
> +                             &desc->pgoff);
> +       if (err)
> +               return err;
> +
>         vma_desc_set_flags_mask(desc, VMA_REMAP_FLAGS);
> +       return 0;
>  }
>
> -static int remap_pfn_range_prepare_vma(struct vm_area_struct *vma, unsig=
ned long addr,
> -               unsigned long pfn, unsigned long size)
> +static int remap_pfn_range_prepare_vma(struct vm_area_struct *vma,
> +                                      unsigned long addr, unsigned long =
pfn,
> +                                      unsigned long size)
>  {
> -       unsigned long end =3D addr + PAGE_ALIGN(size);
> +       const unsigned long end =3D addr + PAGE_ALIGN(size);
> +       const bool is_cow =3D is_cow_mapping(vma->vm_flags);
>         int err;
>
> -       err =3D get_remap_pgoff(is_cow_mapping(vma->vm_flags), addr, end,
> -                             vma->vm_start, vma->vm_end, pfn, &vma->vm_p=
goff);
> +       err =3D get_remap_pgoff(is_cow, addr, end, vma->vm_start, vma->vm=
_end,
> +                             pfn, &vma->vm_pgoff);
>         if (err)
>                 return err;
>
> @@ -3151,10 +3159,15 @@ int remap_pfn_range(struct vm_area_struct *vma, u=
nsigned long addr,
>  }
>  EXPORT_SYMBOL(remap_pfn_range);
>
> -int remap_pfn_range_complete(struct vm_area_struct *vma, unsigned long a=
ddr,
> -               unsigned long pfn, unsigned long size, pgprot_t prot)
> +int remap_pfn_range_complete(struct vm_area_struct *vma,
> +                            struct mmap_action *action)
>  {
> -       return do_remap_pfn_range(vma, addr, pfn, size, prot);
> +       const unsigned long start =3D action->remap.start;
> +       const unsigned long pfn =3D action->remap.start_pfn;
> +       const unsigned long size =3D action->remap.size;
> +       const pgprot_t prot =3D action->remap.pgprot;
> +
> +       return do_remap_pfn_range(vma, start, pfn, size, prot);
>  }
>
>  /**
> diff --git a/mm/util.c b/mm/util.c
> index ce7ae80047cf..dba1191725b6 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -1163,43 +1163,6 @@ void flush_dcache_folio(struct folio *folio)
>  EXPORT_SYMBOL(flush_dcache_folio);
>  #endif
>
> -/**
> - * __compat_vma_mmap() - See description for compat_vma_mmap()
> - * for details. This is the same operation, only with a specific file op=
erations
> - * struct which may or may not be the same as vma->vm_file->f_op.
> - * @f_op: The file operations whose .mmap_prepare() hook is specified.
> - * @file: The file which backs or will back the mapping.
> - * @vma: The VMA to apply the .mmap_prepare() hook to.
> - * Returns: 0 on success or error.
> - */
> -int __compat_vma_mmap(const struct file_operations *f_op,
> -               struct file *file, struct vm_area_struct *vma)
> -{
> -       struct vm_area_desc desc =3D {
> -               .mm =3D vma->vm_mm,
> -               .file =3D file,
> -               .start =3D vma->vm_start,
> -               .end =3D vma->vm_end,
> -
> -               .pgoff =3D vma->vm_pgoff,
> -               .vm_file =3D vma->vm_file,
> -               .vma_flags =3D vma->flags,
> -               .page_prot =3D vma->vm_page_prot,
> -
> -               .action.type =3D MMAP_NOTHING, /* Default */
> -       };
> -       int err;
> -
> -       err =3D f_op->mmap_prepare(&desc);
> -       if (err)
> -               return err;
> -
> -       mmap_action_prepare(&desc.action, &desc);
> -       set_vma_from_desc(vma, &desc);
> -       return mmap_action_complete(&desc.action, vma);
> -}
> -EXPORT_SYMBOL(__compat_vma_mmap);
> -
>  /**
>   * compat_vma_mmap() - Apply the file's .mmap_prepare() hook to an
>   * existing VMA and execute any requested actions.
> @@ -1228,7 +1191,31 @@ EXPORT_SYMBOL(__compat_vma_mmap);
>   */
>  int compat_vma_mmap(struct file *file, struct vm_area_struct *vma)
>  {
> -       return __compat_vma_mmap(file->f_op, file, vma);
> +       struct vm_area_desc desc =3D {
> +               .mm =3D vma->vm_mm,
> +               .file =3D file,
> +               .start =3D vma->vm_start,
> +               .end =3D vma->vm_end,
> +
> +               .pgoff =3D vma->vm_pgoff,
> +               .vm_file =3D vma->vm_file,
> +               .vma_flags =3D vma->flags,
> +               .page_prot =3D vma->vm_page_prot,
> +
> +               .action.type =3D MMAP_NOTHING, /* Default */
> +       };
> +       int err;
> +
> +       err =3D vfs_mmap_prepare(file, &desc);
> +       if (err)
> +               return err;
> +
> +       err =3D mmap_action_prepare(&desc, &desc.action);
> +       if (err)
> +               return err;
> +
> +       set_vma_from_desc(vma, &desc);
> +       return mmap_action_complete(vma, &desc.action);
>  }
>  EXPORT_SYMBOL(compat_vma_mmap);
>
> @@ -1320,8 +1307,8 @@ void snapshot_page(struct page_snapshot *ps, const =
struct page *page)
>         }
>  }
>
> -static int mmap_action_finish(struct mmap_action *action,
> -               const struct vm_area_struct *vma, int err)
> +static int mmap_action_finish(struct vm_area_struct *vma,
> +                             struct mmap_action *action, int err)
>  {
>         /*
>          * If an error occurs, unmap the VMA altogether and return an err=
or. We
> @@ -1355,35 +1342,36 @@ static int mmap_action_finish(struct mmap_action =
*action,
>   * action which need to be performed.
>   * @desc: The VMA descriptor to prepare for @action.
>   * @action: The action to perform.
> + *
> + * Returns: 0 on success, otherwise error.
>   */
> -void mmap_action_prepare(struct mmap_action *action,
> -                        struct vm_area_desc *desc)
> +int mmap_action_prepare(struct vm_area_desc *desc,
> +                       struct mmap_action *action)

Any reason you are swapping the arguments?
It also looks like we always call mmap_action_prepare() with action =3D=3D
desc->action, like this: mmap_action_prepare(&desc.action, &desc). Why
don't we eliminate the action parameter altogether and use desc.action
from inside the function?

> +

extra new line.

>  {
>         switch (action->type) {
>         case MMAP_NOTHING:
> -               break;
> +               return 0;
>         case MMAP_REMAP_PFN:
> -               remap_pfn_range_prepare(desc, action->remap.start_pfn);
> -               break;
> +               return remap_pfn_range_prepare(desc, action);
>         case MMAP_IO_REMAP_PFN:
> -               io_remap_pfn_range_prepare(desc, action->remap.start_pfn,
> -                                          action->remap.size);
> -               break;
> +               return io_remap_pfn_range_prepare(desc, action);
>         }
>  }
>  EXPORT_SYMBOL(mmap_action_prepare);
>
>  /**
>   * mmap_action_complete - Execute VMA descriptor action.
> - * @action: The action to perform.
>   * @vma: The VMA to perform the action upon.
> + * @action: The action to perform.
>   *
>   * Similar to mmap_action_prepare().
>   *
>   * Return: 0 on success, or error, at which point the VMA will be unmapp=
ed.
>   */
> -int mmap_action_complete(struct mmap_action *action,
> -                        struct vm_area_struct *vma)
> +int mmap_action_complete(struct vm_area_struct *vma,
> +                        struct mmap_action *action)
> +
>  {
>         int err =3D 0;
>
> @@ -1391,23 +1379,19 @@ int mmap_action_complete(struct mmap_action *acti=
on,
>         case MMAP_NOTHING:
>                 break;
>         case MMAP_REMAP_PFN:
> -               err =3D remap_pfn_range_complete(vma, action->remap.start=
,
> -                               action->remap.start_pfn, action->remap.si=
ze,
> -                               action->remap.pgprot);
> +               err =3D remap_pfn_range_complete(vma, action);
>                 break;
>         case MMAP_IO_REMAP_PFN:
> -               err =3D io_remap_pfn_range_complete(vma, action->remap.st=
art,
> -                               action->remap.start_pfn, action->remap.si=
ze,
> -                               action->remap.pgprot);
> +               err =3D io_remap_pfn_range_complete(vma, action);
>                 break;
>         }
>
> -       return mmap_action_finish(action, vma, err);
> +       return mmap_action_finish(vma, action, err);
>  }
>  EXPORT_SYMBOL(mmap_action_complete);
>  #else
> -void mmap_action_prepare(struct mmap_action *action,
> -                       struct vm_area_desc *desc)
> +int mmap_action_prepare(struct vm_area_desc *desc,
> +                       struct mmap_action *action)
>  {
>         switch (action->type) {
>         case MMAP_NOTHING:
> @@ -1417,11 +1401,13 @@ void mmap_action_prepare(struct mmap_action *acti=
on,
>                 WARN_ON_ONCE(1); /* nommu cannot handle these. */
>                 break;
>         }
> +
> +       return 0;
>  }
>  EXPORT_SYMBOL(mmap_action_prepare);
>
> -int mmap_action_complete(struct mmap_action *action,
> -                       struct vm_area_struct *vma)
> +int mmap_action_complete(struct vm_area_struct *vma,
> +                        struct mmap_action *action)
>  {
>         int err =3D 0;
>
> @@ -1436,7 +1422,7 @@ int mmap_action_complete(struct mmap_action *action=
,
>                 break;
>         }
>
> -       return mmap_action_finish(action, vma, err);
> +       return mmap_action_finish(vma, action, err);
>  }
>  EXPORT_SYMBOL(mmap_action_complete);
>  #endif
> diff --git a/mm/vma.c b/mm/vma.c
> index be64f781a3aa..054cf1d262fb 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -2613,15 +2613,19 @@ static void __mmap_complete(struct mmap_state *ma=
p, struct vm_area_struct *vma)
>         vma_set_page_prot(vma);
>  }
>
> -static void call_action_prepare(struct mmap_state *map,
> -                               struct vm_area_desc *desc)
> +static int call_action_prepare(struct mmap_state *map,
> +                              struct vm_area_desc *desc)
>  {
>         struct mmap_action *action =3D &desc->action;
> +       int err;
>
> -       mmap_action_prepare(action, desc);
> +       err =3D mmap_action_prepare(desc, action);
> +       if (err)
> +               return err;
>
>         if (action->hide_from_rmap_until_complete)
>                 map->hold_file_rmap_lock =3D true;
> +       return 0;
>  }
>
>  /*
> @@ -2645,7 +2649,9 @@ static int call_mmap_prepare(struct mmap_state *map=
,
>         if (err)
>                 return err;
>
> -       call_action_prepare(map, desc);
> +       err =3D call_action_prepare(map, desc);
> +       if (err)
> +               return err;
>
>         /* Update fields permitted to be changed. */
>         map->pgoff =3D desc->pgoff;
> @@ -2700,13 +2706,12 @@ static bool can_set_ksm_flags_early(struct mmap_s=
tate *map)
>  }
>
>  static int call_action_complete(struct mmap_state *map,
> -                               struct vm_area_desc *desc,
> +                               struct mmap_action *action,
>                                 struct vm_area_struct *vma)
>  {
> -       struct mmap_action *action =3D &desc->action;
>         int ret;
>
> -       ret =3D mmap_action_complete(action, vma);
> +       ret =3D mmap_action_complete(vma, action);
>
>         /* If we held the file rmap we need to release it. */
>         if (map->hold_file_rmap_lock) {
> @@ -2768,7 +2773,7 @@ static unsigned long __mmap_region(struct file *fil=
e, unsigned long addr,
>         __mmap_complete(&map, vma);
>
>         if (have_mmap_prepare && allocated_new) {
> -               error =3D call_action_complete(&map, &desc, vma);
> +               error =3D call_action_complete(&map, &desc.action, vma);
>
>                 if (error)
>                         return error;
> diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/=
dup.h
> index 5eb313beb43d..908beb263307 100644
> --- a/tools/testing/vma/include/dup.h
> +++ b/tools/testing/vma/include/dup.h
> @@ -1106,7 +1106,7 @@ static inline int __compat_vma_mmap(const struct fi=
le_operations *f_op,
>
>                 .pgoff =3D vma->vm_pgoff,
>                 .vm_file =3D vma->vm_file,
> -               .vm_flags =3D vma->vm_flags,
> +               .vma_flags =3D vma->flags,
>                 .page_prot =3D vma->vm_page_prot,
>
>                 .action.type =3D MMAP_NOTHING, /* Default */
> @@ -1117,9 +1117,12 @@ static inline int __compat_vma_mmap(const struct f=
ile_operations *f_op,
>         if (err)
>                 return err;
>
> -       mmap_action_prepare(&desc.action, &desc);
> +       err =3D mmap_action_prepare(&desc, &desc.action);
> +       if (err)
> +               return err;
> +
>         set_vma_from_desc(vma, &desc);
> -       return mmap_action_complete(&desc.action, vma);
> +       return mmap_action_complete(vma, &desc.action);
>  }
>
>  static inline int compat_vma_mmap(struct file *file,
> diff --git a/tools/testing/vma/include/stubs.h b/tools/testing/vma/includ=
e/stubs.h
> index 947a3a0c2566..76c4b668bc62 100644
> --- a/tools/testing/vma/include/stubs.h
> +++ b/tools/testing/vma/include/stubs.h
> @@ -81,13 +81,14 @@ static inline void free_anon_vma_name(struct vm_area_=
struct *vma)
>  {
>  }
>
> -static inline void mmap_action_prepare(struct mmap_action *action,
> -                                          struct vm_area_desc *desc)
> +static inline int mmap_action_prepare(struct vm_area_desc *desc,
> +                                     struct mmap_action *action)
>  {
> +       return 0;
>  }
>
> -static inline int mmap_action_complete(struct mmap_action *action,
> -                                          struct vm_area_struct *vma)
> +static inline int mmap_action_complete(struct vm_area_struct *vma,
> +                                      struct mmap_action *action)
>  {
>         return 0;
>  }
> --
> 2.53.0
>
