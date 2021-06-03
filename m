Return-Path: <target-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D84B0C47097
	for <target-devel@archiver.kernel.org>; Thu,  3 Jun 2021 10:28:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCDAF613AD
	for <target-devel@archiver.kernel.org>; Thu,  3 Jun 2021 10:28:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbhFCKal (ORCPT <rfc822;target-devel@archiver.kernel.org>);
        Thu, 3 Jun 2021 06:30:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58941 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229786AbhFCKal (ORCPT
        <rfc822;target-devel@vger.kernel.org>);
        Thu, 3 Jun 2021 06:30:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622716136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PPQToC1ik9oHfu1AmKA/86ffSnUnlZHx++iOqDu8E5Y=;
        b=NBk2x2Xju74+MRD88UlQGnJp6EPMTjz5vXM/EW/oVuaGBKidfpSc4flVsdG6rK1MXcjCt1
        kZ9s7df6H7iqe5Tsj0mQ8DhE9wZagy9xRCKZ5+C02nB+JKK1l+CLP2CcxfUcQ6GIM8S1Bv
        lAYaJcvUnLKeQEG8kFrByq9nLTkTGnw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-OHMTbGSeMdydLSw4QWlSaw-1; Thu, 03 Jun 2021 06:28:52 -0400
X-MC-Unique: OHMTbGSeMdydLSw4QWlSaw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C940C800D62;
        Thu,  3 Jun 2021 10:28:51 +0000 (UTC)
Received: from localhost (ovpn-114-228.ams2.redhat.com [10.36.114.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 08E625C8AA;
        Thu,  3 Jun 2021 10:28:41 +0000 (UTC)
Date:   Thu, 3 Jun 2021 11:28:41 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        pbonzini@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 2/9] vhost: move vhost worker creation to kick setup
Message-ID: <YLiu2SSYO6OFvMej@stefanha-x1.localdomain>
References: <20210525180600.6349-1-michael.christie@oracle.com>
 <20210525180600.6349-3-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="n/Dbkikjln5Hb9KX"
Content-Disposition: inline
In-Reply-To: <20210525180600.6349-3-michael.christie@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <target-devel.vger.kernel.org>
X-Mailing-List: target-devel@vger.kernel.org


--n/Dbkikjln5Hb9KX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 25, 2021 at 01:05:53PM -0500, Mike Christie wrote:
> The next patch will add new ioctls that allows userspace to create workers
> and bind them to devs and vqs after VHOST_SET_OWNER. To support older
> tools, newer tools that want to go wild with worker threads, and newer
> tools that want the old/default behavior this patch moves the default
> worker setup to the kick setup.
>=20
> After the first vq's kick/poll setup is done we could start to get works
> queued, so this is the point when we must have a worker setup. If we are
> using older tools or the newer tools just want the default single vhost
> thread per dev behavior then it will automatically be done here. If the
> tools are using the newer ioctls that have already created the workers
> then we also detect that here and do nothing.
>=20
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/vhost/vhost.c | 23 ++++++++++++++++-------
>  1 file changed, 16 insertions(+), 7 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--n/Dbkikjln5Hb9KX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmC4rtkACgkQnKSrs4Gr
c8iu4wf/Sk12UdeSXdEDKaWJ2ulcEl3xPNuQ07SuOYcgryJ97dPwlAcruGzMGcWt
RXT085PKTuq3wXxBWV5TJgAduO15mBdTb3r3Ns0IH+kYmCtauaH0xi12LtiNsmKf
sTf+3isPIWzjCjnLn+QzydOlJmnRbfGOlH6CDeMsg87HrpsuOJUEmgm5fuP6thSs
ZKLB3D6cdhcOXlqH4Bqmj75VZNot7BYrfNczyah+zIcdS5oFvArraAMsbOm2ahTz
HyrSRS8bmALHHLsZPry9PtltXQKdYeuSbwaRkpd4oWhTIP1EsbMRIuy/Trc59Y6r
htvrEZK30F4/D12V5p9i03VZZ0QQPg==
=D334
-----END PGP SIGNATURE-----

--n/Dbkikjln5Hb9KX--

