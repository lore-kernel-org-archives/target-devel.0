Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51C4CC5479D
	for <target-devel@archiver.kernel.org>; Wed, 11 Jan 2023 07:07:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbjAKHHy (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 11 Jan 2023 02:07:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235753AbjAKHHn (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 11 Jan 2023 02:07:43 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92164BCAF
        for <target-devel@vger.kernel.org>; Tue, 10 Jan 2023 23:07:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Uxn8RkvBTsv7m+Hcapsi4VPHpT
        +dsbz2vv3wnz5b0Fp7ZCH5ebKRQzpesehlVdWdYzfy2ET/91oxJuaDsCeM3gki+Z3Kmy7yv42xeJR
        XwIv6CE9JlVYmyLm8kSdJ+MaLIooF1sA5JmC/XuprPPoeOUJzqRVLh3St4xTYmnxgdXkGhPZxcYCz
        sTyNzuWDIvkzepOgi7/Y7ZnO1Jt9AbfMlS+G5OZpV1zM9lBKggqw1hJzIfr1NZ9I9S2qCutPc/rMS
        0Ojl6zsHUI76VWvoSc8xj+rzMvh2agzCginnjjYW9I2hihB/JnI+xGk/yvRNRcGZARnl3t95jEPAE
        teGOcz+g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pFVCo-009xbU-3A; Wed, 11 Jan 2023 07:07:26 +0000
Date:   Tue, 10 Jan 2023 23:07:26 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Maurizio Lombardi <mlombard@redhat.com>
Cc:     martin.petersen@oracle.com, target-devel@vger.kernel.org,
        michael.christie@oracle.com, d.bogdanov@yadro.com
Subject: Re: [PATCH] target: core: fix warning on RT kernels
Message-ID: <Y75gLs7FL5aV7W75@infradead.org>
References: <20230110125310.55884-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110125310.55884-1-mlombard@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
