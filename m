Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D74CC47082
	for <target-devel@archiver.kernel.org>; Tue,  8 Jun 2021 23:14:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF20A61178
	for <target-devel@archiver.kernel.org>; Tue,  8 Jun 2021 23:14:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234389AbhFHXQZ (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Tue, 8 Jun 2021 19:16:25 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:40932 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235400AbhFHXQY (ORCPT <rfc822;target-devel@vger.kernel.org>);
        Tue, 8 Jun 2021 19:16:24 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id D9A6741360;
        Tue,  8 Jun 2021 23:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1623194068;
         x=1625008469; bh=n01q+mNrfDRJxkY1SJ5JEkJECX2vyEKsO8S4GXWxhxY=; b=
        nSjlk2jaZ4nYppc9oVfKBMD8s3TZ2RYPE7gFjwbfuU47ExhQxWJAjYawY1vSGd2s
        vdBG7232uT/3w9s7WJDNRzepuEnyrCpIZ7hWNwNzE46ZyMQOH9E1kGa8WIJglO9g
        sx/PwtoqhLOux8H+yR4zDXZNjW57ZxkYGwq1eoAKhXk=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id xp2A8ZqTn6qk; Wed,  9 Jun 2021 02:14:28 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 593F24135F;
        Wed,  9 Jun 2021 02:14:28 +0300 (MSK)
Received: from localhost (172.22.1.233) by T-EXCH-03.corp.yadro.com
 (172.17.100.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Wed, 9 Jun
 2021 02:14:28 +0300
Date:   Wed, 9 Jun 2021 02:14:27 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Maurizio Lombardi <mlombard@redhat.com>
CC:     <martin.petersen@oracle.com>, <target-devel@vger.kernel.org>
Subject: Re: [PATCH] target: remove the auth_type field from iscsi_session
Message-ID: <YL/5074knGDS2Ska@SPB-NB-133.local>
References: <20210608164047.128763-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210608164047.128763-1-mlombard@redhat.com>
X-Originating-IP: [172.22.1.233]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-03.corp.yadro.com (172.17.100.103)
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Tue, Jun 08, 2021 at 06:40:47PM +0200, Maurizio Lombardi wrote:
> This field is not used anymore so we can remove it.
> 
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> ---
>  drivers/target/iscsi/iscsi_target_nego.c | 5 -----
>  include/target/iscsi/iscsi_target_core.h | 1 -
>  2 files changed, 6 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
> index 151e2949bb75..36341ffaffbf 100644
> --- a/drivers/target/iscsi/iscsi_target_nego.c
> +++ b/drivers/target/iscsi/iscsi_target_nego.c
> @@ -144,11 +144,6 @@ static u32 iscsi_handle_authentication(
>  		auth = &iscsit_global->discovery_acl.node_auth;
>  	}
>  
> -	if (strstr("CHAP", authtype))
> -		strcpy(conn->sess->auth_type, "CHAP");
> -	else
> -		strcpy(conn->sess->auth_type, NONE);
> -

Hi Maurizio,

It might still be useful to carry the meaning of "effective auth_type"
in case of complex auth configuration. Otherwise there's no way to check
what auth settings took effect for a particular session/I_T nexus.

I think we should rather print auth_type value someplace in configfs
than delete the field altogether.

Regards,
Roman

>  	if (strstr("None", authtype))
>  		return 1;
>  	else if (strstr("CHAP", authtype))
> diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
> index 1eccb2ac7d02..f0495515ca6a 100644
> --- a/include/target/iscsi/iscsi_target_core.h
> +++ b/include/target/iscsi/iscsi_target_core.h
> @@ -647,7 +647,6 @@ struct iscsi_session {
>  
>  	/* LIO specific session ID */
>  	u32			sid;
> -	char			auth_type[8];
>  	/* unique within the target */
>  	int			session_index;
>  	/* Used for session reference counting */
> -- 
> Maurizio Lombardi
> 
