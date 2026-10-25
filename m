Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792892855;
	b=fGzZ44vnalFaFWKccEcjrI4Cfnw2v1OTIQdpXeHOuYQ2jl0JkJ7lKCViBR5iNY3kR9lq
	 ygTPjRfg01MtiR4SD4/5e+yidRz+/BSgSP2QPecblYykRNLH/WddYNokKV2vRz+c3s47n
	 PJviz3cJi0KV1Pv1InMBnfoSaZinCE7XBkwWu2gCZCC3DXIlp9uvNIQW6thm5o8Elndy3
	 cBUbRMDDI8FinK2iIJT9HtFHNW8/ezbbWsFMlNzvefAepMjg46In1SQZLZF4f/amzgi6F
	 HPEn1Bzj5Cfbcs3kZsudk+KM77S86Rcy+fHYxAZIn5k4QOpV9ta3ObhvTSKdk2dR3hQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792892855;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IQf90Fr1RalRueEZp8ReRjoKdVflHnZWV+h6rhgdLt0=;
	b=HwD7pJ/hsePjdxaRh3SBSBxKbFYU3EF1AZS1cS1+b5t83eWJnZBjnCcnwESoUIXXfjed
	 ZToJ58pL7XcgJIpl2ujpFQoWYgr9WR+yHmFpCU4y62rdJQhU/WAe2/Ar662XMsRVX3Vgs
	 oawDhGbvbSXdlNZVipNgpEcsn8SJuaSw4MTsVQx019DV9nLUkwr+9hmhIzMWZxpUCqMrR
	 FoQ1QOJRU9MjB6KQTFaBP4fSrF8D7B1J5Pcx7TOtQDVY+Otqb2n9Idxf7mp374rKNSslp
	 Lq9z4Vb6E2QBDD1hpTr6iaqDWq7JdQ66LuyoL9xcqlPvHPPbfbl5CwIVYQ1VLn/TW/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	arc=none smtp.remote-ip=74.125.82.50
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7C6606A31B
	for <target-devel@vger.kernel.org>; Sun, 25 Oct 2026 01:47:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CE7C6606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-1931ff67a29so4026706c88.1
        for <target-devel@vger.kernel.org>; Sat, 24 Oct 2026 18:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792892844; x=1793497644; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IQf90Fr1RalRueEZp8ReRjoKdVflHnZWV+h6rhgdLt0=;
        b=o2UWtj1296BSHQ/u/6Ehf7EmeG+tCGM9noKdhbkd1+gqIxX5ZCzGJc2/vZObhDCNWS
         iCzFnC8RaSYazTwUjDjTT7yV6neSMC8ZffOk86YWle/3DEePiazSKSGC8LaR/tU/xbn3
         q4wirtVEhraNnHrW4NL8tXb1AlR0SPyi/P49NiHq+mPe4Of0gW0UvR6wLwFC+x3dPPBw
         YhKY5gjrScIVF9yzrvzcLHRN9US7WODXvKStReQ/FJ5NGanEMdqOf8IpMrKpW+ySI+qg
         A1Xi/0DTUQtFivHXdx70LPoUT2KADDlXuVYfiaN8BUX1Fy/ALxZ+UzChGq7ktVsSRQKu
         aSXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792892844; x=1793497644;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=IQf90Fr1RalRueEZp8ReRjoKdVflHnZWV+h6rhgdLt0=;
        b=TQxkQU9lFKTyfFw5idX5Dc6v1Oda+CiBWt9XfjHYQlccGCEbJnDHLa6FPlwGnrmZH8
         dUgPr9T1aJ+z7aMAU2lRJkFNp4ZentZYrwKnOD1iSKkglWLT3CXzRHJhF5R87y/CxJRx
         j/1D9nlqlf1akc8+fVR44hn+MvLvoYksfEUhtxvLbUlBlh7wJ8fub/W7eonuf3l4QAvM
         ytGJ7dhOqysQJPxJm6/zHIaswctoCmj0TR3iKIHeLHo1Zc50Qpljrtgp9IjhOAml23DZ
         N3uG+Vr1y4ROzQ35hbf9HlVXUGsHm+tKhMGEumYQ92ZVUyG+YzHR5MyGM/T7qpYOMUba
         J/YQ==
X-Forwarded-Encrypted: i=1; AKwUvByy4s/BDmuvn+1t6z4n4fPr7f6xResCV8clpCogadcs11k1KxI0gisGbQnrysJP3eMtRS/rp8Ak/xQUPWU=@vger.kernel.org
X-Gm-Message-State: AFq9FYLzAUn816UQ5qEhNmbaOicFwzMk3k9xRKFR/p//NtT0HSmvPcFF
	4+1GYPAiLnfj+41bbtxrDOyc4NbNYBP4R1qOJND99N7Rbby5I8fo6S0/yy1FJofbLGU=
X-Gm-Gg: AYBFou38qM31wKz9Yry2MEC7DAs52Bnc186gD1OkOi7kiD5lkmOCCOKR9N+wZWP+Ge9
	SG5krklB1SWGfqQ5jR6RUiC7pmimGF4oJHEYQRtlkYZoxDsSgAhiwWfpCJcmspzymg1CVGhJhU6
	G8AjYQbTABtnwyALUp4CESnez0vlIffUlRueNzLp815V1Md2zXS3NfDfwDg1uly4khmU1Hvk/fT
	XOyamOSzzKnrKFAgj1i6FgSJ75WZzmzv9hQuBpC/B7aKquM36UukFhfGLjw5rqvM1L7C4GGTvwa
	KX56nyqRz/cJJjA2KbYTqFOsGXUxC9h4KeI897ed5bKJ8LXDwOW8c6F/c9VoZ69y25zIoSsEC2L
	qBKZIhVmV0b+mMyBPTN66idDppu/PsxbnAmpJii3HE/f0j1MLsf0t0jA3JJkTkq/DJ2tJDMMl5u
	2NndJvNIgpoMYnU/3zCK7J4418WoMLnj7CAhcsbBcaQoPwcILdXIdFFvZKvzF3WSjAoE/ug+ZqW
	CBz38G6AGGshztGOwCtGLL04gcYt/FIqunHORAn9W1LZ7tgeP/AvzXfWdzViIJfD/WeHcfvjVPE
	pie3FYh8l0JFIJP7L1L+5aEf1wTBbrdMVK3LdsbxN05usBs32/sbdAFFoLzmLinHfQ==
X-Received: by 2002:a05:7022:3f01:b0:19d:255d:1767 with SMTP id a92af1059eb24-19d255d1787mr1959370c88.20.1792892843907;
        Sat, 24 Oct 2026 18:47:23 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:dba3:be57:a674:a67f])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-198a2a5a515sm10149517c88.19.2026.10.24.18.47.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 18:47:23 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: Re: [PATCH v4 2/2] RDMA/srpt: widen the indirect RDMA context counters
Date: Sun, 25 Oct 2026 10:47:17 +0900
Message-ID: <20261025014717.3756503-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <75465b8f-1109-4a83-84ab-f4b464f187e3@acm.org>
References: <20261024162852.3528224-1-yhlee@isslab.korea.ac.kr> <20261024162852.3528224-3-yhlee@isslab.korea.ac.kr> <75465b8f-1109-4a83-84ab-f4b464f187e3@acm.org>
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

Thanks for the review. I carried your Reviewed-by into 3/3 of v5.

v5: https://lore.kernel.org/linux-rdma/20261025013748.3755639-1-yhlee@isslab.korea.ac.kr

Thanks,
Yehyeong
