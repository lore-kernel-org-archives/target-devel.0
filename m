Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5789433E368
	for <target-devel@vger.kernel.org>; Wed, 11 Mar 2026 02:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773194859; cv=pass; b=o9JaDYbT0eFRlr8jNzo3efl5aEzkxK9D9HviT3nmCYC01LjNxkfpxkYofQjA49wLu71JznKmOxvqf3nZ41/vCs6gQA9qzpzNmKtSttTEP1mdhlI5U9CCWJigeRcebT3hu2Gcn7qORKJ1XC0BynRXjtYDKnc+HYyYNr7OEXlRDb0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773194859; c=relaxed/simple;
	bh=8UJnLa/DDQ+b65RDSHa97nR/Rm6zetnRjswOkVb13wc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l2g2yzZ4Dybh6kuhvcBULVguDYhdrEOCm8tFVHG5HxZiMK4r1ieV3XC7DvFbBP/+LmMwsbfu65u9ArSpCtaVdbPZteok84/rVMReHCYXmpmbYEy9zrdrliUY8eD89Ecnaq3KiIRSp5NcaBqhT+HUD7Ww+h1VR8ou9i4C8J9QSO4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=SqpOgAb4; arc=pass smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="SqpOgAb4"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5a13d1c6f25so4703795e87.3
        for <target-devel@vger.kernel.org>; Tue, 10 Mar 2026 19:07:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773194852; cv=none;
        d=google.com; s=arc-20240605;
        b=JWaxpavUUg5iAIgnVVmihSNKlAEmkdERdWf9gZSnGaCN/yfFR2PS6BBzW3LZ/vteGO
         2GPJIITeLNT6VynaO5diZXWWlAjPHwosOF0ArQkcIGlPZqhxPJjV6ATQFgA7wpXir8Tx
         u1W77r707n4e4EzX3om7D47UJbN44ZtLpkZ7CDQpednA9vBE1PY3KUCTV03ugXNVpfQG
         Lii9FERvl1uZeHtKbPTekiuUrn0RabAZ9kPz70yKLvkyOZTrG8+W5JBLYn0hxM0UmTsg
         mwjrbVCBDipQOOoCGYF96JLZp1n3LIuacPFt2Rp3xD4eTi5lODRXAzJAdcXP5bmbMi4e
         24nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+zLBLQzKjcztDlxJqoLP6w+B6xnZmfHibV4jlBQCebA=;
        fh=YclSZj0P226bwoSCYfQtFOwjGFoFNjZAMlgArBuxQDc=;
        b=ixcaS+5Fs6PlHVnoMdn4lgop0OjMcYhcb9gxtJ8Torn0QEvSfs0CCvUD13jdTAY36w
         F2wajqrFNY+4ITdANTQZZwY/5R2f71x0I7ZL8GPpz/+17jCryAQRo/uI2sBptglMKIGx
         tDc2lfVFzwaPl9OmVxyMDI7cNRucn/Q0HAH/EVSy2NbZ3/t+n9T7Gtgrpv36EssHUDhI
         L1WRk8k5SaBjyPSPIhLT9FkqbrWulwVQRy/fhp+BbXWoKJn9ibd/PxXEFBov+PorkMA2
         QAGt7W1xOWbhMTPJx/vGt4ub8jljnrFhUPQH2JAAT/CnumIotrK8WUqZKTwcbAiKhrhb
         RUkg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1773194852; x=1773799652; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+zLBLQzKjcztDlxJqoLP6w+B6xnZmfHibV4jlBQCebA=;
        b=SqpOgAb4CQOCp6QT1IhDiJXNOENCCAthmmQiQ2Xm1LqdH6AuNnr9pWEOxoaM6J2EHp
         TaZvrNsWvEAAdeAh3rGZCGLrxzU767HUy57VJt43+079ae3+2kuAr2+JBVbU8T9+l/BT
         vjjO+GANIyds0bGFgUhdgNG0FnF3NJi/nWQH4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773194852; x=1773799652;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+zLBLQzKjcztDlxJqoLP6w+B6xnZmfHibV4jlBQCebA=;
        b=IttBkceE2ngw4xBU4OlsmiO4EaPnlPWunFCX0IwlTeSaQg09YWKDCHl3xiLAs+XyWk
         lCaqZW4DTiTJAEuLvKDeqvP6dbe7+cwy93LcMSUoj2YinTl1brPjJZ3zc3encfOq0nBX
         Fr9X4y2l2FYc28UnA7SaKvSImdY4s6DGk5Tz48qVKg8fVytpnpqFd7ZogMZ86S5D1T6U
         sCbR6mvVp6M0xn2x3f1aXYYVFTJwa+j4YQaz578NzdRKJY+yBB/2QASprkwoZfAit36T
         fl+RSPvDn8v5FBBj0adZG2+nJNdV/r2EuWQAVPkeQq1PYIatAc3bWBD95FNpEC2y+nmT
         HOgw==
X-Forwarded-Encrypted: i=1; AJvYcCUHneC1QeNGF4Cd+59ikG223R4RcIsKdvn32nnWr5YJZO4LChrlJ8MaAPs9AmpPWskU87MxxfYAJpLVAXY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzhfMU7aPGytTkYHo70ZKXtUZCLJ8NVfI8u4mEdOYW8t8jCpC+5
	mBU4Z/wrUo/lhsVqF6Y4kxUj1/YD4UR6nCsTB3ySHsmCRxwBaxtxUN5T+Qumv97ct4EK0F/op3d
	CzAuBFnaMLF4iWFu35CMdRv/qqmGjITT9YeRm7SOW
X-Gm-Gg: ATEYQzx0if8KA32QtWZomzVa6DLMxOhdj/ok7DaADloPyMcYAJMxkGrR3t44p/mo8bK
	uZt/D9h4kX+0YyDSsv2wZc1Jp+8bn3yalEzsHR41+clwgN5Er02P4uYkglGl0sHgx5VZOn9/68U
	qlcTVfCGtRMBPl7Ay97mtgHwJ9k8lD3yB4doRxry0CUgiJmNMxnXSvs7TMK4KbHmFuirSm7XAJQ
	NJrOSTmxQriYZGUI2YCh+QMsGGtYAlnI9pCCotKUCeqqUlnBIa7kZzVVlXRTiEUZgw6GeUWwJh2
	ZCcytud7Yw==
X-Received: by 2002:ac2:4427:0:b0:5a1:3134:9bac with SMTP id
 2adb3069b0e04-5a156cbd1bbmr169453e87.28.1773194852284; Tue, 10 Mar 2026
 19:07:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de> <20260310-b4-is_err_or_null-v1-56-bd63b656022d@avm.de>
In-Reply-To: <20260310-b4-is_err_or_null-v1-56-bd63b656022d@avm.de>
From: Chen-Yu Tsai <wenst@chromium.org>
Date: Wed, 11 Mar 2026 11:07:21 +0900
X-Gm-Features: AaiRm5028PWt8n-JnveiRgn8oYMksdR_-_nk4JOkvxMfplWs-GDr7RRk-OxICyw
Message-ID: <CAGXv+5FQAVaJjqhv+Xq-ysOc4SHQn2mCNTgCAp8XocmWBWGGoA@mail.gmail.com>
Subject: Re: [PATCH 56/61] clk: Prefer IS_ERR_OR_NULL over manual NULL check
To: Philipp Hahn <phahn-oss@avm.de>
Cc: amd-gfx@lists.freedesktop.org, apparmor@lists.ubuntu.com, 
	bpf@vger.kernel.org, ceph-devel@vger.kernel.org, cocci@inria.fr, 
	dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org, 
	gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org, 
	intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org, 
	linux-bluetooth@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, linux-clk@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-gpio@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, linux-input@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org, 
	linux-media@vger.kernel.org, linux-mips@vger.kernel.org, linux-mm@kvack.org, 
	linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org, 
	linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org, 
	linux-phy@lists.infradead.org, linux-pm@vger.kernel.org, 
	linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org, 
	linux-sound@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
	linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org, ntfs3@lists.linux.dev, 
	samba-technical@lists.samba.org, sched-ext@lists.linux.dev, 
	target-devel@vger.kernel.org, tipc-discussion@lists.sourceforge.net, 
	v9fs@lists.linux.dev, Michael Turquette <mturquette@baylibre.com>, 
	Stephen Boyd <sboyd@kernel.org>, Daniel Lezcano <daniel.lezcano@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 10, 2026 at 9:57=E2=80=AFPM Philipp Hahn <phahn-oss@avm.de> wro=
te:
>
> Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
> check.
>
> Semantich change: Previously the code only printed the warning on error,
> but not when the pointer was NULL. Now the warning is printed in both
> cases!
>
> Change found with coccinelle.
>
> To: Michael Turquette <mturquette@baylibre.com>
> To: Stephen Boyd <sboyd@kernel.org>
> To: Daniel Lezcano <daniel.lezcano@kernel.org>
> To: Thomas Gleixner <tglx@kernel.org>
> Cc: linux-clk@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
> ---
>  drivers/clk/clk.c               | 4 ++--
>  drivers/clocksource/timer-pxa.c | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 47093cda9df32223c1120c3710261296027c4cd3..35146e3869a7dd93741d10b72=
23d4488a9216ed1 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -4558,7 +4558,7 @@ void clk_unregister(struct clk *clk)
>         unsigned long flags;
>         const struct clk_ops *ops;
>
> -       if (!clk || WARN_ON_ONCE(IS_ERR(clk)))
> +       if (WARN_ON_ONCE(IS_ERR_OR_NULL(clk)))
>                 return;
>
>         clk_debug_unregister(clk->core);
> @@ -4744,7 +4744,7 @@ void __clk_put(struct clk *clk)
>  {
>         struct module *owner;
>
> -       if (!clk || WARN_ON_ONCE(IS_ERR(clk)))
> +       if (WARN_ON_ONCE(IS_ERR_OR_NULL(clk)))

clk_get_optional() returns NULL if the clk isn't present.

Drivers would just pass this to clk_put(). Your change here would cause
this pattern to emit a very big warning.

I don't think this change should be landed.


ChenYu

>                 return;
>
>         clk_prepare_lock();
> diff --git a/drivers/clocksource/timer-pxa.c b/drivers/clocksource/timer-=
pxa.c
> index 7ad0e5adb2ffac4125c34710fc67f4b45f30331d..f65fb0b7fc318b766227e5e7a=
4c0fb08ba11c8f9 100644
> --- a/drivers/clocksource/timer-pxa.c
> +++ b/drivers/clocksource/timer-pxa.c
> @@ -218,7 +218,7 @@ void __init pxa_timer_nodt_init(int irq, void __iomem=
 *base)
>
>         timer_base =3D base;
>         clk =3D clk_get(NULL, "OSTIMER0");
> -       if (clk && !IS_ERR(clk)) {
> +       if (!IS_ERR_OR_NULL(clk)) {
>                 clk_prepare_enable(clk);
>                 pxa_timer_common_init(irq, clk_get_rate(clk));
>         } else {
>
> --
> 2.43.0
>
>
