Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D9F2C433DB
	for <target-devel@archiver.kernel.org>; Sat,  2 Jan 2021 16:02:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF96720888
	for <target-devel@archiver.kernel.org>; Sat,  2 Jan 2021 16:02:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbhABQBz (ORCPT
        <rfc822;target-devel@archiver.kernel.org>);
        Sat, 2 Jan 2021 11:01:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbhABQBy (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Sat, 2 Jan 2021 11:01:54 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5244C061573
        for <target-devel@vger.kernel.org>; Sat,  2 Jan 2021 08:01:13 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id c124so13214198wma.5
        for <target-devel@vger.kernel.org>; Sat, 02 Jan 2021 08:01:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=OAWPrPrk5GUYc98P6NjfN4YpUP78YJWKyIZp3Ft5q0A=;
        b=bkRALoyRIKvxwGunUtSZYd5/nKny+LWjnsHbmrA85wPLAUAkFjAqsfbm4ICeYl0ceJ
         v2u55GXMeF0iBW049eexeY1Lb2/qyUNV5QEphKAFknaXXSboVfLe5h7c7VFlsqcre7uO
         sKuwrRJfMxdxW1PZO7Ufm5uFT5TyL7tvz1CGrdCD920TZ0TZY/Ds4tT2TeOzR5uDECyQ
         NuHtsMrxr/Y6nrQzKTuCznpMP/D1FpohqSt4XMmqGwJ1oVcu4gU2ECJ/bxiJWhZgi4tI
         O8vl0xyTLJlwZ0Ov/2X7dzI6/dibs0TbEzTrbPhtogtEsAlt6UF9u1WQkh3kdMW3PqLk
         qh/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OAWPrPrk5GUYc98P6NjfN4YpUP78YJWKyIZp3Ft5q0A=;
        b=b2ugOYQXlxxIeuIVvpctb98aRCN+H1jKZ30brP4HS7vXLYZz5Jto7hLNTU2rU6viQz
         83ENZFkXNDT4rLVfI14DnyjZGzGcUL2HZ+3msl2bmufyq2pyY7i2KW0D6umAAmI0uPxZ
         +6Wa/i39OPA+q7/MwsKkaZ2Lc0KQxvgxJYUj+TUC9BxfYN4q6EgO2x/k2kzWZr89uWzz
         y3ZBdC7TNRFIRtubKCmHv4k39x56JVWxsqu6eXEMrLME7j+NyiOMHpPqjH9VZJWU+bLi
         P+a8S7xaUXEVKsTihGr3iZaPDD6DceLW6rzMgp6SzFJtY+CqrEec8IC6zekEkmRWpJ2R
         nf3w==
X-Gm-Message-State: AOAM53231IinMYzPUHfstR1RTY6vBsX1BcezrDZ4LGdTChHOOMHai5zv
        AXW+rd4+047pw3vgyolWTJUK0dhVt5M=
X-Google-Smtp-Source: ABdhPJxz8UNVxJmzltT+drlBUUhLKftrK0PpRUcSWvMU74gYPgWalAIyRPoqW5r/MKLUJDXSgRd8Gg==
X-Received: by 2002:a1c:87:: with SMTP id 129mr19625577wma.183.1609603272034;
        Sat, 02 Jan 2021 08:01:12 -0800 (PST)
Received: from [192.168.178.40] (ipbcc05d1b.dynamic.kabel-deutschland.de. [188.192.93.27])
        by smtp.gmail.com with ESMTPSA id m81sm22241265wmf.29.2021.01.02.08.01.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Jan 2021 08:01:11 -0800 (PST)
Subject: Re: LinuxIO (LIO) target @ Debian 10 and VMware 6.7 Initiator:
 Detected WRITE_PROTECTED LUN Access for 0x00000000
To:     =?UTF-8?B?QmrDtnJuIFdpZ2dlcnQgKHdpZ2dlcnQuaXQp?= <b@wiggert.it>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
References: <zarafa.5fea1887.7399.7358001426d7aa4b@lx18.cmks.de>
From:   Bodo Stroesser <bostroesser@gmail.com>
Message-ID: <4ad3bbd1-fec4-4acb-a675-ec87a359efa9@gmail.com>
Date:   Sat, 2 Jan 2021 17:01:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <zarafa.5fea1887.7399.7358001426d7aa4b@lx18.cmks.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

Probability is high, that your setup indeed does not allow write access to the target for VMWare.
Please check target parameters (e.g. demo_mode) and / or ACLs.

Bodo

On 28.12.20 18:40, Björn Wiggert (wiggert.it) wrote:
> Hi, we are running
> *	QNAP NAS
> *	Debian 10
> *	Host VMware 6.7U3 Hypervisor
> 
> a) Exporting an iSCSI-LUN-target with the QNAP, what is using LIO therfor, and accessing it from VMware (read/write) works fine.
> b) Exporting an iSCSI-LUN-target with a fresh Debian 10 using LIO and accessing it with a Windows 7 iSCSI initiator (read/write) works fine.
> 
> Using the target b) (Debian 10 / LIO) and the initiator a) (VMware v6.7) works as far as
> *	VMware sees the target host
> *	VMware can login and sees the target
> *	VMware can READ the data on the LUN (sees partition table, size of it, partition types, etc)
>   
> As soon as we try to write anything VMware reports
> 
>> 2020-12-28T14:36:00.775Z info hostd[2098690] [Originator@6876 sub=Partitionsvc opID=esxui-2f96-fbd9 user=root] Status : 255 Output: gpt 0 0 0 0
>>
>> Error : Error: Read-only file system during write on /dev/disks/naa.60014054b666e78a1c443ee941c60e3e SetPtableGpt: Unable to commit to disk
> 
> 
> and the Debian 10 box reports:
> 
>> kernel: [ 80.210044] TARGET_CORE[iSCSI]: Detected WRITE_PROTECTED LUN Access for 0x00000000
> 
> I don't recognize why VMware mounts the iSCSI LUN read-only but Windows 7 mounts it read-write and VMware mount the QNAP-iSCSI-LUN also read-write.
> 
> I appreciate any hint - thank you therfor in advance.
> 
> Jan
> 
>   
> 
