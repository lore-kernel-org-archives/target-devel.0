Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21A24C4332F
	for <target-devel@archiver.kernel.org>; Sat, 12 Nov 2022 13:59:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232841AbiKLN7y (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Sat, 12 Nov 2022 08:59:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231404AbiKLN7x (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Sat, 12 Nov 2022 08:59:53 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA2B17E32
        for <target-devel@vger.kernel.org>; Sat, 12 Nov 2022 05:59:52 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id f27so18469079eje.1
        for <target-devel@vger.kernel.org>; Sat, 12 Nov 2022 05:59:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MP0typv1BrIlTtzXhHjSjEaPyIzr12QhqVUV9yyq9VA=;
        b=BjV2h2EKCG3Wh5RbeGgbzZHfarzO8xZaz/Uspw7sF2cnLS8rQm0/zXeReBQpdR6e1c
         0Ny5GvtG6CSGRZ8ijcLh/XSeYQi95qjPv90qVpqrQGX/fXEAUWeGqzt+qQoFUR7XjUBM
         p8V/V7qhmNe4hpdhBCRnoZaVd/dGUSFbaoF5sxY5YsdYIUWT9cWNFIOWH7ZuCjbh6vYv
         cYGobBYiC/ccXC/irlWt/Sj7MP6PGMUCNoa5UmtAUJrvwopZszZbGhssbfh7HWFicabR
         ZJbkD9TC2oKqnBmjhPK1NWsmOavhfw74hMc5soADt+F7WNwPZ/YsyfSvAbYbD6XO393L
         926Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MP0typv1BrIlTtzXhHjSjEaPyIzr12QhqVUV9yyq9VA=;
        b=PIMLS0Sohgp4TBr65rPWHT6ogrW6fmKDvg/NSvfMsink1zbUVPk1AxX0fl5YSh+0eY
         MVSB5rHpOUlGaZIoRqobEZB4NjLpSztB0FjgQDVgyHnQWr5Yite5fWblIxFKjzj4oR1b
         Y/qW/psfDFEXL6dquAnXIxQQI2UPbg6/s27LtZN6I2u7qSlOm+YYsywQuUBYy4Kua2JS
         waH0RYHokY5/VNfE1SCa2CyIDm9gRHtQS7W/RaU6C403MOWrtpFCCrqWoxhLBxnn8zoy
         AlP6ufEM0aR1Cw3xF56Us/1abmhF7aQEo59G4V3Nluw4x02pPkIpb641j3LzV0VtR0Ff
         5bbg==
X-Gm-Message-State: ANoB5pkCZFzf8ez0MMaRlONggieE9zQHbu9PPlpRx9UjZHwUQ+appXdK
        NZd2HjgKufbQc31GLCwFUOg=
X-Google-Smtp-Source: AA0mqf5A1wjYWfUz1tE0ya0kzwztk/s/Y1pt5yzL+amkDUYhVfrGigSxtfS6p1icRa2oGZvu+kisFg==
X-Received: by 2002:a17:906:339b:b0:78d:3862:4488 with SMTP id v27-20020a170906339b00b0078d38624488mr4930748eja.683.1668261591002;
        Sat, 12 Nov 2022 05:59:51 -0800 (PST)
Received: from [192.168.178.40] (ip5f597b78.dynamic.kabel-deutschland.de. [95.89.123.120])
        by smtp.gmail.com with ESMTPSA id i15-20020a05640200cf00b00463c5c32c6esm2341023edu.89.2022.11.12.05.59.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Nov 2022 05:59:50 -0800 (PST)
Message-ID: <e07f0fa5-d59d-36f2-d99b-73e32af3282e@gmail.com>
Date:   Sat, 12 Nov 2022 14:59:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: tcm_loop and aborted TMRs
To:     Mike Christie <michael.christie@oracle.com>,
        Maurizio Lombardi <mlombard@redhat.com>
Cc:     target-devel@vger.kernel.org
References: <CAFL455kjQeqvPqd1CUqs7f6xUjrrDqR1h7edizusAtj130HCPg@mail.gmail.com>
 <caad6a7a-c30c-a3ac-7932-f5a19c877ffc@oracle.com>
Content-Language: en-US
From:   Bodo Stroesser <bostroesser@gmail.com>
In-Reply-To: <caad6a7a-c30c-a3ac-7932-f5a19c877ffc@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

Hello Mike, Maurizio,

Even if we couldn't yet find a method to fix handling of aborted
TMRs in the core or in all fabric drivers, I still think that keeping
the parallel handling of TMRs would be fine.

Tcmu offers a TMR notification mechanism to make userspace aware
of ABORT or RESET_LUN. So userspace can try to break cmd handling
and thus speed up TMR response. If we serialize TMR handling, then
the notifications are also serialized and thus lose some of their
power.

But maybe I have a new (?) idea of how to fix handling of aborted
TMRs in fabric drivers:
1) Modify core to not call target_put_sess_cmd, no matter whether
    SCF_ACK_REF is set.
2) Modify fabric drivers to handle an aborted TMR just like a
    normal TMR response. This means, e.g. qla2xxx would send a
    normal response for the Abort. This exactly is what happens
    when serializing TMRs, because in that case despite of the
    RESET_LUN the core always calls queue_tm_rsp callback instead
    of aborted_task callback.

So to initiators we would show the 'old' behavior, while internally
keeping the parallel processing of TMRs.

If fabric driver maintainers don't like that approach, they can
change their drivers to correctly kill aborted TMRs.

What do you think?

Bodo
  

On 11.11.22 22:18, Mike Christie wrote:
> On 11/11/22 10:20 AM, Maurizio Lombardi wrote:
>> Hello Bodo, Mike,
>>
>> Some of our customers reported that the tcm_loop module is unable
>> to handle aborted TMRs, resulting in kernel hangs.
>>
>> I noticed that Bodo submitted a patch some time ago (our customers
>> confirm it works),
>> Mike instead proposed to revert
>> commit db5b21a24e01d354  "scsi: target/core: Use system workqueues for TMF".
>>
>> The discussion unfortunately died out without reaching a conclusion.
>>
>> Personally, I think that if the handling of aborted TMRs was working
>> before the "Use system workqueues" commit then this should be
>> considered as a regression and the commit should be reverted.
>>
> 
> I'm fine with reverting it because multiple drivers are affected. I had
> talked to Bart offlist back then and he was also ok since we couldn't
> fix up the drivers.
> 
> I think Bodo and I tried to convert qla, but it was difficult without
> marvell's help (we both pinged them but didn't hear back) because from
> what I could tell we needed to send some hw/fw commands to perform cleanup
> to fully handle that case.
