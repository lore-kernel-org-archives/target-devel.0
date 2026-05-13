Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5391534B1AD
	for <target-devel@vger.kernel.org>; Wed, 13 May 2026 02:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778640712; cv=pass; b=PjL+fOa8UmWyAKLjJIXeLb3LS1hR6dyKC/mCTAq1Cwz7/MjXg6FxYc3IOqAB4QK+c8qBxW0DhOrpGDIwBaE+HlqP7I+iW+QDuRBVHIcx/tyABxjBfdUlBCx+9j46pXB4YJ1vSrV1WgjbXwi8+kXP3d9JcWgjTsSJIvra9yjT4H4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778640712; c=relaxed/simple;
	bh=raam9DVb6nwGgVMeORu4BM/vz6+kYfQFafLG0g3ziek=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c6wAoI0XE/90m0Z+xmj22i+lX/JXkbLL+M162fW7ayS05aMzD6selux3Qn6mdLR1DcsrEaj62nTFNxNEiC/E2eypTJpBBRmZIYaJfNBi2Jj+xxofgYt62dnDndRtD24qN4ui0Ggwqs7NCbdUDoRr67NHWovQGnnJGswshm0cb1w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=fdJ3Un6D; arc=pass smtp.client-ip=209.85.210.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="fdJ3Un6D"
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-7dbcb45153cso698300a34.3
        for <target-devel@vger.kernel.org>; Tue, 12 May 2026 19:51:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778640710; cv=none;
        d=google.com; s=arc-20240605;
        b=Qwy3aMF7okVWENXyKFEEhEQc9dMGf//NyZMngF+HkZCDP7quZ5Vvk73wJM2dF03jG3
         X1/uvqXVrvFyDsfRRw1395OWVeouUCF45p1GselXNOyZTc6DYAkq2eIxRsbIjPEqCQhV
         uUd7Ph3VPnP32gwYDtV06JgKgWurOC2djtkk+cMN8wrDaL7If/4Oqf/zKZsfGdoWCtqN
         bxRU4Lp3bDaxD8xykRn6aXNTXSbDOZgYCoXuDH9YAR3CJgKNSdH6gjoPkSabh13seee9
         uyIvkEckihSKcpAolDqVqHZxKmPCYEt0sTS+ZuDz8NQ7VqC77UBC0aAbqk+nVcqNRDuX
         aThA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=raam9DVb6nwGgVMeORu4BM/vz6+kYfQFafLG0g3ziek=;
        fh=guRPPeGOlm5oKFbFyTBYs5Q+fczS4nWhJxbH3s0vGK8=;
        b=OzLjj7ogDtk/n7V1WRZIJjyFh9rH055giI9f0MLCj3m+KanKLjA9Uv7Z7hyJS7U+og
         QRBPxSY/WDeGhIUG8aSnyUQdyS2WCfEHnx6tMAwandGJsTGXWnObr29jr+u3U+yYTRnr
         Czh1GHhBsb615FLRiZVwdgTHZ10t/qajzHUdkq+6z4ib+/8VFtyQ+hFTBITu3AZcTahq
         sQGcihzvjScC2BtmiSeuZos63QPN6AGTEE4/zwPDpJmsDJN3WltlfjkyHVyp0MRNkShU
         QCCArCIXOBb2Ts0cGrWZ/Yyq1wAyr98Q9AGye44Tniz1Z3O+cPB64VaN79i/x/yWMKEx
         syzA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1778640710; x=1779245510; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=raam9DVb6nwGgVMeORu4BM/vz6+kYfQFafLG0g3ziek=;
        b=fdJ3Un6DAoxZo2/gGBlIAAeQDRz3DYXwiaMfealv5cotg4CdH7ts4CYCNrulYFTGiy
         5Y930QH7VOBLpXX9qnh3l9EpSWwgEsyCWTcNG6RL1TcmUgIyrDVYvju0UOKZoUjk+RSJ
         6amyW51TSk8TKLQs7c307lfDR3EsSTz5vyLGjerM6ip8BDQs+hFScvM8SUkk/y4hkLY9
         QLxYUy/8rYuaGRIjoMopOCnU5vnvsMQkUFnA9a1cTK6MmIdbAbQ4DR54sEkBkOQrnl/2
         mAZDQBOdEj8LltC7KRJBmf6cyOCSMPo02CS/XwATAtyO/FjwbqzuoHxrLFwfAEcCOPUf
         WudA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778640710; x=1779245510;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=raam9DVb6nwGgVMeORu4BM/vz6+kYfQFafLG0g3ziek=;
        b=b7rsBiXmQtIKPw077hNUPz3y3D6zxrTU6RQELxVLL1sNB0dPxE2elmgz1COXeEBBTL
         9RSpGaIEdHwlQLa/umNtStU7BPvVXADtTy50B1ma3NfrUIAhvcGBuAu0ikz2jrf38nz0
         Gv/3t0Xwcb6A9UtMMFVObrquieOhz2LjNUp5KRGkY1CRrREqVzEbD9FvVJqGVHEIojf1
         lSv9kF/WrxbA7NgjrPh1d9CbMFWtVaw3yqZPfuur6z+S8cHi2NWu4IdgIYinR+AEswpI
         wLETT7wLvbXsLB3Nl2vsS1tZlXys8YAPT2k/rfwFhHibSPffRZbuOFMD0Ld5nPhoL72n
         sGVw==
X-Forwarded-Encrypted: i=1; AFNElJ80cfcdefaWNf6S16MGMmcpvOP4XUNPg3OxfTXZPm2r4idPtcQwxvoTCw/1GGrqOrx8/KjTe+alZ6ioRHU=@vger.kernel.org
X-Gm-Message-State: AOJu0YynaNesxk67+tEA3ifZt55MG98KcF6V6H9e5hkOLhRWUfbDq1Cr
	DVqit0I+MNG5hy/6KfLglISh52DRgTMgvUTPyPEULioXNm1MMDrsJnm9p5heLphIU9EXLYcRk3K
	pL0q93PCvolkyNyV313EbAOBNtBc5hwX4sh5glbY3lg==
X-Gm-Gg: Acq92OFDjBI/LfWI+OdrYSd9hlobJkgL+5TMvroSYbnK5yFM+ZFqfBFL9jN8oqZ5Pf2
	Ov89+WLSXJyDhR5pUQyRq5uD2Wr6X5/xhq/X8CtDON1mAFBzO6mkV8AK/sV/pHG8tG1OXUoXpmP
	g698WQW6zANEWAo8Gcys/2VuHb2ds2NMVmDeLZS0iTMEnEHkNbjRYFSA3u29J81eQEqoRRVQqhu
	qKB7tez/IidWe6BSKmKhb5nlX9H+ersiHrQIwGdep3o9CekyXZ/LxaIdX+aTT5xGXFqtSqG9juo
	570XgpQFt+5uzu9Qqgw=
X-Received: by 2002:a05:6808:640f:b0:479:ffcf:52e4 with SMTP id
 5614622812f47-482b2d823a2mr634406b6e.8.1778640710257; Tue, 12 May 2026
 19:51:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260417015732.2692434-1-csander@purestorage.com>
 <yq18qams3re.fsf@ca-mkp.ca.oracle.com> <CADUfDZrwzUTi2TOj6M-+FtBK6u5evMsWSBqRDwJsLb8yLbOGvw@mail.gmail.com>
 <yq15x5lqfdx.fsf@ca-mkp.ca.oracle.com> <CADUfDZqkT4g3T6uE=hxt9J6JDMXbJt49rM7_Vgs3EBPdFeuuLw@mail.gmail.com>
 <CADUfDZq+BZ4Xn19TXH53NndDwDwMKm3xS8wSMnMtRsF7dWSyGg@mail.gmail.com> <yq11pfgxf9s.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq11pfgxf9s.fsf@ca-mkp.ca.oracle.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 12 May 2026 19:51:39 -0700
X-Gm-Features: AVHnY4I5-V51JtkIh-Ssp6M4Sux20aXJQq6-7lAFZgFvHPFmHKstgGsa0VGqDxM
Message-ID: <CADUfDZoYNjMCnBwoHmH0pbdiacmQ+aJd=p0KYxad2UB-UJ9-MQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/6] block: fix integrity offset/length conversions
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	Chaitanya Kulkarni <kch@nvidia.com>, Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 12, 2026 at 7:16=E2=80=AFPM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
>
> Hi Caleb!
>
> Sorry about the delay. Been away for a few weeks...
>
> >> So seems like patch 1 ("block: use integrity interval instead of
> >> sector as seed") doesn't need a Fixes tag. Still, I'm confused why
> >> the auto-integrity code bothers setting the seed to the sector number
> >> in the first place if it's going to be remapped later. Why not just
> >> leave the seed zeroed?
>
> It adds a bit of extra protection in the sense that it there is one more
> parameter that can be validated. The premise of the integrity
> infrastructure is that things in the two supplied buffers (data + PI) as
> well as the control path (bip in the block layer case plus the SCSI or
> NVMe command fields) all need to agree for the I/O to go through.
>
> It is valid to generate the PI starting with 0. But that is
> indistinguishable from "the seed value was not initialized".
>
> > I would appreciate a response here. Would you be okay with patch 1 if
> > the Fixes tags were dropped?
>
> I am afraid I still don't completely understand why things are broken.

Nothing is broken, I just mean that the seed value stored in
bip_iter.bi_sector is strange in that it's initialized in units of
512-byte sectors but incremented in units of integrity intervals. As
you point out, the remapping step makes the initial seed value
irrelevant, but I was certainly confused by it when I printed it
during some debugging. I can update the commit message to clarify the
rationale for the change.

>
> For writes, the meaning of the bip seed is: "This is the value you
> should expect in the ref tag for the first integrity interval in the PI
> buffer I prepared". With block layer autoprotect, the seed is set before
> generating the PI and thus implicitly affects the generation.
>
> When the write operation subsequently reaches the bottom of the stack,
> we will check that the first ref tag in the PI buffer matches the
> supplied seed value. And then proceed to remap the ref tags for each
> protection interval to the target LBA + n since that is what the storage
> requires (ignoring the odd Type 2 interval mismatch for now).
>
> For reads, the meaning of the bip seed is: "This is what I expect to
> receive in the ref tag for the first integrity interval in the PI
> buffer". At the bottom of the stack we will receive PI from the storage
> and that will contain ref tags matching the lower 32 bits of the LBA
> since that is what the hardware returns. And we will then remap all
> those ref tags starting with whichever bip seed value was requested by
> the caller. It doesn't matter whether the requested seed value was 0,
> 10, or 42. The ref tags are remapped to whatever the caller wants them
> to be.
>
> I tend to think of the seed as a register you program with the value you
> want. And then hardware or software remaps between what the storage
> device's protection envelope requires and what the application (or in
> this case the block layer) requested. With SCSI + DIX 1.1, the seed
> literally controls a remapping register in the HBA ASIC. In NVMe we have
> ILBRT/EILBRT.

What I find confusing is that the seed value stored in
bip_iter.bi_sector isn't what's actually passed to the SCSI/NVMe
device. It's only used in blk_integrity_iterate() and
__blk_reftag_remap() to generate/verify/remap the reftags in the
integrity/PI buffer. However, (E)ILBRT field (taking NVMe as an
example) comes from the physical block device offset rather than the
reftag seed. See t10_pi_ref_tag(), which returns blk_rq_pos()
converted to integrity intervals. It looks like this works because the
remap step ensures the reftags passed in the integrity buffer match
the physical integrity interval numbers, but this means the device is
comparing physical integrity interval numbers rather than reftag
seeds. My point is that if the remap step undoes the effect of the
seed by setting all the reftags in the integrity buffer to their
physical integrity interval, I don't see why the block integrity code
bothers setting a seed in the first place.

But it sounds like this may be a longer discussion, so I will split
out the two fixes for 7.1 into a separate series.

Thanks,
Caleb
