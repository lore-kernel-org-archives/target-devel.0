Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80733C433DB
	for <target-devel@archiver.kernel.org>; Wed, 10 Mar 2021 08:17:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52E5564FCE
	for <target-devel@archiver.kernel.org>; Wed, 10 Mar 2021 08:17:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231897AbhCJIRL (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 10 Mar 2021 03:17:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231880AbhCJIRI (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 10 Mar 2021 03:17:08 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9AE1C06174A
        for <target-devel@vger.kernel.org>; Wed, 10 Mar 2021 00:17:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=80CU/R9zHr1B9dRQIlFbuo/AV9g+xFeCslYCfR4Bzo4=; b=Db1AERPepfQtFw3dMfP71QbQf0
        gCN44OouAE4d5QCvKx6la+Cy/Bv1oE85eRemS/NaJDA3OZHNFdJ97gHiuzZICB5sNcwoi6IOesWLP
        f1BE6Slab4iFfefFq927W7ZPV85tP3wjQWM/ganfK8eFRphaABYMF1uGJ8P4M/1QbDMUPQqyVaVv2
        vvyKzAqhPQtNoj7msJT9xIiwAWOAFlBt6XsmYHAs04J0WQZnDVDgUQGgtxGCSRpjXmmnTYcBN4zuc
        YC5P2XJ1d3dMDb1dk0CQYFRiuWgdnW2tJzXYyLS7sfcDpEwf5ULwSvwOJmsJ8zgPijwYsS2OXF50B
        kvg7dzFg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lJu1g-002qii-BN; Wed, 10 Mar 2021 08:17:04 +0000
Date:   Wed, 10 Mar 2021 08:17:04 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Vincent Pelletier <vincent@nexedi.com>
Cc:     target-devel@vger.kernel.org
Subject: Re: Is vHost reversible ?
Message-ID: <20210310081704.GA678217@infradead.org>
References: <20210310155813.7bef9aca@vincent-tkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310155813.7bef9aca@vincent-tkpad>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Wed, Mar 10, 2021 at 06:58:22AM +0000, Vincent Pelletier wrote:
> Hello,
> 
> (please keep me CC'ed, I'm not subscribed)

Please stop wasting our time with your out of tree modules.  You use a
piece of crap like that you get the keep the pieces and deal with the
fallout.
