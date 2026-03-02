Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF691A6819
	for <target-devel@vger.kernel.org>; Mon,  2 Mar 2026 21:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772485447; cv=none; b=CrsZgPhxVo0upUFgiKy/bRTdRds9G7lhE3M22HEx6lhU8j8oNAlsgLSrgILblelU94yIEWH13tqFfGirNaV/EvGIPZ65oHMEU1CasacrqUraq4odmuPfAtrYUlBgorX5PFq33NxqOv5oL+R+xASsHH9/9SBWvLhoitat+/2FMwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772485447; c=relaxed/simple;
	bh=UwKN828bpYjsATwe/PFNfBBgDEwwJJjZ3GciXwnOP1g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L4CI/dRwgsGF7x056EeFixNJwbk9oty0C5VE5I1OnlM3vIT0y9FSy96Vbbx12Hci7ggHkUpQf9MdTjgR+smyeQrXcDDY6rV4/20Atvwym0BGYh4p0I5Nm0AW8q/RKADtkVL4dXT4ON8wG0nYeibyZtjPZ3XLkVCRVhdNTPtGCo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Z4Bzo0Wf; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Z4Bzo0Wf"
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-46391f4c1f9so3414262b6e.0
        for <target-devel@vger.kernel.org>; Mon, 02 Mar 2026 13:04:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1772485445; x=1773090245; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UvIDDVWC3amChzTdZaAU+7HRWfu0rMD4zIP/5WJSg4Y=;
        b=Z4Bzo0Wf3G+d2z5kyswDxW3jW+NPZDiVyYZwCcqN83Y49dvLqgm1fj0D+2nh2e/7HK
         y8XgjjOFWG50GRCh2srXXbYtnH1gxt5oudR0awiokKqFJBqFV+75vqF0fXZcb9O37PzB
         ssP/XV05YlZsYh2QLF+rBPyBu9kralV3P1u67TnrC4Gq176kdbtB+q+Yzk7rNrtA2DyL
         JNxO+m04ssNNgDdJS5SdTjn5rlUQGzbyEPyhUWsMrh4R0eemKB2xMgXYGgCtad/ThjyD
         pZvO5pkjXBF07tjJWmuzdzaOoLCD/n7CQeuwzhnCm1zeTQbegrjQte7JAmiotc4r7I1y
         akRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772485445; x=1773090245;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UvIDDVWC3amChzTdZaAU+7HRWfu0rMD4zIP/5WJSg4Y=;
        b=YHSUWkecIztxxmpbngf4LZNdv6ZtRxmDbmOJCJaxhBpPI2yAYRLpNgMTv+DDCbYHIq
         /iyasEHzq70yiEqwPdKA9rUJm5Qbn15xUeKin0n04HoqCxD7bXaWcx+Px1/L7bFBk5mq
         2NFgYNCU6nNaBgP6C9oXqMtaMomV2c0AwZD2EoCZuHwpw7txuk+Jc1xqFAatmsw8cWNA
         zmGkb9fiXdzc3CuABio2+tCr8wMH+lBEm3bmbQyT78OXRnF5+Gmm2Uro6LIHncKzc+I+
         j/y+d4Uidlh4n6hJQtzbJB6ruHHvHiSF+UqYHaWGCBXdVwLXCWxesxLvX5jVHfXon6mu
         Kd0g==
X-Forwarded-Encrypted: i=1; AJvYcCX+tPQjEgqn4ydLWkbCH3h/UaB1b96jEbbm5pmY+HYSvXHnDJJfVj6aMucg2BhjkOJXtikS5UzRzZjZAxk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzC9jcJh5X/yjhmqyTuJ9g3ffPA+QKNcRM1mEazGSscqy2cz/fw
	iHu2Qja+sC3I4YrVjjO8qhNdtZoiI4lRACdoO8Huv/nNQrgCHlD7SDdHyS04jlpDkG4=
X-Gm-Gg: ATEYQzy7FVUsuxmejh+twfXNvmUMUlM6YLKIlXNb814avTM776UV/oPxufTMuwNtyfd
	9FzMzwkhvVHgT08njy8ZGMXLJBdjq/f/N96kZyRDobOhlzL1Odc6uz1aJA/X6GOxErRTTw3NadY
	mR6p096aSrPqYMc/KNrjYDF75F+fkcou3YCQerWkRooo0GP4jkkyIn70kA/W4PunZ2nTh0RTq10
	hzJTNwRupm9gmm1b1y3iF/IESSNEEdIK2xJT2mMPFhDTVb+Lxj/yMjMz3uZiOM7+v0FWPjbJf2n
	6BUNligrtmywsRuHNVTNczlmJW9peixPfKTB3oBEeeSleZQRhBUj0y1M7OraBtwc/TUTCuBQmRv
	OYaKjGQDUUfdFiOBeQ54DZm6euGipZuVU7HdiL21HectK12uqEHu/7oFbK7wjXaNEEfh2qviQes
	RY700Ix+mYrKsBQahaQDcAFflPZGV7h1ayUoryouNIUevHXeQLUlFuG28duucbYtomv+lMGk9qb
	PklVc0RUiekzCoWivT5
X-Received: by 2002:a05:6808:8281:b0:463:b4bd:5287 with SMTP id 5614622812f47-464be921973mr6434178b6e.11.1772485444663;
        Mon, 02 Mar 2026 13:04:04 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-464bb3ab302sm8292175b6e.7.2026.03.02.13.04.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2026 13:04:03 -0800 (PST)
Message-ID: <40e13629-aa4c-45ba-a2da-b7614961def0@kernel.dk>
Date: Mon, 2 Mar 2026 14:04:01 -0700
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] block: remove bdev_nonrot()
To: Damien Le Moal <dlemoal@kernel.org>, Paul Menzel <pmenzel@molgen.mpg.de>
Cc: linux-block@vger.kernel.org, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai@fnnas.com>, linux-raid@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
 David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
 Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, linux-mm@kvack.org
References: <20260226075448.2229655-1-dlemoal@kernel.org>
 <5b8c1811-c9d9-469a-b8d0-992814a11b9a@molgen.mpg.de>
 <a2993605-2cdb-42b2-85fc-b071f07af4c3@kernel.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <a2993605-2cdb-42b2-85fc-b071f07af4c3@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/26/26 5:27 AM, Damien Le Moal wrote:
>   > Is it worth the change, as it looks quite subjective if you prefer the
>> one or the other way?
> 
> I think it is a nice cleanup, but I will let Jens and other
> maintainers decide on the worth of this patch.

It's a bit of pointless churn, but I kind of suspected this was coming
when we added the bdev_rot() helper and now had both of them. So I guess
we may as well finish it, as we're half-way there anyway.

-- 
Jens Axboe
