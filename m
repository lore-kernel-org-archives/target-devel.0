Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38B0CC433B4
	for <target-devel@archiver.kernel.org>; Mon, 17 May 2021 15:02:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16F9E61350
	for <target-devel@archiver.kernel.org>; Mon, 17 May 2021 15:02:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241991AbhEQPD2 (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 17 May 2021 11:03:28 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:43714 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241821AbhEQPBZ (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 17 May 2021 11:01:25 -0400
Received: by mail-pj1-f42.google.com with SMTP id ep16-20020a17090ae650b029015d00f578a8so3864282pjb.2
        for <target-devel@vger.kernel.org>; Mon, 17 May 2021 08:00:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l6wX7YF6aEITSh924zLIZTHI6f81+b7oIJfr5LbdEhI=;
        b=FKVbkEMjNavk1TjyL5vG1gm6Fol7B5lU/HbOrictw7P4XZ5BYw9jJpmcYTlD/ctZPQ
         +F/ujq7F0IYSjXc8SK5cNFmZLJ3eOlFwDX5IJBn81JmyZIOiKZMHRhAFGIKvotogOBAf
         +5wFR7p5raadoVyB4aEES4SRI/7n/NRpXmEnf0x6FTpvNaO6y/J0leRoW1Z++qmfNkbz
         t7XDaH6pc/oVXKxd5+QKb3WK4sWoUJ8UayDAlAAtKnPilddDtfHOTDFPGr18PYK6TchP
         MxfFhenFT+gdOelzS8/Alpt4dY5sWio6DJ7B3EOkxNLmuIKIsytEFJWLq0kPCKVKGVLq
         gBKw==
X-Gm-Message-State: AOAM530f0HlHm9DMz4vistoYatOlLt7zIVkS1CEVSa1MsNrb+6DC2Hjs
        5WOzWmpYTQntjKRj7YX12BU=
X-Google-Smtp-Source: ABdhPJxUP1f0OsrkPOQRzAFheomEeQeeqOc7pc/6OS54fXeh4y3yKLcGex/EQID9z1769wBtD97umg==
X-Received: by 2002:a17:90b:1244:: with SMTP id gx4mr360488pjb.210.1621263609107;
        Mon, 17 May 2021 08:00:09 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:8224:c0d6:d9dd:57b3? ([2601:647:4000:d7:8224:c0d6:d9dd:57b3])
        by smtp.gmail.com with ESMTPSA id b15sm10166188pfi.100.2021.05.17.08.00.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 May 2021 08:00:08 -0700 (PDT)
Subject: Re: warning on PREEMPT_RT kernel
To:     Maurizio Lombardi <mlombard@redhat.com>,
        target-devel@vger.kernel.org
Cc:     bostroesser@gmail.com, michael.christie@oracle.com,
        martin.petersen@oracle.com
References: <CAFL455=vDW6oJPjN8N_TZY9fuMOcffmGeAw5NVRpmruKKdkVPQ@mail.gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <8b2cee4d-76d0-54bb-2f1e-df2b06aeb036@acm.org>
Date:   Mon, 17 May 2021 08:00:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAFL455=vDW6oJPjN8N_TZY9fuMOcffmGeAw5NVRpmruKKdkVPQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 5/17/21 5:39 AM, Maurizio Lombardi wrote:
> static bool
> __transport_wait_for_tasks(struct se_cmd *cmd, bool fabric_stop,
>                            bool *aborted, bool *tas, unsigned long *flags)
>         __releases(&cmd->t_state_lock)
>         __acquires(&cmd->t_state_lock)
> {
> 
>         assert_spin_locked(&cmd->t_state_lock);
>         WARN_ON_ONCE(!irqs_disabled());   <----------
> 
> I guess this is due to the fact that on realtime kernels spin_lock_irq*() do not
> disable the interrupts, so the call to irqs_disabled() returns false.

It's probably fine to leave out that WARN_ON_ONCE() call. And the
assert_spin_locked() probably should be changed into a
lockdep_assert_held() call.

Thanks,

Bart.
