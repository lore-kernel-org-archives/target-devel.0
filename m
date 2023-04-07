Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23BDEC6FD1D
	for <target-devel@archiver.kernel.org>; Fri,  7 Apr 2023 13:05:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232114AbjDGNFK (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Fri, 7 Apr 2023 09:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231757AbjDGNFJ (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Fri, 7 Apr 2023 09:05:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D7C72A2
        for <target-devel@vger.kernel.org>; Fri,  7 Apr 2023 06:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680872640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=pzm+HhBNvjqNQd1g08Bwrs/gMBshTuVB6TW9ThrPWTA=;
        b=ZJAHMVlKVPUGXdUvwYdPHxVXFB8go7swu/B50+1uK/OffyTZqtIt7jWeVWcwEvLJlOpfbY
        R0Wh/fnz7x4JJFcfb0khrPD/VpbGNnXc72YwX7+AmTVJeI4LVfJRtJE21Ltc3/SpbA2XdE
        8rNodAcJmo9kQGRl5n13R03N5sjrMG0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-217-AEZTQTcNMriHbcleTnOkBg-1; Fri, 07 Apr 2023 09:00:37 -0400
X-MC-Unique: AEZTQTcNMriHbcleTnOkBg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4449F8828E9;
        Fri,  7 Apr 2023 13:00:36 +0000 (UTC)
Received: from kalibr.redhat.com (unknown [10.35.206.108])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AF378492C18;
        Fri,  7 Apr 2023 13:00:34 +0000 (UTC)
From:   Maurizio Lombardi <mlombard@redhat.com>
To:     martin.petersen@oracle.com
Cc:     target-devel@vger.kernel.org, michael.christie@oracle.com,
        d.bogdanov@yadro.com
Subject: [PATCH] target: core: fix invalid memory access
Date:   Fri,  7 Apr 2023 15:00:33 +0200
Message-Id: <20230407130033.556644-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

nr_attrs should start counting from zero, otherwise we
will end up dereferencing an invalid memory address.

$ targetcli /loopback create

 general protection fault
 RIP: 0010:configfs_create_file+0x12/0x70
 Call Trace:
  <TASK>
  configfs_attach_item.part.0+0x5f/0x150
  configfs_attach_group.isra.0+0x49/0x120
  configfs_mkdir+0x24f/0x4d0
  vfs_mkdir+0x192/0x240
  do_mkdirat+0x131/0x160
  __x64_sys_mkdir+0x48/0x70
  do_syscall_64+0x5c/0x90

Fixes: 31177b74790c ("scsi: target: core: Add RTPI attribute for target port")

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/target/target_core_fabric_configfs.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 0ce47e21e0c8..b7c637644cd4 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -885,7 +885,7 @@ target_fabric_setup_tpg_base_cit(struct target_fabric_configfs *tf)
 {
 	struct config_item_type *cit = &tf->tf_tpg_base_cit;
 	struct configfs_attribute **attrs = NULL;
-	size_t nr_attrs = 1;
+	size_t nr_attrs = 0;
 	int i = 0;
 
 	if (tf->tf_ops->tfc_tpg_base_attrs)
@@ -895,8 +895,8 @@ target_fabric_setup_tpg_base_cit(struct target_fabric_configfs *tf)
 	if (tf->tf_ops->fabric_enable_tpg)
 		nr_attrs++;
 
-	if (nr_attrs == 0)
-		goto done;
+	/* + 1 for target_fabric_tpg_base_attr_rtpi */
+	nr_attrs++;
 
 	/* + 1 for final NULL in the array */
 	attrs = kcalloc(nr_attrs + 1, sizeof(*attrs), GFP_KERNEL);
@@ -912,7 +912,6 @@ target_fabric_setup_tpg_base_cit(struct target_fabric_configfs *tf)
 
 	attrs[i++] = &target_fabric_tpg_base_attr_rtpi;
 
-done:
 	cit->ct_item_ops = &target_fabric_tpg_base_item_ops;
 	cit->ct_attrs = attrs;
 	cit->ct_owner = tf->tf_ops->module;
-- 
2.31.1

