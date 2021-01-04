Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CD8CC433E6
	for <target-devel@archiver.kernel.org>; Mon,  4 Jan 2021 15:52:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF78C224D2
	for <target-devel@archiver.kernel.org>; Mon,  4 Jan 2021 15:52:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbhADPwn (ORCPT
        <rfc822;target-devel@archiver.kernel.org>);
        Mon, 4 Jan 2021 10:52:43 -0500
Received: from mail-pl1-f177.google.com ([209.85.214.177]:47082 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbhADPwn (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 4 Jan 2021 10:52:43 -0500
Received: by mail-pl1-f177.google.com with SMTP id v3so14725679plz.13
        for <target-devel@vger.kernel.org>; Mon, 04 Jan 2021 07:52:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=/BFImy7XfPqQ+/BPL5kJu8SSJcjgUdo9D8OXbq0nF6Y=;
        b=NzUaQch6l+tczVg1Hj+ArvpHyABHQth+/7hYxDd1RoNIGM46rbV0bRGmaPTdLQEt/z
         vUTcCIw4xhDuk9rbo1WDMD16/KXMtT1uFzes2fvncTHUZx+XagXj+/eGi/CKRUj5KQfZ
         RcBNmMNSfVyT8mRms0Y4DjtT3qZiyynmD51rTtIq7vICWDltFmJoF7q2bdviEr2bOMB+
         63HPBrlucAT1ExknfZXUqaDP0681vyp0Y4XkGw7RhiFuQpmIuYZQONwRDWppJZdQxQWs
         4N1tTyG7L+mqXhWFL1l8uAkgvlnus/CKJuF3W/KN2Y57rqsmKKXiwPqRIKdQGia2XbxU
         aCDw==
X-Gm-Message-State: AOAM533uKn4qetwfpJd2VWFd7ja6hZIJdTvvEUwEp8ebYiiv2cxg+dcu
        aBIA+QXKwOTQ0kwDxKK2YL6w1GSMhuI=
X-Google-Smtp-Source: ABdhPJz6qkE8cl9EYqoPoE7khsGeJvwpMsra1HbdjPq0LUGswY5IzDsMskVvFyBgYEU+QY+4bBOJvQ==
X-Received: by 2002:a17:902:b18c:b029:da:fc41:baf8 with SMTP id s12-20020a170902b18cb02900dafc41baf8mr72606992plr.58.1609775522207;
        Mon, 04 Jan 2021 07:52:02 -0800 (PST)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id q16sm55824363pfg.139.2021.01.04.07.52.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jan 2021 07:52:01 -0800 (PST)
To:     target-devel@vger.kernel.org,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        Hannes Reinecke <hare@suse.com>,
        Mike Christie <michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
Subject: About the tcm_fc FCoE target driver
Message-ID: <f5808b3e-0434-9d8b-93fe-94d48d657926@acm.org>
Date:   Mon, 4 Jan 2021 07:51:59 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

Hi,

My understanding is that the ft_queue_data_in() function in the tcm_fc
driver gets called while processing SCSI READ commands. That function queues
data for sending by calling fc_seq_send(). The FCoE driver translates that
call into a dev_queue_xmit(skb) which sends the data asynchronously.
ft_queue_data_in() frees the data buffer synchronously from inside
ft_queue_status(). I believe that this race condition can trigger data
corruption. Since nobody ever reported this race condition, does this mean
that the FCoE target driver has no users and hence that it can be removed
from the kernel tree?

Thanks,

Bart.
