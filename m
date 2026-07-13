Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9FD2D2394
	for <target-devel@vger.kernel.org>; Mon, 13 Jul 2026 15:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783957854; cv=pass; b=gJTw2/2/YtrDnBRboC0yidU/QePe/mjHJg6+U0MlGIWVVHGE0ve2pDiyZ60JykB4WdXBGbFpQAf4iNSuhhUUubbW3zKc2ZWzsoxydbb0tUlz5QbNh6kDKhDv5yQFcRvA6NgOls6EUPQT4WTInFzsS0t6z7Y4j4C+lSOAPrZofds=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783957854; c=relaxed/simple;
	bh=3mECq0JgKQxu+65FqIfg6qBb9bwB9oI7Lmlwod5ymao=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OkmdvrowkS3xDsLF+LrLnAoJ4/eHWCN9ASxweSXj7Xohk8Tl7AVQABXXSCOKOmJ/lTXmQ/p4XtcIhqrQEA0fXkTRt0ACkcMI6g5IqokOhE/E3JhMuu9FzMDpcXom0oJchz4Xo+e9pIrDfkOYsEf4ghDukzOmqHoNv3EbAoZrbjg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=gsEOBe+w; arc=pass smtp.client-ip=209.85.210.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="gsEOBe+w"
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-7e9faea93a1so596384a34.1
        for <target-devel@vger.kernel.org>; Mon, 13 Jul 2026 08:50:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783957851; cv=none;
        d=google.com; s=arc-20260327;
        b=TNNAmz8ksr+gadzgHcKQ7fwsW6qfXdnOF4w2QpKxiehcESHazy4glpTa+AMEhFitW+
         8ecF0vEUi/UNZJ8kolCaLYh9pXATU8gdHaI7eHdrl3B8x8aLNUBM3RGQoga/AEaMIr6e
         hawerg4nLj6x06qcV/XR7kEN59uO9Iwjc5TfM0dz1EI3afQ0o+wr+pFuhyAncVRnUfBb
         fW5D+qa306A1CA3KmB41YV+wld9JoEJ34PX/Q6Zj7mBH0aeiU7bDDvVFtyQA2dL/1AQh
         vQFNxip3iu5cfJdEetEVCiK8awxzBTAJGrmppQYHUPzkJ8ZeBE9fQYgvEBX39udhiRIQ
         lrIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3mECq0JgKQxu+65FqIfg6qBb9bwB9oI7Lmlwod5ymao=;
        fh=EVCdNF1Cu514aVDfxanEfXGIKyzdlJy+z3B++3fa5N0=;
        b=LcpXhuSJKDhjlnu2s0IR6BtoQkIElSQcc3oTzxe+q2tvooTCEUErGKiEswqwuWU9FK
         u40EtieG6sH4j+u9WAwzt0IpPBDIE1q0leOvkS8+Sd3tE6e6sVChZ435V1naisXfEt1M
         tAI/nxpdimlFbrDsaRiS7Eehc3o5JhieLfPtxZ+D0xGZhdknK1xZaqhnOZccIwUAS0FG
         ZC8BBUfW+1Ra8DWDpv6UY88TX2n0ZYg+UYrO1ovyWgAxCmLMa2qaXajYmDHqKQYz57PB
         jQdk+y/zoQ6bwOJgoRySlzbpIAyZu5xIWGzmizUuDSUrBMjmteiE9swTckw5Qluq/5/J
         d1Fg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1783957851; x=1784562651; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3mECq0JgKQxu+65FqIfg6qBb9bwB9oI7Lmlwod5ymao=;
        b=gsEOBe+wIyNi+N+Y3DYT3ewaeUbTGU/25iTY6t5gwTvo50Ha/Pppkph49XdFrYJ9/j
         jIIJn03KaJkTEPGJVUu4eJyLpQLoMZ9GzNknaqAxnwAidNb97l7VJlDZYEicBkYY7wm/
         8qjIZ3oM8ZbdfHr/XzyAtJRg3yjryLMaaQdsRQ0OF0LjAExZ17hXX7vbTHJDPrAslyiS
         cFzlfTyAyYqNgRevkCO5Wwx8jW8oYZ0YHAwh7ucG7Es2qWa03W8PdM406LBbEnVRWy9v
         0Pf6nIDpPfFtHXrDnazsbvgsW+RqhkyJVppRz/fA3HW7qwnX4kquonwZFL9xynJ2x/R5
         Ne0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783957851; x=1784562651;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3mECq0JgKQxu+65FqIfg6qBb9bwB9oI7Lmlwod5ymao=;
        b=VHeYH+aL7Dk4W0Tnl7hssihKZ6zxJhRa5kf91zBWv3Y45mQB/wVrwzf9spiZYXdu6V
         hgSKZZa64AMhbcCpUO7+H8hnCN8zZUhWKJ2Cv453OcvKw1S4Lj81L61RgZiY82nnePb9
         f8uVNO+zs5ZpflPK6jar5mKtukROsc76UzlBBavP/5OO2ZzYHKteI7+G7fE+f+DQUVRA
         Za2iXlf/+wZy17fiRXdcR0APuPXyTwDOF1l95UwRDr4gKFo2JhpPBm6xOZnUKh6MQXY/
         8vHdujGliXGByaD5UB6OfdL/Dcl4KMcMv6AkIQhtb96ApRHQh6orpBeXEAU2QeC4AB6R
         /Ipg==
X-Forwarded-Encrypted: i=1; AFNElJ+0JClDfJNzgg+b7FhERP1MRh6RVaNi6S/709OqolSbip5FpdFfeSktSW1xG+FCAJvkldlT48DNeH6Xmro=@vger.kernel.org
X-Gm-Message-State: AOJu0YxbeJ/h6t3kCL9a7xPprruMeXbP5FmTJ+S1NCG+1LixuRbpaxtN
	wIdsD9JIq6juuJuzE45fCp3Nc2QgpOq6iIrKeq0fAgOX5mM5eCVglxGazJLhgoOFIxHDhF7jOBU
	V33xjCpXVZ4J/AI/Dhe7bepMXYv5HwLxnXdheSwEYyA==
X-Gm-Gg: AfdE7cn7a0lkJkNRCFmd6FAowdaJ8wbRNQ7BcfWcS3cP1KL7QkOyGij/4TkrAu2bEQo
	F72UrXPICNl8QvpFLdl0gkLNm+5T5ilo1opqZsjN/LnswBy9PNwfHzov91EtTeTGGhTNffdEuW9
	KMt5L9+aELUkocrwocvJeiMnq9HK/2I0X2hj8dJbeJj+rONggHsYn3wYgWIT5wPJLJnqTghMTif
	yovsVW7Q1oApw1CAudrs7tbrBmOASE39bBzfd6x/kj0IFkgWeE5zzCSydTMayvpwYFABrMSGg==
X-Received: by 2002:a05:6830:650f:b0:7e9:e702:a9d1 with SMTP id
 46e09a7af769-7ec097b58famr3955386a34.4.1783957851185; Mon, 13 Jul 2026
 08:50:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260627054220.2174166-1-csander@purestorage.com> <yq1cxwrdgmx.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1cxwrdgmx.fsf@ca-mkp.ca.oracle.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 13 Jul 2026 08:50:39 -0700
X-Gm-Features: AUfX_mwkxpGgZJY4pVFOcqA7Ferj1yZzrVgo2oA_tVNxLSUmFMmyocci83-Ncfw
Message-ID: <CADUfDZoGyu-EWxT5tN41K24oFwu8p4mmxFRsHcDpLBoAY6Y0Yw@mail.gmail.com>
Subject: Re: [PATCH v4 0/5] block: use integrity interval instead of sector as seed
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagi@grimberg.me>, 
	Chaitanya Kulkarni <kch@nvidia.com>, Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 12, 2026 at 4:09=E2=80=AFPM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
>
> Caleb,
>
> > The block integrity layer currently sets the integrity seed (initial
> > reference tag) in units of 512-byte sectors.
>
> ... because that is the fundamental addressing unit in the block layer.
>
> > However, Type 1 and Type 2 ref tags are actually in units of integrity
> > intervals.
>
> They are not in units of anything until they reach their final
> protection envelope.
>
> > On devices with integrity interval size > 512 bytes, ref tags are
> > seeded incorrectly.
>
> The bip seed is whatever the caller decides it should be. The integrity
> interval size is irrelevant. As is the destination LBA.
>
> > But REQ_OP_ZONE_APPEND operations don't have their ref tags remapped,
> > so the ref tags using units of sectors will be stored to the device.
>
> Then there's a problem with how we handle REQ_OP_ZONE_APPEND. For NVMe,
> the PIREMAP flag should address this issue by remapping the written ref
> tags based on their ultimate destination LBA.

Yes, it looks like PIREMAP should allow this to work. But Christoph
reported that ref tags weren't working correctly with
REQ_OP_ZONE_APPEND:
https://lore.kernel.org/linux-block/20260624080014.1998650-3-hch@lst.de/T/#=
u

Christoph, were you testing with an NVMe ZNS device?

Thanks,
Caleb
