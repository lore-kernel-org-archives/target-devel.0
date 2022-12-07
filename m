Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE231C352A1
	for <target-devel@archiver.kernel.org>; Wed,  7 Dec 2022 10:30:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbiLGKa0 (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 7 Dec 2022 05:30:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiLGKaE (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 7 Dec 2022 05:30:04 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 208DC2CDD1
        for <target-devel@vger.kernel.org>; Wed,  7 Dec 2022 02:29:06 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id x22so12828880ejs.11
        for <target-devel@vger.kernel.org>; Wed, 07 Dec 2022 02:29:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arrikto-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QDgZFThaTBg5nGvePgrnjGsjIT5tjYJPsExiCCA99pc=;
        b=WjCrH2UtlIhUhHm4ro6amlardDqyRQEINuyHqaylevC4X2zjumycn7qy8NLptpsECM
         oxOTGPCXXUwXuPJwuVXpLRcvWIFLPTLXO/e2ntfIbu+yl613KAQlu2NSyFOqFEo0co4v
         h5+JV+3mNFxcdSuSaGPpWj1W5JAQ+o+x76ou7FH3AFk716Ja95JWjvtc+F9wjuKNkhQU
         bDG24k+/xe/r65EPiqoVk6N1l+BlBbhduM+fF53n7mpsfmAd4jYT6/CxKPI24C24G0cr
         b9LeZPoYh3CspHErNHygEvKCsA20MfJVowokxoctEKhJWrr22pmITe1yKZruokwEiFAd
         ndWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QDgZFThaTBg5nGvePgrnjGsjIT5tjYJPsExiCCA99pc=;
        b=28xUhcM553ZXrwsCPtTwR9hHOSEeU2ZwMBYyVWOqp5NfDqW7nGm961MJYzUukqM8fL
         m5EAGOtSnsdfoFMJNlbUhOtwxrUOJy4/kDBF9zZuzMbhd33t1vXLBh7/5QFQ7exGRDLV
         HZnsuZN9JRzt6YTIgqYu0XvkpeaMy0T85rswLhiQOr/6lwmN8R3Kyw3nK7i6k4N8u9rd
         d7v+UeXyrH3ms8LAWtO6VjuxTZRwCqQoXqOn+9lBmcVD1GeKXsb6DqyW6R8IlUvhLfeW
         MTNgQI9Ai/THkHEZM/1w1BsHDejSPvcnkrjgRbhfZUqJJ+5f7CJ68N2o0L5e8FipXvGS
         vxOA==
X-Gm-Message-State: ANoB5pkb9kfuV8FOBKjqJchO4xvDAmS2BCX14PCs7SNNQ3HNsw1oPkEO
        0bEHzHmcgYi50N+0BpmXWDpQSsoVkfhVtSe5
X-Google-Smtp-Source: AA0mqf6sLpqto0qEe4KLqE0C4XmMC9iN5bByLx6cl56K+DcuDYdksqj8W6IZy6aJ7/nrk8bSsGWBUQ==
X-Received: by 2002:a17:906:7ad8:b0:7c0:89ac:83f9 with SMTP id k24-20020a1709067ad800b007c089ac83f9mr467372ejo.11.1670408944617;
        Wed, 07 Dec 2022 02:29:04 -0800 (PST)
Received: from [172.16.10.51] (193.92.232.175.dsl.dyn.forthnet.gr. [193.92.232.175])
        by smtp.gmail.com with ESMTPSA id vw22-20020a170907059600b0073dd8e5a39fsm4561086ejb.156.2022.12.07.02.29.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Dec 2022 02:29:04 -0800 (PST)
Message-ID: <6cb7bc9b-635b-7d4a-172d-66b5b8146db1@arrikto.com>
Date:   Wed, 7 Dec 2022 12:29:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH] tcm_loop: Increase maximum request size
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
References: <20220929115504.23806-1-ntsironis@arrikto.com>
Content-Language: en-US
From:   Nikos Tsironis <ntsironis@arrikto.com>
In-Reply-To: <20220929115504.23806-1-ntsironis@arrikto.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

Hello,

This is a kind reminder for this patch. Do you require any changes to
merge it?

Nikos
