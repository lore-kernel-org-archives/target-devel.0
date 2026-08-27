Received: from mta-01.yadro.com (mta-01.yadro.com [195.3.219.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00F042E43F
	for <target-devel@vger.kernel.org>; Thu, 27 Aug 2026 09:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.3.219.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787823772; cv=none; b=ipuoIkLPumKSBSWOS1e8fRGdVKS+EN3sCWk+8jgwcXZgXI5szAGyrIE0uLV0pSb8itEg2vaJ9Yow+SMGK62gm+c+KUbaM6CDleqXKljnfFyPM2Njar3ft06QD1ff3ZxfFfVsDCBEL9uvFDpQpFan0U7w//UxEbh+iNqV0JcyK7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787823772; c=relaxed/simple;
	bh=nwrX3gH0mkDkzd81IytcyV2rrOErdF47tp5dip9Mx8c=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qEJFY3Sohz6KUvWtkZ5HauOOADajK7Xqtl5ydeJj9z5TCiHrcFkAbE3gu+7YhoNJTkmiwA2BgTFy+e+cPYdpV9wRnejYNaTRe+QPru317n7fA2ni+nqBQ58lbRkhGBByYP/9YYqW8OoBeVtrU4fi+qGqPkILj++Pzhid0vQp4Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yadro.com; spf=pass smtp.mailfrom=yadro.com; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=W/+pZ6AO; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=ZJXqNXlo; arc=none smtp.client-ip=195.3.219.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="W/+pZ6AO";
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="ZJXqNXlo"
Received: by mta-01.yadro.com (Postfix, from userid 992)
	id 574EF20003; Thu, 27 Aug 2026 12:33:06 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-01.yadro.com 574EF20003
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-02;
	t=1787823186; bh=1oszAJh7k2bqqCBt+Mgv7aOwdrmOcAzfEtWq2HXF7uY=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:From;
	b=W/+pZ6AOtnd2EuVt6LOEc2gtide49r5Sle1v7b5H95pja2J/R0mPqDKHcH2eJXBjO
	 HxSV2fj7zOd5/AsR2jKLdV5aEbz3mcHAtWVZpksfxx5jZR5wAlKTF5rCMaDydEa4rb
	 msYKki4xfLSqcJbtHOLjITpu5zjniLRb/w1eUHoxcbY0F7lo6IiD2AvkFoeCvqZkQB
	 tN+41Wf3elVn1/0rTfgjCHMX1X5jVWCvnXVhDYspElzh3KGFDxnRsIO8nF5tRpQFn+
	 yxmf+cZmG+4c73iQLJiTYkgaflZdeY5Bybalr/bEScuCzrDtBJMXO8+0UHWgLnsftL
	 3u+oLCt7ua5Jw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1787823186; bh=1oszAJh7k2bqqCBt+Mgv7aOwdrmOcAzfEtWq2HXF7uY=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:From;
	b=ZJXqNXloeSEe/cfOxNxy7uq5ZpFr3elRKx/A+tey8HuTEiw0De1hQU+/HvPFbs9Jv
	 hOj48cYybPeL0Y6xcxfSqJ5N5CGTo4Lzw8EzCsPiCyxWTsvWZuXPTGMTnSpQHE5Umj
	 Z8qBkJkszZlrpN0MwcD+vG+mj432VaAQhBXAoLi3rKXDG75lJVqWlq1u63arz9aOte
	 HInHFbcluUfwlSoz/K2Q19YJU+qFRNXa/P2zW2fu0/va3SNeCwSIlsULVFS21A3Jbh
	 nDVp93Wd36jRUadqDdUkxeLGQGhx6Gpi+l2zaGw4PhHU+KQs4RQJ2vNpzeax4WXtsN
	 dPqKGm9K0mZbw==
Received: from RTM-EXCH-06.corp.yadro.com (unknown [10.34.9.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mta-01.yadro.com (Postfix) with ESMTPS;
	Thu, 27 Aug 2026 12:33:01 +0300 (MSK)
Received: from yadro.com (10.34.9.247) by RTM-EXCH-06.corp.yadro.com
 (10.34.9.206) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 27 Aug
 2026 12:33:01 +0300
Date: Thu, 27 Aug 2026 12:33:01 +0300
From: Dmitry Bogdanov <d.bogdanov@yadro.com>
To: Maurizio Lombardi <mlombard@redhat.com>
CC: <martin.petersen@oracle.com>, <mlombard@arkamax.eu>,
	<michael.christie@oracle.com>, <target-devel@vger.kernel.org>,
	<loberman@redhat.com>
Subject: Re: [PATCH 1/1] target: iscsi: Fix hang for aborted WRITE_PENDING
 commands
Message-ID: <20260827093301.GA2638@yadro.com>
References: <20260717143828.76291-1-mlombard@redhat.com>
 <20260717143828.76291-2-mlombard@redhat.com>
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
In-Reply-To: <20260717143828.76291-2-mlombard@redhat.com>
X-ClientProxiedBy: RTM-EXCH-01.corp.yadro.com (10.34.9.201) To
 RTM-EXCH-06.corp.yadro.com (10.34.9.206)
X-KSMG-AntiPhishing: NotDetected
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.1.8310, bases: 2026/08/27 08:34:00 #28510719
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-KATA-Status: Not Detected
X-KSMG-LinksScanning: NotDetected
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 5

--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline


On Fri, Jul 17, 2026 at 04:38:28PM +0200, Maurizio Lombardi wrote:
> 
> When a LUN_RESET aborts a WRITE command that is in the
> TRANSPORT_WRITE_PENDING state, the target core sets CMD_T_ABORTED and waits
> for the frontend to finish processing.
> 
> If the initiator subsequently sends the remaining dataout PDUs,
> __iscsit_check_dataout_hdr() catches the payload, stops the dataout timer
> if the sequence is final and finally dumps the data.
> However, the iSCSI target doesn't trigger the completion process for these
> aborted commands. Because of this, the abort path hangs indefinitely in
> target_put_cmd_and_wait(), leading to a deadlocked target worker thread.
> 
> Fix this by explicitly calling target_complete_cmd() when the final dataout
> PDU is received for an aborted WRITE command. target_complete_cmd() detects
> the CMD_T_ABORTED flag and cleanly routes the command into target_abort_work,
> allowing the abort completion to successfully unblock.
> 
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> ---
>  drivers/target/iscsi/iscsi_target.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index 62ada3a52210..124ff269b8e7 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -1533,8 +1533,10 @@ __iscsit_check_dataout_hdr(struct iscsit_conn *conn, void *buf,
>                  */
>                 if (se_cmd->transport_state & CMD_T_ABORTED) {
>                         if (hdr->flags & ISCSI_FLAG_CMD_FINAL &&
> -                           --cmd->outstanding_r2ts < 1)
> +                           --cmd->outstanding_r2ts < 1) {
>                                 iscsit_stop_dataout_timer(cmd);
> +                               target_complete_cmd(se_cmd, SAM_STAT_TASK_ABORTED);
> +                       }
> 
>                         return iscsit_dump_data_payload(conn, payload_length, 1);
>                 }
> --
> 2.55.0
> 

Hi Maurizio,

We also faced that bug several years ago. We solved it by removing all
leftovers of hanling of aborted commands in iscsi, because the handling
of aborted commands moved to target core an age ago. iSCSI will collect
data as usual and pass the command to target core, it in its turns will
abort the command.


BR,
 Dmitry



--oyUTqETQ0mS9luUI
Content-Type: text/x-diff; charset="us-ascii"
Content-Disposition: attachment;
	filename="0001-scsi-target-iscsi-fix-hanging-WRITE_PENDING-commands.patch"

From d46bae4973c3467a999818b7a7154109de8facc1 Mon Sep 17 00:00:00 2001
From: Dmitry Bogdanov <d.bogdanov@yadro.com>
Date: Wed, 26 Jun 2024 14:30:34 +0300
Subject: [PATCH] scsi: target: iscsi: fix hanging WRITE_PENDING commands

When Data comes for an aborted WRITE command in WRITE_PENDING state it
is silently received and the command does not pass to the target. That leads
to hanging of other session with LUN_RESET aborting that command.

Pass the aborted WRITE commands when all Data has been gathered.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
Signed-off-by: Sergey Samoylenko <s.samoylenko@yadro.com>
---
 drivers/target/iscsi/iscsi_target.c      | 17 -----------------
 drivers/target/iscsi/iscsi_target_erl1.c |  8 --------
 2 files changed, 25 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index d1887337e..a18fe1c74 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1536,23 +1536,6 @@ __iscsit_check_dataout_hdr(struct iscsit_conn *conn, void *buf,
 			if (hdr->flags & ISCSI_FLAG_CMD_FINAL)
 				iscsit_stop_dataout_timer(cmd);
 
-			return iscsit_dump_data_payload(conn, payload_length, 1);
-		}
-	} else {
-		/*
-		 * For the normal solicited data path:
-		 *
-		 * Check for a delayed TASK_ABORTED status and dump any
-		 * incoming data out payload if one exists.  Also, when the
-		 * ISCSI_FLAG_CMD_FINAL is set to denote the end of the current
-		 * data out sequence, we decrement outstanding_r2ts.  Once
-		 * outstanding_r2ts reaches zero, go ahead and send the delayed
-		 * TASK_ABORTED status.
-		 */
-		if (se_cmd->transport_state & CMD_T_ABORTED) {
-			if (hdr->flags & ISCSI_FLAG_CMD_FINAL &&
-			    --cmd->outstanding_r2ts < 1)
-				iscsit_stop_dataout_timer(cmd);
 
 			return iscsit_dump_data_payload(conn, payload_length, 1);
 		}
diff --git a/drivers/target/iscsi/iscsi_target_erl1.c b/drivers/target/iscsi/iscsi_target_erl1.c
index 2e69632b3..6e8a0b41f 100644
--- a/drivers/target/iscsi/iscsi_target_erl1.c
+++ b/drivers/target/iscsi/iscsi_target_erl1.c
@@ -892,8 +892,6 @@ int iscsit_execute_cmd(struct iscsit_cmd *cmd, int ooo)
 				return 0;
 			}
 			spin_unlock_bh(&cmd->istate_lock);
-			if (cmd->se_cmd.transport_state & CMD_T_ABORTED)
-				return 0;
 			return transport_send_check_condition_and_sense(se_cmd,
 					cmd->sense_reason, 0);
 		}
@@ -911,9 +909,6 @@ int iscsit_execute_cmd(struct iscsit_cmd *cmd, int ooo)
 
 			if (!(cmd->cmd_flags &
 					ICF_NON_IMMEDIATE_UNSOLICITED_DATA)) {
-				if (cmd->se_cmd.transport_state & CMD_T_ABORTED)
-					return 0;
-
 				iscsit_set_dataout_sequence_values(cmd);
 				conn->conn_transport->iscsit_get_dataout(conn, cmd, false);
 			}
@@ -926,9 +921,6 @@ int iscsit_execute_cmd(struct iscsit_cmd *cmd, int ooo)
 
 		if ((cmd->data_direction == DMA_TO_DEVICE) &&
 		    !(cmd->cmd_flags & ICF_NON_IMMEDIATE_UNSOLICITED_DATA)) {
-			if (cmd->se_cmd.transport_state & CMD_T_ABORTED)
-				return 0;
-
 			iscsit_set_unsolicited_dataout(cmd);
 		}
 		return target_submit(&cmd->se_cmd);
-- 
2.25.1


--oyUTqETQ0mS9luUI--
