Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32641FBEBC
	for <target-devel@vger.kernel.org>; Thu, 23 Apr 2026 18:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776967384; cv=pass; b=ip9DGU74/ssjntYZLu3Dkp3tyZz0mrLDmROSMASEq87ljhw3N2+1WrX7rHuZeGD4aBT9pRjEmraGb6Qy+D/SU1nFUj4NCR7aVEMNUCrLTCse+dZ3uV05xymQ461yvIobcyCMbYTyvBjqaMOZqrTjNpVSx4UKR46gFM8PswgxbbU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776967384; c=relaxed/simple;
	bh=c1lJLEbyeroH+TWcwZkpKsknFGLHTffQF4tuZQJcp3k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UbPkJ/uvh7LtPv3439Zzzo5bHxk21dTpsxv3uI9wuW7EAtYoAlxOTQXNQdJyYjCUsQ176kJaiTxC123YQZp332xO1N1ZclX0uEs3vvpB/fBv7J18iMhnA2n03/Xu0cRoYU6pE8ol3KM4cpwTAexLE5IicxIuaTC3trX81rEYbMk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=JTZewQD9; arc=pass smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="JTZewQD9"
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-69490c91241so217595eaf.3
        for <target-devel@vger.kernel.org>; Thu, 23 Apr 2026 11:03:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776967382; cv=none;
        d=google.com; s=arc-20240605;
        b=bXeBP3aqijqcF23d5dHlNfhhanjX/7ry14WuWY2CP+p2k85jK9g4Z/TtuhjEqa1cHp
         1QAp9bj08oi3AcrsasQNV/z3YonsOtZhiVm3W4rDrdREd1108y++nxrJkmodyQleO/qK
         cW4IOTgH2dG1jeWq5yXRz/11aN4Vz4yGG22YP6wZZX3aiXNBpRzeMAcYhZhJzVmZ7Aay
         +jGZ4Z439I9LTBXs00+S87iIklhxd0Wc18y23xUsdNI1qqML/HGG/NyytdmETosqbiFh
         weXXk03cp1uAmfTpwbFtwwrH80KB5l0wF/RiHvsrXmImGZ8yOxhxnpuKOEjisNO0wa7e
         W8xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=c1lJLEbyeroH+TWcwZkpKsknFGLHTffQF4tuZQJcp3k=;
        fh=9Zn0WYKV/lUfl/omnDMxuNc4dY07qq5XmTBy+PNv9Jw=;
        b=Rx83DTNtElzGyQGblG5h8A6X1QC7lIQnP/aNfujvpucTSEoyitIqUUKliwbtNQKOH/
         KcD30S8Mq87Ky9ZUcvUOJemyQ2/qmdcD57llSZSWeZWoK+afYYi7L6punVpa2iyZQvMY
         cYreFf34P1eZ9ubL3rmjcT+ME5k7PwDsA4fr3GENUEOW/Swm1QXAvm9H5mHar73gsfV0
         Aly7iA6fI/zp2mXBnbGsEU4yrCbY8nMqrO+d9yNmV1RwjsCmWehWiGn3FVKUIj9jYoFh
         h5HRFKPIDe2QeRZ/Wk+taPE9DDVjjcfcq3GqZvDXmZp2BoZxLpTIVZDIOsbE4C9ajcPI
         Bjxw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1776967382; x=1777572182; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c1lJLEbyeroH+TWcwZkpKsknFGLHTffQF4tuZQJcp3k=;
        b=JTZewQD9/6xM8PdmL6uWGsX8VdkkMJtXP9CAzZ5OOq3AADr+LCqlg4FQqUAopEtAUu
         859/jg0EGgIEEcoD5noLktrwjRVY1bKcJrHLy0orYguhQY3GjUbOy2MKn9pETT3B2Ldq
         4OzEeyMyNxLLI0z9XkvL/fZzT2NrCV5Pp2XFHksiryGnG1qe+lwQG3NLo1EDriL1SWOc
         GRQBK/PUZ1NdNANrUrOHCOFv/RZa/E+Vq/jVCqD1F8+cthpTmg7SpZQyDw28o9HNs67D
         ryNpEMzRbsVAnrmIRjoIISjiAtKMuF7L6sYooyGd1LqYpqpuybyjfc3xHbr5jNWZQUy8
         p1lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776967382; x=1777572182;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=c1lJLEbyeroH+TWcwZkpKsknFGLHTffQF4tuZQJcp3k=;
        b=Y1tb4oehrFXN/63Q2QahfiKBzg9xQwunOiI/akHyuWCwuSl7XcPENZdOXo4sWqegyK
         8x8RuA3jjA3OYpcI93t0UaQeb2oq0yAiDy+8wrhlG2HCnjkocG3orowyXfSH3noWDW60
         wZOo0JIAulCBegwY3J9MxJJQP4gYIvcKei2ATg7lyJ9ah33kkBulgVjrDiHZtAMaXyyv
         ua4DLA1LYPNDcRc9K3HkDB/sakc8s0vsxUnCrDVftZs9qlMhp91OCFWkdnt6gdD4UlUS
         n3YUMXZqhP8Tk37a3s3biITBBx32VtBDCopd9EGhh8dZ0em17hSe5tDkhtFvXBRkBnrH
         LESw==
X-Forwarded-Encrypted: i=1; AFNElJ8lYi4/16SsFCCaITQ2snM3Q2JiJlnOBQBW0fMfSpJXXfaNXDHSFN6X9Lk1LFfsgzCZf0DZfRDXbUqsirU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQOVNPuWy5Jxf0oRBGBIZ8IPDpSOVedbaHcIDYnDEbwqRaolv0
	vWetGbmjlxIY2B/IeISa21088MAufDSCN2f9sj7pYyICX+G1iGKme9Je82n5cykkynOL2ebEI2Y
	PBpmrYCumUq9j/OYq0c7kcfP/+XPWzVEpxa1tfSpdbw==
X-Gm-Gg: AeBDiesdg1BMuH2OdOj5ii8sGLurw4Bh0UFPY2HBTOc7hrf4GMbzSwCGE6QXnBC3wl9
	QZZxxxDrcy+yBpwBWJ6Ak4gTJHFiqxsDz7QnVrVqG9wqSGYEwE7DnChZwMddeLHAFpPSSHyPYf+
	lybKq/4go5QkMGP5YUraNNWeVe+q9Ogo2mnC2kwLEIrVu+KgzehR/dWblKnFbyM5zzQawrleh8t
	iwB+zpUwBmJ6mMro181BbXsNy2as5no/X/c8fM6mMA3yCikgLVyqevIt+VmbJyjGUmdO64RSKoA
	RjxNsVSVNxMyhHFmZuI=
X-Received: by 2002:a05:6870:16f5:b0:42c:1e12:6bac with SMTP id
 586e51a60fabf-42c1e13c7b0mr5869827fac.5.1776967381259; Thu, 23 Apr 2026
 11:03:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260417015732.2692434-1-csander@purestorage.com>
 <yq18qams3re.fsf@ca-mkp.ca.oracle.com> <CADUfDZrwzUTi2TOj6M-+FtBK6u5evMsWSBqRDwJsLb8yLbOGvw@mail.gmail.com>
 <yq15x5lqfdx.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq15x5lqfdx.fsf@ca-mkp.ca.oracle.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 23 Apr 2026 11:02:50 -0700
X-Gm-Features: AQROBzCpAwBKjPdeKRy_iDk99MgWov4WGujklh5E85jOlbENhysKrBryAPvMMQQ
Message-ID: <CADUfDZqkT4g3T6uE=hxt9J6JDMXbJt49rM7_Vgs3EBPdFeuuLw@mail.gmail.com>
Subject: Re: [PATCH v3 0/6] block: fix integrity offset/length conversions
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	Chaitanya Kulkarni <kch@nvidia.com>, Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 20, 2026 at 7:09=E2=80=AFPM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
>
> Hi Caleb!
>
> > NVM Command Set specification 1.1 section 5.3.3 requires the reference
> > tag to increment by 1 per logical block, so that seems to determine
> > the increment unit:
>
> SCSI allows PI to be interleaved at intervals smaller than the logical
> block size. This was done for PI compatibility in mixed environments
> with both 512[en] and 4Kn disks. Interleaving allows 8 bytes of PI per
> 512 bytes of data on devices using 4 KB logical blocks. That is the
> reason why we use the term "integrity interval" instead of assuming
> logical block size.

Thanks for the explanation, I'm not too familiar with SCSI. I meant to
refer to integrity intervals in my explanation if they differ from the
logical block size.

>
> > The ref tag used for a particular block needs to be consistent. And
> > since reftag(block N) can be computed as the reftag(M) + N - M if
> > block N is accessed as part of an I/O that begins at block M, the
> > function must be of the form reftag(block N) =3D N + c for some constan=
t
> > c. Thus, the ref tag seed needs to be computed in units of logical
> > blocks (integrity intervals); no other unit (e.g. 512-byte sectors)
> > works.
>
> Whoever attaches the PI decides on the seed value. In the case of the
> block layer it made sense to use block layer sector number since that
> value is inevitably going to be the same for a future read.

I'm not following "going to be the same for a future read". The block
can be read back by an I/O with a different starting
offset/sector/seed, as my example illustrates. When the integrity
interval size differs from the sector size (512 bytes), mixing the two
units results in a different ref tag seed for the block depending on
the starting offset of the I/O.

>
> Note that with MD, DM, and partitioning in the mix, the sector number
> seen by whoever submits the I/O is going to be different from the LBAs
> on the target devices which eventually receive the I/O. Nobody says
> there is a computable constant offset. Think scattered LVM extent
> allocations. Or RAID stripes placed at mismatched LBA offsets.

The constant offset relationship still needs to hold over any
contiguous range of a backing block device that can be accessed by a
single I/O. For example, with partitions, it's not possible for a
single I/O to cross a partition boundary, so each partition can have a
different constant offset between the ref tags and absolute integrity
interval numbers. With RAID, each shard can have a different constant
offset. etc.

>
> > To see the issue with the current approach, consider an example
> > accessing LBA 1 on a device with a 4 KB block size. If the block is
> > written as part of a write that begins at LBA 0, its ref tag in the
> > generated PI will be 1 (sector 0 + 1 integrity interval). If it's
> > later read by a read starting at LBA 1, its expected ref tag will be 8
> > (sector 8 + 0 integrity intervals), and the auto-integrity code will
> > fail the read due to a reftag mismatch.
>
> Something is broken, then. Because the ref tag in the received PI should
> have been remapped to start at 8 in that case.

Ah, I missed the remapping piece. Thanks for pointing that out. I
guess I was testing with a ublk device that doesn't advertise
BLK_INTEGRITY_REF_TAG. Since commit 203247c5cb97 ("blk-integrity:
support arbitrary buffer alignment"), the ref tag is unconditionally
set in the PI from the (sector) seed, but the remapping is conditional
on BLK_INTEGRITY_REF_TAG. That explains why I was seeing ref tags in
the PI that didn't match the integrity interval numbers.

So seems like patch 1 ("block: use integrity interval instead of
sector as seed") doesn't need a Fixes tag. Still, I'm confused why the
auto-integrity code bothers setting the seed to the sector number in
the first place if it's going to be remapped later. Why not just leave
the seed zeroed?

Best,
Caleb

>
> > I agree, the seed doesn't need to match the final LBA, but it does
> > need to be in *units* of logical blocks, plus some constant offset.
>
> Your concept of "unit" still sends the wrong message. The seed is an
> integer value used to initialize a counter or hardware register. The
> seed only has meaning to whichever entity submits the I/O. To everything
> else it is a value used for remapping ref tags from the I/O submitter's
> point of view to whichever interpretation is mandated by the storage
> hardware's PI format.
>
> > With a ublk device. It should affect any block device that supports
> > integrity and has a logical block size > 512.
>
> It sounds like the seed value is set incorrectly for reads in your
> configuration.
>
> --
> Martin K. Petersen
