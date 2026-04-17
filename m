Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D572B3B4E80
	for <target-devel@vger.kernel.org>; Fri, 17 Apr 2026 15:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776438650; cv=pass; b=QGVvST1SoiUqx+43qnBESGfDOsznZjQ9GrR/JKOK6FbXThAHMjI0Fb+FXTR7Uwr9XyHxLvI/0eATnbdz9M19dFSkUjradrYpcZEzRVLtN4GZTYYgKUoItVsHymMHJUo27BoAjN71N/Lh6QcEc99BXgLQspt4Y38JWUtJW/Sh9gs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776438650; c=relaxed/simple;
	bh=xFLTiMMKAFunIyu7ceKg8SWDzKCETKZieFq4JIwHgN4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=urusbRKDEYZEC0Q94s4cpISyX9DaHvfyalJ7aT4wshBS5BwDX3y/BJJL3ESkK0RUz/tUAbg1bxh8SiGLy8visWT4l4+ur5FpgKztQlZrFdp3ufZJEoostbPkpRF/V+BYvLQ/oqgIGQAtJGUSGt60bR4a5ldNavB86FymuAuO3bs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=I5e94ITk; arc=pass smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="I5e94ITk"
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-41540f23deaso145636fac.2
        for <target-devel@vger.kernel.org>; Fri, 17 Apr 2026 08:10:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776438648; cv=none;
        d=google.com; s=arc-20240605;
        b=leKnzrnWmnD1y7WOaz25X2ZHMCPDifMNxZT7GfKWJyRx9zRCevqAc32417FmFS4Glp
         3WvEbI6n8gx//8ObeIH27D0ZWTM3kras9vbWT3Z+2nBU9fOtxnnB8RZescfbdLlNZ7eB
         VVxLCyMilfefFKFiWCWrWEkoQCdDIqgKCc3hXC+6xLUroYi8Rs4D+q+gw0yADCPGHWgf
         KC0KFw+73rYZbWOqNZgyVjB5w1pNkA2mGeYE7kjSwxJU2/WuAi74G3ahU1jctO/OZDK/
         JbKXBtFmuLzulL9aslXZ6SiXdo4Oe96C9kHHD5LJcpI4KhQVEE1fFJGT1OV+ZE3KOybI
         aZHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xFLTiMMKAFunIyu7ceKg8SWDzKCETKZieFq4JIwHgN4=;
        fh=34lG6aGOdLqFXlQvh98mvrXfUp2f1CnTNJNNF0+1tY8=;
        b=RnKEAg8OPaJwcBuFgM7uTkVlgEJzRSgLal1b9oho0ocft9i6BR1pkKmf+nDvFuxf0H
         2cnXb7mlkOBWTPnMnkwI0JxmJP4ICP0V0u/+VBLdM/hS2kBppUKErlwvxR+UIirSIS4V
         jrL/EnzPB1plC/5TmKVgrBj6+fYHIfS8Rk5Qw6O8Hrg/4wIdsF7B79a+v2C2nVCjW5rA
         MYIMjn3HOdCcduCb25qYWMJYo3lbP2YNfUMrpWxj2K0IpAcRdI9SwCkPSFS/El5RC53t
         jHT5ULXjuw7YJD61pY7BbgZVAEGqungLXkwVd8La68vI1WVWEhsXWW6kHH6IcgBh3qCQ
         XXWQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1776438648; x=1777043448; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xFLTiMMKAFunIyu7ceKg8SWDzKCETKZieFq4JIwHgN4=;
        b=I5e94ITkR+Rsbq/S115qpU2rTYR/eDDXeEmS5iqWvxOgurzgpA+yyiBQCLMkGRgswB
         pTbDLRPJZABeuIzYjUeXlp/3CY03MjF6Xr1qxD3TsqJI+dRwDE53mS/qVGSV9/fAB07r
         Ilq9aXE24kBk7q/iqp6WO0tys59b/4kMXV8b1MNoGVd0mZkoqGMXykJkK3JbK/4BQ2v4
         WXjmidAMNDJQ0s34JYVyR08iKNIQecaoGW+CWmJSLba4dv73wk7GvoZh5T1/zFmxmd/w
         sJpbpjQJwRcRpgSZsJzGCGzsw4iLBB6/ja6ybbuJVOH7UdYQjTQzRITL7sG7DPhN2RHG
         F0fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776438648; x=1777043448;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xFLTiMMKAFunIyu7ceKg8SWDzKCETKZieFq4JIwHgN4=;
        b=H8zy9rCtebtBxml6wI1vxn2c13fu2zn6VtZiN7KOSXDULyOeNblULQwK8GvidnELCL
         L9WT5t+2qsEWm/X+iEbo+PwN7UOZOMs0Sgjd7pvqCn6xvjU5rrtFI2PV5lwknnO+LaGE
         r3mJ5nmZMwTvSbSb+xEpYtc4MZaiqrgyga4nEbV2YE6L/DGJPs78rZHbfCWsGHa60jHA
         3WuJgj7I5pNjQ4vowJh+g5vOFdb1kkC79H/RzHsWeuxkEAsoATgiZultqH2Z7Et8Fmo3
         kEizO7kETk5psp2tlmjN2uPiUTXpIPWZVmnBn7AJjLb1L5dM0g1+09AnDENNw3NJYAUW
         IatA==
X-Forwarded-Encrypted: i=1; AFNElJ9aVFKzAwFgm37TQAGsX1JAgI9D3YijHWnjMWOJUtKmNCTTwFWZAZAeOvV0fyj3gHg7no8Q3VNqsK2Ekpw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxsOUyg7mUpByMBYU6OZ3ipNYkuAFNVs1iPJjaiMVp+Jly2CSWr
	xsLNZDeXilZHzSJTJslDGDrhepN64K7zbhdWwmHoWtH/SagbZYEMY9cz150EokKw+dViVt8qDYk
	vQcznO43B51EaqRsyyN9pRy0Qcpn6e0J05Q/G9SSi4FWPWLhX6/+8dYfskw==
X-Gm-Gg: AeBDiev7IVOx54+jnvc+JiGvudvIDtPF978MDha2vxLIN98bN2LjPrV0sjKuyxkEOTk
	fVdwP4DF37kkpKq3Dspukaqhw6OS+faJUmTyYZwt8uAN7QqhULac6kF3PIF6G7sUmv6oq1HK0I6
	n3ER4FE878o2m+8XMZ+Z5In/6nvsgzlnYcOfQXX4HpjVrpyy70Ot5r11QA6YdAPRIhmPc4NBcCU
	8vjlT6IoeBUJlYG7TVghFMO3emJd+03Vif5CmjrX4Qo+4/dqhuQNs0pMG/VWNg4n8SNJMjgziog
	hOSu5ks7vAcqdXMHB709A1s4j2gAaQ==
X-Received: by 2002:a05:6870:8888:b0:417:a04:483 with SMTP id
 586e51a60fabf-42abf22006cmr1173721fac.1.1776438647695; Fri, 17 Apr 2026
 08:10:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260417015732.2692434-1-csander@purestorage.com> <yq18qams3re.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq18qams3re.fsf@ca-mkp.ca.oracle.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Fri, 17 Apr 2026 08:10:35 -0700
X-Gm-Features: AQROBzAgZnPY6pX5OSwcczY9YUvRnJkbRQ4Ptv6iv7u-Y7bsDv654h6ccq-SxOo
Message-ID: <CADUfDZrwzUTi2TOj6M-+FtBK6u5evMsWSBqRDwJsLb8yLbOGvw@mail.gmail.com>
Subject: Re: [PATCH v3 0/6] block: fix integrity offset/length conversions
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	Chaitanya Kulkarni <kch@nvidia.com>, Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 16, 2026 at 8:26=E2=80=AFPM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
>
> Hi Caleb!
>
> > The block layer's integrity code currently sets the seed (initial
> > reference tag) in units of 512-byte sectors but increments it in units
> > of integrity intervals
>
> I don't necessarily agree with the premise that the seed needs to be
> expressed in any particular unit. The seed is a start value, nothing
> more.

NVM Command Set specification 1.1 section 5.3.3 requires the reference
tag to increment by 1 per logical block, so that seems to determine
the increment unit:

> If the Reference Tag Check bit of the PRCHK field is set to =E2=80=981=E2=
=80=99 and the namespace is
> formatted for Type 1 or Type 2 protection, then the controller compares t=
he Logical Block
> Reference Tag to the computed reference tag. The computed reference tag d=
epends on
> the Protection Type:
> =E2=96=AA If the namespace is formatted for Type 1 protection, the value =
of the computed
> reference tag for the first logical block of the command is the value con=
tained in
> the Initial Logical Block Reference Tag (ILBRT) or Expected Initial Logic=
al Block
> Reference Tag (EILBRT) field in the command, and the computed reference t=
ag is
> incremented for each subsequent logical block. The controller shall compl=
ete the
> command with a status of Invalid Protection Information if the ILBRT fiel=
d or the
> EILBRT field does not match the value of the least significant bits of th=
e SLBA field
> sized to the number of bits in the Logical Block Reference Tag (refer to =
section
> 5.3.1.4).
> Note: Unlike SCSI Protection Information Type 1 protection which implicit=
ly uses
> the least significant four bytes of the LBA, the controller always uses t=
he ILBRT or
> EILBRT field and requires the host to initialize the ILBRT or EILBRT fiel=
d to the
> least significant bits of the LBA sized to the number of bits in the Logi=
cal Block
> Reference Tag when Type 1 protection is used.
> =E2=96=AA If the namespace is formatted for Type 2 protection, the value =
of the computed
> reference tag for the first logical block of the command is the value con=
tained in
> the Initial Logical Block Reference Tag (ILBRT) or Expected Initial Logic=
al Block
> Reference Tag (EILBRT) field in the command, and the computed reference t=
ag is
> incremented for each subsequent logical block.

The ref tag used for a particular block needs to be consistent. And
since reftag(block N) can be computed as the reftag(M) + N - M if
block N is accessed as part of an I/O that begins at block M, the
function must be of the form reftag(block N) =3D N + c for some constant
c. Thus, the ref tag seed needs to be computed in units of logical
blocks (integrity intervals); no other unit (e.g. 512-byte sectors)
works.
To see the issue with the current approach, consider an example
accessing LBA 1 on a device with a 4 KB block size. If the block is
written as part of a write that begins at LBA 0, its ref tag in the
generated PI will be 1 (sector 0 + 1 integrity interval). If it's
later read by a read starting at LBA 1, its expected ref tag will be 8
(sector 8 + 0 integrity intervals), and the auto-integrity code will
fail the read due to a reftag mismatch. This seems completely
unworkable for a block storage device.

>
> We happen to set it to the block number in the block layer since we need
> to be able to know what to compare against on completion (for Type 1 +
> the restrictive Linux implementation of Type 2). But that does not imply
> that the seed needs to be specified in any particular unit. Submitters
> set the seed to whichever value makes sense to them (i.e. it could be
> the offset within a file as opposed to the eventual LBA on the backend

I agree, the seed doesn't need to match the final LBA, but it does
need to be in *units* of logical blocks, plus some constant offset.

> device). And then that seed is incremented by 1 for each integrity
> interval of data in the PI sent to/received from the device. The
> conversion between the submitter's view of what the first ref tag should
> be (i.e. seed) and what is required by the hardware (for instance lower
> 32 bits of device LBA) is the reason we perform remapping. The seed is
> intentionally different in the submitter's protection envelope compared
> to the device's protection envelope.
>
> Using the block layer block number as seed was just a convenience since
> that provided a predictable value for any I/O that had its PI
> autogenerated. I never intended for the actual LBA to be used as seed
> value on a 4Kn device. Initially we just used 0 as the seed. Leveraging
> the block number just added a bit of additional protection.
>
> I confess I haven't tested 4Kn in a while since things sort of converged
> on 512e. But I used to run nightly tests on a SCSI storage with 4Kn
> blocks just fine.
>
> > This looks to be a longstanding bug affecting block devices that
> > support integrity with block sizes > 512 bytes; I'm surprised it
> > wasn't noticed before.
>
> Are you seeing this with NVMe or SCSI?

With a ublk device. It should affect any block device that supports
integrity and has a logical block size > 512.

Best,
Caleb
