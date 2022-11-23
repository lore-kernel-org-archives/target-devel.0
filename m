Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4680BC433FE
	for <target-devel@archiver.kernel.org>; Wed, 23 Nov 2022 11:50:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235909AbiKWLt7 (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 23 Nov 2022 06:49:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiKWLt6 (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 23 Nov 2022 06:49:58 -0500
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6314D65E4
        for <target-devel@vger.kernel.org>; Wed, 23 Nov 2022 03:49:56 -0800 (PST)
Received: by mail-wr1-f50.google.com with SMTP id cl5so29023269wrb.9
        for <target-devel@vger.kernel.org>; Wed, 23 Nov 2022 03:49:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1z4FdpHNfe+Wlm/1wt4TCkg01HwRJuToZ+pK6DOQGwI=;
        b=JVR/Lmh9LaiyzBpt+9ssUrmpl6QaEW9RMhfjieExdydeDo+W1wwBUEXTXFKlRxRsT+
         sa9R3U8MsL4YURAiFyYpnhq/1qrwtwfDo7WtgOWktJbb7n/SxnLrXwIdGNLr9UOxuE0m
         kXe+gsoErs+19HN6rMHOTEKsNYz5IwWlcCF+rx6mI+lc2wFxLVy0VP/yj2cBWJu8xizb
         VX1BpK9oBYCEyww2BkFDcekbB9krxelxQIs5xOhMsduLANyJdyPhIq1RYF+Q04FSAxpc
         e9R1mWab1TfhJkHasHKDyTJEIdU+hq+FjE4k0K1MZQaK2aeoGGXLL1Rn1PUIdUJe1rWU
         bZSw==
X-Gm-Message-State: ANoB5pms5i0koBLlZL4om7QB3lqPduZwUJEm5yfisBROMKpRlCDifkTw
        V3slj+6CErWV/tA9JxCK6DuaZiicpXw=
X-Google-Smtp-Source: AA0mqf67nYI7tfNCfVADiGYmUwJR8dgWkcI6htEmVOYwTSJ1ofPSLhd7hxdGmOBer3YPJY7G5QrTsg==
X-Received: by 2002:a5d:5957:0:b0:22e:3e9:ba15 with SMTP id e23-20020a5d5957000000b0022e03e9ba15mr16389631wri.180.1669204194741;
        Wed, 23 Nov 2022 03:49:54 -0800 (PST)
Received: from [10.100.102.14] (46-116-236-159.bb.netvision.net.il. [46.116.236.159])
        by smtp.gmail.com with ESMTPSA id bn6-20020a056000060600b00241d2df4960sm9569396wrb.17.2022.11.23.03.49.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Nov 2022 03:49:54 -0800 (PST)
Message-ID: <b7511c59-7a25-cf22-71e7-9333a2f332c1@grimberg.me>
Date:   Wed, 23 Nov 2022 13:49:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: targetcli fabric modules
To:     Luis Navarro <ln@lunadesign.net>, target-devel@vger.kernel.org
References: <08aa01d8febc$74f61260$5ee23720$@lunadesign.net>
Content-Language: en-US
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <08aa01d8febc$74f61260$5ee23720$@lunadesign.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org


> Hi all,
> 
> I hope this is the right place to ask a general (possibly dumb) question
> about targetcli and fabric modules.
> 
> My target is Ubuntu 22.04.1 LTS and my initiator is ESXi 6.7.  Both are
> using Mellanox MCX515A-CCAT connected via a single 100G QSFP28 DAC cable.
> 
> On the server, I've used "apt" to install the "targetcli-fb" package and
> have successfully configured it as an iSCSI target for my ESXi server.
> 
> However, I'm now trying to get ISER working and I'm noticing that when I
> start a "targetcli" session, I'm not seeing "Using iser fabric module" (or
> any "Using" messages for that matter) that I see in the snippet on
> linux-iscsi dot org/wiki/ISER (excellent site, BTW!).
> 
> My question:  Do the fabric modules get loaded/enabled automatically
> (perhaps when it detects a ROCEv2 enabled NIC)?  Or do I have to do
> explicitly do something to make this happen?

When setting a portal to iser enabled, the driver should be
automatically loaded.

I just ran with ubuntu 22.04 and targetcli-fb:
--
/iscsi/iqn.20...c34978ad/tpg1> portals/0.0.0.0:3260 enable_iser true
iSER enable now: True
/iscsi/iqn.20...c34978ad/tpg1> ls
o- tpg1 
..................................................................................................... 
[no-gen-acls, no-auth]
   o- acls 
................................................................................................................ 
[ACLs: 0]
   o- luns 
................................................................................................................ 
[LUNs: 0]
   o- portals 
.......................................................................................................... 
[Portals: 1]
     o- 0.0.0.0:3260 
......................................................................................................... 
[iser]
--

# targetcli --version
/usr/bin/targetcli version 2.1.53
