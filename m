Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3798C39341C
	for <target-devel@vger.kernel.org>; Wed, 21 Jan 2026 13:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769002850; cv=none; b=TPNJfxsoe/7FFDidFhoyUtNPcNBJaG5Nb9k8l+at2PtvVLb0GSXnwnTSRGSBRjsQeO0iSNQ+RUb2bYpD8vsUWgl6rWLKtzF5GhaHRCKTe3aqzUbvBitLlfoGfeIKWyKtcKykt5gIbPJFHdYSu82zI+A0W45XeBCE02YzykUhrqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769002850; c=relaxed/simple;
	bh=Zj98ZO/ts5b/MYgZaQn1CeOkJWBxcPQsjM8uYXM3aaw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DVu/qlmV87HPmyDBEF5VgLVxtMy6CZdFNnYnEMvLZpxlq4w3Roq2Mmv/oqp/+va0ou67ppIcnFkScEOTK+CCyvMI1q+ntGvfPX6W2l3fwSOBYz7oNq80gYFcFuRz4s2A++LBoWSFkLhEtPFcoB22Rshr6X8059vQxATldacUKeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F1tMCEeK; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F1tMCEeK"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-81f4c0e2b42so3439635b3a.1
        for <target-devel@vger.kernel.org>; Wed, 21 Jan 2026 05:40:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769002847; x=1769607647; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pPaaLejyMj+/qnEy2gN+yRCN0UmH2KujytP4NRWmWr8=;
        b=F1tMCEeKELRa0nVdKgeXsW8TRYImYt3BKVrYRDHTahS2rVVOcf8mJ+GAy1C+fELbWg
         PW4LIcjathuH7f6y1DNK5rt6VLeFzlrz2ZIYhEojVBO38z51OZEJhMNFaWOzR7gjI6U8
         7wO6gx/M7bZ3PCMx80W/P4jZTzFUs3zFukyku+nSRk4ogSigIVVbnW1RDHF10botbyyW
         SRHPXGxHkAdfNbJS/nPUiL4MvxbcTbIOUAGz/exnZriGx/ZD+CTDytP6+3LcHjEWs0rv
         XVeqwJTufUcMDHkxXhrS5v53nYFNbpVYrwKCGsuyhQQ26AGtQQqYTMmW3uYWv1t9Egkp
         2mmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769002847; x=1769607647;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pPaaLejyMj+/qnEy2gN+yRCN0UmH2KujytP4NRWmWr8=;
        b=DdB8Dg8YIgJbo/Bks8JLIipbF0KRkPqIGaVLipAUzT+FOSGefJ09Ex6kVpYZNP/fLT
         4FVqHizBwM0rC2rgRIgrPMtaVF3Vy3jhOBm21Hyn39mDKNJcgGA61GtndtYFCmrjoucu
         xmeakCmgzOLg/xG6JjJRgawlOxq+Ii453WaVDFlWys6AzLKomIefH+jCA50mmpLiT7Js
         Zbt3q9cUQtj2FEHoDdnbgtSanjYhH4xWVJNsNtJE3arcO1rJ1ulOZhREgiyjSzO0d5kU
         1s8nUl6VZKdpHDGykmdG5Gy0ve5S+Cjl2OFijbvdSaWLnAL3zOGif+ecu+dp7J/PUnHK
         vwng==
X-Forwarded-Encrypted: i=1; AJvYcCWOQkWkFVzdq69wbSGekewv0ke8HVF3QtiLc36G2ZwhmkDVNbYnpcOB7seldVK6NKOnkXaw+ahHZr1sb3c=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5lYbOQFxWV2N6t810BsMhL3Ssuopy3KWdcIdnOS5KQy0/NH7r
	UrVygp21TEroem49No4SAQ5BRMejVsUlp/S1SwLN5eOTf/qwj+HSKywfLxKe2Q==
X-Gm-Gg: AZuq6aI+mS8iYthRg6RkI+3o0vy4WfT1QKVNy/lIz4PKl5UtSheM83wjr39V7OKdjwX
	5nz6Y17rO2iS1pRIvJQiO1qeA3ZYASIyP8aS5EXwG5Xr1deRVZHGzkIzepihzHAVKNRS2hxGi8D
	crK/ZYqJjR5PfW5KbHlqAka41KQdPT4mfiW1Fr3UmpORu6npX/gnnJd888qro8olpjlDT7+qfzy
	cWLllPb8kJFky3MXc5QxCHm0Md46gcorYQSVehUh4sq26kvo2GGpxPcsO/d1PbQQcXc27o1DbyO
	sVJjzjtnd7+Qg22SjbQMANMxo+qAjzeOEeqWi3Hr7RD7uOhwIgtuHAe4NsY5z95YYLyACIBJgUZ
	KD0+5A6uAe14vN1AIkIzlchH0aWfKRSP/9fW0WB+Ri0HPvuwLfccPav8Bl2TR9OtlV0aNFmrpxj
	QmePgVm/Lv4T8=
X-Received: by 2002:a17:90b:4fc2:b0:34e:630c:616c with SMTP id 98e67ed59e1d1-352c4055083mr3706750a91.31.1769002847164;
        Wed, 21 Jan 2026 05:40:47 -0800 (PST)
Received: from inspiron ([111.125.231.221])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-352c114c2absm5238039a91.13.2026.01.21.05.40.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 05:40:46 -0800 (PST)
Date: Wed, 21 Jan 2026 19:10:37 +0530
From: Prithvi <activprithvi@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
	hch@lst.de, jlbec@evilplan.org, linux-fsdevel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev, skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com, khalid@kernel.org,
	syzbot+f6e8174215573a84b797@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] scsi: target: Fix recursive locking in
 __configfs_open_file()
Message-ID: <20260121134037.kh3rfrgmwsylcl5r@inspiron>
References: <20260108191523.303114-1-activprithvi@gmail.com>
 <2f88aa9b-b1c2-4b02-81e8-1c43b982db1b@acm.org>
 <20260119185049.mvcjjntdkmtdk4je@inspiron>
 <ac604919-1620-4fea-9401-869fd15f3533@acm.org>
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac604919-1620-4fea-9401-869fd15f3533@acm.org>

On Tue, Jan 20, 2026 at 05:48:16AM -0800, Bart Van Assche wrote:
> On 1/19/26 10:50 AM, Prithvi wrote:
> >   Possible unsafe locking scenario:
> > 
> >         CPU0
> >         ----
> >    lock(&p->frag_sem);
> >    lock(&p->frag_sem);
> The least intrusive way to suppress this type of lockdep complaints is
> by using lockdep_register_key() and lockdep_unregister_key().
> 
> Thanks,
> 
> Bart.

Sure. I will make v2 patch for the same.

Thanks,
Prithvi
