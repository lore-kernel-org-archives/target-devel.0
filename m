Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9582FC04FDE
	for <target-devel@archiver.kernel.org>; Mon, 12 Dec 2022 09:13:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbiLLJNa (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Mon, 12 Dec 2022 04:13:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiLLJN3 (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Mon, 12 Dec 2022 04:13:29 -0500
X-Greylist: delayed 422 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 12 Dec 2022 01:13:26 PST
Received: from mail.alsdel.com (mail.alsdel.com [192.121.17.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E241FB65
        for <target-devel@vger.kernel.org>; Mon, 12 Dec 2022 01:13:26 -0800 (PST)
Received: by mail.alsdel.com (Postfix, from userid 1001)
        id 9E47F22BBF; Mon, 12 Dec 2022 09:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=alsdel.com; s=mail;
        t=1670835981; bh=EaccI34atZDi3zI4z+dro7EdezTMN10KG2X0nSBpSo8=;
        h=Date:From:To:Subject:From;
        b=IxrsEs7RKbgEGlX8iEFk168Cl6LKIdjO/jVfC/IHsJho7zOZ2xx9bf9aI8QlRKI8u
         8jK3j1NTWs7mnbmXxFgs9lCM8Afej5co2O9VEJAkZG2MunnU1yg7dOlDwWIbzwwVDj
         K+O6RyKRajx36UP9qyHmSLwVdS9jANBYWugAWrns/GAm9i39t+nfO7O0oylG6jETgs
         gBbAio78JMIEEE63N97yRlruR3I4bGcJRVRDYJD0ryMta5LjnuEluyRpJll3il4Sas
         iQNgkChCCyRDQLGBgegsXIub3GpXfltfMfRd4aMbw8O5Z0UkZJ70B+h6Yj4nAr/RA/
         21RVsNb48c/UA==
Received: by mail.alsdel.com for <target-devel@vger.kernel.org>; Mon, 12 Dec 2022 09:06:04 GMT
Message-ID: <20221212074500-0.1.t.21fe.0.n8j2domcco@alsdel.com>
Date:   Mon, 12 Dec 2022 09:06:04 GMT
From:   =?UTF-8?Q? "Vil=C3=A9m_Du=C5=A1ek" ?= <vilem.dusek@alsdel.com>
To:     <target-devel@vger.kernel.org>
Subject: =?UTF-8?Q?Tepeln=C3=A9_obr=C3=A1b=C4=9Bn=C3=AD_=E2=80=93_objedn=C3=A1vka?=
X-Mailer: mail.alsdel.com
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org

Dobr=C3=BD den,

m=C3=A1te z=C3=A1jem o vyu=C5=BEit=C3=AD velmi kvalitn=C3=AD slu=C5=BEby =
tepeln=C3=A9ho obr=C3=A1b=C4=9Bn=C3=AD kov=C5=AF?

M=C5=AF=C5=BEeme v=C3=A1m nab=C3=ADdnout velmi v=C3=BDhodn=C3=A9 podm=C3=AD=
nky spolupr=C3=A1ce, technick=C3=A9 poradenstv=C3=AD,
s=C3=A9riovou v=C3=BDrobu a testov=C3=A1n=C3=AD prototyp=C5=AF.

Specializujeme se na tradi=C4=8Dn=C3=AD a vakuov=C3=A9 technologie: cemen=
tov=C3=A1n=C3=AD,
nitrocementov=C3=A1n=C3=AD, kalen=C3=AD v plynu, zu=C5=A1lecht=C4=9Bn=C3=AD=
, =C5=BE=C3=ADh=C3=A1n=C3=AD, p=C3=A1jen=C3=AD, normaliza=C4=8Dn=C3=AD =C5=
=BE=C3=ADh=C3=A1n=C3=AD (s p=C5=99ekrystalizac=C3=AD).

M=C3=A1me k dispozici rozs=C3=A1hl=C3=A9 strojn=C3=AD vybaven=C3=AD, velk=
=C3=BD t=C3=BDm odborn=C3=ADk=C5=AF, a proto jsme schopni se p=C5=99izp=C5=
=AFsobit va=C5=A1im po=C5=BEadavk=C5=AFm.

Pracujeme v souladu s na=C5=A1imi certifik=C3=A1ty v rozsahu norem platn=C3=
=BDch v oblasti automobilov=C3=A9ho pr=C5=AFmyslu (IATF 16949; CQI 9) a t=
ak=C3=A9 letectv=C3=AD (akreditace NADCAP).

Pokud m=C3=A1te po=C5=BEadavky v t=C3=A9to oblasti, r=C3=A1d v=C3=A1m p=C5=
=99edstav=C3=ADm na=C5=A1e mo=C5=BEnosti.

Mohl bych v=C3=A1m zatelefonovat?


S pozdravem,
Vil=C3=A9m Du=C5=A1ek
