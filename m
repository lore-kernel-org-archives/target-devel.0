Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EE67C433E0
	for <target-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:05:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C98CE224DE
	for <target-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:05:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727543AbhADRFS (ORCPT
        <rfc822;target-devel@archiver.kernel.org>);
        Mon, 4 Jan 2021 12:05:18 -0500
Received: from mail-pj1-f43.google.com ([209.85.216.43]:51065 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727466AbhADRFS (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 4 Jan 2021 12:05:18 -0500
Received: by mail-pj1-f43.google.com with SMTP id lj6so10462176pjb.0
        for <target-devel@vger.kernel.org>; Mon, 04 Jan 2021 09:05:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QIlaBZsvW0OwXW8VLcQvaxxGhU2K59vnAOXC+usk0wg=;
        b=kNy/UAAK+4wDEEbxe6GGGZTvMEIM1etUw8QeJRbNUjjrYB+UXI6kego4PVGI3/e3Aw
         voMkZ5p3URjcCd+3Fap4N18pQnYK8opN+S5TqUF0A+KmE9urAunpvIj2F7MQRw7dgdi1
         pMHLLFCepfLeqjAXaimdVoW4PLjRznmWyqO7M5MCjkGj6TDH+8MmJ04J4cjs71Ozt05U
         cGq88HcHE/xHbl9eSV5KNa6rOXE7iuKyCuPPggiu8jWFZXNS+eMDJJwffPvZ2ifJ3/91
         BaxSNrUta7UOonwspneDvcfnee/NFeTeK+JUhTrlKGu8BnIqyG3nFoFZDxyoulteLer0
         w+bg==
X-Gm-Message-State: AOAM533eBrRMgj7MFVoR07WHdJkbr6K56HgkvXx2E7TeySa1Q2nPRsrh
        00OEvy/K69weG68PCOl2WJc=
X-Google-Smtp-Source: ABdhPJxM0Cycv7VkkaUT5nzABW+A2EXc/roxCw8WABlQiQ68W3VrOn4x7sT4taRkrq81igFYAPfK2A==
X-Received: by 2002:a17:902:8d97:b029:dc:313:ee70 with SMTP id v23-20020a1709028d97b02900dc0313ee70mr73195433plo.82.1609779877385;
        Mon, 04 Jan 2021 09:04:37 -0800 (PST)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id s24sm54515809pfh.47.2021.01.04.09.04.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jan 2021 09:04:36 -0800 (PST)
Subject: Re: About the tcm_fc FCoE target driver
To:     jejb@linux.ibm.com, target-devel@vger.kernel.org,
        Hannes Reinecke <hare@suse.com>,
        Mike Christie <michael.christie@oracle.com>
References: <f5808b3e-0434-9d8b-93fe-94d48d657926@acm.org>
 <92ab516c9493accb64630e7e86033a87be018458.camel@linux.ibm.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <ae011110-fb45-428d-b336-f9b7ab33ca5d@acm.org>
Date:   Mon, 4 Jan 2021 09:04:35 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <92ab516c9493accb64630e7e86033a87be018458.camel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 1/4/21 8:06 AM, James Bottomley wrote:
> On Mon, 2021-01-04 at 07:51 -0800, Bart Van Assche wrote:
>> Hi,
>>
>> My understanding is that the ft_queue_data_in() function in the
>> tcm_fc driver gets called while processing SCSI READ commands. That
>> function queues data for sending by calling fc_seq_send(). The FCoE
>> driver translates that call into a dev_queue_xmit(skb) which sends
>> the data asynchronously.  ft_queue_data_in() frees the data buffer
>> synchronously from inside ft_queue_status(). I believe that this race
>> condition can trigger data corruption. Since nobody ever reported
>> this race condition, does this mean that the FCoE target driver has
>> no users and hence that it can be removed from the kernel tree?
> 
> It could just mean the race condition is so rare no user has ever
> triggered it reliably enough to report ... have you managed to trigger
> it?

Hi James,

That's a great question. With a driver that is closely related (the SCST
FCoE target driver; the driver from which the upstream tcm_fc driver has
been derived) I could trigger this race condition easily by running fio
--verify against the FCoE initiator driver. Changing "use_sg = !(remaining %
4) && lport->sg_supp" into "use_sg = false" made the fio verification errors
disappear.

Bart.
