Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F28DDC6379F
	for <target-devel@archiver.kernel.org>; Tue, 14 Feb 2023 14:17:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233414AbjBNORq (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Tue, 14 Feb 2023 09:17:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233298AbjBNORk (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Tue, 14 Feb 2023 09:17:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACB3E72A1
        for <target-devel@vger.kernel.org>; Tue, 14 Feb 2023 06:16:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676384163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=425M96tsfNpu7Ay9attAH4J+LckmKF2Nigrx2p3w6SA=;
        b=WtvZBlDfDGBrPjGUwXBQeSY3riA9K64eUwrIOZ6fVqs4h5/Ab/nYqFEthAQQiGsxM2Ew8P
        wccC8t4Ly9clWziNvgawrui/4AKtqYSxGH+eNw4aP5HhGPihyXcoH3usumjxIWRkHUQbh0
        dNyL8Cg2w2GklDyhKp6iIqEkINd7z/M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-53-ZXZJtvvGO5GkfgNN4s_B5g-1; Tue, 14 Feb 2023 09:15:59 -0500
X-MC-Unique: ZXZJtvvGO5GkfgNN4s_B5g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DA302100F907;
        Tue, 14 Feb 2023 14:15:58 +0000 (UTC)
Received: from raketa.redhat.com (unknown [10.35.206.98])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A61DD1121318;
        Tue, 14 Feb 2023 14:15:57 +0000 (UTC)
From:   Maurizio Lombardi <mlombard@redhat.com>
To:     martin.petersen@oracle.com
Cc:     target-devel@vger.kernel.org, michael.christie@oracle.com
Subject: [PATCH] target: iscsi: fix an error message in iscsi_check_key()
Date:   Tue, 14 Feb 2023 15:15:56 +0100
Message-Id: <20230214141556.762047-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

The first half of the error message is printed by pr_err(), the second
half is printed by pr_debug().
The user will therefore see only the first part of the message
and will miss some useful information.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/target/iscsi/iscsi_target_parameters.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
index 2317fb077db0..557516c642c3 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.c
+++ b/drivers/target/iscsi/iscsi_target_parameters.c
@@ -1262,18 +1262,20 @@ static struct iscsi_param *iscsi_check_key(
 		return param;
 
 	if (!(param->phase & phase)) {
-		pr_err("Key \"%s\" may not be negotiated during ",
-				param->name);
+		char *phase_name;
+
 		switch (phase) {
 		case PHASE_SECURITY:
-			pr_debug("Security phase.\n");
+			phase_name = "Security";
 			break;
 		case PHASE_OPERATIONAL:
-			pr_debug("Operational phase.\n");
+			phase_name = "Operational";
 			break;
 		default:
-			pr_debug("Unknown phase.\n");
+			phase_name = "Unknown";
 		}
+		pr_err("Key \"%s\" may not be negotiated during %s phase.\n",
+				param->name, phase_name);
 		return NULL;
 	}
 
-- 
2.31.1

