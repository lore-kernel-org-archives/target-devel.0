Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2357E14D719
	for <target-devel@vger.kernel.org>; Fri, 17 Apr 2026 01:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776390800; cv=pass; b=a3D0/hd3yZHRALWZk2bqJ/yCbx4FQ5Lz2Tu90FtzDtlAnnNWMi+QKXy3e6Bwx4FJqk+N7e50rybRtcyQZiMNyXQWg/HhRUI8oqumlwgWTJmtHv3jfjC/sXy502Us4brvRM7PkMjpIWlYQ0u5xhpnKeLj7tp1YK0s/5QB8ezn+cs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776390800; c=relaxed/simple;
	bh=kOPxik6cGe9f5V9/eiojkqgQAZA5gmwpTfXIgNGzy6s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o4ofiVvp5G5gYyPt1pas8WSenGJ34mgBCmuNOIU9LGaV1jYk/70IGe2DF8pV9LF/hXn0WlyicE4qkR7BJE7UXfvPCehXidQpfDSNc7pKpJVlzev/tX7nCggKKLhkfitxF42BGUcIgzti/9KruewwnmcXBFJf0ocNadUbQXFkVY8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=GwU6xmwC; arc=pass smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="GwU6xmwC"
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-41540f23deaso12287fac.2
        for <target-devel@vger.kernel.org>; Thu, 16 Apr 2026 18:53:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776390797; cv=none;
        d=google.com; s=arc-20240605;
        b=Li+p85aE8RXg5b1b9frdwhmehQ0xbNNSeLs/41238JuQ0yMsDuyEh+aZIGTHvKWwau
         5SDAy5QEEDUwbh2UhuWQcIHpHlRfuxKDYtWA2IYGHX6A6yUfWa1WublvgqkXDMEIdc3L
         vGU83j3Kf01E1PpgsaZHNJUm5OwsuGfSoFTg2OD9Qm7un8hlH2IM3RNkj+bt4wjbEzYw
         6ECaVOjFBd05gHGanzSTvqtusDC01bcIgFdLoTgiFyyRXYMcxuR/VGpoTD5fo8nY+5Yj
         XZy/e5OVBrWcFMJe48CuIveaKQDpl3UDXWORxYfCYuvy5shG2rafZMc5WRXqQFjo5lOo
         raWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+KsO1NaX9EqdvAZLJ/Ig7h5Lud7184o3UpmgRp/VzKQ=;
        fh=NIx+zawwPkfpPNJJBLoGr4FpBOh/Le80KaWuV7BoSwk=;
        b=O/mcaSAi0zh2fXA/s+UGfBHTqjuerfyPHod+swL8hjw9cfRJBiGqJU8wrnMkMUpfve
         NJvUVGXM/K7yEXZfVctfzHBXEMZqacW95SOQzTz6jBVgmrt1ar86IJlRbvZOjLzH89T0
         SJ6lK9F4cIsoGP8Q6tZTff0sDjtlDjRffEESwjVzX/KbS3GmaGBpJ70RbrO25PMGxdOi
         zjHsVRli+b6KJxrdmvXv1YaxrCga46BF26TUojfXnUqQv/M57eePOLUA5ufKstqjnEzy
         gVExklFR+aGeKHKd9xhSZxKZJkTpAJ+3252UQc2/L6fuSU75MSYTxlbNwXjzDozn9NgF
         /Ijg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1776390797; x=1776995597; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+KsO1NaX9EqdvAZLJ/Ig7h5Lud7184o3UpmgRp/VzKQ=;
        b=GwU6xmwCvRkFrguBVDxYY/dZq2a9YCy4ai+T5H7owxALjG17//ep4JHehrP6YAzifb
         2ogTtmAg4CuNGIpB0cc0vWNM1dsvlL2xdE0DpBJ7W325FC4H5dnYOE2CDXZj/eKAfSJC
         iE+jlmKMOcQCvnPxJH1o8lYDI4e9ZAShcU01AseNT8CvEGvyl0cy+ZLvNglGxi+/Gth2
         4GUyCKTDg67W66qR0RVwq0miehQxf8j4gIcpB+mO+gUCZB2dS7/vvR4xqhUlvezX4Ape
         wlLnCo/vZVAc+v+ywf5N9istG+iM/FpxaQj33/FOXT+FAzDSY9DXcyEg6BRrK+ROoGEr
         pjxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776390797; x=1776995597;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+KsO1NaX9EqdvAZLJ/Ig7h5Lud7184o3UpmgRp/VzKQ=;
        b=QnvNZnwhz+/qGgtncr0b+KKXtnWS+3SxpYoIy3gFz7mJ2Jl+HkfzYd0Gxh2aSCmGom
         zfVOyTqypxv+vPWqPsn+OxH+BJcu1aZGqyNX4CLwCzWQaMaJVyqR3zLbmboV53792QQM
         KGrtgDZRGBysY+IVYuQFN100svgRrcGf1RdXKfCPdaproaPFi0ed3NJ9QwbWsMSLRuAC
         O9J2ulHkcwBfbVtb1HTQ0iDdBJ4Og4toTAP8uF+TN+BQ5QWvdHgZa6lwQ1xcIt/cfj9E
         vBiwb3hiMfwbw/vPxjtHIkzIdLOGLE80Y1zDS23OpX/j0sRER/TCpKVpeqdKlTuqZi06
         2ISQ==
X-Forwarded-Encrypted: i=1; AFNElJ/rN6J5K8RgHvQnZqrhqFiTM1/aGfRaN1R5adD7AS0No7GR7Z3ahDQFPOfOx3PYLE/knYPrr+07WE2IQ/A=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKgv0zHQ7aSPa9EKhGdFKlr/Rbw4TluuFroJqpNErWC0C2QW9g
	H29AJ9+04hQkTzV/Jx0wcnFCkbd56bJ3Qj7ij+sYXLpgiZV1x48U3eUqPNCHGoXWjOnLZ21K8FU
	yKeyt/0qzuJ6hzszlg28NJ8yk3xePFSoXMmqwhHp0GQ==
X-Gm-Gg: AeBDietuczPoe7z94asULawIwKk6xaJYhHJWOXoq75k6cxP4mOA2G7e/AwG108Be0RV
	ziFFe909MiRzjbKa68N22KjGrwd38HeVCfCiKVHCwZSpzO60BUGl2ilSwnP+L7IfatgTTFE8Sbs
	IJKsDiQbpVRHpW0BEjufA84kmXPPNnZjkXkwQcIoF8eh7j5ddqcDXdwQCUvkfu47hfvyx4TG3bN
	2c6LJqONsKfnffIcWRmI8rRwS5kVBi/W3T9zWCsYjjJtsYoN8UQTU0aD5ITaTfivzFCXAjo4Zj7
	FhExch+KmxhxGFmSXSk=
X-Received: by 2002:a05:6871:ea06:b0:423:e2d:bcd5 with SMTP id
 586e51a60fabf-42abee7a63fmr242473fac.0.1776390796946; Thu, 16 Apr 2026
 18:53:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260416002214.2048150-1-csander@purestorage.com>
 <20260416002214.2048150-7-csander@purestorage.com> <20260416052325.GE14950@lst.de>
In-Reply-To: <20260416052325.GE14950@lst.de>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 16 Apr 2026 18:53:05 -0700
X-Gm-Features: AQROBzCPGHONvWMncmYhZ1NMXp33B6ERld-DgLK_KyRg3_SVXkVvrIxlwuDEnA0
Message-ID: <CADUfDZpbOhO9BUW_mFZYh9-UZU26_o3rFGBffNTpepk0ogJhZw@mail.gmail.com>
Subject: Re: [PATCH v2 6/6] blk-integrity: avoid sector_t in bip_{get,set}_seed()
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagi@grimberg.me>, 
	Chaitanya Kulkarni <kch@nvidia.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 15, 2026 at 10:23=E2=80=AFPM Christoph Hellwig <hch@lst.de> wro=
te:
>
> On Wed, Apr 15, 2026 at 06:22:14PM -0600, Caleb Sander Mateos wrote:
> > bip_set_seed() and big_get_seed() take/return a sector_t value that's
> > actually an integrity interval number. This is confusing, so pass
> > struct blk_integrity and struct bio instead to bip_set_seed() and
> > convert the bio's device address to integrity intervals.
> >
> > Open-code the access to bip->bip_iter.bi_sector in the one caller of
> > bip_set_seed() that doesn't use the bio device address for the seed.
> > Open-code bip_get_seed() in its one caller.
> >
> > Add a comment to struct bvec_iter's bi_sector field explaining its
> > alternate use for bip_iter.
> >
> > Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
> > Suggested-by: Christoph Hellwig <hch@infradead.org>
> > ---
> >  block/bio-integrity.c               |  5 ++---
> >  block/t10-pi.c                      |  2 +-
> >  drivers/nvme/target/io-cmd-bdev.c   |  3 +--
> >  drivers/target/target_core_iblock.c |  3 +--
> >  include/linux/bio-integrity.h       | 11 -----------
> >  include/linux/blk-integrity.h       | 14 ++++++++++++++
> >  include/linux/bvec.h                |  1 +
> >  7 files changed, 20 insertions(+), 19 deletions(-)
> >
> > diff --git a/block/bio-integrity.c b/block/bio-integrity.c
> > index 3ad6a6799f17..e9ae5db99f64 100644
> > --- a/block/bio-integrity.c
> > +++ b/block/bio-integrity.c
> > @@ -103,13 +103,12 @@ void bio_integrity_free_buf(struct bio_integrity_=
payload *bip)
> >
> >  void bio_integrity_setup_default(struct bio *bio)
> >  {
> >       struct blk_integrity *bi =3D blk_get_integrity(bio->bi_bdev->bd_d=
isk);
> >       struct bio_integrity_payload *bip =3D bio_integrity(bio);
> > -     u64 seed =3D bio->bi_iter.bi_sector >> (bi->interval_exp - SECTOR=
_SHIFT);
> >
> > -     bip_set_seed(bip, seed);
> > +     bip_set_seed(bip, bi, bio);
> >
> >       if (bi->csum_type) {
> >               bip->bip_flags |=3D BIP_CHECK_GUARD;
> >               if (bi->csum_type =3D=3D BLK_INTEGRITY_CSUM_IP)
> >                       bip->bip_flags |=3D BIP_IP_CHECKSUM;
> > @@ -472,11 +471,11 @@ int bio_integrity_map_iter(struct bio *bio, struc=
t uio_meta *meta)
> >
> >       it.count =3D integrity_bytes;
> >       ret =3D bio_integrity_map_user(bio, &it);
> >       if (!ret) {
> >               bio_uio_meta_to_bip(bio, meta);
> > -             bip_set_seed(bio_integrity(bio), meta->seed);
> > +             bio_integrity(bio)->bip_iter.bi_sector =3D meta->seed;
> >               iov_iter_advance(&meta->iter, integrity_bytes);
> >               meta->seed +=3D bio_integrity_intervals(bi, bio_sectors(b=
io));
> >       }
> >       return ret;
> >  }
> > diff --git a/block/t10-pi.c b/block/t10-pi.c
> > index 787950dec50a..71367fd082bd 100644
> > --- a/block/t10-pi.c
> > +++ b/block/t10-pi.c
> > @@ -510,11 +510,11 @@ static void blk_reftag_remap_prepare(struct blk_i=
ntegrity *bi,
> >  static void __blk_reftag_remap(struct bio *bio, struct blk_integrity *=
bi,
> >                              unsigned *intervals, u64 *ref, bool prep)
> >  {
> >       struct bio_integrity_payload *bip =3D bio_integrity(bio);
> >       struct bvec_iter iter =3D bip->bip_iter;
> > -     u64 virt =3D bip_get_seed(bip);
> > +     u64 virt =3D bip->bip_iter.bi_sector;
> >       union pi_tuple *ptuple;
> >       union pi_tuple tuple;
> >
> >       if (prep && bip->bip_flags & BIP_MAPPED_INTEGRITY) {
> >               *ref +=3D bio->bi_iter.bi_size >> bi->interval_exp;
> > diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io=
-cmd-bdev.c
> > index f2d9e8901df4..2c4b312f2f55 100644
> > --- a/drivers/nvme/target/io-cmd-bdev.c
> > +++ b/drivers/nvme/target/io-cmd-bdev.c
> > @@ -218,12 +218,11 @@ static int nvmet_bdev_alloc_bip(struct nvmet_req =
*req, struct bio *bio,
> >               pr_err("Unable to allocate bio_integrity_payload\n");
> >               return PTR_ERR(bip);
> >       }
> >
> >       /* virtual start sector must be in integrity interval units */
> > -     bip_set_seed(bip, bio->bi_iter.bi_sector >>
> > -                  (bi->interval_exp - SECTOR_SHIFT));
> > +     bip_set_seed(bip, bi, bio);
> >
> >       resid =3D bio_integrity_bytes(bi, bio_sectors(bio));
> >       while (resid > 0 && sg_miter_next(miter)) {
> >               len =3D min_t(size_t, miter->length, resid);
> >               rc =3D bio_integrity_add_page(bio, miter->page, len,
> > diff --git a/drivers/target/target_core_iblock.c b/drivers/target/targe=
t_core_iblock.c
> > index 1087d1d17c36..4e0fa91a08fd 100644
> > --- a/drivers/target/target_core_iblock.c
> > +++ b/drivers/target/target_core_iblock.c
> > @@ -706,12 +706,11 @@ iblock_alloc_bip(struct se_cmd *cmd, struct bio *=
bio,
> >               pr_err("Unable to allocate bio_integrity_payload\n");
> >               return PTR_ERR(bip);
> >       }
> >
> >       /* virtual start sector must be in integrity interval units */
> > -     bip_set_seed(bip, bio->bi_iter.bi_sector >>
> > -                               (bi->interval_exp - SECTOR_SHIFT));
> > +     bip_set_seed(bip, bi, bio);
> >
> >       pr_debug("IBLOCK BIP Size: %u Sector: %llu\n", bip->bip_iter.bi_s=
ize,
> >                (unsigned long long)bip->bip_iter.bi_sector);
> >
> >       resid =3D bio_integrity_bytes(bi, bio_sectors(bio));
> > diff --git a/include/linux/bio-integrity.h b/include/linux/bio-integrit=
y.h
> > index af5178434ec6..edcd0855abba 100644
> > --- a/include/linux/bio-integrity.h
> > +++ b/include/linux/bio-integrity.h
> > @@ -56,21 +56,10 @@ static inline bool bio_integrity_flagged(struct bio=
 *bio, enum bip_flags flag)
> >               return bip->bip_flags & flag;
> >
> >       return false;
> >  }
> >
> > -static inline sector_t bip_get_seed(struct bio_integrity_payload *bip)
> > -{
> > -     return bip->bip_iter.bi_sector;
> > -}
> > -
> > -static inline void bip_set_seed(struct bio_integrity_payload *bip,
> > -                             sector_t seed)
> > -{
> > -     bip->bip_iter.bi_sector =3D seed;
> > -}
> > -
> >  void bio_integrity_init(struct bio *bio, struct bio_integrity_payload =
*bip,
> >               struct bio_vec *bvecs, unsigned int nr_vecs);
> >  struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio, gfp=
_t gfp,
> >               unsigned int nr);
> >  int bio_integrity_add_page(struct bio *bio, struct page *page, unsigne=
d int len,
> > diff --git a/include/linux/blk-integrity.h b/include/linux/blk-integrit=
y.h
> > index 825d777c078b..3a2e55e809c5 100644
> > --- a/include/linux/blk-integrity.h
> > +++ b/include/linux/blk-integrity.h
> > @@ -85,10 +85,24 @@ static inline unsigned int bio_integrity_bytes(stru=
ct blk_integrity *bi,
> >                                              unsigned int sectors)
> >  {
> >       return bio_integrity_intervals(bi, sectors) * bi->metadata_size;
> >  }
> >
> > +/**
> > + * bip_set_seed - Set bip reference tag seed from bio device address
> > + * @bip:     struct bio_integrity_payload whose ref tag seed to set
> > + * @bi:              struct blk_integrity profile for device
> > + * @bio:     struct bio whose device address to use for the ref tag se=
ed
> > + */
> > +static inline void bip_set_seed(struct bio_integrity_payload *bip,
> > +                             const struct blk_integrity *bi,
> > +                             const struct bio *bio)
> > +{
> > +     bip->bip_iter.bi_sector =3D
> > +             bio_integrity_intervals(bi, bio->bi_iter.bi_sector);
>
> The bip is pointed to by the bio, so we don't need to pass it separately.
> Same for struct blk_integrity.

I did consider that, but all callers already have bip and bi in
variables that they also use elsewhere. Seemed like it might be
slightly more efficient to just pass the precomputed values instead of
looking them up again. Not a big deal either way. I'll go ahead and
implement your suggestion.

Thanks,
Caleb
