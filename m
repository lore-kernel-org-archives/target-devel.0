Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ACEBC43217
	for <target-devel@archiver.kernel.org>; Thu,  1 Dec 2022 14:15:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbiLAOPv (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Thu, 1 Dec 2022 09:15:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231678AbiLAOPs (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Thu, 1 Dec 2022 09:15:48 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E11EEC6E42
        for <target-devel@vger.kernel.org>; Thu,  1 Dec 2022 06:15:46 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id a16so2518592edb.9
        for <target-devel@vger.kernel.org>; Thu, 01 Dec 2022 06:15:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RUvwSs07qfrLDVvvV8fdQXv1V3JudJx2fgVRbqbfrDI=;
        b=GJeBC7UUT4rWIEqdBx/pRW8wT5evzhYvlB5u7Xf9BTLpgHggE1EDHLV3BY1beamMS/
         Wdw0ZrRgNYHWPARQiKRiLtBij+mRjoe+DEC7nD8QBDzXd+rOF82+DANIq4yIvhy/aE+Y
         MzTqpl78X+1zP3TVMFqSRZ/ZIMfq4UVPrqDufyuIc6wrse1akgb2kKODUJ6bVAunvMDU
         BxBV6OF8ItBInCAx+ozxM3Y4BjSpEwpz+jaQlsE11xTzF45bSvtXIkuNqtkroBSxtkKc
         5i4Ue7jAwzBSTq5vuhbQP3D+DGTiTO11Ubb4MiFsXLRGLkJhGY5+YTRN+228hAKvd67r
         UA4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RUvwSs07qfrLDVvvV8fdQXv1V3JudJx2fgVRbqbfrDI=;
        b=Lr48FcaKiIJqr9O78nzNlNn6dNHL1Hzpqpyy6egJOvX31m7lnAMYefFJxx6ZiN/OlC
         LbJQtE+8+4cktr4OqKPwQDpvYoq86zLy7OfRr+BSgQQgvcTb1iYLHrEQSofdnajTffGT
         LIGM9eHfQ0TZTx5DbuOjtTUeMQNLyh0W9YnGWyEVc+Cv8ZJb8lsbW5QiwziK6onouSV/
         ZwHJSDT0uqX1MncumspqoIEnrAkiqk9VsK7a2rXrQP3rwBESySncSO4rL3QzQXZrpV2D
         wcH6RaJ68Hv6KVdshtxfeWlAFQKYKxcrf3tD4G71I895v6yRfWlkCp2aNFk88Sg8Z633
         yz+A==
X-Gm-Message-State: ANoB5pm7wWGisIC3Ohx0Np/nH755Zm0HqzFgeLIleRSpGeLQkiPIg7r9
        lWDYzzipYqkeWQXrTgQm1uM=
X-Google-Smtp-Source: AA0mqf43yrTFZ6gfqkirfBlUpCNnXxF4OCrrCuJXytmT0UXFmUjNePYWe8FyzGHubKpU7KP/Hz/nsw==
X-Received: by 2002:a05:6402:5:b0:459:cdb:92ad with SMTP id d5-20020a056402000500b004590cdb92admr43372485edu.77.1669904145403;
        Thu, 01 Dec 2022 06:15:45 -0800 (PST)
Received: from [192.168.178.40] (ip5f597b78.dynamic.kabel-deutschland.de. [95.89.123.120])
        by smtp.gmail.com with ESMTPSA id b7-20020a17090630c700b007b790c18264sm1807885ejb.159.2022.12.01.06.15.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Dec 2022 06:15:45 -0800 (PST)
Message-ID: <87d2d228-a4ac-9103-0f1c-57c691f91f0f@gmail.com>
Date:   Thu, 1 Dec 2022 15:15:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
From:   Bodo Stroesser <bostroesser@gmail.com>
Subject: Re: tcm_loop and aborted TMRs
To:     Mike Christie <michael.christie@oracle.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     Maurizio Lombardi <mlombard@redhat.com>,
        target-devel@vger.kernel.org
References: <CAFL455kjQeqvPqd1CUqs7f6xUjrrDqR1h7edizusAtj130HCPg@mail.gmail.com>
 <caad6a7a-c30c-a3ac-7932-f5a19c877ffc@oracle.com>
 <e07f0fa5-d59d-36f2-d99b-73e32af3282e@gmail.com>
 <20221121133550.GB5248@yadro.com>
 <addec585-4271-cd9c-fcf0-fd780f269aa8@oracle.com>
 <20221125084920.GC5248@yadro.com>
 <0a6eb2d4-1158-5268-27d5-454edbf9f566@oracle.com>
Content-Language: en-US
In-Reply-To: <0a6eb2d4-1158-5268-27d5-454edbf9f566@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 27.11.22 19:59, Mike Christie wrote:
> On 11/25/22 3:34 AM, Dmitry Bogdanov wrote:
>> On Mon, Nov 21, 2022 at 01:25:55PM -0600, Mike Christie wrote:
>>>
>>> On 11/21/22 7:35 AM, Dmitry Bogdanov wrote:
>>>>>
>>>> I will vote to your old patch. qla2xxx was fixed long time ago.
>>>
>>> What is the qla fix? I think we still leak. In commit
>>>
>>> commit 605e74025f953b995a3a241ead43bde71c1c99b5
>>> Author: Mike Christie <michael.christie@oracle.com>
>>> Date:   Sun Nov 1 12:59:31 2020 -0600
>>>
>>>      scsi: qla2xxx: Move sess cmd list/lock to driver
>>>
>>> when I changed the locking I had added the check:
>>>
>>> static void tcm_qla2xxx_aborted_task(struct se_cmd *se_cmd)
>>> {
>>>          struct qla_tgt_cmd *cmd;
>>>          unsigned long flags;
>>>
>>>          if (se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)
>>>                  return;
>>>
>> Yes, I was thinking about that commit.
>>> because tmrs are not on the sess_cmd_list that's accessed the
>>> next line down. We don't crash as a result, but I think we need
>>> to add code to send the cleanup command to the FW. Bodo and I
>>> were working on that part, but someone with more qla experience
>>> needed to work on it so it could be properly tested. We didn't
>>> hear back from the qla engineers so progress had stalled.
>>>
>> Yes, you are right, FW expects some response on every ABORT IOCB
>> to clear its resources.
>>
>> I can prepare the patch for qla2xxx.
> 
> That would be awesome.
> 
>>
>> But still, I do not see a sense of new Bodo's solution.
> 
> Drivers are crashing in the aborted_task callout. His idea was a
> workaround/hack so we would call the queue_tm_rsp callout instead of
> aborted_ask like we did before which would avoid the crashes but
> allow us to keep the async behavior.
> 

Not exactly. In case we are not able to fix a driver, I wanted to
change drivers's aborted_task callout to use its internal queue_tm_rsp
routines in case of aborted TMRs.
But that would work only if we changed the core to not call
target_put_sess_cmd, which again would lead to changes in currently
working drivers. Really a hack only.

> To the initiator's it would work like before where it looks like a
> race where the abort response is received right after it has sent
> the lun reset. His assumption is that initiators handled that before
> so it would continue to work.
> 
> If you fix qla, then we can easily fix loop and xen and we can do
> the correct behavior and keep the async feature.
> 

Are we sure qla, loop and xen are the only drivers that handle aborted
TMRs incorrectly?
