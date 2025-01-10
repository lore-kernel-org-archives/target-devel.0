Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A14B207A15
	for <target-devel@vger.kernel.org>; Fri, 10 Jan 2025 08:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736499320; cv=none; b=oXdIPgkRK2WRPSDgWJuEBU8hJYPf9d74H1jYxhM8DdVyFJpPNCapd40me+OqN+ycx9mCSP/U6FKNvNJoBgkTRq6KbDcWFv0g9k1K8uRt1s21mfhmPcE/4ll3ELaX4g4ZQa6vYqGGT4Fldmb6vUgNSoutScbaXS7E+O3+w6S3vMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736499320; c=relaxed/simple;
	bh=cbmAgBIFGegMw9/n64PG7MiCf/X/4twOdx1csl9BLho=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Zjba5FRTa504WguqNyk/7O8vAtS3gjbu/6I2eKfsIXuNEhmVrnbH7sc3DMbZbSHFdnvB4cTleq7GPftz/cAjH6sj9WYP9tpfHvHzZHH2Xsn4RlkQQqNee7J0FXR5xmatIm5tBAikBhfrpd4zFRAJBk3YM9Cm4zj5dnIGYcFXnrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KJnTQJ2A; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KJnTQJ2A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736499317;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cbmAgBIFGegMw9/n64PG7MiCf/X/4twOdx1csl9BLho=;
	b=KJnTQJ2AbuZlWrRSzKRUbap/mYS19Aimces8KaEVmfdMyUPIf9gIPbPRc6DN89fkCeTYVX
	daxD1Eeqp+EsB6+Ipr1I1k1R/2IYggZq2YXIoiuL45fpyrtb2BiRck/Q6LEGgJj2BGjKgQ
	h0oYK2e8cPtFEySSF5WOElNEqk9nnC0=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-465-nwICduqYP5euJUQsV90JFw-1; Fri, 10 Jan 2025 03:55:16 -0500
X-MC-Unique: nwICduqYP5euJUQsV90JFw-1
X-Mimecast-MFC-AGG-ID: nwICduqYP5euJUQsV90JFw
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6dd43b16631so23555026d6.2
        for <target-devel@vger.kernel.org>; Fri, 10 Jan 2025 00:55:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736499314; x=1737104114;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cbmAgBIFGegMw9/n64PG7MiCf/X/4twOdx1csl9BLho=;
        b=KECZDxpOvjPq0q4Kky1banUpIxXDFgrNjwUuayRL1aGBEfrytvw0I7g1UheV2o09/n
         DkWurVqadH3FzSE/mm73lPaBZu9rhPZV97xIg8xxIFEsudham3TnZCFSlKfgT5KD8vUV
         eZCOD+XYbDSdRKwlSxAJl2Z6QMKJG0tOiNjKdhCnzARTc0IrHAefCWXTOPFFaAjhlVq/
         q8m/N0lQtgOvdOdCBnT3Hn3lrzBBY+pC7JVD5KVngEBLaamsZ1wmeYRnLCOLLr9bYUNk
         bWAg5WfDWYRgY2nTBTy+t9zng4xL/VxIne8AyAML/e6403EgQIPQRQBfkeWMgrnbiCvS
         vXRQ==
X-Forwarded-Encrypted: i=1; AJvYcCVyfaAohMFokDT3bQ2X46yZI71cI33lklxYIq3dgqEn0xZoRuMIx6MvM0fHny9BIOUQ+BxwJBMYqbwcoLc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKmFZ1ZgSHgxhpbpldTA1K0hJIINtHvW2oQcSyvGDEBly4Mm9F
	lYso8pBjhvOhggHfTe2tK/MjE3gTJugiz8ZtwDIGCzn/Hr76/DORE7BYOIRksh1CW17WsksGrck
	eTNvOEvc+S23xHt61tgjE5PUk+ABrN31bpGsDAeOWkPVpuRVHaIYSNH2FuwNTwVLagoRE/kamt6
	IV8Jje/cqW1g4kjp5VAQvgEBmW+JKYQW5/tvpa
X-Gm-Gg: ASbGncsKOgxdoJyDwSVaLdqov+RL2pOEcecmIQqyWWxhamLY8wANC3QFvZtQ/mOqAFh
	9XcJJlAm8SGq0oAUw+BWznkdXf7fCaY+J7O3Tsw==
X-Received: by 2002:a05:6214:5087:b0:6d4:2131:563c with SMTP id 6a1803df08f44-6df9b262054mr165554706d6.27.1736499314557;
        Fri, 10 Jan 2025 00:55:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFlFJ0HS11+WfG0bEtJnjkEwNkOKy8oKZOjFbOo4kwZMQuiwkXmEgjDB8+21fXJ6QpeTexzK3Pg9H5Pxdc7LOM=
X-Received: by 2002:a05:6214:5087:b0:6d4:2131:563c with SMTP id
 6a1803df08f44-6df9b262054mr165554486d6.27.1736499314213; Fri, 10 Jan 2025
 00:55:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241224101757.32300-1-d.bogdanov@yadro.com>
In-Reply-To: <20241224101757.32300-1-d.bogdanov@yadro.com>
From: Maurizio Lombardi <mlombard@redhat.com>
Date: Fri, 10 Jan 2025 09:55:02 +0100
X-Gm-Features: AbW1kvYnXJkhbPEqu4IpXNoV5UnRXMqrTZBLlHDj0sIcttE3Bl45IJFK-3u3QEM
Message-ID: <CAFL455nr=4V9ObetZaoECTTvm8wEREkQDfbFN_9_dqjqgJQ_Vg@mail.gmail.com>
Subject: Re: [PATCH] scsi: target: iscsi: fix timeout on deleted connection
To: Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc: Martin Petersen <martin.petersen@oracle.com>, target-devel@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux@yadro.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

=C3=BAt 24. 12. 2024 v 11:37 odes=C3=ADlatel Dmitry Bogdanov
<d.bogdanov@yadro.com> napsal:
>
> NOPIN response timer may expire on a deleted connection and crash with
> such logs:
> That is because nopin response timer may be re-started on nopin timer exp=
iration.
>
> Stop nopin timer before stopping the nopin response timer to be sure
> that no one of them will be re-started.

Looks ok to me,

Reviewed-by: Maurizio Lombardi <mlombard@redhat.com>

