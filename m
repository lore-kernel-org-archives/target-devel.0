Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F07BB39A07C
	for <target-devel@vger.kernel.org>; Mon, 18 May 2026 05:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779082120; cv=none; b=CsRbf2XcEpbIqxImBGCWKcPmbq0aR6698G17BcABnbx0d3FBcZbswcDcZO39J5Y38VqjJ+LmenTxjeagXtmHj1sfc45V+WPfy9EFo9GOUMrGHg6+QNzQIJk5k36K+bPSopw9IN8mkXioclAqNCu++yR7FDZsHCgc2JloJk0jEkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779082120; c=relaxed/simple;
	bh=2M029l9Mh4QQ5yBaW8CGo86oS5xrz7Jg3taBpYveDpM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FKJXetRzYv5v++DjrKglBe+r5kCnwT7m1ElTxTnhrJiaaa9uNG69PFfnWPPRLM4N4/YsFtadx8fnz4e7s6QT6B5IH62SdX02gteXWkFs6I5UHe+n18sXstTgnWpGoNVwy/CJF7eaZ+aIroj0OHtQp4SIQtQpLL2tEUn2tD3eymw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0dU1Rtbp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0dU1Rtbp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD612C2BCB7;
	Mon, 18 May 2026 05:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1779082119;
	bh=2M029l9Mh4QQ5yBaW8CGo86oS5xrz7Jg3taBpYveDpM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=0dU1RtbpbxXft4hkhCEcUtJK0P3RHixg4ItOGyg21AFXQUTrW51ffPx5L7BWw1EVU
	 JdRbAvBvEqtZ7baRH5c5juvfx8qrURNgxfoQlop3nf0PXdN8657p2zQxbGNp7BxidN
	 8jsNo6o1zIhSCdVCH5LQLu4uw4lk50OOCE+YaxLE=
Date: Mon, 18 May 2026 07:28:42 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Alexandru Hossu <hossu.alexandru@gmail.com>
Cc: security@kernel.org, bvanassche@acm.org, target-devel@vger.kernel.org
Subject: Re: heap buffer overflow in iSCSI CHAP base64 response parsing
 (iscsi_target_auth.c)
Message-ID: <2026051813-path-unsealed-6872@gregkh>
References: <6a0a00f2.e1ea9722.1dc845.b85e@mx.google.com>
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a0a00f2.e1ea9722.1dc845.b85e@mx.google.com>

On Sun, May 17, 2026 at 10:54:58AM -0700, Alexandru Hossu wrote:
> Hi,
> 
> Was going through the iSCSI target code looking at what an
> unauthenticated initiator can reach before auth completes. The 2022
> commit that added base64 support to CHAP (1e5733883421, "scsi: target:
> iscsi: Support base64 in CHAP") stood out -- it extends the login path
> with a new decoding branch, so I read through chap_server_compute_hash()
> to see how the new case was handled compared to the existing HEX branch.

As this is public, no need to get security@k.o involved.

Please just send a patch to fix this.

thanks,

greg k-h
