Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF7EEC4332F
	for <target-devel@archiver.kernel.org>; Wed, 12 Oct 2022 14:19:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiJLOTr (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 12 Oct 2022 10:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiJLOTp (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 12 Oct 2022 10:19:45 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B646DA452
        for <target-devel@vger.kernel.org>; Wed, 12 Oct 2022 07:19:42 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id m23so2006999lji.2
        for <target-devel@vger.kernel.org>; Wed, 12 Oct 2022 07:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arrikto-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=y6WWgZlY94ZnDKH76NNPqig9UEZRbMYnfacmmfF9pZQ=;
        b=aFPW8XHco6I1IxyYjB74Fv3u2yNXnVJpZGGpV52dEUulbqWAQzOe5UBlKgJcAhYp/X
         1mJ5Fm/6xWIcSvAoZALWn1jVIo/cR2AGUoLhI0hbgCpwzzIX9zb9VlxLqcJocT7azk6W
         g6pc/RSMYsXewbUOfrJrdq7LROCnPfz6T/2+PbxvZKDsO1VAN6k3vdDhk/GSq7IvzyJA
         cIQN1GAFszfPkmO/hE+y6UC9KFViALk1Ukk9I3o/7iHboukZggluytjF/yAkjpD71w4E
         V2ZvKkgWJZVzo4fCuDkNgCAQWNsuwcAcU9aujCNub0gCNXr24HLOI0aeDFDQaVhtv4JN
         PbxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y6WWgZlY94ZnDKH76NNPqig9UEZRbMYnfacmmfF9pZQ=;
        b=Z1EXKsi3KtaX6fYD2OrbCCurF+Dt2mXvzejIjI3YAGpWA7N7B/lG9FuXmiUlBJsn+L
         fCMNHL6VEgd+tnt5dXVOfJQiynl9w3ALbwFla/+T38/yZKHdeSQ0BG71Rxpowd80DlBA
         UaFoH+9Wc7RAD8B3EebhpSb8qmf3hHm4hU+J+RL8nHNGgDSpAOhUtuQIXD4NgyhyKXHb
         FVroUcEBdffHvoFHOa131216kcdnKwk+FigBoRvZ1T7IUcBm8RA/MBlcsGXof7fT0URY
         KxozFxPcAno9yq0jPFvP20w6pU7PhkrHxzJBLuuz3VxUDhcH2YvwXwC+XZrcttSND0ra
         u5qQ==
X-Gm-Message-State: ACrzQf3NSEcvsl9KJcH1BgphUctT/XCW5P82eyq/v+wOiQ8oeGpoBscN
        UnlrCnXrmhMx92rscE1i0BUOZ284BvZQyA==
X-Google-Smtp-Source: AMsMyM5IKxFIWbYfhYlSA0w9veQ4PLRvo0ekOdHobfYf/3fVniSgu+CSSyQzjihDbGVh5VSWh4sKwQ==
X-Received: by 2002:a17:906:cc5a:b0:78d:c3cf:6ff7 with SMTP id mm26-20020a170906cc5a00b0078dc3cf6ff7mr10242427ejb.383.1665584370870;
        Wed, 12 Oct 2022 07:19:30 -0700 (PDT)
Received: from [172.16.10.51] (213.16.162.108.dsl.dyn.forthnet.gr. [213.16.162.108])
        by smtp.gmail.com with ESMTPSA id hv13-20020a17090760cd00b00782539a02absm1372212ejc.194.2022.10.12.07.19.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Oct 2022 07:19:29 -0700 (PDT)
Message-ID: <0f25805a-cddd-51b3-92e4-032872cbc595@arrikto.com>
Date:   Wed, 12 Oct 2022 17:19:28 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH] tcm_loop: Increase maximum request size
To:     Bart Van Assche <bvanassche@acm.org>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20220929115504.23806-1-ntsironis@arrikto.com>
 <fde47e5e-119a-54ca-7cf6-5b58552ee2b3@acm.org>
Content-Language: en-US
From:   Nikos Tsironis <ntsironis@arrikto.com>
In-Reply-To: <fde47e5e-119a-54ca-7cf6-5b58552ee2b3@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 10/3/22 00:09, Bart Van Assche wrote:
> On 9/29/22 04:55, Nikos Tsironis wrote:
>> Increase the maximum request size for tcm_loop, by setting sg_tablesize
>> to SG_MAX_SEGMENTS.
>>
>> The current value of 256 for sg_tablesize limits the request size to
>> PAGE_SIZE * 256, which for 4K pages is 1MiB.
>>
>> Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
>> ---
>>   drivers/target/loopback/tcm_loop.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
>> index 4407b56aa6d1..6d7c3ebd8613 100644
>> --- a/drivers/target/loopback/tcm_loop.c
>> +++ b/drivers/target/loopback/tcm_loop.c
>> @@ -308,7 +308,7 @@ static struct scsi_host_template tcm_loop_driver_template = {
>>       .eh_device_reset_handler = tcm_loop_device_reset,
>>       .eh_target_reset_handler = tcm_loop_target_reset,
>>       .this_id        = -1,
>> -    .sg_tablesize        = 256,
>> +    .sg_tablesize        = SG_MAX_SEGMENTS,
>>       .max_sectors        = 0xFFFF,
>>       .dma_boundary        = PAGE_SIZE - 1,
>>       .module            = THIS_MODULE,
> 
> There is more that can be improved for this driver, namely removal of the dma_boundary parameter and increasing max_sectors.
> 
Hi Bart,

Thanks for the feedback!

Should I make these changes as part of this patch, or can I leave them for a
follow up patch?

Thanks,
Nikos
