Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57E83939C5
	for <target-devel@vger.kernel.org>; Wed, 18 Mar 2026 16:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773849746; cv=pass; b=Kfh42nhft6BhV0VJrN/Wj3FVQbEPWhwV+3UED1yeYSeOUrx4WFNx3Sf1Swnh88fsVpCdqUReByM243zWjlDz96btcKlrdXFZ6N4nCsWfR8nTDwPIk+C/qCsZYV1sZJazRL1V8390NFc019H4M7pv7yoPm3tmiXZ1H+HuWeXu3cs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773849746; c=relaxed/simple;
	bh=Sn9jbrHlytwm6vm7UMn5Ci63+904PwFRZxmCisoVDck=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gHHD9hzkrsFvp/UClmDtgULhzs7gIWDyJrXuNia7xd5HxDi0k+Lw35DnLddodXMlCmYbwmrC6KJKcmjTbVMXI7yQJmutoYONe4XC0y7AwS/t5owjt8F9nlW6p2ctJageRHs6YDNQkD6+7CgqFtTLSGh8m7uK0uP3buvrg4RJ1pI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Wm0jPzpe; arc=pass smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Wm0jPzpe"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-509069a7a7fso645251cf.0
        for <target-devel@vger.kernel.org>; Wed, 18 Mar 2026 09:02:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773849738; cv=none;
        d=google.com; s=arc-20240605;
        b=VBibMk2Zf2WcoibxLBYY0mmvCBoOCXJzDl5jWDq5sadh5ynXpBl5jCAMBvgCGo7fJy
         +/lm0xXxKos2rXfcaH1jaV737miKPnV4Q3iBR6/RjFHEejvJZP9LTTp07hMiHKCxokXh
         YdIyw89vF2MUd/MZGYmD+PjBc9n0OSWzHrbnYy+cWjG9vYqaBQRLlG8YKbbvJkzttWNN
         KiyJpN1cPInkwCHs08R0V0Yq6C58/GnEHAt9nYq+mH8ZwF/WJwA0W4UtHXUJ93W3kzBe
         F6Kr/LGkUWy06qe/I8yWmKN/mqP4nEUGDfY3yjTnX62YQWWjSzlE0rBD436PSU4SyCkj
         EqPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bBf0X4ZI8hrueKElVjOm/fdCiPNUuzJRpv2jzIUCVLI=;
        fh=M3O2re3ca4hYTVW04NVodhjglrzeqrt7NKTp1rBmwjk=;
        b=AhPwP+PBbzz/nwn578zO6jxVNSKxzM5givlD0GGhzF1I3ohtKIJgQ+Z92It0ouIkyM
         Y7U/hienjgjG1tm9ttxls4uyekT0JyXz1ilvrBdm/dyMJhk05rcX7y4aikY7r3/MM3iw
         ep2qW8emEKkwoCuNxUOSCrHp3POfMo7hSHnx4mmoFoKSfIYle4jU8dJHO/qgveF19zD9
         WJKsb0tPlGH8q1d9xSYSRMZj1g9Ff+yQwbxrN1bSOw/jxBCquf1G4uxiLiUq61zlMA91
         brMAzqMRpSl0s2RYbvWW9OygrsMhQxXzeCclBz8gwZ22B458pZKJC2nSKp5RmlS01V9P
         4IHw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773849738; x=1774454538; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bBf0X4ZI8hrueKElVjOm/fdCiPNUuzJRpv2jzIUCVLI=;
        b=Wm0jPzpeHp5dNdtnLhc5H1xUtQtEyN6dAuXQxuM0/SN+dHfWxkgkDLEv16Sd+NSk4R
         W3zwVULhxvCobeOJ60+FPx2K3eBstNvsz1o15jYru4GL4ux6NqrdChHlBZ9x8AUqIq29
         mSh4V0HHJ1KEDYe3hbSIWJt/zucGLqTxfR/1Gy6C4SU1SnJYyWvn9m69CcuCepH7L6C6
         n0wL88/pgPhUZ1Xwjk6REDhoOePUSYUBm/1TlDa4divFXSqbTArdZq/crK4tSKTSMu00
         OMs4vzIJDqWDaaZZ7G+XPePGtrej7nUQn43nj8Vez1JteO0v0mZPWyOk90/G2Tpzi1+W
         Y63A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773849738; x=1774454538;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bBf0X4ZI8hrueKElVjOm/fdCiPNUuzJRpv2jzIUCVLI=;
        b=CAZKsuQyWiLaRpa9vIWWbp5PmBjDgifaqQF+8EEEJ3+CDBl7FNGuW2T+EpVHHqSriS
         mSUL2XN0RgptD6yeX7bw50HGCTDgi5ChD4JhyXbQqUMkNtT3fnBhUpIVjM2+eXQuSCzf
         i8m+6OkNBiFLT4aNjOIu4CBkUzGB52IKrCxrsrLDJyYj8iHy5DGwShE+1MT/oo0WqqUn
         cmKmIQj+GzQfuQ4Hqrf4M8I/oFiQ1UEUHmWUMlefEMJDQRVgJChML/XCUAEK1J9X68qS
         2gBoaqMZiEbn/Pnlrm4Je2DQltRfyJ3bUnhrr2zQRLcziEl/SOvWr7cFIQbMK4ptsWAo
         Gcwg==
X-Forwarded-Encrypted: i=1; AJvYcCW7hX/PoFCwwbD8FF+sqHYRlYhWgJGsrg6YjTHVxgXQ8aX8/H4VVoZ1t1nhL/wQr2A/ypl/gL/eNxnjcJk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZPhqKzzgLynY5igMggr0e4DYFWnRtPPrTs8sQByHB3G2OBD4c
	3LpJ0e74PbgV/1KvAT5AQT4Un+g4wCIDLEi+MH1C7zBMbeWy/kJszw6nBczDRGS3F3jzTpATdgc
	1nmZKi1mEcciqnOTc0GZ8Fqnu2KF2HlDmr1zkWIz/
X-Gm-Gg: ATEYQzwknui2U/74oNne4Ej4pnzPp+Lj7UeIKDtN44BPA7U02OOo1t3bhrB6rq2ki4q
	705Nty1Xh8IoWpcob4Sp0Q+vGlakMfJoa+VNKR+Z4POFiQeX/14MP2zMgMXjo+r5sWJCcl9lXRG
	3BNKXTMVFiAkiZhAT4TQAqrkAq84Ln0Zz6ZEvwoAO5uy/A5LZ/YmnEuBKq5e/w3N4fFJr95ov3M
	Kof3LGYxGcM/Fb/W++4IgCHkNVSsokJbN+2opEMGPDy0/bwHbjJQcjhZuDxIwjyZ6UCYmGlC7HO
	ScO+SBwYS9XBHi/vxuRUB564F9OeyBDTy7z2gq1x/YxHbGkF
X-Received: by 2002:ac8:5d4e:0:b0:4ff:c0e7:be9c with SMTP id
 d75a77b69052e-50b1462cacfmr16816931cf.0.1773849737454; Wed, 18 Mar 2026
 09:02:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1773695307.git.ljs@kernel.org> <4e152e7b8e1a93baf0777628eef9409d031cf8f6.1773695307.git.ljs@kernel.org>
In-Reply-To: <4e152e7b8e1a93baf0777628eef9409d031cf8f6.1773695307.git.ljs@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 18 Mar 2026 09:02:04 -0700
X-Gm-Features: AaiRm52kf0p9Fxu6EolM9nhc_2BIDOLEzyHhrKwtGPKlzkXo42y6XvhNDeOCJ6g
Message-ID: <CAJuCfpFd-d-E24d5-G6=dSYDpyHkwS=aXzGd6+SzyMkgssyPAw@mail.gmail.com>
Subject: Re: [PATCH v2 16/16] mm: on remap assert that input range within the
 proposed VMA
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
> Now we have range_in_vma_desc(), update remap_pfn_range_prepare() to chec=
k
> whether the input range in contained within the specified VMA, so we can

s/in contained/is contained

> fail at prepare time if an invalid range is specified.
>
> This covers the I/O remap mmap actions also which ultimately call into th=
is
> function, and other mmap action types either already span the full VMA or
> check this already.
>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/memory.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 849d5d9eeb83..de0dd17759e2 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3142,6 +3142,9 @@ int remap_pfn_range_prepare(struct vm_area_desc *de=
sc)
>         const bool is_cow =3D vma_desc_is_cow_mapping(desc);
>         int err;
>
> +       if (!range_in_vma_desc(desc, start, end))
> +               return -EFAULT;
> +
>         err =3D get_remap_pgoff(is_cow, start, end, desc->start, desc->en=
d, pfn,
>                               &desc->pgoff);
>         if (err)
> --
> 2.53.0
>
