Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A44BBC433DB
	for <target-devel@archiver.kernel.org>; Mon, 15 Mar 2021 21:17:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57A5C601FB
	for <target-devel@archiver.kernel.org>; Mon, 15 Mar 2021 21:17:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbhCOVRU (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 15 Mar 2021 17:17:20 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:53126 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229613AbhCOVQw (ORCPT <rfc822;target-devel@vger.kernel.org>);
        Mon, 15 Mar 2021 17:16:52 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 8517941277;
        Mon, 15 Mar 2021 21:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mta-01; t=1615843005; x=
        1617657406; bh=VP0pfSHJjElj1y2QtV2ldA5TnC9XH6gDI3ExP0SGqf0=; b=J
        vIeCzjBled3HlfZjPQ3nz8WFmZvFYul4/C1WzYO9zEzLyrix3S/nHQkC6ymqeHMr
        bhXr5tvCl3cNviHqtIzY8c9w9y5PnuyL7BKT9Jk0wPQVxa9K/JqZdo+qtE5Q7yH/
        XgxsxhW7A3hBYi8jiMB1rzxor4yFno/bx15F0Olh8w=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id rftK7Hj6QaeU; Tue, 16 Mar 2021 00:16:45 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 5D7BB4124F;
        Tue, 16 Mar 2021 00:16:44 +0300 (MSK)
Received: from yadro.com (10.199.0.49) by T-EXCH-03.corp.yadro.com
 (172.17.100.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Tue, 16
 Mar 2021 00:16:44 +0300
From:   Konstantin Shelekhin <k.shelekhin@yadro.com>
To:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux@yadro.com>, Konstantin Shelekhin <k.shelekhin@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [PATCH] target: Make logs less verbose
Date:   Tue, 16 Mar 2021 00:14:54 +0300
Message-ID: <20210315211453.5580-1-k.shelekhin@yadro.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.199.0.49]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-03.corp.yadro.com (172.17.100.103)
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

Change the log level of the following message to debug:

	Unsupported SCSI Opcode 0xXX, sending CHECK_CONDITION.

This message is mostly helpful during debugging sessions in order to
understand errors on the initiator side. But most of the time it's just
useless and makes reading logs much harder.

It gets particularly annoying if there are many initiators that come and
go or if an initiator runs a program that does not care whether the
command is supported and just keeps sending it.

Signed-off-by: Konstantin Shelekhin <k.shelekhin@yadro.com>
Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/target/target_core_transport.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 5ecb9f18a53d..5e1d2abf5efd 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1488,10 +1488,10 @@ target_cmd_parse_cdb(struct se_cmd *cmd)
 
 	ret = dev->transport->parse_cdb(cmd);
 	if (ret == TCM_UNSUPPORTED_SCSI_OPCODE)
-		pr_warn_ratelimited("%s/%s: Unsupported SCSI Opcode 0x%02x, sending CHECK_CONDITION.\n",
-				    cmd->se_tfo->fabric_name,
-				    cmd->se_sess->se_node_acl->initiatorname,
-				    cmd->t_task_cdb[0]);
+		pr_debug_ratelimited("%s/%s: Unsupported SCSI Opcode 0x%02x, sending CHECK_CONDITION.\n",
+				     cmd->se_tfo->fabric_name,
+				     cmd->se_sess->se_node_acl->initiatorname,
+				     cmd->t_task_cdb[0]);
 	if (ret)
 		return ret;
 
-- 
2.30.2

