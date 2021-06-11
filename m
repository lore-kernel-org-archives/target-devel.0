Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C48EC48BD1
	for <target-devel@archiver.kernel.org>; Fri, 11 Jun 2021 17:04:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 221F6613AD
	for <target-devel@archiver.kernel.org>; Fri, 11 Jun 2021 17:04:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbhFKRGy (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Fri, 11 Jun 2021 13:06:54 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:36004 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230322AbhFKRGx (ORCPT <rfc822;target-devel@vger.kernel.org>);
        Fri, 11 Jun 2021 13:06:53 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 1F6BF4136F;
        Fri, 11 Jun 2021 17:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-transfer-encoding:content-disposition
        :content-type:content-type:mime-version:references:message-id
        :subject:subject:from:from:date:date:received:received:received;
         s=mta-01; t=1623431092; x=1625245493; bh=3b3fqeQjkjgrRm10AMwiXf
        0+w6b8A53o3opzcvFjTCs=; b=kBc1ueelNDDG19WDOGFIenSsG7GupSe8k2WOaw
        p9t1ZMgAMW58N2Wi7qivIP9NLFQnb9MUx7xRtHBIaGC8oBO86EUY6wfEUx1Hi+bG
        YFebFFoUoHT4zDP8LBrQT9nZIEeg7v5mepsjxV9E9H2wnnbg4JT0yCQM5IdgfKxr
        z/8Y8=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id I3W7xZB-Oonb; Fri, 11 Jun 2021 20:04:52 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 698E84131C;
        Fri, 11 Jun 2021 20:04:52 +0300 (MSK)
Received: from localhost (172.22.1.233) by T-EXCH-03.corp.yadro.com
 (172.17.100.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Fri, 11
 Jun 2021 20:04:52 +0300
Date:   Fri, 11 Jun 2021 20:04:51 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Maurizio Lombardi <mlombard@redhat.com>
CC:     <martin.petersen@oracle.com>, <target-devel@vger.kernel.org>
Subject: Re: [PATCH] target: remove the auth_type field from iscsi_session
Message-ID: <YMOXs11TpYSHz88I@SPB-NB-133.local>
References: <20210608164047.128763-1-mlombard@redhat.com>
 <YL/5074knGDS2Ska@SPB-NB-133.local>
 <CAFL455=Bi5aAfJtjpM0xzWdb4xoKW+JfnNO_2NJ2tvBQGfM6-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFL455=Bi5aAfJtjpM0xzWdb4xoKW+JfnNO_2NJ2tvBQGfM6-g@mail.gmail.com>
X-Originating-IP: [172.22.1.233]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-03.corp.yadro.com (172.17.100.103)
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

On Wed, Jun 09, 2021 at 12:22:36PM +0200, Maurizio Lombardi wrote:
> st 9. 6. 2021 v 1:14 odesílatel Roman Bolshakov <r.bolshakov@yadro.com> napsal:
> >
> > It might still be useful to carry the meaning of "effective auth_type"
> > in case of complex auth configuration. Otherwise there's no way to check
> > what auth settings took effect for a particular session/I_T nexus.
> >
> > I think we should rather print auth_type value someplace in configfs
> > than delete the field altogether.
> 
> Ok I see what you mean.
> 
> If acls are used, identifying the CHAP-protected sessions is
> trivial... you just have
> to look under configfs /tptg_1/acls/.../auth and tptg_1/acls/.../info
> 
> If dynamic sessions are allowed and the tgt parameter AuthMethod  is
> "CHAP,None",
> you could end up having some initiators using CHAP and some not...
> AFAIK, in this case, there is currently no way to find out if a
> particular session used CHAP or not.
> 
> If it could really be useful to know that, then one possible solution
> is to add this
> information to the "dynamic_sessions" list in configfs,
> but I'm not really sure this is acceptable because it could break the
> user applications
> that rely on this list.
> 
> Another solution that comes to my mind is to create a new configfs
> node "sessions_info"
> that contains a list of all connected initiators, their iqns,
> authentication method etc.
> but if the list is too long it could be truncated (attribute's max
> size is PAGE_SIZE).
> 
> Or we could create a new configfs directory "sessions" and each
> session would have it's own
> entry there.
> 

Hi Maurizio,

Yes per-session file would work. I think about sessions directory in
debugfs (/sys/kernel/debug/target/sessions/<session-name>) with the
following contents:

  * "info" file that contains aggregated information about a
    session

  * per-command directories named after command tag where we can inspect
    every command in se_sess_map of the session

    * "info" file for the command that would allow to read exact command
      state including transport-specific details and probably command
      addresses.

The reason why debugfs is preferred over configfs is the following.
There could be cases where configfs entries couldn't be destroyed due to
a command stuck in the session. In the case we can't read configfs and
have no fallback way to figure out the reason of the TCM lock-up. All
commands to access the session might hang.

If we create debugfs sessions entry right after session init and destroy
it just before session is freed. Then we can read it while the session
as long as it's alive.

Reading from "<session>/<tag>/info" needs to be consistent but shouldn't
have an impact on the hot path. We might need to introduce tag/se_cmd
generation for each command in the session. The generation is increased
on every get_tag()/command allocation. That'd allow printing routine to
detect that content of the debugfs is stale and read should be
retried/EAGAIN or aborted.

It's very raw thoughts but hopefully I'll come up with something that
assists in session debugging.

Regards,
Roman
