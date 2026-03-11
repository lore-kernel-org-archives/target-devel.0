Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C59331203
	for <target-devel@vger.kernel.org>; Wed, 11 Mar 2026 14:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773238321; cv=none; b=R1CAn1kvR4fLRqYuLnsXgHIX0by3QJRM0eUA2QjVfHqdE37snUcDxzQ7btd2Auy4W74pl+ZCP5czWnVf+ggbE8mvcuqeutMsf48YC71LuwvQT5cGUtKkvfz4oyzHZosx4RFzjQzWXW/+GsOv8lf3T8d9FkRKMla6/ZRNwOY580s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773238321; c=relaxed/simple;
	bh=POUJjzeRhBIXfPGojdZfC417KH92loTKx1KmDpRcfoc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HsZoECQxH/kn3BzO0CJOYgBkXGgmQUI+2+X6+ZMip5nQ+76aAx0PuSAEwULd1vGs7efM4CHLyeVdHv3819QQs4MBBY8WHpbqxSkm0ljwt6XFWtgMifpUl4KA9AfjATcJFl+mzbgKlIMwtQjMn69NFtJdAGTBayCuWpjsmGx6Pfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-66174cf4549so2112362a12.0
        for <target-devel@vger.kernel.org>; Wed, 11 Mar 2026 07:12:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773238318; x=1773843118;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wIz9Fr5w5J45ZN4rxwvT/0kjXMGfLP1VpB2aKPOax7k=;
        b=B2u75ycu5VOw2Ma9XODp6uyDb1TaP6TmV4e19LAo7phRdLqk7eu91pG1RbPDzeBCev
         cv+23XxdKKu38yMlkcZdldUcr9qbq5e/9WweDlowPppIeijg0hCuzYyMPkjZMeIJnSrG
         DVmW8M5GFPtuD9v2ygck//O0D1I6II8ccSyrJM+vGZxkBfwsD+XsVA5svxWqD3b9z7R/
         dQkIbdI4gY1PTPuiDAkcp42B6VnFZxwZfC7Vll9pnZL1XjjYZU1Jc+E+ajWMKrdDDt2L
         z8FZc6ZS8sGAfro04XSmoi3lm9v0oQLsOZU6WmkoQXTU2PnkfRhY7w6zQZJ3DjgBQKxw
         BWyg==
X-Forwarded-Encrypted: i=1; AJvYcCXnX5XO69Z0Z+qCOHRWbs4iIRwIGP+ab0XRJzdSn2vaIERHAkU7flvqQWg0/xINz4bA/Wnl4AJTAb/bkKw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3Lvd0MSUBsDDjNR7QLVs9JSYpd3LM6t1U1KStxxz6drHdfyKC
	ZsC5cqdTiBwqtRmBFNjuhmJcevMbnodBZTmbE/vxqUSBN8GZFHjJPOMJbPIwiwmJBhLIkg==
X-Gm-Gg: ATEYQzzwj6DkAMM7ZDo+0xQfUnzBeUenVnL+VVoKaZzMHZjupCQUJwowPiuzgIRsWtt
	omJ55U0qHDBPYnql6HDKchEVBSnVSnevEbdRBwH8Rc4RSO6Z/v2Fi4QVHsnbwr0IqF1IOxPuZdL
	Y7Kz/JvKdkWrOO98vPaEhRItRpXrbbi6Nzj4YDKmukRVC1MzkEdRrIg4y5tRQ/CbZzn+3xVLGeu
	2BBtWzHqt6UKiIR3BNZx3ywguhRRBAgS6RlpkuC9FaVHRlQmOe4jn5ee8v3NNxukI6Z0KIiJMv1
	g9fw5HBMcQIIGPW48UDOsl9ImGxq6vpU7QOJLyGOiO7MCxXNeCTwCBPtjXqP2gVkf2EdB3RtCmF
	W3Y98AZjGNEx+ySlODINGmVBbbH3y78DUdmp2UC+9QtR0PRWkQK9TPHEvI2t91TZif6/aahwhN1
	E7xp/s0/+LxHmLswmk+S16jrcZOift6dygz4hnLBA0g/1PWrz1W0+SItNPiBdo
X-Received: by 2002:a05:6402:a2cf:10b0:649:19bf:bba1 with SMTP id 4fb4d7f45d1cf-662ba944685mr3091571a12.17.1773238318371;
        Wed, 11 Mar 2026 07:11:58 -0700 (PDT)
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com. [209.85.218.43])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6631419b1fdsm567020a12.4.2026.03.11.07.11.57
        for <target-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2026 07:11:57 -0700 (PDT)
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b942b36de08so190361666b.1
        for <target-devel@vger.kernel.org>; Wed, 11 Mar 2026 07:11:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU0eV9DWc9H0AhqECmN8twXoAmhLhPjmRbJzAQ5XbrELFgol/qnRuJDR8W2VDVLgxgvBKfQX90Mw11xml4=@vger.kernel.org
X-Received: by 2002:a17:907:6d16:b0:b88:4f25:81da with SMTP id
 a640c23a62f3a-b97113ff0b9mr462021166b.0.1773237981235; Wed, 11 Mar 2026
 07:06:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
 <20260310-b4-is_err_or_null-v1-15-bd63b656022d@avm.de> <20260310100750.303af303@gandalf.local.home>
 <20260311141332.b611237d36b61b2409e66cb3@kernel.org> <20260311100332.6a2ce4b1@gandalf.local.home>
In-Reply-To: <20260311100332.6a2ce4b1@gandalf.local.home>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 11 Mar 2026 15:06:07 +0100
X-Gmail-Original-Message-ID: <CAMuHMdX4kRGLaKMzPuhS1Pmxh609eiqQW-cAS_jWBBbt-vE6SA@mail.gmail.com>
X-Gm-Features: AaiRm53WEGMMLW4z34e7P-lM1qFvsCJGZ_o4JNL5NPWbhJPKmcqz6k9bJcyL--8
Message-ID: <CAMuHMdX4kRGLaKMzPuhS1Pmxh609eiqQW-cAS_jWBBbt-vE6SA@mail.gmail.com>
Subject: Re: [PATCH 15/61] trace: Prefer IS_ERR_OR_NULL over manual NULL check
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>, Philipp Hahn <phahn-oss@avm.de>, amd-gfx@lists.freedesktop.org, 
	apparmor@lists.ubuntu.com, bpf@vger.kernel.org, ceph-devel@vger.kernel.org, 
	cocci@inria.fr, dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org, 
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
	v9fs@lists.linux.dev, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset="UTF-8"

Hi Steven,

On Wed, 11 Mar 2026 at 15:03, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 11 Mar 2026 14:13:32 +0900
> Masami Hiramatsu (Google) <mhiramat@kernel.org> wrote:
>
> > Hmm, now IS_ERR_OR_NULL() is an inline function, so it is safe.
> > But if you want to use IS_ERR_OR_NULL() here, it will be better something like
> >
> > node = rhashtable_walk_next(&iter);
> > while (!IS_ERR_OR_NULL(node)) {
> >       fprobe_remove_node_in_module(mod, node, &alist);
> >       node = rhashtable_walk_next(&iter);
> > }
>
> But now you need to have a duplicate code in order to acquire "node"
>
> I think the patch just makes the code worse.

Obviously we need a new for_each_*() helper hiding all the gory internals?

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
