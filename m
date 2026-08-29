Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7942DA756
	for <target-devel@vger.kernel.org>; Sat, 29 Aug 2026 02:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787969983; cv=none; b=JkugehKmIT95ESQBO/VlMC+tE73tE5NO4DIx/O6vDOELPeuSEsp9p1RDoe1C6FZg0GYqkyVIL6gtZHzT8T5BbpAXntH8f6CMIzIt7LyEcuf+QFA6iiml6ydL0XC9WuUrvOAT4how15DqSVnEFHiv05Wi2ENIvGsnjWUTbeEmiMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787969983; c=relaxed/simple;
	bh=1uq0OktBpwRoIS6gBCofNu9eRMadK8Dnh2w2Ro2HZTo=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 MIME-Version:Content-Type; b=NQfylCWNicOAIN1eLH/O/Do8zD+oEy2pY2EAQpTbgrGfvs6omUEmdrkuGqfxdmF/VJyeX1WdODwXa4uV3rLdwC9VRuLjqqPghgax5/QTy27ltDezSkzVJ1rb5Hfgv9/QDo0gWwfQO5qzCh+QyQ3bMg/ky+/clcPqKBumjqucVxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=inj4+1Yr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="inj4+1Yr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F281F000E9;
	Sat, 29 Aug 2026 02:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787969982;
	bh=9HXVxGUyH9+Xbg3iQ06ZYUAF5GYSUAgR+2FhHnV2fi4=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=inj4+1YrywsUb0yCj9y/U9+oYZULtTMQIgYpwY/TSNtxfWRrApKJT+H8jrafAVxUf
	 sJhA9+oUQWXq3p2Tbvlghu/bgbKdP2HrgspIFJnhCj780+IAgwqT/scA4xpxtlj1NA
	 0fc+9ANdgp/E1e1Kqw6SXtXl4VLDCFDPfFEi1VzH0ktV7FXJ0k+pFGSkyu3sZk2RmJ
	 20gVtdvB75YgR1Oh4QkOkqesqo0YQ6w4Qc3XNrEIq3Igx5y5L3MnXnJ3M1wqrNEWYR
	 svI/IFhfnE9iLo8xhVHoig410DnR9zN22DwR2ENo8TpCjO2N17yUGx8vZp4pTeGUaY
	 xvVuJSUyfuqTg==
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: mlombard@arkamax.eu,  michael.christie@oracle.com,
  target-devel@vger.kernel.org,  loberman@redhat.com
Subject: Re: [PATCH 1/1] target: iscsi: Fix hang for aborted WRITE_PENDING
 commands
From: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
In-Reply-To: <20260717143828.76291-2-mlombard@redhat.com> (Maurizio Lombardi's
	message of "Fri, 17 Jul 2026 16:38:28 +0200")
Message-ID: <yq1ld9pis7r.fsf@mail.kernel.org>
References: <20260717143828.76291-1-mlombard@redhat.com>
	<20260717143828.76291-2-mlombard@redhat.com>
Date: Fri, 28 Aug 2026 22:19:40 -0400
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain


Maurizio,

> When a LUN_RESET aborts a WRITE command that is in the
> TRANSPORT_WRITE_PENDING state, the target core sets CMD_T_ABORTED and
> waits for the frontend to finish processing.

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
