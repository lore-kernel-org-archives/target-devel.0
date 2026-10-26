Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792989840;
	b=qem7ap+ue/LkzXgAGqPnSiGf2r+onEBMCoOvG94xv4E6vcfgV0AEp7aET4QboscO2hGf
	 6JCFhXSbyKjif/TTcSdgih2DGrntZTptrYARR3G8SsulBqMc9IVq5HRFHR7Y7XSD2PqTy
	 dyFciLrG9Fr0Woi0umcUYutWnOcIAgyII50UXe1qkxOpQTVXb/B8p6+TWvV3ZAy6wOQlu
	 Fneanp0ZmlwXJtNKKy95n61NCz7iVVBXPuh5+hTd3cZ2SbuGYQoguKF5H589eoefAI+Dt
	 s5UigZ/PzFHwq/ykKDtL/w1czRS34i5T528QaQpM/PLQxt2osnENLQ+Ap0d64zpQ4Mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792989840;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OGQ2n/YSypFFKpyFH0GD8CI4jI6BmXLzQ8gJjPjmUbI=;
	b=VKoBt32ldgXdecXzcWOoNZLvCuPUyD+jyYV1BxqyQXtG2Fw7Z91NGHh6UZ6aQy2fp07C
	 6ERHPbNkJEbu+WAUEdKNnX0IRK6hdIxkj4adzzCYA1yKlpqEfMMVHaAEz4aAoK79xIUKQ
	 BfWCE9WKDVSWphrIGg4c7U5j5OAe/Wy2gvw9qin7r3tnVEdBVoGNV9B861TufwcQ8wJ6U
	 vFdc9oTOH7iFNA8QDqUMnOdnsWkNKyVBefsAg/CBlVrYq68UohOkykPVFTThaTzTUEr/R
	 THkf87hR6IWHuMup9RcSBBcQqIhkus3teaaGhIZO3mWau+ZwvE84O0gTI8UcrCI8qyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=K2+282uj;
	arc=none smtp.remote-ip=209.85.216.50
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39249606A31B
	for <target-devel@vger.kernel.org>; Mon, 26 Oct 2026 04:43:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 39249606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=K2+282uj
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3ab752f6244so2382039a91.2
        for <target-devel@vger.kernel.org>; Sun, 25 Oct 2026 21:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792989838; x=1793594638; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OGQ2n/YSypFFKpyFH0GD8CI4jI6BmXLzQ8gJjPjmUbI=;
        b=K2+282uj4+65sW2u7QpDwK8BnRjSppx8kCjYc6j7Qxo7xAilpRb0U83O4UdiJw0gT6
         kHjW/+k3+7oo/rBEdDnJ6OLmXTcKdNrPSOQVkL+xCKIpMy69TsvoesMa4BwTuhcJ4Xug
         GKibOXF4f35qA+u67DgVQWZixx0X+jaQ9yeeW/RIlBaEI96Es2u4Gq96rGYyM/ZU0sNu
         3asOQVBpNMN12yVhTR7wji9AoUG5R0vrDWnZQRQz8rbArIsrz92mKtKnMXkB9DAHxJ+x
         Ou313egELNyZ0boc75MMKTRGdKngOfagBdRm/+IOlin+eoHfMK0NmDx3FL/u3uXulTEz
         nhzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792989838; x=1793594638;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OGQ2n/YSypFFKpyFH0GD8CI4jI6BmXLzQ8gJjPjmUbI=;
        b=o5x4rv6ZL1RjWoWhBLXfnVUmm85wNbrxC3kI+JZcwP/QbwV0d1J+c2Y6ZVm0lgxNqt
         tTpQZyrYMBCMG0qZAh2OuloL70ZaN82n3fN13YY6LOCLGYocER/BibWwxQm8afS4LvAp
         Qf+n7vNEw6JJnywYWqcPv2EseBCMTM7Jwhm5YA1DS8bKqAnC60YlXbjxkFt00yn81MvL
         f8mcA332egeB7i6ZHKaFOPBX04E9ZI5zXV7Lz12gW2s+7mH7dc/F/aas2Kb6RgzLR8yw
         ed6RpCNuaetNliEHmskXr9KWnD9v8t+uuTPu8kLH50hn0WEDXVzEJ3gaJ74OKbh+YbrH
         LkGw==
X-Forwarded-Encrypted: i=1; AKwUvBzuRnzPoRUB7+ZB80A9PvuT7UOG0AkQQI8k3aj0NjVO8/bADkPdkjczG58MebY7ZG3UlS+Ev31VxsEhO6E=@vger.kernel.org
X-Gm-Message-State: AFq9FYIaNXnrONHIYVDL4Q5XWYwr97gLRfg/JmuZ5LgBWxWDyyUtnouJ
	DGYAoheqAaFJFoubfoTWEG0phsiaIQvG71gmqtR8NPgyJGscRNM0QiVbf/D5vIl7x7Q=
X-Gm-Gg: AYBFou3OU5dFGksDo8Br14YGdJ8mBBeL0s1WmIABHXBR+COgCWpgXmBDBIL/olQeEoX
	gq28dKD2aJTsUwntWkarZygUOAAg89rj0FGOeXFDG8LKV32+1P+NhEN9aJb4hbtF8bH7oFQ+GzG
	pfYEo0C5WX6QpxcohZF3dlinB9fgeRM9Qe2rrKy9zklMgAAL6TxW0uB8BZtmzFvpo3MmV1bycda
	0LwADHDLfU/GJ7fb4JJ2zXy7o+v1FvBYG4n+nRtsHXPWmrjtkBBKoCJjRwAU7Qu5QAkfWo8cq3b
	Fsaa5gYzx3MZfqY7y+pzG9nF8PyPk41qdQtP4yuTv0YVg4BUfZcY7+bO+A4hLQQN7enjrDfg3LO
	QiFZmD6Chxw6re13Q5ypg6RX4wrVglqjPdx1xN/CknV4ElOh5u3epYx0+ggKdaDyDdI/8c522ii
	YAW5kEa+6ZIBGKcI62JzL55FUua7wYOFzhOWgowb0/p9fKviejpO7U64bX1Cndp9kbSn1JZyJCM
	/VtezXMhsQaD7tddhipimJEHJM8vi3MfdYZhgH9inqt2tC4R66+Mx5sFCvGrJtRKcHuyRBRNqJ/
	zz11lDwO47N+R+VmpqYv60A/N58ZVZ6Symm9RFADyBM9+o4x
X-Received: by 2002:a17:90b:50cb:b0:3ad:a462:f07f with SMTP id 98e67ed59e1d1-3adeae7796emr4934481a91.45.1792989838351;
        Sun, 25 Oct 2026 21:43:58 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adebaca7casm6810650a91.4.2026.10.25.21.43.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 21:43:58 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sashiko-reviews@lists.linux.dev
Cc: linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Subject: Re: [PATCH] IB/isert: set ISER_CONN_DOWN only after the connection has been released
Date: Mon, 26 Oct 2026 13:43:36 +0900
Message-ID: <20261026044336.228447-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-184560@kernel.org>
References: <20261026000733.4178856-1-yhlee@isslab.korea.ac.kr> <sashiko-outbox-184560@kernel.org>
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Post: <mailto:target-devel@vger.kernel.org>
List-Help: <mailto:target-devel+help@vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:target-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Thanks for the review. Both are real. v2 drops the rem_wait wait entirely
and tears the connections down from an ib_client removal callback, so
neither the use-after-free nor the handler_mutex deadlock can happen:

  https://lore.kernel.org/linux-rdma/20261026041949.225619-1-yhlee@isslab.korea.ac.kr/
