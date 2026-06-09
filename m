Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71FD34DCD7
	for <target-devel@vger.kernel.org>; Tue,  9 Jun 2026 15:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781019283; cv=none; b=iCmd85dN9DfgtfHdy+72BLqMHEa/5pN5DDIhpgIhauXbxPudAewTgCzGEfAmdcs/0AKzO31rxdHiG/wNjF0dckNq5M3dKBeJqgEgPEzBy0sy4MzkLvWvn2/0RWTQlbztDtkjLXVbKFlxM/CqXDe+heniX+fKJm/Y3Xw3ZR+kAi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781019283; c=relaxed/simple;
	bh=5O0JkPvGvNCC2/+/mjU+ydTddQHPWxobpi9WKv/6i2Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VY76PWNBGDzt7tZxiyTXFxNvHOX5w/6a+jUsgbR2GbiWMx4obxeTnQNUdGFSCHfWA+U+GG5eqitDwOLTS6/udoPMlxUdIU8jEEY/FLvRl8SV91MmRBZYP2DhmlQdj05o2YotYri4SpjdGn762Yyu10I/WYgwtZhgiDuZtKmjBt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b=gEjGJNSg; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre.com header.i=@baylibre.com header.b="gEjGJNSg"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-490aebf33e9so32328935e9.3
        for <target-devel@vger.kernel.org>; Tue, 09 Jun 2026 08:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre.com; s=google; t=1781019280; x=1781624080; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=792RkLO86k+ZJOzIRVIVj9y7He3LCXZcsZ9MVtttc9Q=;
        b=gEjGJNSgeWLe99D4Y9Vg6R0GNWSDA90rUwURgu/jOLbZUy+zenR1BeoViOmA2RXitS
         EDSEp4tN9kfpVi95RGzjHCogZsS0RgJyBVZdYbMtVjU7DCaWIQdg7qjl40BEcUI7U4tB
         WEtmy3rO97t5X3HLr/Krqkyai9WdV7qE9IB0zhKXctILfiArG8hEZIn75IoLeD0IvdDC
         w6o+Zcm8P4qHLqmfcj0WRf1Dv2QZB2T+8gRdmEFGck6ZEKEvVF8oUtjlhytRNi/yg0vd
         FJ0FP1DAu/L2yc25+8ja0XKUhLUVT+Rff0t3r6lD4KynUgl7eRPqFUHPmgpQE0inwWyd
         Qfsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781019280; x=1781624080;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=792RkLO86k+ZJOzIRVIVj9y7He3LCXZcsZ9MVtttc9Q=;
        b=sGazqtuJ8RwG1w7Zg5U3l8iYOGIdLH+IXaKVS9jRzZaUt3u0SVNBqtWE49NiWGdeqd
         RAcglQmqBnKOFeEEJwxViH2714fUSKoS6Y4/gMmvUw/jCbyTNghFwLOfXMUfQV6L7Qb/
         /F04qxmNLA7VboCyma8sjIXxvEPREg/7jCbHBTA+RYVTvb+rKDmcwlfpT6CJByRLgQjv
         NgCIcPBoBoelGl+3J8RtauHnn6qdsUQUmURSaxHq94vUsexqK6cu7IWl3e+xFe18+yqv
         4Tztz5MJcTAEjJBb9I1vvJ7I4qsTYrWHx7qqiE5EPUWwqZgYM7gWbnXi4LnSBOv9n/Wp
         BzlA==
X-Forwarded-Encrypted: i=1; AFNElJ9dzV5IyLwyyRwSgMFSlY8vn070f+KsusH6jtFJkKbBhcsG8TQ3GVd9ptoEJs6CA+wNjTEKdibeIZhOwZ4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3DIJLFz/aciONbWGKSx7pUs3b4WdtQk1JWL6uxFmrBCVcOA5H
	UvvfmJMqrN7XePRxdNFBSytZmResc9zz5Mk6PunNf3OA4H8zRCdsnsEZdprSuNw21Ac=
X-Gm-Gg: Acq92OFtjkZ5Gn1GZWb1+lW8WmXE5f4NkEsy9p3RxL1KFE8iohSQK7eGcxUE9/W1Uq0
	4bpOFDBqIHhLhscl+copfZDPVuGTdcBYPoJqjbYmsj2Ufe9M4rGMxH5puskhBvPm8S8JcizcN2N
	r8N2OGzmbEPxduC/jZrpTsocfdP7y5jYys+Se56zXlq+/gd+KtPMQg/Cj3EJP5Ej36m1ky/m3ZL
	3YKW+QxClhNN6mvokXaUVaOy4mj1lnltGLgYE+xZs0wqyQ/OLBeoC0BNpHBOJ4BfXtepXOaONLw
	AtI//ndwksEKNZxagQzZC0ZAxZ8LaGNRuzyBw7mM3kNLvnOiBb+ZQYbgV7vr+rn7/V0lJUJplxe
	uJ86nQ0jVm8Z38+WZu68yiixJGTi7/iG+NoO/MSiYrrSNEcCtqBceSchV6X8iT122aWvjv7cWwf
	yy4oMTXYQnfaALGIqE3s3IcOoLcExSZhwNUV9N7lOYd6vcEgXAMIPkcC4vmGPHE805VV4uJ5tNF
	GH/sxDuNJFuWt6+Ha74vKAYRw==
X-Received: by 2002:a05:600c:81c9:b0:490:bd66:db49 with SMTP id 5b1f17b1804b1-490c25a1e20mr289084495e9.12.1781019280238;
        Tue, 09 Jun 2026 08:34:40 -0700 (PDT)
Received: from localhost (p200300f65f47db045b0dbdd314d8a71f.dip0.t-ipconnect.de. [2003:f6:5f47:db04:5b0d:bdd3:14d8:a71f])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-490bc3c183asm494834455e9.6.2026.06.09.08.34.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 08:34:39 -0700 (PDT)
Date: Tue, 9 Jun 2026 17:34:38 +0200
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig_=28The_Capable_Hub=29?= <u.kleine-koenig@baylibre.com>
To: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Adam Radford <aradford@gmail.com>, 
	Adaptec OEM Raid Solutions <aacraid@microsemi.com>, Matthew Wilcox <willy@infradead.org>, 
	Hannes Reinecke <hare@suse.com>, Finn Thain <fthain@linux-m68k.org>, 
	Michael Schmitz <schmitzmic@gmail.com>, Ram Vegesna <ram.vegesna@broadcom.com>, 
	Yihang Li <liyihang9@h-partners.com>, Don Brace <don.brace@microchip.com>, 
	HighPoint Linux Team <linux@highpoint-tech.com>, Brian King <brking@us.ibm.com>, 
	Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, 
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, Chandrakanth patil <chandrakanth.patil@broadcom.com>, 
	Jack Wang <jinpu.wang@cloud.ionos.com>, Junrui Luo <moonafterrain@outlook.com>, 
	Kees Cook <kees@kernel.org>, Dave Jiang <dave.jiang@intel.com>, 
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>, Bjorn Helgaas <bhelgaas@google.com>, 
	Lukas Wunner <lukas@wunner.de>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Thomas Gleixner <tglx@kernel.org>, Duoming Zhou <duoming@zju.edu.cn>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, target-devel@vger.kernel.org, storagedev@microchip.com, 
	megaraidlinux.pdl@broadcom.com, Markus Schneider-Pargmann <msp@baylibre.com>
Subject: Re: [PATCH] scsi: Consistently define pci_device_ids using named
 initializers
Message-ID: <aigySpryV0ptiBqr@monoceros>
References: <20260429101820.3059523-2-u.kleine-koenig@baylibre.com>
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="4zu2ga2qgi7ol5sf"
Content-Disposition: inline
In-Reply-To: <20260429101820.3059523-2-u.kleine-koenig@baylibre.com>


--4zu2ga2qgi7ol5sf
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] scsi: Consistently define pci_device_ids using named
 initializers
MIME-Version: 1.0

[Dropping Bradley Grove and Michael Reed from Cc: as their addresses
bounced]

On Wed, Apr 29, 2026 at 12:18:20PM +0200, Uwe Kleine-K=F6nig (The Capable H=
ub) wrote:
> ... and PCI device helpers.
>=20
> The various struct pci_device_id arrays were initialized mostly by one
> of the PCI_DEVICE macros and then list expressions. The latter isn't
> easily readable if you're not into PCI. Using named initializers is more
> explicit and thus easier to parse.
>=20
> Also use PCI_DEVICE* helper macros to assign .vendor, .device,
> .subvendor and .subdevice where appropriate and skip explicit
> assignments of 0 (which the compiler takes care of).
>=20
> The secret plan is to make struct pci_device_id::driver_data an
> anonymous union (similar to
> https://lore.kernel.org/all/cover.1776579304.git.u.kleine-koenig@baylibre=
=2Ecom/)
> and that requires named initializers. But it's also a nice cleanup on
> its own.
>=20
> This change doesn't introduce changes to the compiled pci_device_id
> arrays. Tested on x86 and arm64.
>=20
> Signed-off-by: Uwe Kleine-K=F6nig (The Capable Hub) <u.kleine-koenig@bayl=
ibre.com>
> ---
> Hello,
>=20
> the mentioned follow-up quest allows to do
>=20
> 	-	{ PCI_VDEVICE(TTI, 0x3220), .driver_data =3D (kernel_ulong_t)&hptiop_i=
tl_ops },
> 	+	{ PCI_VDEVICE(TTI, 0x3220), .driver_data_ptr =3D &hptiop_itl_ops },
>=20
> which gets rid of a bunch of casts and so brings a little bit more type
> safety. This patch is a preparation for that.
>=20
> I assume a single patch for all of drivers/scsi is fine. If not I can
> split per driver.

Is this patch still on someone's radar?

Best regards
Uwe

--4zu2ga2qgi7ol5sf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmooMooACgkQj4D7WH0S
/k7rYAf7BB8NfldywKX4tj4A6aBVySOEe2C7pUP1TdlEr3w19ARcaTKXslkG4Ehf
3bsCMPQMhEjQaFnmd8qLPqLJt7H4tBDoXphJO2ydmt4pKJ6GYA+aIZsUPyLhlcYN
Jj44sLl6uuougfkZ95xMlkV8BqwoumkQkJXzshYIWXOUTGs474POTHB51QdoEfCX
2I7X6sEy9N7YYtshmD4o40fj3dRxxemVfdbpwWAnAD2p7UK8K/IG1l+IbG3Znp/L
1UFRAw/ukBk7IxkxA/RUDCc7jMor+/X6AkLLF+r3TLvnblpL8CEO2yaXmqNhEiBT
vWE5iW6MuwrRCxfKUVsBadNfYqvblQ==
=uDdw
-----END PGP SIGNATURE-----

--4zu2ga2qgi7ol5sf--
