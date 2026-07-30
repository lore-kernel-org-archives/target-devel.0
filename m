Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1BC1347FCD
	for <target-devel@vger.kernel.org>; Thu, 30 Jul 2026 01:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785376511; cv=none; b=rs4L/h+a/U7gIG27cMfdfLo1AxnQ7RgK90l6RpB47NeGSosTXnBMv5HlZuNKTOdRXgBtqURnX2I40HztMF5s086ySsAYZVYNbh/3GsMMUh0bnqt1E1XOzDOe53ps7pIZBdYPXHi7oY6lCgs08RjKKfYTdbzi8y/VGLasYNxdhSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785376511; c=relaxed/simple;
	bh=VeEYuGzNBqw7pB4OOem0F2DxkRj0GjZ8W0SA5droXS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cu2XOySbIesOd1joJ9CeNjsnb/WOFvh4E6TvTM+RAtuB8VJLjm1vXKUVk4DeGkXFkPpyomgJJp2oj7kumQdOWrAmpoUDsrlE2zBks+QG9St6+oL+YTFCzBrAy42z79bbhytgfyTKH5sC5qwyB/C+BSlt6cP2fevEY/CJ6xQHmXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=Wnge53Eh; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="Wnge53Eh"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-84847482584so182173b3a.0
        for <target-devel@vger.kernel.org>; Wed, 29 Jul 2026 18:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1785376508; x=1785981308; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VeEYuGzNBqw7pB4OOem0F2DxkRj0GjZ8W0SA5droXS8=;
        b=Wnge53EhdbKqkILElz5fl2kkSXMYaL6n8F9Om3qBRgGN8c+andpxw4US4VYdccXxl9
         MB9BAltkmbqtvI3iS7W82hYj20nutb/g0azAWvtrRrKvuZlWe8hpHThJkhBYkFAPDdWi
         0D9ZjKqPranNIrN/gICiEVpBmLtXAxHRszh6YnSvmHrtkECY21fTMyjM7ETvYMX0KEFP
         IPdqv/xGDaDNv82G6lZqXK9m6rc30iY1R0Nu+4IHsHiH9tjO6D4R90xpvbs/ZRE6YI4x
         AXwc6ovn7qC9q0OoQydaqNSeJCRxF34CJJVNoZ80Gr27JSAe3I1F9Zcf5tj/CNSB+2/u
         yTPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785376508; x=1785981308;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VeEYuGzNBqw7pB4OOem0F2DxkRj0GjZ8W0SA5droXS8=;
        b=qQFBq65fLARjd11HnsMXD6/88j8UZr8Yz4qZsTLODgHBr5PhBgnyWiaxryuKa91sXA
         ad27jrUwO8bX1N0BaOx9D3B+0FNMvDiujTl5Lx/MCgjd8aC3vOEC7foSq9BqxBAVL8Cw
         TV3PQkMwef6D7SWtGNsBVMjzbD1uovPniXw/FUaQONZZzP8Cv/r1oYpvmO+IU2FGOp3Y
         AaInjDq+rrxDJp0YJIpZV6seZrCRfE6LIfleiXHY0Bu83Ve1fs5piUtTFx2OzeLny4as
         cB2qaltsz2rlPWK32311Y9x421r35Ykwsm6ABpvbiIsNghPNpgcVLz7ju/BzAUsVzNGr
         pnww==
X-Forwarded-Encrypted: i=1; AHgh+RqXHe0qxZZ0EhIHKoDgb8wigTj68g/rVmONPznODH8vMU/9FPZhY9buhDmmYMQzZ+nr91Qr0GoLKsdVRrY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyswJ7B3Up1ewKgILlAZg9oOz9flt59Gj1N5A6V/tJxRJzc3K95
	+K8XCva3sprqR/5E/OOTlOLmTlflKSk/7uvjXaf15KDBW8fVJheqK7BqsFmBKeDzNjM=
X-Gm-Gg: AR+sD10INBGWPYMHi0oPbsexMyDLOcPo9DGkftmDgQqfzfPf6yNIWUoBHxwAQHZgGU3
	tuUnqsfQQiMqIqTDTWCZukMcpGPTkhaCR98KDIkvwSN/S3xOa4w+6ylwNyhM3XrshHEVnkmgteS
	9rA5iXIwEcxiIdfnJEslArNTacMPksdT24zhKEXXXasaScJkbE36DjykakOdZkiRoQ1ECZsbTUB
	VywnXkjItLJPAC3fyjuYTC0mw1F7VNutOqowJdBmBowwwuRSIG8fTMjpZO3QTDje/MzFj8Wydfk
	DTO6i5jzF8dFYT28tDClVyia52e60qXJdzRTAfxaca4jY8ME0j8IG/Kpbv7b1iNyCqI4DX0XZiq
	3NBofTXdMxKf5wwrdLiNZiT+HgVAYItyoRMI1wgLH2mErN6zw8MldcF4QSFyO5hYIepp21/Ntth
	5jLq+403ltcvzx2vzcaOjikXXFtCx7M9zy1KYLaKge4QwLdAJWY7P+UVh9qRqkMwd1wt0+
X-Received: by 2002:a05:6a00:aa06:b0:84b:e69f:1b3f with SMTP id d2e1a72fcca58-84ebdc67bf9mr352039b3a.8.1785376508034;
        Wed, 29 Jul 2026 18:55:08 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84ea0055325sm2192327b3a.15.2026.07.29.18.55.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 18:55:07 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: leon@kernel.org
Cc: sagi@grimberg.me,
	jgg@ziepe.ca,
	michael.christie@oracle.com,
	martin.petersen@oracle.com,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IB/isert: post full-feature receive buffers after session registration
Date: Thu, 30 Jul 2026 10:54:55 +0900
Message-ID: <20260730015455.1505508-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260729130141.GN12003@unreal>
References: <20260729130141.GN12003@unreal>
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Thanks for the review.

On Wed, Jul 29, 2026 at 04:01:41PM +0300, Leon Romanovsky wrote:
> 1. Please keep commit messages concise and easy to read.
> 2. Include the full kernel Oops in the commit message.
> 3. Keep code comments to a minimum.

I will fix all three in v2.

> 4. Please address Sashiko's concerns about this patch.

Posting the receive buffers from the RX thread does leave the receive
queue empty between the final Login Response going out and
isert_get_rx_pdu() running. On IB and RoCE that is absorbed by the
rnr_retry_count = 7 that isert_rdma_accept() puts in the REP, but iWARP
has no RNR flow control and cma_accept_iw() ignores the field, so the
patch as posted is wrong there.

v2 will post the buffers in isert_put_login_tx() as before and delay the
final Login Response instead. An initiator cannot enter Full Feature
before it sees that response, so the queue is never empty and no command
can arrive before __transport_register_session().

Best regards,
Yehyeong
