Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DBA5C433EF
	for <target-devel@archiver.kernel.org>; Fri,  8 Jul 2022 22:14:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240014AbiGHWOH (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Fri, 8 Jul 2022 18:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239536AbiGHWOG (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Fri, 8 Jul 2022 18:14:06 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B92462A707
        for <target-devel@vger.kernel.org>; Fri,  8 Jul 2022 15:14:05 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id l6-20020a25bf86000000b00668c915a3f2so16891767ybk.4
        for <target-devel@vger.kernel.org>; Fri, 08 Jul 2022 15:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=E20Nt12LsnkGtFpMkOvIRDlb9+mX9JX506hrC6n8tfI=;
        b=A6x6i+4QMeCkiuZ9qANdK/2cQfpMAeCB6bDJk4ZsZGw910nDKgog3Ylz7k8Xpd4oQK
         j4i4VYbhIT0VHMsfdeYlUsvrrJCWvZvSQK7Pmfieuk++8yDviKUuV2bA2gRRaCDej0MW
         rRbDC88IdQowNGoAIV1VTpNAUV49zsNJDOC7dj4QEYmHR4qLgkzMenAfXzJ0uT7MdA3z
         HKVxx3XKkzSeNdTLINSHA9nUoLG14ewxtkSaKQyYspvYbOrwZ3+9js1xfLjavk2xa2kl
         f/8CsqtyN7Cd1EhwJ60iNLBruJ1UHpRY4EbjzvF0eHk3frIGZanylB3kP5OO8o9C8DcQ
         7Kzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=E20Nt12LsnkGtFpMkOvIRDlb9+mX9JX506hrC6n8tfI=;
        b=tM1ubTHQy7dztD7rSlfw+p06yXgCkkiFRJftuL23hda4/+2K2r0f++FlvFslFg96jk
         szHFIXIRdK+cV6iRBIgFevVLLT5383u7RTdtSUAO+PUxNiDdibnwzD0f4NN86RfNpPmM
         avz/XhlK2r2YCeJ9osUMo5JzyH37+tWno7iJiyl23t2xKXSs4RezxqfU7CmrVPFBuJFh
         Jgp5xWX4iFwVv0lcfwo0OoAYMdfG5IBd1YEyxWuPCinyvsx2CIzjx04O3QWkNimT22Oy
         vPDyUGk54+w+lw9VVOruKbfkNK57TCAFO3887ZeRr1d+DK5V69IWJbEGGzELMUgFl0/P
         tdYg==
X-Gm-Message-State: AJIora/J586UN67eyqpYWPbEEKUnhRCDKMQUoAtF6VuJIOIPoTQTgJsg
        h9LBGv0JDd5Hx4PPQ/E9qPmjQs9EYZl2+FVOXQ==
X-Google-Smtp-Source: AGRyM1tbai2dfceIBCyizcjYkUf1XddOKPCwzP+Gz2PbecpsC1ry4B6MzxMbOc8QJ3HDBdHRwREkLhtVHneAH17JEA==
X-Received: from justinstitt.mtv.corp.google.com ([2620:15c:211:202:f21c:9185:9405:36f])
 (user=justinstitt job=sendgmr) by 2002:a81:a24b:0:b0:31c:95d5:1725 with SMTP
 id z11-20020a81a24b000000b0031c95d51725mr6572075ywg.403.1657318445014; Fri,
 08 Jul 2022 15:14:05 -0700 (PDT)
Date:   Fri,  8 Jul 2022 15:13:14 -0700
Message-Id: <20220708221314.466294-1-justinstitt@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH] iscsi: iscsi_target: fix clang -Wformat warning
From:   Justin Stitt <justinstitt@google.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Mingzhe Zou <mingzhe.zou@easystack.cn>,
        Justin Stitt <justinstitt@google.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

When building with Clang we encounter this warning:
| drivers/target/iscsi/iscsi_target.c:4365:12: error: format specifies
| type 'unsigned short' but the argument has type 'int' [-Werror,-Wformat]
| " %s\n", atomic_read(&sess->nconn)

The format specifier used is `%hu` which describes an unsigned short.
However, atomic_read returns an int which means the format specifier
should be `%d`.

Link: https://github.com/ClangBuiltLinux/linux/issues/378
Signed-off-by: Justin Stitt <justinstitt@google.com>
---
 drivers/target/iscsi/iscsi_target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index e368f038ff5c..bfb717065344 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4361,7 +4361,7 @@ int iscsit_close_connection(
 
 	spin_lock_bh(&sess->conn_lock);
 	atomic_dec(&sess->nconn);
-	pr_debug("Decremented iSCSI connection count to %hu from node:"
+	pr_debug("Decremented iSCSI connection count to %d from node:"
 		" %s\n", atomic_read(&sess->nconn),
 		sess->sess_ops->InitiatorName);
 	/*
-- 
2.37.0.rc0.161.g10f37bed90-goog

