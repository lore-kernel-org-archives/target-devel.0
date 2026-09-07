Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70383C5DB8
	for <target-devel@vger.kernel.org>; Mon,  7 Sep 2026 09:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788773480; cv=none; b=cV3xIAkF1qzjciAc2ETYNo2Dh7wBGmcPag+sr2rUGEiv2tL/DEbgn1KLdxUBj4HjtC+DvrymN5g9B7Gb0sT7SuRX3/G/+w5aLtLU5B+7vBusXTfT4ZDOOpJ0ZWImuDOxDe7ONqw8WNMbHz6GTjTrx03pjbbijVS/Uzx9c2W7hHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788773480; c=relaxed/simple;
	bh=YW0gAUDwkvvZJn0XenT28cdinXoPV0s6KA1GbgLjbl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AGJaT1sDuB2SRHT/6QQdfQK4LzEojp8/KQzNHOghMUPVwypypyGZCZBBwPkGl6vff0hd8PArX0jFNvmKpZDXDbEPk6rza+OnRcFE6CvyXtM68Wklv5sAkA9aMGPtRibIG5F6XHng4k5OqHL09OzlHLH3xE9njCKEkU3wYgtW0Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LoNP3T7j; arc=none smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LoNP3T7j"
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-4b5b727be96so2174377b6e.3
        for <target-devel@vger.kernel.org>; Mon, 07 Sep 2026 02:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788773478; x=1789378278; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0wrOg4Aqb2hI92x0tRngos4S31Q42LPdhP4S5UqqDqA=;
        b=LoNP3T7jBczwYhCB6GqytMJwiWG2SmUJ8pEvl2BWpYpyABiSdj2MOoLI9I3jR4BH+s
         IwBb9lJzLgrJ3iJ5oX/evNqTJ6eFlWL7SPWQyLDkBBH8y3VoR4/M9PzaS9Npi/QsQ8t+
         wv7frP3pgzZrRqUSkUwCk8vSr0RrTnZoxdfV4PdHUeN5d52ypRYSFYfomMar015fSVVK
         wGla91AadYzB5Vh8PbtdOOGuYxMbqT+Punf4j5fodWBrWjyeHR9OCOQOkT7OZ14z+aag
         KJISPHNVwxYSTBqjvXOJI+bwFUt1D1PKqDDz4Qyo6wxrUAI4OD7eSagYNBMt07BeWulx
         2Zsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788773478; x=1789378278;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0wrOg4Aqb2hI92x0tRngos4S31Q42LPdhP4S5UqqDqA=;
        b=YqKYzyhMoi6k5tP3o0M/UKt92KhXPMIx8zFa2Y9AzY0rGzHhxpF8fEPuSEK4or1m8H
         XO09h+4nHGYpIAVszM2regHfxFA4OWOH39VOCWaCUWamMC1A3hwRP6cDBhgqkQmvXxD/
         U5IYVHe3BzgihpoTrbC/WOIseyHdt/K5T2gCmau1hjkli2ZaA7QMpQhoRG+CUqjr7hne
         hj/+orbPs+3aHezxY1WC4J4gwCW1BN434C3FTG6zW1Y1mFR69/DxZXq6o4vTCmpvnRSR
         o3ovgKDPl8C5rPegpJo62R6qB0MXrlKmjrm5m+TYCreX8KGUEKrnf1joYTNnWccmBJwp
         CWAg==
X-Forwarded-Encrypted: i=1; AKwUvBzRkwRMGPbVHBCfJPUnfcIuhzf58YDdS9BQgdg2uPDb+7/hvZ/6akvFBeZyZxGHyqjPW5jnDCuFMVZq0uY=@vger.kernel.org
X-Gm-Message-State: AFuF++knf5ORlnREZrVEz6u1QQ59ISwS0mRgR1NEy2AeaR/0OVFUVf4i
	RdcLDEMQow7MJXJvcow3qobe0tcKj52j4VKaUWdpAPU/b9rGPdv6aCar
X-Gm-Gg: AYBFou12DaGiyBe2XzXmyoI+rH2mIpDbM2qbcLINCiUnlRG1fDy9XdxZ3/9h07e+itA
	qCJ26IvEwZXXKksTPETl6u1pNSxkjBIa2Yun9VHlG126LXdky8LkI6uXHiEhdIFhdHZ35h3VOwW
	x8J7o/pRrOL3zSrT8TqiJ7q/FGmxO7xyAu2y8qiVRsExdqSfIbyUJFK5XnZkKfecMaZnh9bAm/y
	yV7qfvA6vhmWPgeq3iUOMaz0oZYj1WUIz+wFRtGA7+hwggn7GE3D4+6gBJYQJAbfPX/tgd07jQb
	eWv/rX8ntz74xqYOpCqTey2h/ZK1O5PU+s95L86sj2+hx0hNWLERG9QYDEt1+XQYC16vdcG3DoH
	5ZqSNDYZZVsx0iiORztxWOKNgsLfohAkEL+EbGXLBGAO3pMviysJ1OKFFHiIGqca65HsP2J3EiI
	zLDo2qylFgZ/6S935hpELFbx9yAw1EiTuGrCGtNqbqo7MLwkd7DF39wT4/3Bi6xxLtMx3Pg2KXh
	WH7NFU9p7UuMfXnHkL+ZRnk
X-Received: by 2002:a05:6808:1920:b0:486:4892:d553 with SMTP id 5614622812f47-4b95cad07f1mr15166734b6e.0.1788773477623;
        Mon, 07 Sep 2026 02:31:17 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-143243f780csm23953277c88.13.2026.09.07.02.31.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 02:31:17 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Potnuri Bharat Teja <bharat@chelsio.com>,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Kai Shen <kaishen@linux.alibaba.com>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Michal Kalderon <mkalderon@marvell.com>,
	Nelson Escobar <neescoba@cisco.com>,
	Satish Kharat <satishkh@cisco.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Max Gurtovoy <mgurtovoy@nvidia.com>,
	Bart Van Assche <bvanassche@acm.org>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	target-devel@vger.kernel.org
Subject: Re: [PATCH 1/2] RDMA: fix typos in comments
Date: Mon,  7 Sep 2026 15:01:09 +0530
Message-ID: <20260907093109.24023-1-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260907082728.GH13683@unreal>
References: <20260907065047.26773-1-hemanth.selam@gmail.com> <20260907065047.26773-2-hemanth.selam@gmail.com> <20260907082728.GH13683@unreal>
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

On Mon, Sep 07, 2026 at 11:27:28AM +0300, Leon Romanovsky wrote:
> >  			 * release_cleanup is the exception because
> >  			 * uverbs_uobject_fd_release() needs it. In this case
> > -			 * the module reference held by the fops will guarentee
> > +			 * the module reference held by the fops will guarantee
> >  			 * the type_class remains valid too.
> >  			 */
>
> And what has changed here?

Sorry, that one is easy to miss: it is a single letter in the middle of
the word.

  guarentee
      ^
  guarantee
      ^

The fifth character goes from 'e' to 'a'.  "guarentee" is a misspelling
of "guarantee", and it is listed in scripts/spelling.txt, which is how
checkpatch.pl flagged it.

Hemanth
