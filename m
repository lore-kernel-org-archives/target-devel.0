Received: from arkamax.eu (128-116-240-228.dyn.eolo.it [128.116.240.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55939284690
	for <target-devel@vger.kernel.org>; Thu, 27 Aug 2026 07:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=128.116.240.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787816263; cv=none; b=prAD46am59SlKtl4m9OmhO9L4OU03kMI7oTFvb7y8AmjdxE0MBQ1J6U8/1h8LXfdenOSa86y2x6SP+Qx9XxwMyygQYaNXTF2xW/gvAbg045fGKDx6lgqmNprMs4rKLgC7aNFjFvB+rohwYBNTqaLpIFalJenrdRp/ox1oRhAK6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787816263; c=relaxed/simple;
	bh=LQILYjJQw4J+Jvk3IEaCcgHaiJ2xwXeH6sOTQ3GrCRo=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=qHnHGFkhLXWhArgXHQAHyelpP8yTA0LheIUN3ejaBM+/8bYTiERlAcGA4oCChwijkNe4UTY6pTNGnypFufNOMR+HkcfK7bAg8aEXBEuaFooeT8M/QmL7erTAjtYhE77/YyBwKPzqn/cnftUuT+27aUNbnVLDbxKE+ipkmAXWr9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=arkamax.eu; spf=pass smtp.mailfrom=arkamax.eu; dkim=pass (2048-bit key) header.d=arkamax.eu header.i=@arkamax.eu header.b=M0UQ1iol; arc=none smtp.client-ip=128.116.240.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=arkamax.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arkamax.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arkamax.eu header.i=@arkamax.eu header.b="M0UQ1iol"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; s=mail1; bh=LQILYjJQw4J+Jv
	k3IEaCcgHaiJ2xwXeH6sOTQ3GrCRo=; h=in-reply-to:references:to:from:
	subject:cc:date; d=arkamax.eu; b=M0UQ1iolGL5OYqon8Ng+wXaD4tz8kG7qdu9a0
	NAfNbZ6VR7hcygblrCXGmLZ1618k5YdG6q77ORVW28cZG1p5q6/v2nZYvxIeCe9qCA6bXF
	46WiicV7/uXfCNIGIH9VIMuhXS/5HeEa63546iBFWYAeS8uZa7ke3JLVQoTrL+ZeGBthdl
	Q3aAaXMIOgIipUVR8Xe5t2lEyetNkdI6wYIAqAYZCdSoBmRRIXLirC7mKSwAYSInwP1R3s
	AUPH4UyMii3KeBXp8mlKamwvHcXSw9Fp296R+owltXOEzxaKhlg16rZi5P//2nr/RPBd5r
	oWTLGvEf77S+ofF9YLMyjiXzQ==
Received: from localhost (<unknown> [193.207.148.212])
	by arkamax.eu (OpenSMTPD) with ESMTPSA id 29fc37df (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Thu, 27 Aug 2026 09:30:57 +0200 (CEST)
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 27 Aug 2026 09:30:55 +0200
Message-Id: <DKZJTTSJ1AM1.1WHUHFDN2HF0K@arkamax.eu>
Cc: <mlombard@arkamax.eu>, <michael.christie@oracle.com>,
 <target-devel@vger.kernel.org>, <loberman@redhat.com>
Subject: Re: [PATCH 0/1] Write commands abort hang
From: "Maurizio Lombardi" <mlombard@arkamax.eu>
To: "Maurizio Lombardi" <mlombard@redhat.com>, <martin.petersen@oracle.com>
X-Mailer: aerc 0.22.0
References: <20260717143828.76291-1-mlombard@redhat.com>
In-Reply-To: <20260717143828.76291-1-mlombard@redhat.com>

On Fri Jul 17, 2026 at 4:38 PM CEST, Maurizio Lombardi wrote:
> One of our customers reported that sometimes the LIO driver hangs when
> performing a LUN reset while I/O is underway.
>
> I was able to reproduce the hang by using the following libiscsi patch:
>
> https://arkamax.eu/misc/dataout_abort_libiscsi.patch
>
> INFO: task kworker/5:0:514619 blocked for more than 46 seconds.
> __wait_for_common+0x94/0x1b0
> target_put_cmd_and_wait+0x6d/0xb0 [target_core_mod]
> core_tmr_drain_state_list+0x2a3/0x330 [target_core_mod]
> core_tmr_lun_reset+0x93/0x1a0 [target_core_mod]
> target_tmr_work+0xce/0x100 [target_core_mod]
> process_one_work+0x188/0x3b0
> worker_thread+0x2ef/0x410
>
> Maurizio Lombardi (1):
>   scsi: target: iscsi: Fix hang for aborted WRITE_PENDING commands
>
>  drivers/target/iscsi/iscsi_target.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Gentle ping on this one.
It fixes a hang that is impacting production workloads.

Thanks,
Maurizio
