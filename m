Received: from mail.commetrax.com (mail.commetrax.com [141.95.18.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491801F5827
	for <target-devel@vger.kernel.org>; Tue, 14 Oct 2025 08:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.95.18.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760429535; cv=none; b=eyV60oF8UD9NihFknhdW9hR50uYiQW/xH5bk/v9cNb3LdVUInJSd4MOM+eoumwVEghD6mktUNbiq1/8wa6jjfERJQwWhrkVsWyfcCjSECU/eAqkuDwl6USitxpuVgRGNFFgkb7BnF0c1vGMno6XsuFQBxgV58renL3ubbEbsP1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760429535; c=relaxed/simple;
	bh=M2z+nFeXqIRcbI6rcgrOtIQjqLLid9ZQ1XheJsIeFLM=;
	h=Message-ID:Date:From:To:Subject:MIME-Version:Content-Type; b=faB4cv4pJw0HLyMzEGZdC8NjuxJzTPlBwkM+jC+ywhPNwCrfCNmPVRGMqsjgBT1YVzqUz60tb4RkX1e6nlMnpwBTVFwbMfFYNAi7qgVcyODFArHCMqwsBpn8272wmaoOV9Y1R2xNXyu0DR9jYoqi9tZT20FedWNqCixKfwSDTkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=commetrax.com; spf=pass smtp.mailfrom=commetrax.com; dkim=pass (2048-bit key) header.d=commetrax.com header.i=@commetrax.com header.b=JND+61JU; arc=none smtp.client-ip=141.95.18.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=commetrax.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=commetrax.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=commetrax.com header.i=@commetrax.com header.b="JND+61JU"
Received: by mail.commetrax.com (Postfix, from userid 1002)
	id 9506B242FD; Tue, 14 Oct 2025 10:11:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=commetrax.com;
	s=mail; t=1760429532;
	bh=M2z+nFeXqIRcbI6rcgrOtIQjqLLid9ZQ1XheJsIeFLM=;
	h=Date:From:To:Subject:From;
	b=JND+61JUorl6UEUbzvu+Sl6xyALEm9nsqI2hamfD1HCsVboxLSOwmli45dVmZETYf
	 GBwhzDi+Q+YokaDHe99hGPXlVNpNTE8sRZejxwyJHGcwVF3IZl27Tsx4voxqefMZEx
	 a15oP7/IO2jDU09Wucdol9SGPgAKVMhMA2VaKNtM2uQXtiyKS3WELEK+PHL8KyX/jc
	 KCcm0xZ9x5OrQpSuqveycuk+1mfp70iWCpRO4vZgueBy3LkZAOZhMpHcZvi5DbUU+a
	 vt0ocZLBHB5fT49kOkqyW3b6sHsfdHH3wH7JZQMCd7FnUy0MYptmgEClMkjOKrAkK7
	 j7GLI3DCz+hoQ==
Received: by mail.commetrax.com for <target-devel@vger.kernel.org>; Tue, 14 Oct 2025 08:11:01 GMT
Message-ID: <20251014084500-0.1.c9.16qox.0.2imrg8ah94@commetrax.com>
Date: Tue, 14 Oct 2025 08:11:01 GMT
From: "Luke Walsh" <luke.walsh@commetrax.com>
To: <target-devel@vger.kernel.org>
Subject: Welders ready to work
X-Mailer: mail.commetrax.com
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

we support companies in carrying out industrial projects by providing wel=
ding and assembly of steel structures =E2=80=93 both on-site and in-house=
=2E

In practice, this means we enter with a ready team of welders and fitters=
, take responsibility for preparing the components, their installation an=
d quality control.=20

The client receives a complete, safe and timely delivered structure.

If you have projects that require steel solutions, we would be happy to t=
alk about how we can take over this part of the work and relieve your tea=
m.

Would you be open to a short conversation?


Best regards
Luke Walsh
