Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 330C413666F
	for <target-devel@vger.kernel.org>; Thu, 15 Feb 2024 17:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708016952; cv=none; b=fnE1CcScqAjtU5GppcDp9Qd6QpzgttrB4+cvo5iZwm2fcp3MXJfKWlHA4CgCaERuaXVOnMDR3Oj3oOOLiHKkqPVBCd1Bo4y9Us6L/Q1dyVzycGOXXr+AOjnEv/TX6JPRj2XILWioLO2viVSv+AdaIEaSfg/A3XJbRx/o2i82N7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708016952; c=relaxed/simple;
	bh=+gxxkxAnAEQlZleQZ+wm/qc2F5HNzRdgPWV8KaEq+mw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ql6Xk6cGS7UVQVBz6U32q1/WrYYWIG++5ZrN9i/oa0+C1+meq6izGYGncDpoktmtK/yFauvay7yBhFtevrv6Mt6P0IcGfbZhHY4YtDOrmPK/4LcrkNHqj5KyXfY5aAyVfCbv/0xIsA7tSgUPN56z+2vmjeCs6OMKgzZvv2LAceE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UDu3vs9K; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UDu3vs9K"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708016950;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+gxxkxAnAEQlZleQZ+wm/qc2F5HNzRdgPWV8KaEq+mw=;
	b=UDu3vs9Kqv/3kWrNcupr4ynsRmM/BQ6BhYP41euWUMln/1R/gaEqhhr5HJKGvDA9VhlIYo
	rCB4gUoA2zx75TbBHLpyTisQaIjpkCc8nAmiRGyGIV6xjmOlbqnRUR/Dd1Y99BrJl2HjzP
	LvkDpRFbK4GqclebesXFz8khOXcchUc=
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com
 [209.85.222.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-610-oH_o6jEsNwC46dVTj038vA-1; Thu, 15 Feb 2024 12:09:08 -0500
X-MC-Unique: oH_o6jEsNwC46dVTj038vA-1
Received: by mail-ua1-f71.google.com with SMTP id a1e0cc1a2514c-7d8e4dbe845so1781814241.1
        for <target-devel@vger.kernel.org>; Thu, 15 Feb 2024 09:09:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708016948; x=1708621748;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+gxxkxAnAEQlZleQZ+wm/qc2F5HNzRdgPWV8KaEq+mw=;
        b=GBiiaGrnjlFJvDjmO+4LdazLAV52VhsaBDThUaLUYsBcrmVhiX9FehuduI+rmC4VYF
         C0XTEDFrt2NnV/LJ/JngthsDWwHTage6CYvkgFWr/hvKEn/7eULEfLGwVKq/pwuHi92V
         arDQ+z0MeCzAWuKUHz12oQoy77FADCHNscTRD0x9rvzTjkwXwwBffGC9f1cZKRB/cbJ5
         E0Szzt03UaD+8S9emKqX33EI7vnygbeIUFpRGtglOzlqeL8t0UCVuwLJluNRpOYHuknR
         cVK5trdOs964fYX5nMIoW8Jmy7GIxdnZ0ThM8UabA9Nt2coeCANVv0ZUd9GTzZdkDwKy
         Ti0Q==
X-Forwarded-Encrypted: i=1; AJvYcCUXllIC/nchF4a6sF63X7JxEvzcmmJm6F8f8Z38kKgkb0KVIRvMOx+bu+HMP+HEnMeMO+jkGvp0BxXbT66MEmUxth3lcGKlwsTRDwq9
X-Gm-Message-State: AOJu0YxB4oad30Seu6DQZ9NNtt+UXEN2AvckTvoSdTk4JGEnQWv3975R
	AxJkl44NMHij7OsY3yKE/D/ZNdjdWc9X8JEJ57klgXIhupm5nLCOCNIZAGXSZtJ7ubagOof99Lj
	TxAhfZUAnH30EZmDTDE6c85ttbK7lK/WdPHhwfkOIe0jk04ym+nbsWdCrbnsVc+Ug17dMtaHyr0
	66JL7v4ydFH2+nmogRIQzx7xdbJXlE+s7OJOdALdQjWsoI
X-Received: by 2002:a05:6102:b16:b0:46e:cb85:998c with SMTP id b22-20020a0561020b1600b0046ecb85998cmr6102131vst.3.1708016947878;
        Thu, 15 Feb 2024 09:09:07 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFqKN8nXG9DHdlGCKBx7j2h+yBVgeTITjkwdhQ86LVF1SxQWbSi60KlBl6PJI+9np84yiXLCdbc47riWfuRXdk=
X-Received: by 2002:a05:6102:b16:b0:46e:cb85:998c with SMTP id
 b22-20020a0561020b1600b0046ecb85998cmr6102094vst.3.1708016947610; Thu, 15 Feb
 2024 09:09:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240215143944.847184-1-mlombard@redhat.com> <20240215143944.847184-3-mlombard@redhat.com>
 <69dfb8a5-ef4d-4b38-8b5f-f793166b2c24@oracle.com>
In-Reply-To: <69dfb8a5-ef4d-4b38-8b5f-f793166b2c24@oracle.com>
From: Maurizio Lombardi <mlombard@redhat.com>
Date: Thu, 15 Feb 2024 18:08:56 +0100
Message-ID: <CAFL455mS93DvhizUizcro7c3+Go_4LJxsE04ywQ2TLc5RCCE0g@mail.gmail.com>
Subject: Re: [PATCH V2 2/2] target: set the xcopy_wq pointer to NULL after free.
To: michael.christie@oracle.com
Cc: d.bogdanov@yadro.com, target-devel@vger.kernel.org, 
	martin.petersen@oracle.com, linux-scsi@vger.kernel.org, 
	james.bottomley@hansenpartnership.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

=C4=8Dt 15. 2. 2024 v 17:42 odes=C3=ADlatel <michael.christie@oracle.com> n=
apsal:
> Why do you need this? Isn't this only called when the module is unloaded?
>
> We don't normally do this for that type of case in general. In the target
> code alone we have lots of places we don't do this.
>

I don't really need this, it's just a matter of personal preference,
we can drop this one.

Maurizio

