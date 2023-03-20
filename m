Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 512D7C7618E
	for <target-devel@archiver.kernel.org>; Mon, 20 Mar 2023 18:41:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbjCTSll (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 20 Mar 2023 14:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbjCTSlT (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 20 Mar 2023 14:41:19 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE94A3C799
        for <target-devel@vger.kernel.org>; Mon, 20 Mar 2023 11:33:20 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id o2so6070461plg.4
        for <target-devel@vger.kernel.org>; Mon, 20 Mar 2023 11:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1679337196;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:subject:cc:to:from:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=K4mu+bNehauaTgSBwCnPiSfzrVvCzsepaH3d15QbbN4=;
        b=ClQrVslAhJvgqbe8M3xHOKxNgniQIh/uBsT0fWFpMbXdu6MFA1Jpv9xYHkM3UDdd9u
         Q1KcpFDNhByvRzXb6AIGsWNhSajaD0ZFJIvDdVjfFDmky2eS8jQfTixhQBQg+aZpR/E6
         veAKsW9HkLBeX9ZAaVtQ1F3vihHnlFAw3UXa4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679337196;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:subject:cc:to:from:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K4mu+bNehauaTgSBwCnPiSfzrVvCzsepaH3d15QbbN4=;
        b=BW5Ka+novHx2+WrhRvPPIiEozjYZgL5ctwQmgDdMzxTan2z9f0FjCdNuTn8nHrAW6U
         MEELrUmF05MlTE5D69N+g4x+bBePzioWgQRZ1WpSfmOP6aV49LmyJVHt6SJIUY0t4sgi
         A2ZgYZ7qnv9CQzRdtYR4Xfat9BfOcXOIYaLN3RFiKFpXs1OdWgtDHzS4zXhH6d+im3LI
         /b118WZsfQtw09nbujxVEy++HGm4T2Ais5XVEe5Sp0woCg8QY5yy7cv9gBLVQtFekMbo
         hdIlWU4nS2qCh9jbCMcjjx17ItMMtHWMigkvCB3VuEjJwk8OuRS0/H5W06j+Czn/OVN7
         8ZxQ==
X-Gm-Message-State: AO0yUKUo8H1CCcgdFIkG8kEZcYkzakHZW2AVd4ZSQcl4Po9m4yetX+1C
        sYo2vOZ3KR/toXrWKP3chO3ewYfJZ6JU3gGpUu8=
X-Google-Smtp-Source: AK7set/pnmLIeD8BRH/9kRDtin7NNNPBnPbucuL8sJUzMrogrV26aMT63BiNpaTx4nZIFu8i2QAeRw==
X-Received: by 2002:a05:6a20:4c84:b0:cd:ed5c:513 with SMTP id fq4-20020a056a204c8400b000cded5c0513mr303189pzb.31.1679337196653;
        Mon, 20 Mar 2023 11:33:16 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id k2-20020aa792c2000000b006089fb79f1asm6608990pfa.208.2023.03.20.11.33.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 11:33:16 -0700 (PDT)
Message-ID: <6418a6ec.a70a0220.1f3d7.afc4@mx.google.com>
X-Google-Original-Message-ID: <202303201133.@keescook>
Date:   Mon, 20 Mar 2023 11:33:15 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Bodo Stroesser <bostroesser@gmail.com>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] uapi: target: Replace fake flex-array with
 flexible-array member
References: <ZBSchMvTdl7VObKI@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZBSchMvTdl7VObKI@work>
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Fri, Mar 17, 2023 at 10:59:48AM -0600, Gustavo A. R. Silva wrote:
> Zero-length arrays as fake flexible arrays are deprecated and we are
> moving towards adopting C99 flexible-array members instead.
> 
> Address the following warning found with GCC-13 and
> -fstrict-flex-arrays=3 enabled:
>   CC      drivers/target/target_core_user.o
> drivers/target/target_core_user.c: In function ‘queue_cmd_ring’:
> drivers/target/target_core_user.c:1096:15: warning: array subscript 0 is outside array bounds of ‘struct iovec[0]’ [-Warray-bounds=]
>  1096 |         iov = &entry->req.iov[0];
>       |               ^~~~~~~~~~~~~~~~~~
> In file included from drivers/target/target_core_user.c:31:
> ./include/uapi/linux/target_core_user.h:122:38: note: while referencing ‘iov’
>   122 |                         struct iovec iov[0];
>       |                                      ^~~
> 
> This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
> routines on memcpy() and help us make progress towards globally
> enabling -fstrict-flex-arrays=3 [1].
> 
> Link: https://github.com/KSPP/linux/issues/21
> Link: https://github.com/KSPP/linux/issues/270
> Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [1]
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
