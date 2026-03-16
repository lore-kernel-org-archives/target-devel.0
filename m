Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E7B1DFD96
	for <target-devel@vger.kernel.org>; Mon, 16 Mar 2026 23:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773704357; cv=pass; b=nyVK28IrkjKEiZAJ6sSp1L46w6gboNRkExZLp6zwhFbrsqdLbBV/mxhEDSiLp5sxEkgWOMql/pnmAmTFU+loG+MmcR53Hk0KO9TvJYSipkvgUD4e/KuGoVaA8OP9E5toQLLMZtQeb3S9RV+5jzenYG8ktop7D1XXNPkMMhCDatE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773704357; c=relaxed/simple;
	bh=WF2+lgqMgD1FnPP3kXftU34ziNhbWPLWbtQ6EokDtSk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NpredpVNjnM3VYvISEcnCe4rVM4Vfa0iFnvvFO/86H2xw89MO9m7P5hY3mxmVLu3gFgqFf6yPhVHsibKCfJZOiCNgBZlGquBIh4OwwfrCKZSbOYkEXxErDUl2JPnAM8cT9DVTTiMNiWX7hT2i5fErxABngsnxdlKSXLstuUIi+o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H0nB1Tj0; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H0nB1Tj0"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-5091ed02c54so108941cf.1
        for <target-devel@vger.kernel.org>; Mon, 16 Mar 2026 16:39:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773704353; cv=none;
        d=google.com; s=arc-20240605;
        b=W4n4DLdfUCw3S0cVDh2NyK0OvtfHFLzLnOIxVNp9ZvWheGqVvLuSwCovIfo4pv3dKR
         R+Lgflb0pDVoSIWbLpVmbnCLfz7V5cC5BUzM4tyOQ2vdZoKUYBXk93RZ7tNGtHlEGaAN
         v8Qx6bURmCqFtMUD3Q5y1ZjmhIxxfAc8xaTXhYBtMih3Losy+Vy/aHshvV1TbDNGxdeB
         WMtdiuFgJqwc6eruEXIg6skBVdYDeymwAYEO3qxVrRdHOfCU4IuA51yLN95KkyAgzCRT
         BxndByau+uhL7Ncd/np8AuawJMGFqenZlcVtW8AT3MvrWfHD5j6UIhKNiTmZiGfSZak3
         EPpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VwUHzKKpuzMgKlUaXpAb89AV8p2fq44hwffT/WJRTbU=;
        fh=U7XKET92ol8pqhUXLJezsgcs5gAwRwIuqkUZa6FF0FA=;
        b=E08+j0fGFNJqu6aEBcuTDXpDBYH9b5/cS+tPdXPQeYzXOAlCqv0M3wk4/Jjd93LuEH
         jS94anogR2rjXxXjO5mtdp4FrsfUO8ooK2aDLh+J0LlKYfeCeySx+HnjsiSew/UzlLnC
         f2BpX7Qp8u0OXpHSZbpimslVbr61VvTzz1LwuvUBXdogECz4PTRrwN3pvfZs2mix9uHB
         r1O6Chb4r0/L6TO3/L5vc4ie8hP15f7vmNgSdCwD3D74vfVcCjNwzN45G+X70M3bkoa9
         1wyCzj6YFdz0Jijb7eb+rQEIIXfa+HrIbkmt04oKg1FuCm3JtZp/QW3f6s86V+pQ5MnM
         jVEg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773704353; x=1774309153; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VwUHzKKpuzMgKlUaXpAb89AV8p2fq44hwffT/WJRTbU=;
        b=H0nB1Tj0UEXCumFzsAuE3mVWbftdHGr1WjbQq6o2AR+MfYX8eXf+h5UpTLL7pFBW6Z
         OVL4SyWqWXEutpUCh/sPUT4KJt38jWP5iCD9l5q/l4BG/+DZXZWWrwxB8816tCa/3Cfb
         8Pxr301imyZ8uXU9GjY1SOHxwYbSfOjXSo6REntezrzgYb8IYAwO1Kea1I5tymiPOQBy
         isjl/IDvLnoxh4gnLqiPZOK1Eh8WGQr9jfZSx5ru3ZGY66JphgHgRS8tKpU9quHXePWM
         vvIorYR24O0mwBxuJvhIN/Uts/hH4bogtFFMwiVBod+a2xd1qnJT3+grWxZDblyhFuzE
         Bw6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773704353; x=1774309153;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VwUHzKKpuzMgKlUaXpAb89AV8p2fq44hwffT/WJRTbU=;
        b=CmcRL3CfvaFgSx3+obCDvt2mxvGHZHyOajvzqjHExVSvrBiSsUiqgaEHgE7tKF21Yx
         6rI0fD7sjN5c7mxLxWoAr9Fx3MVI2RLms/X9lWBwVBmFDt/OTcoafKeRLFQ3mt56lTQA
         4e0ukrmeaFzXhrRe1i2PQTl8qDJ6MSrSe9zky9Vx0jaWl+WY19kexSX+JgRkGd6qUiDv
         ZcguK0jX9tqu3sY6j1rslO305zEkVmqQDrUjraQp0O9oN0uQwTp6NxZ3gW0ubrDQjHks
         NaBZyZPeooNj2WU+XZWmO4IIO4Z+luw7b/2fd/2I0xbCVl9YaRc+ixqdECjrCA06Er1+
         764g==
X-Forwarded-Encrypted: i=1; AJvYcCWosc4+iRi9fddseXZvvP+tdg2wTim8ylqHtePnG1zVOfSgwztA6tRr6xBViQdr6BiGLnOBrVFn6wlFHYg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYP0yZSkW5/7idQi8XTzDmK/8uju8O547pTxmBhdMro1EeisBn
	GDzGhUsTsKaXi9yETDnDj6evOLkTrOwP55NJ4AW2sz9pG29eQx6ERc0AsjMLFWAbtTC3fAYtEMq
	V0bEHjaLrxa0ZR28NvFbshjYFJmE4wjcajmwFsx2F
X-Gm-Gg: ATEYQzzkxVEaL3DCBhbDtNVlzCqiyeMy+pEfAQ2Q+JI5VlJNiv8nNPUEJak0n+hg7Gr
	SS2RZA0WtzqkZL2LXZnKqrFYnXLZGZ2HcdCu5fJKbzXl79RiccVrb0VALpQcJeRk2MtDGgoVk8V
	YzPWQa0c+P48FoLH77lOledugATLnYQus3v8LNrZqey6Auo7b7qphLR1bjIzR7WP9eTY09fRQE0
	aD/mYMQ0xX9WraN1+YXkVSHOobXtArgam5Oa5AZGqVdsD/qPZiz9NOQeqtyn7Ds3FrZrsiKVX/M
	OYeqvg==
X-Received: by 2002:a05:622a:1b92:b0:509:1eca:6d24 with SMTP id
 d75a77b69052e-50998c190femr6055661cf.2.1773704352286; Mon, 16 Mar 2026
 16:39:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <0e0fe47852e6009f662b1fa42f836447b8d1283a.1773346620.git.ljs@kernel.org>
 <20260313110238.2500603-1-usama.arif@linux.dev> <24cbbaf6-19f2-4403-8cb7-415007597345@lucifer.local>
 <CAJuCfpH1gzi50aWni7rh9=2gM8WwCzm=fY14DCFbjweAq82i6Q@mail.gmail.com> <1f3423d7-ee33-4639-a9a0-f722c7b8b6f1@lucifer.local>
In-Reply-To: <1f3423d7-ee33-4639-a9a0-f722c7b8b6f1@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 16 Mar 2026 16:39:00 -0700
X-Gm-Features: AaiRm53Tb_NnT8EVVpYOE95vTfs7yh1dM4BKVxlkiOPnNfWZWSfIkeN6CRECK8E
Message-ID: <CAJuCfpGFiKd-1rDdMviy8mUFiCtB9pxPj6ux-tF60eB4uVm4=A@mail.gmail.com>
Subject: Re: [PATCH 04/15] mm: add vm_ops->mapped hook
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
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

On Mon, Mar 16, 2026 at 6:39=E2=80=AFAM Lorenzo Stoakes (Oracle) <ljs@kerne=
l.org> wrote:
>
> On Sun, Mar 15, 2026 at 07:18:38PM -0700, Suren Baghdasaryan wrote:
> > On Fri, Mar 13, 2026 at 4:58=E2=80=AFAM Lorenzo Stoakes (Oracle) <ljs@k=
ernel.org> wrote:
> > >
> > > On Fri, Mar 13, 2026 at 04:02:36AM -0700, Usama Arif wrote:
> > > > On Thu, 12 Mar 2026 20:27:19 +0000 "Lorenzo Stoakes (Oracle)" <ljs@=
kernel.org> wrote:
> > > >
> > > > > Previously, when a driver needed to do something like establish a=
 reference
> > > > > count, it could do so in the mmap hook in the knowledge that the =
mapping
> > > > > would succeed.
> > > > >
> > > > > With the introduction of f_op->mmap_prepare this is no longer the=
 case, as
> > > > > it is invoked prior to actually establishing the mapping.
> > > > >
> > > > > To take this into account, introduce a new vm_ops->mapped callbac=
k which is
> > > > > invoked when the VMA is first mapped (though notably - not when i=
t is
> > > > > merged - which is correct and mirrors existing mmap/open/close be=
haviour).
> > > > >
> > > > > We do better that vm_ops->open() here, as this callback can retur=
n an
> > > > > error, at which point the VMA will be unmapped.
> > > > >
> > > > > Note that vm_ops->mapped() is invoked after any mmap action is
> > > > > complete (such as I/O remapping).
> > > > >
> > > > > We intentionally do not expose the VMA at this point, exposing on=
ly the
> > > > > fields that could be used, and an output parameter in case the op=
eration
> > > > > needs to update the vma->vm_private_data field.
> > > > >
> > > > > In order to deal with stacked filesystems which invoke inner file=
system's
> > > > > mmap() invocations, add __compat_vma_mapped() and invoke it on
> > > > > vfs_mmap() (via compat_vma_mmap()) to ensure that the mapped call=
back is
> > > > > handled when an mmap() caller invokes a nested filesystem's mmap_=
prepare()
> > > > > callback.
> > > > >
> > > > > We can now also remove call_action_complete() and invoke
> > > > > mmap_action_complete() directly, as we separate out the rmap lock=
 logic to
> > > > > be called in __mmap_region() instead via maybe_drop_file_rmap_loc=
k().
> > > > >
> > > > > We also abstract unmapping of a VMA on mmap action completion int=
o its own
> > > > > helper function, unmap_vma_locked().
> > > > >
> > > > > Additionally, update VMA userland test headers to reflect the cha=
nge.
> > > > >
> > > > > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> > > > > ---
> > > > >  include/linux/fs.h              |  9 +++-
> > > > >  include/linux/mm.h              | 17 +++++++
> > > > >  mm/internal.h                   | 10 ++++
> > > > >  mm/util.c                       | 86 ++++++++++++++++++++++++---=
------
> > > > >  mm/vma.c                        | 41 +++++++++++-----
> > > > >  tools/testing/vma/include/dup.h | 34 ++++++++++++-
> > > > >  6 files changed, 158 insertions(+), 39 deletions(-)
> > > > >
> > > > > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > > > > index a2628a12bd2b..c390f5c667e3 100644
> > > > > --- a/include/linux/fs.h
> > > > > +++ b/include/linux/fs.h
> > > > > @@ -2059,13 +2059,20 @@ static inline bool can_mmap_file(struct f=
ile *file)
> > > > >  }
> > > > >
> > > > >  int compat_vma_mmap(struct file *file, struct vm_area_struct *vm=
a);
> > > > > +int __vma_check_mmap_hook(struct vm_area_struct *vma);
> > > > >
> > > > >  static inline int vfs_mmap(struct file *file, struct vm_area_str=
uct *vma)
> > > > >  {
> > > > > +   int err;
> > > > > +
> > > > >     if (file->f_op->mmap_prepare)
> > > > >             return compat_vma_mmap(file, vma);
> > > > >
> > > > > -   return file->f_op->mmap(file, vma);
> > > > > +   err =3D file->f_op->mmap(file, vma);
> > > > > +   if (err)
> > > > > +           return err;
> > > > > +
> > > > > +   return __vma_check_mmap_hook(vma);
> > > > >  }
> > > > >
> > > > >  static inline int vfs_mmap_prepare(struct file *file, struct vm_=
area_desc *desc)
> > > > > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > > > > index 12a0b4c63736..7333d5db1221 100644
> > > > > --- a/include/linux/mm.h
> > > > > +++ b/include/linux/mm.h
> > > > > @@ -759,6 +759,23 @@ struct vm_operations_struct {
> > > > >      * Context: User context.  May sleep.  Caller holds mmap_lock=
.
> > > > >      */
> > > > >     void (*close)(struct vm_area_struct *vma);
> > > > > +   /**
> > > > > +    * @mapped: Called when the VMA is first mapped in the MM. No=
t called if
> > > > > +    * the new VMA is merged with an adjacent VMA.
> > > > > +    *
> > > > > +    * The @vm_private_data field is an output field allowing the=
 user to
> > > > > +    * modify vma->vm_private_data as necessary.
> > > > > +    *
> > > > > +    * ONLY valid if set from f_op->mmap_prepare. Will result in =
an error if
> > > > > +    * set from f_op->mmap.
> > > > > +    *
> > > > > +    * Returns %0 on success, or an error otherwise. On error, th=
e VMA will
> > > > > +    * be unmapped.
> > > > > +    *
> > > > > +    * Context: User context.  May sleep.  Caller holds mmap_lock=
.
> > > > > +    */
> > > > > +   int (*mapped)(unsigned long start, unsigned long end, pgoff_t=
 pgoff,
> > > > > +                 const struct file *file, void **vm_private_data=
);
> > > > >     /* Called any time before splitting to check if it's allowed =
*/
> > > > >     int (*may_split)(struct vm_area_struct *vma, unsigned long ad=
dr);
> > > > >     int (*mremap)(struct vm_area_struct *vma);
> > > > > diff --git a/mm/internal.h b/mm/internal.h
> > > > > index 7bfa85b5e78b..f0f2cf1caa36 100644
> > > > > --- a/mm/internal.h
> > > > > +++ b/mm/internal.h
> > > > > @@ -158,6 +158,8 @@ static inline void *folio_raw_mapping(const s=
truct folio *folio)
> > > > >   * mmap hook and safely handle error conditions. On error, VMA h=
ooks will be
> > > > >   * mutated.
> > > > >   *
> > > > > + * IMPORTANT: f_op->mmap() is deprecated, prefer f_op->mmap_prep=
are().
> > > > > + *
> >
> > What exactly would one do to "prefer f_op->mmap_prepare()"?
>
> I'm saying a person should implement f_op->mmap_prepare() rather than
> f_op->mmap(), since the latter is deprecated :)
>
> I think that's pretty clear no?
>
> > Since you are adding this comment for mmap_file(), I think you need to
> > describe more specifically what one should call instead.
>
> I think it'd be a complete distraction, since if you're at the point of c=
alling
> mmap_file() you're already not implement mmap_prepare except as a compatb=
ility
> layer.

Yep, it seems like a warning that comes too late.

>
> I mean maybe I'll just drop this as it seems to be causing confusion.

Maybe instead we add a comment that f_ops->mmap is deprecated in favor
of f_ops->mmap_prepare() in here:
https://elixir.bootlin.com/linux/v7.0-rc4/source/include/linux/fs.h#L1940
?

>
> >
> > > > >   * @file: File which backs the mapping.
> > > > >   * @vma:  VMA which we are mapping.
> > > > >   *
> > > > > @@ -201,6 +203,14 @@ static inline void vma_close(struct vm_area_=
struct *vma)
> > > > >  /* unmap_vmas is in mm/memory.c */
> > > > >  void unmap_vmas(struct mmu_gather *tlb, struct unmap_desc *unmap=
);
> > > > >
> > > > > +static inline void unmap_vma_locked(struct vm_area_struct *vma)
> > > > > +{
> > > > > +   const size_t len =3D vma_pages(vma) << PAGE_SHIFT;
> > > > > +
> > > > > +   mmap_assert_locked(vma->vm_mm);
> >
> > You must hold the mmap write lock when unmapping. Would be better to
> > assert mmap_assert_write_locked() or even vma_assert_write_locked(),
> > which implies mmap_assert_write_locked().
>
> I'm not sure why we don't assert this in those paths.
>
> I think I assumed we could only assert readonly because one of those path=
s
> downgrades the mmap write lock to a read lock.
>
> I don't think we can do a VMA write lock assert here, since at the point =
of
> do_munmap() all callers can't possibly have the VMA write lock, since the=
y are
> _looking up_ the VMA at the specified address.

It sounds strange to me that we are unmapping a VMA that was not
locked beforehand. Let me look into the call chains a bit more to
convince myself one way or the other. The fact that do_munmap() looks
up the VMA by address and then write-locks it inside
vms_gather_munmap_vmas() does not mean the VMA was not already locked.
vma_start_write() is re-entrant.

>
> But I can convert this to an mmap_assert_write_locked()!

Ok, let's go with that. I don't want to slow down your patchset while
I investigate locking rules here. We can strengthen the assertion
later.

>
> >
> > > > > +   do_munmap(vma->vm_mm, vma->vm_start, len, NULL);
> > > > > +}
> > > > > +
> > > > >  #ifdef CONFIG_MMU
> > > > >
> > > > >  static inline void get_anon_vma(struct anon_vma *anon_vma)
> > > > > diff --git a/mm/util.c b/mm/util.c
> > > > > index dba1191725b6..2b0ed54008d6 100644
> > > > > --- a/mm/util.c
> > > > > +++ b/mm/util.c
> > > > > @@ -1163,6 +1163,55 @@ void flush_dcache_folio(struct folio *foli=
o)
> > > > >  EXPORT_SYMBOL(flush_dcache_folio);
> > > > >  #endif
> > > > >
> > > > > +static int __compat_vma_mmap(struct file *file, struct vm_area_s=
truct *vma)
> > > > > +{
> > > > > +   struct vm_area_desc desc =3D {
> > > > > +           .mm =3D vma->vm_mm,
> > > > > +           .file =3D file,
> > > > > +           .start =3D vma->vm_start,
> > > > > +           .end =3D vma->vm_end,
> > > > > +
> > > > > +           .pgoff =3D vma->vm_pgoff,
> > > > > +           .vm_file =3D vma->vm_file,
> > > > > +           .vma_flags =3D vma->flags,
> > > > > +           .page_prot =3D vma->vm_page_prot,
> > > > > +
> > > > > +           .action.type =3D MMAP_NOTHING, /* Default */
> > > > > +   };
> > > > > +   int err;
> > > > > +
> > > > > +   err =3D vfs_mmap_prepare(file, &desc);
> > > > > +   if (err)
> > > > > +           return err;
> > > > > +
> > > > > +   err =3D mmap_action_prepare(&desc, &desc.action);
> > > > > +   if (err)
> > > > > +           return err;
> > > > > +
> > > > > +   set_vma_from_desc(vma, &desc);
> > > > > +   return mmap_action_complete(vma, &desc.action);
> > > > > +}
> > > > > +
> > > > > +static int __compat_vma_mapped(struct file *file, struct vm_area=
_struct *vma)
> > > > > +{
> > > > > +   const struct vm_operations_struct *vm_ops =3D vma->vm_ops;
> > > > > +   void *vm_private_data =3D vma->vm_private_data;
> > > > > +   int err;
> > > > > +
> > > > > +   if (!vm_ops->mapped)
> > > > > +           return 0;
> > > > > +
> > > >
> > > > Hello!
> > > >
> > > > Can vm_ops be NULL here?  __compat_vma_mapped() is called from
> > > > compat_vma_mmap(), which is reached when a filesystem provides
> > > > mmap_prepare.  If the mmap_prepare hook does not set desc->vm_ops,
> > > > vma->vm_ops will be NULL and this dereferences a NULL pointer.
> > >
> > > I _think_ for this to ever be invoked, you would need to be dealing w=
ith a
> > > file-backed VMA so vm_ops->fault would HAVE to be defined.
> > >
> > > But you're right anyway as a matter of principle we should check it! =
Will fix.
> > >
> > > >
> > > > For e.g. drivers/char/mem.c, mmap_zero_prepare() would trigger
> > > > a NULL pointer dereference here.
> > > >
> > > > Would need to do
> > > >       if (!vm_ops || !vm_ops->mapped)
> > > >               return 0;
> > > >
> > > > here
> > >
> > > Yes.
> > >
> > > >
> > > >
> > > > > +   err =3D vm_ops->mapped(vma->vm_start, vma->vm_end, vma->vm_pg=
off, file,
> > > > > +                        &vm_private_data);
> > > > > +   if (err)
> > > > > +           unmap_vma_locked(vma);
> > > >
> > > > when mapped() returns an error, unmap_vma_locked(vma) is called
> > > > but execution continues into the vm_private_data update below.  Aft=
er
> > > > unmap_vma_locked() the VMA may be freed (do_munmap can remove the V=
MA
> > > > entirely), so accessing vma->vm_private_data after that is a
> > > > use-after-free.
> > >
> > > Very good point :) will fix thanks!
> > >
> > > Probably:
> > >
> > >         if (err)
> > >                 unmap_vma_locked(vma);
> > >         else if (vm_private_data !=3D vma->vm_private_data)
> > >                 vma->vm_private_data =3D vm_private_data;
> > >
> > >         return err;
> > >
> > > Would be fine.
> > >
> > > >
> > > > Probably need to do:
> > > >       if (err) {
> > > >               unmap_vma_locked(vma);
> > > >               return err;
> > > >       }
> > > >
> > > > > +   /* Update private data if changed. */
> > > > > +   if (vm_private_data !=3D vma->vm_private_data)
> > > > > +           vma->vm_private_data =3D vm_private_data;
> > > > > +
> > > > > +   return err;
> > > > > +}
> > > > > +
> > > > >  /**
> > > > >   * compat_vma_mmap() - Apply the file's .mmap_prepare() hook to =
an
> > > > >   * existing VMA and execute any requested actions.
> > > > > @@ -1191,34 +1240,26 @@ EXPORT_SYMBOL(flush_dcache_folio);
> > > > >   */
> > > > >  int compat_vma_mmap(struct file *file, struct vm_area_struct *vm=
a)
> > > > >  {
> > > > > -   struct vm_area_desc desc =3D {
> > > > > -           .mm =3D vma->vm_mm,
> > > > > -           .file =3D file,
> > > > > -           .start =3D vma->vm_start,
> > > > > -           .end =3D vma->vm_end,
> > > > > -
> > > > > -           .pgoff =3D vma->vm_pgoff,
> > > > > -           .vm_file =3D vma->vm_file,
> > > > > -           .vma_flags =3D vma->flags,
> > > > > -           .page_prot =3D vma->vm_page_prot,
> > > > > -
> > > > > -           .action.type =3D MMAP_NOTHING, /* Default */
> > > > > -   };
> > > > >     int err;
> > > > >
> > > > > -   err =3D vfs_mmap_prepare(file, &desc);
> > > > > -   if (err)
> > > > > -           return err;
> > > > > -
> > > > > -   err =3D mmap_action_prepare(&desc, &desc.action);
> > > > > +   err =3D __compat_vma_mmap(file, vma);
> > > > >     if (err)
> > > > >             return err;
> > > > >
> > > > > -   set_vma_from_desc(vma, &desc);
> > > > > -   return mmap_action_complete(vma, &desc.action);
> > > > > +   return __compat_vma_mapped(file, vma);
> > > > >  }
> > > > >  EXPORT_SYMBOL(compat_vma_mmap);
> > > > >
> > > > > +int __vma_check_mmap_hook(struct vm_area_struct *vma)
> > > > > +{
> > > > > +   /* vm_ops->mapped is not valid if mmap() is specified. */
> > > > > +   if (WARN_ON_ONCE(vma->vm_ops->mapped))
> > > > > +           return -EINVAL;
> > > >
> > > > I think vma->vm_ops can be NULL here. Should be:
> > > >
> > > >       if (vma->vm_ops && WARN_ON_ONCE(vma->vm_ops->mapped))
> > > >               return -EINVAL;
> > >
> > > I think again you'd probably only invoke this on file-backed so be ok=
, but again
> > > as a matter of principle we should check it so will fix, thanks!
> > >
> > > >
> > > > > +
> > > > > +   return 0;
> > > > > +}
> > > > > +EXPORT_SYMBOL(__vma_check_mmap_hook);
> >
> > nit: Any reason __vma_check_mmap_hook() is not inlined next to its
> > user vfs_mmap()?
>
> Headers fun, fs.h is a 'before mm.h' header, so vm_operations_struct is n=
ot
> declared yet here, so we can't actually do the check there.

Ack.

>
> >
> > > > > +
> > > > >  static void set_ps_flags(struct page_snapshot *ps, const struct =
folio *folio,
> > > > >                      const struct page *page)
> > > > >  {
> > > > > @@ -1316,10 +1357,7 @@ static int mmap_action_finish(struct vm_ar=
ea_struct *vma,
> > > > >      * invoked if we do NOT merge, so we only clean up the VMA we=
 created.
> > > > >      */
> > > > >     if (err) {
> > > > > -           const size_t len =3D vma_pages(vma) << PAGE_SHIFT;
> > > > > -
> > > > > -           do_munmap(current->mm, vma->vm_start, len, NULL);
> > > > > -
> > > > > +           unmap_vma_locked(vma);
> > > > >             if (action->error_hook) {
> > > > >                     /* We may want to filter the error. */
> > > > >                     err =3D action->error_hook(err);
> > > > > diff --git a/mm/vma.c b/mm/vma.c
> > > > > index 054cf1d262fb..ef9f5a5365d1 100644
> > > > > --- a/mm/vma.c
> > > > > +++ b/mm/vma.c
> > > > > @@ -2705,21 +2705,35 @@ static bool can_set_ksm_flags_early(struc=
t mmap_state *map)
> > > > >     return false;
> > > > >  }
> > > > >
> > > > > -static int call_action_complete(struct mmap_state *map,
> > > > > -                           struct mmap_action *action,
> > > > > -                           struct vm_area_struct *vma)
> > > > > +static int call_mapped_hook(struct vm_area_struct *vma)
> > > > >  {
> > > > > -   int ret;
> > > > > +   const struct vm_operations_struct *vm_ops =3D vma->vm_ops;
> > > > > +   void *vm_private_data =3D vma->vm_private_data;
> > > > > +   int err;
> > > > >
> > > > > -   ret =3D mmap_action_complete(vma, action);
> > > > > +   if (!vm_ops || !vm_ops->mapped)
> > > > > +           return 0;
> > > > > +   err =3D vm_ops->mapped(vma->vm_start, vma->vm_end, vma->vm_pg=
off,
> > > > > +                        vma->vm_file, &vm_private_data);
> > > > > +   if (err) {
> > > > > +           unmap_vma_locked(vma);
> > > > > +           return err;
> > > > > +   }
> > > > > +   /* Update private data if changed. */
> > > > > +   if (vm_private_data !=3D vma->vm_private_data)
> > > > > +           vma->vm_private_data =3D vm_private_data;
> > > > > +   return 0;
> > > > > +}
> > > > >
> > > > > -   /* If we held the file rmap we need to release it. */
> > > > > -   if (map->hold_file_rmap_lock) {
> > > > > -           struct file *file =3D vma->vm_file;
> > > > > +static void maybe_drop_file_rmap_lock(struct mmap_state *map,
> > > > > +                                 struct vm_area_struct *vma)
> > > > > +{
> > > > > +   struct file *file;
> > > > >
> > > > > -           i_mmap_unlock_write(file->f_mapping);
> > > > > -   }
> > > > > -   return ret;
> > > > > +   if (!map->hold_file_rmap_lock)
> > > > > +           return;
> > > > > +   file =3D vma->vm_file;
> > > > > +   i_mmap_unlock_write(file->f_mapping);
> > > > >  }
> > > > >
> > > > >  static unsigned long __mmap_region(struct file *file, unsigned l=
ong addr,
> > > > > @@ -2773,8 +2787,11 @@ static unsigned long __mmap_region(struct =
file *file, unsigned long addr,
> > > > >     __mmap_complete(&map, vma);
> > > > >
> > > > >     if (have_mmap_prepare && allocated_new) {
> > > > > -           error =3D call_action_complete(&map, &desc.action, vm=
a);
> > > > > +           error =3D mmap_action_complete(vma, &desc.action);
> > > > > +           if (!error)
> > > > > +                   error =3D call_mapped_hook(vma);
> > > > >
> > > > > +           maybe_drop_file_rmap_lock(&map, vma);
> > > > >             if (error)
> > > > >                     return error;
> > > > >     }
> > > > > diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/=
include/dup.h
> > > > > index 908beb263307..47d8db809f31 100644
> > > > > --- a/tools/testing/vma/include/dup.h
> > > > > +++ b/tools/testing/vma/include/dup.h
> > > > > @@ -606,12 +606,34 @@ struct vm_area_struct {
> > > > >  } __randomize_layout;
> > > > >
> > > > >  struct vm_operations_struct {
> > > > > -   void (*open)(struct vm_area_struct * area);
> > > > > +   /**
> > > > > +    * @open: Called when a VMA is remapped or split. Not called =
upon first
> > > > > +    * mapping a VMA.
> > > > > +    * Context: User context.  May sleep.  Caller holds mmap_lock=
.
> > > > > +    */
> >
> > This comment should have been introduced in the previous patch.
>
> It's the testing code, it's not really important. But if I respin I'll fi=
x... :)

Thanks!

>
> >
> > > > > +   void (*open)(struct vm_area_struct *vma);
> > > > >     /**
> > > > >      * @close: Called when the VMA is being removed from the MM.
> > > > >      * Context: User context.  May sleep.  Caller holds mmap_lock=
.
> > > > >      */
> > > > > -   void (*close)(struct vm_area_struct * area);
> > > > > +   void (*close)(struct vm_area_struct *vma);
> > > > > +   /**
> > > > > +    * @mapped: Called when the VMA is first mapped in the MM. No=
t called if
> > > > > +    * the new VMA is merged with an adjacent VMA.
> > > > > +    *
> > > > > +    * The @vm_private_data field is an output field allowing the=
 user to
> > > > > +    * modify vma->vm_private_data as necessary.
> > > > > +    *
> > > > > +    * ONLY valid if set from f_op->mmap_prepare. Will result in =
an error if
> > > > > +    * set from f_op->mmap.
> > > > > +    *
> > > > > +    * Returns %0 on success, or an error otherwise. On error, th=
e VMA will
> > > > > +    * be unmapped.
> > > > > +    *
> > > > > +    * Context: User context.  May sleep.  Caller holds mmap_lock=
.
> > > > > +    */
> > > > > +   int (*mapped)(unsigned long start, unsigned long end, pgoff_t=
 pgoff,
> > > > > +                 const struct file *file, void **vm_private_data=
);
> > > > >     /* Called any time before splitting to check if it's allowed =
*/
> > > > >     int (*may_split)(struct vm_area_struct *area, unsigned long a=
ddr);
> > > > >     int (*mremap)(struct vm_area_struct *area);
> > > > > @@ -1345,3 +1367,11 @@ static inline void vma_set_file(struct vm_=
area_struct *vma, struct file *file)
> > > > >     swap(vma->vm_file, file);
> > > > >     fput(file);
> > > > >  }
> > > > > +
> > > > > +static inline void unmap_vma_locked(struct vm_area_struct *vma)
> > > > > +{
> > > > > +   const size_t len =3D vma_pages(vma) << PAGE_SHIFT;
> > > > > +
> > > > > +   mmap_assert_locked(vma->vm_mm);
> > > > > +   do_munmap(vma->vm_mm, vma->vm_start, len, NULL);
> > > > > +}
> > > > > --
> > > > > 2.53.0
> > > > >
> > > > >
> > >
> > > Cheers, Lorenzo
