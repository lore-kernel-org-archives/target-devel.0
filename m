Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C0BDF76
	for <target-devel@vger.kernel.org>; Mon, 16 Mar 2026 00:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773621838; cv=pass; b=YJleiJzP+lsCLKxiOW/1RTFTgxjW+0O9W0hRynUH5gBdOoTK+91XxUhwfEqjL7fUYasiMdZZ9XSfHC3X3Y493JuZyUtz7As6VHXARWB5bf3a7qMdAuaoXP9gf4Z/UpVp3eL8OZ1x8vztGYb+JIYiLxWH7sQZ2tm6fGfbH3tWvu0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773621838; c=relaxed/simple;
	bh=7LEG6GSfAF3VAhLmKNS+zMMoXAkVfIwRn9mYIfi1rWQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kYTqugXvgSiNsrQNy77ZgV5XFfa+MpxNlVXzEEmgCxh16WXlSqPwJij39uXKn2y5hWabR8hMvjbhncA/iJpZMDLvCXrVy6F0Vp2aUpy30StU4Wh4bhUpiPB3CpitHhnbwP52T/zGSppyZTvR81bfy8WJoLxBzWBN+l3p20jgIe0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bISgmRPH; arc=pass smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bISgmRPH"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-509062d829dso680051cf.1
        for <target-devel@vger.kernel.org>; Sun, 15 Mar 2026 17:43:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773621834; cv=none;
        d=google.com; s=arc-20240605;
        b=MnljYq2++CanbVPkisuZcfTSk6S/BtMDFcl+Ss3wlg3n8phfu4gVnzcVoOnmj0Rl+C
         Pz+taTs90PP3Yn31SAD41mRJQddv09xZZ3f4ji6zUf9WT0np9LAWA59FiI/SkCZ0a4Ap
         YZb/MW/NoZ6y+Ac2o2sJthcBhkgrS2y1q+ac3DxEz9envkZDYXCAYz38XQVuxIlX/FuY
         tK8ty65u1YMbCuXtcqqYp9wuC/49KY3/Qd6aJA7Wks6ky3zI2RJs4ji+fsOGfMps0ydp
         xx2D0Qqo3gxR168pMcbrdHjAPRfDpq1V7gAozE5g/SXJQ0DBfNSLdjMeDIQHbfcJDvaw
         mXaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=B4iLbVdU6UwNcjWJZqb9n6er3BcFb6HsfZvwCgpauBo=;
        fh=k3fVGPH7gq1AEk8SfeY7A64TYBgtCMzF8/ntbjy2pJs=;
        b=VXvJ/JbulDhmOUihEFJNSjNj8fNgu2XyaOLXjC/j20GfhInq3ME9xYpoBTmKmDvIBS
         PF1beYMamddofbmm2IXyy7NYZnWHZhJNzcA9UsTS/lKy8hU19almjZxi5T6bJ3qzWEoz
         jOfg8Eys44Ffkta/cGfUUsIH7QyX/ezNv039/xLkYs6WH1ZD9PolXIoYQ9c898BoPOKN
         DuQYOq3IjsFKnYSKHvj5vQ7rp5WMfdsIMOOuPfdH/vI37JEbieEqtj0axfOZJhyTl6Ln
         gk3uQitco6Pf7OJQj1a8hy9cWleodCOm8o0nFuS50aT682pKsGrmFBdGTpXyH6jzvX1N
         Mr5A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773621834; x=1774226634; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B4iLbVdU6UwNcjWJZqb9n6er3BcFb6HsfZvwCgpauBo=;
        b=bISgmRPHe1Sfdsvy6ngj1NvbPI5bCE4DfMr53m6zdg7zHA/OxjYsVgkGZ6mmp9AdYR
         gnlYG3eKj1cbFgEJrKs+y/ifQndl/7jdxcksA6ZyDvnvB0ptVSOL8mI5/wNl5TIIZCQr
         kkIn9S+93uEe7phvawobD7GXH8YDsDCrjsu6ubRO4YfCD0Vq17bZ1QDCx9UWyEOT6ab3
         i6sJcQSr8KI0VyUFZPfQC0VVAEssE2QJMPIBwT5CuK2BGhScJ4zFMWcGrbXmwoovk9Ab
         OhOnUEFAKyjD4ZV8Q4+5RXTrS8X7c61GaFvLviA+kMeb2dBiEpQdhPK2U4kVqS/79xXF
         NsLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773621834; x=1774226634;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=B4iLbVdU6UwNcjWJZqb9n6er3BcFb6HsfZvwCgpauBo=;
        b=F5VTtg52cYc3ubHf2Ekerm1iQQNr0YAZomhJc3YEYsmWu2xPG85NtjxVNsNk28U1Ft
         Jp4p2+F2HGfY4kXoIS4yVAlmClpCrSCrkOeJeH0pQ8O0uYCL4hcPrYYXbMv90dL0jT87
         9TtpzDHaUDpfkNpPoNaEwuWK8APEcbJlCoa8qulkMois7WIpc4cWY5ulmEFy4zaoM9LQ
         hYEaBoleIGIfWLHxhnFZr3hOhXpi+/qz3EOELT7RpQ1O1EUj0kqi/lnFMUkedCCdmJWY
         0125qFKPf6SWIQTJm/vlRdGxCsZpfFPB7FI8etLhUcgrf6BxVm8fN/U3L5LR3kO+qAFS
         kykA==
X-Forwarded-Encrypted: i=1; AJvYcCWrYVE464HuRWcAfR8wc82KdYeQTux1D3NoFXJ9+T8e2SgAS4VCCPXygOU/Uz1szyV9n5AKws0BAnEL0mY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwxiSaV0MHF4gQ/9g4fGowzQ/CRPxhJGpZ6OD77ZDYocj6Fybww
	pn3BdELBrKdgB9Fhy9PssuIRBs5l8ZcJ0iwQBHllRQscqr7SpsB9mWWrFph6o8Bag5y9wzcdrHi
	3+BLZZ7ZJJEV2lqfs2mxeE5bHj3nvZvoosiCGWZz1
X-Gm-Gg: ATEYQzyw/2of4UzTjjp+ZAveEASuSG6zMotAlCd9oCslztO4vEzSPLO78pc6Fvur9J+
	2NxNOgt+B3EfyN6t1wO0+kkCDf3NDccK1i7NQ6J1vmZ7nmhJEGdjeFsSC0+cXN59ADXfhEemvpc
	cvl0Sp5QERffP8zXEU1wCZkmwUAZmQvqOU11Af8KIWD1hPK8BdD2wA/rrpND38x5STjwQqJm5hU
	dbNVx822UWfDcJHhxyrfYVjeqqEclzaLP0fh45XpxlPS0cbRKwCcECfjqQtlh8CbiPZRUZk8Rjt
	b+HBbQ==
X-Received: by 2002:ac8:590e:0:b0:503:4bc:c925 with SMTP id
 d75a77b69052e-5096aa2ae2cmr17578141cf.13.1773621833001; Sun, 15 Mar 2026
 17:43:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1773346620.git.ljs@kernel.org> <52a7b9a003ea51521ab3c0baf30337a7800a3af7.1773346620.git.ljs@kernel.org>
In-Reply-To: <52a7b9a003ea51521ab3c0baf30337a7800a3af7.1773346620.git.ljs@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 15 Mar 2026 17:43:41 -0700
X-Gm-Features: AaiRm51H9IsCynzRpnxAc6_DrzYXD9cjd8fR558hmylwDQfMj5FrJzUnU5dorNw
Message-ID: <CAJuCfpHVN66abFrJgorXKBsjv7Ut=CP-E4NpLMC4SW613tJwtw@mail.gmail.com>
Subject: Re: [PATCH 03/15] mm: document vm_operations_struct->open the same as close()
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
> Describe when the operation is invoked and the context in which it is
> invoked, matching the description already added for vm_op->close().
>
> While we're here, update all outdated references to an 'area' field for
> VMAs to the more consistent 'vma'.
>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---
>  include/linux/mm.h | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index cc5960a84382..12a0b4c63736 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -748,15 +748,20 @@ struct vm_uffd_ops;
>   * to the functions called when a no-page or a wp-page exception occurs.
>   */
>  struct vm_operations_struct {
> -       void (*open)(struct vm_area_struct * area);
> +       /**
> +        * @open: Called when a VMA is remapped or split. Not called upon=
 first
> +        * mapping a VMA.

It's also called from dup_mmap() which is part of forking.

> +        * Context: User context.  May sleep.  Caller holds mmap_lock.
> +        */
> +       void (*open)(struct vm_area_struct *vma);
>         /**
>          * @close: Called when the VMA is being removed from the MM.
>          * Context: User context.  May sleep.  Caller holds mmap_lock.
>          */
> -       void (*close)(struct vm_area_struct * area);
> +       void (*close)(struct vm_area_struct *vma);
>         /* Called any time before splitting to check if it's allowed */
> -       int (*may_split)(struct vm_area_struct *area, unsigned long addr)=
;
> -       int (*mremap)(struct vm_area_struct *area);
> +       int (*may_split)(struct vm_area_struct *vma, unsigned long addr);
> +       int (*mremap)(struct vm_area_struct *vma);
>         /*
>          * Called by mprotect() to make driver-specific permission
>          * checks before mprotect() is finalised.   The VMA must not
> @@ -768,7 +773,7 @@ struct vm_operations_struct {
>         vm_fault_t (*huge_fault)(struct vm_fault *vmf, unsigned int order=
);
>         vm_fault_t (*map_pages)(struct vm_fault *vmf,
>                         pgoff_t start_pgoff, pgoff_t end_pgoff);
> -       unsigned long (*pagesize)(struct vm_area_struct * area);
> +       unsigned long (*pagesize)(struct vm_area_struct *vma);
>
>         /* notification that a previously read-only page is about to beco=
me
>          * writable, if an error is returned it will cause a SIGBUS */
> --
> 2.53.0
>
