Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABF65C4743F
	for <target-devel@archiver.kernel.org>; Mon,  7 Jun 2021 02:18:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87804611AE
	for <target-devel@archiver.kernel.org>; Mon,  7 Jun 2021 02:18:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbhFGCUc (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Sun, 6 Jun 2021 22:20:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40844 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230130AbhFGCUc (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Sun, 6 Jun 2021 22:20:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623032321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/YSBBQ9cGooM1hAnJfrax+C1tCPnWfT7V7/0+qUaI/k=;
        b=gURlGpmiCbruSt9zHlH/oxgHf1vfyxsO4eO1YPBSU5krQdcHYYL+tHZQlwRXLaNIEvB+cW
        3A1ZJKWWfpjvK72xCxYPsfZwaRbLkqoJ2BhJdBg4Qgn5B6ej84najAFUV+r4gsC8hummoT
        IGcG20HHMO4I6zGumjA2R8c3C8Kzwu0=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-CK8XnOlsN8KLj9A4iE7dCQ-1; Sun, 06 Jun 2021 22:18:38 -0400
X-MC-Unique: CK8XnOlsN8KLj9A4iE7dCQ-1
Received: by mail-pl1-f199.google.com with SMTP id a6-20020a1709027d86b02901019f88b046so7015995plm.21
        for <target-devel@vger.kernel.org>; Sun, 06 Jun 2021 19:18:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=/YSBBQ9cGooM1hAnJfrax+C1tCPnWfT7V7/0+qUaI/k=;
        b=RpRbCysYVD6SH+cDPLhptLva40qKl00JySy4adi6+9PvrFYosOF3CMbsoodJrPpfNS
         rAMUR/4Q+hAYVsjNmVj7ge2vXitP8n5Bj3M13bOfONrny9U3ypURmZz1DorAY3GopEFp
         SO/HgVU+d7e0lJurrg5vW/iRdEq8PZsy/YL4lqi+ynlIr6tfreiHAjpC4XJR3RembcW0
         KSjUfXBy5OggJmAEPQuj4pilaKOwIzlHu4CrrgK7KCVW79JuL2EmemmXIp0vMKLrZ0MX
         jZy95Q+uPKrewcRlHsLmXvCK3fNINtVccu3Vsr6w5HEY7Pfgfu4IcCLI+gclnexTjpnu
         NtjQ==
X-Gm-Message-State: AOAM533Ca+pVJolfqgtv0qmNTgeOlNAu8rXRl6owj0ZRSu5ObGoJ7Ghz
        zXkp11eMBy+6yJfGiOjkRGFxhp0STwYjAVnW5D4ZhDEJcchFV+1QzlPceqJgAS0GUXnLDw+cnuR
        NrN+SQFSBBcxCC9+3gt5xMBkS
X-Received: by 2002:a17:902:c403:b029:106:7793:3fcc with SMTP id k3-20020a170902c403b029010677933fccmr15707467plk.81.1623032317077;
        Sun, 06 Jun 2021 19:18:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz1Mz9rWZDNywIxinqZddVbgfmBbg3wbcfPQEw6zpB+wsjqIzZBnXaVdGeLRKGzInGbXtwyVA==
X-Received: by 2002:a17:902:c403:b029:106:7793:3fcc with SMTP id k3-20020a170902c403b029010677933fccmr15707445plk.81.1623032316810;
        Sun, 06 Jun 2021 19:18:36 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w21sm2048729pfq.143.2021.06.06.19.18.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Jun 2021 19:18:36 -0700 (PDT)
Subject: Re: [PATCH 9/9] vhost: support sharing workers across devs
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Mike Christie <michael.christie@oracle.com>
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        pbonzini@redhat.com, mst@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org
References: <20210525180600.6349-1-michael.christie@oracle.com>
 <20210525180600.6349-10-michael.christie@oracle.com>
 <YLjoDjas6ga3Ovad@stefanha-x1.localdomain>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <f475f7fe-75ec-02fe-34a3-df8c863e8a73@redhat.com>
Date:   Mon, 7 Jun 2021 10:18:28 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YLjoDjas6ga3Ovad@stefanha-x1.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org


在 2021/6/3 下午10:32, Stefan Hajnoczi 写道:
> On Tue, May 25, 2021 at 01:06:00PM -0500, Mike Christie wrote:
>> This allows a worker to handle multiple device's vqs.
>>
>> TODO:
>> - The worker is attached to the cgroup of the device that created it. In
>> this patch you can share workers with devices with different owners which
>> could be in different cgroups. Do we want to restict sharing workers with
>> devices that have the same owner (dev->mm value)?
> Question for Michael or Jason.


I thing sharing workers within a cgroup should be fine.

The differences is that if we restrict the works with the same owner, it 
may only work in the case where an VM have multiple vhost devices.

Thanks



