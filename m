Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA70371D13
	for <target-devel@vger.kernel.org>; Wed, 20 May 2026 16:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296003; cv=none; b=S4E0xu4GzTrdG5MGMSF2JCNEjbTEs4Iv92mhARbdoCW+PO+62kPv94ArDwT2cktZ8aFG8AajB07PSpYFacWYPag/EKVDMxC8moeD3KnT/oVkdcixKvlYL5g18CSOx6tBDmd4eIWHV4SlmlAx3D3Y9R7Vfykmogo7iZ+dj5JS2zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296003; c=relaxed/simple;
	bh=++VV2z8DF9nYNXw7ZGVhPSn17Ap73p9EQBATvvZQOOI=;
	h=Message-ID:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KoeJ8Mk5BCiI1PEx1BHvG8NtnaeJ/Ucfn1dSJwvzuYxY0CGMo/bdUlss0/niaLsm491iO9BmE0d5R0cXEyTgA3djQSDFom8k+SFBiNsQ74yhR0s9zsXX8C6PAXYW5NxgSNwp6IqeZ0DqwWN2urvM2rWzReZJ3YwVeg8dGnxaINs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a88r0ebo; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a88r0ebo"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-bd4f8260e4eso1024451966b.1
        for <target-devel@vger.kernel.org>; Wed, 20 May 2026 09:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779295998; x=1779900798; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to
         :subject:cc:to:from:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uW1DWs6dLVxbMJbJA1XC7hMjjnFFtxpIrjpCj7Et85U=;
        b=a88r0ebomWrncpMAU1k1hVlO/8O9b5BTZsgHdTR7xyt6cnrTkR2xbvXR+pTYbUcwSW
         WFN1WCAOPyK40/TM3xPW/3X57uY4dVxOUZRtvCZZ3w00TIY8PSx34NloolnOs04SO/Jl
         +3UokslLUEu3svnFxjxH8ldUmJLhFePs9vjR3MrcF5pq+puw+z34DCUtmePCxDI1AZ+J
         NdyWr0IyUQl0XTFdm/2d6dId1G/eRwEJWOxf/1wb+PdCOkmqJyfIRcwkCJXU8fGHv9iI
         KQ4dQKerFnQT+YkpQ8NqDadATMvk6U2Khz8nfwyB+Oo1cVq6hk51af1v4NEuWln5j9uM
         QMWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779295998; x=1779900798;
        h=mime-version:content-transfer-encoding:references:in-reply-to
         :subject:cc:to:from:date:message-id:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uW1DWs6dLVxbMJbJA1XC7hMjjnFFtxpIrjpCj7Et85U=;
        b=cJct1ZMezsL3PqDTRj4f6Lla1N5iM1U+/6tn/58thHTWiguK15YwGRlJnDwpLApXg5
         Ii3RH0fSOwIZgW1r75QQx7XMS7BioP5ShfulFxpS3UIvZTnJk9dTQ9uHtrbOlnwL6qF9
         glarDmqta7qhPyTlYaEuTlxXudFqwjfoLjvhhEGF3R1iKD2z5xWRmAcKIbHHvJsrLdp3
         0roWbvhvruxX/CrKho7/KP+S+7Q1T1kOe6T8X8A3E5IzKrUAq1ttbFf0B2eMnmHtIV6S
         abTc521gE5JIo3jwzFcpuQxqIXZyItwjWkvugty0CWGoPMSb4HPZRQ6ZYfMUXHkkRc09
         BWeA==
X-Forwarded-Encrypted: i=1; AFNElJ+iA75rJt+G9n0h48jLILfGAARfc6hmdMJK8Pt4esWX775r7DWTe5GfXcfeZX/iRxt+xJp567FYq2EF5HQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5+4q0/iRvNdXsuSJinou2BInHEBnMy6Xx6oMe8rCRj1o0w+oc
	sTcsQvy0HV2BtuDngrVB9VfRCpPlQ1nroLuJYuN9BsQON8Grh9I4Uu/S
X-Gm-Gg: Acq92OFGjmXnJ4jESMp1hoHzr00c+vWaILz7di+ZL5Pv4pHnUlbESefPCz7t9BqksNs
	EZYfBa7P5TFL8k+9sbDSJZJ7ozwv7VLJmi5BKDVSxSvWzXVFJg37cUhLHdEBWt1WAaRb+hS2fmU
	ku7RUrfsKbFe+pkndaC3WNl2nLaUReRN9wCiN+VkoTLfrZQPCUI2zjteAyRv5XtcrB3lTLJ8UE+
	xwDG74ZVxaruehIqmRybpzeAHLvtYGqJLwjTzXWxPvJG9hU4G2yjlecPhiaen0PT/PGSQyxkzE6
	ZV01D+I2rtHEhR/CYJsW+UL6t/64JNOl9kUshP5vjFUWkmjmoye3xl3frn3prQeVjEsGtm6nYuW
	SQWmm5gnT/F9VS+3DmQaehW8GDvBNE/65N1tdibYOsxfI98T+rvbbciJXM3d0xXgvDZWKESfhJ9
	q7d/gbcHlkrgCfnD75bmvOFyNLCrpasybsfS/tTWwJjNjQRSIDmYJWP5iXddn5hn3/L+hLJvukl
	oZl5vg1nTS80HZP3/mAfLHEvq1fuWVRkClpRytfIw1aHDeehT2q9IUXA0ZrnNUon1mX9IbZf4BS
	YHfW9q9zNJgVoeqjZpDhJ+p6Pied
X-Received: by 2002:a17:907:d78b:b0:bd5:2c56:71a2 with SMTP id a640c23a62f3a-bd52c567250mr1328647166b.36.1779295997739;
        Wed, 20 May 2026 09:53:17 -0700 (PDT)
Received: from ahossu.localdomain (ip-217-105-56-94.ip.prioritytelecom.net. [217.105.56.94])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-68704a658d3sm1547636a12.17.2026.05.20.09.53.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 09:53:16 -0700 (PDT)
Message-ID: <6a0de6fc.2d57a604.3a8602.5396@mx.google.com>
Date: Wed, 20 May 2026 09:53:16 -0700 (PDT)
From: Alexandru Hossu <hossu.alexandru@gmail.com>
To: mlombard@arkamax.eu
Cc: martin.petersen@oracle.com, bvanassche@acm.org, ddiss@suse.de,
 target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
 stable@vger.kernel.org, hossu.alexandru@gmail.com
Subject: Re: [PATCH v2] scsi: target: iscsi: validate CHAP_R length before
 base64 decode
In-Reply-To: <DINMKOIB4PRJ.1Y571RHF6NAQJ@arkamax.eu>
References: <20260518121811.385350-1-hossu.alexandru@gmail.com>
 <20260518235040.48647-1-hossu.alexandru@gmail.com>
 <DINMKOIB4PRJ.1Y571RHF6NAQJ@arkamax.eu>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, May 20, 2026, Maurizio Lombardi <mlombard@arkamax.eu> wrote:
> There is something that doesn't totally convince me about this length check.
> Couldn't chap_r contain those Base64 padding '=' characters that
> would make strlen(chap_r) too big to pass this check?

Correct. For SHA-256, a padded encoding of the 32-byte digest is 44
characters (43 data + one '='), but DIV_ROUND_UP(32 * 4, 3) = 43, so a
legitimate padded response would be incorrectly rejected.

v3 strips trailing '=' before the comparison:

	size_t r_len = strlen(chap_r);

	while (r_len > 0 && chap_r[r_len - 1] == '=')
		r_len--;
	if (r_len > DIV_ROUND_UP(chap->digest_size * 4, 3)) {
		pr_err("Malformed CHAP_R: base64 payload too long\n");
		goto out;
	}

chap_base64_decode() already handles '=' by returning early, so
stripping them from the pre-check does not affect decoding.

v3 below.

Alexandru
