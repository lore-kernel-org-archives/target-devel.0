Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D91A7C74A5B
	for <target-devel@archiver.kernel.org>; Wed, 29 Mar 2023 11:51:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbjC2Lvw (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 29 Mar 2023 07:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjC2Lvv (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 29 Mar 2023 07:51:51 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F25F46B3
        for <target-devel@vger.kernel.org>; Wed, 29 Mar 2023 04:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.at; s=s31663417;
        t=1680090705; i=ldm@gmx.at;
        bh=KRdcLHNW1la/TjfpHY/cYT14N8EbJDJ7UP213Vt3ni4=;
        h=X-UI-Sender-Class:From:To:Subject:Date;
        b=FmoWkAmFQZ6ONSM4uLcioKQ9ezsgaqktoSbZveeLG2CflVKO73SINMqwEPG4/c+6M
         pIlmVNR+g8aOJE5HkGwP24OkgWIi9zS88vwW+YIPJxZhDUUD0IQYx4Fb9H1tabfeKh
         rHDbhyRHab7w+a57mMJPyUEIIZosaf5q1i2rVueQ7Z3Mv+OmFXNmneYMtKdXfQOX3O
         W9HNVXARKljJtsnQo86D+4QEVP7jp3wNFDtqf22z7mgbQjtE+CFn+X1mBxPFSW6AK0
         7Uy/EeshoYP1ojuRueaIOT6d5VswlSm7wv1C6vmdGVHuxFWngx1/WLD3VA2LDKsP8W
         BK0SduLvwi5CA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [62.178.21.45] ([62.178.21.45]) by web-mail.gmx.net
 (3c-app-gmx-bs24.server.lan [172.19.170.76]) (via HTTP); Wed, 29 Mar 2023
 13:51:44 +0200
MIME-Version: 1.0
Message-ID: <trinity-7a9a1e34-4702-4c7a-8012-e540eea4447b-1680090704891@3c-app-gmx-bs24>
From:   Ldm@gmx.at
To:     target-devel@vger.kernel.org
Subject: Fw: Poor or non existent documentation of attributes
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 29 Mar 2023 13:51:44 +0200
Importance: normal
Sensitivity: Normal
X-Priority: 3
X-Provags-ID: V03:K1:TXfJSS76blrceLLLvMHeOauHKrs0cQ3AS9KzwxPNpSbKeo20gQ7qzoeFC61OgIEXYlWvv
 1Em1e/Fiv9S9/k0EgA/fI36K87DHthC1OXVkACuiozuOrb8ZzfdrddBQhmyvcX1hVEoj6oE32Fc7
 yE5Yug9xJrKF6zQzbmtsyfqmBDfV+SjrtSFX9wG9j19HO8BLTUShI4xe6D5dEOZ6NwkAQ3lBv4y+
 1kip6cv6x1uB4E6Sx5WK49RGIg6+4cCmzOGs9y6Qi8EPlmxkhTSEnkF9tk8ZS7ljk94ZLxUC7ZRR
 rw=
UI-OutboundReport: notjunk:1;M01:P0:TUN1D9ZEaXk=;6K06J32CSYObtmnFlnfKbrb3svU
 lv6cqfbRjBH6qJ/tB2+XqUZ04m1R1/TTXHcFnQkLlI8sIU9MbKWAy6dE8ibyvxRUNW9KqfZJB
 ckMZ81w/co8oN3G6X5a9JNQRTX9VXQDSzShagsYW/2FwdjK+9ziyo75LtnOUm725HKefv2Zs7
 EHsitZnjnPFZkeAaUwIxeYPMfUWn8IZYzUY5UCAzIEP+BWPy5C1KYJr16CN/x/WpHSirwKBzn
 CFNKZwu635UgPG4+xxjLGkV21ESQRKuEnSKPJgD1hKrnUp/dCnyztA303z+uWWYsonD4S78kt
 0kgp7vEJaK/zrX4Swf6h0jq3ihoSikyvru5HEYAqdktZYHPi9DhtV+ADNm5ppMf/Dx3uyUlas
 NF39UA1xIcgsw/geGX3z/yvDfOCLt+zi2GG/hZp6D812Gl6YMPljWJxDzwTQ3oYw6B8Nb5VSQ
 Tao9xinKg32lD8Lg61ai06ci1+tukr/e8golfORdaI6UZ+AVyVyT/Tbq7lq9C4C5U7uwDZW5g
 AOHpRHHfOc/d+gKEboH5r8r+qV9V7QpOwG40aOIN2h57HBHXWxhQUzqrjkWUjwYR32ReAglpK
 Dwy0Th3vuyF90CTKm6O9CmiJuBh6MYrvhJcQVWA5jC4bCFSm4wGU0lLysxi5rdfrwDmDfKC2Y
 wr+9sc3tuKSKT+nYtjtP6+s02uhYxj4IoIhMiytU+scqCNTaJq1l68cNm8+NwcdtME1KVONXi
 xxw1PI+aBasTUcBPHozKr4teFyrqhjVZ4FKIWTvu+Y5gNalZGgg/iuPyyzz9MLS+p9Wy7V2zB
 kKJSfyavfplwR1qE1nCl/E6JQVkqJB9044UZpDf+bf1DM=
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

Hi,

about 6 months ago I wanted do change the sector size that is reported for a target via iSCSI. After a long Google search I found a single Reddit thread that explained that there is a possibility to configure "set attributes block_size=4096" on a block device backstore. In the mean time I found two other secondary sources about this attribute [2],[3].

But I was very surprised that there seems to be no official documentation of those attributes.

1. The MAN page for targetcli only mentions that attributes are backstore-specific and contain values relating to the backstore and storage object. [4] [5].
2. https://github.com/Datera/targetcli references the http://linux-iscsi.org wiki. Trying to reach that website in a browser yields an ERR_CONNECTION_TIMED_OUT error.
3. https://github.com/Datera/rtslib mentions the same broken website, and a rtslib-API-reference.pdf that I can't retrieve. And a Google search didn't find a single mirror of that file anywhere else [6].
4. Digging through the source code I found a list of attributes for block backstores from a parser code https://github.com/Datera/rtslib/blob/6fd0bbfc20947143eb2e4c3bfd34c65bf8551468/policy/backstore_iblock.lio but this has no description of attributes.
5. There seems to be no description or list of attributes in the RedHat doucumentation [7].
6. The targetcli util claims when I invoke "help set" that I can "Run with no parameter nor group to list all available groups, or with just a group name to list all available parameters within that group." But then when I actually call "set" without argument in a backstore I get en empty "AVAILABLE CONFIGURATION GROUPS ===============".

If I didn't accidentally find this Reddit thread I would have had no chance of knowing howset the block size. If I hadn't digged through the weeds for quite some time to write this email I would have never discovered on [2] that there is "emulate_tpu=1" which "exposes an UNMAP command which is functionally similar to TRIM for SSDs" and "is_nonrot specifies whether the pool is composed of HDDs or SSDs. Windows uses this to decide whether or not to make the iSCSI drive defragmentable", which would have been extremely advantagous to know!

I wasted too much time finding anything useful, I am frustrated. Is the official documentation really that bad, or did I miss something obvious?
Can we improve this situation?

Best regards
Markus


[1] https://www.reddit.com/r/homelab/comments/ror016/lio_target_w_zvol_for_esxi_vmkernellog_lvm_block/
[2] https://forum.level1techs.com/t/guide-iscsi-target-server-on-linux-with-zfs-for-windows-initiator-clients/174803
[3] https://serverfault.com/questions/818655/how-to-specify-sector-size-for-lvm-logical-volume
[4] https://linux.die.net/man/8/targetcli
[5] https://manpages.ubuntu.com/manpages/bionic/man8/targetcli.8.html
[6] https://www.google.com/search?q=%22rtslib-API-reference.pdf%22
[7] https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/storage_administration_guide/online-storage-management

x-posted to stgt AT vger.kernel.org
