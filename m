Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50E77C04FF8
	for <target-devel@archiver.kernel.org>; Wed, 20 Sep 2023 20:02:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbjITUCy (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 16:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbjITUCx (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 16:02:53 -0400
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06342A1
        for <target-devel@vger.kernel.org>; Wed, 20 Sep 2023 13:02:47 -0700 (PDT)
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-69101022969so143457b3a.3
        for <target-devel@vger.kernel.org>; Wed, 20 Sep 2023 13:02:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695240166; x=1695844966;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W9vwPaA5yMCAnKKLcFZMasWCJqwvS0tPm+zQylhR3jM=;
        b=tsS+lgOrB7FgFyd3QzHXQeXqL73kofPgHwe4B4NyqE3sdBdSLN+hR2/Ub77q9NE3wA
         acrwdd3CSqiH1y5XLmMJUT8GochxFHxqRiAtTwNzsp+UTs8f0n85IN8RxPyba2Zk+K49
         gjRcmR0BbY43uiLIxDWFgVaACGQ+lcTYNhfbC5mCQqzJuJEeu1BccZghRG5eLsoQ7KLu
         8fQbmk5lz7xpN8nDsuuKUHRZTW8Yf18S7QA9WWqqe00ByiWUWmPBP+JOamcyOmsdmYfF
         lKgcz4ocZI7YF1B/r40uqFlTeAujbbpnCq7p4ojjiq2vNx8B6/A/8utvYkyRnBEcUzWv
         LvNQ==
X-Gm-Message-State: AOJu0YyxPZuB8+SFEQNiWgtj1ayX4RyyV0cmahabe68yZ9/59HETMUzE
        IocM7JdgPdoL0CZXHM/LdAM=
X-Google-Smtp-Source: AGHT+IEoAp470rqch6S7TCzwMZmcrUrIELpUJmSK6qPCpzGW6plxGg6mYe1rkVDngx13j2Tk15K43A==
X-Received: by 2002:a05:6a00:9a6:b0:68c:3f2:5ff7 with SMTP id u38-20020a056a0009a600b0068c03f25ff7mr4165583pfg.1.1695240166307;
        Wed, 20 Sep 2023 13:02:46 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:b0c6:e5b6:49ef:e0bd])
        by smtp.gmail.com with ESMTPSA id c70-20020a633549000000b0054fe7736ac1sm10035341pga.76.2023.09.20.13.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Sep 2023 13:02:45 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Mike Christie <mchristi@redhat.com>,
        Christoph Hellwig <hch@lst.de>, target-devel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/3] Replace most references to linux-iscsi.org
Date:   Wed, 20 Sep 2023 13:00:18 -0700
Message-ID: <20230920200232.3721784-1-bvanassche@acm.org>
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

Changes compared to v1:
- Modified the description of patch 2/3.
- Modified patch 3/3 such that the email addresses in copyright statements are
  not modified.

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
 drivers/target/tcm_fc/tfc_conf.c                  | 2 --
 drivers/target/tcm_fc/tfc_io.c                    | 1 -
 30 files changed, 34 insertions(+), 36 deletions(-)

