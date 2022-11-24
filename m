Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F17CC43219
	for <target-devel@archiver.kernel.org>; Thu, 24 Nov 2022 21:29:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbiKXV3n (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Thu, 24 Nov 2022 16:29:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiKXV3m (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Thu, 24 Nov 2022 16:29:42 -0500
Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [67.231.154.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5258C052E
        for <target-devel@vger.kernel.org>; Thu, 24 Nov 2022 13:29:41 -0800 (PST)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.51.177])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 296B1A0060;
        Thu, 24 Nov 2022 21:29:40 +0000 (UTC)
Received: from mail.lunahosting.net (tomservo.lunahosting.net [67.20.55.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 05A82680075;
        Thu, 24 Nov 2022 21:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=lunadesign.net; s=default; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-ID:Date:Subject:In-Reply-To:References:To:From:Sender:
        Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=9mP+cEwv+f4qjUJ0svxYUKhANnvEX4e+7gP/qpkiNwk=; b=zP2QNLjA+FmNXIZTn4CHGQRMid
        +H9/Ae3VdZO8yMHVdMCigi8wTUrclfTe3YpGHy+NDSgdtTA0fVr5DyxjKot/+YCPtNUPOaBaMqr02
        bwSWMsQ2O7Yv6lY2nk9pyeFTkvOeszYAJS72OUqeFuHap7c7D7f4l6pZ4WwI6xC4mYqgDb2ow399h
        E6Zo4WEM50Tt9nt0qstLtqukMmSuQFGDvDom36I/wVqV8gZHamZJypMcqjqtjkbauTm6sZcUpo6NF
        nLoR6VgZSMsvkm0/4MzOOoFLoYGuJ6kZYoNXpLSBCwGClePUF8cvjl4t6H5RmTTYPXXK2UX1K5jZ2
        zz3K6ZHQ==;
Received: from [50.126.108.206] (port=50048 helo=europa)
        by tomservo.lunahosting.net with esmtpsa  (TLS1.2) tls TLS_DHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <ln@lunadesign.net>)
        id 1oyJmw-0007Sf-09;
        Thu, 24 Nov 2022 21:29:39 +0000
From:   "Luis Navarro" <ln@lunadesign.net>
To:     "'Sagi Grimberg'" <sagi@grimberg.me>,
        <target-devel@vger.kernel.org>
References: <08aa01d8febc$74f61260$5ee23720$@lunadesign.net> <b7511c59-7a25-cf22-71e7-9333a2f332c1@grimberg.me>
In-Reply-To: <b7511c59-7a25-cf22-71e7-9333a2f332c1@grimberg.me>
Subject: RE: targetcli fabric modules
Date:   Thu, 24 Nov 2022 13:29:43 -0800
Organization: Luna Design Syndicate
Message-ID: <0d2801d9004b$de9da1c0$9bd8e540$@lunadesign.net>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQEvNhKmCSXvmp6mgyyqyNKSvLsQEAHSV0UDr5OUiAA=
Content-Language: en-us
X-MDID: 1669325380-e4iwu7kqauaw
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

> When setting a portal to iser enabled, the driver should be =
automatically loaded.
>=20
> I just ran with ubuntu 22.04 and targetcli-fb:
> --
> /iscsi/iqn.20...c34978ad/tpg1> portals/0.0.0.0:3260 enable_iser true =
iSER enable now: True /iscsi/iqn.20...c34978ad/tpg1> ls
> o- tpg1
> =
.........................................................................=
............................=20
> [no-gen-acls, no-auth]
>    o- acls
> =
.........................................................................=
.......................................=20
> [ACLs: 0]
>    o- luns
> =
.........................................................................=
.......................................=20
> [LUNs: 0]
>    o- portals
> =
.........................................................................=
.................................=20
> [Portals: 1]
>      o- 0.0.0.0:3260
> =
.........................................................................=
................................=20
> [iser]
> --
>=20
> # targetcli --version
> /usr/bin/targetcli version 2.1.53
>

Hi Sagi,

Thank you very much!  I'm seeing exactly what you're seeing.  But when =
you first start targetcli, do you see lines like the following?

Using ib_srpt fabric module.
Using qla2xxx fabric module.
Using iscsi fabric module.
Using iser fabric module.
Using loopback fabric module.

These are shown on the LIO ISER page but I'm not seeing anything like =
that.

The output on the LIO ISER page apparently comes from a targetcli =
version from 2014.  My version (same as yours) indicates 2011-2013.  So =
maybe the code that outputs that info was added to a version later than =
ours?

Best regards,
Luis


