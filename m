Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48640C433E0
	for <target-devel@archiver.kernel.org>; Thu, 18 Feb 2021 08:24:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE4CF64E68
	for <target-devel@archiver.kernel.org>; Thu, 18 Feb 2021 08:24:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbhBRIWS (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Thu, 18 Feb 2021 03:22:18 -0500
Received: from mx2.suse.de ([195.135.220.15]:44672 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230434AbhBRITw (ORCPT <rfc822;target-devel@vger.kernel.org>);
        Thu, 18 Feb 2021 03:19:52 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C000EAFA0;
        Thu, 18 Feb 2021 08:19:10 +0000 (UTC)
Subject: Re: Can LIO configfs handle concurrent changes independently
To:     tasleson@redhat.com, target-devel@vger.kernel.org
References: <94b1290f-4713-460a-43b8-ff00402c64dd@redhat.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <1044e9fe-f5ec-d7d8-b6f6-2f0ee9cc0fd7@suse.de>
Date:   Thu, 18 Feb 2021 09:19:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <94b1290f-4713-460a-43b8-ff00402c64dd@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 2/17/21 5:10 PM, Tony Asleson wrote:
> Can configfs for lio can handle multiple containers making changes
> concurrently and independently?
> 
> ref. https://github.com/open-iscsi/targetd/issues/77#issuecomment-757087879
> 
> Thanks!
> 
Not to my knowledge. Neither sysfs nor configfs are namespace aware.

Should be doable for configfs, as this is a stand-along 'filesystem' 
which could be made namespace-aware.

The implications of this, however, will be challenging as quite some 
internal structures using configfs are currently programmed for a
single user.

Still, interesting project, and one should be looking into it.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
