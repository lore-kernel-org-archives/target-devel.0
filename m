Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2768E7D0B0
	for <target-devel@archiver.kernel.org>; Thu, 21 Sep 2023 20:35:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbjIUUf4 (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Thu, 21 Sep 2023 16:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232424AbjIUUfF (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Thu, 21 Sep 2023 16:35:05 -0400
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C424768F3
        for <target-devel@vger.kernel.org>; Thu, 21 Sep 2023 10:33:52 -0700 (PDT)
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-774105e8c37so38718485a.3
        for <target-devel@vger.kernel.org>; Thu, 21 Sep 2023 10:33:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695317519; x=1695922319;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8JCSus+4z3hMiDQI9RHh/8lZ8gBL0Cwyc5vCkLQjcNI=;
        b=LKPjXMsDlbU7iMvQTJMep0ynlAc5o2mxi5AlNKRzZp/1wvxLJdaL7f4liqctsiDOUw
         4jp/u7P3r17vvX/ZiKJqCiyE0F3TWn981nerkXyHbWCQtgjpjQmdDelQPGUTndQkkOJv
         P7L6dy4uh5SVHvcfBfRBpl2G5xJE3rGILKzTUL//bDVaJtq23KIyo4jwQoMZm1svC+Ql
         WewwH7PmYTId6fIzx/71SR0kK3CnJePYSHgPoAI62uzSvdGPVgIQxyTeCo8ZafXAw8Fs
         LGJkEXome3lM8qmZV2A/JrCOpdzLQudRUEoH+0tBaXld4p17ihjuyZ27zUERNrAT9LyH
         DLwA==
X-Gm-Message-State: AOJu0YyIrsRcAVnOjXvpQs0pdxv9Nb89M17UDiyBXYw0UAgdOEofacxw
        NqvEZb8KDY/Pa9yC+aRbHglnZxh16/uHYA==
X-Google-Smtp-Source: AGHT+IFzWQhSI4G3e1aYtgWbFN1WznK6GMGz8Vu6Cf3sxxTj7Sp6viB5v7ZoUpJ0sUcbJ77wO26ZPw==
X-Received: by 2002:a17:902:efd5:b0:1c5:ce3c:c399 with SMTP id ja21-20020a170902efd500b001c5ce3cc399mr2759395plb.39.1695306943621;
        Thu, 21 Sep 2023 07:35:43 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:6903:9a1f:51f3:593e? ([2620:15c:211:201:6903:9a1f:51f3:593e])
        by smtp.gmail.com with ESMTPSA id b8-20020a170902d50800b001b891259eddsm1550217plg.197.2023.09.21.07.35.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Sep 2023 07:35:42 -0700 (PDT)
Message-ID: <a2dafeb7-6643-4d2c-a7e0-3a3931706ba8@acm.org>
Date:   Thu, 21 Sep 2023 07:35:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] scsi: target: Change nab@linux-iscsi.org into
 nab@kernel.org
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Mike Christie <mchristi@redhat.com>,
        Christoph Hellwig <hch@lst.de>, target-devel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Sagi Grimberg <sagi@grimberg.me>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        Mike Christie <michael.christie@oracle.com>,
        Maurizio Lombardi <mlombard@redhat.com>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Konstantin Shelekhin <k.shelekhin@yadro.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        Azeem Shaikh <azeemshaikh38@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
References: <20230920200232.3721784-1-bvanassche@acm.org>
 <20230920200232.3721784-4-bvanassche@acm.org>
 <ca46b0f2-779e-46fe-8653-03654e5188ea@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ca46b0f2-779e-46fe-8653-03654e5188ea@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 9/21/23 00:31, Hannes Reinecke wrote:
> On 9/20/23 22:00, Bart Van Assche wrote:
>> Note: I received the following reply after having sent an email to
>> nab@kernel.org: "I'm sorry to have to inform you that your message
>> could not be delivered to one or more recipients. It's attached below.
>> For further assistance, please send mail to postmaster. If you do so,
>> please include this problem report. You can delete your own text from
>> the attached returned message. The mail system."
>>
> Didn't you want to drop this patch?
> The 'Author' line is a historic reference; Nic Bellinger wrote this code
> using that e-mail address. This fact will not change, even if Nic is 
> using a different e-mail address now.

The domain linux-iscsi.org won't be owned by N.A.B. forever. Hence, 
sooner or later another person may become the owner of the email address 
nab@linux-iscsi.org. I think it is much less likely that the email 
address nab@kernel.org will ever be owned by another person than 
Nicholas Bellinger since the kernel.org administrators use PGP keys to 
verify the identity of a person. Anyway, I will drop this patch.

Bart.

