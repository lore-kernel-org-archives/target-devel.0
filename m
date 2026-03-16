Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD2D366562
	for <target-devel@vger.kernel.org>; Mon, 16 Mar 2026 22:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773701981; cv=pass; b=rQe23+87L297u+Gv0I6YFYsccR3o2kfw2HURrw9ELw/msJA/yTgafyt1oxducAelaS75qw0ALcV/ISQndEGDDrgE9fIgUk3lBcarMaVEc4I7IoeVyeZztNevqhDrrpOdwPJwI22tJUjn12CRihvQocxlYHSV/tQhvitK5tJoWGI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773701981; c=relaxed/simple;
	bh=n5yqztpjRLufPkj5VJdYxT7NEGdWEh93DgrTEzhQ/40=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oAEDMGpz0EM8yidV42Nptu8P9L3CgRy8njZMPqydC7jTtYp77j7jxQBxf6tREfX7lGej6zD3jWlZOoUUTuhtWOTifdCvZfXQJfBx23nDIm838lCcPFkvxzxAE5Vqqr3oVB7Eq6b1+5HljYP4mGT66/l1VSq61KixGspdNE0aqQY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DMh6LtIz; arc=pass smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DMh6LtIz"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-50906a98ffeso251451cf.0
        for <target-devel@vger.kernel.org>; Mon, 16 Mar 2026 15:59:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773701978; cv=none;
        d=google.com; s=arc-20240605;
        b=D0HMrYNJWnspVg5zcJIfBeietoKZqAmlB09wGiooyX5K1QJmiy4V1/gkmrBL93BYv3
         VYTpu7cj1dWCKBWUmXTnrdli93CfCcXuGVdLb1erniQZloDGpiI6i0YujDj/vJk4hZvB
         kouzNyh3d4sfXHTwgYgxg+tDAsT0dpznh+1g+5urVSDdM2v5XTrmef4ev1GlytC+hM1w
         eEAaJZQxakp+PYleBLd6oEO71KoOLBpCGmOgocnIVg9V2HqA+631XzpuxgoqGaxJjWPp
         TfuJj5vnHi1Zsh1CBuvU4P58+A6WNq4Qx15V+CouGJ1Hq+MoEdn4C04HgiXRkli1PRjl
         hsqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Q4cJcFtf4hpm0T0e+VviEvUx2ruLtbnKyeEs5ldKrcs=;
        fh=Pduo+C9ARdXt12VM+ZHZ6g0SfbT0RsSy5+5pxn7WZpc=;
        b=K560kcDLVy5tNAx2NbxHlhhe9N7ClUEjY165EOtZjXRpuq1K7/W0PcPrbKJ2SOzDmG
         nDSr5ju9r7iKYC37i9SlPVFRe3ctQxDTPdgRYpuE2AYwuVXmulZoVtH6czzhMrpXqF8t
         tJ73HW2SB3H5DyxVBQIsB1eLh6cG48eT3d97XVlzuObAE9IrdInck4QX3Lmhy7i/tmil
         6O81NP935TMrDpzmH740JHDZavjMUHyd7MkKKZ8E9f+2ADbaHSmPqR/3v/8gbKmezcsi
         Y18oHt7oPzA+wNnjy8H4fNjU/0QUkI8eWVlXPhxjVKuv9xqJMfdI4HDjcKbe+/acuYhG
         kFdQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773701978; x=1774306778; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q4cJcFtf4hpm0T0e+VviEvUx2ruLtbnKyeEs5ldKrcs=;
        b=DMh6LtIzSVg4b4oelvmsNsDfbzbWWsMFFLbjMmv/YlM02GhO16UEdWQZg6lkAWRPiY
         e1b0KmY3hHsxDAB3vmpZRocTb7NTd5tHB/ikcd4xsxBL5ldcfp1KOJcM0VpyFU2AHvh4
         4uAdbzOZDE8uME31qR4W+uzm6Lwmwy2dZvyHFo2Rvt0dl5/tGGx2rGVR0o33Shwynwvr
         usSOa+82hpfddhkC5h1VRXC3VG8AwpLJ6dprpIWAojy9ZSikFkE8q9NMDEUo9lluWdWH
         bYJ5XaoPqjjoP33My/z3yFOUMrxZ9H5m7N826oNInydhwQo/asZ6I6F/C8NerdVOsS7o
         L/qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773701978; x=1774306778;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q4cJcFtf4hpm0T0e+VviEvUx2ruLtbnKyeEs5ldKrcs=;
        b=PjiZhIj1JdlzL3dZQ7WakueHJnqGQzXC/qXfFiM6BvKmtiXSAy3sE3hrqRkuhqiE2J
         MWyRvrY711pWtM7ubW+6/7emWsZkMce4JzMqEFKG36OX3oXVqWN3MUIA12d/YJazPQTG
         OZ1uDmBZsMMjD0Zc4lxN2ppabgrrnVsPd4WuLy6eDhIwBoCFQnO3zwL0eqIQR4QRMbkP
         6i1Syt36EuGcffB3USF4BW7FusO4NVgov03vsljHLmw2MbogXsVT/eIvdWroZroIYDcZ
         cYhDNm27NJAj4RAv5TkXSvAxGnbAUNmoDWSQgDFRLg0jyT+qEFw0AVgjcuohvlRtSwk2
         DUXQ==
X-Forwarded-Encrypted: i=1; AJvYcCUaeE91hTbeeDBzwz/d4WP19ExBtUfFn4B5qBxfleABUrCL5tnTXkSOakL1mvUfzxKSh/sbozHZsvXC2Og=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+jCADqG6r4yBjle5OcvmjQ1H8TSz04izfpPzHCgrL0lFPiD1j
	1SViHGRVxuxI2zkJJbit4ZFBYVS1dy0bwKaKmqdhXz9S1cvpqQGjcnlJKfcorqgme+ruNFobEKm
	s2ITj5U2F5vSATB9MOW72zIYhyVMn2ALQKMb0hM4n
X-Gm-Gg: ATEYQzzdAT+n+oruLQAc/qGNKm/LD/bvv7M0MCeXJ0Vo37hsi/xSuib9KEFIVyYP9ST
	cMMPPkgt72EesuvDSsJxmxq9FKmHnsnrPf5xiLo79+cTm4PDskP6P27ey7FNj/RJQNyJtpUmfls
	icF8ynRexihto26zJJHAj7fLQUPrh/o8XYL2Hw0PsooS8epf++PxMrisr5HylGiqrMuU2O4tQib
	VnuHrVbbDG9lyq4ieq3U0MXxp4xOzsnnJYKZyNh2WGN7zVFy/aAUD71KABo2WttFKKoClWSIjA/
	5UKRu0hyKm+BxTjE
X-Received: by 2002:ac8:5e12:0:b0:4f3:54eb:f26e with SMTP id
 d75a77b69052e-5099ac78738mr2798501cf.1.1773701977490; Mon, 16 Mar 2026
 15:59:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1773346620.git.ljs@kernel.org> <c5bb61cf789df1ecb32facc29df9749987c7ddfc.1773346620.git.ljs@kernel.org>
 <CAJuCfpGd702=Xop3X5Aop9rrScdiAOQEEooTu1gcJqR9pmO5GA@mail.gmail.com> <6a0e73a5-519e-49ca-9f76-2f6cc5a1577c@lucifer.local>
In-Reply-To: <6a0e73a5-519e-49ca-9f76-2f6cc5a1577c@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 16 Mar 2026 15:59:26 -0700
X-Gm-Features: AaiRm5118TD3MF16DHCGoLHkzYMnffHjhVhwrz0uUgfCnERLy0ui_OLbleubf-w
Message-ID: <CAJuCfpEjTw1nQik_HWXHg2su2DwzPrn5NPGpeAVPrjJK0tOSkg@mail.gmail.com>
Subject: Re: [PATCH 02/15] mm: add documentation for the mmap_prepare file
 operation callback
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

On Mon, Mar 16, 2026 at 12:17=E2=80=AFPM Lorenzo Stoakes (Oracle)
<ljs@kernel.org> wrote:
>
> On Sun, Mar 15, 2026 at 04:23:14PM -0700, Suren Baghdasaryan wrote:
> > On Thu, Mar 12, 2026 at 1:27=E2=80=AFPM Lorenzo Stoakes (Oracle) <ljs@k=
ernel.org> wrote:
> > >
> > > This documentation makes it easier for a driver/file system implement=
er to
> > > correctly use this callback.
> > >
> > > It covers the fundamentals, whilst intentionally leaving the less lov=
ely
> > > possible actions one might take undocumented (for instance - the
> > > success_hook, error_hook fields in mmap_action).
> > >
> > > The document also covers the new VMA flags implementation which is th=
e only
> > > one which will work correctly with mmap_prepare.
> > >
> > > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> > > ---
> > >  Documentation/filesystems/mmap_prepare.rst | 131 +++++++++++++++++++=
++
> > >  1 file changed, 131 insertions(+)
> > >  create mode 100644 Documentation/filesystems/mmap_prepare.rst
> > >
> > > diff --git a/Documentation/filesystems/mmap_prepare.rst b/Documentati=
on/filesystems/mmap_prepare.rst
> > > new file mode 100644
> > > index 000000000000..76908200f3a1
> > > --- /dev/null
> > > +++ b/Documentation/filesystems/mmap_prepare.rst
> > > @@ -0,0 +1,131 @@
> > > +.. SPDX-License-Identifier: GPL-2.0
> > > +
> > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> > > +mmap_prepare callback HOWTO
> > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> > > +
> > > +Introduction
> > > +############
> > > +
> > > +The `struct file->f_op->mmap()` callback has been deprecated as it i=
s both a
> > > +stability and security risk, and doesn't always permit the merging o=
f adjacent
> > > +mappings resulting in unnecessary memory fragmentation.
> > > +
> > > +It has been replaced with the `file->f_op->mmap_prepare()` callback =
which solves
> > > +these problems.
> > > +
> > > +## How To Use
> > > +
> > > +In your driver's `struct file_operations` struct, specify an `mmap_p=
repare`
> > > +callback rather than an `mmap` one, e.g. for ext4:
> > > +
> > > +
> > > +.. code-block:: C
> > > +
> > > +    const struct file_operations ext4_file_operations =3D {
> > > +        ...
> > > +        .mmap_prepare    =3D ext4_file_mmap_prepare,
> > > +    };
> > > +
> > > +This has a signature of `int (*mmap_prepare)(struct vm_area_desc *)`=
.
> > > +
> > > +Examining the `struct vm_area_desc` type:
> > > +
> > > +.. code-block:: C
> > > +
> > > +    struct vm_area_desc {
> > > +        /* Immutable state. */
> > > +        const struct mm_struct *const mm;
> > > +        struct file *const file; /* May vary from vm_file in stacked=
 callers. */
> > > +        unsigned long start;
> > > +        unsigned long end;
> > > +
> > > +        /* Mutable fields. Populated with initial state. */
> > > +        pgoff_t pgoff;
> > > +        struct file *vm_file;
> > > +        vma_flags_t vma_flags;
> > > +        pgprot_t page_prot;
> > > +
> > > +        /* Write-only fields. */
> > > +        const struct vm_operations_struct *vm_ops;
> > > +        void *private_data;
> > > +
> > > +        /* Take further action? */
> > > +        struct mmap_action action;
> >
> > So, action still belongs to /* Write-only fields. */ section? This is
> > nitpicky, but it might be better to have this as:
> >
> >         /* Write-only fields. */
> >         const struct vm_operations_struct *vm_ops;
> >         void *private_data;
> >         struct mmap_action action; /* Take further action? */
>
> Absolutely not. This field is not to be written to by the user.
>
> We sadly have to allow hugetlb to do some hacks, but these are things we =
don't
> want to point out.

Ack.

>
> Users should use mmap_action_xxx() functions.
>
> >
> > > +    };
> > > +
> > > +This is straightforward - you have all the fields you need to set up=
 the
> > > +mapping, and you can update the mutable and writable fields, for ins=
tance:
> > > +
> > > +.. code-block:: Cw
> > > +
> > > +    static int ext4_file_mmap_prepare(struct vm_area_desc *desc)
> > > +    {
> > > +        int ret;
> > > +        struct file *file =3D desc->file;
> > > +        struct inode *inode =3D file->f_mapping->host;
> > > +
> > > +        ...
> > > +
> > > +        file_accessed(file);
> > > +        if (IS_DAX(file_inode(file))) {
> > > +            desc->vm_ops =3D &ext4_dax_vm_ops;
> > > +            vma_desc_set_flags(desc, VMA_HUGEPAGE_BIT);
> > > +        } else {
> > > +            desc->vm_ops =3D &ext4_file_vm_ops;
> > > +        }
> > > +        return 0;
> > > +    }
> > > +
> > > +Importantly, you no longer have to dance around with reference count=
s or locks
> > > +when updating these fields - __you can simply go ahead and change th=
em__.
> > > +
> > > +Everything is taken care of by the mapping code.
> > > +
> > > +VMA Flags
> > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > +
> > > +Along with `mmap_prepare`, VMA flags have undergone an overhaul. Whe=
re before
> > > +you would invoke one of `vm_flags_init()`, `vm_flags_reset()`, `vm_f=
lags_set()`,
> > > +`vm_flags_clear()`, and `vm_flags_mod()` to modify flags (and to hav=
e the
> > > +locking done correctly for you, this is no longer necessary.
> > > +
> > > +Also, the legacy approach of specifying VMA flags via `VM_READ`, `VM=
_WRITE`,
> > > +etc. - i.e. using a `VM_xxx` macro has changed too.
> > > +
> > > +When implementing `mmap_prepare()`, reference flags by their bit num=
ber, defined
> > > +as a `VMA_xxx_BIT` macro, e.g. `VMA_READ_BIT`, `VMA_WRITE_BIT` etc.,=
 and use one
> > > +of (where `desc` is a pointer to `struct vma_area_desc`):
> > > +
> > > +* `vma_desc_test_flags(desc, ...)` - Specify a comma-separated list =
of flags you
> > > +  wish to test for (whether _any_ are set), e.g. - `vma_desc_test_fl=
ags(desc,
> > > +  VMA_WRITE_BIT, VMA_MAYWRITE_BIT)` - returns `true` if either are s=
et,
> > > +  otherwise `false`.
> > > +* `vma_desc_set_flags(desc, ...)` - Update the VMA descriptor flags =
to set
> > > +  additional flags specified by a comma-separated list,
> > > +  e.g. - `vma_desc_set_flags(desc, VMA_PFNMAP_BIT, VMA_IO_BIT)`.
> > > +* `vma_desc_clear_flags(desc, ...)` - Update the VMA descriptor flag=
s to clear
> > > +  flags specified by a comma-separated list, e.g. - `vma_desc_clear_=
flags(desc,
> > > +  VMA_WRITE_BIT, VMA_MAYWRITE_BIT)`.
> > > +
> > > +Actions
> > > +=3D=3D=3D=3D=3D=3D=3D
> > > +
> > > +You can now very easily have actions be performed upon a mapping onc=
e set up by
> > > +utilising simple helper functions invoked upon the `struct vm_area_d=
esc`
> > > +pointer. These are:
> > > +
> > > +* `mmap_action_remap()` - Remaps a range consisting only of PFNs for=
 a specific
> > > +  range starting a virtual address and PFN number of a set size.
> > > +
> > > +* `mmap_action_remap_full()` - Same as `mmap_action_remap()`, only r=
emaps the
> > > +  entire mapping from `start_pfn` onward.
> > > +
> > > +* `mmap_action_ioremap()` - Same as `mmap_action_remap()`, only perf=
orms an I/O
> > > +  remap.
> > > +
> > > +* `mmap_action_ioremap_full()` - Same as `mmap_action_ioremap()`, on=
ly remaps
> > > +  the entire mapping from `start_pfn` onward.
> > > +
> > > +**NOTE:** The 'action' field should never normally be manipulated di=
rectly,
> > > +rather you ought to use one of these helpers.
> >
> > I'm guessing the start and size parameters passed to
> > mmap_action_remap() and such are restricted by vm_area_desc.start
> > vm_area_desc.end. If so, should we document those restrictions and
> > enforce them in the code?
>
> I mean it's the same restrictions as all of the functions already apply i=
f you
> were to use them with a VMA descriptor.
>
> I think implicitly a remap will fail if you try it out of the VMA range a=
t the
> point of applying the change.
>
> But it might be worth adding range_in_vma_desc() checks at prepare time, =
will
> see if I can do that for the respin.
>
> I think it's pretty obvious that you shouldn't be trying to remap totally
> unrelated memory, so I'm not sure that's at a level of granularity that's=
 suited
> to this document though.

I just saw you already have WARN_ON_ONCE() inside mmap_action_remap()
to check for these limits, so codewise I think we are already good.

For documentation I'll rely on your judgement whether to mention this or no=
t.

>
> >
> > > +    struct vm_area_desc {
> > > +        /* Immutable state. */
> > > +        const struct mm_struct *const mm;
> > > +        struct file *const file; /* May vary from vm_file in stacked=
 callers. */
> > > +        unsigned long start;
> > > +        unsigned long end;
> >
> >
> > > --
> > > 2.53.0
> > >
