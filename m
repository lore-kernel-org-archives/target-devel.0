Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E0735504B
	for <target-devel@vger.kernel.org>; Wed, 21 Jan 2026 18:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769018908; cv=none; b=tzOdDGBOzr9V/+rvhiZNlWzLA50AlTF06VTX72YUXXxRVFP2bWv4YojRdELdeVQ2UaqXCV0KZ3IEwnWMDGGJcFDuhTukns/KHnQTNw7vxGnV2Wg1cEu//aU91nYAK0HcnWybVUHiQn65NjxwqwqbEFB4bo3OEOZm2mYvSH+Mh2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769018908; c=relaxed/simple;
	bh=vVxmaTN6DfAQMnybaHcGPQ0UAXYghYLqHrfg83IBi0g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u+Ij3LDSCzir82N94Gb1u28fVUIXDGjbdszwMcUzenwlSOFkgVD7SvdgkmyEHwz8odTlU9fxWWTkd4AHqrlAgl0pDxPLuGhuKHpaOqGs59OtgW6R66eRcD4NqrCjEnHxOfGWZDBxD9qhdETZHJVvXWunXCi1Dxyh6xdAH0KtS0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K9WJEoN5; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K9WJEoN5"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2a743050256so608525ad.3
        for <target-devel@vger.kernel.org>; Wed, 21 Jan 2026 10:08:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769018905; x=1769623705; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=72auvTTn3y/RhhBaaOjOnqHUYFhZMWqSD++rNQfrdXE=;
        b=K9WJEoN5XiF/8kURq1xAFdXXaYeHiUMKlFRahBUe6BqLlf7iR6B/RJcSwlBvlEcwzp
         xlBnFcr5xeSJgaWFzxcR2BC/65DHVIAl3WAIAM9k6mE3u2BIkvUDBnTksJFRC6SLRdgV
         bjZXrQ/JgOk9pR0aJW39Mm3z2Nl3XhiAHi8LVkxeYP+zDIBStH/T36zWiCBRJGxY2SqV
         kWG5Ctyi4M+sCn7c3sd12GtgCvB1dfk04epE/QOYXIk6/mxa9UBjbtEallporwuQeugf
         6kcbxoaLN3E+EXVHjHaLgJko14vIEw1pDOVC0CBqjxTdrAsoJbFVjmtRuy4slh6BG0eH
         +6Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769018905; x=1769623705;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=72auvTTn3y/RhhBaaOjOnqHUYFhZMWqSD++rNQfrdXE=;
        b=YylyUKenaJ+HC4/gQZ/SYGjEXnBqIAYnm+vZoWYUU6yphDqt7BTl21TdMVlhaxzepT
         fQPZxcIztArl4y4ggmxjBYxcvBDxkXfYVXtQLadC9l1avgHBY8yt3hr8MnrSf85q/Moq
         p5H+Sw0vicSa5ZdydRCNxyuKlksdTjNWC0OkPsASDqzRtjj5N91Rd2JYg2cjYwOBGM5W
         xGyTdrqmZBzfzpWWf5h0mAFOns+uykeLQAoc0A93ni6uDz2nrTKwDYl5Arsfixz+nTwV
         8Ug/wdP7WD2cGVcPV9UFdkuK0fmhLHAWumEDsI8Oj2Klir0m+nj9bSpBANTbmomMk2Y6
         XEvg==
X-Forwarded-Encrypted: i=1; AJvYcCWqzeRNPZ/jmSpJHiPKcKDdL5HmaCyIQ3or7ttRR9YmRh3TYaRGpD4QHfMtdmJAEXr5LQLVdBNdvxiMlqs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxTri9qKkPwvIh3EjxE03lzdCcuEeqEmBTvKRfgoMoRRf48Dii9
	AkHyS/TyL7Oy+ZTuAWwTCvY0WnskSlevk/oyAdR7hBCkLRG9rkfyUXvL
X-Gm-Gg: AZuq6aLxk4Yey1yIZy1YkaZ/Of9kxcmrap7YXg01YgynqDkUwweewX65KHebX924+44
	znFAlFEnmFBEHKKUnIwT+6A6MaAimg1+w4hSp+N0+92WKiaR2U1qny3kstpnv51DeFxS9tkA/H7
	e7FXA29Tw2/GJ1aRi8Mv/54zrf4/h1r8YD59jf99w/1FAyLIhsmDESApGiLPjmFmkM3MzxtBz29
	mczXtgauVVWoFNGACXhQZoEa/anU+KxBVuYJ5YYm6iF2bRxLAP/0LCLiV6FBK8SQzmV16Z/njoV
	fLM7i2ngBROsr9z0k8td1Zp3DYB7khd5sRMBiTqjLU04fDN4WADgfQ/hdg2smKaGwiv2tBS9KAC
	mNsRrpG/zPeZPWAsYABSHDQHwHKZTpNXrQ+aNb1zKmwVVrwfGl33FGyJW+8b/24QxWBtKm9fs73
	CNU1d6CTZZdic=
X-Received: by 2002:a17:903:22ce:b0:2a3:e7fe:646e with SMTP id d9443c01a7336-2a768a7e6e7mr60039705ad.5.1769018905199;
        Wed, 21 Jan 2026 10:08:25 -0800 (PST)
Received: from inspiron ([111.125.231.221])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a719406505sm157012105ad.84.2026.01.21.10.08.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 10:08:24 -0800 (PST)
Date: Wed, 21 Jan 2026 23:38:15 +0530
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
Message-ID: <20260121180815.usbtlsqxqdgriqqs@inspiron>
References: <20260108191523.303114-1-activprithvi@gmail.com>
 <2f88aa9b-b1c2-4b02-81e8-1c43b982db1b@acm.org>
 <20260119185049.mvcjjntdkmtdk4je@inspiron>
 <ac604919-1620-4fea-9401-869fd15f3533@acm.org>
 <20260121175136.2ku57xskhwwg7syz@inspiron>
 <6927d0f7-5bf5-4035-b1c2-50f3edae4b7f@acm.org>
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6927d0f7-5bf5-4035-b1c2-50f3edae4b7f@acm.org>

On Wed, Jan 21, 2026 at 09:59:49AM -0800, Bart Van Assche wrote:
> On 1/21/26 9:51 AM, Prithvi wrote:
> > I tried using lockdep_register_key() and lockdep_unregister_key() for the
> > frag_sem lock, however it stil gives the possible recursive locking
> > warning. Here is the patch and the bug report from its test:
> > 
> > https://lore.kernel.org/all/6767d8ea.050a0220.226966.0021.GAE@google.com/T/#m3203ceddf3423b7116ba9225d182771608f93a6f
> > 
> > Would using down_read_nested() and subclasses be a better option here?
> > 
> > I also checked out some documentation regarding it and learnt that to use
> > the _nested() form, the hierarchy among the locks should be mapped
> > accurately; however, IIUC, there isn't any hierarchy between the locks in
> > this case, is this right?
> > 
> > Apologies if I am missing something obvious here, and thanks for your
> > time and guidance.
> 
> This is unexpected. Please ask help from someone who is familiar with VFS
> internals. I'm not familiar with these internals.
> 
> Thanks,
> 
> Bart.

Sure, no problem...thank you very much for your time and guidance :)

Best regards,
Prithvi
