Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC63BC433F5
	for <target-devel@archiver.kernel.org>; Wed,  9 Mar 2022 09:12:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbiCIJNP (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Wed, 9 Mar 2022 04:13:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231879AbiCIJNO (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Wed, 9 Mar 2022 04:13:14 -0500
X-Greylist: delayed 393 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 09 Mar 2022 01:12:15 PST
Received: from mail.lasedrum.pl (mail.lasedrum.pl [151.236.17.159])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FD4316BFAF
        for <target-devel@vger.kernel.org>; Wed,  9 Mar 2022 01:12:15 -0800 (PST)
Received: by mail.lasedrum.pl (Postfix, from userid 1001)
        id 5BA4640E5B; Wed,  9 Mar 2022 10:05:32 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=lasedrum.pl; s=mail;
        t=1646816740; bh=jqHIBqxs7o8giDgUN2U2QL98LF/31E7JMwKZLkg2F1M=;
        h=Date:From:To:Subject:From;
        b=TyfpCBOyrWbhEatphwiaOedRXTmo6R39TOJtC9mefLZlAoAFbemWOFm7BfnVqOotn
         BN7BqEv1VBY8hHpjYfjHUQUPcHcz+LfHqErCbf1KCmCmLmx10Pdyj4SMZJ5kBchw7e
         zWR+Zp9Teq8CG44z9H1CzoMtetojUeiFohLDjfvQ0ht4Zkyzk2RAH1xRbEoq/zT+4+
         bsoA2HyJeZP7GvP6680hqxQIhW1Kx/ucRL56pmF2yIamAEtY8F+uAwypI+Ko3qcKa4
         8r2FchfITfRDaUwvcqBlJY/8SgohhrKm3h36zleRSZDS11gdvkRbwU5h37FzUjBwhz
         F8Wch4aQ48fwQ==
Received: by mail.lasedrum.pl for <target-devel@vger.kernel.org>; Wed,  9 Mar 2022 09:05:28 GMT
Message-ID: <20220309084500-0.1.1c.3cal.0.g33rh3v7d3@lasedrum.pl>
Date:   Wed,  9 Mar 2022 09:05:28 GMT
From:   "Marcin Chruszcz" <marcin.chruszcz@lasedrum.pl>
To:     <target-devel@vger.kernel.org>
Subject: =?UTF-8?Q?Pytanie_o_samoch=C3=B3d?=
X-Mailer: mail.lasedrum.pl
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

Dzie=C5=84 dobry,

Czy interesuje Pa=C5=84stwa rozwi=C4=85zanie umo=C5=BCliwiaj=C4=85ce moni=
torowanie samochod=C3=B3w firmowych oraz optymalizacj=C4=99 koszt=C3=B3w =
ich utrzymania?=20


Pozdrawiam,
Marcin Chruszcz
