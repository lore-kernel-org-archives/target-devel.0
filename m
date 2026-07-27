Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711BF3E5EF8
	for <target-devel@vger.kernel.org>; Mon, 27 Jul 2026 10:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785147200; cv=none; b=LH5IumolxLb/OEGxg0xJP8bJTWFdb7sCWplM6MOfPj96ND5okU8lMrLHMMtBnK0OI5iJjYuay94t1Bn2LaU4LRxqzdiNVqKOgK9S86G/adk+9uOtySufEsPi9rRW39twwaL9ygqdbQqn8FUV+2yy/+JaK0PVeFdwrTj3zRz6tbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785147200; c=relaxed/simple;
	bh=TOdxnhWT+ZLO74zXS8rVU8Ea0zC1JkHe0Dz2LVslEPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SS6LGHTSEwHHXP7g/1pC5TRYxNUmrDgWCcz94lpxvAQu5tVQ0jJCcNlBogJmCdtLEQyPummryES4inZS9knqZOR6Yh5w5R/xQfrlVJgCqD6iqoyd3B1Vw59NAOX05gd3jRTlpv6P9ElHVPE5YIdjU6YKO+zYczvQ+3rHRXCl6LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=slh5LoJI; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="slh5LoJI"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8484f229529so1578937b3a.2
        for <target-devel@vger.kernel.org>; Mon, 27 Jul 2026 03:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1785147199; x=1785751999; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vp/5BcyrePbYZxYkxsuSp08ldVpSPznaXrpWbqGp8q8=;
        b=slh5LoJIOkO2Mb+XR9wN4TPaDMN43SANhDdp3Cu6yNQIOUPsTDcz6TOTzJZaQzCJar
         SDvkAYEtpEoey0U7jvF3rUamvLvdA+wdtmsvM9hnuHrwADFyUrdPciDZn95n8Zloy9Lu
         rpgnCnQx1Q3NSD9DQlwqyBjvCL87aMFZI01iy/toATYny60jGmEtGtbAY5whOcRc6ny1
         YGWeNwQjRcrpMTRuRE2nd6WebQT9e81kiZgJsTQQ4/aigrK0MHFJ+HMebR9Gt/g6afiQ
         UAwZ4T3F9EsHi1SneKewxEmEA2F6+o2Kh/8+vrOJszlyFI7aMFPijqAhuVf2vQpm6rNU
         +wLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785147199; x=1785751999;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vp/5BcyrePbYZxYkxsuSp08ldVpSPznaXrpWbqGp8q8=;
        b=VM9mVd7DLAJJma93S1y6OPF2Z+81U39dWUREaUEWtGwlhd8UGoU0aAqNxEfs6L3nxL
         GnvxxN2UuJrrxEmBsGvqscyey44NbHJBLZC9BjZGNZl+Zf1u+AJJTO+gh/KdOt83kel1
         xa2/QqpHnVXIbMrAUklmANPiZQPrU59JZfkTAiXmJ0E6iicssQNbZGCUImC49K0VZDuO
         berZKVNA5MVD80HKs8JPJkKGAyPOjQ6LH2qU+l5Cek9W+7gwVN2pMReCz+n3Zp3/YVGz
         N57KtTbq4Kqe3e+kSgUaLGKrlFbX4YvbeUdrAhEVFxB6CII6/k9o874H88G4Y0bWfWB7
         hcpw==
X-Forwarded-Encrypted: i=1; AHgh+RoyjAKef7ZUbtIxXvwb5bGwKIcABdn5G/XisJIxQlBI1QQ1+bXu+Ok3PLh6k2bQjNLKu+KxBBZ2G/IlnhA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yya12cpVyHDqiD3YVAIFZBkjrXPrGKK6BVMtkOnUmzzedEQXK7Z
	mwE1XIMGIZK5JpLKv4X4pPkB8abFxePQJVfzq4nVt7pA6Th5+iIgTgTittOwl/YJl5Q=
X-Gm-Gg: AR+sD13azId40OnGP1AXXdNswExOq52HhCaXf8oS+bN2i+b1kf0e0Ri/sutqqc3f5EU
	wHvVwqIjtcTRX52lsOPtNcKiZ9nZM31qYHOHn5+LaVAPtB5VCWoGP5O23KhzlgaUT1Z5Lk1W10q
	5vAPjDmEWdKgi3GsFZq6zm6rHXsc2zmpdu6dHfGbMb/sdOc2a5PmNgdYqNlG26xim0+PPFudPCG
	aiWMW3QLh5RSOfGxT57aBltSDrvPmrvYso7mTcHCl8GoMazPL9BF9s5fTS/E7fzIKLsY0aGvwfA
	prc6FqtmkzI3CJFgadWOe9+DhYqGVZPhlNmmCFjICCIXCT51aQ85MrXdmmq9WV4Oyw7JT6f2jAK
	S8hoF+BZ/F/aG6Weao3rm/LbK1hN5SfDURpGj4ezfZbotkUr87DVBexhL7hsF4dwwGUshLl+zrW
	9k/0b1sjm3wKcbHQugwSxql5vu
X-Received: by 2002:a05:6a00:e87:b0:848:438d:3665 with SMTP id d2e1a72fcca58-84e595644e0mr6217501b3a.41.1785147198851;
        Mon, 27 Jul 2026 03:13:18 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:fc36:f2a9:533e:766d])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e53253d7dsm2788211b3a.5.2026.07.27.03.13.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 03:13:18 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sagi@grimberg.me,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: Re: [PATCH] IB/isert: reject PDUs declaring more data than was received
Date: Mon, 27 Jul 2026 19:13:07 +0900
Message-ID: <20260727101307.1079690-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260727051557.GH12003@unreal>
References: <20260727051557.GH12003@unreal>
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, Jul 27, 2026 at 08:15:57AM +0300, Leon Romanovsky wrote:
> I have little desire to argue with chatbot, but the second check MUST to
> be added.

It is added, with your Suggested-by:

  [PATCH v2 2/2] IB/isert: reject login PDUs declaring more data than was received
  https://lore.kernel.org/all/20260726163931.971063-3-yhlee@isslab.korea.ac.kr/

The check runs from both isert_get_login_rx() and
isert_login_recv_done().  I posted the series as a new thread instead of
in reply to this one, which is why it does not appear here.

Best regards,
Yehyeong Lee
