Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1968AC433FE
	for <target-devel@archiver.kernel.org>; Mon, 21 Nov 2022 09:28:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbiKUJ2I (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 21 Nov 2022 04:28:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbiKUJ2H (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 21 Nov 2022 04:28:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9E858FFA8
        for <target-devel@vger.kernel.org>; Mon, 21 Nov 2022 01:27:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669022830;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=wNgZKsv6FuLzVF5ta6xNwIP4kWMSYZbaxeiJSBdGXNk=;
        b=THutelx4DL5LCKNg8SXsQsCIqSTANs1RAAK/63ZaAtT5jCQxOIfJ0xFS8fY4pmogduqHAi
        d83JxLqh0fhaI1NyZDI5DbohM1lzhQERgeU2UOdu3D4HTrN6EPuJ7x7xU1BASjaYu6E4SI
        KFXJ0mQAIhJUFuxRZN7qcAYCP8C7op8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-323-YTdN5O3zMt2MLW8dRlP7ug-1; Mon, 21 Nov 2022 04:27:06 -0500
X-MC-Unique: YTdN5O3zMt2MLW8dRlP7ug-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DDC80101A52A;
        Mon, 21 Nov 2022 09:27:05 +0000 (UTC)
Received: from raketa.redhat.com (ovpn-193-4.brq.redhat.com [10.40.193.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D106849BB60;
        Mon, 21 Nov 2022 09:27:04 +0000 (UTC)
From:   Maurizio Lombardi <mlombard@redhat.com>
To:     martin.petersen@oracle.com
Cc:     michael.christie@oracle.com, target-devel@vger.kernel.org,
        linux@yadro.com
Subject: [PATCH] target: iscsi: fix hard lockup when executing a compare-and-write command
Date:   Mon, 21 Nov 2022 10:27:03 +0100
Message-Id: <20221121092703.316489-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

While handling an I/O completion for the compare portion of a
COMPARE_AND_WRITE command, it may happen that the
compare_and_write_callback function submits new bio structs
while still in softirq context.

low level drivers like md raid5 do not expect their make_request
call to be used in softirq context, they call into schedule() and
create a deadlocked system.

 __schedule at ffffffff873a0807
 schedule at ffffffff873a0cc5
 raid5_get_active_stripe at ffffffffc0875744 [raid456]
 raid5_make_request at ffffffffc0875a50 [raid456]
 md_handle_request at ffffffff8713b9f9
 md_make_request at ffffffff8713bacb
 generic_make_request at ffffffff86e6f14b
 submit_bio at ffffffff86e6f27c
 iblock_submit_bios at ffffffffc0b4e4dc [target_core_iblock]
 iblock_execute_rw at ffffffffc0b4f3ce [target_core_iblock]
 __target_execute_cmd at ffffffffc1090079 [target_core_mod]
 compare_and_write_callback at ffffffffc1093602 [target_core_mod]
 target_cmd_interrupted at ffffffffc108d1ec [target_core_mod]
 target_complete_cmd_with_sense at ffffffffc108d27c [target_core_mod]
 iblock_complete_cmd at ffffffffc0b4e23a [target_core_iblock]
 dm_io_dec_pending at ffffffffc00db29e [dm_mod]
 clone_endio at ffffffffc00dbf07 [dm_mod]
 raid5_align_endio at ffffffffc086d6c2 [raid456]
 blk_update_request at ffffffff86e6d950
 scsi_end_request at ffffffff87063d48
 scsi_io_completion at ffffffff87063ee8
 blk_complete_reqs at ffffffff86e77b05
 __softirqentry_text_start at ffffffff876000d7

This problem appears to be an issue between target_cmd_interrupted()
and compare_and_write_callback(). target_cmd_interrupted() calls the
se_cmd's transport_complete_callback function pointer if the se_cmd
is being stopped or aborted, and CMD_T_ABORTED was set on the se_cmd.

When calling compare_and_write_callback(), the success parameter
was set to false. target_cmd_interrupted() seems to expect this
means the callback will do cleanup that does not require a process
context. But compare_and_write_callback() ignores the parameter if
there was I/O done for the compare part of COMPARE_AND_WRITE.

Since there was data, the function continued on, passed the compare,
and issued a write while ignoring the value of the success parameter.
The submit of a bio for the write portion of the COMPARE_AND_WRITE
then causes schedule to be unsafely called from the softirq context.

Fix the bug in compare_and_write_callback by jumping
to the out label if success == "false",  after checking if
we have been called by transport_generic_request_failure();
The command is being aborted or stopped so there is no
need to submit the write bio for the write part
of the COMPARE_AND_WRITE command.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/target/target_core_sbc.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 1e3216de1e04..80d7a4419c4c 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -454,12 +454,22 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
 	sense_reason_t ret = TCM_NO_SENSE;
 	int i;
 
-	/*
-	 * Handle early failure in transport_generic_request_failure(),
-	 * which will not have taken ->caw_sem yet..
-	 */
-	if (!success && (!cmd->t_data_sg || !cmd->t_bidi_data_sg))
-		return TCM_NO_SENSE;
+	if (!success) {
+		/*
+		 * Handle early failure in transport_generic_request_failure(),
+		 * which will not have taken ->caw_sem yet..
+		 */
+		if (!cmd->t_data_sg || !cmd->t_bidi_data_sg)
+			return TCM_NO_SENSE;
+
+		/*
+		 * The command has been stopped or aborted so
+		 * we don't have to perform the write operation.
+		 */
+		WARN_ON(!(cmd->transport_state &
+			(CMD_T_ABORTED | CMD_T_STOP)));
+		goto out;
+	}
 	/*
 	 * Handle special case for zero-length COMPARE_AND_WRITE
 	 */
-- 
2.31.1

