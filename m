Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794916254;
	b=ZzgnzDqPdaK1QVzg76IYqV512CeVFbSwqftWpmOn5z7y053kenRELxWS2WGZmmCKOa5q
	 YLI4Z9DQzUqKE+Y2jiV/Juf3VQD6OPVgMDL3GpAZ9GbrjSbmjLaGlXnGK6WvQwikKLnLj
	 Ahe3sKzoMl9XSb3fphYh93ZcXqW6Dlq3Q1c0+pwVOTQNF1Ziw98s6Dva+JPS1AgBBq7W9
	 Wlgo9F2RwW6oxexKdLTafQV7HHtucOTUWFVwyOgW6+AfXid5I3iwLTtMMt7gSr8QfROd3
	 juhwY+U9S7OHse/d90+Ufru/J5n4T6bLJ7gLPsdM4sZ2+HxSOt4MhxpSLtsjh/v14nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794916254;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=vox9UTwbHA3vT707I3aI3S7jFRVVZiEckXrdeJNrXd0=;
	b=HYfMj4b0au715ln0I7ollQlWDtsd5hN66NVSZgLuGaZBtsOsU2ZCYxqhPH7wvdNCJYhR
	 Uza6PWPx81CIsXqTO45/KUPTYC1VRJCNrylbPpyBFbs9383/C1xx6lHXkuxo4d6eQ4Cl+
	 vgdW21fCBR54yNFfARIUBk923ThzOdOpCVgq8C+Ry0mBkoBPYozl57dkGMkQ9gNAxxhaq
	 5CpQU4d2833LndpZLPUvSyTx+rt5vsSlToftz6uU46ECVdAUxL6sSwR/pfj2ifxDeKyfl
	 RqA/w0ffxMnwrFq/nzTXsZZqyW5NvbdditLKlYatgRn+nuSs+HPmlqUW5KO9FEuOKVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=T8sAbKSm;
	arc=none smtp.remote-ip=209.85.216.44
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FFA3606A329
	for <target-devel@vger.kernel.org>; Tue, 17 Nov 2026 11:50:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2FFA3606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=T8sAbKSm
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3acb11973c3so4224627a91.3
        for <target-devel@vger.kernel.org>; Tue, 17 Nov 2026 03:50:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1794916253; x=1795521053; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vox9UTwbHA3vT707I3aI3S7jFRVVZiEckXrdeJNrXd0=;
        b=T8sAbKSmnqw0foDwoe4J88XYmKh/nE0/+nZQKU39t/Rq3a9Kzm5WmmULo+Wtw5SnwO
         rNAiT05lr8OFMBtVKlkDoozNpq5TVnWVk42lx8hlW9j62ntNvPmwVMDuqwxYMb0FU43h
         GhEqQ9G0dkZvRn4aZTtFaVkSqav5z67WRcKkKQJYQSj8t4WpMGNlRAOuLg9e3oOs7hKM
         NSVtAE9dhQ6mDwQ6lY/kaZfUlLPGHWeiJb3cy+45BUjs+/KfOw+Aw6DD13bLPpyMnTuj
         QGJyBUd+QzoUD1phhN68QsZNRSwusVTL9n0up9cP5fLwZd7RAUeAmrTs1y6TbNjK7Htw
         O63Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794916253; x=1795521053;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vox9UTwbHA3vT707I3aI3S7jFRVVZiEckXrdeJNrXd0=;
        b=MsJQthx8T+KEKvpFmKDm3klKpP5f7taRzHnS/SXv6gEL7+eOVTxlESSC2G/ZlufGkd
         5r5y/C+dLGoC8Y9LeSLqT3YLBjSH9HtrfWk60rddpEUm2OQwGDLqe51CZQohmf6ybEFX
         wntdcmoxgWjhsGySRJJhiT2J23eVM/wfT8YH/Ih6YEnt97nJvRTVEmGE8j/HkqWl0ADs
         l13e3fZPKEYgDtyhAmAWbHQuGTScdapphtfA5Ay2yG+JIEiQtgJxnQci88ddHUl/Jr+E
         vQ2l2dw9CmF4Q2tqjaoknijmf6f6UAdVxD1kX7xmKqcYRm+BeHyPjMhdxnRMfEDIGN3n
         LT4w==
X-Forwarded-Encrypted: i=1; AL+hErHEq9YGJdiYmDXagA9K5cc8jdqThix0CdUtVnAd3DXpUCY/5bgr/otIIAvx4nrVN5MGII4EafIDSlx0adQ=@vger.kernel.org
X-Gm-Message-State: APuU4Z96AdUGW0nTwu6WK9frYCiccEEZem0SdCIiSgY4ZTc1reTix47Z
	p4i/ILB7ZZJLNsh+nhJG6rYdLXb6/hbYvnoIlXsxHMELovFkpY7vg7OxOj68rdrJ8Al71Vj1MI3
	O1sLk
X-Gm-Gg: AZFdTZfbcwDry6Q/7aG+r1Bm9rfAqbxrnFikhJjYNhUkm1HYLuu8XmYUsv1HIblSf4+
	SxVyTYoO+Ec6NCojt5ulr7OUDwSE2m2wu0kw4U5GIRG6vT1OwYYC8tHwlo8PyFehSxkFCpkrruh
	wFmMNNScXo762XjcJZqGabmbbKj5M5u9MJOJVz2NS2e/YJelpd7T7BFXP2s2dXbA/2gs60wjZPr
	2VBEEvPTDuJFticifdknKziqmHxI2BM6St335Ov4AfjO3fehvtxz40Bydet9eQ5/t4TkSd+8Zu6
	P5b1MmUKW9BfaJJOuJD3tJ/skIi0scK8B0xdYPPBFVs8wzgTOkFfyuC2roo3s41BmmgOiJ6JrLk
	gz07OvmaL/8GKDZWKBeBKj7zFTZFsRJEIXhKDaPn2EeyybXONukouy2STaz4kaQOFsVTs2jOz8Q
	Tp4YAV/L/3fh1vNl8UBiPXyt6N73njav0T7gm1C/uXXRaOdNkpgGk3prMCq9ji2xCk+u8b5l3x3
	i830EkeguBtor8p9yQwORpGRkmaR6iOOC63Xv24AAbDSO1I0zBzEbCGkaMzCU4vjn80wX07C0l7
	g+gdOCFal2N9nD/UKKqvh9vOzPEHXAO1ANA5BjGjg4RkleebArCDN12P7HbEWHdAdGjQEspKWO4
	XpIzt/oviqyKtBwT2t4w5dF3VOVpHVnHGYEYasA==
X-Received: by 2002:a17:90a:c88b:b0:3ac:9c37:9430 with SMTP id 98e67ed59e1d1-3b1b09e6a07mr13635182a91.21.1794916253425;
        Tue, 17 Nov 2026 03:50:53 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:73df:c7da:8e76:82c5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3abe8b263sm4173884a91.13.2026.11.17.03.50.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 03:50:53 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mkp@kernel.org
Cc: michael.christie@oracle.com,
	bvanassche@acm.org,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: target: iscsi: run the Time2Retain handler in process context
Date: Tue, 17 Nov 2026 20:50:46 +0900
Message-ID: <20261117115046.1955877-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261115121943.1446744-1-yhlee@isslab.korea.ac.kr>
References: <20261115121943.1446744-1-yhlee@isslab.korea.ac.kr>
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Post: <mailto:target-devel@vger.kernel.org>
List-Help: <mailto:target-devel+help@vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:target-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is superseded by v2:
  https://lore.kernel.org/all/20261117114920.1955697-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
