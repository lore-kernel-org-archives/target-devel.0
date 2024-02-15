Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6538E12DD9A
	for <target-devel@vger.kernel.org>; Thu, 15 Feb 2024 17:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708016870; cv=none; b=TxLunLMUlCw8ZvG0WgKLGg86DClWY+HTcZvlko7oorLQFs+S3MZaaUnhUx04xQR12HS9O31RUv/nryS0DbhPWiE6e8xtQUVpjbNaj7NDGBgQyKlOuWa8L+T53/zsAETEXxDOBvotFuKdG9EXuH9nSe4+rwhrrDleh+6WFfZhBJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708016870; c=relaxed/simple;
	bh=BqCtoCQHrzAUwiYaaLwqGf982YndP73amvuwOmKCxXw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rmS9Bh1kzb58QExLPNAOjG+pJeWuBgwDS5Ra0XmtU9pCZ3JAWbKjaGem5U/583uK3lsa8OD8YtfCsUEKJyQkHSaOxBktV5AexPmQltBLeNY2rJA8HdORClL0jIflEDirqwd8EmwI0Pk+nUaL9RU0Anrz8pL706Sknl3UQoUFO4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VAuLitYL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VAuLitYL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708016868;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BqCtoCQHrzAUwiYaaLwqGf982YndP73amvuwOmKCxXw=;
	b=VAuLitYLLR5lJWkCAymzuCesG++iqc8IsThXRRMTkXCwzRy9JhFXho6B/zIwZNdafvK3+L
	slsvWIdZ3ryVIgDdKk2XZn8Cc7YVliseIcneVwXkelf9485tqe9oF4lJNxE/cAhKfn+ePT
	xZnrcpLdqH2iGG68K8Vfo3QQ2PiDXm8=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-117-MSAoRZSAOMmsNtfXcBrTtg-1; Thu, 15 Feb 2024 12:07:45 -0500
X-MC-Unique: MSAoRZSAOMmsNtfXcBrTtg-1
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-3c036e04a9dso2164286b6e.1
        for <target-devel@vger.kernel.org>; Thu, 15 Feb 2024 09:07:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708016865; x=1708621665;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BqCtoCQHrzAUwiYaaLwqGf982YndP73amvuwOmKCxXw=;
        b=d93QM7YPKv+BVZehb4wrsOjzlolNZI0Xbk2Y/iOtK/km+tidS4bU9s0CyyJIHoozif
         cvtws0QmEkikiFuLvQhKN+SeSl+XdNQqKje/hKMpY4LnRWIXDe5MEjY2cS8WGIwzKtFZ
         diu7/TCFXu1lqKkGDuWn0PbaK0OBARjEcLCsoCg1+O7UEhpUP2MbSPtFPBt0OlshU60/
         aYqE/4chwipfxiqDRGZNw5qTpu8pAZtr31XcsQ6QsAWyLj5BGAxB3Ugwgov3VEokymKi
         9RLOAeUpXFNT1yRI/AEow4hbxhHRg//0tfpSBhuJUaGNNVu2Y8rOJr8vrBzCD6zaNDDj
         3ssA==
X-Forwarded-Encrypted: i=1; AJvYcCXeNcRAfZsGoDbGhYBp2kbH1oU3OwpL5VpKqFN+WPMs+c2SOQzOZBFd5qQmOWYpDuj9Zxe//YxvFMSjC1fmmge0VCjjusnHoyo1BsOg
X-Gm-Message-State: AOJu0YznTJZ2HbmWc+8IAytWRiRMcgaHGFe5WC3F4vxwleIHa+PGRxZM
	3a/nEc+KKij9H33C/EhorLAw28U93Nn/faDJkQJtRKSYO+uj7jrzMREvhX3Hre++OXPL3iEOfMq
	CiBk2+38rp/A6g7Th09rIQd0YDmvhMIkoqHslNntFZOj35I2QYJ77G2dC2g48BA0TTFJZTaiT1w
	mLKoSEgHsA+uwM5XyaXHHd7oDuVwmqEW7rW2wA
X-Received: by 2002:a05:6808:10d3:b0:3c0:b3f3:c30f with SMTP id s19-20020a05680810d300b003c0b3f3c30fmr2810397ois.9.1708016865054;
        Thu, 15 Feb 2024 09:07:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IESlgFGH+F95Jh9Jxk2Bvz+hi3v+FJokWREsaOdPcDYPEwsceqiqPlNbNqKY2qZyuKcggGWY/ikrQz3XF/BqR4=
X-Received: by 2002:a05:6808:10d3:b0:3c0:b3f3:c30f with SMTP id
 s19-20020a05680810d300b003c0b3f3c30fmr2810377ois.9.1708016864663; Thu, 15 Feb
 2024 09:07:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240215143944.847184-1-mlombard@redhat.com> <20240215143944.847184-2-mlombard@redhat.com>
 <094cd372-eb90-4738-acce-a3725dd2c0fb@oracle.com>
In-Reply-To: <094cd372-eb90-4738-acce-a3725dd2c0fb@oracle.com>
From: Maurizio Lombardi <mlombard@redhat.com>
Date: Thu, 15 Feb 2024 18:07:33 +0100
Message-ID: <CAFL455mD1XEYqRb80K1REHVeyWVmD2yKEViMY-AYqxhJ8bpQBw@mail.gmail.com>
Subject: Re: [PATCH V2 1/2] target: fix selinux error when systemd-modules
 loads the target module
To: michael.christie@oracle.com
Cc: d.bogdanov@yadro.com, target-devel@vger.kernel.org, 
	martin.petersen@oracle.com, linux-scsi@vger.kernel.org, 
	james.bottomley@hansenpartnership.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

=C4=8Dt 15. 2. 2024 v 17:44 odes=C3=ADlatel <michael.christie@oracle.com> n=
apsal:
> Do you need something similar for the pr related dirs/files or how does
> that work but not this?
>

I think that in that case it won't be necessary because the pr code is exec=
uted
by a kernel thread that calls the execute_cmd() callback, not by a
user process in kernel context,
but I will try and eventually I will report back the findings

Maurizio

