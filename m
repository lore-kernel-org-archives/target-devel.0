Received: from mail.nextryonl.pl (mail.nextryonl.pl [162.19.155.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B82229A9C3
	for <target-devel@vger.kernel.org>; Fri, 28 Nov 2025 08:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.19.155.164
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764318647; cv=none; b=cIEefODeD/92VhXahhzj5ctQcH1/LvkYWb7fypzyZqGQUgTOJHvEVWqSgKW78VrGXXhbWl5BJQt4H+zwbYjY9NpOEbBh3eWAfyOcDAe5SuIPNrJSQj269nm7v9RHKwOXi2tEQyg3RTTz4eU+NQuYCR5iKAIiD/usWvG4INGhh1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764318647; c=relaxed/simple;
	bh=fIh67CnJs35z4uTVN1yEzBZIG1sWJSjOc8Phu/rB5ug=;
	h=Message-ID:Date:From:To:Subject:MIME-Version:Content-Type; b=GwiJKeGVNlWRsjDDDxWKjhiFf32Uu4N1J/X4F3GPKvr+bTh6b9G85SbDdTYugFgNdd62UfjX/Y0d4wvKT9XIsosV7KD7DmTFp3zN/6mLbVLpY4cgSSPWZwa9YSSrHGeIrEa0BEJMN06jPPPvdmAmU7ld/7DKWDP/wncSk46pLC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nextryonl.pl; spf=pass smtp.mailfrom=nextryonl.pl; dkim=pass (2048-bit key) header.d=nextryonl.pl header.i=@nextryonl.pl header.b=gbxxGRsT; arc=none smtp.client-ip=162.19.155.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nextryonl.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nextryonl.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nextryonl.pl header.i=@nextryonl.pl header.b="gbxxGRsT"
Received: by mail.nextryonl.pl (Postfix, from userid 1002)
	id 513BE22563; Fri, 28 Nov 2025 08:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nextryonl.pl; s=mail;
	t=1764318642; bh=fIh67CnJs35z4uTVN1yEzBZIG1sWJSjOc8Phu/rB5ug=;
	h=Date:From:To:Subject:From;
	b=gbxxGRsTejzPsrW7xGOnoTfwp3KeOTid1exuPZADUb9ZQgPGCn0qcGgqtCei05a7h
	 kUcu2eckEPnF7vf7s9/r03UqIpJq9jblzjS1nukPc/yRmrVmJb1ldE/SK+5V1d0e9Z
	 ue5Uos1u9/pd4wm7tcCCRSkwlEQPwOTAhQWBvUrWSPXzp1n26psTK9OUJKP8//oydz
	 3TwKOmQJzGLqpw0ortJLWyr284ZGx++MijyTCC0lvtgqvxABqIac44GBqR0q9Qm+b3
	 bqRv/FfCEYHlKjNyEQMLuvzBueJaPoSex5ycrW+jyIYUzbqNgFCr0tLhNTYDQKF8bK
	 j/fsi1dEogAZA==
Received: by mail.nextryonl.pl for <target-devel@vger.kernel.org>; Fri, 28 Nov 2025 08:30:31 GMT
Message-ID: <20251128074500-0.1.65.10hr8.0.0qmhemaesi@nextryonl.pl>
Date: Fri, 28 Nov 2025 08:30:31 GMT
From: "Marek Poradecki" <marek.poradecki@nextryonl.pl>
To: <target-devel@vger.kernel.org>
Subject: =?UTF-8?Q?Wiadomo=C5=9B=C4=87_z_ksi=C4=99gowo=C5=9Bci?=
X-Mailer: mail.nextryonl.pl
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dzie=C5=84 dobry,

pomagamy przedsi=C4=99biorcom wprowadzi=C4=87 model wymiany walut, kt=C3=B3=
ry minimalizuje wahania koszt=C3=B3w przy rozliczeniach mi=C4=99dzynarodo=
wych.

Kiedyv mo=C5=BCemy um=C3=B3wi=C4=87 si=C4=99 na 15-minutow=C4=85 rozmow=C4=
=99, aby zaprezentowa=C4=87, jak taki model m=C3=B3g=C5=82by dzia=C5=82a=C4=
=87 w Pa=C5=84stwa firmie - z gwarancj=C4=85 indywidualnych kurs=C3=B3w i=
 pe=C5=82nym uproszczeniem p=C5=82atno=C5=9Bci? Prosz=C4=99 o propozycj=C4=
=99 dogodnego terminu.


Pozdrawiam
Marek Poradecki
