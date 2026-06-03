Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305D63DA5B4
	for <target-devel@vger.kernel.org>; Wed,  3 Jun 2026 16:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780504272; cv=pass; b=LxP0XDWLFEr9Ii+TxuTpvb7r3Tgpxjuk+fGh2TlxSWCl9LC85zndnqW/60uS267x5Q1tm5L3/ACqYWirJaoOb6uZ8IsmWpReXysxbOFpZgzNiuDCGj7SvIZltK+Jx+FjFdujbJ3vtrp4VfrDKcBPsvOSniSDC1//f3hArlaaU9o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780504272; c=relaxed/simple;
	bh=GDbsJcs2QiLywbucMnh0d/gAmgm1aQxoL7ban/WLVQI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qa6oAQnNNkZvUgOPrT/4/mVe/vTxQC8qk7yn6HllZNSvmBs1Q4qbRgUOBaipIxdVL3IjlwX7xDIoIBtYPDMujmEYoxQHX8TcgRt6UxdOfoWYC9t+mkW2M1bRq4mPJZpOb4WqCd0TxJx+3BCeb3QIOX0uD8GnPQyv6fEsC2PXpFA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gvIrX0ng; arc=pass smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gvIrX0ng"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-39669bcaadfso41506961fa.0
        for <target-devel@vger.kernel.org>; Wed, 03 Jun 2026 09:31:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780504269; cv=none;
        d=google.com; s=arc-20240605;
        b=SWClKwv/InMhaOg/HI1ndVaumjGag39ugV22OpF9e+lNCsJWgYmd91+hNneS8df7ss
         WY6NPy9ycxJ1iJb6dIj/D2iwTUZQ5MXlOTzkFVgV9PXtUCTUSAx9e9aDL99tVVSHdQ/g
         RbN2aZifZL+t9Q6SACRz76awMjVEpt38bA4hOpF5f2k3JNaDoe7X44vAwajfs7Mo2ySx
         7i/qMTjOqXlmtyqhXAupCrfIHKtAlDJVgEjnXIhi2igMA1gCQxXRRD2WV0tePCRDKLuS
         LaXCd18GmD3banmC15xi+Y1kmg7O7kmU9+3RfNMruToPSycHTP3aNmmpFQPXKGR/0cyH
         c2Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sxfSZaF8do2hQPd38ry8GeKt7hfM6jV9CMwJ030Ibpc=;
        fh=5L1ZzOsHCl6Nkb2+73kD07AsEzmb4eiG1oVW/sXaUko=;
        b=Tj3jEJ/829aBJxbWGu5kpWiR4ia74zMN8lFALqkxbIRPPFOe3EQMEh07GnkhwSzrdi
         Vy6TcrnBDXLlLQYLk8GWjrpuMfpYA9kCu0Mi8lU0S2k/A8uHuozy1iPNiddMvbYck+Nq
         pimCH9nP3S4tZxU3x8gVWI4ADyD4fRCzmqreNyZQojO6wJOIRWFkaUS8dYL8R773oIW9
         nm9TZ9jv6OqK6jqg0oBCKHjWQ+fV2gh6NGJ42H/EZR/YobzBWmnh3m4YuuMEeWKutnu9
         QzTulYzjpMRaBKtYZq2GCM5K8Y6UWsmX42Xmf1OftcgvBnSbJLT7VSxe7YpH9nRSrDqY
         WeVw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780504269; x=1781109069; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sxfSZaF8do2hQPd38ry8GeKt7hfM6jV9CMwJ030Ibpc=;
        b=gvIrX0ngerlepkqsb0tNKAo01NeEIhSGyCUDWunpHFcfkpQ+ITWr3T+h9/OsYLV54E
         EKJjXVmOcIwzUWiCTV8pjTQ6jouHNwzlBMlvqUoTZ5bgb8u5G73lSn6FPTsxQapBHznS
         fZsHguNEtHtFs+NlqDEBRqx7PTP2e7sXqYHwAeBsoEqvj1vKTTjm3PhFNBTDTkQh5b+I
         MvCUHT31W1qLwEo3Jn4MlkwwgSoRmQkq/vG/pxs6ZPiug2U0iNmylnhOrFBkSJ8oBgPi
         ivAIUFvy26fwb/RmJqBMf4c9sS+4/HflNuvu5AO/A/ezyQ3PWaBQ0E9Cj7/7PiAYgbPG
         kbkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780504269; x=1781109069;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sxfSZaF8do2hQPd38ry8GeKt7hfM6jV9CMwJ030Ibpc=;
        b=hIp6g1wQZrY8LZBsORRXSM6jsYv+ez/bgu1lDEWAFYbLzEnhj7f31hlT4f3UGWhbVe
         lu32A32QAj+ih9mZkMaS82xSq77LUlPtsTWZKKKUmj50AXg7RHwwaw8G2OL5WXsEAWgQ
         5SZ4uME0Uy2IRx4AkPTN42C8tILfW5Q/q7+vCyZyaRvlGc2Z8zpDNX93/xWAlTk4rrRc
         p/mkvb798Ua2PQm/wpRfW0akixrYWhUrTyHw0EBVOHrR8wEWpUZl6fZv6pRRurikTA8y
         Ym7VxDlv/X/fuPHarsScjtEJmTQ413dEfMu/mmbLgz0tIeriCN8pv4utL3SL/FsOLK/c
         jQ/Q==
X-Gm-Message-State: AOJu0YxrKbYyLWmJDzKZuUaA/O9K5C6C9TEKSiVkggMb5q5zcVMA/BiD
	4w0/xjUhe8NnYH9d+Kf9mtbPFSVB/9BD7zSCwdSqjZBAdrFzaHwcOAgLyiLo9tPSGJsVITyQUN4
	zLOo6hJju5UE9Aj/Rb7AqAp04RLn7fGDS8XC0/z2rZw==
X-Gm-Gg: Acq92OGmIzTcApp5Oq0HUETV1gKtfEJAm+iUEQr09E1Jt8QerWvw+RfDy/ziPiK+r2y
	czlPBI33dCJ1SkX266jyuJeS0oXRy9ChepoG0Spi22LeD1AkqQloWxnroyZfhHEdNPGU8EnHerY
	XFCQ3C2aphomd4P3L1FXQ14QLWpOl/Z0OdIw3bmMtxzin+NJX3TAii72YhKTaZytorshokk4npX
	H+OjEzrRAInEVoiubxfwF6AIZTPXG2pPOqBdBLlXDd4wjTrgfxaRf09x4roGMdvdJazBEPQZulC
	Nf92izDfyss4V8Q6iWZxOiZjDNicJg==
X-Received: by 2002:a05:651c:150d:b0:396:7b8a:3da0 with SMTP id
 38308e7fff4ca-396af4d5d09mr14505761fa.26.1780504269294; Wed, 03 Jun 2026
 09:31:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260602115840.26490-1-ddiss@suse.de> <20260602115840.26490-2-ddiss@suse.de>
In-Reply-To: <20260602115840.26490-2-ddiss@suse.de>
From: Lee Duncan <lduncan@suse.com>
Date: Wed, 3 Jun 2026 09:30:57 -0700
X-Gm-Features: AVHnY4L4u7qOl5tCuqk9eSOmN2pRIjr0SC76D06SccNBNg_xh7kuL7DKkW_MY1E
Message-ID: <CAPj3X_XbHq3W0yozq6LWMom-m2jcWeGiwK=cbJKyns9UXEFeog@mail.gmail.com>
Subject: Re: [PATCH 1/2] scsi: target: add extract_param_str() helper
To: David Disseldorp <ddiss@suse.de>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 2, 2026 at 5:04=E2=80=AFAM David Disseldorp <ddiss@suse.de> wro=
te:
>
> The existing extract_param() helper, detects and strips any hex (0x/0X)
> or base64 (0b/0B). This makes sense for some parameters, but not strings
> such as CHAP_N.
>
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> ---
>  drivers/target/iscsi/iscsi_target_nego.c | 37 ++++++++++++++++++++++++
>  drivers/target/iscsi/iscsi_target_nego.h |  1 +
>  2 files changed, 38 insertions(+)
>
> diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/is=
csi/iscsi_target_nego.c
> index b03ed154ca34e..53b17d3cc86c3 100644
> --- a/drivers/target/iscsi/iscsi_target_nego.c
> +++ b/drivers/target/iscsi/iscsi_target_nego.c
> @@ -98,6 +98,43 @@ int extract_param(
>         return 0;
>  }
>
> +/* same as extract_param() above, but don't interpret any type-prefix */
> +int extract_param_str(
> +       const char *in_buf,
> +       const char *pattern,
> +       unsigned int max_length,
> +       char *out_buf)
> +{
> +       char *ptr;
> +       int len;
> +
> +       if (!in_buf || !pattern || !out_buf)
> +               return -EINVAL;
> +
> +       ptr =3D strstr(in_buf, pattern);
> +       if (!ptr)
> +               return -ENOENT;
> +
> +       ptr =3D strstr(ptr, "=3D");
> +       if (!ptr)
> +               return -EINVAL;
> +
> +       ptr +=3D 1;
> +       len =3D strlen_semi(ptr);
> +       if (len < 0)
> +               return -EINVAL;
> +
> +       if (len >=3D max_length) {
> +               pr_err("Length of input: %d exceeds max_length:"
> +                       " %d\n", len, max_length);
> +               return -EINVAL;
> +       }
> +       memcpy(out_buf, ptr, len);
> +       out_buf[len] =3D '\0';
> +
> +       return 0;
> +}
> +
>  static struct iscsi_node_auth *iscsi_get_node_auth(struct iscsit_conn *c=
onn)
>  {
>         struct iscsi_portal_group *tpg;
> diff --git a/drivers/target/iscsi/iscsi_target_nego.h b/drivers/target/is=
csi/iscsi_target_nego.h
> index e60a46d348352..6b72edd2aef2e 100644
> --- a/drivers/target/iscsi/iscsi_target_nego.h
> +++ b/drivers/target/iscsi/iscsi_target_nego.h
> @@ -13,6 +13,7 @@ struct iscsi_np;
>  extern void convert_null_to_semi(char *, int);
>  extern int extract_param(const char *, const char *, unsigned int, char =
*,
>                 unsigned char *);
> +extern int extract_param_str(const char *, const char *, unsigned int, c=
har *);
>  extern int iscsi_target_check_login_request(struct iscsit_conn *,
>                 struct iscsi_login *);
>  extern int iscsi_target_locate_portal(struct iscsi_np *, struct iscsit_c=
onn *,
> --
> 2.51.0
>
>

Reviewed-by: Lee Duncan <lduncan@suse.com>
