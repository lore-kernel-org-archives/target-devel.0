Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84B92D2491
	for <target-devel@vger.kernel.org>; Thu, 16 Oct 2025 06:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760595689; cv=none; b=UDnf4lsJm6UMsHOMpzx5m5xH9HnXnz5p9Iku6Ldu66t8s2FCHfNRk4kDFa3+Pf6Cb4rBNR9pA8SfbI+wEwyVDnt7Ta9Q490gAWQsWb3p8lqrxsEGoqImUEC/L5MFoghpTb4hxXyZiUv4QUJorbYpAGruD2U1PMwgjiE1sbQq2VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760595689; c=relaxed/simple;
	bh=o+C8S8b7oye8fhDbrnRA7wHUYgIBz3uRNCDsuUA02aA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=irZBPLjqapXOStZ4us8WxeIyV7do/C0Kmlzo6uM+/ScMzaJM8+IIBRqtaph9cwiKYUJ1nznpA3J4PpNnKhU3YmNXhPeGiuE1NyEhA9OOTUyw9DfJ/gcLd6rP9wYa08koChVPO23Ql5HtLEg2UVUPmE8PdLYiHrq8GmqvhQdaz7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=I71EOZ04; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="I71EOZ04"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-471131d6121so1340565e9.1
        for <target-devel@vger.kernel.org>; Wed, 15 Oct 2025 23:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1760595685; x=1761200485; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qFFPvQY2xqGGVVhW4Pf2VGxOIDuwDnxKEVJCnDd5QpU=;
        b=I71EOZ046cnnEulJ25xEhq/Wk1NEC88Q+Sg1FVdyC8+OuZAqvJLkQDB2p6+r49syHg
         2xkc6xjUCALZpoGcTYqDXpEWAaBa3UIrK1TcgcKZpSdOfFpHKRC1sZdTiOPZST1dwziM
         g8Mgx9F/Qlys2fPHht8m7dB6DStXq9fW4BnuDXhnExDf9e03xLbAnW7In8y9YNtuNdmo
         8CHde70y+Sj45t80VHj8FIPYrAI4GNRgFUooKvooN3aZI6qNbkBTZSZ5zDpYUnhvzser
         RxkFWa5UBkeimv9QDNAV6q0Mo3ewCMi795gzaQXY48uzwqZmRyFLoo6RMWAsUtu5brZQ
         IoOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760595685; x=1761200485;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qFFPvQY2xqGGVVhW4Pf2VGxOIDuwDnxKEVJCnDd5QpU=;
        b=OwTNa0cKZNQM6E71FMEULfdN0XVX4D34G80QkQGMjKQ3KNdo0WX4kcw1H1KEEGAR5W
         xOfWIelLMGeD1y4hGCQEhjbTGR6EPEppl1LsvA4EHrYbKR5qcwAulrHWcNLCZdD3IbID
         MHveAlFgXMpD7M5ZZ+nBc1YPsHBb2zM2iwk+Jr1PlaCGdIyD0ynoBWzrmRq4m37XZsdi
         ok1tzS2y0zC6emRs7JKV1l/vdSgMaNFy4vMtCxlMG8YLZ5nWTpYFkd7WhKU7xPVTzRXI
         qK727Yo8bx39X7D3g4E7qKUQKxUzgJMO5lQY8dWZ9r/Kb0TfpLmageT/Bt/87UUmU86W
         Tfqg==
X-Forwarded-Encrypted: i=1; AJvYcCUZ6KWGToX/wm7zQLm7n4ioGjoPd4s6gi6SR/2RBFwPoI6ByTQP6vcV+F6jQYmKMVoiUHKpIP0gE87MQJA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEO8YCkqZ84la+a0xpxlhDvS2MsC55vHmgLPSnMuyyD1C6fVq9
	m+EbenLLzcv4IWbotXX9mthfE02s+15mJxPOTot5lI5wuXOwpkhJk3w65GPxlOjOnyw=
X-Gm-Gg: ASbGnctBfakAzQXWBzX5nO7Gvi9EBuK0TWBMeQAm0IUBt+/OCf8jDjLQHyDMZEJrYKi
	snHTZQFZxLyGvsCodtf4qsMHK09CubJGRBH9A856W06szQ8dQpWk39YfvhgR4Xyzus83vYK3Lix
	yzyyMCqPGVgdIPSoUVc4GML952oEfVYtWZ4/5NhTptkdyQD/idltt0koZ4DE2KY+hoMvHkiiSSq
	RuOIy9qtQ6B9M30N3P5pAmZBvs1RCtFBQzTDGN2yv1D2BFrH0XFsshllsLFN89hJmWJ1YtqYzwF
	T6OrsOkamqtRN7yWyb4CQoibSzGm71F+YyJ41oizkhyF3SG33ZrZy1kUIpoTaf6Z1ktzT4k64ti
	o5uVkeEW2vdwUS2+ERByyicVIiFAVs6sK6sGuSoXFdq1DUR0PNlqk3TTcBqiHKWJxRIBpRXSXQX
	5fAj+Jc7r+SMoFwuXap3nzfvTrFvzPY9ZV3XHdw59hxUJ0vJi5e+vOPA==
X-Google-Smtp-Source: AGHT+IFyLl64Z9ZQXCx7GLm69+tRgSLDxlc4avUVV+nrM/Oo/r23HX2yP3RYFyu7MD5qz9QY+1cdhQ==
X-Received: by 2002:a05:600c:1986:b0:46e:4246:c90d with SMTP id 5b1f17b1804b1-46fa9aa4711mr196979145e9.11.1760595684754;
        Wed, 15 Oct 2025 23:21:24 -0700 (PDT)
Received: from ?IPV6:2001:a61:2b2e:bf01:3c0e:50df:88:71fe? ([2001:a61:2b2e:bf01:3c0e:50df:88:71fe])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47114461debsm6657525e9.18.2025.10.15.23.21.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Oct 2025 23:21:24 -0700 (PDT)
Message-ID: <5e272360-899e-4f27-8b29-5d696ed53ab0@suse.com>
Date: Thu, 16 Oct 2025 08:21:23 +0200
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] scsi: target: Move LUN stats to per CPU
To: michael.christie@oracle.com, mlombard@redhat.com,
 martin.petersen@oracle.com, d.bogdanov@yadro.com, bvanassche@acm.org,
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20250917221338.14813-1-michael.christie@oracle.com>
 <20250917221338.14813-4-michael.christie@oracle.com>
 <03e53a96-d94e-4608-b52e-bbd87b8a90af@suse.com>
 <76ba1773-60ae-485d-a124-f2040bb07cbf@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <76ba1773-60ae-485d-a124-f2040bb07cbf@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/18/25 16:50, michael.christie@oracle.com wrote:
> On 9/18/25 1:31 AM, Hannes Reinecke wrote:
>> On 9/18/25 00:12, Mike Christie wrote:
>>> The atomic use in the main I/O path is causing perf issues when using
>>> higher performance backend devices and multiple queues (more than
>>> 10 when using vhost-scsi) like with this fio workload:
>>>
>>> [global]
>>> bs=4K
>>> iodepth=128
>>> direct=1
>>> ioengine=libaio
>>> group_reporting
>>> time_based
>>> runtime=120
>>> name=standard-iops
>>> rw=randread
>>> numjobs=16
>>> cpus_allowed=0-15
>>>
>>> To fix this issue, this moves the LUN stats to per CPU.
>>>
>>> Note: I forgot to include this patch with the delayed/ordered per CPU
>>> tracking and per device/device entry per CPU stats. With this patch you
>>> get the full 33% improvements when using fast backends, multiple queues
>>> and multiple IO submiters.
>>>
>>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>>> Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
>>> ---
>>>    drivers/target/target_core_device.c          |  1 +
>>>    drivers/target/target_core_fabric_configfs.c |  2 +-
>>>    drivers/target/target_core_internal.h        |  1 +
>>>    drivers/target/target_core_stat.c            | 67 +++++++-------------
>>>    drivers/target/target_core_tpg.c             | 23 ++++++-
>>>    drivers/target/target_core_transport.c       | 22 +++++--
>>>    include/target/target_core_base.h            |  8 +--
>>>    7 files changed, 65 insertions(+), 59 deletions(-)
>>>
>> Ho-hum.
>>
>> That only works if both submission and completion paths do run on the
>> _same_ cpu. Are we sure that they do?
>>
> What do you mean by it only works if they run on the same CPU? Do you
> mean I won't get the perf gains I think I will or is there a crash type
> of bug?
> 
> The default is for cmds to complete on the submitting CPU. The
> user/driver can override it though.

Exactly. And the transport can interfere.
But if they do the stats become garbled as the completion statistics
are added to the wrong CPU.
Can't you store the submitting CPU in 'struct se_cmd', and then use that
value on the completion path?
Then we can be sure to correctly update statistics in the correct
per-cpu slot.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
