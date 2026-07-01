Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E23514B959
	for <target-devel@vger.kernel.org>; Wed,  1 Jul 2026 19:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782935799; cv=pass; b=rxh5DWgOUF5xHeAY3gQGP07iUSTO76V1DmzK8BLroIys4TdqMM/0G3DL79X6D/UNSKxQqlrAk7UvTjmtMaapq21wuF/3lDpTtU4AlN3B+w17dmWAHh5Mu+N8v6ryS2bX7bjZbIa+mAAsBWIEoHRH+umxO48peb+Zs41+WeEv4Rs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782935799; c=relaxed/simple;
	bh=KoFkJKqOZpBo9LxusJau6YmmTGqiKlHE4BPUGelmuaQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uiir2JCq8Xg0geiYP4v+sY43cfTessMEmGkHql74BmYzpCZ+t4xri5Slzmq1iBkyiyvd7OccbfaXr9jhFRvG3IC2PgMNTeRgEzlwllp7sSOwca1XL2Fxb4P2vsTzV+50vLycIaQmqBquAvqRskmgWNYGhR5gL5Y8RrG1EhVlfMo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=RPTdIJgb; arc=pass smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="RPTdIJgb"
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-6a181b545e9so78724eaf.0
        for <target-devel@vger.kernel.org>; Wed, 01 Jul 2026 12:56:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782935795; cv=none;
        d=google.com; s=arc-20260327;
        b=Rkk1zAUGM6TkkZD2W/Tu7siBWy9UHg1HJ/tt60D7SaXdEFXpO6EA6LtUfiGeI9tvci
         fUGzdBMbdtSJISvJUwrJ0ZZZDTKGNxkl/APImy8mPmglBWMduRjy3KB58EB6B28FWgDY
         gQaX6eEEhl9sXgyFLJS6W+RVlcd4DiXYW6sQ78cbhk44jKiENuZYljS1/Of5Vwai6L2w
         W38bDyQwCec8a8H6XqFQ6nX1hCUN7Jn6osQCdjCTyhH5+c067j/HkQX3DYxGxIV98Dv7
         GmRhqxq3xn5zMp8y4m6V0yDpphJhP6Z3dI+fEDSFk/Yp1yjZ8rCzfJupaa5eg+GDz/xc
         P0tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mtIVN0DqJBgCNlfEAAUMuGRPuwtbmUfKPGcnXNrwZLM=;
        fh=rMbKQwRira40odx/ayBLXy/XWbi+0kQF7JAt37u9rnE=;
        b=o4J+LZyGymzXFJVHcj8NqbKihMyzx2LrH5g1fOSu0vv/ddkupY1eTDGQxx5QxjR6JK
         RMfUgnEI+/zgN6Lhw4FEmaeZ41Pq+QgFQANmO3orvzKYSdrAUMIJoBVRT5kOI3/b3fGZ
         QUtiNPTDYSSGfmrdD50KqgPXuQXS7M8zmKhBQ0nWvP+0wt/mstA8bWmEF28YG5Y4bCtf
         ksnukBT/MQoVBTbDBbVf0EDJnSmDm6C26rvblDisRQGVRjzJeh8N7xLittIugVxDH2Aq
         nRtsBXeM1iSdO+zouo2OZA3+jDOa8xz3sSa1He5qFaHFAsrthE2YHhxUWJ0Sg9Gt9C5d
         HkJA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1782935795; x=1783540595; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mtIVN0DqJBgCNlfEAAUMuGRPuwtbmUfKPGcnXNrwZLM=;
        b=RPTdIJgbadMMMI77vkIsKOaFJYsysluGNmgen+IR0V80ycKF7UOkcEijW97k3md5nE
         7MNcD51WwHnziverBts1qSSELmGIiSLAWZaYpwXb0dMWAxdyBxgIoetCpWnAtcYq1/5H
         Rvz+K2Sggd9LAVrqMwQCovypGAqdyq5nY4gGsIMpe/DOnlouY1wZkjjAQguHWDE23Gew
         S6jlFDLhH65+UxfrJMK2aBOYYWlpYuMyu9TI8FCEk2Q3FDKK2TlGoC7tL2vr0P23BWt/
         D87VcZs8tAz5i3ZhdCvkqbE928thbhsWHmPziB4tU7xNi+bhpf/ZNp6StO4328Unwd4G
         LIWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782935795; x=1783540595;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mtIVN0DqJBgCNlfEAAUMuGRPuwtbmUfKPGcnXNrwZLM=;
        b=EW3I2iMhaSWRsGCql1eVJOvpUbSDHUt4NuxQIzCPlBeOLq0sVqxCg3AvAwNUdZnrY1
         BE9ibIu9wqrUH/YOeCg0W/kdv7CZDysA+GQE9X1DKBo33q7FWoQnSuSS9uk+I5FzNsaY
         zHGjaGvAS8dz7xL7kvjn8jet84Z/xJScT5BuvPj6FZVY9QCubwmL4FU9Og8q6J4fpMum
         FQY+f9RCq10BsVY4XNvwIIGtZaXEFDRpHJPlUOdOXt6GQDSx5Xi6E/Qt00xby1OjA/eT
         GRMV6vkulM27pheOWfpDsj6kB+8co6SMVbU8TJ6GDmKFjy3BhlwXAG4Mwm0rSmlhDfyZ
         uCFQ==
X-Forwarded-Encrypted: i=1; AFNElJ/eJRf4k+DU0T/b/Mg2vfe2uxHNmB5a0dw1jfXF4MUYYPvQ78GNnk/eV9obDMsilGLPQPn3ZAZfU3WZ1+k=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6Vh4/BaRsU+4WTRy/tWSBUtZ3YP0xc4Twmdkseu1QHK25UX8k
	De7E4Rt2Xf4aiuiBFC5lUg0oFexoIPjPVPcoOa0JPe11fPLO5yC2evvIVWpsgBOtwwzLRJQk/tz
	7zkkksJzdWXK+DCUsBX6R6H7TDwbGKjIEMbnGtQl2yg==
X-Gm-Gg: AfdE7cl9WGcIizljnjDeX3iZj0uGMNfPCm9MyF8jNCgJApavDe78aZLReMN50unEStS
	NTM/69CV6+WMgzfufU+9AXUmNi4r4dpfoUd5AAp076UMEuDB5L+zopIPDtwBNz8an2unb1qT4hT
	Lp99eG/C2GSDKFGSx8NQjCja11zDd/QJQecylXspRpYVn2+IxDK/Gbla9QimGP7B65leBPBxBuo
	TyMzuDeUCJGz31h44MAECeoeDkZQC6EnxI1EabMd+QA6i2qBnxVh3X3sFPIetA7jDwlp3pn6dEl
	J5jv2WqZ
X-Received: by 2002:a05:6820:7705:b0:6a0:ee7d:80ea with SMTP id
 006d021491bc7-6a30974705amr995871eaf.0.1782935795443; Wed, 01 Jul 2026
 12:56:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260627054220.2174166-1-csander@purestorage.com> <20260627054220.2174166-2-csander@purestorage.com>
In-Reply-To: <20260627054220.2174166-2-csander@purestorage.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Wed, 1 Jul 2026 12:56:24 -0700
X-Gm-Features: AVVi8CcoTxYjhA4dG7f1i1JCHKMq7tvfJVmlu_uynO4PEoI0alXFMGjmDjqio0g
Message-ID: <CADUfDZqE6JLLbugK+qYe=XFSLV5zUwFEQ6qRqvJ-=uVs8OtfVg@mail.gmail.com>
Subject: Re: [PATCH v4 1/5] block: use integrity interval instead of sector as seed
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	Chaitanya Kulkarni <kch@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 26, 2026 at 10:42=E2=80=AFPM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> bio_integrity_setup_default() and blk_integrity_iterate() set the
> integrity seed (initial reference tag) to the absolute address in the
> block device in units of 512-byte sectors. However, Type 1 and Type 2
> ref tags are actually the least significant bits of the integrity
> interval number. On devices with integrity interval size > 512 bytes,
> the ref tag seed thus isn't the correct initial ref tag. The ref tag
> seed is correctly incremented/decremented in units of integrity
> intervals in bio_integrity_map_iter(), bio_integrity_advance(), and
> blk_integrity_interval().
>
> For REQ_OP_{WRITE,READ}, blk_integrity_{prepare,complete}() covers up
> this ref tag seed discrepancy by adding/subtracting the difference
> between the initial integrity interval and ref tag values to/from each
> ref tag in the protection information. However, REQ_OP_ZONE_APPEND can
> also carry PI but doesn't go through blk_integrity_prepare() because the
> final data location on the zoned block device isn't known until the
> operation completes. As a result, the REQ_OP_ZONE_APPEND PI ref tags
> start from the ref tag seed, which isn't in integrity interval units.
> Subsequent reads of the appended blocks will fail to remap the ref tags
> from the expected integrity interval numbers to sector numbers.
>
> Additionally, NVMe and many SCSI transports support offloading ref tag
> remapping to the device by specifying the expected initial ref tag in
> the command. The kernel doesn't currently take advantage of this, always
> remapping ref tags in software for reads and writes and setting the
> expected initial ref tag to the integrity interval. Setting the ref tag
> seed in units of integrity intervals would be a prerequisite to allowing
> the kernel to skip the software remapping and pass the ref tag seed as
> the expected initial ref tag in the command.
>
> So compute the ref tag seed in units of integrity intervals instead of
> sectors to avoid relying on ref tag remapping for the conversion.

Martin, are you okay with this updated commit message? Would be nice
to get this fix in so auto-integrity works correctly for zone appends
on 4KB-integrity-interval devices.

Thanks,
Caleb


>
> Fixes: 0512a75b98f8 ("block: Introduce REQ_OP_ZONE_APPEND")
> Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
> Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/bio-integrity.c | 3 ++-
>  block/t10-pi.c        | 3 ++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/block/bio-integrity.c b/block/bio-integrity.c
> index b23e2434d80c..d20f9002c7c9 100644
> --- a/block/bio-integrity.c
> +++ b/block/bio-integrity.c
> @@ -102,12 +102,13 @@ void bio_integrity_free_buf(struct bio_integrity_pa=
yload *bip)
>
>  void bio_integrity_setup_default(struct bio *bio)
>  {
>         struct blk_integrity *bi =3D blk_get_integrity(bio->bi_bdev->bd_d=
isk);
>         struct bio_integrity_payload *bip =3D bio_integrity(bio);
> +       u64 seed =3D bio->bi_iter.bi_sector >> (bi->interval_exp - SECTOR=
_SHIFT);
>
> -       bip_set_seed(bip, bio->bi_iter.bi_sector);
> +       bip_set_seed(bip, seed);
>
>         if (bi->csum_type) {
>                 bip->bip_flags |=3D BIP_CHECK_GUARD;
>                 if (bi->csum_type =3D=3D BLK_INTEGRITY_CSUM_IP)
>                         bip->bip_flags |=3D BIP_IP_CHECKSUM;
> diff --git a/block/t10-pi.c b/block/t10-pi.c
> index a19b4e102a83..e58d5eb6cefb 100644
> --- a/block/t10-pi.c
> +++ b/block/t10-pi.c
> @@ -308,18 +308,19 @@ static blk_status_t blk_integrity_iterate(struct bi=
o *bio,
>                                           struct bvec_iter *data_iter,
>                                           bool verify)
>  {
>         struct blk_integrity *bi =3D blk_get_integrity(bio->bi_bdev->bd_d=
isk);
>         struct bio_integrity_payload *bip =3D bio_integrity(bio);
> +       u64 seed =3D data_iter->bi_sector >> (bi->interval_exp - SECTOR_S=
HIFT);
>         struct blk_integrity_iter iter =3D {
>                 .bio =3D bio,
>                 .bip =3D bip,
>                 .bi =3D bi,
>                 .data_iter =3D *data_iter,
>                 .prot_iter =3D bip->bip_iter,
>                 .interval_remaining =3D 1 << bi->interval_exp,
> -               .seed =3D data_iter->bi_sector,
> +               .seed =3D seed,
>                 .csum =3D 0,
>         };
>         blk_status_t ret =3D BLK_STS_OK;
>
>         while (iter.data_iter.bi_size && ret =3D=3D BLK_STS_OK) {
> --
> 2.54.0
>
