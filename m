Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795174346;
	b=gc1Yyw+a+u7ZjSq0yFUAffy5+aUik9zGowYcM9x+V2OhaMP9owXJrRxuT0fDmGHQQYER
	 O0oElhIgZ37ZvXxn5+JyxuQ5SBMMGoy9mrGy9zbndLfp8wcqDaorjwH4QebkdQArUjWgA
	 VjG4UejlIq54MMi0btT/hHKZ9RIzyOUJ9etdFV3GizOlvcn/msWJajT80T9bFuWskiGU+
	 C7ZGWFaVMZK52++uhM7nWXHMk8UeUTwzAPjatpiAslEm1OQbq2gyQYOqffyQ8Vncmunk7
	 ciIE9M4X9DRhpPtUN2y91MpKGYJ9nkXXgMswojdX2U3GyPXzWi5z9y3zzp31IJXBwZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795174346;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=rQ5M/egh3irMjrbocw1q9ggI+9luFCL+5wWsNmpgU2A=;
	b=0UUcQqIaWnaQmA9xNonoJxHL6eXvLaF5BNkBFIEofbGQnIJE7lRSO7XWLMYGpeo7X+KS
	 gPm2HeY8dXqvgsm6cdBlgiqHu2DOaCPMlFafNzCTpbyxCODYbRJerBbXXuowFpl9iPTnM
	 FHF/xBBgVaaWwvrJ3JYcI56URa2pnKSP7RucxZUzp2t8d/HXzrY945Zjd84VX8QB4bQPc
	 mxC4+N6g1i2bqCeWgZWE7raLeMX5QEBmgLnESXkJC7vxSrYviZg/fapcPUYRGgm2uOGPQ
	 oW7p91TBFn5nUNirl+2yKKFaEiwwsSN0kbqI++RaLzyvy3qUdmbYmc8GpASRmtumN4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=rHH5mBAv;
	arc=none smtp.remote-ip=209.85.214.170
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38D5606A325
	for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 11:32:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C38D5606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=rHH5mBAv
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2f052ae3c86so374205ad.1
        for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 03:32:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795174345; x=1795779145; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rQ5M/egh3irMjrbocw1q9ggI+9luFCL+5wWsNmpgU2A=;
        b=rHH5mBAvnCyf5BVeI/8RbDkS5YUknOHEdPZvIF8FKjxdvbbWZPbnhXk5b+fqIhITkh
         MXOj5OkHp1R/Gv8C1COn2AKCQfksjkdOn6H198NvlvyOBxsjEgiaSfeCbyHJaCF1PsZD
         2/p0QII9PkM/n8fgae0jCtGPMOoGxk0qHiBxb4rVLu+PvU+naG6XweH/ZAOIO+lonTXN
         kSeRC9HknBYJafcdmNytNF/iNVoh3LNLn0Xy8k/bjfK4R1g8Wn1Q+45qz0fA2W4OR+3n
         t0jAhND84haBEwfyhnkfY2S8kRCZOV85cPMqlY44l5E0ckcCDlY58PvEF0jTHtENXAsO
         weqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795174345; x=1795779145;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rQ5M/egh3irMjrbocw1q9ggI+9luFCL+5wWsNmpgU2A=;
        b=1Iq/DyXCYglxU1GOJyGNAXrYv8ySscJbHWElzas9QUE+bHuHcjvV7Rq8+cghL/zJOg
         PQ4x5VEZwrjWhsJyJ5RZFKK0Pyyh1YUk3KsqeHA0LDvtS70Vnuxl55rOaGlEsCsRxr0g
         uh8Jq5kNWkjoc6JCsEI/cu4JHci0L76NAtJQScNYNgYyBGPQlktTQHd6BLf+aSursx1g
         8aqTgb5bQdw2JtA+BepnHP2lH+N+IOCmvuMNsz5qoxwVdRbZvaLWsUXnXlj5c66w15//
         stjd0blL4sj8X/fJ+P+7xhAjC4MJeqkTxm4MbS2eCW+gMuy0wL4WAW02TPPDgfbdydHf
         dJTA==
X-Forwarded-Encrypted: i=1; AL+hErEBM9prCo9kV3/fjgGVwA2znK0Ep2hbnXnaMwmutQZbGMvr3eT/irlJXvx/SBHhPLdRtTTbCtEDceOjgnI=@vger.kernel.org
X-Gm-Message-State: APuU4Z8W6Rec9pad2HZAPqmMxWNy1wgwyTVhLDfRKqgGmgbXaC1Nb/Sr
	EBGoOKTX8mQV5eNBTcfEb07KbcVaEcFOqBtply6K4INe5tmrsTvv1doTe3bIxwq2ghA=
X-Gm-Gg: AZFdTZfY32h2IGUmRLCmQ/S8BjRwMBmysrsd1gF1prYLVkxrUAwNRdiLR29MD/KzNm/
	0F1+8MLnf9jn+0PyV9tvzA3hciN2e0eRni6XE66RJq8fmTEkPSKW9H/xHXn4E4VrrNRqwB6M/6L
	JoDB5uDEQob/lWUsmcVaJOQi3C1XpmDLVLdYdOz7UkH0Q1UobxHHmijQf+anQvA+gbUKWteW3Fm
	lYM79gBz/Hc/M+NyYk7qvslbWWyrtKIjS7Sq+s25i7zpMEAbRvRWiOiqMOtVRVg4n2Es1gyqNHU
	nmwQVroqp4RecsJBS7TWl3FtGSIX3jIJIUodnmuDPTQS2MjGOPBoNDwCN9kcMLFMEvFpjpYEXRO
	1iDn5fUVnha7LhhHZKve5lG4eliqHmCrPy2eA0bjwhoD0B1L9uWosgWC6sLQEI0S/3NGM8VOCUd
	cqQ0r+QDY2x04Wl1pU7Z8s33lXr6nbe5j8b5++ktpcSCdLZsB0PxjxqWUakRhPJcv4FKZT9qC1+
	ncYPd+bDvftpk37K6dUTUAbHwyzEtqVhLa8/h4NYOQ/LwFmBr67lCmacKlKp9JSr9iHdrXS+UwN
	303lMcpRYAsgu6fprNmnqJ/7bNwgasZbr6T91411EXCcpFBCm+8kB7tGGds5NC1ZsRrGnsYipOD
	zfvKynwEURGDJOeH+7tpmkmKh/2udChNkhlC2
X-Received: by 2002:a17:903:3d10:b0:2f0:2250:7abd with SMTP id d9443c01a7336-2f03f17662cmr28672825ad.10.1795174345126;
        Fri, 20 Nov 2026 03:32:25 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03ee848c1sm13247705ad.10.2026.11.20.03.32.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 03:32:24 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: nkapron@google.com,
	Thinh.Nguyen@synopsys.com,
	bigeasy@linutronix.de,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	benquike@gmail.com,
	linux-usb@vger.kernel.org
Subject: Re: [PATCH v8 2/4] usb: gadget: f_tcm: zero the CBW buffer the status path sends
Date: Fri, 20 Nov 2026 20:32:16 +0900
Message-ID: <20261120113217.3063855-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <2026112008-parakeet-unblessed-17ed@gregkh>
References: <20261118124005.2428068-1-yhlee@isslab.korea.ac.kr> <20261118124005.2428068-3-yhlee@isslab.korea.ac.kr> <2026112008-parakeet-unblessed-17ed@gregkh>
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

On Fri, Nov 20, 2026 at 11:55:22AM +0100, Greg KH wrote:
> On Wed, Nov 18, 2026 at 09:40:03PM +0900, Yehyeong Lee wrote:
> > Hui Peng's multi-driver fix of 2026-09-19 zeroed this buffer too; the
> > reviewer asked for it to be split per driver and it was not applied.
> 
> Why is this line in the changelog?  It shouldn't be.

Sorry, I wanted to credit Hui's earlier patch, which made the same
change.  I'll drop it from the changelog in v9 and mention it below the
--- line instead.

Best regards,
Yehyeong Lee
