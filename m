Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1C61DDC37
	for <target-devel@vger.kernel.org>; Mon, 16 Mar 2026 02:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773628388; cv=pass; b=B/GASvksDjFsYOW7/7OOtLUFCmZfsurhAfQOzNQAnhEQ0i/Fz7dSAyzEPe+1MVDYj46s56XxQGsgUUA4f3jK1HX8eVfpF+bvZvwOdIIfm5bhhBgwW+HsONzp8GVHnfYpji6uG2PD5Ne90Q8q8N2Sk9uBDLy4MW0WYShjzIPUOoU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773628388; c=relaxed/simple;
	bh=P8upWlYrnSKRURZkcwVOV+h6+eQ68h1jm6EnGvbVBq8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VWeBMN0bqY5AOvK2JaUy4FvL1WAM3qgJLXm3OHyZ6h524Mdi6jCDnqB7XbspD+GVsZnYGRvRKLzqPAs6HKAaSW1L4WFr4qij3IY2nBty2ZT5ANmBL6ZDjWS1mBuLU4YOOS4eFMWmVdPbcZXI3SAcKCzbnn22zNkilOAjx9g4bf0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Os005hha; arc=pass smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Os005hha"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-509062d829dso709001cf.1
        for <target-devel@vger.kernel.org>; Sun, 15 Mar 2026 19:33:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773628385; cv=none;
        d=google.com; s=arc-20240605;
        b=luhftlIOEjRZxwbZQjz/4Jl8ObcFnO9mFO7QvnRZwJYvmoeJ98XApZWRP5RxILTLg3
         mdzscHeF62+P42EyxkT9nMC5r4gfal2tL88+r1ew9byQyWkJ3gmfshdzYyWEXQWAgYE4
         n+F87CEzkFjCEhGsobvPGN5afWP+75IwDOhg8zyUxcunQVKkjaWykdT2dnHcsUMw+zyr
         E1qOrp6vxsas9b6PQcXzCJmBZZW3IWvrhoBuvqjiRYqpZqLvC3mOFNGtpwA2iiwT8clt
         7NYZfckIbsEK4/1TbS2XeU9Kv58tIaNYEZOH8s/Dq9MDUqy5K8e+sNHcOHytjzEW3N/Z
         I9LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SOxR7OMcrpIXquZYk6Fw42QRhAnf+JOcixO64waw3M8=;
        fh=i3dXQXOyWEjMI60M6HlMV9NWJS8p/7XdUqXcTtuK9HE=;
        b=kFtyTatorZBKGzbU2AayxnXCGqPYIMrUYjxeUojw1fCEBYHVcp9heNctkHPylpNXGe
         tNC3xc52o7yZN+XugxwzobXlUBXK8FchMVY6OD/ff2BuuB01XgS8ET9jsmLBle1G3N1B
         jJDvN/Z8IDpqsEN4HnzPe8G6O/D4Zu2Y5BqQb7oN2kmCV7cgWcHEU8bdlI9ST2ezaHrX
         oKtsI5nPctgfEzaH+1xYRwsYwfwCX+BQBn22VWxbfLLjEsGBbGQ2wsk+q1hpJ7IS2SNk
         BQWsmhOq+Ik81hanlHwgo1zcoOFK670sA1P15j1hW6nVcJaMfKdgRQNUsIHRcza8BE8k
         qnOQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773628385; x=1774233185; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SOxR7OMcrpIXquZYk6Fw42QRhAnf+JOcixO64waw3M8=;
        b=Os005hha9utJ0zhLJOYe43DqwRJu1UsmQb6s+HI6U/vIkdMMHKNfni2DnM3UjY2ppG
         Pgldse+NU/KSqsNIKnhLsbu3tV+y5WOf7u38Ae1jXCGJ+TALOgC7DlZBap+ebz4BPH5E
         nRNEReY023lXBY4rnzTVP/LQogEO2pekM5ob8tnZjzH8wkHt+SD0VxbFEmVw/IXm5ykT
         zenhaSk0a2HdP0Y9lApDdeu+NjIkaHvZvyqrN9+GDogwYjuU+8lnmWqykOgeBlgiP6JA
         /7T3vubRR+T2OKrdyYplaKBWP4WvlYGo8Iw+KD28NlBJmyFbtK2bzcP1n+j5ThCSE+rA
         UXZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773628385; x=1774233185;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SOxR7OMcrpIXquZYk6Fw42QRhAnf+JOcixO64waw3M8=;
        b=D2rpyL2OHdcWF3KUXkoCQiMITnQfvZIt2lo2tDwomn2jQPnV3X1YTu2UovHAgGpjLj
         s51gI7+IUScjXMObXPdy+8S4H3GRh0Ml4EBle0jN8vhMM4YVVawEVPOR1Oc5qc6zUCI1
         BgahKgvcrNJ0mJXjz+Opl0NE5UE6YS7gVpB1tyLwBi9rHc9CtReV8QNym7Aect/YrdEf
         V+KmTvffsQn360Zpf8dDWwAbYqSsTFokAdwB6IbnHm6tHARNyTooD3Wb21bWmQG01Re7
         2u8OzHVscmcrtYHZe3oPvgxDyCtt/V7gHCD50lPQc87xbbr9xiBeOriujMFeAYV57CJR
         iozg==
X-Forwarded-Encrypted: i=1; AJvYcCWvIS7aD75jst2aEXZ5O8L87HV7nGZWIhFENXu2tPWGI77o5ERlWHPAU3rSQriXPNPwR89ewCdzt+djudQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyzRQwG5oSLAKkHX9tGYSIzBCwkex52FQymLpl4zsfR1inifAUu
	X59WFTzlz7NLiOPlNgSxJHOcOM3Vcub5u/WhkHaHDc9a0xnWy346RvfRBjl6P5WLrox3yalt6m1
	TS8H2DoglDLtkht8TmgpwOKj6T5xV+hvoZMlNyiv8
X-Gm-Gg: ATEYQzwZhv+06uHWDW4577cd+HVIkpmw5acIpY3HSVNh/Aj49YmUhxqzrMZQyGALzzb
	0NsLaBzAEPnF1yUmcNSj1BzbiyjTeHLKiJcaS16KutgFWas1VJz6Jc7ibPWphAWH+bya/quyM8H
	C91NkdWqX4W8nmCVkLD62IAJEI05j14QIezim7tF4FyH33quVCMGiDVoXE6EiDQ5osu787eFiTH
	uQs0nE6xU9Pv3TVa9edXzP5qY7qTE8E8sm59e58iWyCjPgJ3ejOxEUHbC183VjSpcmSfPpJZUnu
	Qfo36g==
X-Received: by 2002:a05:622a:60c:b0:4fb:e3b0:aae6 with SMTP id
 d75a77b69052e-5096a92ebdbmr823271cf.1.1773628384887; Sun, 15 Mar 2026
 19:33:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <4a5fa45119220b9d99ed72a36308aed01a30d2c1.1773346620.git.ljs@kernel.org>
 <20260313110745.2573005-1-usama.arif@linux.dev> <c62305d7-22c4-4cf7-969b-fbe214c93b64@lucifer.local>
In-Reply-To: <c62305d7-22c4-4cf7-969b-fbe214c93b64@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 15 Mar 2026 19:32:54 -0700
X-Gm-Features: AaiRm52_478_pqzpMaMH6nJQtQvcaF-xKuK5uDWZ-u00xGMYRYKMJPl6M-Q1q5E
Message-ID: <CAJuCfpFio6n-O-1NkPXrymV0o3UqvHYS8ZOyQtt=JXnZ5dTGhQ@mail.gmail.com>
Subject: Re: [PATCH 05/15] fs: afs: correctly drop reference count on mapping failure
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

On Fri, Mar 13, 2026 at 5:00=E2=80=AFAM Lorenzo Stoakes (Oracle) <ljs@kerne=
l.org> wrote:
>
> On Fri, Mar 13, 2026 at 04:07:43AM -0700, Usama Arif wrote:
> > On Thu, 12 Mar 2026 20:27:20 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kern=
el.org> wrote:
> >
> > > Commit 9d5403b1036c ("fs: convert most other generic_file_*mmap() use=
rs to
> > > .mmap_prepare()") updated AFS to use the mmap_prepare callback in fav=
our of
> > > the deprecated mmap callback.
> > >
> > > However, it did not account for the fact that mmap_prepare can fail t=
o map
> > > due to an out of memory error, and thus should not be incrementing a
> > > reference count on mmap_prepare.

This is a bit confusing. I see the current implementation does
afs_add_open_mmap() and then if generic_file_mmap_prepare() fails it
does afs_drop_open_mmap(), therefore refcounting seems to be balanced.
Is there really a problem?

> > >
> > > With the newly added vm_ops->mapped callback available, we can simply=
 defer
> > > this operation to that callback which is only invoked once the mappin=
g is
> > > successfully in place (but not yet visible to userspace as the mmap a=
nd VMA
> > > write locks are held).
> > >
> > > Therefore add afs_mapped() to implement this callback for AFS.
> > >
> > > In practice the mapping allocations are 'too small to fail' so this i=
s
> > > something that realistically should never happen in practice (or woul=
d do
> > > so in a case where the process is about to die anyway), but we should=
 still
> > > handle this.

nit: I would drop the above paragraph. If it's impossible why are you
handling it? If it's unlikely, then handling it is even more
important.

> > >
> > > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> > > ---
> > >  fs/afs/file.c | 20 ++++++++++++++++----
> > >  1 file changed, 16 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/fs/afs/file.c b/fs/afs/file.c
> > > index f609366fd2ac..69ef86f5e274 100644
> > > --- a/fs/afs/file.c
> > > +++ b/fs/afs/file.c
> > > @@ -28,6 +28,8 @@ static ssize_t afs_file_splice_read(struct file *in=
, loff_t *ppos,
> > >  static void afs_vm_open(struct vm_area_struct *area);
> > >  static void afs_vm_close(struct vm_area_struct *area);
> > >  static vm_fault_t afs_vm_map_pages(struct vm_fault *vmf, pgoff_t sta=
rt_pgoff, pgoff_t end_pgoff);
> > > +static int afs_mapped(unsigned long start, unsigned long end, pgoff_=
t pgoff,
> > > +                 const struct file *file, void **vm_private_data);
> > >
> > >  const struct file_operations afs_file_operations =3D {
> > >     .open           =3D afs_open,
> > > @@ -61,6 +63,7 @@ const struct address_space_operations afs_file_aops=
 =3D {
> > >  };
> > >
> > >  static const struct vm_operations_struct afs_vm_ops =3D {
> > > +   .mapped         =3D afs_mapped,
> > >     .open           =3D afs_vm_open,
> > >     .close          =3D afs_vm_close,
> > >     .fault          =3D filemap_fault,
> > > @@ -500,13 +503,22 @@ static int afs_file_mmap_prepare(struct vm_area=
_desc *desc)
> > >     afs_add_open_mmap(vnode);
> >
> > Is the above afs_add_open_mmap an additional one, which could cause a r=
eference
> > leak? Does the above one need to be removed and only the one in afs_map=
ped()
> > needs to be kept?
>
> Ah yeah good spot, will fix thanks!
>
> >
> > >
> > >     ret =3D generic_file_mmap_prepare(desc);
> > > -   if (ret =3D=3D 0)
> > > -           desc->vm_ops =3D &afs_vm_ops;
> > > -   else
> > > -           afs_drop_open_mmap(vnode);
> > > +   if (ret)
> > > +           return ret;
> > > +
> > > +   desc->vm_ops =3D &afs_vm_ops;
> > >     return ret;
> > >  }
> > >
> > > +static int afs_mapped(unsigned long start, unsigned long end, pgoff_=
t pgoff,
> > > +                 const struct file *file, void **vm_private_data)
> > > +{
> > > +   struct afs_vnode *vnode =3D AFS_FS_I(file_inode(file));
> > > +
> > > +   afs_add_open_mmap(vnode);
> > > +   return 0;
> > > +}
> > > +
> > >  static void afs_vm_open(struct vm_area_struct *vma)
> > >  {
> > >     afs_add_open_mmap(AFS_FS_I(file_inode(vma->vm_file)));
> > > --
> > > 2.53.0
> > >
> > >
>
> Cheers, Lorenzo
