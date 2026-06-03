Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AFDF43637A
	for <target-devel@vger.kernel.org>; Wed,  3 Jun 2026 16:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780504235; cv=pass; b=MIKv4EpXMtmkL0d+eE6dwLIVrPAqt1fHMuGEw3tRdZbp50y6AfPCS5rh8OCspZVpQgKhvjVbtDoFgt6t5sbkXJK73hP3f5HWJqho+ZVqV/rnDlt60KZUTUU5tMonlV5VevaPv8KHvlR1qw8MqVj3eHekGXNmZV5pBWaoWxFjGdk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780504235; c=relaxed/simple;
	bh=MGjyHAboyvKunuPMYx+1O58h1Rnay/E34EqctC7+rsc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BFZuGmyCLGd1/Yvt+8sUxoi3z7PsPTPK1fdlnnQYcrQx7ByX4LTAH/ieslV5WTsI2Di6Cq0rGtHD4QBH88AbubP/0ITNvrglOY+NcKkr3cVjJm6NLyIoTJFnSI4+k7pOuVWLYmo1ktgbC74igvABdwS2icjjR//5r/y/l9E8MDw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=CG5dssQO; arc=pass smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="CG5dssQO"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-39661f81eacso11735951fa.0
        for <target-devel@vger.kernel.org>; Wed, 03 Jun 2026 09:30:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780504232; cv=none;
        d=google.com; s=arc-20240605;
        b=Z0MmXfe9jpNLMFGjdtfEw3DkfzDGhSErndR/nKv6ljYgUAGPmyG90z/I+OUd0SV+jj
         RXCAnIR2CLGCX2Mhejde7OhZSgdA7TSrkLvViBcIwpqbgyor3YinDVQ3MXHYS3/jJQoQ
         IBMpKfWjwF1zHkwODgNMjkItdMQu2F8JHlP3t734v1n8W7Cp3Aw9iEXowghagGgb+qXq
         KXBr9joVTR97FhiIkDkBdT7GMFeiQCqGlVQ4ps0jZ2tbZ5OTH5+7tOvE5u+3vyY8AWCn
         xCKTJtT/oCNsmylwymb7TmTRjP/pl4B9jiJCF1D2s+2sm8SwQ6bFzkL4pgR3hcuyAWxI
         jeGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XoEOVYrB6znHXj9h4Z3nSLM94MZ4hDg42P6x3cwnbBU=;
        fh=5L1ZzOsHCl6Nkb2+73kD07AsEzmb4eiG1oVW/sXaUko=;
        b=iFPO8UQQtCFVe50eemRJsLSxlAs6T+7ayc2Wjcz930+C9bBFlcgakYpGDCezwssPXu
         gubyDfMiGDBipUOE4zAB+F7R/SQxci6ghMgxyh9/LbbCfXPHA78tUY3a2fT/0LwoSLIC
         NjQi4k5SyIssYRf6dm8BGw1fXKo9jNT3l+l1xWVccivj/Avdfi+H61On20KjJXyPEvjE
         kX0voZQFM+ghql0y7FM3ynGxp8pJrkfxUvVbmq9Ov5Buf0g5YZDkFrLFMd9qQls2eUA4
         +YhTBZknYNNh7JXpTv4MQGVo4K03HwfASPjrZMIbIjH0ZUt7LQXr6bsoq2xmBkHg68av
         sZbw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780504232; x=1781109032; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XoEOVYrB6znHXj9h4Z3nSLM94MZ4hDg42P6x3cwnbBU=;
        b=CG5dssQO0+XXNHVw8KrQr6CIpkZgYUTF8oG5Gq9SBTdFrebDZfFzGhFH/ehdishd8g
         F+Q9RX0cgVJRRifcEte+xqLugfD/rSPresdRsoxWZAZogpwAugSqNpOic0gZANlPhI8F
         1vy2PIFSlHwuJpCGKb0WHPSQPnBYWhcWzROfD+tWvSAQGzZxnF1OXgozkLBrWE5fnUrl
         1jgrSJx3uJtsEEf5RxL6kLuK71XH4qNUvFtrhkQysa849JzOwlw35RGLk/Ebt9JRBAWJ
         +tdL8fCpG1OJ9cUKATwwPcquby2rF20Nj+Ub/8TWZC0QdPw6IDLe/+zXfa6DrYN9Er1X
         DTBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780504232; x=1781109032;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XoEOVYrB6znHXj9h4Z3nSLM94MZ4hDg42P6x3cwnbBU=;
        b=dqUaMHA/R8KOooZKVXwUwBz3hDaNDVYpdPO5AUIwSHCos3GTsoA7Ob9R5cfmYsaFe3
         x1y9/+zCtIIZUO73kVFVPsietAu+frl3n5B33TxsuVo5KXcDZ+K9iYRvoEjRO064oD6D
         hLbzKdzAtshdEDFY7nuXtWTXnC8U0s8rlwx0UPdjYxD3IsvzRMb/R5mmBAdiVMgjr0se
         4Y5ZjAvdfA/F+Zj6KZoYgppGzSRihX6s+IncjJiTXpLcKl3N6fJ8PqgTUf1dCFjbMel5
         hD5sVT0kX+fKx9BGcr82oGLsMXzwOvL3bIwnLDs2NfmxJqSNWqAN87mDtUf+zZSkcjhM
         nB3Q==
X-Gm-Message-State: AOJu0YwNm/f0iJzqx2NwLhnu7UnBNpVKR24G06hH3oekf2itXP80b4Fv
	Y6lzufXFmvqOKjvGosuSsRhdZlO86tTmHBp2DkT5G5eXYq+kB8/vzAYb0Mu/T8gr0VEZ/4ulGwQ
	wdt+IHWPjRgQlhVOYVgOak93xK8zmzRHDgBtcyorQIjiUhQRV1xRmQ1Y=
X-Gm-Gg: Acq92OE3ykyjpxUtvrJ8kyTJ7n8FJqcio6hmjAa2GndLt6hmv9a1mibv/0wDBvsW7z/
	1upPDO7/IB4ch/1AWsgg1+3rTji/89VOTaM2m75/rCvDrOK6znjlVvUtR8MkzI4/Lb8hoN283qw
	0U8fQrC/sPsv0wqeTtmBvdWqu5gypGhqzdTRMsV5BqBZOjpxHzFs/qmmuL/jgvCShquSyfBnrDf
	5SAHqHYFupKA8ZfIQrvwx61xRx72PLePojtHEqD+geCirH8wnx31+8IFiiOPGKR093TNr6Gqh3e
	FcIDKXmtaY4edNy0DRfstMTSdktLaQ==
X-Received: by 2002:a05:651c:2115:b0:396:711a:dcb9 with SMTP id
 38308e7fff4ca-396bbaeee4dmr312821fa.16.1780504231815; Wed, 03 Jun 2026
 09:30:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260602115840.26490-1-ddiss@suse.de> <20260602115840.26490-3-ddiss@suse.de>
In-Reply-To: <20260602115840.26490-3-ddiss@suse.de>
From: Lee Duncan <lduncan@suse.com>
Date: Wed, 3 Jun 2026 09:30:20 -0700
X-Gm-Features: AVHnY4K8fEmdPNDZXjCK3g-EVU3HYTqV94mC9U4cLBGZG90M1vb2BXJytEjQwC0
Message-ID: <CAPj3X_U11zY5yHEw6xE4AET2zSzhG+EXRuWH0cKHKwgG+Hz1Uw@mail.gmail.com>
Subject: Re: [PATCH 2/2] scsi: target: fix auth when CHAP_N carries a hex/b64 prefix
To: David Disseldorp <ddiss@suse.de>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 2, 2026 at 5:04=E2=80=AFAM David Disseldorp <ddiss@suse.de> wro=
te:
>
> Attempting to authenticate using a CHAP username with a '0x' or '0b'
> prefix currently fails. This is due to extract_param()'s behaviour of
> stripping these prefixes, and the subsequent (type =3D=3D HEX) error-path=
.
> I believe this behaviour is contrary to the RFC 3720 specification,
> which states:
>
>   5.1.  Text Format
>   ...
>   text-value: A string of zero or more characters that consist of
>   letters, digits, dot, minus, plus, commercial at, underscore,
>   slash, left bracket, right bracket, or colon.
>
>   11.1.4.  Challenge Handshake Authentication Protocol (CHAP)
>   ...
>     CHAP_A=3D<A> CHAP_I=3D<I> CHAP_C=3D<C>
>
>    Where A is one of A1,A2... that were proposed by the initiator.
>
>    In the third step, the initiator MUST continue with:
>
>       CHAP_N=3D<N> CHAP_R=3D<R>
>    ...
>    Where N, (A,A1,A2), I, C, and R are (correspondingly) the Name,
>    Algorithm, Identifier, Challenge, and Response as defined in
>    [RFC1994], N is a text string, A,A1,A2, and I are numbers, and C and
>    R are large-binary-values ...
>
> "N is a text string" implies that any hex or base64 encoding prefix
> should not be interpreted or stripped. Fix this by using the new
> extract_param_str() helper function to obtain the CHAP_N value as-is.
>
> Reported-by: Sashiko (gemini/gemini-3.1-pro-preview)
> Link: https://sashiko.dev/#/patchset/20260521151121.808477-1-hossu.alexan=
dru%40gmail.com
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> ---
>  drivers/target/iscsi/iscsi_target_auth.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/is=
csi/iscsi_target_auth.c
> index a3ad2d244dbee..6f21075e58416 100644
> --- a/drivers/target/iscsi/iscsi_target_auth.c
> +++ b/drivers/target/iscsi/iscsi_target_auth.c
> @@ -303,12 +303,8 @@ static int chap_server_compute_hash(
>         /*
>          * Extract CHAP_N.
>          */
> -       if (extract_param(nr_in_ptr, "CHAP_N", MAX_CHAP_N_SIZE, chap_n,
> -                               &type) < 0) {
> -               pr_err("Could not find CHAP_N.\n");
> -               goto out;
> -       }
> -       if (type =3D=3D HEX) {
> +       ret =3D extract_param_str(nr_in_ptr, "CHAP_N", MAX_CHAP_N_SIZE, c=
hap_n);
> +       if (ret < 0) {
>                 pr_err("Could not find CHAP_N.\n");
>                 goto out;
>         }
> --
> 2.51.0
>
>

Reviewed-by: Lee Duncan <lduncan@suse.com>
