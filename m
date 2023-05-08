Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B25EDC7EE22
	for <target-devel@archiver.kernel.org>; Mon,  8 May 2023 16:23:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234030AbjEHQXQ (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 8 May 2023 12:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbjEHQXO (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 8 May 2023 12:23:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD4644AA
        for <target-devel@vger.kernel.org>; Mon,  8 May 2023 09:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683562945;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=af581cU8r556BDJW0GqMExg/6u9tCwnvIBUUMdTmMpU=;
        b=QINo2I6Kd7fR0lCUf83/yTPtahgZa0pTLEMX95+G14jwVG9j6Q+8lZPoPUWLeEJoF+qfco
        z7pPs1z5GXQ7df7ZEAxebf6qeHYfihAYj8NBruGuNnNsuWw1y/6KEkd1LA3SPXXdOv58Bs
        nEZdTbtst2z0OJGewnyaNjpdqDCYduA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-155-ywQV1413O-eWK5-6nDmSrw-1; Mon, 08 May 2023 12:22:22 -0400
X-MC-Unique: ywQV1413O-eWK5-6nDmSrw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4522A88B767;
        Mon,  8 May 2023 16:22:22 +0000 (UTC)
Received: from kalibr.redhat.com (unknown [10.35.206.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 129002026D16;
        Mon,  8 May 2023 16:22:20 +0000 (UTC)
From:   Maurizio Lombardi <mlombard@redhat.com>
To:     martin.petersen@oracle.com
Cc:     michael.christie@oracle.com, target-devel@vger.kernel.org
Subject: [PATCH V3 0/3] Fix possible hangs and race conditions during login
Date:   Mon,  8 May 2023 18:22:16 +0200
Message-Id: <20230508162219.1731964-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

PATCH 1 fixes a possible hang when during a login operation the initiator
stops sending data to the target and the login_work doesn't get scheduled.

PATCH 3 fixes a bug in iscsi_target_locate_portal(), in the error
code path the login semaphore may end up being released even if
no one called down() against it, this may allow
multiple threads to access the semaphore-protected code.

v3: fix the comments' format

v2: the login timeout of 15 seconds now is relative to the entire
    login operation and not per-PDU.


Maurizio Lombardi (3):
  target: iscsi: fix hang in the iSCSI login code
  target: iscsi: remove unused transport_timer
  target: iscsi: prevent login threads from racing between each other

 drivers/target/iscsi/iscsi_target.c       |  2 -
 drivers/target/iscsi/iscsi_target_login.c | 63 ++-----------------
 drivers/target/iscsi/iscsi_target_nego.c  | 74 +++++++++++++----------
 drivers/target/iscsi/iscsi_target_util.c  | 51 ++++++++++++++++
 drivers/target/iscsi/iscsi_target_util.h  |  4 ++
 include/target/iscsi/iscsi_target_core.h  |  7 ++-
 6 files changed, 106 insertions(+), 95 deletions(-)

-- 
2.31.1

