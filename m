Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86962EB64DD
	for <target-devel@archiver.kernel.org>; Mon,  7 Aug 2023 10:11:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbjHGKLf (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 7 Aug 2023 06:11:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjHGKLf (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 7 Aug 2023 06:11:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5738110F1
        for <target-devel@vger.kernel.org>; Mon,  7 Aug 2023 03:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691403047;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=2yG5uCh9/4E1VtSr3okWqDhu/dCuzXZKqsQA8TJO8TA=;
        b=eUE2iljmQuqit95AmgE4HK4bMtOzjiyFm4y/VTDd2UQlX2xtUsATgQHGCMT8GFR/YwUQLZ
        rHKOvLi+d0LHS9vQgFDWRKIb2JpE4P3vDfs2esKP49HAL61dBJ/IqnAPtVduIiUuVUCgUY
        HfSBsvWUdtP2bYq3JEa4buQLF3mkTUQ=
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com
 [209.85.222.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-102-_DJI2ENLN-yQSrfqpfZ6WQ-1; Mon, 07 Aug 2023 06:10:46 -0400
X-MC-Unique: _DJI2ENLN-yQSrfqpfZ6WQ-1
Received: by mail-ua1-f69.google.com with SMTP id a1e0cc1a2514c-79b02ab5194so311746241.1
        for <target-devel@vger.kernel.org>; Mon, 07 Aug 2023 03:10:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691403045; x=1692007845;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2yG5uCh9/4E1VtSr3okWqDhu/dCuzXZKqsQA8TJO8TA=;
        b=VwmkjGAvkX8c8don8E9H2KQGnT5MYazwnnxkwUF+y+isQzcGt+zLSb6MI/ush3+i95
         H7ip0Sh0vVms4sKgeJVKv5S4Gv6J/JrbdNBTxmqP1B4+IBIaJB/FaQ81STib1pngyQHY
         ahSPhyu9D3mV1xTWZzamxyLCPbNwu6yeDQuiE+aIgJaCMDetcaljcVTa4g8m6u5YKpNh
         2nwLHR68ngcm2D2hkLtZfxFfYkCm3PSa5OzgJx4tb7NAZUCWtb53l3DYCdWZOCgbHgxZ
         ICNsWfxIComDPq07DFZubt8EBnicNjg0lCCFoKOb8mvyOhZmZVtOJUeK2U/OUygULOYk
         4BuA==
X-Gm-Message-State: AOJu0YyiBGF6naclLUcj2i4B3FR3uHkgXEZ0v1Rr8hZPGrqCj8BtMBzZ
        PGFdmgIFehGsRwsCC/Ntt08kNtms6LgGM029nG24CYpJCwtEMkhzFmjHOuBh1D9NK+yXVvKn2cr
        S5AD9hRlC2CfA+kPKLDUu10sAB8DXDjCL8aYBqMOglaN/JDWXt9U=
X-Received: by 2002:a67:fe10:0:b0:443:6397:250f with SMTP id l16-20020a67fe10000000b004436397250fmr2907083vsr.27.1691403045248;
        Mon, 07 Aug 2023 03:10:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE0I3T5LBB3bruAyZb8u4XCvH9IhBxW7kCe3mD2SSnIv8MYwph1GHUKguNLAcV5qV89o061g9wJ5Mhe9QAbLk4=
X-Received: by 2002:a67:fe10:0:b0:443:6397:250f with SMTP id
 l16-20020a67fe10000000b004436397250fmr2907080vsr.27.1691403045006; Mon, 07
 Aug 2023 03:10:45 -0700 (PDT)
MIME-Version: 1.0
From:   Maurizio Lombardi <mlombard@redhat.com>
Date:   Mon, 7 Aug 2023 12:10:33 +0200
Message-ID: <CAFL455=r4SuND7vL1Sr2vKzLTsgg-KL7GNzzJZPe2wDDH-NQyg@mail.gmail.com>
Subject: For targetcli/rtslib/configshell distro package maintainers.
To:     target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

Hello,

If your distro has switched to Cython 3, you have probably noticed
that the python-kmod package doesn't compile anymore.

Since agrover's python-kmod repository on github is marked as
archived, I found myself forced to fork it and modify it to make it
compatible with Cython 3.0.

Here is my repository
https://github.com/maurizio-lombardi/python-kmod
I released version 0.9.2 a week ago and merged it in Fedora rawhide.

You may have to backport this rtslib patch to make targetcli work with
this new version of kmod
https://github.com/open-iscsi/rtslib-fb/commit/c1378f28f7abce6f8993a43c34d5e287b092bb1e

nvmetcli seems to work without problems.

Please don't hesitate to submit MRs to improve it because I am more
experienced in C than in Python and I will appreciate any help.

Thanks,
Maurizio

