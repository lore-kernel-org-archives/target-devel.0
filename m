Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748DF3242D9
	for <target-devel@vger.kernel.org>; Wed, 26 Aug 2026 04:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787719025; cv=pass; b=VXbPRbUC0ltIlymJDNrM6z9YA7qt+7LrTnnHmUuSjByYP5PmgMCvEe6veS0wDP/TpQ4d34v+dxKG3f/lbk4cuZHYHtgWRTNH1eaqhVltnGzLiXH3j5/2ESd2NVmB65U8XHQIdXG1gGddDQozYPAnZiDSrv3MnTMZpKJUD3duwMI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787719025; c=relaxed/simple;
	bh=xocIVRG0rHG//NgAWUeZnGmxkGXCo2ACyK7AAxZSkhg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=USMjUJkWGtB3yHOFrSGc0LldFD9SEFlvOaGej5EC4Fs9hB33eeJ3xPx5xEs00NV8nW9PSAnbcSnOc33ieszYbJSC7XCxtUS+zR8J4ODjdJwSX8oNSmDfNNWhWpSABZKKZ3VG9jNLOd6IrMigAIwsje5onJegzYXeMNMqM6Lv2/I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cGAJ0F0N; arc=pass smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cGAJ0F0N"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-39db07589caso4180501fa.2
        for <target-devel@vger.kernel.org>; Tue, 25 Aug 2026 21:37:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787719021; cv=none;
        d=google.com; s=arc-20260327;
        b=PShiA/eWGgaf340QSW+wyjXzG6i0UjuK+UTFcVnztHgq06Dl2plqlTO/Jnhe92sPDo
         L23bmXFOFZV5gIxNqkVD/Zfnd2JjyR7b5/mbQMRqis3jntK5q7w/87PBljtUm8EpUbtU
         fWvxHYO2sKF4ME4VlF0/vwzOJPCafwGHjxVPC07giB+N77tvn20RBMlcBO0pCQI6JXnf
         WAqClIAsQDqrNNPppZ6RSR5FgIVm70qOOnrMQYccbIIZs4e62XpZlHMj7L7TfKkVxFHT
         +EFpg1H6lB5b1xh9cudhV4Tm8Y3RMe9c4LU+daz9xw4kCFuuqNHku+dT4G8lhPlO3Bxd
         PyWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xocIVRG0rHG//NgAWUeZnGmxkGXCo2ACyK7AAxZSkhg=;
        fh=AJQzs8u8/PGqhiHjwUEHcMw8IRjeUfXb4Fmjv0IKbEg=;
        b=eyhacCaimAWk9IGFstTVw9e2o1hjMGAgZ+QL7YAJ0MHV9+I7FxkzbOHFCD+bGxPwJg
         zabKpkYYT4VYFWS3C0UXm2nXinudMDPmCDcYmt2oZuqc5Tgt0SfygIw6t5iZmVVaWZKv
         ocFyQdgSm4XFbg6u1e1aIJghy/O42B2ZRBDzjgzUJqzmlun5yWevU0vlZm6WlEk+azOV
         QRTeE0/jYxPQ84iYXaKDExphaiGiWfAimFuSYxjuUdov0oPurP6pcBHJvEMtCyLOopdt
         A5eSTiEshZfGw4PsYYdr6UdFM/qU+cQmh3P2NlRtfWPQdBaTU3LwBOiNg2LPuCUypKU7
         GCbw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787719021; x=1788323821; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xocIVRG0rHG//NgAWUeZnGmxkGXCo2ACyK7AAxZSkhg=;
        b=cGAJ0F0NvT4R6rBis1sXGmlDYbFL1VV19zlNRu6fxsdHOyPiLr6oKlbByfrMpa1OTm
         6Fme1vwVYCGahj2CJUGD14C5139xA2QEygzAe/h/d2bnVF9/pIt7YudBNSZsWr7vNJ1h
         y7obhapGDgN9bSP3WPpfP89eLScMoN+xQiyMNYwf8ZHswd36NRb3dyWVXwah1vPVRUtT
         OYIfY97sSv8LFtEjRy6k7mLiSbIUYh6v8kkXtzr+q+SfbUhTB1VKth3lqAkzZgc0KoWm
         gedoMYeZkM9Nb8XlYuTSi/ovm1qrgrz2XRSOD8pmRFSRc9++aUs7hKEg2QMTkQs/6DTz
         Qneg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787719021; x=1788323821;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xocIVRG0rHG//NgAWUeZnGmxkGXCo2ACyK7AAxZSkhg=;
        b=kh85q3uaNogfctZImRYE/cY3RCJpIaxzMoN9gekXocH+/BL5Y9T9CCgLKXSy4iwqlU
         vnF2fMUZsjLW6eBNiYS+NC5MW+aCGfNvZWNd9oK3LQzhN9VZp2DcQy9hN9IYyJBjmtX5
         SDRHNbYuk067AmPIYtnIckEXUwrZ4deN5LWHby2acDGjQCBgqxvrFptkUiZz2fbJHiR2
         /wY5zBw6wVEayghcuHF9CGbxpaY/EkrXGv2Ur4UjC9I1TZe2JK2s6EiRvk6YajgVTiS5
         e0xovkn8zhEYWyz8ER1DOwSZCuI7pO4KjuiWQi7vtCepFhuBh4tsnOAojt71hhTT8kBg
         ZqNg==
X-Forwarded-Encrypted: i=1; AHgh+RodoRJMI3+GANPMnRmadGdG/YVqypnemY4G9NWG1U8lY1PGbDdG2K5F7ZdanZLabSciS5TvsT0dnyN4di4=@vger.kernel.org
X-Gm-Message-State: AFuF++nx7U5e2fv35hSZ00NenEjpMNl7MoVmap6NldpX3svHDil6h9Qh
	C2fCHl3hHnquq7SV4I+YvER9C7Ob53w8JuFts6kcPl0jzEhtFu9Lb7ZS7hu2bxO50gCQoRN32KZ
	kIwFKhCnejCktrcRzCqamyQ/Q7cANTgo=
X-Gm-Gg: AR+sD124maRk7Q20cO6JYZz8WrlL0dQ0NikKchtuPiYDRVSKlFmsQhHnaNcENxJKTJy
	OPeZ02kSW+DO0CyMqzhnsXrunxZxcDBYdQoltb3DUjLARducsioCzWAFv+onN2e7nAPtz3rdHop
	zx2bneQ3hqLUOF2xQRMbTmr1D8n+CKnDoCyHxIK27jKPZ5aDEaQiZSJSmE6gbpQqrSq62vWkSND
	0Uxt8ndKYm4QOlMe8O+SRjADeqhlfYI8fyF+6aMr//DAE6Zg2HUtZFaPDw9FcCcmU7Lmdya7id0
	2QV7NEoZLf4Pm/YoDwHYrvNZ7STj4OitkVblWGZRP0R+CHibq766V+DJQWYu+J5/OJ5kr1slC/i
	16P4=
X-Received: by 2002:a05:651c:154e:b0:3a1:4509:937e with SMTP id
 38308e7fff4ca-3a1fd473b5emr7956161fa.4.1787719021154; Tue, 25 Aug 2026
 21:37:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260811124843.6817-1-linfeng.sun.dev@gmail.com>
In-Reply-To: <20260811124843.6817-1-linfeng.sun.dev@gmail.com>
From: Linfeng Sun <linfeng.sun.dev@gmail.com>
Date: Wed, 26 Aug 2026 12:36:49 +0800
X-Gm-Features: AcwNN1XMIbrZFQSI7R58mkoIHo9nv9R24upQZvu6XQgKamt0W6uVGxTu_MiYw7M
Message-ID: <CA+kkGbtea56-HmXq=w85r9qGYB2fxeGyDCSddF=ZiRjgNy69tA@mail.gmail.com>
Subject: Re: [PATCH] scsi: target: iscsi: Fix race in discovery auth updates
To: "Martin K . Petersen" <martin.petersen@oracle.com>, Alok Tiwari <alok.a.tiwari@oracle.com>, 
	Mike Christie <michael.christie@oracle.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 11, 2026 at 8:49=E2=80=AFPM Linfeng Sun <linfeng.sun.dev@gmail.=
com> wrote:
>
> Separate configfs opens can concurrently update the discovery AuthMethod
> parameter. Both callers may free the same value in
> iscsi_update_param_value(), causing a double-free.
>
> Protect the lookup and replacement with the discovery TPG access lock, as
> used by the other TPG configfs parameter updates.
>
> I dont consider this a high-severity security bug, but for safety as a
> precaution, I can provide the reproducer PoC privately to the maintainers
> if needed.

Hi,
A gentle ping on this patch. It fixes a reproducible double-free in
discovery AuthMethod updates.

I have not received a response for over two weeks. Please let me know if
you have any comments.

Thanks,
Linfeng Sun
