Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21CED425CC0
	for <target-devel@vger.kernel.org>; Wed, 18 Mar 2026 16:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773849636; cv=pass; b=mIG8Jstve63syrRfTOjbVT9ROFk1AlzH0Hf7/11opVwZLyFkbn6CQujYpecvvZNrQoKY5VMEmcMwBn35NyO2Rj5Ct8HqA29gzkEiGFSS0fGfbiaQIxAHr8geehqXC3hpJbVhRQEI8lphx4stdAO4PEDqP7p+CSWtcxR7XTegH9Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773849636; c=relaxed/simple;
	bh=dPbKT25C4GPcI3JtqDUYqqKrB12KKuXMc+HZEx8dtyI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HdaNZRh8V4u0AURQoyq1ADFMrzvTMNNJPC34H3sylC5JuuYeQbLnB9Q2l3CdiC2CGVU1cFgSVi3kDPSbjyQvBHnNcIDqTto8wYP9GBf81FP82MY4R9LV2WcXDeMC86PVosaq9xWbZMZd5hzuo8zBhkInU8QMDOHhG1yeBMC+DRY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lnUpsYZw; arc=pass smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lnUpsYZw"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-5091ed02c54so687891cf.1
        for <target-devel@vger.kernel.org>; Wed, 18 Mar 2026 09:00:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773849627; cv=none;
        d=google.com; s=arc-20240605;
        b=JbqlWKFg9k3ZqRKhh3V+QcvEYZWFOC+izoo3kOnyepSP+bZaR2z3alfaJ5OSW/mT+e
         HT5UckHnkHg+wvVBbQ81egDFvjGe6kQJOCtu2O3VW+UW0zcATGjarSoL76TDH3oVpnby
         6AAD4gD9+bpDmEc4z0YWI+Hv6efJDRoa4cfqJTY38r+WyGbOWi3yZEavmTWocm++5Tmz
         DQW1aEMT6web3/grWH6PlwuxtPtVo2iMB6xfEnZ+DreScr+a2zIVXlc5fLKf9qRXuLcf
         kSU3mVqInUYyOxtwumotzyklc5dFzegY0C6w96sLEfnHKgQVPXEjedj1UnG5pF/38GVI
         9j6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8q0J7KCNx+A8Y+J2RSy7VQj65zrNoynNXfOuxxJlza4=;
        fh=OqUYZRNrk+yC99OjnF7ZHrzoEIHQVz3aTwWbf2Pxsq0=;
        b=PiNCZxy1p7b8W4HGdzdoq3FsnNa07PVm0BAHZWFuh5TzNwgOiFke6U5H5mEy4Ck0Uv
         36hW2DKVsBMoCKyE8Bg9mmNdKi1nF6L+gtmcrdKb0/OcmZJ0+wfF9lnKyC5qvEl6Wbtw
         SAETbp0Kfs8kWxesszs/EtVFI6lOW5nY56arRum/uIy8+iHUM7mFd1nT5acJ7M8XNG1y
         2oS/zehgd672QzMTgg+ex3mmDzf7wbVvhtolRuKBKIUiLmc6jz3rJpyWvz6tr8Hi4NtX
         n08apl0ZvXZtHEjAPgv6Th6jf2dQoCGgJuG/y7WQEynnZgccn+9Ng2G0H2kLSxXjEtWt
         lq0A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773849627; x=1774454427; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8q0J7KCNx+A8Y+J2RSy7VQj65zrNoynNXfOuxxJlza4=;
        b=lnUpsYZwWf6Ngn/dqPOq7iQ1HVijjDPBZhgwYESz9kfeLT/BZxbGPpEe/4D4KnGWPr
         kCCPmUNpyoC+BM+S0/AilDKxE8o1CD/tQVzgZ8m85n+tmTvRkDDUKqDbBpQ8uzK/xkwW
         krD3uuyiCYETL1cqk2fqid6RWjt8z8Yb3OG2zujBT/hOWReYHF+pLdi9roOdVeHzcsuA
         QJXe02qdxmtUe6YfR1NFuqn15NuHUpLmj9pNFJwoHIswo1qAJhFVz7jWYhedR8di+XVA
         5cqovfkCv1bJUZki95dI8il97zlBON76NQtpQB/JdBHgAIOrN5FGHw4Hm9tEDrXxvpNu
         Ytgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773849627; x=1774454427;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8q0J7KCNx+A8Y+J2RSy7VQj65zrNoynNXfOuxxJlza4=;
        b=bE3V6dLVvqjXs3WEeUjFyI4n96IhWv+bg24kZ7C7+2w/4+XoEjitXzXebWJXoOqRyM
         U2mS03KMSimqWICebX+rJ6dF1iGagRJ2Z7nCwFA+4Wl9bY47uX4enWGhX8p5LgtSRuFO
         HgD+mdgpkMFUp8YOYiWSOTNowFa9BpyIZ1a9PvzaqwUZp0u4hgS5krjeD2Adyt3KfHqf
         P3FEN7I89V0gDKpwcOM8MJigYkYr8Rb+ibj6omWHUZEqp4KMlCBQmChwP/XxA8GIrT4v
         16JqEQsKkuaG5gdpyio8J7GhDDan4LMWCEIEKZh+4eK3OUtm7mYVuuuRRbKLWZKHElcu
         gD8Q==
X-Forwarded-Encrypted: i=1; AJvYcCUhUR9NrksL5RwG5jybwr8sJpM/GYIdPMhqkkJiozAf+gSNUtX0h+SWvKT26FLQ4H9c4h2GJJ6GJmHdveI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxerhcxyIhyc/Mn/SHYO3IpSSqZHl/mH/T0QEa6PWtSOKLib4OP
	qVYfkbAb0t09tYHWAWfNxA9c2+vA1Qr2owDvISE7aSylEi2FaABoU5XgdOjC1g3Ruw9wrz0CodJ
	tRUFJrDTogsaXiHHP/KV2WU+DsedCJUzd5EV89UDo
X-Gm-Gg: ATEYQzx7UpcTRLbt8WhQx6bIPN69l8hkVeMezIf0JTNDVWGIYJQfT/bbEOjDkcHOQXg
	eI6jOvnJkU3DMUKtUtnSyVXKI9SM78zWMY1uBLrA1ZVQU/dOYRJoZIy2DcTEtIb9c6FCjHlQsvB
	WAwy2rU7LF6q57BTLIizZLz58NyWJwJ5ZiUClAkz200bRh+va7jQe2ce7rihc5kI4XuevUw4yhg
	eNJACyhoyP1inYlT2Vb4decePWTM1U8ppwka8sive2KCgR5SmsXMJ3pcogvYQH4LkE6ZEjTD8UK
	ZRyBriVUMpIg2DTN3WIQHSrTLU5+XeS1qsGM9A==
X-Received: by 2002:ac8:7f4d:0:b0:509:174d:3224 with SMTP id
 d75a77b69052e-50b15c109d1mr14316251cf.11.1773849625679; Wed, 18 Mar 2026
 09:00:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1773695307.git.ljs@kernel.org> <8e28e4b63bae67bfa1a59ccbac9dc6db1442d75d.1773695307.git.ljs@kernel.org>
In-Reply-To: <8e28e4b63bae67bfa1a59ccbac9dc6db1442d75d.1773695307.git.ljs@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 18 Mar 2026 09:00:13 -0700
X-Gm-Features: AaiRm51xXcSMS3sQHOtwlzL9JQsE-2S39fLY5xwjkClhFBo1kCA372O2Zp37zjU
Message-ID: <CAJuCfpF6eS18HLgNvQtkLGd=7N0_L1JPmF0GzM-Z0QimRWT7AQ@mail.gmail.com>
Subject: Re: [PATCH v2 15/16] mm: add mmap_action_map_kernel_pages[_full]()
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

On Mon, Mar 16, 2026 at 2:14=E2=80=AFPM Lorenzo Stoakes (Oracle) <ljs@kerne=
l.org> wrote:
>
> A user can invoke mmap_action_map_kernel_pages() to specify that the
> mapping should map kernel pages starting from desc->start of a specified
> number of pages specified in an array.
>
> In order to implement this, adjust mmap_action_prepare() to be able to
> return an error code, as it makes sense to assert that the specified
> parameters are valid as quickly as possible as well as updating the VMA
> flags to include VMA_MIXEDMAP_BIT as necessary.
>
> This provides an mmap_prepare equivalent of vm_insert_pages().
>
> We additionally update the existing vm_insert_pages() code to use
> range_in_vma() and add a new range_in_vma_desc() helper function for the
> mmap_prepare case, sharing the code between the two in range_is_subset().
>
> We add both mmap_action_map_kernel_pages() and
> mmap_action_map_kernel_pages_full() to allow for both partial and full VM=
A
> mappings.
>
> We also add mmap_action_map_kernel_pages_discontig() to allow for
> discontiguous mapping of kernel pages should the need arise.
>
> We update the documentation to reflect the new features.
>
> Finally, we update the VMA tests accordingly to reflect the changes.
>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

With one nit,
Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  Documentation/filesystems/mmap_prepare.rst |  8 ++
>  include/linux/mm.h                         | 95 +++++++++++++++++++++-
>  include/linux/mm_types.h                   |  7 ++
>  mm/memory.c                                | 42 +++++++++-
>  mm/util.c                                  |  6 ++
>  tools/testing/vma/include/dup.h            |  7 ++
>  6 files changed, 159 insertions(+), 6 deletions(-)
>
> diff --git a/Documentation/filesystems/mmap_prepare.rst b/Documentation/f=
ilesystems/mmap_prepare.rst
> index be76ae475b9c..e810aa4134eb 100644
> --- a/Documentation/filesystems/mmap_prepare.rst
> +++ b/Documentation/filesystems/mmap_prepare.rst
> @@ -156,5 +156,13 @@ pointer. These are:
>  * mmap_action_simple_ioremap() - Sets up an I/O remap from a specified
>    physical address and over a specified length.
>
> +* mmap_action_map_kernel_pages() - Maps a specified array of `struct pag=
e`
> +  pointers in the VMA from a specific offset.
> +
> +* mmap_action_map_kernel_pages_full() - Maps a specified array of `struc=
t
> +  page` pointers over the entire VMA. The caller must ensure there are
> +  sufficient entries in the page array to cover the entire range of the
> +  described VMA.
> +
>  **NOTE:** The ``action`` field should never normally be manipulated dire=
ctly,
>  rather you ought to use one of these helpers.
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index df8fa6e6402b..6f0a3edb24e1 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2912,7 +2912,7 @@ static inline bool folio_maybe_mapped_shared(struct=
 folio *folio)
>   * The caller must add any reference (e.g., from folio_try_get()) it mig=
ht be
>   * holding itself to the result.
>   *
> - * Returns the expected folio refcount.
> + * Returns: the expected folio refcount.

nit: I see both "Returns:" and "Return:" being used in the codebase
but this header file uses "Return:", so for consistency you should
probably do the same. This also applies to later instances in this
patch.

>   */
>  static inline int folio_expected_ref_count(const struct folio *folio)
>  {
> @@ -4364,6 +4364,45 @@ static inline void mmap_action_simple_ioremap(stru=
ct vm_area_desc *desc,
>         action->type =3D MMAP_SIMPLE_IO_REMAP;
>  }
>
> +/**
> + * mmap_action_map_kernel_pages - helper for mmap_prepare hook to specif=
y that
> + * @num kernel pages contained in the @pages array should be mapped to u=
serland
> + * starting at virtual address @start.
> + * @desc: The VMA descriptor for the VMA requiring kernel pags to be map=
ped.
> + * @start: The virtual address from which to map them.
> + * @pages: An array of struct page pointers describing the memory to map=
.
> + * @nr_pages: The number of entries in the @pages aray.
> + */
> +static inline void mmap_action_map_kernel_pages(struct vm_area_desc *des=
c,
> +               unsigned long start, struct page **pages,
> +               unsigned long nr_pages)
> +{
> +       struct mmap_action *action =3D &desc->action;
> +
> +       action->type =3D MMAP_MAP_KERNEL_PAGES;
> +       action->map_kernel.start =3D start;
> +       action->map_kernel.pages =3D pages;
> +       action->map_kernel.nr_pages =3D nr_pages;
> +       action->map_kernel.pgoff =3D desc->pgoff;
> +}
> +
> +/**
> + * mmap_action_map_kernel_pages_full - helper for mmap_prepare hook to s=
pecify that
> + * kernel pages contained in the @pages array should be mapped to userla=
nd
> + * from @desc->start to @desc->end.
> + * @desc: The VMA descriptor for the VMA requiring kernel pags to be map=
ped.
> + * @pages: An array of struct page pointers describing the memory to map=
.
> + *
> + * The caller must ensure that @pages contains sufficient entries to cov=
er the
> + * entire range described by @desc.
> + */
> +static inline void mmap_action_map_kernel_pages_full(struct vm_area_desc=
 *desc,
> +               struct page **pages)
> +{
> +       mmap_action_map_kernel_pages(desc, desc->start, pages,
> +                                    vma_desc_pages(desc));
> +}
> +
>  int mmap_action_prepare(struct vm_area_desc *desc);
>  int mmap_action_complete(struct vm_area_struct *vma,
>                          struct mmap_action *action);
> @@ -4380,10 +4419,59 @@ static inline struct vm_area_struct *find_exact_v=
ma(struct mm_struct *mm,
>         return vma;
>  }
>
> +/**
> + * range_is_subset - Is the specified inner range a subset of the outer =
range?
> + * @outer_start: The start of the outer range.
> + * @outer_end: The exclusive end of the outer range.
> + * @inner_start: The start of the inner range.
> + * @inner_end: The exclusive end of the inner range.
> + *
> + * Returns: %true if [inner_start, inner_end) is a subset of [outer_star=
t,
> + * outer_end), otherwise %false.
> + */
> +static inline bool range_is_subset(unsigned long outer_start,
> +                                  unsigned long outer_end,
> +                                  unsigned long inner_start,
> +                                  unsigned long inner_end)
> +{
> +       return outer_start <=3D inner_start && inner_end <=3D outer_end;
> +}
> +
> +/**
> + * range_in_vma - is the specified [@start, @end) range a subset of the =
VMA?
> + * @vma: The VMA against which we want to check [@start, @end).
> + * @start: The start of the range we wish to check.
> + * @end: The exclusive end of the range we wish to check.
> + *
> + * Returns: %true if [@start, @end) is a subset of [@vma->vm_start,
> + * @vma->vm_end), %false otherwise.
> + */
>  static inline bool range_in_vma(const struct vm_area_struct *vma,
>                                 unsigned long start, unsigned long end)
>  {
> -       return (vma && vma->vm_start <=3D start && end <=3D vma->vm_end);
> +       if (!vma)
> +               return false;
> +
> +       return range_is_subset(vma->vm_start, vma->vm_end, start, end);
> +}
> +
> +/**
> + * range_in_vma_desc - is the specified [@start, @end) range a subset of=
 the VMA
> + * described by @desc, a VMA descriptor?
> + * @desc: The VMA descriptor against which we want to check [@start, @en=
d).
> + * @start: The start of the range we wish to check.
> + * @end: The exclusive end of the range we wish to check.
> + *
> + * Returns: %true if [@start, @end) is a subset of [@desc->start, @desc-=
>end),
> + * %false otherwise.
> + */
> +static inline bool range_in_vma_desc(const struct vm_area_desc *desc,
> +                                    unsigned long start, unsigned long e=
nd)
> +{
> +       if (!desc)
> +               return false;
> +
> +       return range_is_subset(desc->start, desc->end, start, end);
>  }
>
>  #ifdef CONFIG_MMU
> @@ -4427,6 +4515,9 @@ int remap_pfn_range(struct vm_area_struct *vma, uns=
igned long addr,
>  int vm_insert_page(struct vm_area_struct *, unsigned long addr, struct p=
age *);
>  int vm_insert_pages(struct vm_area_struct *vma, unsigned long addr,
>                         struct page **pages, unsigned long *num);
> +int map_kernel_pages_prepare(struct vm_area_desc *desc);
> +int map_kernel_pages_complete(struct vm_area_struct *vma,
> +                             struct mmap_action *action);
>  int vm_map_pages(struct vm_area_struct *vma, struct page **pages,
>                                 unsigned long num);
>  int vm_map_pages_zero(struct vm_area_struct *vma, struct page **pages,
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 7538d64f8848..c46224020a46 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -815,6 +815,7 @@ enum mmap_action_type {
>         MMAP_REMAP_PFN,         /* Remap PFN range. */
>         MMAP_IO_REMAP_PFN,      /* I/O remap PFN range. */
>         MMAP_SIMPLE_IO_REMAP,   /* I/O remap with guardrails. */
> +       MMAP_MAP_KERNEL_PAGES,  /* Map kernel page range from array. */
>  };
>
>  /*
> @@ -833,6 +834,12 @@ struct mmap_action {
>                         phys_addr_t start_phys_addr;
>                         unsigned long size;
>                 } simple_ioremap;
> +               struct {
> +                       unsigned long start;
> +                       struct page **pages;
> +                       unsigned long nr_pages;
> +                       pgoff_t pgoff;
> +               } map_kernel;
>         };
>         enum mmap_action_type type;
>
> diff --git a/mm/memory.c b/mm/memory.c
> index f3f4046aee97..849d5d9eeb83 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2484,13 +2484,14 @@ static int insert_pages(struct vm_area_struct *vm=
a, unsigned long addr,
>  int vm_insert_pages(struct vm_area_struct *vma, unsigned long addr,
>                         struct page **pages, unsigned long *num)
>  {
> -       const unsigned long end_addr =3D addr + (*num * PAGE_SIZE) - 1;
> +       const unsigned long nr_pages =3D *num;
> +       const unsigned long end =3D addr + PAGE_SIZE * nr_pages;
>
> -       if (addr < vma->vm_start || end_addr >=3D vma->vm_end)
> +       if (!range_in_vma(vma, addr, end))
>                 return -EFAULT;
>         if (!(vma->vm_flags & VM_MIXEDMAP)) {
> -               BUG_ON(mmap_read_trylock(vma->vm_mm));
> -               BUG_ON(vma->vm_flags & VM_PFNMAP);
> +               VM_WARN_ON_ONCE(mmap_read_trylock(vma->vm_mm));
> +               VM_WARN_ON_ONCE(vma->vm_flags & VM_PFNMAP);
>                 vm_flags_set(vma, VM_MIXEDMAP);
>         }
>         /* Defer page refcount checking till we're about to map that page=
. */
> @@ -2498,6 +2499,39 @@ int vm_insert_pages(struct vm_area_struct *vma, un=
signed long addr,
>  }
>  EXPORT_SYMBOL(vm_insert_pages);
>
> +int map_kernel_pages_prepare(struct vm_area_desc *desc)
> +{
> +       const struct mmap_action *action =3D &desc->action;
> +       const unsigned long addr =3D action->map_kernel.start;
> +       unsigned long nr_pages, end;
> +
> +       if (!vma_desc_test(desc, VMA_MIXEDMAP_BIT)) {
> +               VM_WARN_ON_ONCE(mmap_read_trylock(desc->mm));
> +               VM_WARN_ON_ONCE(vma_desc_test(desc, VMA_PFNMAP_BIT));
> +               vma_desc_set_flags(desc, VMA_MIXEDMAP_BIT);
> +       }
> +
> +       nr_pages =3D action->map_kernel.nr_pages;
> +       end =3D addr + PAGE_SIZE * nr_pages;
> +       if (!range_in_vma_desc(desc, addr, end))
> +               return -EFAULT;
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL(map_kernel_pages_prepare);
> +
> +int map_kernel_pages_complete(struct vm_area_struct *vma,
> +                             struct mmap_action *action)
> +{
> +       unsigned long nr_pages;
> +
> +       nr_pages =3D action->map_kernel.nr_pages;
> +       return insert_pages(vma, action->map_kernel.start,
> +                           action->map_kernel.pages,
> +                           &nr_pages, vma->vm_page_prot);
> +}
> +EXPORT_SYMBOL(map_kernel_pages_complete);
> +
>  /**
>   * vm_insert_page - insert single page into user vma
>   * @vma: user vma to map to
> diff --git a/mm/util.c b/mm/util.c
> index a166c48fe894..dea590e7a26c 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -1441,6 +1441,8 @@ int mmap_action_prepare(struct vm_area_desc *desc)
>                 return io_remap_pfn_range_prepare(desc);
>         case MMAP_SIMPLE_IO_REMAP:
>                 return simple_ioremap_prepare(desc);
> +       case MMAP_MAP_KERNEL_PAGES:
> +               return map_kernel_pages_prepare(desc);
>         }
>
>         WARN_ON_ONCE(1);
> @@ -1472,6 +1474,9 @@ int mmap_action_complete(struct vm_area_struct *vma=
,
>         case MMAP_IO_REMAP_PFN:
>                 err =3D io_remap_pfn_range_complete(vma, action);
>                 break;
> +       case MMAP_MAP_KERNEL_PAGES:
> +               err =3D map_kernel_pages_complete(vma, action);
> +               break;
>         case MMAP_SIMPLE_IO_REMAP:
>                 /*
>                  * The simple I/O remap should have been delegated to an =
I/O
> @@ -1494,6 +1499,7 @@ int mmap_action_prepare(struct vm_area_desc *desc)
>         case MMAP_REMAP_PFN:
>         case MMAP_IO_REMAP_PFN:
>         case MMAP_SIMPLE_IO_REMAP:
> +       case MMAP_MAP_KERNEL_PAGES:
>                 WARN_ON_ONCE(1); /* nommu cannot handle these. */
>                 break;
>         }
> diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/=
dup.h
> index 6658df26698a..4407caf207ad 100644
> --- a/tools/testing/vma/include/dup.h
> +++ b/tools/testing/vma/include/dup.h
> @@ -454,6 +454,7 @@ enum mmap_action_type {
>         MMAP_REMAP_PFN,         /* Remap PFN range. */
>         MMAP_IO_REMAP_PFN,      /* I/O remap PFN range. */
>         MMAP_SIMPLE_IO_REMAP,   /* I/O remap with guardrails. */
> +       MMAP_MAP_KERNEL_PAGES,  /* Map kernel page range from an array. *=
/
>  };
>
>  /*
> @@ -472,6 +473,12 @@ struct mmap_action {
>                         phys_addr_t start;
>                         unsigned long len;
>                 } simple_ioremap;
> +               struct {
> +                       unsigned long start;
> +                       struct page **pages;
> +                       unsigned long num;
> +                       pgoff_t pgoff;
> +               } map_kernel;
>         };
>         enum mmap_action_type type;
>
> --
> 2.53.0
>
