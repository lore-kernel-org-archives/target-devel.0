Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E95EC05027
	for <target-devel@archiver.kernel.org>; Fri,  3 Feb 2023 17:16:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233519AbjBCRQ2 (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Fri, 3 Feb 2023 12:16:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbjBCRQ2 (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Fri, 3 Feb 2023 12:16:28 -0500
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32A028C439
        for <target-devel@vger.kernel.org>; Fri,  3 Feb 2023 09:16:27 -0800 (PST)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-169b190e1fdso7413289fac.4
        for <target-devel@vger.kernel.org>; Fri, 03 Feb 2023 09:16:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=delphix.com; s=google;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fkZDqZHqG9mxt+n7zRTPrbvm43sT9U0t9cZMa9wAMjM=;
        b=OGE1Jtx8PeJVkU+CaaVARx8P3Udw/ZLIPzzlknAgskHhJs/z47VZvfBdh5y5i5RNml
         V7/LN1qKI3t+9bqHJ2balRz1cyihrNrrKRaeFxA+COMAXlI/QsuxAXUJPrENIDWO0SV6
         kLPFq/hfbLxXAE+djzZMIb2nm7pvY+MhuRiu8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fkZDqZHqG9mxt+n7zRTPrbvm43sT9U0t9cZMa9wAMjM=;
        b=F79m5mhSURa2VJfd+2wAfBo2cftom3tKwq5EnbcPOBBOegxZHBkAz9j/FfeZTydns3
         oWHLIIIeGTVkNAp2Pc45wg0c4fdADWqgrKTDWnkJekAA6B4BGhaVnJ5blYX4iq2C0E+S
         rB4mABi4ox7Ml4qWZ9Ue1MNgS/FI1Zqyo/x1Eup/2aUf8RmSbxAtzQffI/RiXXumrzln
         JF+JyG/UHoF3kkCqXW6VozdvVkj5HEgiCAectv8VJgy4s3xYG9NdM6zmjwt+nfaOo65i
         93t7KBqpcAbmdpEDmgPP1gSGr8TVLhWzDzNs4uIcSxqUpdUFZPk3DkOMYcqV1w3YHbA4
         Eftw==
X-Gm-Message-State: AO0yUKWQF2N5YNbmRxARPqor2KyIUq2o/6WcOtxJfpt6VqWyYOrEMFFf
        9YqSPFtexUiFgnK5EsGi0mp6oEqiLI1It8sr4r1Co/8FN58GuJrlR98=
X-Google-Smtp-Source: AK7set+V8kMtdoQJTPqm/+gHAjE+jICTevYYERlk19Ch/kCkwcx1myoLih5xKZe4SYp0ITfOsLHST/qq1YMGOtewep4=
X-Received: by 2002:a05:6870:1219:b0:169:e281:7f82 with SMTP id
 25-20020a056870121900b00169e2817f82mr489846oan.198.1675444586354; Fri, 03 Feb
 2023 09:16:26 -0800 (PST)
MIME-Version: 1.0
From:   Serapheim Dimitropoulos <serapheim.dimitro@delphix.com>
Date:   Fri, 3 Feb 2023 09:16:15 -0800
Message-ID: <CAMbhmBwe7KU8sHPLRgjGOrKPt44HMytaTbavBeFk1+uVvGzVmQ@mail.gmail.com>
Subject: Hang in iscsit_access_np() related to tpg->np_login_sem
To:     martin.petersen@oracle.com, michael.christie@oracle.com,
        mlombard@redhat.com
Cc:     target-devel@vger.kernel.org, Paul Dagnelie <pcd@delphix.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

Hi folks,

I'd like to inquire some info related to the following patch:
https://www.spinics.net/lists/target-devel/msg18875.html

We've been hitting a similar issue in the production environments
of our customers leading to the same symptoms. We get constant
"iSCSI Login timeout on Network Portal 0.0.0.0:3260" messages
because the iSCSI Target login thread will wait on the np_login_sem
semaphore until it gets interrupted by the timer timeout. Here is our
stack trace of the thread waiting:

0xffff8bdf62f2ac80 INTERRUPTIBLE         1
                  __schedule+0x2c1
                  schedule+0x33
                  schedule_timeout+0x205
                  __down_interruptible+0xbb
                  down_interruptible+0x4b
                  iscsit_access_np+0x5a
                  iscsi_target_locate_portal+0x429
                  __iscsi_target_login_thread+0x332
                  iscsi_target_login_thread+0x6f3
                  kthread+0x120
                  ret_from_fork+0x1f

During that time there is no other login or login-related thread which
leads us to believe that another thread probably got the semaphore
but never actually released it.

Looking through the login code it seems like there are two functions that
are expected to call up() on that semaphore by calling iscsit_deaccess_np():

A] __iscsi_target_login_thread(): This is the same thread that acquired
    the semaphore (by calling iscsit_access_np()).
B] iscsi_target_do_login_rx(): This is a delayed worker thread spawned
    by the thread in [A]

Looking at both of those codepaths it seems like there is one case for each
path that we never call iscsit_deaccess_np() to release the semaphore.

For [A] that is if iscsi_target_start_negotiation() returns 0 towards the
end of that function.

For [B] that is if iscsi_target_do_login() returns 0 AND
iscsi_target_sk_check_and_clear(conn, LOGIN_FLAGS_WRITE_ACTIVE)
returns 0.

Since we have no expertise in this part of the kernel I wanted to ask you
all, are the two above scenarios expected to not release the semaphore
on purpose or is any of them a bug? If they are not bugs, where is the
semaphore expected to be released?

Any explanation or insight will be very appreciated.

Regards,
Serapheim
