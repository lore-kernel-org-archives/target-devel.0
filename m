Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85739CD37B0
	for <target-devel@archiver.kernel.org>; Mon, 18 Sep 2023 22:00:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbjIRWAT (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 18 Sep 2023 18:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjIRWAT (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 18 Sep 2023 18:00:19 -0400
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C37D83
        for <target-devel@vger.kernel.org>; Mon, 18 Sep 2023 15:00:13 -0700 (PDT)
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-68fbd5cd0ceso4441732b3a.1
        for <target-devel@vger.kernel.org>; Mon, 18 Sep 2023 15:00:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695074412; x=1695679212;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xILTodmrczk5oPVX1p5OmsXkgrdSItgtnECJsiyzxbk=;
        b=VTYgZej9pEloCDa6oHfa0c9nhT208Tsb+5TbOuPdU/BDkyTvxK6ybFBzaIcVOfG6HN
         dLBCk9A/sZWXPSf9w43FKMzwk9UWGatyyCYll3VuwRik8naPAVdH9qKaK3CQaeRkFZNJ
         k3WHl97ga/NUfDb0LvvRJg3vaVuXDpjhlDrS2SnMDEhke5iuNFwQnd6YC9nnP3Qozi9j
         kYDFJd8MjAjKGTpkkiFMYoydefwiYKd73TOVhVydt6lYFOecQXwNMdiVy+0W581ecySh
         sorh78fk9u4pjy0B8U0wSjG4F6UzEh91izEaOf0TF9tG1FHPwHJRZmlBDJgnbTc2GIM8
         wxmQ==
X-Gm-Message-State: AOJu0YzZ7nvHKJE8q3DIDMq3ulK0L65mgVmJ9psMmC4kD+b1BViGMC5t
        LsPUezjcXAJt8VcoOs+rJnM=
X-Google-Smtp-Source: AGHT+IGlIHfLDbJpBdwtxFPKT8HrqYvc085jG5EBmLdOLB0O8DqggvxnrJJTqdkZluPxKa9jIkJQPA==
X-Received: by 2002:a05:6a00:39a5:b0:682:4c1c:a0fc with SMTP id fi37-20020a056a0039a500b006824c1ca0fcmr12521194pfb.19.1695074412307;
        Mon, 18 Sep 2023 15:00:12 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:33e7:1437:5d00:8e3b])
        by smtp.gmail.com with ESMTPSA id fe20-20020a056a002f1400b00687dde8ae5dsm7514850pfb.154.2023.09.18.15.00.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 15:00:11 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Mike Christie <mchristi@redhat.com>,
        Christoph Hellwig <hch@lst.de>, target-devel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/3] Replace references to linux-iscsi.org
Date:   Mon, 18 Sep 2023 14:59:38 -0700
Message-ID: <20230918215941.2053109-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.459.ge4e396fd5e-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

Hi Martin,

Since the website www.linux-iscsi.org no longer exists, this patch series
removes the references to that website. Please consider this patch series
for the next merge window.

Thanks,

Bart.

Bart Van Assche (3):
  scsi: target: Remove the references to http://www.linux-iscsi.org/
  scsi: target: Remove linux-iscsi.org copyright statements
  scsi: target: Change nab@linux-iscsi.org into nab@kernel.org

 Documentation/target/tcm_mod_builder.rst          | 2 +-
 MAINTAINERS                                       | 2 --
 drivers/infiniband/ulp/isert/ib_isert.c           | 4 ++--
 drivers/target/iscsi/Kconfig                      | 9 ++++++---
 drivers/target/iscsi/iscsi_target.c               | 4 ++--
 drivers/target/iscsi/iscsi_target_auth.c          | 2 +-
 drivers/target/iscsi/iscsi_target_configfs.c      | 2 +-
 drivers/target/iscsi/iscsi_target_datain_values.c | 2 +-
 drivers/target/iscsi/iscsi_target_device.c        | 2 +-
 drivers/target/iscsi/iscsi_target_erl0.c          | 2 +-
 drivers/target/iscsi/iscsi_target_erl1.c          | 2 +-
 drivers/target/iscsi/iscsi_target_erl2.c          | 2 +-
 drivers/target/iscsi/iscsi_target_login.c         | 2 +-
 drivers/target/iscsi/iscsi_target_nego.c          | 2 +-
 drivers/target/iscsi/iscsi_target_nodeattrib.c    | 2 +-
 drivers/target/iscsi/iscsi_target_parameters.c    | 2 +-
 drivers/target/iscsi/iscsi_target_seq_pdu_list.c  | 2 +-
 drivers/target/iscsi/iscsi_target_stat.c          | 2 +-
 drivers/target/iscsi/iscsi_target_tmr.c           | 2 +-
 drivers/target/iscsi/iscsi_target_tpg.c           | 2 +-
 drivers/target/iscsi/iscsi_target_util.c          | 2 +-
 drivers/target/target_core_configfs.c             | 2 +-
 drivers/target/target_core_fabric_configfs.c      | 2 +-
 drivers/target/target_core_fabric_lib.c           | 2 +-
 drivers/target/target_core_file.c                 | 2 +-
 drivers/target/target_core_iblock.c               | 2 +-
 drivers/target/target_core_pscsi.c                | 2 +-
 drivers/target/target_core_stat.c                 | 2 +-
 drivers/target/tcm_fc/tfc_conf.c                  | 4 +---
 drivers/target/tcm_fc/tfc_io.c                    | 3 +--
 30 files changed, 36 insertions(+), 38 deletions(-)

