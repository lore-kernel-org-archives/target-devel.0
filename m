Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA163AA1B2
	for <target-devel@vger.kernel.org>; Fri,  5 Jun 2026 16:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780675389; cv=pass; b=FkZydp6hgQO8hHwerpYVJBm6uhpjACVzSKlBDg1twSAuspCkxgO/yKEy4eovsSrzVbMoOBI5AUFbAZ49Ulpo7qXlR0hwkBgUYrV0KhUTNKDRx4CU6Ho8Z3vI4x9mK1a9Eo5Jo3ruau/FE3fTqytfQby72xYkrHZ5+ArKRNvr5Jc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780675389; c=relaxed/simple;
	bh=/OAVgqB1os2JKqx6E3DYW6MjnB+zs+wpoJqXzrnGQYo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r50+deAa0AW/I5nvJUm9Bnlh+8uaAYPYNUlzWqPbsXuYp938JglGs/58fzlOsSRK0VL7/CJQ/gJ80HUX8IfTDoeu3N/VkM3WL4uw9612+PIeL1HcC12WY4sIhYl1Y//t9HIlLuRnR0ykVao9Sg77zg54++mkT1og29tT8tvI7IQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dx8ZNviY; arc=pass smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dx8ZNviY"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-3966388b388so19188991fa.1
        for <target-devel@vger.kernel.org>; Fri, 05 Jun 2026 09:03:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780675386; cv=none;
        d=google.com; s=arc-20240605;
        b=lcCzMEKjB7nFm9JVDZY2CYWCj/dS2p5ZN13VEVkpyFfdSUi0pinrksvSPMZ/NSz86c
         FvU2TMeDmwlwJ5pvRsnIPuuzn4QvYbMForp5IAyR6JHVIC8fHCVssUNp8Fl4nUkUg5M9
         cPHSb/gJ5v2+v2vMWIdIXMny8aRkEnUDVVO+rWNA1VDK0HAKWctP4Ud7SfkHViE1y3AE
         qCkqeJU50nO79PxJ79FhpEqSm2kAS5NZBzulAg3+d6N7ZqrcvLu644w0lgI0gRqK+J2U
         wRDyp+grEGnsgZ8DLjx4gvGoDVj3BFtoKiZDGlxEGdnyWYYNX/+6x0QcMza4uGvxU7ur
         1KxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=m3imsklewZW5NJtEHgr3Rhgr27i3saOSHzFDYpwEW70=;
        fh=5L1ZzOsHCl6Nkb2+73kD07AsEzmb4eiG1oVW/sXaUko=;
        b=NHMo7TT+CViZ0PTGjXks3shJDwH/0CaC5aUq5OyLDAvS1rzn9gYo3wlvu7cp0N1suP
         feQybzISXnaBBCp/R7FfL7mO82hB8+0LLpgjrHxtZccLk7WVJHVL71o4NkQrw7coJAHn
         spzldaTWIADlWYnTk8gL62Z7kfDq0esDEC66VCyBNBM+EjlWegRcHP2D60scL0zX96wD
         T2S5zvzGjw0AGDYDm/Vcn9rQV71/B42XM/nS0jJD6eqhzx7hga+OiRd1ioRnO5aEb457
         8/YOj+gW9xwsGcI7RMsytsBh46t8zaQ+qzeEk8EEh/kajNPdJuV9+ePj9QX/ATg5dvYJ
         IHRg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780675386; x=1781280186; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m3imsklewZW5NJtEHgr3Rhgr27i3saOSHzFDYpwEW70=;
        b=dx8ZNviY3ajZ2AJbHkxaYXWi9cY5R6CcwR8vn9mcI4Qd3td2XNFnvfLy+c1L4w5yo6
         jIu3Tt1WnJSy3HQxt5K988tAIypTv0erV1JMOv/5k2mp3mNHazq5xmECBT2XnJGI6Dkd
         HM3V7GTZJzlgHULQmOgiJ/9bPD1k58Q91L3krYh4g1hK0w1kOJ7i7YtAC/NTjlaQGs4L
         ZDE3xewFEgJRfK2Q5ijPaE/v8RsYTpT+4zBVIjO8Urub/9RIlvzgAZP+ctTD9r2SwlI9
         jayx+sk9EUPnMbxlrKav/TkzVNQ1o3onTcx8WSPEXu3nWfPn0UJE1UNYFg4oaOtbBP63
         9vIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780675386; x=1781280186;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=m3imsklewZW5NJtEHgr3Rhgr27i3saOSHzFDYpwEW70=;
        b=NuRlJJeS9UqjZVhSyTFSQOjhBoplwridb/AGoir0EFKfqEeW97iE8OXC/jW9TngUBm
         Wn/Q/0oPYvQm12CFfMExIL/pObXkTSx89Yp4m1CYgUp4LS3G9gO4jhX9dTggTfTcUjGd
         WzZcnBszmHE+ehgZ5tT4vDCFytFR4uwvxBTDDIP9Day/pnz1K1zn6qY4pA67zaQxGemH
         LiYvX0vmswKGr/QX75d6Imm2ygZV/wEgHyOLDdqAqgYDJt2sSphhPvTRDsbiumAsztM9
         aS2/KIM7EuFeZndID+85AaGmzED9hrXT6rVnE0KQklmIQvu4+h7YvFmlgdzRMQ+Ej3z+
         nzNA==
X-Gm-Message-State: AOJu0Yy8os+mGLghlQHjhvNHE4xouPdJkUF1b6vue20PiQWn0t3CEbAF
	z9ZoQnT80NlDNvOVDjEKJeEVmJb3J5LSqWiIT8St4cR74Sk9A3It0+gVXSWj9xZm/dk9v8ILfVE
	b7hppfbMCw8EzUq1apEfQIOGxRU4IusSU4JjCWuhMJg==
X-Gm-Gg: Acq92OHuWUqdM1ijf0d2jcK5er/bjd+sEs71TKrR5LhottdXqP2I9R6I0o6q87Db8dc
	C3C4gCg67TyFPAA8CcqG2AFdZJJP3uyhh9mPOLVrCMPJ6sdrbh8gOOy9FnqWiXX9QTRBGEMm1dr
	M8Tl8zVztqBZhYYgYiOdUlFqkZZhnpPCSZGEi33kTQ1YfGAPFAU/BRFxsLnu3dZqhzo1xEzk8iT
	KBe3kFuea6hcuGFOU2N2eaJSmnRyxG4Ww2onJW9w4rRYWnDdKDV799+Arp9dpdogbSHhfg6MP4T
	rB8KhwISTBW1I+tvw5E=
X-Received: by 2002:a2e:be08:0:b0:38b:dd55:b71 with SMTP id
 38308e7fff4ca-396d2a6e020mr9460151fa.20.1780675385674; Fri, 05 Jun 2026
 09:03:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260605122019.24146-1-ddiss@suse.de> <20260605122019.24146-2-ddiss@suse.de>
In-Reply-To: <20260605122019.24146-2-ddiss@suse.de>
From: Lee Duncan <lduncan@suse.com>
Date: Fri, 5 Jun 2026 09:02:54 -0700
X-Gm-Features: AVVi8Cf3Wv1cD6ibsG8ebHzwmFjyXOlkEFG9AwMz2g1A6Wf5XPKkHpRYsroR4vs
Message-ID: <CAPj3X_VQerGwtz2MheM9ESFe9KpZHAsy2UceADTHgJeEekyU9A@mail.gmail.com>
Subject: Re: [PATCH 1/2] scsi: target: fix hexadecimal CHAP_I handling
To: David Disseldorp <ddiss@suse.de>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 5, 2026 at 5:37=E2=80=AFAM David Disseldorp <ddiss@suse.de> wro=
te:
>
> A mutual CHAP handshake requires target processing of an initiator-sent
> CHAP_I identifier. The RFC 3720 specification states:
>
>   11.1.4.  Challenge Handshake Authentication Protocol (CHAP)
>   ...
>   CHAP_A=3D<A> CHAP_I=3D<I> CHAP_C=3D<C>
>   ...
>   Where N, (A,A1,A2), I, C, and R are (correspondingly) the Name,
>   Algorithm, Identifier, Challenge, and Response as defined in
>   [RFC1994], N is a text string, A,A1,A2, and I are numbers
>
> CHAP_I parsing currently calls extract_param(), which returns the
> @identifier string (stripped of any 0b/0B or 0x/0X prefix) and a
> @type which indicates DECIMAL, HEX or BASE64 encoding (based on any
> stripped prefix).
>
> Any HEX encoded CHAP_I string is further processed via:
>   ret =3D kstrtoul(&identifier[2], 0, &id);
> This is incorrect for two reasons:
> * The @identifier string has already been stripped of the 0x/0X prefix,
>   so skipping the first two bytes omits part of the number.
> * The kstrtoul() call specifies a base of 0, which will see
>   &identifier[2] parsed as a decimal, unless a '0x' or (octal) '0' is
>   erroneously present at that offset.
>
> Fix this by passing the (zero-offset) identifier string to kstrtoul()
> along with a base=3D16 parameter. Also add an explicit error handler for
> BASE64 encoding.
>
> Hex-encoded CHAP_I handling can be testing using the libiscsi EncodedI
> test linked below.
>
> Reported-by: Sashiko (gemini/gemini-3.1-pro-preview)
> Link: https://sashiko.dev/#/patchset/20260521151121.808477-1-hossu.alexan=
dru%40gmail.com
> Link: https://github.com/sahlberg/libiscsi/pull/473
> Fixes: c3fb804c12bad ("scsi: target: fix hexadecimal CHAP_I handling")
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> ---
>  drivers/target/iscsi/iscsi_target_auth.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/is=
csi/iscsi_target_auth.c
> index a3ad2d244dbee..5858cc3089796 100644
> --- a/drivers/target/iscsi/iscsi_target_auth.c
> +++ b/drivers/target/iscsi/iscsi_target_auth.c
> @@ -438,9 +438,11 @@ static int chap_server_compute_hash(
>         }
>
>         if (type =3D=3D HEX)
> -               ret =3D kstrtoul(&identifier[2], 0, &id);
> +               ret =3D kstrtoul(identifier, 16, &id);
> +       else if (type =3D=3D DECIMAL)
> +               ret =3D kstrtoul(identifier, 10, &id);
>         else
> -               ret =3D kstrtoul(identifier, 0, &id);
> +               ret =3D -EINVAL;
>
>         if (ret < 0) {
>                 pr_err("kstrtoul() failed for CHAP identifier: %d\n", ret=
);
> --
> 2.51.0
>
>

Reviewed-by: Lee Duncan <lduncan@suse.com>
