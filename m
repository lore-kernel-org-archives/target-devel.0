Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795186898;
	b=IEBfxXwldjYFTuoxikQ77Uxa5WzkNEg0u2oCKHvincuxUhzzybzCiA/4lbkmfKzRaNv7
	 JujCqUb8wDuf/tDKFk4GXYELBOHrFwQu51UlDIXhrjBpNz9Px7B5ZiAUj0vUK2c//AvX2
	 eaQWL5GJQjfwLTwRBptcOopXt6DA83U5R3glCZh7DrBrzU1BigLruutsb+BuFte8eBScy
	 LyNRiqxkoW836yIVMELJCy8Sp1Bnyn3aymli9owOglu2dN4BykEyNDwMI0UqlpdBwRmsq
	 PJCIaBWi/npPg3ukwG3LENcVrwTAluV/YFi81yPQhvo60YH2ZDk3pd6T5tMC+C9oflA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795186898;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=a1raqnnGut4xynOxiwY0p1mw/MtwsmNrEMEfjzI9bPk=;
	b=DoL1F5lrcx2+qj233D1uBVIrW5JUQeqkAVJLGzxhA3bt7Vpp8UZcofvkhA3xVglgCv5F
	 pcsAWjlUKLuQppWovWW7iJZP9os6LYHZ6ER+c+bb1dZBDCPaM/VPkjRxN3ir0sbS9uArv
	 zGt/yvqLmkXFKDKvMrO4J3kCZIbgg70pND5sr7S1+NcfeLGUHyxMDMQLD5kTEEfxIUifj
	 LhUeo84psoEemoTGCaspCrs2Pw4mIu6CvyB70JyoGtpYzvxvMjocCWgB3obdtDRkpuRid
	 yESd+qeb6r+BCTxFE8HG1+keEgIZxbbeht0G8KK0/0gdPOrYHYEIUtAY0p1U5jbmbSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=nw2iieT6;
	arc=none smtp.remote-ip=209.85.216.53
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80DD606A800
	for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 15:01:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D80DD606A800
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=nw2iieT6
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3b405d8f1cfso527439a91.3
        for <target-devel@vger.kernel.org>; Fri, 20 Nov 2026 07:01:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795186897; x=1795791697; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=a1raqnnGut4xynOxiwY0p1mw/MtwsmNrEMEfjzI9bPk=;
        b=nw2iieT6zUVADY0ray39fHYzAT9kH2gz9FKtZKveuHZrNp9Gj7Da92sUF7KBEb3qm1
         8cFoW2kOr+coqqXW19d9xm3X+DegN6RdC4dyEATwvfqCXR36HgV5VAeodwl1p5P/2zcJ
         x5vtmdT3YkWZ2DxgeGRkn0GkUb9SYzXzOsvaexaXMR+qKvwcV4ELzk8wqReb/sKbhHBa
         ev9iDIAJHPyIQlURYXO+6r+HWBM2MsVMz+MZ2qAkJxFf9MQ7AxJbM1pjww8j8GeAjKFr
         0rHreAY/UKOpEmnCiRWOxOQ8bVTkbpGeGWjAOov0oc5RNKC4cR7AwQjhq4/6720izgd9
         jO9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795186897; x=1795791697;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=a1raqnnGut4xynOxiwY0p1mw/MtwsmNrEMEfjzI9bPk=;
        b=YM6jrPl8zA4tkHdcYrBDdUGuP/zusSjXbIe8cenb1Mn+K9JzVnOtR1JnOK+Pr3tY1e
         v6mgxYzbv7MFK1L5km4Ye7BVPLgSJwEnK6wg8S9hDCf2RkqhLV+j3ODpPfBu6LIEAIhm
         FptpGU/lTdR5tE2J7sDemxHFxKw6IHpr0dIPTT0uSBtbrIEac8SlQXljSoktJFbU65ji
         D+8BamT+N4s3omj5LzWPoW54NwkEj74eZEHTxyjWu8FNiL70W5c6LOWpzrq4q98tn71w
         XQl/NXLy77wH5n2c07O7T99ze/12qhv480hCdISkn8HMIajR5MZfC3d2PLPcmJ5nLYj2
         MJXg==
X-Forwarded-Encrypted: i=1; AL+hErE3KKsLhSFIUl71WO9wbpgHXIMY+H/sqHLpL0MDt/LpX0Dtrnn7JNhjCrRWrvkhpBOsWIrOKhYgHgyfj3U=@vger.kernel.org
X-Gm-Message-State: APuU4Z/2dZBSBzEFh/szSM8W0/ST6e+RKWXQy9Y5kXEN8FEJatl0HsVD
	BQutBFvfOegaQWBTI0TntcHcsMuZQED3PMwmqRf0NoRVaaQnBrimii7h+h/2XgCX3I8=
X-Gm-Gg: AZFdTZd9rJCOHBzuVGj5Cd8yVH6QpP9Nj8wTll28jBnO+qL/DNvwhtxhOzwF9SxThA1
	G3X+VW8kg3XByL0qx5WCnI3pcuFLS9l8IUVSOsUq4Zu+xSu8VLHPCIZNMnb0QLoxgOZhseKgJjr
	SH1xgdUS4vLe+TTm91Nd4HDmxIy6AfTFWund4LiVbxZmLPfjY4H9gpcyrbUANzDiY5XGU22y3Xl
	VqXJQuhpDHsnL9hga5D7BUb//JVFzEzul6DSaTuKZEisVG/vs0vzFG6gaKnvBLToPcEnFiLm7p3
	GVmWHYjEtEKEIisyzj8VYRUkdKucu2O/qEeJivGJKnQVKfqFp504FyNL4jR1FRKGkSE9I4bkZNZ
	u3ZGe6p8sdCGg8OiHmIxyI5tvqndTisR1eUV7bXpKA6EZVmMAl4z/OfGKf5qlwg0PjU6XJ5CJQG
	eTyZJXG4wV24Mk3foCrfw4EYtdPEJ/nAQ18sytEPDyfKfkjWMHfu0fkoUsNZdApy8S4zFMc7901
	f9iMrY8J4OVZFGb/qh88Yo1URs8xyZpEpre3eW3NBFG3IluULfOGYrSl+fIElbCRACElPion3qQ
	xD4sDOomiX631zzJikSZrMIKZhaa6wrtkTpl+8XOxylt0pJEuBrU05VY2vxnTayuYaYFrwqme+1
	+MXXanJantmBei+Q7AgiP8TbebZObtwyhPQV2
X-Received: by 2002:a17:90b:4ec5:b0:3b3:a6b0:8991 with SMTP id 98e67ed59e1d1-3b41c96180amr3266903a91.60.1795186897160;
        Fri, 20 Nov 2026 07:01:37 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b405ecb486sm7652978a91.16.2026.11.20.07.01.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 07:01:36 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org,
	Thinh.Nguyen@synopsys.com,
	bigeasy@linutronix.de,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: f_tcm: reject a short write data-out transfer
Date: Sat, 21 Nov 2026 00:01:32 +0900
Message-ID: <20261120150132.3128382-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261012154422.2436134-1-yhlee@isslab.korea.ac.kr>
References: <20261012154422.2436134-1-yhlee@isslab.korea.ac.kr>
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

On Tue, Oct 13, 2026 at 12:44:22AM +0900, Yehyeong Lee wrote:
> usbg_data_write_cmpl() commits the WRITE buffer to the backend as soon as
> the OUT request completes successfully, looking only at req->status and
> never at req->actual.  A host that declares an 8192-byte WRITE but ends the
> data-out after 4096 bytes still reaches target_execute_cmd() with the full
> length.

This is superseded by v8:
  https://lore.kernel.org/all/20261118124005.2428068-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
