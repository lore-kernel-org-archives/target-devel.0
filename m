Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793905144;
	b=zEpLRkL/c/1kOca8DOcs2kOb6QK0q/jg/k5qF/CUK9b5V9EAYhRZmGvPlw1Zjsm2qtVK
	 KUk7+lYUqC/y1XQdeYBbYnOD3Wb1yVDlh956yOhq23NJrffEHyGD3H1BcP6zqpxpjYQcT
	 DezybibFOBRAPKsxsekmewOvqhfaK9SOQV7hQhqQnbK4P0o+pqfLEY779rPWDFjQAdigE
	 acgLufPYgCvGEMy5uGvqz06P+4R8PH5CTDh4XgHofIZ0y32jyT+rdkgk/pt9/aEB+Lh3g
	 DptFWCTNe/hfa2pNoAvjBBtkn3c6Lug8XNuODNgm+OFWVtNuNMMRO1xHangPA78DnPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793905144;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Subject:From:To:Cc:Date:In-Reply-To:
	 References:Content-Type:Content-Transfer-Encoding:User-Agent:
	 MIME-Version;
	bh=GtVJ5fDzJs7dwdJ7kQ13zFePN7w2DrejpnY2Ytkrdiw=;
	b=LmxOwMxpgiO408nemns3MnPXe4hFXy58tMtVMYi8jRbQSv9qioCHI63tYxM/XLy4Pyz1
	 A/+qgmxAb+uotPX7yphM46wGqHAcG8nAYvpK3cQVP+jh5wwjFixSDePxcGI2goRWr9Xp+
	 LkYlrPXaAFL8HFwQ7Vf+rLtiM6F2tSP9C9F2cywe1ETbMW6UBOUd2pC63liGmYxwEosx6
	 77rn2ZQUPaJqiM31sS+8zKnhSgDXQOHyhSXXwpj3xVk/nJIbzNEfi3v8LFyqjhQfCausA
	 tYwZ83gegYi8X8rXbxXJniyPPM4tPrFvr0sdLAczP4KcV3NrvYnMmkd9D0PaP9e3/JA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=DLycYrth;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=L6B5jDV+;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59475606A31B
	for <target-devel@vger.kernel.org>; Thu,  5 Nov 2026 18:59:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 59475606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=DLycYrth;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=L6B5jDV+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793905142;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GtVJ5fDzJs7dwdJ7kQ13zFePN7w2DrejpnY2Ytkrdiw=;
	b=DLycYrthOKqS3R3zYxK2muqHFBISPvgO4v38GTHXpzYpF6mhFL5dSE108rxcXAzhvrWEQP
	pfTBNZmanqSEuoiVkQdtEJUMcmKe1DWAOuZqJRfGo7eP4f+9TO0FM6GiaEO/YpyOs0voNM
	Tvm6zrFyS6wbBiwQX4HEWCqOPyFjU/I=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-247-PJkJWjMPPHW47cSKL8S-pw-1; Thu, 05 Nov 2026 13:59:01 -0500
X-MC-Unique: PJkJWjMPPHW47cSKL8S-pw-1
X-Mimecast-MFC-AGG-ID: PJkJWjMPPHW47cSKL8S-pw_1793905140
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-8b320a98b7eso34999677b3.3
        for <target-devel@vger.kernel.org>; Thu, 05 Nov 2026 10:59:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793905140; x=1794509940; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=GtVJ5fDzJs7dwdJ7kQ13zFePN7w2DrejpnY2Ytkrdiw=;
        b=L6B5jDV+fhmnDVZIKwO414AEnkdbC1y9UlWdyY1sY+9FXLp/OIb2pRQKxf8LxNGfqR
         GKsAe/hXDkpUfK5VNDRnXJmryWsxw4i3rPhyfLYDkfBXhj8qJMkwvLyJt0DDza48mJ5p
         7nDNabYytCLVRcEqiofEIXUIxj0yjn7JU/ecb9LxCxFmzdp0rvHikgCwEepns6xLUfey
         OPTw0xywPSbGwfIwQ3LaAQk27GwQ7KyzZGgqezX16MuU6g46/LL70JH6hhPbA7h1f2JX
         HkBXVHFq0TsHZ8t3xZRAC0rr4L0d8gymrARfhz3q5ZCa+ogTQAiTSR5nuFSLHCcGJRdq
         tYlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793905140; x=1794509940;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GtVJ5fDzJs7dwdJ7kQ13zFePN7w2DrejpnY2Ytkrdiw=;
        b=KytgHjWN7UbwcLimTb8nyFItdcsQzXd4+HGS4DC7T14z4lgHWJY+DhCNghjqa2udDm
         P8cQ4NIQeV6vHf5MICENGuvrQYExYRPE8BhpqZ9koZqIm0a8i3CCE0Ip6wacJITok6ks
         eGdLiMwOWUTEpfCJDVf9iDI8gjsfmy8VLuQaOlrE+8lU6hY1OU6yra6BHe8KlMMDD8Q9
         /9m45mqPyk3yEv1idxZ4hFJ+mW7DZCVl+1Z1DPRg7lOZ+WnTzx+jm1xo+qWZRHgGhuP3
         MIBe3LcTUp1f46u7+xApTwiG1ANqt3M1UDAeb4KqYu39xdQ+AMUOkZoYA2JgWKC6YWct
         XNDQ==
X-Forwarded-Encrypted: i=1; AL+hErHBaKelZ1W9uezW6ZPCrrjpVC1rNZ1RtrP2JcbwAB9faFEEJpjwrCqxTeuY+ZAEUDZbOVYgtqrOmzbhv6o=@vger.kernel.org
X-Gm-Message-State: APuU4Z/G7SUDlc0MUnlpxGKxMTq0UDOZmhT+rG5jb4WekIVrKuklZTr2
	ZzfkgYZWVDWiUnX8Bvc77qG25BBQHoGTns4jLr0PWduiMp9qHcwzLpiGRh6Q9PMYI9pmpfLnSM2
	pFeLmxg9U3nnCU9zp7A7Ko8dEenLep5FLnF1WLfiBj+Uk+3bi5lIaUIBhqZuvT/tJSg==
X-Gm-Gg: AYBFou1GvYfi2x6zQf7/VzS4QUvegiDXVJcO2ex383dx6Triyji3iKuEB4jm8LuzBOQ
	2tFM2cG3Fi0v4fRVxPC/wqiGVQEllKqLb2zWmi5bNXqOBYnbsA6gqmTiV/yQxuYAdP749fO9sMM
	hRHvdPrOekxb+DvDAZRzBqfBULBzCbCx8bqA0SPFSsAXaT8gga5qBzN2wondSOwBEI6j2uuGgYS
	K3oHj8P8njfybAhs1pZ1jGYCuUOnXfO5l29aIzZv9BkNJIBTaOcjuxbX+KRMv2MpTNkliMaaK85
	WqYlZDXrpkXH3hcLLzrQx/PEGVf68uyhusi9yWMx7i+YooFq2flUWcETVG8/Rvm+s6X7QJXCIP2
	mI+V5Qrmuu9qXrGD7E7Ufe8MBC6T93fjkjxDbVP3IDN9NtWbmZrO3DVcV0QvQN1SoxZ4Lp7uJPm
	eiU+nSA5R/rjNz7l5zuILLKfQcvD1SVf1pru977aQED42SloizKHNsiAWCV1/kb3t2oElDIbI=
X-Received: by 2002:a53:bd83:0:b0:679:887f:a2bf with SMTP id 956f58d0204a3-67c142c35eamr78959d50.36.1793905140256;
        Thu, 05 Nov 2026 10:59:00 -0800 (PST)
X-Received: by 2002:a53:bd83:0:b0:679:887f:a2bf with SMTP id 956f58d0204a3-67c142c35eamr78942d50.36.1793905139634;
        Thu, 05 Nov 2026 10:58:59 -0800 (PST)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:aa2b:ddff:fe88:da74])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67c135e8d5esm242675d50.19.2026.11.05.10.58.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 10:58:58 -0800 (PST)
Message-ID: <7dccd24b8dc18be694ffca063cd4c13655ff1c9a.camel@redhat.com>
Subject: Re: [PATCH 1/2] target: iblock: drop the dead kmap() NULL check
From: Laurence Oberman <loberman@redhat.com>
To: shao.mingyin@zte.com.cn, mkp@kernel.org, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org
Date: Thu, 05 Nov 2026 13:58:57 -0500
In-Reply-To: <20261105193351820CRZfBnzFE8zZm2DrNx0T_@zte.com.cn>
References: 
	20261105193346452uAUQ3LtGtsQ_d_O9gjAw5@zte.com.cn <20261105193351820CRZfBnzFE8zZm2DrNx0T_@zte.com.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Post: <mailto:target-devel@vger.kernel.org>
List-Help: <mailto:target-devel+help@vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:target-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Thu, 2026-11-05 at 19:33 +0800, shao.mingyin@zte.com.cn wrote:
> From: Shao Mingyin <shao.mingyin@zte.com.cn>
>=20
> kmap() never returns NULL, so the check after it is dead code.
>=20
> No functional change.
>=20
> Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
> ---
> diff --git a/drivers/target/target_core_iblock.c
> b/drivers/target/target_core_iblock.c
> index ea65d39fef88..604fca959f2e 100644
> --- a/drivers/target/target_core_iblock.c
> +++ b/drivers/target/target_core_iblock.c
> @@ -461,8 +461,6 @@ iblock_execute_zero_out(struct block_device
> *bdev, struct se_cmd *cmd)
> =C2=A0	int ret;
> =C2=A0
> =C2=A0	buf =3D kmap(sg_page(sg)) + sg->offset;
> -	if (!buf)
> -		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
> =C2=A0	/*
> =C2=A0	 * Fall back to block_execute_write_same() slow-path if
> =C2=A0	 * incoming WRITE_SAME payload does not contain zeros.

Looks good.
Reviewed-by: Laurence Oberman <loberman@redhat.com>

