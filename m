Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE2ADC433EF
	for <target-devel@archiver.kernel.org>; Thu, 14 Oct 2021 23:12:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFFF460EBB
	for <target-devel@archiver.kernel.org>; Thu, 14 Oct 2021 23:12:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbhJNXOo (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Thu, 14 Oct 2021 19:14:44 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:38286 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230032AbhJNXOo (ORCPT <rfc822;target-devel@vger.kernel.org>);
        Thu, 14 Oct 2021 19:14:44 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 6FB7243F61;
        Thu, 14 Oct 2021 23:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1634253156;
         x=1636067557; bh=jljv/D5W9V0XVMap7vlWvGh5bmQXzhEKtSVlQqk1rME=; b=
        tzM569WfL1z7APBBMZr0a5ihF4edC/qc6VJbi6UVK5ISoDixXnr47B3f76WLaEkr
        SeQU2zxLz5oGbj1e/viUv/VVAfKwlzSb/LtuYJHj9Td4QIzPaiOdAbnsVQK7M0LX
        TW10dzf9whLSPU6IM6GmgMGVYhLYp/GfqFwuLQJevuA=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id xjnLgH3oUPYk; Fri, 15 Oct 2021 02:12:36 +0300 (MSK)
Received: from T-EXCH-04.corp.yadro.com (t-exch-04.corp.yadro.com [172.17.100.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 0AA4F43F3D;
        Fri, 15 Oct 2021 02:12:35 +0300 (MSK)
Received: from yadro.com (10.199.9.171) by T-EXCH-04.corp.yadro.com
 (172.17.100.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Fri, 15
 Oct 2021 02:12:34 +0300
Date:   Fri, 15 Oct 2021 02:12:34 +0300
From:   Konstantin Shelekhin <k.shelekhin@yadro.com>
To:     Mike Christie <michael.christie@oracle.com>
CC:     <target-devel@vger.kernel.org>, <linux@yadro.com>,
        Maurizio Lombardi <mlombard@redhat.com>
Subject: Re: iSCSI Abort Task and WRITE PENDING
Message-ID: <YWi5YumbN/Zzze5h@yadro.com>
References: <YWbdbh1w1Eiw82Zr@yadro.com>
 <17647b68-f039-3fc3-808e-0feb652ddf8c@oracle.com>
 <YWcggfDyrHU1VhKN@yadro.com>
 <2e83aa6a-2746-8914-f295-30eea8954814@oracle.com>
 <6059cfab-5cbb-984b-7efc-eb193bddea7a@oracle.com>
 <YWcsWKIn5RyN+UbD@yadro.com>
 <YWcs/8CQYn7C7G9T@yadro.com>
 <e76e1a95-dc88-ac9a-62b0-89533182aafd@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e76e1a95-dc88-ac9a-62b0-89533182aafd@oracle.com>
X-Originating-IP: [10.199.9.171]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-04.corp.yadro.com (172.17.100.104)
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Wed, Oct 13, 2021 at 03:21:19PM -0500, Mike Christie wrote:
> For lun resets, let's take the abort case.
> 
> 1. core_tmr_abort_task is waiting in target_put_cmd_and_wait for the WRITE.
> 2. For the normal case where a cmd has been passed to LIO core then eventually
> the cmd completes and we do:
> 
> target_complete_cmd -> target_complete_cmd_with_sense -> target_cmd_interrupted
> -> target_handle_abort. Ignoring TAS, that function then does the last puts on the
> cmd which wakes up the TMR code in #1.
> 
> For the case where we never submit the cmd to LIO core, then the puts will never
> be done by that target_complete_cmd path. And, in this case where the iscsi connection
> is closed we know the cmd will never be submitted to LIO core because the iscsi
> threads have been killed. iscsi needs to do the last puts on the cmd so #1 wakes up
> on that WRITE.
> 
> So we need a cmd bit to set to indicate iscsi has called one of the submission
> /execution functions in LIO. If it's not set then iscsit_release_commands_from_conn/
> iscsit_free_cmd needs to do those last puts.
> 
> Here in this example to better show what I mean, we detect if an abort has been sent
> to LIO core for a cmd that has not been sent to LIO core. If that happens then
> iscsit_free_cmd gets force_cleanup=true so transport_generic_free_cmd will do a put
> and not wait, and then iscsit_free_cmd does the last target_put_sess_cmd which
> will wake #1 above. The abort will then complete too.
> 
> Note:
> I don't think we have to worry about TAS in this case, because we never got a complete
> SCSI command. The iscsi layer only got part of it and never submitted it to the SCSI
> layer. We then escalated to session level recovery so we are not sending any responses
> for any of the cmds or TMFs. The transport is killed at this point, so no responses
> can even be sent.
> 
> 
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index 2c54c5d8412d..d0e80a2b653b 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -4088,7 +4088,8 @@ static void iscsit_release_commands_from_conn(struct iscsi_conn *conn)
>  
>  		if (se_cmd->se_tfo != NULL) {
>  			spin_lock_irq(&se_cmd->t_state_lock);
> -			if (se_cmd->transport_state & CMD_T_ABORTED) {
> +			if (se_cmd->transport_state & CMD_T_ABORTED &&
> +			    se_cmd->transport_state & CMD_T_SUBMITTED) {
>  				/*
>  				 * LIO's abort path owns the cleanup for this,
>  				 * so put it back on the list and let
> @@ -4096,7 +4097,7 @@ static void iscsit_release_commands_from_conn(struct iscsi_conn *conn)
>  				 */
>  				list_move_tail(&cmd->i_conn_node,
>  					       &conn->conn_cmd_list);
> -			} else {
> +			} else if (!(se_cmd->transport_state & CMD_T_ABORTED)) {
>  				se_cmd->transport_state |= CMD_T_FABRIC_STOP;
>  			}
>  			spin_unlock_irq(&se_cmd->t_state_lock);
> @@ -4108,8 +4109,12 @@ static void iscsit_release_commands_from_conn(struct iscsi_conn *conn)
>  		list_del_init(&cmd->i_conn_node);
>  
>  		iscsit_increment_maxcmdsn(cmd, sess);
> -		iscsit_free_cmd(cmd, true);
>  
> +		if (se_cmd->transport_state & CMD_T_ABORTED &&
> +		    !(se_cmd->transport_state & CMD_T_SUBMITTED))
> +			iscsit_free_cmd(cmd, false, true);
> +		else
> +			iscsit_free_cmd(cmd, true, false);
>  	}
>  }
>  
> diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
> index 6dd5810e2af1..931586595044 100644
> --- a/drivers/target/iscsi/iscsi_target_util.c
> +++ b/drivers/target/iscsi/iscsi_target_util.c
> @@ -742,7 +742,7 @@ void __iscsit_free_cmd(struct iscsi_cmd *cmd, bool check_queues)
>  		conn->conn_transport->iscsit_unmap_cmd(conn, cmd);
>  }
>  
> -void iscsit_free_cmd(struct iscsi_cmd *cmd, bool shutdown)
> +void iscsit_free_cmd(struct iscsi_cmd *cmd, bool shutdown, bool force_cleanup)
>  {
>  	struct se_cmd *se_cmd = cmd->se_cmd.se_tfo ? &cmd->se_cmd : NULL;
>  	int rc;
> @@ -751,10 +751,14 @@ void iscsit_free_cmd(struct iscsi_cmd *cmd, bool shutdown)
>  
>  	__iscsit_free_cmd(cmd, shutdown);
>  	if (se_cmd) {
> -		rc = transport_generic_free_cmd(se_cmd, shutdown);
> +		rc = transport_generic_free_cmd(se_cmd,
> +					force_cleanup ? false : shutdown);
>  		if (!rc && shutdown && se_cmd->se_sess) {
>  			__iscsit_free_cmd(cmd, shutdown);
>  			target_put_sess_cmd(se_cmd);
> +		} else if (se_cmd->sess && force_cleanup) {
> +			__iscsit_free_cmd(cmd, true);
> +			target_put_sess_cmd(se_cmd);
>  		}
>  	} else {
>  		iscsit_release_cmd(cmd);
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 14c6f2bb1b01..eb233ea8db65 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -1554,7 +1554,7 @@ int transport_handle_cdb_direct(
>  	 * this to be called for initial descriptor submission.
>  	 */
>  	cmd->t_state = TRANSPORT_NEW_CMD;
> -	cmd->transport_state |= CMD_T_ACTIVE;
> +	cmd->transport_state |= (CMD_T_ACTIVE | CMD_T_SUBMITTED);
>  
>  	/*
>  	 * transport_generic_new_cmd() is already handling QUEUE_FULL,
> @@ -2221,7 +2221,7 @@ void target_execute_cmd(struct se_cmd *cmd)
>  		return;
>  
>  	spin_lock_irq(&cmd->t_state_lock);
> -	cmd->t_state = TRANSPORT_PROCESSING;
> +	cmd->t_state = (TRANSPORT_PROCESSING | CMD_T_SUBMITTED);
>  	cmd->transport_state |= CMD_T_ACTIVE | CMD_T_SENT;
>  	spin_unlock_irq(&cmd->t_state_lock);
>  
> diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
> index fb11c7693b25..b759ec810fa9 100644
> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -511,6 +511,7 @@ struct se_cmd {
>  #define CMD_T_COMPLETE		(1 << 2)
>  #define CMD_T_SENT		(1 << 4)
>  #define CMD_T_STOP		(1 << 5)
> +#define CMD_T_SUBMITTED		(1 << 6)
>  #define CMD_T_TAS		(1 << 10)
>  #define CMD_T_FABRIC_STOP	(1 << 11)
>  	spinlock_t		t_state_lock;
> 
> 
> 
> 
> 

If I understand this aproach correctly, it fixes the deadlock, but the
connection reinstatement will still happen, because WRITE_10 won't be
aborted and the connection will go down after the timeout.

IMO it's not ideal either, since now iSCSI will have a 50% chance to
have the connection (meaning SCSI session) killed on arbitrary ABORT
TASK. While I'm sure most initiators will be able to recover from this
event, such drastic measures will certanly cause a lot of confusion for
people who are not familiar with TCM internals.
