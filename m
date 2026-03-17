Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A92328260
	for <target-devel@vger.kernel.org>; Tue, 17 Mar 2026 04:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773722013; cv=pass; b=CMUxmIbPyHq7Z5v4tGKsUY5JP6U9X41Xjr0n9S1Ug2tO3bmuvy4hwxbXEm0CIRRmY0wC+EY74kKrxRONguHBRPoOBlf9ePc7wzJXD/JQ0H0eeEhzrPqKJ4ssKd6O0e3GnI1wOllUEHHvdCU+FcuGtyr+W1Gi2V6JitwaLQKHE5U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773722013; c=relaxed/simple;
	bh=tiOslg2ijiNLvUEule9D7TB3nKCRsqgcCv7YiVviGdo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sVspszNDwkJFW9tg2cGBeKMaUVCnte6lCQuQRHh3JUULPeENzsSqF5thg2waSUlcd6+1G8opp5a2xLrpOGgC3pEGgE8Om1ydNKqokLoPXdtQWrkEDWf0mZioJzz5D4VOP4fkHxonCZPnF53Zp3NzpG0dlqiatJsGJXAlieISmbA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XOHBHWty; arc=pass smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XOHBHWty"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-509062d829dso230971cf.1
        for <target-devel@vger.kernel.org>; Mon, 16 Mar 2026 21:33:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773722011; cv=none;
        d=google.com; s=arc-20240605;
        b=P01Sj6K47WNadrjno6FM+6CI4lD/k/6x1bLBYU6yxL1SmCWMxtrGaTT8eBdnEX9GNU
         wKHmIrBRc4B9UMUGPfLbSCnmgafhidgGadLiQGcW6jr0Goqm3V2KlIzdvxUi+y0KCMxv
         8ISiueTPeUTzqPT9AxttsrczZznmctVj8roTaJsxnHARhjm5Usw7wy6sc7djXctflxU9
         fDZq9zl6laeWEhoqwosXIf46UH8LqTOFU4a6dv0pJnL93mbYBk8qge/C8NZhtPqT17Ug
         c9eIgB5tEGEJF7oMJ9zc6KcErbQT10boVlwckN6W/rx0GyHgZkQtXz9px/HohYG29sRM
         kebg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/NEZIoIL+p9WYNIWM8eip/yr8eeRSa2d7nrT0z5B5yM=;
        fh=lM0l1yVT+RKRr9P5B4hCJZZWWfMrwwyEpVEGaISwZ64=;
        b=PwkoK4v3t7w/sM5cIP/IDnzTzbZNSbX6NAvQNpM2n2H3n7WtTvACbmHo6HEPKb63Gm
         d3sHeirqLFMoTTxTzue4RhpgFdVQn1pv9lcq7utZ5wAl8oUUi4/K1x5Y90ypfL8HDC5D
         YbffZlEC01kJkS5fNrYIpy9UoRc1qEqNk7izE+UbHA/qHoJL6jOBXly3jOKiVNHI7Euw
         K+iIo8WEcvJhppmYv4SHrXT8eNvFgXkyo7/0E8W126Vs/7DOfbRLTnD8jNOw7pU3WgUs
         6V+CXjYPnGKuSb7BErCTYCZjS3pPYU4IDnNTti5mTtYeixKY/5YAAr9AFUO0Bj+W3KKH
         ipSw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773722011; x=1774326811; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/NEZIoIL+p9WYNIWM8eip/yr8eeRSa2d7nrT0z5B5yM=;
        b=XOHBHWtyrlsh7Yoa4vNnjb6T9UyuOpn+BAQwM6/uhn8ej309RDdBFaM0vYPVNGoxBD
         fZ4VRrRF0P1oXYGRPa1P6vXDW4hEkqYusYkSgtFEpwEaBMZSkbBuOzVEGkYjLbJnG0ce
         QU79t/gmXkvF21hP+Hh0ZK69g3kK819Gvg5zCvpU2oo0xApP7o57C/wEJJ0VBa6Bacey
         wjarTwWHd65HU/pv9GZujDxU1zzk1io+Q5IMCyzum2RA6KkJ9FSc0WAExQYW1SjbtbTt
         34LW/Y1yWWNLOSsBOPPxDUV5NcywSZ15RzaSRhQvYN6v7clysze7Sd3FTfZBv4btjwv1
         gjlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773722011; x=1774326811;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/NEZIoIL+p9WYNIWM8eip/yr8eeRSa2d7nrT0z5B5yM=;
        b=JCAwUlWoTgt3aiBpyX8oKiSertBwSGpkCWf87xK0vLDrLXjiZDon0KZUriMZ2OeoX8
         vFvWyZkl/F8AWVlI4PJOKuwQLPd9O26IZ3ZakoApBncib0vcoVG08Sh5OHT01bbC3n2k
         tFv16Z9l6OiMv+bm/NgovhlbYPf4IeQJ2PA1uTet5nyM/dfqZjoTQ0+vURC438zKrgtw
         kY6waeV9iPSQTc12xhCyiX8Te5tYI9943u1DX1h3g1tKGxic2i1Aee3bC/f0nN20BbY9
         6wNlI+5z/w/EKwuGBHGcCvqr4huOriMMBujO8BGLWNik7Azm7wPN/Rh4B/TMNf2b9FOb
         3P6w==
X-Forwarded-Encrypted: i=1; AJvYcCXrpaRVvLfJ6p9L5SeeZFJTvaK3qr6siT1F0h4L9JskTYP04Tgzjg/XHl+PVKD6zZ7duEPT4TUr6+YwbJY=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywph9HwKOVSLNX6VcZiNlvJNnySzR/RUbYx+m8Ocy92lX8ALzjk
	5QUL57luc0ZGNFJppWEbpeFG9vBWVBJ2+YD9Re2abm7pKff/v0aDmGNU7rPGL6wdRTLbxnrd2sf
	spgCDgbO/5O63KbFN2U2VgRjZE5C6F/3/moCZE75w
X-Gm-Gg: ATEYQzxWxfa6tLzmPwC6bXzKx4pEum5Hc1YLQlyRcs09OGWkyQhqQJtmyfDxhfp65DP
	fO+tb0Kw9EOq2wbxcFWNGUlbqp5o5zBqB5iXthj0S/YM4hMWey18UMCIs4ts0q72gBXmsyYQXDw
	E5AaL+iH3kV+SCNXqzMt4+pz1s9VIx3TzdAlLCiTzutEju5Ys5AOHNGHEr2FLMv1xWPUDQPnunT
	MA6F1bP74F5La54EylUA7p4zgT6NuBkVF83Lpvsqz7N+VI89rdjG0nGZIh5PFja5CJV0sHeFApO
	mLb7yA==
X-Received: by 2002:ac8:5844:0:b0:509:cd7:aa18 with SMTP id
 d75a77b69052e-50998d3b42cmr9273521cf.10.1773722010151; Mon, 16 Mar 2026
 21:33:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1773695307.git.ljs@kernel.org> <a8debbca3fc7b765937e6b5b76bd9002c66b225b.1773695307.git.ljs@kernel.org>
In-Reply-To: <a8debbca3fc7b765937e6b5b76bd9002c66b225b.1773695307.git.ljs@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 16 Mar 2026 21:33:19 -0700
X-Gm-Features: AaiRm50Qx7Mej7rYBXyqChXz1IjfagNMkbSFlVwOhEN7Z-gN2V6TQSUIzNbqMWk
Message-ID: <CAJuCfpHBfD0zO60tPCEeNXSRJSoDi5Azs0LzutpYFEBW2z6JJw@mail.gmail.com>
Subject: Re: [PATCH v2 08/16] hpet: replace deprecated mmap hook with mmap_prepare
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
> The f_op->mmap interface is deprecated, so update driver to use its
> successor, mmap_prepare.
>
> The driver previously used vm_iomap_memory(), so this change replaces it
> with its mmap_prepare equivalent, mmap_action_simple_ioremap().
>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  drivers/char/hpet.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
> index 60dd09a56f50..8f128cc40147 100644
> --- a/drivers/char/hpet.c
> +++ b/drivers/char/hpet.c
> @@ -354,8 +354,9 @@ static __init int hpet_mmap_enable(char *str)
>  }
>  __setup("hpet_mmap=3D", hpet_mmap_enable);
>
> -static int hpet_mmap(struct file *file, struct vm_area_struct *vma)
> +static int hpet_mmap_prepare(struct vm_area_desc *desc)
>  {
> +       struct file *file =3D desc->file;
>         struct hpet_dev *devp;
>         unsigned long addr;
>
> @@ -368,11 +369,12 @@ static int hpet_mmap(struct file *file, struct vm_a=
rea_struct *vma)
>         if (addr & (PAGE_SIZE - 1))
>                 return -ENOSYS;
>
> -       vma->vm_page_prot =3D pgprot_noncached(vma->vm_page_prot);
> -       return vm_iomap_memory(vma, addr, PAGE_SIZE);
> +       desc->page_prot =3D pgprot_noncached(desc->page_prot);
> +       mmap_action_simple_ioremap(desc, addr, PAGE_SIZE);
> +       return 0;
>  }
>  #else
> -static int hpet_mmap(struct file *file, struct vm_area_struct *vma)
> +static int hpet_mmap_prepare(struct vm_area_desc *desc)
>  {
>         return -ENOSYS;
>  }
> @@ -710,7 +712,7 @@ static const struct file_operations hpet_fops =3D {
>         .open =3D hpet_open,
>         .release =3D hpet_release,
>         .fasync =3D hpet_fasync,
> -       .mmap =3D hpet_mmap,
> +       .mmap_prepare =3D hpet_mmap_prepare,
>  };
>
>  static int hpet_is_known(struct hpet_data *hdp)
> --
> 2.53.0
>
