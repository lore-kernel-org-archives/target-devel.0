Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8096D26B2AD
	for <target-devel@vger.kernel.org>; Thu, 18 Sep 2025 06:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758177118; cv=none; b=oDIBaC56PQYPYkFgXtQn7XQFE8w0PRmVH2dlJVY+yoKHDbiM2uRbv4Or68dYpKZB+BAnrzA+rlPHpc2kDnTD+2uArn9uBJwT7fI0EGxrYyrXpA35dlua1A+h/45xQsNG1A+GEwtFV4HaL5qC1YbACdXAfp5BO2adN5b7WT4qRI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758177118; c=relaxed/simple;
	bh=tqjjPOdw1Jg62QI2picFjWMRENrxDQK4lLxM1I25rxM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=kTuh0/p2BXGO33hROtzBorKGCzGtdPcqqYkmgFkCFstDNpn9FvcDN92eprrmuzzWtxBJrs/lY5AsEA1IC5+nq0oqIAkc8RLdk5eTXdU8lD5ddyBk3kh7MarIZhrgjJyOX1yFuk3KdAiDECpl5eTDUB71K5qookV/vD7CRgOVEqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aOA0K2pu; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aOA0K2pu"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b07e081d852so103443666b.2
        for <target-devel@vger.kernel.org>; Wed, 17 Sep 2025 23:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1758177114; x=1758781914; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wuZHOs6t/YVWP7jmWbtVeLQEg1XFgW/8IGgnj2m3170=;
        b=aOA0K2pupLo2ZfWQpd0VHrWNjfCrGpl1TocNbM7sdiHGl8onbm+/rkkWtWrW4Kl3gK
         YCDgmtEGMZrmZx3efr4tDu3Q37SuA775UBiSP7zpoer9G+jFW0ylE4o8bDHzymiPGNUL
         tvEADN6NSgFNQ4bq/EJYX08LuLtbnQcOcTKmg862i2qc9DzlkPXVfyd+z+RQCBvwUcot
         XVKdg8RUhg5JOoy+/3JnnqJenlh+HAomS5p01+pd1bEzNesCo6dzpaY7Eh/mPc53DW7k
         axoSn5aG7MaHbiBHVczgBGR3jWqlXv8eMsEOLP2qGCA43US4E76C8XusnVOxRS8tFjgy
         dxEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758177114; x=1758781914;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wuZHOs6t/YVWP7jmWbtVeLQEg1XFgW/8IGgnj2m3170=;
        b=GPyHomFZ/T0n8dNBq+iZfIXXFBBVRlurmEDWVSsW8oHeMHxkmZ0s8bh1lHJAxMxac7
         ljMhhJWFqgcAaodw/GLCVH6dzYP656pHcyrYG2ZeFozoh/ZvKqZ/hzcsiimwVP6xVfJv
         tvCEXijHO8uNre4VLa1kI/7qRVV+vMBeDwJaBYjjpyKS6AAPzXM22+K2DXRVuKC4/Zm+
         mp/uDYKN8iONy17aZxdU0WFQhcjwyw+3i0dh7IEPNTylVQOkidUXcaZbTOehASFimA12
         XeDEjA7pO5qM7Na1YTikG4xrCYpkJW+N7ty4NeBwN78bp36yoUS5qKl6O41WIgKQRDjD
         r3vQ==
X-Forwarded-Encrypted: i=1; AJvYcCU2kyRJKS/O14M+jgI6X976UQ5Cntns/b+KB4M9Vv1i0ogwcfLXNfKqNstDMy+XNeoDIPhj9pYcIhaYJAs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwtFb58pGgxFWOAqtT4K9t2LYiLMQ9TBZiRfoko9wZncke0YCpa
	3nFrFgNM626MlJx1Qh00WTbZbFRZsvCiLi0F/xcvtqb1LQvP6JbwCiHawKBgqvR93IU=
X-Gm-Gg: ASbGncsYCW78dbmKMSZ5+caTv1oAFGZEgLYDopjhrqhZ+KMegp2wYX3BycMcCE8oIp7
	p/CSsTOQDK+iBHythqRCoFmKKlMyCZk1QTHWv6Z3qBivp9wTK4CDBzgJpP3SkRCHLeYLfoTWWqF
	8sedkmIkt7bdo8ZSWNuYMRwpF8DWYC1e8P9UT4GjwPlXs5UqwpbuaCIWPPmImufW0qFFU602AJj
	WsWsGJg8HX39kLH9pL6rWlaWTlqeRSJRauiK6ANV5OOyysU4lwWZBbcO/6HpLGyfKjX2jbrwa85
	6dzx0IIb4KuUO/4ex3XSooaNdnwUl+ZIm5vm0NSinWsF4lGG065laO1VHpug82T02eK1kYPtmEd
	gHmfnPwiMbvZLX+Laj2AaYlSvYVpOaPU+leALDPManqNNyf4z5zQL5bhEcOh5VlBp6lDLbxW89N
	Ki4L4=
X-Google-Smtp-Source: AGHT+IHe3Y3NhYECl5dqTv+1NobzXta1+PjMpav0U21h4SQ5zBX4MEYc5XAYJUXjiV8ukv2wn6JZ5Q==
X-Received: by 2002:a17:906:c146:b0:b04:6bb6:c91d with SMTP id a640c23a62f3a-b1baf5089f1mr466145266b.1.1758177113777;
        Wed, 17 Sep 2025 23:31:53 -0700 (PDT)
Received: from ?IPV6:2001:a61:2a86:6301:7dfe:e974:37b1:d013? ([2001:a61:2a86:6301:7dfe:e974:37b1:d013])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b1fd262953csm125387066b.99.2025.09.17.23.31.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Sep 2025 23:31:53 -0700 (PDT)
Message-ID: <03e53a96-d94e-4608-b52e-bbd87b8a90af@suse.com>
Date: Thu, 18 Sep 2025 08:31:52 +0200
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] scsi: target: Move LUN stats to per CPU
To: Mike Christie <michael.christie@oracle.com>, mlombard@redhat.com,
 martin.petersen@oracle.com, d.bogdanov@yadro.com, bvanassche@acm.org,
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20250917221338.14813-1-michael.christie@oracle.com>
 <20250917221338.14813-4-michael.christie@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20250917221338.14813-4-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/18/25 00:12, Mike Christie wrote:
> The atomic use in the main I/O path is causing perf issues when using
> higher performance backend devices and multiple queues (more than
> 10 when using vhost-scsi) like with this fio workload:
> 
> [global]
> bs=4K
> iodepth=128
> direct=1
> ioengine=libaio
> group_reporting
> time_based
> runtime=120
> name=standard-iops
> rw=randread
> numjobs=16
> cpus_allowed=0-15
> 
> To fix this issue, this moves the LUN stats to per CPU.
> 
> Note: I forgot to include this patch with the delayed/ordered per CPU
> tracking and per device/device entry per CPU stats. With this patch you
> get the full 33% improvements when using fast backends, multiple queues
> and multiple IO submiters.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
> ---
>   drivers/target/target_core_device.c          |  1 +
>   drivers/target/target_core_fabric_configfs.c |  2 +-
>   drivers/target/target_core_internal.h        |  1 +
>   drivers/target/target_core_stat.c            | 67 +++++++-------------
>   drivers/target/target_core_tpg.c             | 23 ++++++-
>   drivers/target/target_core_transport.c       | 22 +++++--
>   include/target/target_core_base.h            |  8 +--
>   7 files changed, 65 insertions(+), 59 deletions(-)
> 
Ho-hum.

That only works if both submission and completion paths do run on the
_same_ cpu. Are we sure that they do?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
