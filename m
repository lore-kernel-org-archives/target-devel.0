Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A274D331A61
	for <target-devel@vger.kernel.org>; Tue, 17 Mar 2026 04:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773721851; cv=pass; b=GgroZ23Yt1QzbbM6156lSfD1TA/rlepBFdM+bfCs5QNIwtsiqUJ559iiJLKfu31sZiGu0T3PnEGEVlYAMISj93IT8wyKi5w1NtYDTGUMGceNEufOPHRN5ArQuPGdf+t1pYcC1OVSpWNlWqxFOXOUk6/79LbvGnk62YCwxahZv+I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773721851; c=relaxed/simple;
	bh=+qEdsUsTBQ5PdU99AN+GVBCS7vF9AHbvt2iuwIsGSck=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YQGgXdx4CDFWeW0TwAjOAP1d9t2TV+UZFHhhPaFDamCAvxO9wQTTBExiBdERtBd/yPSrcFy8ZmMUzkJ8mZH9WrkNMUoh74ammzGS976siffzAPDpj6B7Vol4oyT+BAwcK2RG3Vzrg1e1rO5m67WJkYQSgmKKpBhGmKX5+SI+PAQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dcHz9jWS; arc=pass smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dcHz9jWS"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-5091ed02c54so192491cf.1
        for <target-devel@vger.kernel.org>; Mon, 16 Mar 2026 21:30:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773721848; cv=none;
        d=google.com; s=arc-20240605;
        b=doIEaD2kbPSFWziusMU/NlMvW1mZ/Ati7VMhlLN8+XBe3OBZxo90GnBj6PksjFekkj
         GW/I8kUr/3uVZnu8vDZABX2CsDANCrydu0JPxynNT9f0pTK1RteKG3fOQhW/BRlyhY9d
         FAG4tnsa9aUNlnx6wi9iOjqJX6flMoU8CfSJN3FrO4BnwJexxGuMYh7l7yNCAwMsE+rk
         LhZUR6rWjxy0cL6aFAE0cHCTElXxm84qx14/WCr8x8rQl7BV7uqNDNfR18lpoC/SLivI
         as8mEX7/slge6JC+YNzxAWoJq3hFPQ7WwYhRNnng0BrMGg9lrUTeJHRNm1DEuGhBText
         2bYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pFQPhmx+ISxO6Fn3xc13MwW50zT+1NZPXlLC27SUdek=;
        fh=LUdrQ79ggpTaIa1trQFyVEOhRRZNnSGAYO1Pxp0xdO4=;
        b=fnRWs5u/jFyT/q8Qcws7XMWwQ1YOvOiLvt+gm4EjpFgPVMjls7Fw61C2vGWz6+Bqnt
         TSddYANN7GpyciKNPTm8mCSSxQaUuGPrcK9C+QJQpeby67xUxirrLP7X+WhRJ9VEbOOI
         zq4y6di64wTsAWtOXMNcLV2cdfW6+kxfFRxqd5DzYWWplImuxwCv+v9BKXViMIHwkEtS
         BjBv5bklLP9DJq8SknOzqMcn95YJ+G184eLBOKcQwFKD9RU6e4GF8xAKcsQB4f3M5r/r
         aN0AaxOWHLEYTPR5nufOz8GTOp8haJMEzoZTX5l1t0wcCkocGd3tdKa454fbh+vUsaV+
         36VQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773721848; x=1774326648; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pFQPhmx+ISxO6Fn3xc13MwW50zT+1NZPXlLC27SUdek=;
        b=dcHz9jWSigF+3BARnPnbKteLX4VaADjtLsdaMyhGyNJV6JIimRYsLO4x7EbK9BzBKm
         mEBNOo5L0VUPl/dip+HXrZAa92QHbbWUxIR33fHYlLzQokFDwQJjBzeRf/caR0pjg2Mo
         34+rdKlPO1pqvYIaUSk19WaF9PSBtDSVR0MEozQlDzToqkl/jokmLSbZZk4UFJtqHEmi
         kXCC+DmS5SZkg30BADq3NkbtYVryfdZAaKXoYS6JLFIzqMyrVPWUXccsrILfv3Xl/Xkd
         r80MwV7t7nyhZxw2K0hrEcQ6qFdzAhEIEtys7scmuZDaSQSy0hx5l9Sk892/mMBb7UNJ
         O8MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773721848; x=1774326648;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pFQPhmx+ISxO6Fn3xc13MwW50zT+1NZPXlLC27SUdek=;
        b=Wr4r8/q+Ora6AnqmfL5j8uEkpS05i+vuv0MNS9iHBJEzfh2pg4n+KljnT8+t6KbG7K
         0UCjMwT01LvWa1Lr6HxV2KcjEIKb2EQrnl/i1vf7bsqtTIdKpknmjx4ql49WsvpkMpja
         IstKU17A6l87Ej17iMVCgVuyQlbaevWDFcbalPzvjaqLv20IkM9TeITmU3bYmexwE+DZ
         wF7xjcCm+1FVFnAqo8a1JZp/KQIEVH6N+Myr6cT2GnaLNvch+RLs5ft5Y+wyt7Y13PU+
         CIZ/8kj2vMtM8H6agiH8ljjVPEo/nvDNsZH22srhDcJUjWyA2VvGplkSZnAMhhPNNTbH
         jjwA==
X-Forwarded-Encrypted: i=1; AJvYcCXjF/IofkHiFV32wKVM8MgPxC8mJAKQJMKJwGfupAHgdABHLoUUC5V5ckqp8rMZ0GahiD9wjSGWRjASQrI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwAQ5AdG9HsOJbaXpfCYga3x51MsGcJtcO2jk8hDzD5x8hnollb
	HoIsQvcVkq/e/PZpl4O+smf8k9yQPTtK5hp2++rfxAsgCzbPclJ5vJs3k4b84LyEhaPc59uDb2V
	yTSpCKiJlU1xhMErc1o8a+sQjPwQvpXfFyFul6mQQ
X-Gm-Gg: ATEYQzycBupOfNYZV6aCHBPBlDOob3l2s+Or1Eh8GOL6Q1+vm1OfVJN1uvRy7T9v4/X
	IEdih5F5LXaFUtiXcK+4SnacxBlIFmtBQuV8Oc7kPZu+FEThhDWm1kKzIlTZvihWRkINatJEUcD
	VxQlkorhpoeYSQvvSt3E4/7ZZmgG+OxDwUBTgBz9xFHZ8aSI1utjkqvNWUhAhczVpmFuPUW4uEe
	EEsxkz8E49u468J7QOuGVi2Bwk0+4ubCewd+YrG9ovvq1RTE1PVdmNFuSQwjBmwgQZMH0XEU+BI
	m58WSw==
X-Received: by 2002:a05:622a:1b92:b0:509:1eca:6d24 with SMTP id
 d75a77b69052e-50998c190femr8741161cf.2.1773721847648; Mon, 16 Mar 2026
 21:30:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1773695307.git.ljs@kernel.org> <77fbdae93f250fa1551f3052fc9034739795ff20.1773695307.git.ljs@kernel.org>
In-Reply-To: <77fbdae93f250fa1551f3052fc9034739795ff20.1773695307.git.ljs@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 16 Mar 2026 21:30:36 -0700
X-Gm-Features: AaiRm50ZCLTl3QDNivnPnY48qRQMsgXcmE9SOEgt_D7vDyjlZ8af9f8bQZf6tcw
Message-ID: <CAJuCfpFdKjix2fEdZ7iSrd_nk4-5e7EUNAoCEgUc5snKzq-3Cg@mail.gmail.com>
Subject: Re: [PATCH v2 07/16] misc: open-dice: replace deprecated mmap hook
 with mmap_prepare
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

On Mon, Mar 16, 2026 at 2:13=E2=80=AFPM Lorenzo Stoakes (Oracle) <ljs@kerne=
l.org> wrote:
>
> The f_op->mmap interface is deprecated, so update driver to use its
> successor, mmap_prepare.
>
> The driver previously used vm_iomap_memory(), so this change replaces it
> with its mmap_prepare equivalent, mmap_action_simple_ioremap().
>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  drivers/misc/open-dice.c | 19 +++++++++++--------
>  1 file changed, 11 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/misc/open-dice.c b/drivers/misc/open-dice.c
> index 24c29e0f00ef..45060fb4ea27 100644
> --- a/drivers/misc/open-dice.c
> +++ b/drivers/misc/open-dice.c
> @@ -86,29 +86,32 @@ static ssize_t open_dice_write(struct file *filp, con=
st char __user *ptr,
>  /*
>   * Creates a mapping of the reserved memory region in user address space=
.
>   */
> -static int open_dice_mmap(struct file *filp, struct vm_area_struct *vma)
> +static int open_dice_mmap_prepare(struct vm_area_desc *desc)
>  {
> +       struct file *filp =3D desc->file;
>         struct open_dice_drvdata *drvdata =3D to_open_dice_drvdata(filp);
>
> -       if (vma->vm_flags & VM_MAYSHARE) {
> +       if (vma_desc_test(desc, VMA_MAYSHARE_BIT)) {
>                 /* Do not allow userspace to modify the underlying data. =
*/
> -               if (vma->vm_flags & VM_WRITE)
> +               if (vma_desc_test(desc, VMA_WRITE_BIT))
>                         return -EPERM;
>                 /* Ensure userspace cannot acquire VM_WRITE later. */
> -               vm_flags_clear(vma, VM_MAYWRITE);
> +               vma_desc_clear_flags(desc, VMA_MAYWRITE_BIT);
>         }
>
>         /* Create write-combine mapping so all clients observe a wipe. */
> -       vma->vm_page_prot =3D pgprot_writecombine(vma->vm_page_prot);
> -       vm_flags_set(vma, VM_DONTCOPY | VM_DONTDUMP);
> -       return vm_iomap_memory(vma, drvdata->rmem->base, drvdata->rmem->s=
ize);
> +       desc->page_prot =3D pgprot_writecombine(desc->page_prot);
> +       vma_desc_set_flags(desc, VMA_DONTCOPY_BIT, VMA_DONTDUMP_BIT);
> +       mmap_action_simple_ioremap(desc, drvdata->rmem->base,
> +                                  drvdata->rmem->size);
> +       return 0;
>  }
>
>  static const struct file_operations open_dice_fops =3D {
>         .owner =3D THIS_MODULE,
>         .read =3D open_dice_read,
>         .write =3D open_dice_write,
> -       .mmap =3D open_dice_mmap,
> +       .mmap_prepare =3D open_dice_mmap_prepare,
>  };
>
>  static int __init open_dice_probe(struct platform_device *pdev)
> --
> 2.53.0
>
