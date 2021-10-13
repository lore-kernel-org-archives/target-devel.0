Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16600C433F5
	for <target-devel@archiver.kernel.org>; Wed, 13 Oct 2021 13:22:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E970F61040
	for <target-devel@archiver.kernel.org>; Wed, 13 Oct 2021 13:22:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233015AbhJMNYD (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 13 Oct 2021 09:24:03 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:58016 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234875AbhJMNYD (ORCPT <rfc822;target-devel@vger.kernel.org>);
        Wed, 13 Oct 2021 09:24:03 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 9B77143F42
        for <target-devel@vger.kernel.org>; Wed, 13 Oct 2021 13:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-disposition:content-type:content-type:mime-version
        :message-id:subject:subject:from:from:date:date:received
        :received:received; s=mta-01; t=1634131311; x=1635945712; bh=MyP
        q5K9P9uii8w21HvqHxLT32Rd4qDReMSAzzYgpmSE=; b=fs6zi3Zow6Hp2Yo61e3
        Sjza6FPzAJXK30GFFqbP5LLc3rmhF56MTjJwdoh9xIxZA0Zvzo3nfUgD84cLLAb6
        7JhIch7J7X/S0+GINUv67SiY7bQH8Efm9W7qbUxQzexkTa1EO/1dURXwPRBU8J4k
        EL6GRGQmfWtpBPvCHXB0DAgo=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id nWdGnfpegnMK for <target-devel@vger.kernel.org>;
        Wed, 13 Oct 2021 16:21:51 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 4AE5B43F3F
        for <target-devel@vger.kernel.org>; Wed, 13 Oct 2021 16:21:51 +0300 (MSK)
Received: from yadro.com (10.199.12.215) by T-EXCH-04.corp.yadro.com
 (172.17.100.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Wed, 13
 Oct 2021 16:21:50 +0300
Date:   Wed, 13 Oct 2021 16:21:50 +0300
From:   Konstantin Shelekhin <k.shelekhin@yadro.com>
To:     <target-devel@vger.kernel.org>
CC:     <linux@yadro.com>
Subject: iSCSI Abort Task and WRITE PENDING
Message-ID: <YWbdbh1w1Eiw82Zr@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Originating-IP: [10.199.12.215]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-04.corp.yadro.com (172.17.100.104)
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

Hi,

I really need the collective wisdom.

Not long ago we've uncovered the problem with iSCSI and ABORT TASK
handling. Currently it's not possible to abort a WRITE_10 command in
TRANSPORT_WRITE_PENDING state, because ABORT TASK  will hang itself in
the process:

  # dmesg | tail -2
  [   83.563505] ABORT_TASK: Found referenced iSCSI task_tag: 3372979269
  [   84.593545] Unable to recover from DataOut timeout while in ERL=0, closing iSCSI connection for I_T Nexus <nexus>

  # ps aux | awk '$8 ~/D/'
  root        32  0.0  0.0      0     0 ?        D    15:19   0:00 [kworker/0:1+events]
  root      1187  0.0  0.0      0     0 ?        D    15:20   0:00 [iscsi_ttx]

  # cat /proc/32/stack
  [<0>] target_put_cmd_and_wait+0x68/0xa0
  [<0>] core_tmr_abort_task.cold+0x16b/0x192
  [<0>] target_tmr_work+0x9e/0xe0
  [<0>] process_one_work+0x1d4/0x370
  [<0>] worker_thread+0x48/0x3d0
  [<0>] kthread+0x122/0x140
  [<0>] ret_from_fork+0x22/0x30

  # cat /proc/1187/stack
  [<0>] __transport_wait_for_tasks+0xaf/0x100
  [<0>] transport_generic_free_cmd+0xe9/0x180
  [<0>] iscsit_free_cmd+0x50/0xb0
  [<0>] iscsit_close_connection+0x47d/0x8c0
  [<0>] iscsit_take_action_for_connection_exit+0x6f/0xf0
  [<0>] iscsi_target_tx_thread+0x184/0x200
  [<0>] kthread+0x122/0x140
  [<0>] ret_from_fork+0x22/0x30

What happens:

  1. Initiator sends WRITE_10 CDB
  2. Target parses the CDB and sends R2T
  3. Target starts the Data-Out timer
  4. Initiator sends ABORT TASK; no new data from Initiator after this
  5. Target starts aborting WRITE_10, gets into core_tmr_abort_task()
     and starts waiting for the request completion
  6. Nothing happens
  7. The Data-Out timers expires, connection teardown starts and gets
     stuck waiting for ABORT TASK that waits for WRITE_10

The ABORT TASK processing looks roughly like this:

  iscsi_rx_opcode
    iscsi_handle_task_mgt_cmd
      iscsi_tmr_abort_task
      transport_generic_handle_tmr
        if (tmr_cmd->transport_state & CMD_T_ABORTED)
          target_handle_abort
        else
          target_tmr_work
            if (tmr_cmd->transport_state & CMD_T_ABORTED)
              target_handle_abort
            else
              core_tmr_abort_task
                ret = __target_check_io_state
                  if (write_cmd->transport_state & CMD_T_STOP)
                    return -1
                  write_cmd->transport_state |= CMD_T_ABORTED
                  return 0
                if (!ret)
                  list_move_tail(&write_cmd->state_list, &aborted)
                  target_put_cmd_and_wait(&write_cmd)

As I see it, the main problem is that the abort path can't initiate the
command termination, it simply waits for the request to handle this on
the execution path like in target_execute_cmd():

  target_execute_cmd
    target_cmd_interrupted
      INIT_WORK(&cmd->work, target_abort_work)

However, in this case the request is not going to be executed because
Initiator will not send the Data-Out buffer.

I have a couple of ideas on how to fix this, but they all look kinda
ugly. The one that currently works around this for me:

  core_tmr_abort_task():

    [...]

    spin_lock_irqsave(&se_cmd->t_state_lock, flags);
    write_pending = se_cmd->t_state == TRANSPORT_WRITE_PENDING;
    spin_unlock_irqrestore(&se_cmd->t_state_lock, flags);
    
    if (write_pending && se_cmd->se_tfo->abort_write_pending)
            se_cmd->se_tfo->abort_write_pending(se_cmd);
    
    target_put_cmd_and_wait(se_cmd);

    [...]

The new method abort_write_pending() is defined only for iSCSI and calls
target_handle_abort(). However, this opens up another can of worms
because this code heavily races with R2T sending and requires a couple
of checks to "work most of the time". Not ideal, by far.

I can make this one better by introducing R2T list draining that ensures
the proper order during cleanup, but maybe there is a much easier way
that I'm not seeing here.

The tempting idea to wait for the Data-Out timer to time out and then
abort the request is not going to work either, because if the WRITE_10
processing lags and WRITE_10 is marked as aborted before R2Ts are sent,
ABORT TASK will still be stuck, but the Data-Out timer won't even be
started. Also the timeout upper limit is 60 seconds, so...

I really need some advice on how to deal with this properly.

P.S. This case is easily reproduced by libiscsi with some minor
modifications:

  $ git clone https://github.com/sahlberg/libiscsi.git
  $ cd libiscsi
  $ cat <<-EOF | patch -p 1
	diff --git a/test-tool/test_async_abort_simple.c b/test-tool/test_async_abort_simple.c
	index 82abb9f..70fd5ea 100644
	--- a/test-tool/test_async_abort_simple.c
	+++ b/test-tool/test_async_abort_simple.c
	@@ -92,7 +92,7 @@ test_async_abort_simple(void)
	 {
	 	int ret;
	 	struct tests_async_abort_state state = { NULL, 0, 0, 0, 0 };
	-	int blocks_per_io = 8;
	+	int blocks_per_io = 32678;
	 	unsigned char *buf;
	 	uint64_t timeout_sec;
	 
	@@ -146,6 +146,8 @@ test_async_abort_simple(void)
	 	}
	 	logging(LOG_VERBOSE, "dispatched");
	 
	+	sleep(2);
	+
	 	/*
	 	 * queue abort - shouldn't cancel the dispatched task. TMF req should
	 	 * be sent to the target.
  EOF
  $ ./autogen.sh
  $ ./configure --enable-test-tool
  $ ./test-tool/iscsi-test-cu -V --dataloss --test iSCSI.iSCSITMF.AbortTaskSimpleAsync \
  	-i <initiator-iqn> iscsi://<portal>/<target-iqn>/<lun>
