Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793286946;
	b=ghSDdOkdlJ+vy9MIgxuXQS9uGq1nr9O2MO303taGnnQBTv3zBtPP21k3rpBnRDFTsu7T
	 SKEqXVWoyfMpCe2w31oGb5km5RujpeDyp2JypqQ8I+M2lbknY6ZtAHClhoqliz6aMxkLK
	 rAwgGmbTf31NigGixE0avTZP3bSj2lz/yoQ7rlgvelAg9/dHgnHQdVYlXxB8XoQmgpzJr
	 OOkUqlZrvn2/PvluwaXJ634LXCdkuS2ScwLi5neqLoXw92txGiHJLWWGt84CpT9qud/BY
	 mqYGI9Dny2xvlBUF/T0aEHU71GCVI+/EvAAkkI6oCPnM5GDtHYyPtPe1pJz1XxQ7SzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793286946;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=IPw0/BwW5p18oDLi2WLGpDus6SNGg/LLfcJaEGzwHNY=;
	b=Q76yd4E4LvDkemGfQvlEdQ1BdSpwkQBzGC/+lHzZCBfoX0cuKBpt2IcNb8o92T8VDc8W
	 +CDT740x9zaixdTOSHxr04/e+200RTI3ucIHstylmu6XUj2ZaQtSpOWyeIMEjyb1VFwy9
	 YA8rRGTI/IJXTU0wxeDgojnsBCbmHfy+3Z0Dm6RhMa8wYx5CahkW9j9WmmzgZRQuQh8dS
	 RLEWR7x0WUOktNDzm+ayweoUX0SgtmZ4fGHqs6egm5nyRR2vi/sK9Ao5+GllhPFwslYSd
	 jDv2kEilLB8ZQ/GGbdykFgIurdf1ZL746RVus/vzFw0EM7CvKErZjBoRJ0iAT/I9ZiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="YQyg/dT/";
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0F5606A31F
	for <target-devel@vger.kernel.org>; Thu, 29 Oct 2026 15:15:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5A0F5606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=YQyg/dT/
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a2072b9832so4508445e9.1
        for <target-devel@vger.kernel.org>; Thu, 29 Oct 2026 08:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793286945; x=1793891745; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IPw0/BwW5p18oDLi2WLGpDus6SNGg/LLfcJaEGzwHNY=;
        b=YQyg/dT/ujL28wE43zB9C71dKTfJvrpo1KO7D/jy0jgZk57/H3YiRCfnPIdlEjtefB
         cm9TH64FFLTV7C6TnCMnOyD69bLOmwueKLUc9AfG/hzzZqbDa49UOJllTF0SoFzz151M
         robsLl7IiNBMSLdqR4zpZ6WtNnotbqIHkq8A78rrWjUChIlyzIAsrH5AWqD9i/bb5KrZ
         puWCXXX+R5t56iuBpzEJqbITqy6+NolpzxgqagrHv9//AyxV8xI7MhWEOdrhukzfEDVh
         asADL3kyxGxBlSuRdtn4HdxQ2oJR+jbVezVHz7O6CXgyBbRhjhFg4tPIioMJs5PuVTI8
         UrwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793286945; x=1793891745;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IPw0/BwW5p18oDLi2WLGpDus6SNGg/LLfcJaEGzwHNY=;
        b=wEvZpRW1Ky4FSEAQNnFWx9vCKiN/Re0Yg40XeupSfoAk6HI7+TMBJXdg4D9yRKb+Gy
         tl3YNL+vyCqFqVpQWCV5Xx5S3EVfWF0rC0bt4bMSFRSzSUy23/Iv2WyFUjKvSZvCnUye
         SpLYo7NWCd+KEmcaLqKhCap9d7VhcDtJ/lx2g0RhbRvvLIEctvJrZyeoLcaSGmDCGDYE
         iEywY1bWoasVgDuAJgdJw33T2dIJ+d06+sRoXxsPx7H79Nj90W4+oIVGYN8/MV1kyk16
         4mGx/P9icy5N0pZfJEXUjmg4sCN17WIWZBHYu8mwTVv9iF/K8HUZJ0PK5p52JG6kqpDx
         Fp1w==
X-Forwarded-Encrypted: i=1; AKwUvByKsKYVjU0twnzIU12QQvwaQ7Hv+nJc+rEChq87QYdHBk8uCQ1j0JPGzyrJyywd/ziuBfEhBL3/0lxU3rQ=@vger.kernel.org
X-Gm-Message-State: AFq9FYJULUMrZiEX5IgfVyHhnXU9HF0Gmbsed8/t2iUncovxrbdJFaNR
	+Q9myWwZzKt12S8ePEhMr6V2ustiP0AuNwbnXlvkI4EGR36rcbN+5IER
X-Gm-Gg: AYBFou1FIkaGNm2eVDc70mCBO39z4pqaoJb40y9jMrfwlX/+a05wESi2dyNdBCYhunv
	nE2YGUu2v9K5nophJ0U9jqCswAc//L7pki4mcGTS+ssQAUNuP11xUBh3cNoBFmqTX5ZnahieXTz
	ix/0+RH3aNvL8Wab6eFeS16oOnx859NwUk1SiVPN17Dz96iFPtc2G3GaG37VU5Z1zR2NGZviu4Z
	ME72aLYf0zNXAOHW70Cu9hBZ9yRYwRVJDkwa1qAtla9XHkOwDG/bpUGCucrDU4eE+KilU2Uft0T
	sta70BF8vub7pOhysJuCa8o9NYGXYS7wP9306nxzSzJZlE6/Mb1tRJf2/ZrL7436uLq9DlezpNt
	swB1norR0aJ4HmT2fRHe1cMG6uhEjYtJa61/ZrR5KnyUD7jpaLsEK+r3XMxeYHQ1Ex6L8eRDIsD
	YD7pOMl4dHzEKGUMUPxhOuYAtISobJ5nZPg5rYjIm37yJTBWQiyJOgX0MZNBqCNNtpKANFRGNYO
	WaPg6A8wclAi2v1KufaBWa+3QrxqNtn40NFowc1ycMuWb3bn6mKx0/aMv8LY6f1dG5WkOCRaVtC
	Nlgqp3JXdYvny9I/TZdghnVL+7Cijf7ZgBvCQjzmNU4HMCWHKt3yJuruJAqNx78/3tKqqG6oNnv
	IuBoo
X-Received: by 2002:a05:600c:3e15:b0:4a2:18c4:61a5 with SMTP id 5b1f17b1804b1-4aa871e8bc9mr81472915e9.6.1793286944585;
        Thu, 29 Oct 2026 08:15:44 -0700 (PDT)
Received: from ?IPV6:2a02:810d:7e03:5f00:f9b7:8364:5700:ca7c? ([2a02:810d:7e03:5f00:f9b7:8364:5700:ca7c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a966a56abesm88595065e9.0.2026.10.29.08.15.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2026 08:15:41 -0700 (PDT)
Message-ID: <57e4f2c2-d692-4130-835f-e507574c7252@gmail.com>
Date: Thu, 29 Oct 2026 16:15:40 +0100
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Post: <mailto:target-devel@vger.kernel.org>
List-Help: <mailto:target-devel+help@vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:target-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: target: tcmu: Fix divide-by-zero in
 data_pages_per_blk store
To: shao.mingyin@zte.com.cn, mkp@kernel.org, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org
Cc: michael.christie@oracle.com, bvanassche@acm.org,
 linux-kernel@vger.kernel.org
References: <20261026195245337ktSXy9G17VCcXyw760g9s@zte.com.cn>
Content-Language: en-US, de-DE
From: =?UTF-8?B?Qm9kbyBTdHLDtsOfZXI=?= <bostroesser@gmail.com>
In-Reply-To: <20261026195245337ktSXy9G17VCcXyw760g9s@zte.com.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 26/10/2026 12:52, shao.mingyin@zte.com.cn wrote:

> From: Shao Mingyin <shao.mingyin@zte.com.cn>
>
> tcmu_set_data_pages_per_blk() only validates the upper bound of the value
> parsed from data_pages_per_blk=. Zero passes that check and is then used
> as the divisor when computing udev->max_blocks:
>
>    divide error: 0000 [#1] SMP
>    ...
>    tcmu_set_data_pages_per_blk
>    tcmu_configure_device
>
> Reject non-positive values, as the neighbouring max_data_area_mb and
> cmd_ring_size setters already do.
>
> Fixes: 08976cb548d6 ("scsi: target: tcmu: Make data_pages_per_blk changeable via configfs")
> Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
> Cc: stable@vger.kernel.org
> ---
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index 425ad1246a75..07b514678176 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -2524,6 +2524,11 @@ static int tcmu_set_data_pages_per_blk(struct tcmu_dev *udev, substring_t *arg)
>   		return ret;
>   	}
>
> +	if (val <= 0) {
> +		pr_err("Invalid data_pages_per_blk %d.\n", val);
> +		return -EINVAL;
> +	}
> +
>   	if (val > TCMU_MBS_TO_PAGES(udev->data_area_mb)) {
>   		pr_err("Invalid data_pages_per_blk %d: greater than max_data_area_mb %d -> %zd pages).\n",
>   		       val, udev->data_area_mb,

Reviewed-by: Bodo Stroesser <bostroesser@gmail.com>

Thank you.

Regards,
Bodo Stroesser

