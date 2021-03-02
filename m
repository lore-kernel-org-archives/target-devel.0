Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D847AC433E0
	for <target-devel@archiver.kernel.org>; Wed,  3 Mar 2021 04:44:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 961C564E67
	for <target-devel@archiver.kernel.org>; Wed,  3 Mar 2021 04:44:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344207AbhCCEd7 (ORCPT
        <rfc822;target-devel@archiver.kernel.org>);
        Tue, 2 Mar 2021 23:33:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34657 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1383355AbhCBL1h (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Tue, 2 Mar 2021 06:27:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614684370;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lo2s5SQiKV70dlGo7mTZAO1iOrWIOPSlewk20ESJ59w=;
        b=Dl4DbX1ZBOnU/L2RI+WQsKo98m02lLS69U+Q7nzJfNC9rUe4M4yoP8pTwqMyih9BXwAYWx
        oj8FTk9dsbMDZMFs1B9GBCEM2M7sFubkScr/LNj81mq8o2TYKwBXlZoFIXejjEHeWFO+RJ
        4bOmDawnei+D+J4miTIRqnd0XUGbElA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-550-yuMhc0nNOTiMBEOaW33iyw-1; Tue, 02 Mar 2021 06:22:19 -0500
X-MC-Unique: yuMhc0nNOTiMBEOaW33iyw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4504F107ACE8;
        Tue,  2 Mar 2021 11:22:18 +0000 (UTC)
Received: from [10.40.193.149] (unknown [10.40.193.149])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6B4755C8A7;
        Tue,  2 Mar 2021 11:22:17 +0000 (UTC)
Subject: Re: Stability of FILEIO as backing store?
To:     Forza <forza@tnonline.net>,
        Mike Christie <michael.christie@oracle.com>,
        target-devel@vger.kernel.org
References: <af031d3.b2327dec.177db1f2641@tnonline.net>
 <b4397eb1-db51-7cf2-b881-88fe7bcfa7bb@oracle.com>
 <24226ad.50248908.177dd3502ec@tnonline.net>
 <0d561b83-1bb5-aa4c-8adc-953036e2f003@oracle.com>
 <2feabdd.b5c9def5.177ee7128e8@tnonline.net>
From:   Maurizio Lombardi <mlombard@redhat.com>
Message-ID: <08682666-d350-6cbd-14e1-f550f49d75b6@redhat.com>
Date:   Tue, 2 Mar 2021 12:22:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <2feabdd.b5c9def5.177ee7128e8@tnonline.net>
Content-Type: text/plain; charset=iso-8859-2
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

Hello, I'm trying to reproduce the problem you reported on Fedora 33

Dne 01. 03. 21 v 16:38 Forza napsal(a):
> 
> Also, the "aio" attribute  is different. Perhaps I set it manually in Fedora, but I cannot remember. It is not visible in /sys but is in the saveconfig.json.
> Ubuntu:
>   "storage_objects": [
>     {
>       "aio": false,
> Fedora:
>   "storage_objects": [
>     {
>       "aio": true,
> 
> Does "aio" mean Async I/O in this case? I could not find any documentation for this attribute.

Yes, it means "async I/O" but I don't understand why it's set to true.
Looking at the rtslib/targetcli sources, aio by default is set to false and
it's not even possible to change it via targetcli.
You likely changed it manually in the saveconfig.json file.

Btw, there is a possible race condition in kernel versions < v5.12-rc1
when async i/o is enabled:

In the fd_execute_rw_aio() function, the bvec pointer is freed before the
async command is completed, might be the reason behind the disk corruptions?

This has been fixed with commit ecd7fba0ade1d6d8d49d320df9caf96922a376b2

Maurizio

