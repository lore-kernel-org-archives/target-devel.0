Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A6ECC433FE
	for <target-devel@archiver.kernel.org>; Thu, 31 Mar 2022 16:48:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240240AbiCaQun (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Thu, 31 Mar 2022 12:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240243AbiCaQum (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Thu, 31 Mar 2022 12:50:42 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D38F358825
        for <target-devel@vger.kernel.org>; Thu, 31 Mar 2022 09:48:53 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id z6so240115iot.0
        for <target-devel@vger.kernel.org>; Thu, 31 Mar 2022 09:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=GVS+7ByfaDfRQ3cP7Su5v65xswUHpTm7s1D0XKCLUIc=;
        b=5UHAlnNn6pmh13gHK2pkVOqqU+NLxHAIm10n7hxY69fkf4etI7xGcoRjiBvGoyxJNr
         kabCkIf1xxwY5lv3Fz+S1YPx7xckQPP2QGAxBmU/6XuRjvC3V9So7gmo5sdkO4isG+7U
         NYY0uWHbGE6Q/h3sInup3pNJi9R9t2lf1mAnVfMWjXyxKmAnrTRpm6i8FD+xdnRD9+kO
         TZ43pQfEjcjGk7vvTk+toj73TV/PjBpXagt13go4gLwi84xpTxTtB2xWYo91klXaZtPT
         YIuOfPzysEz9Z8i6engCc1D604prelmrGVhbWJ968cwBOEX4MnOYuo44vJBZyXv5Y/b+
         Wf/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GVS+7ByfaDfRQ3cP7Su5v65xswUHpTm7s1D0XKCLUIc=;
        b=JxIxnN7IBldKZlRFPHHKzC5/DHI5Kvx4LcDFnz4jWljeiRO9CW+FaFaV5t7WPIP6W9
         4a3jBazrlov6UcfZFps980pN32bC6g0ynbSQTJkuzxZx2jyFMZ6TQRw9ZFByjNQGpfGm
         3madlzL6LS5oOUousYcF1yDwQGqEDgBR+qkyvdbCFFZFgykglYtuv55KPGfi0hTaV4G/
         pWubKsOdMTAZcGi1txT3j3JdRcRIeTNYGMgDazNj3bogSyqqIIAHfL+PPu/dJPJyt+2d
         bNSIMnAxF1ZuJHcBy77r6p5nNhcZIN0b/wmWi8JmoTT8TNw4xT78wSEGcWkruZf8Hpxs
         yNAQ==
X-Gm-Message-State: AOAM530uOlAHqPvC2yazpipVfr/+lQmFuvt2GlgYqhbJXR4/4qDX/DKx
        Oq8oIXYsn0BHIgpgm4G0Ce7p4A==
X-Google-Smtp-Source: ABdhPJxO6cxAuydd+MYxjFrmEZWnATNnBLDhK+n22mh4Hzt3rKwlZEwEzWA3wPZWmZM8hKaYOdK5ag==
X-Received: by 2002:a02:c017:0:b0:323:6b24:5bde with SMTP id y23-20020a02c017000000b003236b245bdemr3323956jai.185.1648745331810;
        Thu, 31 Mar 2022 09:48:51 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id j4-20020a056e02218400b002c82f195e80sm12730706ila.83.2022.03.31.09.48.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Mar 2022 09:48:51 -0700 (PDT)
Message-ID: <572bf891-8b2b-b32e-af64-d80fb7f5963f@kernel.dk>
Date:   Thu, 31 Mar 2022 10:48:50 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: cleanup bio_kmalloc v2
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Qian Cai <quic_qiancai@quicinc.com>
Cc:     Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>,
        Song Liu <song@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org, target-devel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
References: <20220308061551.737853-1-hch@lst.de> <YkXYMGGbk/ZTbGaA@qian>
 <20220331164024.GA30404@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220331164024.GA30404@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 3/31/22 10:40 AM, Christoph Hellwig wrote:
> This should fix it:

Let's drop this one for 5.18, it's also causing a few conflicts and
would probably be more suited for 5.19 at this point.

-- 
Jens Axboe

