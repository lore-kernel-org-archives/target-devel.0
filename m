Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 070F5C433FE
	for <target-devel@archiver.kernel.org>; Sat, 19 Nov 2022 11:42:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbiKSLma (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Sat, 19 Nov 2022 06:42:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbiKSLm3 (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Sat, 19 Nov 2022 06:42:29 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E880993CF5
        for <target-devel@vger.kernel.org>; Sat, 19 Nov 2022 03:42:27 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id n12so18795280eja.11
        for <target-devel@vger.kernel.org>; Sat, 19 Nov 2022 03:42:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pc7bXqo8v/85/+FMt7Gx8ybdXgpsBz9kNHdDO8mFlok=;
        b=TYPmAB4KWiQ2H6aDg7gFIdkUDmC3JVB9vxraLmhVARcHLyLXPG3GNrxUa61VxLn27f
         5fbLnrOpVhbwn2CH5AGJ/C1g9Uh1x+AJW3G1I7x6Q/zuXQ4psHiiO/w6LxtZvVAKQlkU
         vpg49Fw1K5r8w1KWXggqUGr+Ygjz+tJ9TvjXJiJW2vPelkJUWZCR4Yz4+9NjA5tDBeEi
         jpgLNLSjVrpDENvuEW8RBMEc18IGuT9ieO685McILtjWqqRnm3KcOZd0UddLGtf/bWHE
         zGn6s1FVIe00YwZL1gihilmKTObWYE6zjWzAk8FZSSQt7FpOai5bAxtRztkM3pYHhqby
         3cLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pc7bXqo8v/85/+FMt7Gx8ybdXgpsBz9kNHdDO8mFlok=;
        b=4rUOjaJxK8PghvbzTW0V40lhdnSa/A/TSthz6tEDUERnk8vGVUPvzG4OExeoXPvUoq
         WCfMyMLKJ6YRT6TiCOMoy3QADzcltM4F4/iqQ6+O4LzZmOt+S5KiPPe3Qk91VXQElxpD
         qT4dUVA31T4Mj0YRXJNaNR67xSI/XO6mpGsSRzCQbABFMO4D16I7otOXy/d1kvhiEtt/
         zjezoxBn7ldkg8SWsXtrYmXt3stxSAStDwTEX/rEw4ToZQRr7qR2h27fLeViy8jcpNy8
         XetuQZbpGftTfLyPMukFcvDGBhtCeRwAQqwJG1YjgLC3vcKNkBiC3kVHBNCvLyqkVW03
         XNtw==
X-Gm-Message-State: ANoB5pkpCnTR9wbomHMcmmdcmVsrf3nSs5N3FfCyG+nVcI3UkjvvmWrF
        NtWuHWdy8xgC4JdAAjZg96E=
X-Google-Smtp-Source: AA0mqf7pGt99JFM4oeYqsPVr/yY5+ru8Bbs3W7WVR7STNxEpmmcsPaFnuHUI1fzq1rW70CaiTLFCBw==
X-Received: by 2002:a17:906:6782:b0:7ad:7d50:dec2 with SMTP id q2-20020a170906678200b007ad7d50dec2mr9710272ejp.37.1668858146340;
        Sat, 19 Nov 2022 03:42:26 -0800 (PST)
Received: from [192.168.178.40] (ip5f597b78.dynamic.kabel-deutschland.de. [95.89.123.120])
        by smtp.gmail.com with ESMTPSA id ss5-20020a170907038500b007ad86f86b4fsm2805472ejb.69.2022.11.19.03.42.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Nov 2022 03:42:25 -0800 (PST)
Message-ID: <fcae196e-7f33-dc99-9901-7dbdbb066879@gmail.com>
Date:   Sat, 19 Nov 2022 12:42:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: tcm_loop and aborted TMRs
To:     michael.christie@oracle.com,
        Maurizio Lombardi <mlombard@redhat.com>
Cc:     target-devel@vger.kernel.org
References: <CAFL455kjQeqvPqd1CUqs7f6xUjrrDqR1h7edizusAtj130HCPg@mail.gmail.com>
 <caad6a7a-c30c-a3ac-7932-f5a19c877ffc@oracle.com>
 <e07f0fa5-d59d-36f2-d99b-73e32af3282e@gmail.com>
 <2cf05339-bd4d-016a-0f94-d1f292cca97c@oracle.com>
Content-Language: en-US
From:   Bodo Stroesser <bostroesser@gmail.com>
In-Reply-To: <2cf05339-bd4d-016a-0f94-d1f292cca97c@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 12.11.22 22:46, michael.christie@oracle.com wrote:
> On 11/12/22 7:59 AM, Bodo Stroesser wrote:
>> Hello Mike, Maurizio,
>>
>> Even if we couldn't yet find a method to fix handling of aborted
>> TMRs in the core or in all fabric drivers, I still think that keeping
>> the parallel handling of TMRs would be fine.
>>
>> Tcmu offers a TMR notification mechanism to make userspace aware
>> of ABORT or RESET_LUN. So userspace can try to break cmd handling
>> and thus speed up TMR response. If we serialize TMR handling, then
>> the notifications are also serialized and thus lose some of their
>> power.
>>
>> But maybe I have a new (?) idea of how to fix handling of aborted
>> TMRs in fabric drivers:
>> 1) Modify core to not call target_put_sess_cmd, no matter whether
>>     SCF_ACK_REF is set.
>> 2) Modify fabric drivers to handle an aborted TMR just like a
>>     normal TMR response. This means, e.g. qla2xxx would send a
>>     normal response for the Abort. This exactly is what happens
>>     when serializing TMRs, because in that case despite of the
>>     RESET_LUN the core always calls queue_tm_rsp callback instead
>>     of aborted_task callback.
>>
>> So to initiators we would show the 'old' behavior, while internally
>> keeping the parallel processing of TMRs.
>>
>> If fabric driver maintainers don't like that approach, they can
>> change their drivers to correctly kill aborted TMRs.
>>
>> What do you think?
>>
> 
> I'm fine with doing it in parallel. However, the issue is we have real
> users hitting it now and we have to fix all the drivers because it's a
> regression. So if your idea is going take a while then we should revert
> now and then do your idea whenever it's ready.

I agree.

Even if my old patch fixes the issue for tcm_loop users, it does not
make sense to apply it, since the new idea would lead to reverting
parts of it. And with the patch we would still take the risk of users
running into trouble with fabrics other than tcm_loop.
