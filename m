Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D09EC64EC4
	for <target-devel@archiver.kernel.org>; Fri, 10 Mar 2023 10:05:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbjCJKFQ (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Fri, 10 Mar 2023 05:05:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbjCJKFN (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Fri, 10 Mar 2023 05:05:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A6DD107D6F
        for <target-devel@vger.kernel.org>; Fri, 10 Mar 2023 02:04:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678442671;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Ey3h5wAuaiWMVLipOiOW05WYsGhbkUd8whSsuvZH79Y=;
        b=SCDlOz0rle8Tsoucu2VEAI/HbnXT5tV21aEO8hA68D0HckblPBCOtIWMPQLVGV1UqMIw+c
        ViS6BfNv8L8CYt45Yxm3j4gszs1MclenDa2RyaMwkSdbiaR0yb5oXM8uTMv+GKLoZKAhn7
        hQ6XQ0CaVr81br+xCrCAPvG1ojTbTxQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-454-VWNSKN6mML-2Drw7hbw-fA-1; Fri, 10 Mar 2023 05:04:26 -0500
X-MC-Unique: VWNSKN6mML-2Drw7hbw-fA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D25A4857AA1;
        Fri, 10 Mar 2023 10:04:25 +0000 (UTC)
Received: from kalibr.redhat.com (unknown [10.35.206.200])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 67281C15BAE;
        Fri, 10 Mar 2023 10:04:24 +0000 (UTC)
From:   Maurizio Lombardi <mlombard@redhat.com>
To:     martin.petersen@oracle.com
Cc:     michael.christie@oracle.com, serapheim.dimitro@delphix.com,
        target-devel@vger.kernel.org
Subject: [PATCH 0/3] Fix possible hangs and race conditions during login
Date:   Fri, 10 Mar 2023 11:04:20 +0100
Message-Id: <20230310100423.1258256-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

PATCH 1 fixes a possible hang when during a login operation the initiator
stops sending data to the target and the login_work doesn't get scheduled
by the sk_data_ready callback.

PATCH 3 fixes a bug in iscsi_target_locate_portal(), in the error
code path the login semaphore may end up being released even if
no one called down() against it, this may allow
multiple threads to access the semaphore-protected code.

Maurizio Lombardi (3):
  target: iscsi: fix hang in the iSCSI login code
  target: iscsi: remove unused transport_timer
  target: iscsi: prevent login threads from racing between each other

 drivers/target/iscsi/iscsi_target_login.c |  1 +
 drivers/target/iscsi/iscsi_target_nego.c  | 60 +++++++++++------------
 drivers/target/iscsi/iscsi_target_util.c  | 26 ++++++++++
 drivers/target/iscsi/iscsi_target_util.h  |  3 ++
 include/target/iscsi/iscsi_target_core.h  |  2 +-
 5 files changed, 59 insertions(+), 33 deletions(-)

-- 
2.31.1

