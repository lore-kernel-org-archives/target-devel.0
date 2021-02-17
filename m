Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3D2BC433E6
	for <target-devel@archiver.kernel.org>; Wed, 17 Feb 2021 16:12:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FA9E64E33
	for <target-devel@archiver.kernel.org>; Wed, 17 Feb 2021 16:12:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234028AbhBQQL5 (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 17 Feb 2021 11:11:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27782 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234059AbhBQQLp (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 17 Feb 2021 11:11:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613578219;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=HegTmpKYNVimcYrJcW3wdvDOS7LV1YJeNnKzFbvVb9I=;
        b=QGWf4fpNHkRWB2q/i+aJ9qETX3KEdEAI87lsjqV8pI3CDqaF8M0SwqUdxqpAm/lTowRHix
        hk4xq+pdAD++pjAHk+M4rRbui846NUiuyEP9tf7jHxvHR2S7pyqkNjfIKluQ9ZgxpCja4a
        lGVkigbc5HrDRG5rJ9AUfQ2tq15WSlc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-60-meVQVvEsOOu0IKziT0j2og-1; Wed, 17 Feb 2021 11:10:17 -0500
X-MC-Unique: meVQVvEsOOu0IKziT0j2og-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 437D2107ACC7
        for <target-devel@vger.kernel.org>; Wed, 17 Feb 2021 16:10:16 +0000 (UTC)
Received: from [10.10.112.124] (ovpn-112-124.rdu2.redhat.com [10.10.112.124])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F1B896A03C
        for <target-devel@vger.kernel.org>; Wed, 17 Feb 2021 16:10:15 +0000 (UTC)
Reply-To: tasleson@redhat.com
To:     target-devel@vger.kernel.org
From:   Tony Asleson <tasleson@redhat.com>
Subject: Can LIO configfs handle concurrent changes independently
Organization: Red Hat
Message-ID: <94b1290f-4713-460a-43b8-ff00402c64dd@redhat.com>
Date:   Wed, 17 Feb 2021 10:10:15 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

Can configfs for lio can handle multiple containers making changes
concurrently and independently?

ref. https://github.com/open-iscsi/targetd/issues/77#issuecomment-757087879

Thanks!

