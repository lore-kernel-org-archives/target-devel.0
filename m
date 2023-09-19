Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3A80CD5BCD
	for <target-devel@archiver.kernel.org>; Tue, 19 Sep 2023 15:09:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232384AbjISPJN (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Tue, 19 Sep 2023 11:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231866AbjISPJN (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Tue, 19 Sep 2023 11:09:13 -0400
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E17F94
        for <target-devel@vger.kernel.org>; Tue, 19 Sep 2023 08:09:08 -0700 (PDT)
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-68fdd6011f2so4341454b3a.3
        for <target-devel@vger.kernel.org>; Tue, 19 Sep 2023 08:09:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695136147; x=1695740947;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qeMhCO4JsXnZTfyI+bhQS9VGdGKXDNmVPOA10FwHwXg=;
        b=nz6F+BAHpzQRvyNULJxWV8V7YysvwlFXra3zTQ0ROZ/RtcDVfAy1onsIFGTLWf8/wo
         gkJ+koa1QzjyF5UmIwetT/pJpwpFOD6IrHSrJUE2KZHn3hC1mzjQ35ROmbfQA4oB2oTo
         IgOOUNa7/IH4gOXC3y2B6Sboq8yWOkA6bxGVr3zj/cfNi+pnln2E3qYTpKNboePMt+lP
         ch00NGol2RvZ6vScvlLNJyR1FqbHqh4qADxNZ2BPR5gP5WJzucSAeAkPU0f77JG0EIDY
         HxNJyzLsf8E9xY91/3gxYnRWzbAAzh8Y4qcYr9Cm5Nz2q2HSYv3H03SGmxVGPrP0YJRy
         K9Pg==
X-Gm-Message-State: AOJu0YzkhmEg1Ui9VXEoVgDc0U/ei8PRt2uksJRbiv63JTAwoDqcaO1e
        VtHunsvalUsuWnfhYoWoNhA=
X-Google-Smtp-Source: AGHT+IHemPJiPhyKNXwsJ6tSGbgMWG48Tl9Tk8R54Aa58GGjokbxoqZOGQs7tPfTogALzv5M+CFQ1Q==
X-Received: by 2002:a05:6a00:148c:b0:68e:2c3a:8775 with SMTP id v12-20020a056a00148c00b0068e2c3a8775mr12313134pfu.33.1695136147341;
        Tue, 19 Sep 2023 08:09:07 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:dc54:7e62:ea3c:d7a8? ([2620:15c:211:201:dc54:7e62:ea3c:d7a8])
        by smtp.gmail.com with ESMTPSA id ey4-20020a056a0038c400b0064d74808738sm8787285pfb.214.2023.09.19.08.09.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Sep 2023 08:09:06 -0700 (PDT)
Message-ID: <3cf27172-6fda-469a-be30-69916b35ee79@acm.org>
Date:   Tue, 19 Sep 2023 08:09:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] scsi: target: Change nab@linux-iscsi.org into
 nab@kernel.org
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Mike Christie <mchristi@redhat.com>,
        Christoph Hellwig <hch@lst.de>, target-devel@vger.kernel.org
References: <20230918215941.2053109-1-bvanassche@acm.org>
 <20230918215941.2053109-4-bvanassche@acm.org>
 <98ca06fa-229b-460f-96bb-2d8b50dfc45e@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <98ca06fa-229b-460f-96bb-2d8b50dfc45e@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 9/19/23 01:11, Hannes Reinecke wrote:
> Hmm. I'm not sure if replacing the original e-mail addresses in the 
> copyright portions of the source file is the way to go. For figuring
> out which e-mail address one should consult the MAINTAINERS file; I
> would treat the e-mail addresses in the copyright primarily as a
> reference to the original author and the company he worked for at
> that time. So I'd rather not change that.
> 
> But that's personal opinion, of course. I'm not a lawyer.

Thanks Hannes for having taken a look. I'm not a lawyer either. This is
what I found by searching on the web for "How to write a copyright
notice?":
* The standard format for a copyright notice is (1) a copyright symbol
followed by (2) a date, (3) the name of the author and (4) a statement
of rights.
* None of the guides that were written by a lawyer mentioned the
inclusion of an email address in the copyright notice.

The Bard software told me the following: "Legally speaking, the email
address is not required for a copyright notice to be valid. Copyright
protection is automatic in most countries, and a copyright notice is
simply a way of notifying others of your ownership rights. However,
there are some potential benefits to including an email address in your
copyright statement.

For example, if someone infringes on your copyright, you can use your
email address to contact them and ask them to stop. You can also use
your email address to file a DMCA takedown notice with a hosting
provider or search engine."

Anyway, unless someone has another opinion, I will revert the email 
address changes in the copyright statements when I repost this patch
series.

Bart.
