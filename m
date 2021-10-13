Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 818C1C433EF
	for <target-devel@archiver.kernel.org>; Wed, 13 Oct 2021 18:59:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C35C610EA
	for <target-devel@archiver.kernel.org>; Wed, 13 Oct 2021 18:59:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239242AbhJMTBG (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 13 Oct 2021 15:01:06 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:47896 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239093AbhJMTAn (ORCPT <rfc822;target-devel@vger.kernel.org>);
        Wed, 13 Oct 2021 15:00:43 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 356AE43F5D;
        Wed, 13 Oct 2021 18:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1634151517;
         x=1635965918; bh=J8JNKfFPPT+/2uSZYEUpOok+YIN9Elk7QPpUgRdViMI=; b=
        DgIxHoiZWy60TQGrBdDlLqC5WI7wn/KYZCYeFOegA3pcyEyFugxP3ncQec64810I
        j+5u/oByKgY8E2iZW0TC45lod8YkFRywpTwKQDZxToiESxwdM1TE+lopkQ+lLii7
        yxLjt4Nqz6Zf/ptlRMijEvg5ZCPMKAOcR8Gr9tMdNjI=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id cW3f5gmqEkOk; Wed, 13 Oct 2021 21:58:37 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 26C4343F5E;
        Wed, 13 Oct 2021 21:58:33 +0300 (MSK)
Received: from yadro.com (10.178.21.26) by T-EXCH-04.corp.yadro.com
 (172.17.100.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Wed, 13
 Oct 2021 21:58:33 +0300
Date:   Wed, 13 Oct 2021 21:58:32 +0300
From:   Konstantin Shelekhin <k.shelekhin@yadro.com>
To:     Mike Christie <michael.christie@oracle.com>
CC:     <target-devel@vger.kernel.org>, <linux@yadro.com>,
        Maurizio Lombardi <mlombard@redhat.com>
Subject: Re: iSCSI Abort Task and WRITE PENDING
Message-ID: <YWcsWKIn5RyN+UbD@yadro.com>
References: <YWbdbh1w1Eiw82Zr@yadro.com>
 <17647b68-f039-3fc3-808e-0feb652ddf8c@oracle.com>
 <YWcggfDyrHU1VhKN@yadro.com>
 <2e83aa6a-2746-8914-f295-30eea8954814@oracle.com>
 <6059cfab-5cbb-984b-7efc-eb193bddea7a@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6059cfab-5cbb-984b-7efc-eb193bddea7a@oracle.com>
X-Originating-IP: [10.178.21.26]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-04.corp.yadro.com (172.17.100.104)
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Wed, Oct 13, 2021 at 01:30:32PM -0500, Mike Christie wrote:
> On 10/13/21 1:24 PM, Mike Christie wrote:
> > On 10/13/21 1:08 PM, Konstantin Shelekhin wrote:
> >> On Wed, Oct 13, 2021 at 12:51:32PM -0500, Mike Christie wrote:
> >>> On 10/13/21 8:21 AM, Konstantin Shelekhin wrote:
> >>>> Hi,
> >>>>
> >>>> I really need the collective wisdom.
> >>>>
> >>>> Not long ago we've uncovered the problem with iSCSI and ABORT TASK
> >>>> handling. Currently it's not possible to abort a WRITE_10 command in
> >>>> TRANSPORT_WRITE_PENDING state, because ABORT TASK  will hang itself in
> >>>> the process:
> >>>>
> >>>>   # dmesg | tail -2
> >>>>   [   83.563505] ABORT_TASK: Found referenced iSCSI task_tag: 3372979269
> >>>>   [   84.593545] Unable to recover from DataOut timeout while in ERL=0, closing iSCSI connection for I_T Nexus <nexus>
> >>>>
> >>>>   # ps aux | awk '$8 ~/D/'
> >>>>   root        32  0.0  0.0      0     0 ?        D    15:19   0:00 [kworker/0:1+events]
> >>>>   root      1187  0.0  0.0      0     0 ?        D    15:20   0:00 [iscsi_ttx]
> >>>>
> >>>>   # cat /proc/32/stack
> >>>>   [<0>] target_put_cmd_and_wait+0x68/0xa0
> >>>>   [<0>] core_tmr_abort_task.cold+0x16b/0x192
> >>>>   [<0>] target_tmr_work+0x9e/0xe0
> >>>>   [<0>] process_one_work+0x1d4/0x370
> >>>>   [<0>] worker_thread+0x48/0x3d0
> >>>>   [<0>] kthread+0x122/0x140
> >>>>   [<0>] ret_from_fork+0x22/0x30
> >>>>
> >>>>   # cat /proc/1187/stack
> >>>>   [<0>] __transport_wait_for_tasks+0xaf/0x100
> >>>>   [<0>] transport_generic_free_cmd+0xe9/0x180
> >>>>   [<0>] iscsit_free_cmd+0x50/0xb0
> >>>>   [<0>] iscsit_close_connection+0x47d/0x8c0
> >>>>   [<0>] iscsit_take_action_for_connection_exit+0x6f/0xf0
> >>>>   [<0>] iscsi_target_tx_thread+0x184/0x200
> >>>>   [<0>] kthread+0x122/0x140
> >>>>   [<0>] ret_from_fork+0x22/0x30
> >>>>
> >>>> What happens:
> >>>>
> >>>>   1. Initiator sends WRITE_10 CDB
> >>>>   2. Target parses the CDB and sends R2T
> >>>>   3. Target starts the Data-Out timer
> >>>>   4. Initiator sends ABORT TASK; no new data from Initiator after this
> >>>>   5. Target starts aborting WRITE_10, gets into core_tmr_abort_task()
> >>>>      and starts waiting for the request completion
> >>>>   6. Nothing happens
> >>>>   7. The Data-Out timers expires, connection teardown starts and gets
> >>>>      stuck waiting for ABORT TASK that waits for WRITE_10
> >>>>
> >>>> The ABORT TASK processing looks roughly like this:
> >>>>
> >>>>   iscsi_rx_opcode
> >>>>     iscsi_handle_task_mgt_cmd
> >>>>       iscsi_tmr_abort_task
> >>>>       transport_generic_handle_tmr
> >>>>         if (tmr_cmd->transport_state & CMD_T_ABORTED)
> >>>>           target_handle_abort
> >>>>         else
> >>>>           target_tmr_work
> >>>>             if (tmr_cmd->transport_state & CMD_T_ABORTED)
> >>>>               target_handle_abort
> >>>>             else
> >>>>               core_tmr_abort_task
> >>>>                 ret = __target_check_io_state
> >>>>                   if (write_cmd->transport_state & CMD_T_STOP)
> >>>>                     return -1
> >>>>                   write_cmd->transport_state |= CMD_T_ABORTED
> >>>>                   return 0
> >>>>                 if (!ret)
> >>>>                   list_move_tail(&write_cmd->state_list, &aborted)
> >>>>                   target_put_cmd_and_wait(&write_cmd)
> >>>>
> >>>> As I see it, the main problem is that the abort path can't initiate the
> >>>> command termination, it simply waits for the request to handle this on
> >>>> the execution path like in target_execute_cmd():
> >>>>
> >>>>   target_execute_cmd
> >>>>     target_cmd_interrupted
> >>>>       INIT_WORK(&cmd->work, target_abort_work)
> >>>>
> >>>> However, in this case the request is not going to be executed because
> >>>> Initiator will not send the Data-Out buffer.
> >>>>
> >>>> I have a couple of ideas on how to fix this, but they all look kinda
> >>>> ugly. The one that currently works around this for me:
> >>>>
> >>>>   core_tmr_abort_task():
> >>>>
> >>>>     [...]
> >>>>
> >>>>     spin_lock_irqsave(&se_cmd->t_state_lock, flags);
> >>>>     write_pending = se_cmd->t_state == TRANSPORT_WRITE_PENDING;
> >>>>     spin_unlock_irqrestore(&se_cmd->t_state_lock, flags);
> >>>>     
> >>>>     if (write_pending && se_cmd->se_tfo->abort_write_pending)
> >>>>             se_cmd->se_tfo->abort_write_pending(se_cmd);
> >>>>     
> >>>>     target_put_cmd_and_wait(se_cmd);
> >>>>
> >>>>     [...]
> >>>>
> >>>> The new method abort_write_pending() is defined only for iSCSI and calls
> >>>> target_handle_abort(). However, this opens up another can of worms
> >>>> because this code heavily races with R2T sending and requires a couple
> >>>> of checks to "work most of the time". Not ideal, by far.
> >>>>
> >>>> I can make this one better by introducing R2T list draining that ensures
> >>>> the proper order during cleanup, but maybe there is a much easier way
> >>>> that I'm not seeing here.
> >>>
> >>> Ccing Maurizio to make sure I don't add his original bug back.
> >>>
> >>> If I understand you, I think I added this bug in:
> >>>
> >>> commit f36199355c64a39fe82cfddc7623d827c7e050da
> >>> Author: Mike Christie <michael.christie@oracle.com>
> >>> Date:   Fri Nov 13 19:46:18 2020 -0600
> >>>
> >>>     scsi: target: iscsi: Fix cmd abort fabric stop race
> >>>
> >>> With that patch if the abort or a lun reset has got to lio core then we
> >>> are going to be stuck waiting for the data which won't come because we
> >>> killed the iscsi threads.
> >>>
> >>> Can go back to always having the iscsi target clean up the cmd, but if
> >>> LIO has started to abort the cmd we take an extra ref so we don't free
> >>> the cmd from under each other.
> >>>
> >>> This patch is completely untested:
> >>>
> >>>
> >>> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> >>> index 2c54c5d8412d..d221e9be7468 100644
> >>> --- a/drivers/target/iscsi/iscsi_target.c
> >>> +++ b/drivers/target/iscsi/iscsi_target.c
> >>> @@ -4090,12 +4090,13 @@ static void 	(struct iscsi_conn *conn)
> >>>  			spin_lock_irq(&se_cmd->t_state_lock);
> >>>  			if (se_cmd->transport_state & CMD_T_ABORTED) {
> >>>  				/*
> >>> -				 * LIO's abort path owns the cleanup for this,
> >>> -				 * so put it back on the list and let
> >>> -				 * aborted_task handle it.
> >>> +				 * The LIO TMR handler owns the cmd but if
> >>> +				 * we were waiting for data from the initiator
> >>> +				 * then we need to internally cleanup to be
> >>> +				 * able to complete it. Get an extra ref so
> >>> +				 * we don't free the cmd from under LIO core.
> >>>  				 */
> >>> -				list_move_tail(&cmd->i_conn_node,
> >>> -					       &conn->conn_cmd_list);
> >>> +				target_get_sess_cmd(se_cmd, false);
> >>>  			} else {
> >>>  				se_cmd->transport_state |= CMD_T_FABRIC_STOP;
> >>>  			}
> >>
> >> The bug was there before. I had to backport this patch in order to
> >> introduce my fix. I can revert it and check what is different, but it's
> >> there in some form.
> >>
> > 
> > Don't waste your time. It's because iscsit_free_cmd's call to
> > transport_generic_free_cmd has wait_for_tasks=true.
> > 
> > We then do transport_generic_free_cmd -> target_wait_free_cmd ->
> > __transport_wait_for_tasks like you posted above.
> 
> That's wrong, it's the transport_generic_free_cmd wait:
> 
>         if (aborted) {
>                 pr_debug("Detected CMD_T_ABORTED for ITT: %llu\n", cmd->tag);
>                 wait_for_completion(&compl);
>                 ret = 1;

I'm not sure I'm following you. The wait on master comes from this:

 core_tmr_abort_task():
  [...]
  target_put_cmd_and_wait(se_cmd);
  [...]

IMO it's kinda legit wait. And we can't just drop the references and
call it a day, because a request has to go through the
target_handle_abort() because it (at least) does some TAS magic. And
currently there is no code that calls target_handle_abort() for
WRITE_PENDING requests.
