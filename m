Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147DD17557E
	for <target-devel@vger.kernel.org>; Thu, 21 May 2026 00:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779324225; cv=none; b=TLXyH3p0Y/ESGrMpF6qliVWKjvp36nxXRzbc4S8dK2GHDOPD3VhP/sjADbz/lLGExECozhnphaJR0cKJUwAhPVqsZs4mfPlMLbNuWtHhBR+ndLkZPGb77ccQdJtODQCwBC9TXyRM7Dw0SmuTR+IRByj4S4j+6Hy/rdGJ9l6ZiFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779324225; c=relaxed/simple;
	bh=IEIzvlRRqDl+bWvL9H8iIJCwiKrUdTUr0U3EgaWDVWo=;
	h=Message-ID:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Content-Type:MIME-Version; b=nUPDRorijjyQlCmi6g4QzIPOIR9ETnKv2twn8HXatRPNSFcIo7GeUV20Fmp9wRUSC2PA9V884/z+c0Rmx7yzF6WUknA7YxsVugHAaHZc84L+IWyeYWtmEnSswW00LkVZ8jL0YVE+G04FJrPFN/6vA24lfo6iClbSJwwfIkGiqpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=chDufqv5; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="chDufqv5"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-bd4f8260e4eso1082421466b.1
        for <target-devel@vger.kernel.org>; Wed, 20 May 2026 17:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779324220; x=1779929020; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to
         :subject:cc:to:from:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D+uQ3Q0GrDaAUefTv9AQLXze2AquCr/DP4u2vUROxGQ=;
        b=chDufqv5kulo53fezyEyTxtb2SL3xMz0aYVAukaG4fJKB4kIZzLE5nFXg9LquI2Smw
         z6Uj2B/GoNAeoWLyWXzMfEtGm5kEEQ/Q67fSv88ueH10oZFldfQqNNbD4OiP2W3Ogb9H
         sQhm6u8ic3wJHdyU5xARAvYMkQnN+RpJywI/2xiRgW/Ti1GJg+8ygjX9bQz44mbgHfgD
         lUjfnitFCq6Qzca4B9iwfPefsMQmuJYHEjdo4AnAvn1P+zFgwMJTCRcr8GvRciRaIjsL
         A/2A1f2VV+YrPPP9upn0DC3NriKPWSqHb6fsHdyGpTURNh80goha954gjX+Qs3qOzFz0
         1QwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779324220; x=1779929020;
        h=mime-version:content-transfer-encoding:references:in-reply-to
         :subject:cc:to:from:date:message-id:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=D+uQ3Q0GrDaAUefTv9AQLXze2AquCr/DP4u2vUROxGQ=;
        b=ljAFlYIUH2HadVyuFUvbhHAUMR5wxLhlqg2JTS1v2bZwCaoH2A/nKhALZ860bFR00d
         ZJy+56D/rbc4yr09zQZq1gdh/ipEAE1FqSOAAtrJNW3lmW3UDMJyj/5IoTIwylQijePg
         C/v1VGVpv8qa8Uyxc5/gMInpnS1t5L5j+4XjB63pkvcJL0lsGO13vZgE45gx+Pf/A01Z
         lkraZd9AE/qVdnFq0dlqwi/g2bC0TzMzui09rLW0eXYmma1yWHpz3jpALgRLClp8Ke4O
         78nQYUnbCRQkaxOUD8fVND/7DENnfBa+cS07d6zKx3OfDI2sgo527Wi6HZi5HIkHQ07A
         1a1Q==
X-Forwarded-Encrypted: i=1; AFNElJ9iM9BuCDVTdKniVajKjdZG/f0l/Wv7fBg2j9KmTgAIolzIcc2ugUgrfowbw2RJQ0WXUS3OoBgY6xbDpcU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2iDSql/I53Y3WHiyUb51RhSKPSL5bkvNn+zmFJGCgzpBCyfFL
	fv2jS7z0A1gdCH4R3MQus4o6eVTxe7DpfYpRwxhra7Tl155vS3gkWOPu53yrMLBs53g=
X-Gm-Gg: Acq92OHc7jVgrXD06s5zAyfNwy7l1pnrPWU1efnmMzItgi/UTWGBY0vcFG7/0oGl4/K
	JD6sdN6EoNdNuPgnTqWWNwvjtC1AcT5pDPBA/nAgYwExlujMwBuh42PCthnI4ZQ0iJBt93nERo8
	aUP11e0itHu+vDWTGyJHD/5NGdC07aFwx7V6X9ey39Zcv/t+wHr8W2FDK4sRccMXjrsmuGdqpX1
	f01cEgYQ/nwesrP38FqseyB2nAfqz6ptMY+OEiqXZ9PiIzwg8Rkbv4lr5NHhP29mjoiv1u2ie1W
	tFoodsjSVZTOTozCRrPTYAKdZzSLxPRNSPobAp+4IiFvE3zjZjjqJvzEobhUpT2u+Ej8IG0n6+Y
	jQorY3VlmMM500ZMgtxIAIoxBwHmhbIbkntM0jDFj6CXtR9fdGVNxrTk+GPlRHHt4jKBfwWfd2Z
	K1751DpKNGlrDnUXx76x9K4c2Nq9wEMpnnk6vBBIlMfNQJEubYL1YsUOJzosf5GYoLyoQkfntCD
	za537UkNfRbNipSGhDv/uoGIgCuM3DnGdTYl2Es4uJ3mcfqljMIl1GOmvlfWdgSAwzyEtK46b0Q
	unNshDJtFMds8dWRA6QDCKfjb2jA
X-Received: by 2002:a17:907:3c95:b0:bc3:c6f5:1d47 with SMTP id a640c23a62f3a-bdc12f857c9mr22479466b.11.1779324219917;
        Wed, 20 May 2026 17:43:39 -0700 (PDT)
Received: from ahossu.localdomain (ip-217-105-56-94.ip.prioritytelecom.net. [217.105.56.94])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bd4f4dea94bsm919213866b.33.2026.05.20.17.43.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 17:43:38 -0700 (PDT)
Message-ID: <6a0e553a.010ccaa2.2ab173.fc09@mx.google.com>
Date: Wed, 20 May 2026 17:43:38 -0700 (PDT)
From: Alexandru Hossu <hossu.alexandru@gmail.com>
To: d.bogdanov@yadro.com
Cc: mlombard@arkamax.eu, martin.petersen@oracle.com, bvanassche@acm.org,
 ddiss@suse.de, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
 stable@vger.kernel.org, hossu.alexandru@gmail.com
Subject: Re: [PATCH v2] scsi: target: iscsi: validate CHAP_R length before
 base64 decode
In-Reply-To: <20260520180204.GA15940@yadro.com>
References: <20260518121811.385350-1-hossu.alexandru@gmail.com>
 <20260518235040.48647-1-hossu.alexandru@gmail.com>
 <DINMKOIB4PRJ.1Y571RHF6NAQJ@arkamax.eu> <20260520180204.GA15940@yadro.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, May 20, 2026, Dmitry Bogdanov <d.bogdanov@yadro.com> wrote:
> Yes, the length of Base64 decoded string is not deterministic.
> Moreover, length of Base64 encoded string must be divisible by 4. Which
> is biger that 4/3 of decoded.
>
> | MD5_SIGNATURE_SIZE      | 16   | 21,33333 | 22       | 24                =
   |
> | SHA256_SIGNATURE_SIZE   | 32   | 42,66667 | 43       | 44                =
   |
>
> So, that formula is not correct and will break all iscsi authentication.

v3 (sent about an hour before your email) already handles this. Trailing
'=3D' are stripped before the comparison, so the check is applied only to
the data characters:

	while (r_len > 0 && chap_r[r_len - 1] =3D=3D '=3D')
		r_len--;
	if (r_len > DIV_ROUND_UP(chap->digest_size * 4, 3)) {

Using your table as input:

  MD5 padded:     "data=3D=3D" -> r_len =3D 24-2 =3D 22, 22 <=3D 22 =E2=9C=93
  SHA-256 padded: "data=3D"  -> r_len =3D 44-1 =3D 43, 43 <=3D 43 =E2=9C=93

> Alexandru, may be better just to change size of client_diggest variable
> to match it with chap_r like for initiatorchg and initiatorchg_binhex?

That also prevents the overflow. The length check is preferred for
consistency with the HEX branch, which validates input length before
calling the decoder rather than relying on a larger destination buffer.

Alexandru
