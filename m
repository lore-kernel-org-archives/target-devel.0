Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.169
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793787882;
	b=nYLT4VXOJaSJNfNrsNGS7up3ZQDx/NQjN7rmTbcNERZ/8EgWcedZ4zeiXsUZksRmdBSx
	 lB1oYMIpucMQTOxYxVl+hq0Yqr21qvHC5cAOhs5VbebLguw+hLdnj973XQbIpJTzcftft
	 xGzkJx7Awe3paGIK6y6yfGh5ec67n97gmCSYCpy2vwhfM7GdJQ3ST1bT15ZrUzA4hHskx
	 Wpup2SKnPEFyVNFQlpN1Zs5yMdnP//tRquJwt5XOMOFsCsMW94aidZc7/KYupm1QOnCq2
	 KRvWqowG66I+bW/lTe7jnvis3eX0tZCdT0E8cqAgLaFepTCx5OFgXDQonFCtIQJIg3g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793787882;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:MIME-Version:From:Date:X-Gm-Features:Message-ID:Subject:To:
	 Cc:Content-Type;
	bh=+dcl/erqXSVMqWlciMAxF0/KBcxrMf17dIv8kW6c+wM=;
	b=1Getq1Bw0rB6qad2MegN0miJuJLVzZXaL5REXEJ4uC5Vb3YkqAo4SrJ/b0Y/d9si4Gtw
	 xLpA/xoEiOt2cuofLQXskCwYV413sVGStRm1SvBrZSjJrUSDFH04dsFyEP1NpehQhk+vi
	 yDM/mD5uwsoGFj6OO72pE39G9Zk2h6hfEbhknN2Qvc/HRvYF1ywn0tcXSSsIvDT1xzvsO
	 7EpFsNgvA4hahEE5SZ8J1bCSVpiMYIqgpyzr0tGJ0dRvhl2brgIa4vI+lKRZ9Axy70Yzr
	 anw/5l5h0sVP9ELZDnRVIEsvyM+4isoCgHaTTuD32PRmA9Bz+dAuQn17Cmo1tpzP2cA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=B179lsik;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.169
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF64606A328
	for <target-devel@vger.kernel.org>; Wed,  4 Nov 2026 10:24:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7EF64606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=B179lsik
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-3ab27e45e7cso4567321fa.3
        for <target-devel@vger.kernel.org>; Wed, 04 Nov 2026 02:24:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793787881; cv=none;
        d=google.com; s=arc-20260327;
        b=qiGJxN2iRRX0d0Gn8zXkhurm44M+4LLz4r9Eg6jztCdUHhy8xb80SHUiV9x+17M2TL
         mcpL/AfRdM7XyUrnbrX5GRZ/MKvGXkgTb9nAiIGK37bTtkeK02Fi/m7bwa4sdT1bqlVg
         dDNMTYmC94gE9H/rpPCA6RfZ9/W4MweZDGTePp92CvAiFrcpWqx7uj66FtjeU3dW+H0h
         IQw0w93fC8K5uVk+FeYNWpj2hpSm++FA3BsStpz/Ck4WR99cSAO7u1ucaY1sf/UyI/97
         MbmH7+IimOtw+O2eM4g+GVhpTBZfDyQc/HaZOY0jb6E14wxTsdIMLjLgPOmzzLm90ljf
         IVIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=+dcl/erqXSVMqWlciMAxF0/KBcxrMf17dIv8kW6c+wM=;
        fh=AffWpZaFlFVu3HwMh+9QDOq1e5OZX6tB1O0W+JYwLmM=;
        b=KYPytwcocCMgFvi/NbdZv1fnlFp+WxIXvX9f+9RMEMOsJ3AK6eFR44WtIQazbej5G5
         nVqys55EV1P8RHpWycwvkWTz3PoI4yTrxzX7UeIIG+Vcd51h2hNHE5Wb7K72Tpky2VO7
         qGJU9+ayWKWIeCvVUcA5XvEBk7X+QAU/bzuFF2GkLYQ0jh4mqWLPzTYJ95sljJpLfxQf
         e8+Zur8M22BtoVO70wYgJTVhAX558Iy/IvDDDj98cbA9mjpviUwxeazAtaD0d/iFrsY0
         EddIjfJcKnM1B5fawtpMcGyS+k9yFLFBSdYi/6BYOm/UuWFTK828M4epIKUswpuEhwV/
         TLRA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793787881; x=1794392681; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+dcl/erqXSVMqWlciMAxF0/KBcxrMf17dIv8kW6c+wM=;
        b=B179lsikAo3MCoRa+xYIU4+cZtrZXD43+xWjXxmmK7EU5jzixchIfy30KlADnrT861
         iOvQoQm6BBNZdCJEH0Q4WhyLpdI8kZdvfbbQNXoluGnrGFoHLA1WtHksMSh5Z9uI3/N5
         ClWvmr/7fzJhhdoPSfUrsEdt2Vms6hp0PmDFXu9ly9n+lduev3vRRHwF0h0+YmYTcai4
         1mysWtx6OwwvhVco8qHIUWDnpfCe25Ijst9ZbEymg41mIAehVIGkIL/PVYWeT+FnL5zw
         H64u/RUyB3pt8ygIkFMF/DJdsTmn9Q0smb1O8dPO1Ya6tWfIYpkI/Y00oMahoPSz5fH1
         r5SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793787881; x=1794392681;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=+dcl/erqXSVMqWlciMAxF0/KBcxrMf17dIv8kW6c+wM=;
        b=HB5VEUr7FaaXM4GXwGYhqIc9tP/7NF+eWixikhVZjuOYPUn2rbSX5NPpfsHtuvVFMG
         iOMCovJRGsry2gxun4y8YgS+woW3i2HJBxioWbxl4JY5Xn1unLxhtVTWT1jJsTAnvuYw
         rbwUHemzOalPrmxkyeq63gpI3wYTXesGjyUQEC40S8foI6mpB627+QlPcjUx5YRLyNYj
         wV1urEEBRLHLXgsxS9VX3kEHPqs09dHSSeXNZ643i8FlhRsbIUqkirkXwg1/n7o36Oxd
         md9I4Up+dorc6JcCd6BhJ3euitL+IyRigzrkrVEvm8T+7vBazIaWcGQJgawqvSz9dxNO
         uYrw==
X-Forwarded-Encrypted: i=1; AKwUvBxQJSysjQBhLpNWTTbPXQOh8yLczzwgYhpk6TA5dfOzEAbZfP8uexKZ7shAeLdBte53tv1RTvn22pGw0BE=@vger.kernel.org
X-Gm-Message-State: APuU4Z+4fUmEh3vXhlD35tMqV55mUYeIIVZ05QtctXEYuBANESLijW1j
	9QSmEHP+B84VHCsV/Iwy4VX/6dvlwnCZtlP/slonELgDWhdWDWBCR6/H767qdNP2xqI5asSdnYR
	WfYQxX15VwFbyAk1F6eP4RB08l3XrhGA=
X-Gm-Gg: AYBFou33hI2J/YUWqhmsvzZUsf7NlU7VK+U/tSqQDNbIZ9LirugRiC0RPUP8UJo7Oyq
	gUqammalMQ46PlGlHoEPuUE7V+8qFI/BMAyFrP9HWZs6z3iAltVsu6RI+4xibgRQa93Mr8VQFJL
	E1cCq4o0UZuTFYLU159TIEO1vyiN9lLFUQ950Q6kBTYSxgRESS+JjFN+SnTxgEPqYr/tAr44beN
	4MRl/jWXIfM+00Ahej4sK0V9hp7Vn12WO6pJnct5mnEiC30M3FnmYLsRijUYsIN6EHerWKtHf++
	rbwwGv8L3coNgLhXX8FEVty/oiRvH7hDgtuXftnTY51y6TwqGUD9oZyPLY6HJskrm5CPZxGib8f
	adLtrkyBCMKucBWT79fE1zdwmla3AAPkFk28YYMfyQ3jofV3gzV/MJq5LwJQjS0oCEQ==
X-Received: by 2002:a05:651c:a345:b0:3ab:3f60:51be with SMTP id
 38308e7fff4ca-3acb7b52404mr37108141fa.28.1793787880322; Wed, 04 Nov 2026
 02:24:40 -0800 (PST)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Wed, 4 Nov 2026 05:24:39 -0500
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Wed, 4 Nov 2026 05:24:39 -0500
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Post: <mailto:target-devel@vger.kernel.org>
List-Help: <mailto:target-devel+help@vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:target-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: zhang san <shunsheng1218@gmail.com>
Date: Wed, 4 Nov 2026 05:24:39 -0500
X-Gm-Features: AclHuK8mKYrOLw55T5M7eaMYFOVlEhEP6K_xnwt_-B3_tP11Fu0SQdsrg4zyZZ4
Message-ID: <CAGTEBTZ5teYJyMk3o8-FZ897OsSgwVdFDpvKoKdfA9vR=Bi=-g@mail.gmail.com>
Subject: [BUG/RFC] target: PR ALL_TG_PT traversal can dereference freed LUN
 during removal
To: mkp@kernel.org
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

We found a use-after-free in __core_scsi3_alloc_registration() when a
PR REGISTER AND IGNORE with ALL_TG_PT=1 races a concurrent LUN removal
via configfs.

Problem description:

The function iterates dev->dev_sep_list with
list_for_each_entry_safe() while dropping se_port_lock inside each
iteration body. The current element (lun_tmp) is protected by a
percpu_ref_tryget_live() reference, but the iterator's cached next
pointer is not: if the next se_lun is removed and freed during the
unlocked body, the loop's next iteration dereferences freed memory
through the cached pointer. This manifests as a general protection
fault on a non-canonical address (list poison).

We reproduced this on mainline 6628e7d4c6b2 (v7.4-rc1) with a
KASAN-enabled kernel: a GPF in __core_scsi3_alloc_registration() when
the PR registration races a configfs port deletion. The reproducer
uses controlled timing to expose the interleaving and is available on
request; control runs were clean.

Attempted fix and design question:

We explored taking a percpu_ref_tryget_live() reference on the next
entry before dropping the lock, and releasing it when the iteration
advances. This prevented the observed use-after-free in the tested
interleaving.

However, when the next entry's tryget fails (the LUN is dying and
being removed), there is a functional tradeoff:

  - We cannot safely carry that pointer across the lock drop without a
lifetime guarantee.
  - We cannot obtain a live reference with tryget in this case.
  - Our prototype stops the traversal (break), which may skip later
LUNs that are still valid and should receive ALL_TG_PT registrations.

We therefore do not consider the prototype ready to submit as a fix.

We would appreciate guidance on the correct approach:

  1. Is stopping the iteration when a dying LUN is encountered
acceptable under the target core's PR registration semantics?
  2. Should the traversal instead restart under se_port_lock, using a
safe way to identify and avoid already processed LUNs?
  3. Is there an existing target-core lifetime or traversal mechanism
that should be used instead?

We can provide the prototype patch, KASAN traces, kernel
configuration, and test setup privately if useful. If a fix is
proposed, please CC me so I can test the exact revision and provide a
Tested-by tag if it passes.

This finding comes from an AI-assisted source audit; the source
analysis and injection-assisted tests were reviewed by us.

Best regards,
Yaohan Li
shunsheng1218@gmail.com
