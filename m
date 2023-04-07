Return-Path: <target-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2CEBC77B61
	for <target-devel@archiver.kernel.org>; Fri,  7 Apr 2023 13:32:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbjDGNcx (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Fri, 7 Apr 2023 09:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbjDGNcx (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Fri, 7 Apr 2023 09:32:53 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B69446B7
        for <target-devel@vger.kernel.org>; Fri,  7 Apr 2023 06:32:49 -0700 (PDT)
Received: from mta-01.yadro.com (localhost.localdomain [127.0.0.1])
        by mta-01.yadro.com (Proxmox) with ESMTP id E37ED342081;
        Fri,  7 Apr 2023 16:32:46 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; h=cc
        :cc:content-type:content-type:date:from:from:in-reply-to
        :message-id:mime-version:references:reply-to:subject:subject:to
        :to; s=mta-01; bh=jhDglwtHZ1w70nHIGACT03ciiA/jdDtdnR1g3rACmVQ=; b=
        Rivqjt1BAa9o9M4yfzu/9lHxY12+VWhtdNexjN+EbMsA+YwRJ9PEdB9XZAhRlWjl
        ecGp4L+NU+UOE2hT42xsBBg/kH2/TUB2olekrCC6Wdr+dYyuBpSDQW7AjE9gLoP2
        kBgeXq9u/f9k6PHZQpp9KbquEUFrRie6ypUx40bYFsk=
Received: from T-EXCH-08.corp.yadro.com (unknown [172.17.10.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Proxmox) with ESMTPS id DBD20342070;
        Fri,  7 Apr 2023 16:32:46 +0300 (MSK)
Received: from yadro.com (10.199.20.11) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Fri, 7 Apr 2023
 16:32:46 +0300
Date:   Fri, 7 Apr 2023 16:32:46 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Maurizio Lombardi <mlombard@redhat.com>
CC:     <martin.petersen@oracle.com>, <target-devel@vger.kernel.org>,
        <michael.christie@oracle.com>
Subject: Re: [PATCH] target: core: fix invalid memory access
Message-ID: <20230407133246.GB20571@yadro.com>
References: <20230407130033.556644-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230407130033.556644-1-mlombard@redhat.com>
X-Originating-IP: [10.199.20.11]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

ACK

