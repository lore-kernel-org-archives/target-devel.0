Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0D02EB64DC
	for <target-devel@archiver.kernel.org>; Fri, 30 Jun 2023 15:54:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbjF3PyN (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Fri, 30 Jun 2023 11:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232840AbjF3PyJ (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Fri, 30 Jun 2023 11:54:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3878C3ABE
        for <target-devel@vger.kernel.org>; Fri, 30 Jun 2023 08:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688140397;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=dt8/TNwwjEp7T+q1FJfhndbuDgfaevnHhS8riY/vCsU=;
        b=Qz8lUFe2H8dRVuXGUoshQJ86q814A0yazgJKcjF/Mg8cCt5MWGrNXk084j2Wy4Z+yCf4Mz
        9Hauad73jBJ2bopDr1PBJSH27ZJHSsWJ8majNVRNzRoOQKhwBb73AVV7koOYvIOhtbADUB
        lfWY3L0eEcUNcVELU5/6ouhcFdL5AM8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-228-aGSmEoumMvSZ_YWq-gsTLQ-1; Fri, 30 Jun 2023 11:53:13 -0400
X-MC-Unique: aGSmEoumMvSZ_YWq-gsTLQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1E7B08D138B;
        Fri, 30 Jun 2023 15:53:12 +0000 (UTC)
Received: from kalibr.redhat.com (unknown [10.35.206.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DEACFF5CEC;
        Fri, 30 Jun 2023 15:53:10 +0000 (UTC)
From:   Maurizio Lombardi <mlombard@redhat.com>
To:     martin.petersen@oracle.com
Cc:     target-devel@vger.kernel.org, michael.christie@oracle.com
Subject: [PATCH] target: iscsi: remove the unused netif_timeout attribute
Date:   Fri, 30 Jun 2023 17:53:09 +0200
Message-Id: <20230630155309.46061-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

This attribute has never been used, remove it.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/target/iscsi/iscsi_target_configfs.c |  2 --
 drivers/target/iscsi/iscsi_target_tpg.c      | 26 --------------------
 drivers/target/iscsi/iscsi_target_tpg.h      |  1 -
 include/target/iscsi/iscsi_target_core.h     |  4 ---
 4 files changed, 33 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 5d0f51822414..6ce967f5af14 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -783,7 +783,6 @@ CONFIGFS_ATTR(iscsi_tpg_attrib_, name)
 
 DEF_TPG_ATTRIB(authentication);
 DEF_TPG_ATTRIB(login_timeout);
-DEF_TPG_ATTRIB(netif_timeout);
 DEF_TPG_ATTRIB(generate_node_acls);
 DEF_TPG_ATTRIB(default_cmdsn_depth);
 DEF_TPG_ATTRIB(cache_dynamic_acls);
@@ -799,7 +798,6 @@ DEF_TPG_ATTRIB(login_keys_workaround);
 static struct configfs_attribute *lio_target_tpg_attrib_attrs[] = {
 	&iscsi_tpg_attrib_attr_authentication,
 	&iscsi_tpg_attrib_attr_login_timeout,
-	&iscsi_tpg_attrib_attr_netif_timeout,
 	&iscsi_tpg_attrib_attr_generate_node_acls,
 	&iscsi_tpg_attrib_attr_default_cmdsn_depth,
 	&iscsi_tpg_attrib_attr_cache_dynamic_acls,
diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
index 3cac1aafef68..f7bac98fd4fe 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -211,7 +211,6 @@ static void iscsit_set_default_tpg_attribs(struct iscsi_portal_group *tpg)
 
 	a->authentication = TA_AUTHENTICATION;
 	a->login_timeout = TA_LOGIN_TIMEOUT;
-	a->netif_timeout = TA_NETIF_TIMEOUT;
 	a->default_cmdsn_depth = TA_DEFAULT_CMDSN_DEPTH;
 	a->generate_node_acls = TA_GENERATE_NODE_ACLS;
 	a->cache_dynamic_acls = TA_CACHE_DYNAMIC_ACLS;
@@ -666,31 +665,6 @@ int iscsit_ta_login_timeout(
 	return 0;
 }
 
-int iscsit_ta_netif_timeout(
-	struct iscsi_portal_group *tpg,
-	u32 netif_timeout)
-{
-	struct iscsi_tpg_attrib *a = &tpg->tpg_attrib;
-
-	if (netif_timeout > TA_NETIF_TIMEOUT_MAX) {
-		pr_err("Requested Network Interface Timeout %u larger"
-			" than maximum %u\n", netif_timeout,
-				TA_NETIF_TIMEOUT_MAX);
-		return -EINVAL;
-	} else if (netif_timeout < TA_NETIF_TIMEOUT_MIN) {
-		pr_err("Requested Network Interface Timeout %u smaller"
-			" than minimum %u\n", netif_timeout,
-				TA_NETIF_TIMEOUT_MIN);
-		return -EINVAL;
-	}
-
-	a->netif_timeout = netif_timeout;
-	pr_debug("Set Network Interface Timeout to %u for"
-		" Target Portal Group %hu\n", a->netif_timeout, tpg->tpgt);
-
-	return 0;
-}
-
 int iscsit_ta_generate_node_acls(
 	struct iscsi_portal_group *tpg,
 	u32 flag)
diff --git a/drivers/target/iscsi/iscsi_target_tpg.h b/drivers/target/iscsi/iscsi_target_tpg.h
index 839e45362776..71d067f62177 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.h
+++ b/drivers/target/iscsi/iscsi_target_tpg.h
@@ -38,7 +38,6 @@ extern int iscsit_tpg_del_network_portal(struct iscsi_portal_group *,
 			struct iscsi_tpg_np *);
 extern int iscsit_ta_authentication(struct iscsi_portal_group *, u32);
 extern int iscsit_ta_login_timeout(struct iscsi_portal_group *, u32);
-extern int iscsit_ta_netif_timeout(struct iscsi_portal_group *, u32);
 extern int iscsit_ta_generate_node_acls(struct iscsi_portal_group *, u32);
 extern int iscsit_ta_default_cmdsn_depth(struct iscsi_portal_group *, u32);
 extern int iscsit_ta_cache_dynamic_acls(struct iscsi_portal_group *, u32);
diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
index 4c15420e8965..60af7c63b34e 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -50,9 +50,6 @@ struct sock;
 #define TA_LOGIN_TIMEOUT		15
 #define TA_LOGIN_TIMEOUT_MAX		30
 #define TA_LOGIN_TIMEOUT_MIN		5
-#define TA_NETIF_TIMEOUT		2
-#define TA_NETIF_TIMEOUT_MAX		15
-#define TA_NETIF_TIMEOUT_MIN		2
 #define TA_GENERATE_NODE_ACLS		0
 #define TA_DEFAULT_CMDSN_DEPTH		64
 #define TA_DEFAULT_CMDSN_DEPTH_MAX	512
@@ -773,7 +770,6 @@ to_iscsi_nacl(struct se_node_acl *se_nacl)
 struct iscsi_tpg_attrib {
 	u32			authentication;
 	u32			login_timeout;
-	u32			netif_timeout;
 	u32			generate_node_acls;
 	u32			cache_dynamic_acls;
 	u32			default_cmdsn_depth;
-- 
2.39.3

