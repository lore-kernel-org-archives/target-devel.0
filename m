Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F0C9332EBD
	for <target-devel@vger.kernel.org>; Mon,  1 Jun 2026 04:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780288400; cv=pass; b=QTCROz/K8TMxN3r3mitYXdz0qqrsjaZGgheaBjqkBHWiBlUgFIugh98QX9Gke2LOV5raftcxBC8fbEJnjcQv6CpQ1+AlNaKZxIJkP0KStprnY6OfllX3QZSP9lQACRSkQ3xPFLiv3ZLlvQl9Y9GJ1yKwBOYZX6GG2zpVQ2Y10PU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780288400; c=relaxed/simple;
	bh=0UZXrL/sz8NLcwOLSzU9YZpogwyYLPIhStx4quryKwg=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=R7+ZwqhcP+BDN6pnbuoYyDkH2ZDKAyOqZoaFOIRDu2ix87h9X2j1ff8AfuUzfsD1BQCN3kLjH/8fWq1OTE8rqsPUPhFKFMkwERbgnOUEJ6IpEeKmtt960yKGBvBR5jjeLsR5iTm5sQWUY+DDTpGisomH8I6ov78592QaGIloPiY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=r0icHDHp; arc=pass smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r0icHDHp"
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-7e38f2f3800so7491707b3.0
        for <target-devel@vger.kernel.org>; Sun, 31 May 2026 21:33:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780288398; cv=none;
        d=google.com; s=arc-20240605;
        b=GcoVNpPLOkxpU2qTuyne99InQVWCIWPgjbeiqkhEjB1vUOKfskDWr4ASQX6aozGwqT
         Z5NzduE3U2VkTxTSQLkgUm6zn9EHChm/U8uF5ISvb/xV4Ma9o7l7Us/a/jmxXNCKek9h
         oevxXfKGenuWKIXuwSB+hZeAJyfVTCwLtjEmQQot5foLMEoq8XWuODIK5m9cxXcC4iDc
         giuwQWXMadlSqLBGWmTZwwanz8tXSNS8CnSUGS1T5pUk3IxuOtQZF+n1QySsWD43znOM
         Pqg8ddLs0YDpdPzMPZNOSbEf+csq4p3m3SyrqvC3NA35rqZ/00cRw1MzqKTZWGhj/kkI
         rLNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=pEwHZMxiAJxYqtcMCz1PfVYBMTQhyTj/SBAyrw3RfYE=;
        fh=InBi338tRnccEAswk1LVACTNEIvmrs4oKQYyiwL3G5c=;
        b=IqFmIc0Eb9vm9PYx/h90wIGiS2RRRnZnamPZH5CCH8BgghzXT5YhN/w24+I2MOXg9k
         t7Q7NydMIct+Q9GVlL+MUaAk4a5NWNCmRLq6gU5UtCaBGu7hp5sGRY1T2tT1fZiLVnhX
         hfSIWAmfEyXnacsMypKSgyCnQ4RXTIaaujxauY5OUuopWxVTOUlIHodQPJ/BBJr5wtQr
         k9i1apfHs50DUD6RpTMJnbpRm8tInhd+QS6CxUkEuu9hypk7gcF51dTtLzfylssf/OJY
         wXb0fHMH1OfjLVMWGFDzjPOoow15lX7P+4cfsMduKa+VWYNJ5jcCRnmY/aUFoWXrqaAk
         Q7vg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780288398; x=1780893198; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pEwHZMxiAJxYqtcMCz1PfVYBMTQhyTj/SBAyrw3RfYE=;
        b=r0icHDHpIgeBCeTv4Dy8p9phzxWHbtWmvE9fdnXTWCqPWng06dBA6mgME2GaM6UD28
         GWotpU1QLigy/9tFKMLJNSP7JepWHo+9zmOYm6jfvLg3E806C+2GvJnKa+G8AGzt5oOi
         aykH709PBE5WTUY4Fz927IVU8qXnVzYv4JKFWWN2qhlPLhSSlUkupa86pBTnsSe0Lkxc
         d9SXMxx+G8mtxpK+C9hFnY4iP2pTwcJzBmhTMIeSIGxWoyO1oUC9jAqrt6mZCApe3uty
         cV7tauBYLcxssEtdc1iYC1eqMszgWiPpnHK/4fXCv4v0y8ywn2PQhhW2zYRagV4lOMjv
         ANrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780288398; x=1780893198;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pEwHZMxiAJxYqtcMCz1PfVYBMTQhyTj/SBAyrw3RfYE=;
        b=VmJzNS1wysE/x1VH1azogpOP5TNWSSJEv1+3qXPCL89tqoVGEcQ0luzBHmieYeSPHH
         gbMZzBHyRiXuHK2YIyMvNYFN7kNw8e04KnPtLQeOrOB8fsgG075hnUSUcBWJrFOZ64HC
         3sHx1ZWkVbAhxEFFrlzgERSzP+IH4OaocqJBsxhVqV/gDd4JylNjichv8XXqZ21uc4yD
         tZT4YRH/BbqNHTm2e2gDswPuf/SC8YfBuPxJHHo7gBW84MplfMB36GV8BTAhUGSoOVcD
         wJWEA/dWW6AQ9692cxlDN3VDb72BrlpylSe78nRZCvZSHDCCQtQ6Ibet+sZN886llshv
         yIgw==
X-Gm-Message-State: AOJu0Ywvg2fQbmpMOoxNG9bYB5Up2NS4qyD2QCi1HOcSprjqKFlDsPQO
	spCGlH76zdVcdtm7zRFrQBMiDMUja3QVLikwvweg6qQtIpL1uqOWTDZeQciD7WlgM45+jfEKW+0
	jEQySo2wn5lfWxtg9IvIPGzFgRxyemmfNMa4D
X-Gm-Gg: Acq92OFzWxGyyLUOHe4L/8n/wyJcQciGD0eZTeznnc7x8vTKhOxu1iXfTfrY6tdYmvY
	vlFQPRSDuQbh686fs+Ekeu6K7/Y1tBkgT+61TS9xkUjmsuahBVWp+MfcijwpOrdoyuZxu+Ac/Vz
	WSx8wU5z1ixKlrhk5mAfCUqQ0xY7J9TFtGamY+SiiTBGTv7TCuHQ/R2PpFGGhXRLJcXM79QWmUz
	vN3UlsR1U9fy/b1ENdZcrPmbgq/7m5hmNpkQEXj7HwfJYuy7ELBFi1gAjZOawBqCVvzBU8h68j0
	Uoa7d/UdFLqnm6I3jwuph3LIbjDrDO4=
X-Received: by 2002:a05:690c:6a87:b0:7bd:93b0:bd25 with SMTP id
 00721157ae682-7e058b44d8cmr86221377b3.4.1780288398138; Sun, 31 May 2026
 21:33:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Ginger <ginger.jzllee@gmail.com>
Date: Mon, 1 Jun 2026 12:33:07 +0800
X-Gm-Features: AVHnY4LZa3ImsatjuLyk4EWFgwb6jmaA1ndPIHrbsJ0kPlKnRVoa6BnToDYfy9w
Message-ID: <CAGp+u1a-=aJxSfa3k0mfLd0LrbyVgfDh=_BLQNc2dfamv3nAsg@mail.gmail.com>
Subject: [bug report] Potential atomicity bug in drivers/target/sbp/sbp_target.c,
 between tgt_agent_fetch_work() and tgt_agent_rw_orb_pointer()
To: bootc@bootc.net
Cc: target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Dear Linux kernel maintainers,

My research-based static analyzer found a potential atomicity bug
within the 'drivers/target/sbp' subsystem, more specifically, in
'drivers/target/sbp/sbp_target.c'.

This potential issue is present as of git commit
eb3f4b7426cfd2b79d65b7d37155480b32259a11 of the mainline kernel.

Potential concurrent triggering executions:
T0:
tgt_agent_fetch_work
     --> spin_lock_bh(&agent->lock);
     --> agent->doorbell = false;
     --> agent->orb_pointer = next_orb;
     --> spin_unlock_bh(&agent->lock)

T1:
tgt_agent_rw_orb_pointer
    --> spin_unlock_bh(&agent->lock);
    --> agent->orb_pointer = sbp2_pointer_to_addr(ptr);
    --> agent->doorbell = false;

The writes to 'agent->orb_pointer' and 'agent->doorbell' are outside
of the critical section of 'agent->lock'.
This does align with the lock's critical section in T0 as
'agent->lock' seems to be responsible for 'agent->orb_pointer'.

Please kindly check at your convenience. Thank you for your time and
consideration.

Best regards,
Ginger
