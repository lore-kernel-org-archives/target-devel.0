Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2807AC433E0
	for <target-devel@archiver.kernel.org>; Fri, 22 Jan 2021 10:57:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA3F320739
	for <target-devel@archiver.kernel.org>; Fri, 22 Jan 2021 10:57:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbhAVK53 (ORCPT
        <rfc822;target-devel@archiver.kernel.org>);
        Fri, 22 Jan 2021 05:57:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727364AbhAVJ3P (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Fri, 22 Jan 2021 04:29:15 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 584E7C061786
        for <target-devel@vger.kernel.org>; Fri, 22 Jan 2021 01:28:35 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id d2so2186718edz.3
        for <target-devel@vger.kernel.org>; Fri, 22 Jan 2021 01:28:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=e8zlznAImcFn6aUQKKQ/ezvduZl3NWTYoAtSuyukN7E=;
        b=BRbFnfHDIs/smHNgoUrxYDsFF05nDbpo8aSX5PfzleHap763MuKQwDfK8u29Egxixj
         LCg013vU1qCYwBh/SMZ8szaUPk+K5RJooP2EyszdG93GCzNP0+yTdjHxZgJ//gzygcOz
         jArtPCqymk9K81zX3cm4IOjMeFbE06eym3lNUPhR4WZokG/h+vhIOlluYchjHAJe2/wv
         ctoKg+wMd5of+A0178pvtkJUHW891tZo2G4b1lAcikc1QrB/V+fkdJXpi0rQp0EsOl4w
         045fYov7QDjRjW6IQ2u5TVSfVF76TRDw+xRa7zVuj5ORUtWyC7ZzUfDYAr3l4ETfM5CW
         A5pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=e8zlznAImcFn6aUQKKQ/ezvduZl3NWTYoAtSuyukN7E=;
        b=NuQy/G4D3sK0nOvNaojXy7vjabI20SB/PdulOT9jMsGlICmLQ7UeCLAqJRctLoUAi9
         ToNashNnFLKZKcSaNb/PuTN99tCrWKCbha1joKW+utLCUVeyM44xCwQI6kzsT8NpOK1C
         vRKN+aF0Wo/I4hVfAoEZVhXCM2trE2xNlxVRptxokzlYjWdQGNZspZdIe8xiSoeSGPr3
         Blc3Oxky2HZcMlNFMYCRwEzv5ztOLiug90JUqEnGPJre7szOqSmxuvDxFTbSHCxtAUFS
         cqCzuNuOBKw5xQe4eIk3K+JuFnpTWdPpveobxNyHi+62njkEXXo/VgCF2EX2Dk2U4dDD
         MjPw==
X-Gm-Message-State: AOAM533wi8X5//zOHA8p3W+WgI3CHoUjB//WiTY5EoyYc87g5E9YRoek
        rUYYn5+L+pbTGJ1tpJnb6R5NyshJCH7eRF2a
X-Google-Smtp-Source: ABdhPJyMaoODmdy8RXoi2rfv+If9xXYUfirTcZFY48nRrUmzOPPhl1zUfZ7bEVx62nyqAu1KqG1gJA==
X-Received: by 2002:a50:bacb:: with SMTP id x69mr2476714ede.39.1611307713947;
        Fri, 22 Jan 2021 01:28:33 -0800 (PST)
Received: from ls00508.pb.local ([2001:1438:4010:2540:481b:68e3:af3e:e933])
        by smtp.gmail.com with ESMTPSA id g17sm4684508edb.39.2021.01.22.01.28.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 01:28:33 -0800 (PST)
From:   Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
To:     axboe@kernel.dk
Cc:     linux-block@vger.kernel.org, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-ide@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-nfs@vger.kernel.org,
        hch@infradead.org, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: [PATCH V2 0/2] remove unused argument from blk_execute_rq_nowait and blk_execute_rq
Date:   Fri, 22 Jan 2021 10:28:22 +0100
Message-Id: <20210122092824.20971-1-guoqing.jiang@cloud.ionos.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

V2 changes:
1. update commit header per Christoph's comment.

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

