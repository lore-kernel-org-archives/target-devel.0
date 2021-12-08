Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90869C433EF
	for <target-devel@archiver.kernel.org>; Wed,  8 Dec 2021 12:43:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbhLHMrV (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 8 Dec 2021 07:47:21 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:38248 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229496AbhLHMrV (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 8 Dec 2021 07:47:21 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R441e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0Uzw.fyt_1638967422;
Received: from 30.225.28.158(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0Uzw.fyt_1638967422)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 08 Dec 2021 20:43:43 +0800
Message-ID: <00c1cb51-2396-6a72-2c1c-2152d73c4541@linux.alibaba.com>
Date:   Wed, 8 Dec 2021 20:43:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Content-Language: en-US
To:     target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: tcmu data area double copy overhead
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

hi，

I'm a newcomer to tcmu or iscsi subsystem, and have spent several days 
to learn
iSCSI and tcmu, so if my question looks fool, forgive me :)

One of our customers is using tcmu to visit remote distributed 
filesystem and finds
that there's obvious copy overhead in tcmu while doing read operations, 
so I spent
time to find the reason and see whether can optimize a bit. Now 
according to my
understanding about tcmu kernel codes, tcmu allocates internal data 
pages for data
area, use these data pages as temporary storage between user-space 
backstore and
tcmu. For iSCSI initiator's write request, tcmu first copy sg page's 
content to internal
data pages, then user-space backstore moves mmaped data area for these 
data pages
to backstore; for iSCSI initiator's read request, tcmu also allocates 
internal data pages,
backstore copies distributed filesystem's data to these data pages, 
later tcmu copy
data pages' content to sg's pages. That means for both read and write 
requests, it
exists one extra data copy.

So my question is that whether we don't allocate internal data pages in 
tcmu, just make
sg's pages to be mmaped in data area, so we can reduce one extra copy, 
which I think
it can improve throughput. Or is there any special security issues that 
we can not do
this way? Thanks.


Regards,
Xiaoguang Wang
