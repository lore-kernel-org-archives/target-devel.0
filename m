Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24830C54EAA
	for <target-devel@archiver.kernel.org>; Fri, 27 Jan 2023 09:59:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbjA0J7k (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Fri, 27 Jan 2023 04:59:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232615AbjA0J7k (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Fri, 27 Jan 2023 04:59:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39E4C1717F
        for <target-devel@vger.kernel.org>; Fri, 27 Jan 2023 01:58:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674813532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=I41gfGyy6InK2dqZkVSVDEWkgswtom5ob/hRpHAIV8o=;
        b=JlXR4vzaIoubpV08U5VLhFfaN0Y5bTfcXrMtns+qfw/J8Fj8iASDcxXDS4ORo7MuFiTSRa
        iW4ZbArYRrBNX/tsfWurVcRbKenukqPrPeB64uOvmgIlSvAX3F1NkgSmXCFBdHeg4UWCLu
        qqkAPHOMJtnmBPVZ5XcOcjXwkuyoA4c=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-321-lcYXXv_hPHWAnNgbSjTvCQ-1; Fri, 27 Jan 2023 04:58:51 -0500
X-MC-Unique: lcYXXv_hPHWAnNgbSjTvCQ-1
Received: by mail-lf1-f72.google.com with SMTP id o16-20020ac24950000000b004d5811430c3so1873909lfi.7
        for <target-devel@vger.kernel.org>; Fri, 27 Jan 2023 01:58:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I41gfGyy6InK2dqZkVSVDEWkgswtom5ob/hRpHAIV8o=;
        b=RwkuOg3s3Dkc9BWECPZQUFXnkWcjYsi6m001ZFhZzPG9ry44Pz3IGOWoia88cSJ2zu
         P9Y2vp+h0jhioaPhTXt4qOlSzRsGOUXFlkEnTEDmPZbOjQs2csH4mvrRgIxJyPGZWIOe
         eFs5SgAWZs33SYNHPL5SA8VwTf815HuKd/NKtl9+x6ZBZLvBRGZAZzl6zWjhXo0yzfqw
         Vgu1Y+J0+yUJIZBaO2CIjR/WdCeQ7Om2oi8/3gn0UtVIzr7J0w9VN3LsdM4MpiPetk17
         I6tCIJcWT2cy4V5qovzBAp84HO/czDuFYHZJPvL1MdaaklGelZcLwUm3rRylzeit3KKb
         Gvbg==
X-Gm-Message-State: AO0yUKUThVoUy1jM7br4w1fGAATu9kEgNEKVsDCpuxWvmcBJ7tQCf69z
        BbmBMtD6pfSvADl3KcNRjeWsjl/m1Abt4peGmDHLRIWdvb2nrSyKeHUMhy9aZmTL93SDnHkWx1B
        Vz5QDht0mrB/EdB7LKzX1iI3VFjhbSxfdNgJWCxnc
X-Received: by 2002:a05:6512:12cc:b0:499:fa38:3da4 with SMTP id p12-20020a05651212cc00b00499fa383da4mr838634lfg.12.1674813526496;
        Fri, 27 Jan 2023 01:58:46 -0800 (PST)
X-Google-Smtp-Source: AK7set8BuOzQxEt9q/awnFhHj5z0f2Uw+xXWalsiQq8oMp/WRs1UJ0/mrdI/l/9X1jRzJQMQWipcdTtb4fF+Qloo5J8=
X-Received: by 2002:a05:6512:12cc:b0:499:fa38:3da4 with SMTP id
 p12-20020a05651212cc00b00499fa383da4mr838631lfg.12.1674813526272; Fri, 27 Jan
 2023 01:58:46 -0800 (PST)
MIME-Version: 1.0
From:   Maurizio Lombardi <mlombard@redhat.com>
Date:   Fri, 27 Jan 2023 10:58:33 +0100
Message-ID: <CAFL455m0amBULArG5dNHrrGKJ8Jg4n3SdnvzOavz4=i2FUR5Sg@mail.gmail.com>
Subject: deadlocks when the target server runs as initiator to itself
To:     Mike Christie <michael.christie@oracle.com>, d.bogdanov@yadro.com
Cc:     target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

Hello Mike, Dmitry,

A customer of ours needs an unusual configuration where an iSCSI initiator
runs on the same host of the target;
in other words, the host sees an iSCSI disk which is in fact just a local disk.

The problem is that under heavy load sometimes the system hangs,
example of backtrace:

    crash> bt 2037117
    PID: 2037117  TASK: ffff8bb4c901dac0  CPU: 0    COMMAND: "iscsi_trx"
     #0 [ffffa3f4199db378] __schedule at ffffffff9134b2ed
     #1 [ffffa3f4199db408] schedule at ffffffff9134b7c8
     #2 [ffffa3f4199db418] io_schedule at ffffffff9134bbe2
     #3 [ffffa3f4199db428] rq_qos_wait at ffffffff90e61245
     #4 [ffffa3f4199db4b0] wbt_wait at ffffffff90e7bb99
     #5 [ffffa3f4199db4f0] __rq_qos_throttle at ffffffff90e60fc3
     #6 [ffffa3f4199db508] blk_mq_make_request at ffffffff90e5159d
     #7 [ffffa3f4199db598] generic_make_request at ffffffff90e4592f
     #8 [ffffa3f4199db600] submit_bio at ffffffff90e45bcc
     #9 [ffffa3f4199db640] xlog_state_release_iclog at ffffffffc0358cae [xfs]
    #10 [ffffa3f4199db668] __xfs_log_force_lsn at ffffffffc0359059 [xfs]
    #11 [ffffa3f4199db6d8] xfs_log_force_lsn at ffffffffc035a21f [xfs]
    #12 [ffffa3f4199db710] __xfs_iunpin_wait at ffffffffc03454e6 [xfs]
    #13 [ffffa3f4199db780] xfs_reclaim_inode at ffffffffc033c203 [xfs]
    #14 [ffffa3f4199db7c8] xfs_reclaim_inodes_ag at ffffffffc033c620 [xfs]
    #15 [ffffa3f4199db948] xfs_reclaim_inodes_nr at ffffffffc033d851 [xfs]
    #16 [ffffa3f4199db960] super_cache_scan at ffffffff90d1cad2
    #17 [ffffa3f4199db9b0] do_shrink_slab at ffffffff90c73e9c
    #18 [ffffa3f4199dba20] shrink_slab at ffffffff90c74761
    #19 [ffffa3f4199dbaa0] shrink_node at ffffffff90c7908c
    #20 [ffffa3f4199dbb20] do_try_to_free_pages at ffffffff90c79659
    #21 [ffffa3f4199dbb70] try_to_free_pages at ffffffff90c79a5f
    #22 [ffffa3f4199dbc10] __alloc_pages_slowpath at ffffffff90cbcd31
    #23 [ffffa3f4199dbd08] __alloc_pages_nodemask at ffffffff90cbd953
    #24 [ffffa3f4199dbd68] sgl_alloc_order at ffffffff90e80e08
    #25 [ffffa3f4199dbdb8] transport_generic_new_cmd at
ffffffffc0972ce5 [target_core_mod]
    #26 [ffffa3f4199dbdf8] iscsit_process_scsi_cmd at ffffffffc09eabf5
[iscsi_target_mod]
    #27 [ffffa3f4199dbe18] iscsit_get_rx_pdu at ffffffffc09ec239
[iscsi_target_mod]
    #28 [ffffa3f4199dbed8] iscsi_target_rx_thread at ffffffffc09eda61
[iscsi_target_mod]
    #29 [ffffa3f4199dbf10] kthread at ffffffff90b036c6

This is what I think it may happen:

The rx thread receives an iscsi command, calls sgl_alloc() but the
kernel needs to reclaim memory to satisfy the allocation; the memory
reclaim code starts a flush against the filesystem mounted on top of
the iscsi device, this ends up in a deadlock because the filesystem
needs the
target driver to complete the task, but the iscsi_rx thread is stuck
in sgl_alloc().

Sounds correct to you?

What do you think about using memalloc_noio_*() in the iscsi_rx thread
to prevent the memory reclaim code from starting I/O operations? Any
alternative ideas?

Thanks!
Maurizio

