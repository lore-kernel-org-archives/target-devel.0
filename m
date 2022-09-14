Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8024FC6FA82
	for <target-devel@archiver.kernel.org>; Wed, 14 Sep 2022 18:00:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbiINSAq (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 14 Sep 2022 14:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbiINSAi (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 14 Sep 2022 14:00:38 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFFAE481C1
        for <target-devel@vger.kernel.org>; Wed, 14 Sep 2022 11:00:36 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id b23so12823546iof.2
        for <target-devel@vger.kernel.org>; Wed, 14 Sep 2022 11:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=delphix.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date;
        bh=VFUdzmJIixtci3FBm2HFEi2rzmbDhqDr3flHCiO2ODI=;
        b=Y7tZdSeImLIqYc9pcvqJoHx8ufLm1yqJP7AV3wa+o/MSGFmwr3axTFPhJk14SQoCdi
         hP7+08h/ORxUiYIDPUB88CzgYYZISPLUWu/sT1j9tbO7QZ+AQtR6EqzlvPwLCokyfQIy
         YFqb0D/HFfviqKAHFIQ2fGalixHEA8w7oKDmE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=VFUdzmJIixtci3FBm2HFEi2rzmbDhqDr3flHCiO2ODI=;
        b=OfGO1oezkOwacSJkQkkZfoaChrUnw80DmD0W1Qh32Dy18ZVQzbX8m5t3h6Z6aAypV3
         aMTwmQtIjRxAlx2XWs171minU/Rko6Pht+MO0bzTgduISNvkKJI3xP92+O21GcHtSgR2
         Fuc6NNa5S9DrGmHSDLdG8e4AkGGylNInsEjugH4XvNsridOWHVHTDsVQXsowFqaKZNUr
         BzV42Ev/5nUhrX1G63bnhBkEy4OeDHMKYl/Gx/F4p6fjRk2LznbZK5PwT7i3XeiTW88+
         rnoZ2B4pL+xWbp4SPvq3O8xXyvnLBFEmoo8bnb4jIZOE3D8FE4YWZm9chLp9hvLF0SdV
         eJoQ==
X-Gm-Message-State: ACgBeo3A+dWyjl9TbnMWpebbjL44Ju/SaSBjQHIxIqCljMqCSdnVETUu
        qz0krotjmdZMLv7ipqEWb962xo/ZfZ3kb+TIa00MswAwbcbcsg==
X-Google-Smtp-Source: AA6agR40Ni/cj1DUDI7MpY/DZyQ4E3ofwXYYno4L/dr1MpRMQcgvk8yWbR8hmWkwFwJv2/zuRasIW1SKJlIuT08yNus=
X-Received: by 2002:a5d:8a13:0:b0:69e:2133:4b38 with SMTP id
 w19-20020a5d8a13000000b0069e21334b38mr12937388iod.106.1663178435753; Wed, 14
 Sep 2022 11:00:35 -0700 (PDT)
MIME-Version: 1.0
From:   Paul Dagnelie <pcd@delphix.com>
Date:   Wed, 14 Sep 2022 11:00:10 -0700
Message-ID: <CAJ-UWOeis8L26X1rSa0t+h3rzmQCFLSxPKBS7YiP=hArgnjPSA@mail.gmail.com>
Subject: [BUG] iscsi hangs during login attempt
To:     target-devel@vger.kernel.org
Cc:     Sumedh Bala <sbala@delphix.com>,
        Sebastien Roy <sebastien.roy@delphix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

Hi all,

We've encountered an issue a few times now that results in a hung
iscsi session that cannot be recovered, and ultimately leads to the
system being wedged. I've done some initial analysis on what the issue
might be, but I would appreciate some more experienced eyes on it and
suggestions about the right course of action.

The machines in question are running Linux 5.4 (plus some other
changes; it's a custom kernel built on top of Ubuntu 20.04, but I
don't see any relevant patches anywhere in the stack, so I decided to
come straight here). The issue presents with iscsi login attempts
timing out repeatedly. We took a core dump of the machine, and
analysis of the stack traces showed that the iscsi_target_login_thread
is waiting for another thread to finish with the np_login_sem. That
semaphore is being held by a thread in iscsi_target_do_login_rx, which
is currently waiting for a session to be reinstated.
iscsit_cause_connection_reinstatement signals the rx and tx threads,
and then waits for the conn_wait_comp completion, which is signalled
in iscsit_close_connection. That appears to be called by the tx and rx
threads when they exit.  After puzzling through the core for a bit, I
found the kernel threads in question, and they appear to be calmly
waiting in the normal blocking path waiting for IOs to come in for
them to respond to. I would think that if they were in that state when
the SIGINT came in they would have exited properly.

My theory, after examining the code, is if two connection requests
were received from one initiator in rapid succession, it seems like
the second one would use the connection reinstatement logic. It may be
possible that if a reinstatement happens fast enough after the initial
login, the rx and tx threads would not yet have marked themselves as
able to receive the SIGINT that the connection reinstatement logic
uses to prompt them to close the connection so a new one can be
created. As I understand how signals are processed for kernel threads,
this would result in the signal being dropped. After that happens, the
kernel threads would never exit. If that is possible, then this could
explain the issue we=E2=80=99re seeing.

We've enabled some of the pr_debug statements on the systems in
question, but the issue hasn't recurred on any system yet. In
addition, it's worth noting that this issue did present itself shortly
after patching the initiating windows systems, which would presumably
result in one or more connection reinstatements. Does this theory seem
plausible? We haven't managed to reproduce it in-house or with
debugging statements enabled yet, but if it is the root cause it seems
to me the best fix would be to add or use an existing flag that is set
during reconnection (before the signal is sent), and have the rx and
tx threads check it after enabling signals to close the window for the
race.

--=20
Paul Dagnelie
