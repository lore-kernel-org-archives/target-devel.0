Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECEE37DEAA
	for <target-devel@vger.kernel.org>; Fri,  5 Jun 2026 16:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780675489; cv=pass; b=eHHOdDMJdxgKrFFTBQOacqSZWE7xV3tV+oQKobwBfX7Tv5co0JKfAaHlvAyvdxrasRxlfOtDgitI5x0I8rQdVEfY7rFNtFjyCqTXjef6W8efi2w2FbDCJ6/Y5l7Nz7l3xkPFZif0vrb3fnWP2Ft9Cm8jWUmEjSVkuAjuSO1uDt0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780675489; c=relaxed/simple;
	bh=LG8J/R+2eufDNwIl81kPJGrTs5zv+E3jtTsi0TpUf2Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I0vPI+l6n8YST62Cxq/O8L7TCJIveBI127NqlPlpO5ZM37J7NIoOzgEUsgu9Vpj0g65VAK7X8bCOOcLuDM1LdyraLLWXSskUKFs+kE3t1wDSBrpS1vC4grNhK1kFF2WJL7mvbhSMy3svrWRkM8QxX/W13NpnVMw2I5THuOS4QAc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Cv8Lu6JC; arc=pass smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Cv8Lu6JC"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-3967725a77fso21476711fa.1
        for <target-devel@vger.kernel.org>; Fri, 05 Jun 2026 09:04:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780675486; cv=none;
        d=google.com; s=arc-20240605;
        b=h+f5FLvpMlj61BEeifyXnuWs7uYF+vhDJv5OiTQJOTfv2tXPvFbjY7WVDlicTLkdR3
         xg/dmEEbQzlLT+QYyQO5EklJ09zJTpGwPn7IVkE0/8mmtlrFkA9jR4Wm4svzLsGE0A92
         re+DwewMR3567tC+OvpYxZIKSdGn1e4BOXwDhv5l/rOYAfaHsJiykLn3OjhI6vbe998B
         OP1kGD6UUIMvz8hWffPIAGNRvY5VeXpweO8SwZf0YkpQjHiBbMQGkV1nG02QJJe0bJTV
         vDS9LM6AXxXLtUKUMhNgMqIa/5GW8JbLM76xkuDXGpeWMFf84mmPEsetw58EGcg1glhM
         bomg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Vm/ss87izqfP/0U05LwE7pPzc4bfkP4ilQm2LP62OvM=;
        fh=5L1ZzOsHCl6Nkb2+73kD07AsEzmb4eiG1oVW/sXaUko=;
        b=WkkEbambMsOtde2MPmPj+DzPW2o61ZsFOnd/zK5KK7R0AZXjGVCb6Pi2YjT4S17uqB
         sdQ7C79IN0WG9yBF0tSki26hYxriHBRNp/yBONFuYc8II7pqOoRZizAHlwovfMm9uvFp
         L64A6kZY2j48m+GXgHVZMCsySHBX4jhmvogPp0ydfUOq/00ARykcPZsULBiiPZdS4Bwl
         kD64KKAQTXdcHmAbWGWEi6hNpdESec2kQAzwrOVfz1WTZggEIt2mXZ3nYQi/iJAnzDaR
         0hG+X8fzdcYhjCFRaJDpsosA1SzEJZysaKJ+CIJ/4Sxb2N8tKxPlAMQyEd1itJiXYbJD
         2fjA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780675486; x=1781280286; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vm/ss87izqfP/0U05LwE7pPzc4bfkP4ilQm2LP62OvM=;
        b=Cv8Lu6JC5XtyxQIsfqjw9APdSzUn3k3L0GM3Fs3LxCqwoDc5s+poIN7gKPHR4G0NUK
         ZzdnM9l8Gl/JJaV4RecX2IPwVXqOIAsMuDtE/5v5mrbqqBR736sZMZZAr9YYyQf2zXJY
         AtFLp5ghh6O+zoSqJdVwXSr1caC9A38Pd+A/HAsUNoJfbBMAwscra6t1LwD+JWVrqqjl
         BVRe12xPmEVB3848m5fqVuCeC+J39Fx6VcOv5Jp6fir3p1eTIdg29zBnF9bW/FFgHsXi
         4Omk3p+ewDYOf8VZL0ZG3lX481gL+i1a04g9GLZ7a9n2YduAvkSBkbPISfIpdPpGNoGk
         vuKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780675486; x=1781280286;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Vm/ss87izqfP/0U05LwE7pPzc4bfkP4ilQm2LP62OvM=;
        b=eFp24B4hN44iGeWuCVT2DbbtzRNVuMaGBcL+6zULSGc51P9bz6kDXipjD1wAx61lm1
         dcgMp7GtVt+2rJcBH9FCrXtzdRTDN9MECnUkzib+iIGr6SaZ1VV6IWhHxOWv3QU74ipy
         2pitzk/ZpZnXJEI5EgrGwHeni/Fd851LRY3rG15m7BDHRJXU7nQnixipwFIG/q7OB4Xt
         dPK6IR29/+z4OZSs5d16MegFCWUyHtClP51gT3A6VOP7d9/yo1TZEJLqYGSQBOJhAdK1
         B1VFcFEPKAUmEPF875E5crfvlyVFaCnmKQZxBzpxV3xJRmf6TJ22GAsJYUYAG1U1hZrT
         pOFQ==
X-Gm-Message-State: AOJu0Yzk1x/iQBgFfbKVVPzHAm/mN+cd1z6Q8Rz6zS6hvsvL+zKvxHmQ
	zKjnz9qSyJ12rfdAzefIIuNokcErOVVN4UeucFGmUUWfB2jdBapZElmQK0LLrAwBJ9n/7RwYYTS
	AcfuV+oFDo0eeS6UKO7xZEiP5C05IS4G6w0cCbRUh4A==
X-Gm-Gg: Acq92OEBbo6/y6O5AxRSbT5i/6WXPq7njN+0+X15HPko2lNn4C29Pr/siJjqRfDiEtd
	wCxsOQqWlrT6+wdU7Rk0Sf0vUUF/RZumiIlxjyKYmTzB/a6ghXo7FQMttypNgcTgjmHvE+QcTdi
	+Z6da+JU/3rWep6Ft+kWARkKBqwmWE70civB2yBgkAsB6qGvUQFdD4/9vx2TdBgJofcWE66zW8V
	vqhRRJd+Dj6UqjBfi7OSE4YcKDDi+nfKGVMtbzEX4Pc6IolX+HlYgaJx1+tIF4HB1/JLoMfgW4w
	R6UOuIJX16VQ00rPwcU=
X-Received: by 2002:a05:651c:2226:b0:396:6bd5:a9c9 with SMTP id
 38308e7fff4ca-396d0951cc0mr13180741fa.20.1780675486192; Fri, 05 Jun 2026
 09:04:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260605122019.24146-1-ddiss@suse.de> <20260605122019.24146-3-ddiss@suse.de>
In-Reply-To: <20260605122019.24146-3-ddiss@suse.de>
From: Lee Duncan <lduncan@suse.com>
Date: Fri, 5 Jun 2026 09:04:34 -0700
X-Gm-Features: AVVi8CcJBFVxH8_a3drKGpbHpoIuI2zt32jQkrprudoFvbnSYf69bqjmgG0S-LM
Message-ID: <CAPj3X_WHMQZTZ7UBv99_H5Gv8UVxcKzgdzW2OWv+ez2ocwfp_g@mail.gmail.com>
Subject: Re: [PATCH 2/2] scsi: target: use constant-time crypto_memneq for
 CHAP digests
To: David Disseldorp <ddiss@suse.de>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 5, 2026 at 5:32=E2=80=AFAM David Disseldorp <ddiss@suse.de> wro=
te:
>
> A constant-time memory comparison is more suitable than plain memcmp()
> for authentication digest comparison.
> CHAP digests use an authenticator-provided random challenge, so any
> timing side-channel shouldn't be easily exploitable.
>
> Reported-by: Sashiko (gemini/gemini-3.1-pro-preview)
> Link: https://sashiko.dev/#/patchset/20260521151121.808477-1-hossu.alexan=
dru%40gmail.com
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> ---
>  drivers/target/iscsi/iscsi_target_auth.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/is=
csi/iscsi_target_auth.c
> index 5858cc3089796..f3c0cdd318300 100644
> --- a/drivers/target/iscsi/iscsi_target_auth.c
> +++ b/drivers/target/iscsi/iscsi_target_auth.c
> @@ -9,6 +9,7 @@
>   ***********************************************************************=
*******/
>
>  #include <crypto/hash.h>
> +#include <crypto/utils.h>
>  #include <linux/kernel.h>
>  #include <linux/string.h>
>  #include <linux/err.h>
> @@ -408,7 +409,7 @@ static int chap_server_compute_hash(
>         pr_debug("[server] %s Server Digest: %s\n",
>                 chap->digest_name, response);
>
> -       if (memcmp(server_digest, client_digest, chap->digest_size) !=3D =
0) {
> +       if (crypto_memneq(server_digest, client_digest, chap->digest_size=
)) {
>                 pr_debug("[server] %s Digests do not match!\n\n",
>                         chap->digest_name);
>                 goto out;
> --
> 2.51.0
>
>

Reviewed-by: Lee Duncan <lduncan@suse.com>
