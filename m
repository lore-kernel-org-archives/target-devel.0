Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793018644;
	b=XJKKIUN5Asm6Ne528ATY5AMHqrdcmp57gJ2yzt7l9mgPo9ARTGDidb4dOYZ16rRflEVO
	 XIPgd7mKYhYqFvT02oLptHBg3oUkTuIpV4nztRejG+yvwmScw9MihOrwrnBqxC23oI4R3
	 es0JLPhSjuUXpwfeTk0H56J/96gFcHgTbSJUEyw7BEd7bVd3N1egSDYR40OaUJQ8RSr3o
	 m+PENO7Fi4/FKfjvXkaWnOuPrQDoBWzK61VXszK6IGyyPZtZJopF2CB30jp7g4RUE70rI
	 qANyHoVeVF6mq19OzI5dlB2TFwO6nVNYnAgUvVxYQJKCFSaOhKBVMeR0knZ2MJhp/mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793018644;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Scanned-By;
	bh=elI1N0EXlsXg/Z1aYrnpFW75kl66V6BwjpkweJofPjk=;
	b=5Mkl/j7WH2ecYsvQz72eFsq6sKCbwT+RKb36btAQt0IV5XbvpvTtaNT5KvVrWaK6uAip
	 5BuSc2Zn4LzWPhAW+zEhba6fyIoj2y15lBUgqtowDHpbW0JgXNtAepeEApg450UsNbHfp
	 QR60XyM1qxkFeu4kqmBLN5DgGvTYr6jj8d6MsZ5Fb70QhKC9u1U+J6jrLiwjoXjLa0rvl
	 XYDC/RhfibBwKiZrTalnEhe3bTeC60GmgUG23oPQYZx7wRdu/QjHJ8fBRouF04YWMowzM
	 DIyogkQBihUSuH+wf5NouNxAyIXjYOzMLT8phfCN9AAkv9je0tIuo2K5bXN/s76rnXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=NHHXU9P+;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD58606A31B
	for <target-devel@vger.kernel.org>; Mon, 26 Oct 2026 12:44:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BAD58606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=NHHXU9P+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793018642;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=elI1N0EXlsXg/Z1aYrnpFW75kl66V6BwjpkweJofPjk=;
	b=NHHXU9P+/8rYERcri0nItO4mZdgJW/6MbbVd2NRyv5lzzFo47jBNNAv7ULpaRIAv87fye2
	bVWwvdlTvJnJrmtuiRW/0p6yAqTzKGdNMYQ/xNlC8HnrwoXVNU3R+OtTphrC+4M9tPpupp
	QxvLO10YjrAoYDEuFINkN7m+M78scz8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-648-dWbtLQTSPoCJgaiveJKDmw-1; Mon,
 26 Oct 2026 08:43:58 -0400
X-MC-Unique: dWbtLQTSPoCJgaiveJKDmw-1
X-Mimecast-MFC-AGG-ID: dWbtLQTSPoCJgaiveJKDmw_1793018637
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 638B419560BE;
	Mon, 26 Oct 2026 12:43:57 +0000 (UTC)
Received: from loberman-thinkpadp16gen3.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4B0B41956088;
	Mon, 26 Oct 2026 12:43:56 +0000 (UTC)
From: Laurence Oberman <loberman@redhat.com>
To: mkp@kernel.org
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	mlombard@redhat.com,
	michael.christie@oracle.com,
	bvanassche@acm.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/4] scsi: target: iscsi: Complete an aborted WRITE when a new R2T would be sent
Date: Mon, 26 Oct 2026 08:43:42 -0400
Message-ID: <20261026124344.745124-3-loberman@redhat.com>
In-Reply-To: <20261026124344.745124-1-loberman@redhat.com>
References: <20261026124344.745124-1-loberman@redhat.com>
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Post: <mailto:target-devel@vger.kernel.org>
List-Help: <mailto:target-devel+help@vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:target-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

iscsit_check_dataout_payload() hands a command to iscsit_get_dataout() to
request the next burst whenever iscsit_check_post_dataout() returns
DATAOUT_SEND_R2T, without checking CMD_T_ABORTED first.

If a TMR aborted the command while the burst that just finished was in
flight, no further DataOut will arrive: the initiator is about to be told
the command was aborted. The CMD_T_ABORTED handling in
__iscsit_check_dataout_hdr() does not cover this, because it only runs
for DataOut PDUs belonging to R2Ts that were already issued, and
outstanding_r2ts has already been decremented to zero for the burst that
completed. The command is left in TRANSPORT_WRITE_PENDING with nothing to
complete it.

Complete it here instead, through iscsit_complete_aborted_cmd() so that
the completion is claimed. target_complete_cmd() on a command that
already has CMD_T_ABORTED set goes to target_cmd_interrupted(), which
queues target_abort_work and returns without setting CMD_T_COMPLETE or
changing t_state. The command therefore stays in TRANSPORT_WRITE_PENDING
and on conn_cmd_list until target_abort_work reaches
iscsit_aborted_task(), and a connection drop in that window would let
iscsit_release_commands_from_conn() complete it a second time. Guard on
outstanding_r2ts so that with MaxOutstandingR2T > 1 the completion is
still left to the last R2T to drain in __iscsit_check_dataout_hdr().

Signed-off-by: Laurence Oberman <loberman@redhat.com>
---

Notes:
    This window was never observed in the field: instrumented kernels on two
    hosts recorded no completions at this site across 300 reset cycles, and
    the reproducer that triggered patch 1 never reached it.  It is closed by
    code inspection, for symmetry with the other paths that can leave an
    aborted WRITE_PENDING command stranded.

 drivers/target/iscsi/iscsi_target.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index aab9237..3dad7f6 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1669,6 +1669,22 @@ iscsit_check_dataout_payload(struct iscsit_cmd *cmd, struct iscsi_data *hdr,
 	if ((rc == DATAOUT_NORMAL) || (rc == DATAOUT_WITHIN_COMMAND_RECOVERY))
 		return 0;
 	else if (rc == DATAOUT_SEND_R2T) {
+		/*
+		 * A new R2T would never be answered for an aborted command.
+		 * The CMD_T_ABORTED handling in __iscsit_check_dataout_hdr()
+		 * does not cover this: it only runs for DataOut PDUs
+		 * belonging to R2Ts that were already issued, and
+		 * iscsit_dataout_update_r2t() has already decremented
+		 * outstanding_r2ts for the burst that just finished.  Guard
+		 * on outstanding_r2ts so that with MaxOutstandingR2T > 1 the
+		 * completion is still left to the last R2T to drain.
+		 */
+		if (cmd->se_cmd.transport_state & CMD_T_ABORTED) {
+			if (cmd->outstanding_r2ts < 1)
+				iscsit_complete_aborted_cmd(cmd);
+			return 0;
+		}
+
 		iscsit_set_dataout_sequence_values(cmd);
 		conn->conn_transport->iscsit_get_dataout(conn, cmd, false);
 	} else if (rc == DATAOUT_SEND_TO_TRANSPORT) {
-- 
2.43.0

