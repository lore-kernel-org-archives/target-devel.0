Received: from arkamax.eu (128-116-240-228.dyn.eolo.it [128.116.240.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22CBA29D260
	for <target-devel@vger.kernel.org>; Fri, 10 Jul 2026 14:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=128.116.240.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783694697; cv=none; b=bWyhlnhqbJXM0sknJQ0Z3BEfyOWjETsG5hRMGaniCa3CjqBuwyo46/nFBJie8U/y14ll5+5QXnX+hhWIP4QDud2xZmn5WqOft3wr/0hCy54DfYDURnoFiIwsQ09l01zpO3f2C8ezevSgXkVDKxIf20lygjvVS0tz/HizSCHuhYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783694697; c=relaxed/simple;
	bh=mIxkibzeJC+U/zrP4DQQcWaSCK26u2bHcYe7Ycxupkk=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Subject:
	 References:In-Reply-To; b=Bunlw1kxdffqro58msHDdvacOnTiBWajoQUvyIf3JHvcVfvxKgj0DWym+ylE3Op/3sBPlHCkl6F0G3NJnaFPomtpNETZaVA8GVXO34qN5KHyjOmnS5PyMX7sEUC7lP/Gri/L8KWKgvqbV6DR7DcWAe/tCcgZFarDrfUqkK1dMp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=arkamax.eu; spf=pass smtp.mailfrom=arkamax.eu; dkim=pass (2048-bit key) header.d=arkamax.eu header.i=@arkamax.eu header.b=czEvk0s9; arc=none smtp.client-ip=128.116.240.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=arkamax.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arkamax.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arkamax.eu header.i=@arkamax.eu header.b="czEvk0s9"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; s=mail1; bh=mIxkibzeJC+U/z
	rP4DQQcWaSCK26u2bHcYe7Ycxupkk=; h=in-reply-to:references:subject:to:
	from:date; d=arkamax.eu; b=czEvk0s9muV2WxaCrytfvV92rln5B9h1trJkJ/vATg0
	vkwfesF5Zg+quXZHV2dDWaFQNhjocdwhRwv79neDuYtgTn5UN4RdPgrg/zneZ8ubImmUsG
	cL0gg7GeRe7R/RMIffdJupJFTrSsYykYAlpJSf3qD6axp348pKbeJX7ZrVozK5VRpy61AT
	/XmknEoVCN4UPGKwK+jfrwZr2B9iVx4wq/vW6HvV8lqV0LjCq7tKnhYEjwc+Fwt/lZetZ6
	8LMCK+0YsHksLpcCad8dHU5L8deVm8GaYsy69QjsYEgYYAzDUaUPmK8cCFyPhGujPtaCJc
	jSnUWt4X0MHiNfDd79A==
Received: from localhost (128-116-240-228.dyn.eolo.it [128.116.240.228])
	by arkamax.eu (OpenSMTPD) with ESMTPSA id 64c612a7 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Fri, 10 Jul 2026 16:38:11 +0200 (CEST)
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 10 Jul 2026 16:38:10 +0200
Message-Id: <DJUYUT1XN1D5.13A59JJEDQ1IN@arkamax.eu>
From: "Maurizio Lombardi" <mlombard@arkamax.eu>
To: "Russel Moos" <rmoos@dunaway.com>, "target-devel@vger.kernel.org"
 <target-devel@vger.kernel.org>
Subject: Re: TargetCli issue / bug
X-Mailer: aerc 0.21.0
References: <DM6PR13MB3907DA980830B2383DAB09EDA8FE2@DM6PR13MB3907.namprd13.prod.outlook.com>
In-Reply-To: <DM6PR13MB3907DA980830B2383DAB09EDA8FE2@DM6PR13MB3907.namprd13.prod.outlook.com>

Hello,

On Fri Jul 10, 2026 at 12:26 AM CEST, Russel Moos wrote:
> Hello,
>
> I was using your guide and discovered that when I try to create a portal =
for iscsi, I can create any portal I want except one with port 3260.
>
> For instance, I can create 10.2.70.250 3261 just fine, but if I try to us=
e 3260, I get errors like "Could not create NetworkPortal in configFS"

Could you look in dmesg if you see any error?
Can you tell me the targetcli and rtslib package versions installed on
your distro?

I tried the latest version of targetcli and I don't see any error:

/iscsi/iqn.20...5f3cdaaa/tpg1> portals/ delete ::0 3260
Deleted network portal ::0:3260
/iscsi/iqn.20...5f3cdaaa/tpg1> portals/ create 10.8.3.73 3260
Using default IP port 3260
Created network portal 10.8.3.73:3260.
/iscsi/iqn.20...5f3cdaaa/tpg1> portals/ delete 10.8.3.73 3260
Deleted network portal 10.8.3.73:3260
/iscsi/iqn.20...5f3cdaaa/tpg1> portals/ create ::0 3260
Using default IP port 3260
Binding to INADDR_ANY (::0)
Created network portal ::0:3260.
/iscsi/iqn.20...5f3cdaaa/tpg1> portals/ delete ::0 3260
Deleted network portal ::0:3260
/iscsi/iqn.20...5f3cdaaa/tpg1> portals/ create 0.0.0.0 3260
Using default IP port 3260
Created network portal 0.0.0.0:3260.

Thanks,
Maurizio
