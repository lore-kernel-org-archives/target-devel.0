Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 927BCC83F01
	for <target-devel@archiver.kernel.org>; Wed, 30 Aug 2023 22:12:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245350AbjH3WMk (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 30 Aug 2023 18:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244192AbjH3WMj (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 30 Aug 2023 18:12:39 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3637612C
        for <target-devel@vger.kernel.org>; Wed, 30 Aug 2023 15:12:15 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id d75a77b69052e-4108a8f0de7so1073431cf.0
        for <target-devel@vger.kernel.org>; Wed, 30 Aug 2023 15:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693433467; x=1694038267; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fT/dG8PH+5kjdfp0lNfGSE00HAneCDlI+gc0vyBZvf4=;
        b=ahYEcXgnFtgzHjj1NoZ3/eQjc06kUbA31Xfhs3+8LXb7grNVg1nQjtmSRPvH4455n2
         eteOd19XPk8w+DAlzJ+w3/j737t5t+BbZzmty//HygL8VcOE3ncufDJXqSkWRj41upEs
         aNVJQyTVjV29ikPzSN49+9lGMM9+XLMX8YP16ZaX0jnSeU/kS/StsJ9SbZIDQxImW43j
         5Hc3hZQcThQ1EDQbxBHLd522vJeAe38v0JzN0Y8GR9kx2PGiPsDgaHp4yRJTppV2Nj3H
         QMLxtgwDVT1AyXn7/44nkFRmV00uMY2lMW3UAE83ud+CpRzS3HDxU/TZNEeIMzof1zwx
         nA3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693433467; x=1694038267;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fT/dG8PH+5kjdfp0lNfGSE00HAneCDlI+gc0vyBZvf4=;
        b=Dh8LIjAroTLblMDuFQFTpNP+owoLyHdxhVKbP/iuUu6MGMZQHvyHDlajDMHqaIcmG8
         wrwooHmDkiuLtpqc5Qu7M7A+qaUaXbulnhl9PybeOoLgbf/4PRmMc0J/ZlVYOkgRNFhd
         nnwsLg9h6LlZ+HlTkUcEXG6qEtO9rdaNQlO7Zy9oRLjiGbYoFvoC4sdfWQiBN3u5tmd+
         1wLI91hN7SspeVMNiVrcbjj6hwWMp+ZdAvh4NC36eLqgdVRnF9tcjZ1kJ6hAh+eRftXl
         rSF6VVVMH/3N8AQWfuog/sMzbm5+S4iwCv60dztGwWDLR0PL/JTSq/CqE7j6lXyeDlg6
         O0GQ==
X-Gm-Message-State: AOJu0Yy2uKOXZhji8NxSTTVjrG/dfCdMduY54hCD+Vdcp2K8Dgu4I7T3
        5gENJciImo4nrVzjMDiq/4qr+JZZSqSowO+up1U6SQ==
X-Google-Smtp-Source: AGHT+IGqxsyB9NGlYxwJsRZgtFvY5zsY1NppQgidovpARDU2fWnZUcd25uoPUkOvkwUfGey/nbMgqg==
X-Received: by 2002:a05:6e02:1b84:b0:34a:a306:ae7c with SMTP id h4-20020a056e021b8400b0034aa306ae7cmr4567188ili.28.1693432413967;
        Wed, 30 Aug 2023 14:53:33 -0700 (PDT)
Received: from google.com (161.74.123.34.bc.googleusercontent.com. [34.123.74.161])
        by smtp.gmail.com with ESMTPSA id v9-20020a92c809000000b0034ce78e2450sm45948iln.39.2023.08.30.14.53.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Aug 2023 14:53:33 -0700 (PDT)
Date:   Wed, 30 Aug 2023 21:53:30 +0000
From:   Justin Stitt <justinstitt@google.com>
To:     Azeem Shaikh <azeemshaikh38@gmail.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-hardening@vger.kernel.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: target: Replace strlcpy with strscpy
Message-ID: <20230830215330.6gyhpq3ohkbbtsam@google.com>
References: <20230830210724.4156575-1-azeemshaikh38@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230830210724.4156575-1-azeemshaikh38@gmail.com>
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Wed, Aug 30, 2023 at 09:07:24PM +0000, Azeem Shaikh wrote:
> strlcpy() reads the entire source buffer first.
> This read may exceed the destination size limit.
> This is both inefficient and can lead to linear read
> overflows if a source string is not NUL-terminated [1].
> In an effort to remove strlcpy() completely [2], replace
> strlcpy() here with strscpy().
>
> Direct replacement is safe here since return value of -errno
> is used to check for truncation instead of sizeof(dest).
>
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
> [2] https://github.com/KSPP/linux/issues/89
>
> Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>
> ---
> v2:
>  * Replace all instances of strlcpy in this file instead of just 1.
>
> v1:
>  * https://lore.kernel.org/all/20230830200717.4129442-1-azeemshaikh38@gmail.com/
>
>  drivers/target/target_core_configfs.c |   27 ++++++++++++---------------
>  1 file changed, 12 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> index 936e5ff1b209..10a22a428267 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -1392,16 +1392,15 @@ static ssize_t target_wwn_vendor_id_store(struct config_item *item,
>  	/* +2 to allow for a trailing (stripped) '\n' and null-terminator */
>  	unsigned char buf[INQUIRY_VENDOR_LEN + 2];
>  	char *stripped = NULL;
> -	size_t len;
> +	ssize_t len;
>  	ssize_t ret;
>
> -	len = strlcpy(buf, page, sizeof(buf));
> -	if (len < sizeof(buf)) {
> +	len = strscpy(buf, page, sizeof(buf));
> +	if (len > 0) {
>  		/* Strip any newline added from userspace. */
>  		stripped = strstrip(buf);
> -		len = strlen(stripped);
>  	}
> -	if (len > INQUIRY_VENDOR_LEN) {
> +	if (len < 0 || strlen(stripped) > INQUIRY_VENDOR_LEN) {
>  		pr_err("Emulated T10 Vendor Identification exceeds"
>  			" INQUIRY_VENDOR_LEN: " __stringify(INQUIRY_VENDOR_LEN)
>  			"\n");

Should we be explicitly checking for `len == -E2BIG` instead of the more
generic `len < 0`? Perhaps this is a nitpick but I prefer the former.

...

> @@ -1448,16 +1447,15 @@ static ssize_t target_wwn_product_id_store(struct config_item *item,
>  	/* +2 to allow for a trailing (stripped) '\n' and null-terminator */
>  	unsigned char buf[INQUIRY_MODEL_LEN + 2];
>  	char *stripped = NULL;
> -	size_t len;
> +	ssize_t len;
>  	ssize_t ret;
>
> -	len = strlcpy(buf, page, sizeof(buf));
> -	if (len < sizeof(buf)) {
> +	len = strscpy(buf, page, sizeof(buf));
> +	if (len > 0) {
>  		/* Strip any newline added from userspace. */
>  		stripped = strstrip(buf);
> -		len = strlen(stripped);
>  	}
> -	if (len > INQUIRY_MODEL_LEN) {
> +	if (len < 0 || strlen(stripped) > INQUIRY_MODEL_LEN) {
>  		pr_err("Emulated T10 Vendor exceeds INQUIRY_MODEL_LEN: "
>  			 __stringify(INQUIRY_MODEL_LEN)
>  			"\n");

... and here


> @@ -1504,16 +1502,15 @@ static ssize_t target_wwn_revision_store(struct config_item *item,
>  	/* +2 to allow for a trailing (stripped) '\n' and null-terminator */
>  	unsigned char buf[INQUIRY_REVISION_LEN + 2];
>  	char *stripped = NULL;
> -	size_t len;
> +	ssize_t len;
>  	ssize_t ret;
>
> -	len = strlcpy(buf, page, sizeof(buf));
> -	if (len < sizeof(buf)) {
> +	len = strscpy(buf, page, sizeof(buf));
> +	if (len > 0) {
>  		/* Strip any newline added from userspace. */
>  		stripped = strstrip(buf);
> -		len = strlen(stripped);
>  	}
> -	if (len > INQUIRY_REVISION_LEN) {
> +	if (len < 0 || strlen(stripped) > INQUIRY_REVISION_LEN) {
>  		pr_err("Emulated T10 Revision exceeds INQUIRY_REVISION_LEN: "
>  			 __stringify(INQUIRY_REVISION_LEN)
>  			"\n");

... and here

> --
> 2.42.0.283.g2d96d420d3-goog
>
>

At any rate, this is a worthwhile change for the reasons you mentioned.

Reviewed-by: Justin Stitt <justinstitt@google.com>
