Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB341C433E0
	for <target-devel@archiver.kernel.org>; Thu, 21 Jan 2021 14:50:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A66F8238A1
	for <target-devel@archiver.kernel.org>; Thu, 21 Jan 2021 14:50:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731301AbhAUOuK (ORCPT
        <rfc822;target-devel@archiver.kernel.org>);
        Thu, 21 Jan 2021 09:50:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731709AbhAUOlK (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Thu, 21 Jan 2021 09:41:10 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EFBCC08EB25
        for <target-devel@vger.kernel.org>; Thu, 21 Jan 2021 06:29:26 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id hs11so2902128ejc.1
        for <target-devel@vger.kernel.org>; Thu, 21 Jan 2021 06:29:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=6d+dhFnF8O5Dji9MI3uQGCEsi3R81Xte/6yH406EepA=;
        b=iAMU6N4iZaZA9+7UD8H8MnQtQ2Cpe3YeQRtcdIAvDIMVUVH+8jruJobsWtbta2pu9/
         TS8Em6eCbSnkRLg6QmIFMfSZ5NJiLC+P0inASmZ1ck5hcL92XvnYfrUlOIh5NEockg3M
         sngnJTujgRmBntErYNkPTd0lC5Q5BMFqfS/xZ+2i8/20XXJh1hncFJ8r/5F4dE4HO8vc
         msi5NMvm1FcfSz2eZTGnR8q8mysXQrGwM4CEPaKERmRRfWMj9G4a+EFmcV5fQkZvfVMO
         B83i0efToxwbo6fT4gVOFQj0cp9m8jld4Df7IpwukDPFpkDLwdoGd2XTiQfnKp9lWEKD
         guUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6d+dhFnF8O5Dji9MI3uQGCEsi3R81Xte/6yH406EepA=;
        b=ClEwliechgJq+iIwJ8yt5AcP3rQ7wDTMjXYb8SjT3HlqmfjUDOXmzO/+6ucvHFs/dK
         A6bNdlHJfbYfmYXlZJMLGIhnfT5tmywvKRl28oSHH8/SOyL6w5UazyRVcG0/BxW/v4OD
         elvl1TEydGG02u2DGj7YbDEb7B/YexkQKa7733nctUKPF9Th5V7cWnO0RSN2UiRIk4lQ
         49spkFc0yhAQ9CxwqjDP8wAOdfOi76V+pyHH7k0cV9viP59fd5vw1kxQ+cYSEZ7jzm0m
         Pkp3NEmyYJW4zbgPiacFAVD1owoCOV7sBWH8tSYvBHZyYUEmjb7pOY95DVckK1pLQapy
         NEdQ==
X-Gm-Message-State: AOAM533EweP9tlQkfGpNYlnYkw8XMKJbShftSe1virMYeAsbDEH9BCpR
        szqpO10Q3SKPXBIdKrSwixCc/H5yJFnDRmGE
X-Google-Smtp-Source: ABdhPJxCDi5bLwTWjg3Cogi17XLUs88z2mnzLi3uB5dGCnmO1AkoP5tvuP3B7w2NbRmf5F5CDrtLTw==
X-Received: by 2002:a17:906:95cf:: with SMTP id n15mr9672034ejy.178.1611239364997;
        Thu, 21 Jan 2021 06:29:24 -0800 (PST)
Received: from ls00508.pb.local ([2001:1438:4010:2540:481b:68e3:af3e:e933])
        by smtp.gmail.com with ESMTPSA id gt18sm2263684ejb.104.2021.01.21.06.29.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 06:29:24 -0800 (PST)
From:   Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
To:     axboe@kernel.dk
Cc:     linux-block@vger.kernel.org, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-ide@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-nfs@vger.kernel.org,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: [PATCH 0/2] remove unused argument from blk_execute_rq_nowait and blk_execute_rq
Date:   Thu, 21 Jan 2021 15:29:03 +0100
Message-Id: <20210121142905.13089-1-guoqing.jiang@cloud.ionos.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

Hi Jens,

This series remove unused 'q' from blk_execute_rq_nowait and blk_execute_rq.
Also update the comment for blk_execute_rq_nowait.

Thanks,
Guoqing

Guoqing Jiang (2):
  block: remove unnecessary argument from blk_execute_rq_nowait
  block: remove unnecessary argument from blk_execute_rq

 block/blk-exec.c                   | 13 +++++--------
 block/bsg.c                        |  2 +-
 block/scsi_ioctl.c                 |  6 +++---
 drivers/block/mtip32xx/mtip32xx.c  |  2 +-
 drivers/block/paride/pd.c          |  2 +-
 drivers/block/pktcdvd.c            |  2 +-
 drivers/block/sx8.c                |  4 ++--
 drivers/block/virtio_blk.c         |  2 +-
 drivers/cdrom/cdrom.c              |  2 +-
 drivers/ide/ide-atapi.c            |  2 +-
 drivers/ide/ide-cd.c               |  2 +-
 drivers/ide/ide-cd_ioctl.c         |  2 +-
 drivers/ide/ide-devsets.c          |  2 +-
 drivers/ide/ide-disk.c             |  2 +-
 drivers/ide/ide-ioctls.c           |  4 ++--
 drivers/ide/ide-park.c             |  2 +-
 drivers/ide/ide-pm.c               |  4 ++--
 drivers/ide/ide-tape.c             |  2 +-
 drivers/ide/ide-taskfile.c         |  2 +-
 drivers/mmc/core/block.c           | 10 +++++-----
 drivers/nvme/host/core.c           |  8 ++++----
 drivers/nvme/host/lightnvm.c       |  4 ++--
 drivers/nvme/host/pci.c            |  4 ++--
 drivers/nvme/target/passthru.c     |  2 +-
 drivers/scsi/scsi_error.c          |  2 +-
 drivers/scsi/scsi_lib.c            |  2 +-
 drivers/scsi/sg.c                  |  3 +--
 drivers/scsi/st.c                  |  2 +-
 drivers/target/target_core_pscsi.c |  3 +--
 fs/nfsd/blocklayout.c              |  2 +-
 include/linux/blkdev.h             |  5 ++---
 31 files changed, 50 insertions(+), 56 deletions(-)

-- 
2.17.1

