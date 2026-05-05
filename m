Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D822744F
	for <target-devel@vger.kernel.org>; Tue,  5 May 2026 00:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777939877; cv=none; b=PA1lOS4iXv5Trs1JYxE6cxRnHZLnt4LP+KHJ66PzlsaXeevc3plCO8C6uySw5fEO3z9lixiwoeMPUglkheOl3nwgK8TKPf49Y6gMdtSa7dAr1bzfcT5Lfr5/d/bHFKLG5l0HU/TOHx8Ne7wepSoASMdLVQ7aFrxU9f/4rKCtZ1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777939877; c=relaxed/simple;
	bh=vtW70XD7sgH1la6jbceNOWaOTwUM5D0j2nHs+xlyJC0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tw2zLu3OopZQ6r0OBlmLEkmCSPH++GwW5CGSxvP30sgXQhpwKvC5z4rHEl6tMGZ1NlYSFIMBLwfsC90/iIZURvQiXCBOdlHGo2KX3DlTn2HoSehwLBHEtFOwemuffAWVSrjM3MGEfOrhH/82MuM8WyM88EK/AVoWtXyTJrXZRqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nRuKzQU2; arc=none smtp.client-ip=74.125.82.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nRuKzQU2"
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-2bdcf5970cdso3511557eec.0
        for <target-devel@vger.kernel.org>; Mon, 04 May 2026 17:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777939876; x=1778544676; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qd/krIT/1cSoLMMya0JMIdHmRHAFdBg2W/mBeQ6dU54=;
        b=nRuKzQU206xVMp9eAtUnNmf67sbnZD3+J4gjRs8ChwWORJVg/na9VF5gyQAWNFsbgL
         PziIm0yt0j5CL6A51C7Ew83GfEgCkXav6LLZoTOcplx7Gg0RK73z2U/Eb2cNP0HxjfQT
         9/OslOLk2syPVQVl0yyMrYXndfLmjcjYduXDlHcOSWtVlCni+g4gtTwrcn0IHTJg/udg
         5u16gb4dNSPwVpM/xCWBWUR19QB93nGiE8/5fMmd/x1Y06EL7Gmzb1q+pQ0pkpfELF7n
         7rm1fZYrXZPfS6siwyFXedgx3nTun+dvx4eb5xzSNDM3exEmibvKrW3JJziaSTWSmlzZ
         4PxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777939876; x=1778544676;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qd/krIT/1cSoLMMya0JMIdHmRHAFdBg2W/mBeQ6dU54=;
        b=P8k7UwKGy2VkoKCTR3hmo2U1ztkZ8QGN89d2kysillrj90F9k4Jt+yaWg/PJrhFIyu
         wcU2aufynEUqP2GOs/UO1110cAC6Vi3/M3K4Td2akkOb1HtrPlLwqmQrilMvYCIhqq+H
         DmNN1k7jc+o/bpfefK4YnnzhVou5sOdOROctrT+5myVdEmqWZNsFhGlYg2oS8i5fgdO9
         tVgUv0czt1hBwW/2dGbKnhJz//0KAkvsV/UfE0BG5Ww5er08NXIkTOB8hLZLAAspSsVA
         Td7l50oIPpm/I0dpFL8NFoBRn36y/2Zp6hHI2p3nyCF/DiwGZpjCYb2TyFrkhvIMksa4
         NpGA==
X-Forwarded-Encrypted: i=1; AFNElJ/ODyU8zmSsWzjgax112xc7ChWev3mxBzUlm0d+YuP6llWhs5VEhGWcTncIM6/ENID0k7LfUdfNw2WNZOA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxoBuZ1T4hVKXlm4BWZjLr89tabpiCV4Yyhqqt0TBq53uKDixMa
	g/DM8PWqnux7ElBc7gnhufKUDAp+QSaFzAKDnXBVcFp8DtSfE+F1was=
X-Gm-Gg: AeBDies2ZwXr32Cz7FWGDAfTt+KkTJQDG2vXegOqIMOeYhZzqbEkVAE7NZDMeMoPtaB
	ghcxUJ1gQd2VnNuIdMiNDF5TzcNvqQ3TCzZwEYNmVXzpDLPcfZukyjSIu1uXGgslOPbESaXxVa9
	A/qzj4W4tuTpKrkbqZ+3F+v6ODDoouHfsSdlV5b/tQ9mV7QnhNvxPSepTHyfGU2JPf8GuPaO7WY
	tMeqwnNK9L0i767V2QMAQyeOIuw0UDhUgEMaGQU7hYERkw9c/gLtC6veAxg5EyQSp2giTENdYo+
	zhEj6eT3mfm/ebh8z8C/q9jjfBG+JVbLANUmdAdj/fANVKEBgivSp4OoW2NHCNytfqaITDpWWlk
	5b9fC5MVrzEE8dK71fj7+p+KyzaZkyVix++oDN1avzds8A2C6KGFFihYwWz3MbGQvnsPctUWjKX
	7UZqam9nofrLyh/3/iHqBJ478hPoTUKt+9SjqlbhVqa84cGAYwt/XwrK/t+68rXUbYHAzsU5RXM
	CmIceEC
X-Received: by 2002:a05:7300:ca8:b0:2f3:b7b2:cbd3 with SMTP id 5a478bee46e88-2f3ce9f1febmr945308eec.5.1777939875407;
        Mon, 04 May 2026 17:11:15 -0700 (PDT)
Received: from [10.100.6.77] (LAMBDA-INC.bar2.SanFrancisco1.Level3.net. [4.7.9.202])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ee38d79eb9sm24529936eec.8.2026.05.04.17.11.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2026 17:11:15 -0700 (PDT)
Message-ID: <bdb04831-1c40-4744-a0b9-395b849127cb@gmail.com>
Date: Mon, 4 May 2026 17:11:13 -0700
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RDMA/srpt: fix integer overflow in immediate data length
 check
To: Bart Van Assche <bvanassche@acm.org>, jgg@ziepe.ca
Cc: leon@kernel.org, dledford@redhat.com, linux-rdma@vger.kernel.org,
 target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 carlos.bilbao@kernel.org
References: <20260504080036.3482415-1-sarajvenkatesh@gmail.com>
 <dbc57009-f563-4858-91f1-a63efe786d01@acm.org>
Content-Language: en-US
From: Sara Venkatesh <sarajvenkatesh@gmail.com>
In-Reply-To: <dbc57009-f563-4858-91f1-a63efe786d01@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Bart,

Yes, tested with blktests srp suite against this patch on 7.1.0-rc2:

srp/001 ... [passed]
srp/002 ... [passed]
srp/005 ... [passed]
srp/006 ... [passed]
srp/007 ... [passed]
srp/008 ... [passed]
srp/009 ... [passed]
srp/010 ... [passed]
srp/011 ... [passed]
srp/012 ... [passed]
srp/013 ... [passed]
srp/014 ... [passed]
srp/016 ... [passed]

srp/003 and srp/004 are [not run] (legacy device mapper support missing).

Thanks,
Sara

On 5/4/26 01:17, Bart Van Assche wrote:
> On 5/4/26 10:00 AM, Sara Venkatesh wrote:
>> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c 
>> b/drivers/infiniband/ulp/srpt/ib_srpt.c
>> index 9aec5d80117f..f66cfd70c263 100644
>> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
>> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
>> @@ -1129,9 +1129,10 @@ static int srpt_get_desc_tbl(struct 
>> srpt_recv_ioctx *recv_ioctx,
>>           struct srp_imm_buf *imm_buf = srpt_get_desc_buf(srp_cmd);
>>           void *data = (void *)srp_cmd + imm_data_offset;
>>           uint32_t len = be32_to_cpu(imm_buf->len);
>> -        uint32_t req_size = imm_data_offset + len;
>> +        uint32_t req_size;
>>   -        if (req_size > srp_max_req_size) {
>> +        if (check_add_overflow((uint32_t)imm_data_offset, len, 
>> &req_size) ||
>> +            req_size > srp_max_req_size) {
>>               pr_err("Immediate data (length %d + %d) exceeds request 
>> size %d\n",
>>                      imm_data_offset, len, srp_max_req_size);
>>               return -EINVAL;
>
> Do the srp tests from https://github.com/linux-blktests/blktests/ still
> pass with this patch applied?
>
> Thanks,
>
> Bart.
