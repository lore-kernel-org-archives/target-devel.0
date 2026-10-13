Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28691395AE2
	for <target-devel@vger.kernel.org>; Tue, 13 Oct 2026 01:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791853511; cv=none; b=ANKJfa2S8FFAgbJaOinfa84kem+VCEABPQjrV/Hllw4loJJ9X7PeB0Ku3MOY4SmrEvMpwLLg28oUtQAgSrA1NmWyJpoTEzIeV54PfxTxDEvoUSaIrkn8e9TNV/KGPMoLoHxyBeTK/CAjydAB+7ArLbzxqHMCn6sbfjFnurJp+uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791853511; c=relaxed/simple;
	bh=lc9zj8acVJzB2Zqg5NYLr7ldjKhGUblQwyVTN5qJy9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FeoAqISjayPdzG+GvGADEkhbB9ljh+i2UzsgbmfKQekcHQSLz/rnJ5SLxXqb/EJJDJ6PHp+u2H5aZJZ3tzisGVXLpgsilaTNr8dwiqF5+YJb/YcOyCcdyKU4YJRKGDJD520knqJs+Q7+ooU6BwMgGID3z4WjWNR8ubAmxboOKfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=iyp5Xkjr; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="iyp5Xkjr"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-892734ce7e6so809673b3a.1
        for <target-devel@vger.kernel.org>; Mon, 12 Oct 2026 18:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791853509; x=1792458309; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rogv8gP1H52CoBczHw69sKFPcqTXLhNajNS7Lu6i04U=;
        b=iyp5Xkjr9/0PVvrnELxm+jrh8SzISYCJ69A1ly05gNkK3pXL0T0xoORr9VYECpqpTW
         f2WtBk5CmHPfbAX0dudG0oqruztFRPqId0QWzeOCSxbheDIaCKI80kqg63YjshMViGI/
         Rmhfxkq/+Xx8z0Bwq25iJz/8oqTBB6EU1REYzkJWIWksbGOFDSCBOXG+SFrykXPELUmQ
         eJzoPLeoYbrSruTmyUkDnjcLtO7yng2h6earm/uMi2j6DgOOPa/odfms4nAqAaAKH8iw
         N30SuUFdvCGc1jBiZTboRjPtCJynnmIYbePS5Ie7Qqhh1+jTZcTXA91b5xi7RrMuCVX1
         I0pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791853509; x=1792458309;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rogv8gP1H52CoBczHw69sKFPcqTXLhNajNS7Lu6i04U=;
        b=2Zp9FhduDyerjK9MoBGaSbpaCACvrmreGv6M5cOt8vh1dLqGsc6el6nNmSIWk9eTD3
         w0rvD/6krSlpMLaIfjXYL2yI1ZktcNAjkT8v6kGxK9p5pMMRTGEkywUS7B9LRmJt4Eew
         DmlD2d4s5iOJR+LWLmA+itq9yoVb8Bf4kuFnrrTGEvxrz2Bq0B3CAeULf7mQPfT7GAeZ
         xHrvTg2PQX4bHaEFmjgoG/Dirg/J4p2bRLk2bHkjOE4hvALe5Uu9z1TCEvUuI9O1ldd6
         9fCaOjITe9Y9zNSyVEjht+JD0iLjkV4O+e5gA7nb8h4i2YjZBH1lNA+EPUIXsyWBFaSN
         HKPA==
X-Forwarded-Encrypted: i=1; AKwUvBwTFtttYyDuSPFCmhqDuyhJo09AndFN/OsOJbDgKm73AESYb3b1AMnlhVF7BdVqqIHaPiFX3FvTkJKaaVo=@vger.kernel.org
X-Gm-Message-State: AFq9FYI8Yepq8hfu7jWsVeP2id6S0lXpCv4TpHvmj+Pft9ek9USFRT1w
	8fh+QtQZ37acYt4BaKbldXFyWS+YcAZnXwwK5k/uR5LernoVOf6FzPWd4NBQck6qQFs=
X-Gm-Gg: AYBFou0GBHjskedkrVq+NKe03ACWShSdy5XT7RUGMBwJ/VUumCERHwrH++OO5FVmZTM
	C54HyVbhOWXwMT4lpPst+ebiFukA+FAmwiE59EpaxdcGlGcXFF2jiy7SfVwlLQw5LEHOONzI8u6
	1FlQnnrxakBFYd8qhDR3IpRNG3neBNs2t4AfINePOC9tbEw50QN+aPRptFenqBYaeuQrWIvgYpj
	/V0/rY2sNTz3Y/yi5C8kywFREi1sSW/f2VupWMyny574T0ZYTf0PjhfYsirGecXeuGylJcNsO9y
	nuhg3lP48cvbU6VRtXpY25M0RcWVhdKDaZHbxDGRbbJBXCqsCVjSrtvexSfeXpy2JNvdOuXhP9Z
	+GPgcil375KvRzMdJo4UaBTM6Xx73UrlWR0ayxSSMQM6dly3XxJ8MIp+awFbcfVb/5kKnM9Gewt
	H+mTnrdeSFpy+KDze2A1q+2PGC0pN25whTgHBldGb6xpIG+OyrxHQELAlmiTB0cHW3oB/rnppQl
	lRRNQ==
X-Received: by 2002:a05:6a00:4185:b0:890:a3ed:8a49 with SMTP id d2e1a72fcca58-897c7cd481emr9345777b3a.51.1791853509580;
        Mon, 12 Oct 2026 18:05:09 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-896c3107194sm4387216b3a.18.2026.10.12.18.05.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 18:05:09 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: gregkh@linuxfoundation.org,
	linux-usb@vger.kernel.org
Cc: Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	target-devel@vger.kernel.org,
	sashiko-reviews@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: f_tcm: reject a short write data-out transfer
Date: Tue, 13 Oct 2026 10:04:54 +0900
Message-ID: <20261013010454.2472267-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-168374@kernel.org>
References: <20261012154422.2436134-1-yhlee@isslab.korea.ac.kr> <sashiko-outbox-168374@kernel.org>
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Thanks - both are addressed in v2.

Deadlock: you are right, the failure path reached bot_send_bad_status() with
cmd->data_len still at the full declared length, so it queued an OUT drain for
data the host had already stopped sending.  v2 clears cmd->data_len on this
path - the OUT data phase is over, so the status phase sends the CSW instead
of draining.  I confirmed the drain is no longer queued: ep_out stays idle and
only the CSW goes out on ep_in.

Log: v2 uses dev_err_ratelimited() for that message.

For what it is worth, the same bot_send_bad_status() drain is reachable
without this patch by any BOT WRITE that completes its data phase and then
fails in the backend; the failure branch lacks the moved_data guard the
good-status branch has.  That is a separate pre-existing issue, left alone
here.

v2: https://lore.kernel.org/linux-usb/20261013005854.2470384-1-yhlee@isslab.korea.ac.kr/

Thanks,
Yehyeong
