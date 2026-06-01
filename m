Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED5F3D9039
	for <target-devel@vger.kernel.org>; Mon,  1 Jun 2026 15:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780326724; cv=none; b=iWZmGsz6fn51fuyRBFDkcEL06Orw3bWaIEw5uH6bICmoY6WcsD/y4f2y2kTVd9/Fu50lzjmK09z6yrW9U6nWJ9s3G7OYoMh5gx8EG805FnZmfVlY9bi8nYsddURIvqc2/8FTAG2i49iTnGM7wm8dWKuERRBGVRN6g3zHnofsYVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780326724; c=relaxed/simple;
	bh=rWpsWUuAyGs/DUr8UlR/ATk7uflqDoWzL2uxm0n2Mjk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CxND6hDsLxULjf/pgdkjcxbIml5hAt5cqMr1zvZI6hTL5ZJ6NNp+9KE++pdbb7XXxoO0qzdFs33HhKiwrJ3q6r963ZCqf2q/LjzheCHb3EGFX+AXBVC2ayW4wKevdelkLH1ymO1jfA8p6zybfr4I1cwKw3veSW8WceEABTQi1qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FvCz7+ji; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FvCz7+ji"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7e6b5737bb2so1442798a34.1
        for <target-devel@vger.kernel.org>; Mon, 01 Jun 2026 08:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780326718; x=1780931518; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BjUlIwGeEm+vNl4Jvgu18HLK73C6LBKofUsrM8OMYNc=;
        b=FvCz7+jiWMsNpKIe1biGsRCtMda3FAwj7FMGwdv2TvtA+okzJM2aSAkadNEkgOJZQE
         3iLB/xpynOMOovZ/TwI8f/hM6N0AW4DA7XUlJPRoZBR3xpUn+lDdNGUi7oRQ6n9vM2IO
         KgA8KjjuaOxcNBC+2m1BT+wQn6UFqTIZawkznOIao3STsFf4164OsOGJj7j8jyo2b1WL
         l5b/AWd3Xl9V3I4w9utZJHvCthLgESJdjAEfToajqWLu+4L7W0RDFm/eBXukBctk6/1C
         S78nRDCt6j+1Zf5y+5qcTq4KKhNulFULST9SDoq4Ua0+mfRB7pxt10pywPYyo3hUSVet
         l/5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780326718; x=1780931518;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BjUlIwGeEm+vNl4Jvgu18HLK73C6LBKofUsrM8OMYNc=;
        b=INfX9dipiD7MmSA7EqTEhHRz4+gqV4fcM1H5kHC715OIn9q0xM2QwkkluuVBSUvCwK
         LCl7wsAZ6ncrphblmnKrnOTFCIjOVHG5S0d3ZqHnPLHpqRSUQRSe7LukqAeyI5DFgwna
         w4kvZ74E54FwFd1WLhYySGfi1+A3qVybmT9T8Xt5kO1cCtmbJjP1l15C+8adh/KT0Yc4
         DPOkNoVYRTat2QFI8V3lHu/+92rkMAuj2OPpBqhcvaNM9Sq05lAucpEoxw8/I1JfQT6r
         TcVVbjfqK/lFO/8TLNeAD0bqM6ZIIc6MV2DHZmsDwbUrjobUEGLCubR3QDpoAa2izl4y
         QCfg==
X-Forwarded-Encrypted: i=1; AFNElJ9zaV+lvX1RzhjzvuKwsQ+hO2nPWGolYrjW/cQol1mbtOfgDEQFamZJ1SvqdZiZmJE49Q+UGP3OkjSyUCA=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywp6VJfhueKdlMoemXxf9UI+8BrE5EEDHPTsPsxldr1Ij9a39vl
	Y9YeWXf0dvPZsfcThXK1iJexx6EqHZ9sUbVA8Utfo/Occ6TjUn/iRR5qobWrow==
X-Gm-Gg: Acq92OHAiYnd7Uu+LamsDrn/nHeYUQ4/5zRpxfZ4T8mAcfhqY0XQfQ9zvGLTSweSuoR
	irM1Kto/6yWHKunmOKfpz0cL0ypL0EZSbc30rHRfu5y2JSerAD5ATJosmCW+YwKDhBAVjt6mzDO
	XsFbLA3NlKJGQy7Bg7VA8BdLQUoit2v9TURKfeLuV6nDPWbGHupZ4TpD6u+EIHGELm0ENqra2Ux
	LsNySAxIZ18bbYZfcJG8he/s4igr4Ji1znBobKPBsJQLI7RPTNqA7HOAHJJlhzJ0OEoS3R3y6KG
	4bsIuX6Sbhw7+8+EckI8GFlTJBUcCgv60AWk+S2rbkcmnrPCDjQnq3cu1br+iAKdp0Gg8EnVA+P
	prs1kUPoTedWDq+q+exELaQd2KBlSIfhyfNyuT4tF9tQoRI4IKywFTD+CRylEbV5K0evSWwhHmW
	FW4+R717PEwDUUJwd8PVv1WT2tle35TQKpAYiX64YyFFxrFYndmUYhu1ojV0lZYjoDWh5ZL+eFy
	6DNxicRCvYxIc1ZRVdItL8=
X-Received: by 2002:a05:6830:6732:b0:7e5:68ca:892a with SMTP id 46e09a7af769-7e6a1e76b30mr6788062a34.20.1780326718364;
        Mon, 01 Jun 2026 08:11:58 -0700 (PDT)
Received: from ?IPV6:2605:a601:aab9:5000:242b:bfa1:6aa7:4d01? ([2605:a601:aab9:5000:242b:bfa1:6aa7:4d01])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e695d4726dsm7671373a34.19.2026.06.01.08.11.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2026 08:11:57 -0700 (PDT)
Message-ID: <0a34e748-15ea-4bca-92a1-e42af023f111@gmail.com>
Date: Mon, 1 Jun 2026 10:11:55 -0500
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: target: Allow FUA if no write cache enabled
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260428203938.9738-1-stuart.w.hayes@gmail.com>
 <yq1340cfogx.fsf@ca-mkp.ca.oracle.com>
Content-Language: en-US
From: stuart hayes <stuart.w.hayes@gmail.com>
In-Reply-To: <yq1340cfogx.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/2026 10:43 AM, Martin K. Petersen wrote:
> 
> Stuart,
> 
>> Without this patch, accesses with FUA set will be rejected, even
>> though they always go directly to the media when there's no write
>> cache.
> 
> The spec allows this. However, ...
> 
>> This is needed because EDK2 FAT filesystem code sets the FUA bit when
>> writing, regardless of whether the device advertises support of
>> DPOFUA.
> 
> ^^^ that is clearly a spec violation. What is being done to address this
> issue?
> 
I've gone through SBC and SPC, and I can't find anything that would 
suggest that this is a spec violation.

And, not that what I think makes any difference, but I don't see the 
point in requiring an initiator to check DPOFUA before setting FUA on a 
write that needs to go straight to media... why not just set FUA 
whenever needed, and if the FUA bit wasn't strictly required to ensure 
that the write went straight to media, who cares, if the requested 
behavior is still provided?

> Also, wrt. the patch itself, please see:
> 
> https://sashiko.dev/#/patchset/20260428203938.9738-1-stuart.w.hayes%40gmail.com
> 
The AI review suggests moving this fix to sbc_check_dpofua(), so that 
DPOFUA behavior in the mode page is unchanged, and it just silently 
allows writes with FUA set even if DPOFUA isn't set.

If there's no objection, I'll submit a new patch that does that. The 
reason I didn't do that the first time around is that it breaks some of 
the blktests that specifically check to make sure a command fails if FUA 
is set when DPOFUA isn't.

