Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 042BAC433F5
	for <target-devel@archiver.kernel.org>; Wed, 13 Oct 2021 14:25:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E08C9610FB
	for <target-devel@archiver.kernel.org>; Wed, 13 Oct 2021 14:25:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237201AbhJMO1J (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 13 Oct 2021 10:27:09 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:45180 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbhJMOYp (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 13 Oct 2021 10:24:45 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 8CF5E21969;
        Wed, 13 Oct 2021 14:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1634134961; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BSTPhyZ5uxgxQyKgvPHS4/i5zCvnurKRcDP9GX3Vuf4=;
        b=Njw4Jf8nS4JksjXsZPqHdmQOxK2D5V+fOwwxveOAUvCk5DkVC+LFy+/wibfJ7gnRcDVi8Z
        jZhIxSQwObAAl7Q08nvC+KOEMge6wzs5RFetVj/zCd1W7v9eg4t82/sXm20bG5tHeNw9Yk
        0mDCo1VsDUR/2vEbUQdb4mrlE1rrh3U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1634134961;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BSTPhyZ5uxgxQyKgvPHS4/i5zCvnurKRcDP9GX3Vuf4=;
        b=lsrsVug50W+0Y46Ht+S2dbMo0PCFmQ5TLKXHk1uVkxGXprKCTnJjJRvGZzrni+ZcvBCw5q
        mkiNFEsVBIdV06BA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7F2A113CEC;
        Wed, 13 Oct 2021 14:22:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id uTTMHrHrZmGyTQAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 13 Oct 2021 14:22:41 +0000
Subject: Re: iSCSI Abort Task and WRITE PENDING
To:     Konstantin Shelekhin <k.shelekhin@yadro.com>,
        target-devel@vger.kernel.org
Cc:     linux@yadro.com
References: <YWbdbh1w1Eiw82Zr@yadro.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <2a819e5d-c77a-94e8-1fe2-0ba81e7c9fa3@suse.de>
Date:   Wed, 13 Oct 2021 16:22:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YWbdbh1w1Eiw82Zr@yadro.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On 10/13/21 3:21 PM, Konstantin Shelekhin wrote:
> Hi,
> 
> I really need the collective wisdom.
> 
> Not long ago we've uncovered the problem with iSCSI and ABORT TASK
> handling. Currently it's not possible to abort a WRITE_10 command in
> TRANSPORT_WRITE_PENDING state, because ABORT TASK  will hang itself in
> the process:
> 
>   # dmesg | tail -2
>   [   83.563505] ABORT_TASK: Found referenced iSCSI task_tag: 3372979269
>   [   84.593545] Unable to recover from DataOut timeout while in ERL=0, closing iSCSI connection for I_T Nexus <nexus>
> 
>   # ps aux | awk '$8 ~/D/'
>   root        32  0.0  0.0      0     0 ?        D    15:19   0:00 [kworker/0:1+events]
>   root      1187  0.0  0.0      0     0 ?        D    15:20   0:00 [iscsi_ttx]
> 
>   # cat /proc/32/stack
>   [<0>] target_put_cmd_and_wait+0x68/0xa0
>   [<0>] core_tmr_abort_task.cold+0x16b/0x192
>   [<0>] target_tmr_work+0x9e/0xe0
>   [<0>] process_one_work+0x1d4/0x370
>   [<0>] worker_thread+0x48/0x3d0
>   [<0>] kthread+0x122/0x140
>   [<0>] ret_from_fork+0x22/0x30
> 
>   # cat /proc/1187/stack
>   [<0>] __transport_wait_for_tasks+0xaf/0x100
>   [<0>] transport_generic_free_cmd+0xe9/0x180
>   [<0>] iscsit_free_cmd+0x50/0xb0
>   [<0>] iscsit_close_connection+0x47d/0x8c0
>   [<0>] iscsit_take_action_for_connection_exit+0x6f/0xf0
>   [<0>] iscsi_target_tx_thread+0x184/0x200
>   [<0>] kthread+0x122/0x140
>   [<0>] ret_from_fork+0x22/0x30
> 
> What happens:
> 
>   1. Initiator sends WRITE_10 CDB
>   2. Target parses the CDB and sends R2T
>   3. Target starts the Data-Out timer
>   4. Initiator sends ABORT TASK; no new data from Initiator after this
>   5. Target starts aborting WRITE_10, gets into core_tmr_abort_task()
>      and starts waiting for the request completion
>   6. Nothing happens
>   7. The Data-Out timers expires, connection teardown starts and gets
>      stuck waiting for ABORT TASK that waits for WRITE_10
> 
> The ABORT TASK processing looks roughly like this:
> 
>   iscsi_rx_opcode
>     iscsi_handle_task_mgt_cmd
>       iscsi_tmr_abort_task
>       transport_generic_handle_tmr
>         if (tmr_cmd->transport_state & CMD_T_ABORTED)
>           target_handle_abort
>         else
>           target_tmr_work
>             if (tmr_cmd->transport_state & CMD_T_ABORTED)
>               target_handle_abort
>             else
>               core_tmr_abort_task
>                 ret = __target_check_io_state
>                   if (write_cmd->transport_state & CMD_T_STOP)
>                     return -1
>                   write_cmd->transport_state |= CMD_T_ABORTED
>                   return 0
>                 if (!ret)
>                   list_move_tail(&write_cmd->state_list, &aborted)
>                   target_put_cmd_and_wait(&write_cmd)
> 
> As I see it, the main problem is that the abort path can't initiate the
> command termination, it simply waits for the request to handle this on
> the execution path like in target_execute_cmd():
> 
>   target_execute_cmd
>     target_cmd_interrupted
>       INIT_WORK(&cmd->work, target_abort_work)
> 
> However, in this case the request is not going to be executed because
> Initiator will not send the Data-Out buffer.
> 
> I have a couple of ideas on how to fix this, but they all look kinda
> ugly. The one that currently works around this for me:
> 
>   core_tmr_abort_task():
> 
>     [...]
> 
>     spin_lock_irqsave(&se_cmd->t_state_lock, flags);
>     write_pending = se_cmd->t_state == TRANSPORT_WRITE_PENDING;
>     spin_unlock_irqrestore(&se_cmd->t_state_lock, flags);
>     
>     if (write_pending && se_cmd->se_tfo->abort_write_pending)
>             se_cmd->se_tfo->abort_write_pending(se_cmd);
>     
>     target_put_cmd_and_wait(se_cmd);
> 
>     [...]
> 
> The new method abort_write_pending() is defined only for iSCSI and calls
> target_handle_abort(). However, this opens up another can of worms
> because this code heavily races with R2T sending and requires a couple
> of checks to "work most of the time". Not ideal, by far.
> 
> I can make this one better by introducing R2T list draining that ensures
> the proper order during cleanup, but maybe there is a much easier way
> that I'm not seeing here.
> 
> The tempting idea to wait for the Data-Out timer to time out and then
> abort the request is not going to work either, because if the WRITE_10
> processing lags and WRITE_10 is marked as aborted before R2Ts are sent,
> ABORT TASK will still be stuck, but the Data-Out timer won't even be
> started. Also the timeout upper limit is 60 seconds, so...
> 
> I really need some advice on how to deal with this properly.
> 
Short answer: you can't.

There is no feasible path in the I/O stack to abort running I/O; the
only chance you have here is to wait for it to time-out.

We have run into similar issues, and found that the only sane solution
was to wait for the I/O to come back and then retry.
As this would take some time (30 seconds if you are unlucky) most
initiators will get unhappy and try to reset.
Which won't work, either, as the I/O is still stuck.
So we finally delayed relogin until all I/O was cleared.

Not the best solution, but the only thing we can do in the absense of a
proper I/O abort mechanism.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
