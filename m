Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B65617335C
	for <target-devel@vger.kernel.org>; Wed,  4 Dec 2024 20:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733345250; cv=none; b=bIwRwwTIktSr9qeTBK9jYJ0oUzEzyNYfMkcR5DkqT210KpF2QfsX8t7V4LNYS7TfbkdIE41iaFdhUYPa18RqkjCqtseBnYXEPD6zOwfTxmLwxDMVakU/BJs54AjZ95x4rnnXvHDM8bDtAK3/yf0y7MSyGYa0uDFrXnUYt2Ai2wQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733345250; c=relaxed/simple;
	bh=m8m0Pb5AOH9C5SbM5Y38gauDgNeP9F3syMc6moF6jSs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KlPMDtKH+DqSzwWMdUnhiFjNJxD3bWux/VnrCMBeMfx0dOptoexc7keXBNTVawQrLaAscy968Oxwmbg8SmsL7bJbHbj6bkPDQjKLtcKR+wybm6363KkMyJfVAX/tHl1fOsddMx4xVjRPfG/g/C8nLm8ox/rra/ZMZLAW+KainuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F9McNUot; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F9McNUot"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733345247;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=m8m0Pb5AOH9C5SbM5Y38gauDgNeP9F3syMc6moF6jSs=;
	b=F9McNUotxO3Ss3RdoXHtbZ0EKMyPECNlxh+SHBKjdQT8u6ztD24llub5bsNtyIGOvhtjxu
	JtIrWjJnD9m7Dt3LOTUNwPlhsjd+/ZMcAU0485UrOMy0/xulzScAHXoNjvvA9LsXrPg8ur
	QCTlyLqsnI/acxTWtsHyMdoooHB68m4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-42-EatMqeSWO4i1fDBghL2ITw-1; Wed,
 04 Dec 2024 15:47:26 -0500
X-MC-Unique: EatMqeSWO4i1fDBghL2ITw-1
X-Mimecast-MFC-AGG-ID: EatMqeSWO4i1fDBghL2ITw
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 63ED41955F3F;
	Wed,  4 Dec 2024 20:47:25 +0000 (UTC)
Received: from localhost (unknown [10.2.16.246])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6FF031956054;
	Wed,  4 Dec 2024 20:47:24 +0000 (UTC)
Date: Wed, 4 Dec 2024 15:47:23 -0500
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Mike Christie <michael.christie@oracle.com>
Cc: jasowang@redhat.com, mst@redhat.com, sgarzare@redhat.com,
	pbonzini@redhat.com, target-devel@vger.kernel.org,
	virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v2 0/8] vhost-scsi: Memory reduction patches
Message-ID: <20241204204723.GA48585@fedora>
References: <20241203191705.19431-1-michael.christie@oracle.com>
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="hFZFi1BZnDJeU0rX"
Content-Disposition: inline
In-Reply-To: <20241203191705.19431-1-michael.christie@oracle.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40


--hFZFi1BZnDJeU0rX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 03, 2024 at 01:15:07PM -0600, Mike Christie wrote:
> The following patches were made over Linus's tree and also apply over
> the mst vhost branch. They reduce the memory use for vhost-scsi.
>=20
> For a simple device with 1 queue and 128 cmds we use around 25 MB. These
> patches allow us to reduce that to 8.2 MB when supporting up to 128 8 MB
> IOs (the current passthrough max size).
>=20
> For a more complex device with 16 queues we use around 2.5 GB. These
> patches allow us to reduce that to 77.1 MB when supporting 1024 8 MB IOs.
>=20
> v2
> - Rebase against current trees/branches.
> - Fix email threading.
>=20

Nice improvement! I haven't reviewed the patches in detail but this
sounds good.

Acked-by: Stefan Hajnoczi <stefanha@redhat.com>

--hFZFi1BZnDJeU0rX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmdQv9sACgkQnKSrs4Gr
c8i7QAf/f/EdoRoSDhepp8tPxlculmrsqaR7+Aqfvs/06vk9026xdKVo4XxwzXzb
3j1eWdSRiXw8f3Z3LmRV38D4TzMpUaJrGrgSRMXR3A+cFRJVYBF+eOO3MwmSDVXB
PEwJthub3exehRXYuYw8iTlDYLMu/JecoNlQIq4jTP+8dqCpdzFrI+/yrZVtIio6
9OPN8aDMWSdTO3As98NkRPsq8P3PMn3T5LR/D0N2ZI5cRCHDr+HswHVpRiNbyVeH
OBPWiHQn+Twix7r2+TEYwCYFDfvSWMD4ORtHRC50MpZjdbUjTdlzSqYT23Vt1j78
rxQ5ZCItLMyiQPbTBQ3krB70m2Oa4Q==
=aOhi
-----END PGP SIGNATURE-----

--hFZFi1BZnDJeU0rX--

