Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8203333BBB1
	for <target-devel@vger.kernel.org>; Tue,  7 Apr 2026 16:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775580545; cv=pass; b=DaBjN9ybaYJRbBhqd7aZzaz6YNyjhoaFNQfa+gL7qCtzXgiF7Ou81vEt/1diIhhfmu5YfBukXRCmwY35q3vLaafsIEYsQ7uoePAj0juRJpoJyCyZPMK+mbfvjaTK86Nq7J/dQW67xwPp68C1aJJ5vIJplKs4NgZo/1tNa16ErIY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775580545; c=relaxed/simple;
	bh=nvKu8su4QhAoCTShBYhb8X1jBL0vWh/vW/5aUOBwMVc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BH3exDMmrCU0e4AnLpks+cfRE0XMezLtJpGUst/v2b/LDovqz1jsfLyZIsf4ZtCM0N6uDqdOlHj0kuLZocyCzoE/mqKj64e+FAEJ4DV6YmtY4b/aeh+jJYhCO+6LK0qEEpSQHcscmIcdJpYw1j8W54E28ZnKnRTlMx+BIERk/IE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=eFq1jPuB; arc=pass smtp.client-ip=209.85.160.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="eFq1jPuB"
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-415d7461fa5so553596fac.2
        for <target-devel@vger.kernel.org>; Tue, 07 Apr 2026 09:49:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775580543; cv=none;
        d=google.com; s=arc-20240605;
        b=O/Udgf6xouW0a9H6dT1IwpjI9FIsw2KBnVtIMkvLCjmWkHPIHSxBsDP32aenH/vUGQ
         pDN0l8Ev/1M61El4s+DACRp2Tmt6J680cs/MgHE3k3Wa08s9qwc0CLdZemXsoVLWwoW3
         zrJN2UlQiHDrf/HkdoQJLqkmlSFdgyeZS3lzL7Ykb6cNU6V8HHGgXF1l7Y+4jtCiDLTE
         2ZwgiQTiklqDLGWIdvxEnVR/LvP91AiH2+lpuN7+Qu+q4Rrg0wEW122x4UQ2x6Hb1xeq
         DbEkifqpH97hWpbd3wkifnosxDtXc1tEYawTdnBW4SEsfM0f8RSlceMMy4dDQzTNccyn
         YhVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lazOyKwXnU60c9GoYfvLsxP7atxxk5CZ7DnVJNd+0g0=;
        fh=cmUxaSlcuwOsA0mHqrUsXXSxmhH+8QsmaBc4xJpHyNk=;
        b=E8T1RKZbhFDv6WtpIEu/2xa22u3OsdmEHuuMzC2I614HdSl/G4dFdFTQce+c4D4g5o
         1cgCMisWyT0p52+bnkkHSstRk/4chKvBCYoaKDc0UNPDslRw5wKtb97EK7K9oLRIx8a9
         wQdpV7bRTO5F6+A8+OA5QdE5CAsrRUzGw9UKYiNiKntoxeWXmJJnrp038kEBIwVb/OJC
         Z5R54/tUBt8j0daGy+O+A1T50SsyR91tGVTi95Xjr0KakQYo3ah6L52qw2w5QZXUu7Bm
         r/N8AyDmNk+Bf/P6IF62dIQZ6xfIRBZECYXZTF4m0RI8ayCWBoDmuV/ll2B+jf6/uBTd
         HZZQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1775580543; x=1776185343; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lazOyKwXnU60c9GoYfvLsxP7atxxk5CZ7DnVJNd+0g0=;
        b=eFq1jPuBo9/nXQu8b60SkzvJFVvLT/scrknaWk9UWNYCfgUBW8Ti7quPN9bDkfYgzN
         uDYU2CfoHdsBOL6mFDdh6tOjRLDJVT4p4QnVuQtN4Rw2haHQ62Stc+nymwh80Iqa/kwD
         sprpBmnP8iXMOpqYmkP80fJHHI0Ggke/VCUn4bHfmT2MMqGcu+j0lgDmkCMHMLG2DC10
         pfntEZI9ssUP6X7W8vdJxWpACRpfEKDp9jDutQ5M0bqoJnaK/X89rYIe8hekZzGSwm6r
         PiZcOILwEoNiHXFnDRT+L7WnUlPV6/w3YlaNcOTnfC31pEw2w81UXDH228q4lbhIPBSv
         TQ1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775580543; x=1776185343;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lazOyKwXnU60c9GoYfvLsxP7atxxk5CZ7DnVJNd+0g0=;
        b=Z+51vZLn6Sgm5soWvd3CjVDjRg7nmGxQLMwfQdRkZ8NFSvw1+eT5EsXRIoJJLlf9x2
         3h71tBcP5pJ0LK0h9NfzgoCjLmjPzQjm8+1rs7yS7fI6oe4XaD7+gTNckABAulw6e4hb
         gwx008W6hLg1K+bc6HrDscgWKj4z1+ZZDfxpkHXZ7Pv82UFjS1CjG8IaCTGOYCMFHoHB
         7QG7VSUyAxj6V28lY/RrJBbWHKBa4n3tG3mP3WtLF/riglxWP/WbynCATUWWllmErL5+
         WX70E+bnhPKoGUionuE4Dd6HaPv/lSPwzlMg/t/OsxdV9vHDZh753bHJBBOXY1IoawY3
         kY0Q==
X-Forwarded-Encrypted: i=1; AJvYcCU9p9nA2mG+nlmcPxduLE4Rbw69FDO8sRxzluL5xdBa8pEj72Vgz2gTVSkUTbltVjhwtVHw871whWkirGA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxL7c10kJF9pcJnWqLuSBxHjESn/J/z8pZ5C7tXec+U9qaNx56I
	rEbqNUuq0ZRSnM38AWRpQTtuGs499okJO1LM1DLd0sZwUJcwSgCpmhjS8uus5vO8t5lkr4/SQqd
	8J6AeSdIqMX2tKH3VbpCufnxbv8m5U63WwaucZZL6Cw==
X-Gm-Gg: AeBDiesxNdvj4zRVB5GdFhYfiy3qi35gG4MySnYvf+3eMCRmNGXbxfBWtvpw4FCJrEb
	P/RP35ScAncLdlRkeAyy+FJsvMLX4pUSWda4qvq+koHCS8n2WeLpNns8dUFSxGH6m1OL4/d+vTw
	EdWcWjdKR/LkWI4F+joWXsEvWfLJ91TEISxRoROKIwAY/et0V33XAGcFZQwHJHTTio6tdH7F4NV
	VHQ8qeF+ikdqN2W/IQ0z+ZIa5jgSbfcH8cRFgG4cpuGY/uCMYKAbbefwY+BcmsFpS1WSkSFJbRI
	mgQs+5nI
X-Received: by 2002:a05:6820:858e:10b0:67c:3021:908a with SMTP id
 006d021491bc7-6821fa67067mr4123248eaf.3.1775580543405; Tue, 07 Apr 2026
 09:49:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260403194109.2255933-1-csander@purestorage.com>
 <20260403194109.2255933-3-csander@purestorage.com> <adNUE67FpIGF_x7Q@infradead.org>
In-Reply-To: <adNUE67FpIGF_x7Q@infradead.org>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 7 Apr 2026 09:48:52 -0700
X-Gm-Features: AQROBzCt_NO9LdYduvYfMd8GPp7cOALx7rkbussdP1UbmbwnR15kmHFzXdPpfAE
Message-ID: <CADUfDZqHyTDO6aYed+mtChU9m3iPgW=hghwfifuCV8Z_CzxoFQ@mail.gmail.com>
Subject: Re: [PATCH 2/6] block: use integrity interval instead of sector as seed
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagi@grimberg.me>, 
	Chaitanya Kulkarni <kch@nvidia.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 5, 2026 at 11:35=E2=80=AFPM Christoph Hellwig <hch@infradead.or=
g> wrote:
>
> On Fri, Apr 03, 2026 at 01:41:05PM -0600, Caleb Sander Mateos wrote:
> >  void bio_integrity_setup_default(struct bio *bio)
> >  {
> >       struct blk_integrity *bi =3D blk_get_integrity(bio->bi_bdev->bd_d=
isk);
> >       struct bio_integrity_payload *bip =3D bio_integrity(bio);
> >
> > -     bip_set_seed(bip, bio->bi_iter.bi_sector);
> > +     bip_set_seed(bip, bio_integrity_intervals(bi, bio->bi_iter.bi_sec=
tor));
>
> Should we simply switch bip_set_seed to take a bio bvec_iter argument and
> lift all this logic into it?  That feels a lot less fragile.

Perhaps I'm misunderstanding the suggestion, but how would that work
for initializing the seed from struct uio_meta in
bio_integrity_map_iter()?

bip_set_seed(bio_integrity(bio), meta->seed);

Thanks,
Caleb
