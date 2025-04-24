Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4240E19D07E
	for <target-devel@vger.kernel.org>; Thu, 24 Apr 2025 06:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745475288; cv=none; b=O4utbzKwFYcGiDcnvrtQrvSOE5rQ/E8u3WWAlM2kFonDm4XQ3T4pQ4ayS4ad7hqAbjePDvqbIwCUz+Z5L76kJp7oLFYffE0rAyXlp/qap6ihPJoKz6J6HEKYE3G7/Hy1yn4TpcKVxll2oyUmWQve8LbaAcCB+0Z4XjqOowUgaiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745475288; c=relaxed/simple;
	bh=ikZlhbwKTHjaNDw4vZfG0SZokKJ4sUFvzcUkdejt9Ok=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=p971iMQBql02xZkDcvR+1rO4vML0NmCwGimuKkOV67dvDf45S1fJiMWJlQgQd21KQp9MP/vGYjt5t+2M488Fo6ubUr6gfs9Vylk/3kEIuUDjNiZ4KPtPQfn1QYYJ1Pxe2i4doC73Z98vSZUOuDPRN2fqRbDTpUR3g2uN6nujI2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dN2c56vw; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dN2c56vw"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ac28e66c0e1so87000266b.0
        for <target-devel@vger.kernel.org>; Wed, 23 Apr 2025 23:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1745475283; x=1746080083; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FC7LE0QO/t68hv5Jq9QCAxCamjYGyd/GLyn/JiI3/KQ=;
        b=dN2c56vw4ZTOVKERBGurF+zV3b6VlahhZc0ONj3f/X/1X0I5m2rijFgQjKpyXQoFoj
         sg5B41XB0d2fwGfeYvNrs7C5C023kviOxxp8DSJ/IEPJijKwzc/gvsKGHGp5SdjpxsOw
         m4aUhNVFy4lJLsqDnGa0thZqbsrYiR6ZBYYbikwuGobDDyxFEXYrcvH5mg+Ed8khErUp
         oQcBDp7HcFEb9bmmv6qsoKFhIGFA0mOvbIyvyTu9wRppeDV8Y7q5nacvCcy2UieMD+q8
         35pLNwZKKUbjpqI1jc3vk+MJWCbz/oBsUa4VUxN4lIYU2+hOsT8HuU1Q9TgSQjGE2opF
         jiWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745475283; x=1746080083;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FC7LE0QO/t68hv5Jq9QCAxCamjYGyd/GLyn/JiI3/KQ=;
        b=F7V/KkjvLfwPALOtvA+apPaU4ua29TtMVwjrd07anKZpAIKjOjn/I+pxdpc6hvjCa3
         PE4kVx2q2qRyHjNr8IFANcqdZSdEgxAoiDQVYU+lKSGjjY/ZZqMpQ/lF12+EnWFwA99I
         epUPFL6xOeh5jW9tejg/rRlQ5SKKc7a9I3LaR3NojhJght3B/wE3yG58YCgw++kw/EKr
         IbfEet2hKjBRGYQxLJ5K8NjbU7uouNAD2jxMUtKRSMAzpVrjaDwf4j7PLKatLkc71nOz
         F+L+z54raSLmYCXC5PIhrQmqQJg7IbaduOs1d1m9T3b4oe4TeK3wfliWeHtovy583nS+
         VgxQ==
X-Forwarded-Encrypted: i=1; AJvYcCUd0dSt7kZsLs4EClYTtll4uMaVGPoBBu4eup7FQQ7KI6KS3ZJWa25gr/UhFWHrruYcwGoko7P1XfQlrv8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBcyme5MO9bqNNBLWz12iLjWEMcpxo3qjixwobMXIAXVwEljZ1
	aavxBBg/PBSWs6g8wVtBHRfOtjjpNYre/wc/OldInYyKvF0WzMwHTTy/Ap4GS3DwXTf2NS4b+oy
	RvyM=
X-Gm-Gg: ASbGnctrdInhQ15ZikwSeB2gGzsyjahFmvomSeR+PAypseEryrBVj6AvZJimiXun/lX
	awUPzsMu0UuywHJ4m12Qi4iooDhTf7wfJnI3pkLn1AWIifdBEd5Nq0EJHxQv8OD19Y1SNAIyEjX
	mznsSiFPRqg7GMGlrw4LZWKHlzcr8j7YltlKyanRyg4nr15svs5Wg1R95UXcVuY0aGW94ShmedJ
	RQhEJHBZeu0M2/q6xCEBu9VCMzQKoiIuk6a/6tTkqBkyDAczoxfqFi/NQUnLCFMUgnz+5UJQa+N
	hN40saCUWJ4XQIFdxctSK1hrjlsYCsZIb8SoEswdFftdV1mY9hDneuujxKDAPvQZo7IhkxJNSH0
	v
X-Google-Smtp-Source: AGHT+IEBYlBl1CDzg+KOpWOrCm6Q7eogybzfxFRvlWGQ3CGxlUHRr5ImO3LVC7md8m90Q9SDovihig==
X-Received: by 2002:a17:907:9801:b0:aca:d6fd:39a with SMTP id a640c23a62f3a-ace5744ffcemr125020366b.51.1745475283411;
        Wed, 23 Apr 2025 23:14:43 -0700 (PDT)
Received: from ?IPV6:2001:a61:2b7f:8f01:ed13:8888:df70:a3b? ([2001:a61:2b7f:8f01:ed13:8888:df70:a3b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace59830f51sm51667466b.5.2025.04.23.23.14.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Apr 2025 23:14:43 -0700 (PDT)
Message-ID: <801f48a0-53ec-4ef6-a507-3c73ba8acaaf@suse.com>
Date: Thu, 24 Apr 2025 08:14:42 +0200
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] target: Move IO path stats to per cpu
To: Mike Christie <michael.christie@oracle.com>, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20250424032741.16216-1-michael.christie@oracle.com>
 <20250424032741.16216-2-michael.christie@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20250424032741.16216-2-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/24/25 05:26, Mike Christie wrote:
> The atomic use in the main IO path is causing perf issues when using
> higher performance backend devices and multiple queues. This moves the
> stats to per cpu. Combined with the next patch that moves the
> non_ordered/delayed_cmd_count to per cpu, IOPS by up to 33% for 8K
> IOS when using 4 or more queues.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/target/target_core_device.c | 69 +++++++++++++++++++++--------
>   drivers/target/target_core_stat.c   | 69 ++++++++++++++++++++++++-----
>   include/target/target_core_base.h   | 20 ++++++---
>   3 files changed, 121 insertions(+), 37 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
