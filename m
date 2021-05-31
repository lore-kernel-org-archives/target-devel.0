Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6564CC47080
	for <target-devel@archiver.kernel.org>; Mon, 31 May 2021 21:11:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 339A0611CB
	for <target-devel@archiver.kernel.org>; Mon, 31 May 2021 21:11:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbhEaVNb (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 31 May 2021 17:13:31 -0400
Received: from mail-pl1-f182.google.com ([209.85.214.182]:34649 "EHLO
        mail-pl1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbhEaVN3 (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 31 May 2021 17:13:29 -0400
Received: by mail-pl1-f182.google.com with SMTP id e15so5778485plh.1
        for <target-devel@vger.kernel.org>; Mon, 31 May 2021 14:11:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A0ZNVIihgiASbIJ7WsZM4SQrj+x+YfVrOIuep8klSlw=;
        b=o1AZrxL7mSz4KeLrd8uVF6vvf0Odb7xgV6Ez1cCewO155WrheYhzLLyq83eueF1lT/
         8Z4qgqd9TlzbAOICSlBysoebXX8TXNHjof9ZJ69FVG42oSU26HNpPsSK42KOzIQxk3wx
         /izHNFC2bhGgFiA5RWIjHrHcgING7F6mcYEqe3ZNmaP86UOLNjkdQL0rJ5C8HHbrTj2J
         csJ+wOlrUshpLCsUegr3I5mmngBudNY1Cc5Hr0t/FryWWNs5uzUmZYT0oRpvz272XOgK
         HQrCwEcUr9UfkIVhMc2SYmDh51Yw0OAZDzCNRy3YHgvh/yPTnmvIakucFt8zubsn5IQs
         UpXw==
X-Gm-Message-State: AOAM530dkbAI9HdVeUfVGUlgQDtJVCX47TW5t9zvZR4/vpqx+lY0bkNE
        39FhbiDyF/fD3NxI1mKHy7M=
X-Google-Smtp-Source: ABdhPJxBCex4pBtg3FMGJILpq52wmlnLSH+g3oibzmbN6097Cu/kv5MOExiAW6wRxLIEFo5pmW1a5g==
X-Received: by 2002:a17:902:d917:b029:107:eca4:d5b4 with SMTP id c23-20020a170902d917b0290107eca4d5b4mr334244plz.79.1622495509445;
        Mon, 31 May 2021 14:11:49 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id b20sm3380857pgm.30.2021.05.31.14.11.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 May 2021 14:11:48 -0700 (PDT)
Subject: Re: [PATCH] target: fix warning on realtime kernels
To:     Maurizio Lombardi <mlombard@redhat.com>
Cc:     michael.christie@oracle.com, target-devel@vger.kernel.org,
        martin.petersen@oracle.com
References: <20210531121326.3649-1-mlombard@redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <cc9a3c8b-03cf-3438-e950-ad69629e6730@acm.org>
Date:   Mon, 31 May 2021 14:11:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210531121326.3649-1-mlombard@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 5/31/21 5:13 AM, Maurizio Lombardi wrote:
> On realtime kernels, spin_lock_irq*(spinlock_t) do not
> disable the interrupts, a call to irqs_disabled()
> will return false thus firing a warning in __transport_wait_for_tasks()
> 
> This patch removes the warning and also replaces assert_spin_locked
> with lockdep_assert_held()

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
