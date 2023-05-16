Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A47CAC77B75
	for <target-devel@archiver.kernel.org>; Tue, 16 May 2023 18:16:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbjEPSQI (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Tue, 16 May 2023 14:16:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjEPSQI (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Tue, 16 May 2023 14:16:08 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3095B59FB
        for <target-devel@vger.kernel.org>; Tue, 16 May 2023 11:16:07 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1ab01bf474aso110180325ad.1
        for <target-devel@vger.kernel.org>; Tue, 16 May 2023 11:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1684260966; x=1686852966;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=84nwJfF5J6T8UXJDjJIGknoJcQZGQDLwemF5IvWH188=;
        b=TOrDyWMhovHSWLdMZZLFO2aQDFuuPNmAgwXZUpHizvYaoVMl7PKB6QMwFyb9um/nkC
         8WEuQxQQIBhwg3UanQgfr1RUfmUTSlY8K8RtXTlYfolVprSZ2iAxuH+SUp5S6H/VAAUu
         pHqB2gS9CapmpKklaBvwnaZ3IUIt5AYhBE8vs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684260966; x=1686852966;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=84nwJfF5J6T8UXJDjJIGknoJcQZGQDLwemF5IvWH188=;
        b=XQPgr3LE4fxobEgnERLsQAg44/cGeJKUkqFBWZzi7hVGtcJKk75WgkOZrDCSA7UAOi
         XmEnbADCiRvmiTf5kI57jrMqO0yBlYuJbX5O5ADg9mzr6yDuk688CcZnV+JcXEaz2vve
         o8aWTvV5p7Tda1dcKSzOyqDlCLMWRuOpZXG1NvphxEd2WQctqVCGyyuPJNcF1KmSG2PP
         NFrDpGcYbX3uD+5LksREhFgfnpz/MJAR22X8j2tTN919IR5kAglJTHtwEHhRU6F7rV2n
         PWNCe80Nr64+6WG82ZrkaNBr4kwdxXx4YgHFVBWu3fTnWjwHT9re6nIseNa1foRhGQ20
         fH0w==
X-Gm-Message-State: AC+VfDzn2DcDxBWUXQT1t3IVxdDRKq+gQDa9ncT4C2XU/CbXBykPV1k3
        DZaCEqF8UdUTB275Gg1WQuU7Wg==
X-Google-Smtp-Source: ACHHUZ7bezD1AfXTru0fjrFVtWJPfsMcjudLSkYIWaDbfyoRl8Xk0oroge6WdmZaIIIqqJqKWTfMVg==
X-Received: by 2002:a17:902:9049:b0:1ab:19db:f2b with SMTP id w9-20020a170902904900b001ab19db0f2bmr40306193plz.36.1684260966700;
        Tue, 16 May 2023 11:16:06 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id a14-20020a170902ecce00b001ab016e7916sm6473789plh.234.2023.05.16.11.16.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 11:16:06 -0700 (PDT)
Date:   Tue, 16 May 2023 11:16:05 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Azeem Shaikh <azeemshaikh38@gmail.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-hardening@vger.kernel.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        Maurizio Lombardi <mlombard@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] scsi: target: Replace all non-returning strlcpy with
 strscpy
Message-ID: <202305161115.8FACC7D1@keescook>
References: <20230516025322.2804923-1-azeemshaikh38@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230516025322.2804923-1-azeemshaikh38@gmail.com>
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Tue, May 16, 2023 at 02:53:22AM +0000, Azeem Shaikh wrote:
> strlcpy() reads the entire source buffer first.
> This read may exceed the destination size limit.
> This is both inefficient and can lead to linear read
> overflows if a source string is not NUL-terminated [1].
> In an effort to remove strlcpy() completely [2], replace
> strlcpy() here with strscpy().
> No return values were used, so direct replacement is safe.
> 
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
> [2] https://github.com/KSPP/linux/issues/89
> 
> Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
