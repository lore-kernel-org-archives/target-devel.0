Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88B4BC433F5
	for <target-devel@archiver.kernel.org>; Thu, 14 Oct 2021 07:09:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6925B60FE8
	for <target-devel@archiver.kernel.org>; Thu, 14 Oct 2021 07:09:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbhJNHLO (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Thu, 14 Oct 2021 03:11:14 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:41676 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbhJNHLN (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Thu, 14 Oct 2021 03:11:13 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 570FC21A75;
        Thu, 14 Oct 2021 07:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1634195348; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2QQ6N/GHCgFQGxhbBlbpB0OlXZShb7rQaF+C7tSzIro=;
        b=marFmTlGDYClnECH74Vk4IWh/yu9KDniCjCsO2qwNjHdHPvsw39wjz5Yj8uAuhJWi9IVRb
        mClLYeXzsJS/kKDvsmFDoHM09uuXZKO0lMMQAYeajGUGqjm69L5GcutY3BtJU2DYCuDrwZ
        7cJaVy+CVjWw4y/jNNMsKjiOLiblS6k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1634195348;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2QQ6N/GHCgFQGxhbBlbpB0OlXZShb7rQaF+C7tSzIro=;
        b=6cBSCgO5rijBLyF5SkWFWA/f6Pi3GfVOybH4EqJGlHt1FXNsBOd8usH/LBobJMknC1RT74
        SDV4UWD5riLWQjDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1ADEF13D3F;
        Thu, 14 Oct 2021 07:09:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id y+3eApTXZ2FqEgAAMHmgww
        (envelope-from <hare@suse.de>); Thu, 14 Oct 2021 07:09:08 +0000
Subject: Re: iSCSI Abort Task and WRITE PENDING
To:     Konstantin Shelekhin <k.shelekhin@yadro.com>
Cc:     target-devel@vger.kernel.org, linux@yadro.com
References: <YWbdbh1w1Eiw82Zr@yadro.com>
 <2a819e5d-c77a-94e8-1fe2-0ba81e7c9fa3@suse.de> <YWby1FD69Sz4W8eX@yadro.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <5b7c289a-c2bf-b7d0-9ee3-0692871333b0@suse.de>
Date:   Thu, 14 Oct 2021 09:09:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YWby1FD69Sz4W8eX@yadro.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 10/13/21 4:53 PM, Konstantin Shelekhin wrote:
> On Wed, Oct 13, 2021 at 04:22:41PM +0200, Hannes Reinecke wrote:
>> On 10/13/21 3:21 PM, Konstantin Shelekhin wrote:
>> Short answer: you can't.
>>
>> There is no feasible path in the I/O stack to abort running I/O; the
>> only chance you have here is to wait for it to time-out.
>>
>> We have run into similar issues, and found that the only sane solution
>> was to wait for the I/O to come back and then retry.
>> As this would take some time (30 seconds if you are unlucky) most
>> initiators will get unhappy and try to reset.
>> Which won't work, either, as the I/O is still stuck.
>> So we finally delayed relogin until all I/O was cleared.
>>
>> Not the best solution, but the only thing we can do in the absense of a
>> proper I/O abort mechanism.
> 
> I'm not sure we are talking about the same bug. In this case the relogin
> is not possible, because new connections are rejected by the target and
> the existing one is not going anywhere, because it's deadlocked on ABORT
> TASK. The only solution is to reset the server.
> 
Precisely.

Relogin fails as there is I/O outstanding on the original session, and 
you try to relogin into the same session. Which is still busy, hence you 
cannot login.

And I/O is outstanding as it can't be aborted, as the only transport 
implementing abort is target_core_user.c; for all the others you are 
screwed.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
