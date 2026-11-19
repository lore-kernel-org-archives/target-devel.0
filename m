Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795094307;
	b=MfOHCM3+1Y+HLnjgeUQwqMKJ4tj47ucEKiVm3oEmSd4OsP3yeJCUgWXPAmJYoYEuKgG+
	 cengNF4ZKMsBrjIgVgacwj5bCuDIUrFJxVDE4/Sn53ZBeBuQGSkAjOKCoxwd9/PgO22YY
	 sB1p9WPJ9S3li8lNQ/z/bLRRcBpDQ9L1QeMnDifIp47mqi7wAmil1vCaZdyu3BfJiPW9d
	 zQPcJolTkQ8ezgFOChqOHSL1yLvsOy7i1DFZGI0I6e+j+jZekXxwV/+NJJ+jQcc0KD6Fa
	 FEQIQmlY3/EYjlU5FgkOsIiBHkSovtBa0Xd6y8cGwq6gRJUwDuL3blnWjJc1GPqeaYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795094307;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=lW0rsTzAv8g0kMd3ojP3+GnYyed/cwVnxWGi5+Nic2w=;
	b=XioU6b5EpPzX9rpXbWhlMU+IjmPxGUS75aR0z9zQ3uUehXapaPRG6gTectU7N4XelwQ1
	 /pg+QsovBTtz3ETlb+2NSLSnj50KmVgqq4/45rjvfhbFJb3mYwkH+jA04Snekis9dx/o0
	 E8DAGge3Z5UYWqRTJTBO4A5FARH04Lb3Koz6dUOp1cqqsBVYLQiV7UVec6DE7U1nzzwv2
	 OxRZ3HQBPu7ECuiVcN+Vvs5MThbio2qRs0dYD7rB5KVAQrwoyq64OXzTJxUanwktHqs2N
	 a2eL7gW4RKKHDNb28ZjbR78JGEseQ6WANpL0oEie4rb68yYcV3hT0WnHr9NfilP2/4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=PnsugRTi;
	arc=none smtp.remote-ip=209.85.216.41
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE054606A32C
	for <target-devel@vger.kernel.org>; Thu, 19 Nov 2026 13:18:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DE054606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=PnsugRTi
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3ac9f49b984so649514a91.1
        for <target-devel@vger.kernel.org>; Thu, 19 Nov 2026 05:18:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795094306; x=1795699106; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lW0rsTzAv8g0kMd3ojP3+GnYyed/cwVnxWGi5+Nic2w=;
        b=PnsugRTi43kd8Jc6wW0hk/YmUu0oNjvvRG1DQNje/m8SbD3TlSSeMEupfF4A15j0K0
         HHQbAEpzZbImTOgkUBPzUgfM2+34y+Z1Z3LIGfstav+IDG1RD4I2Cz0fIFwUVCFgap/W
         ko9db2jEwjEMacCCr6UIQxyv0rQFSJbLtRxjZVppSI41nq2x19GgjfGV/qPASE07OR6U
         1OppQBWCjSjSHcxZYnVd9Iq9hI1paPuJVUlegnwTpsZdlrGCng2ATgrKzd6hLmo89yy0
         gqeWEAFW62yKxK36qNil/zzi7Qh4eIVuAxFDAwaoe6Cy6S73PAL3j7f3kmooKXmhtUGi
         i2ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795094306; x=1795699106;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lW0rsTzAv8g0kMd3ojP3+GnYyed/cwVnxWGi5+Nic2w=;
        b=Svp/sdo5eAU7evxWNQexMLmPgJ56BrcKdLBCM6x5tAxZcru8QdbezoCXiBWdPbBdsE
         XaNXNzx9a189jMFOhbWBVvA6FGLBp920GpOfshe8gXNvH7rqB90FuRdAHImVGK84tTp/
         1lqSloArsu9+U5ympmlmMHF9sXAcaC0fhW5/HAGpfzxkCbYumZxa1r7tBOwoe2a/rLvC
         mldMMMGGMzLzXzQ5plgdnhnTopW2SKGhoxeX8EJriJJBswLLRIf/2//hKg4HnEaduxRV
         YzT5uYDHlX1aYUja4M+yVj0I8FOnsdGe587heeM6pTsPGoPvAnmrlmNaOyNg7ycnOqmr
         KHcA==
X-Forwarded-Encrypted: i=1; AL+hErE8LM896mSkOSlSS21ON3qJwz56UJCckP8bvG6PD20hyEYgOAMyZrl4MY90K7sY0XYm1ZmHMMterScxG1o=@vger.kernel.org
X-Gm-Message-State: APuU4Z+77OAwbuerwtp6xAHRKJjFCKEAhnEx5H3TzHLgZQLvJPnx9Idc
	G7OH3LvA82fdWJQpqP5S1PVP6CO11lXMFHqtpO6S6TOKjAzTaE6C6V5g2Tf2KSWfmSg=
X-Gm-Gg: AZFdTZcp4uxwVMhUy41+98NveJF9f+OYXU1FvQXRqZQ6TH++nC+zU6+in9zLFxfZq5V
	84cCLz20a+ehltA7uV/dy23A35LFAd9JoMTAkGeG2KGOLii2JXYAcDDusfUNlqumL/1563ShZ1L
	8Ks07QIOlzj81f160u4AoqeKC5+u0dURJ2ncGAuLchkbNS7KRxQEUXCylGF0XKxJ2VBM/oorI38
	Wv8+eEiGZaIl8aIzyWxlHvJRCRN1dJ8cu7RJpCcLRuSC0ye4jWW8VbZ1JVc4SKxPye+/8KBuIR3
	QqcbiSRnh3zANxlmcQw9SPeSHvx8mlneF+ss0gBD7tpdz0c0cm9VT2yN1EP5vR0qXrFVTO2cXER
	tSQvKKZNz4/GtIHXSzaclrWSiLP7lx/bSye8+B/MAUczOok0PAjz4ub6u1r3yDiqfZixKJphK3m
	3W1E/PFm7/CJHJj9DndNInzw1gEO+0gprgKbESPmDcoG7/3o/fT9GCj+/gZJLzHau0Py8cRpiVU
	dtmZWhb37F/b9reESJv77rnIMN8TmQGKFskmrq8JVU1X2bUA3M+sD6fVhGixCDtkGqUkKQ9w6I3
	d+9z/wTWy2Ngtesrubkydbhol4uRioDpZnfjDz7QHsxkXsjqMk0QFgILJ3mx2nCtzTdVB16wleD
	JyG0Zd3y3szdZgPXq6MgCgowmg1m56P11j3q2rQ==
X-Received: by 2002:a17:90b:2c90:b0:3b0:9bfa:72ac with SMTP id 98e67ed59e1d1-3b40a0e1cffmr734949a91.21.1795094306265;
        Thu, 19 Nov 2026 05:18:26 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:1076:1f1f:dde8:a816])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b40543eda7sm2794953a91.0.2026.11.19.05.18.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 05:18:25 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sagi@grimberg.me,
	jgg@ziepe.ca,
	leon@kernel.org,
	mkp@kernel.org
Cc: linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/4] isert: the commands the target core allocates itself
Date: Thu, 19 Nov 2026 22:18:15 +0900
Message-ID: <20261119131815.2722343-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261118211503.2526705-1-yhlee@isslab.korea.ac.kr>
References: <20261118211503.2526705-1-yhlee@isslab.korea.ac.kr>
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

This is superseded by v4:
  https://lore.kernel.org/all/20261119131700.2722108-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
