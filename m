Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E3A341055
	for <target-devel@vger.kernel.org>; Wed, 21 Jan 2026 17:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769017910; cv=none; b=cPOmZDsSJDmedwLofq6fCaqekp+ZPPZ+g389a2yRMQV2juth3bBnE2tQQDlcYZvO5SMjqD8BGAMCDIhpVLLrNPevQQLEleexDjXDLyTdp0vZdn+GwYPN2U+ZPWLrWyHm0N+cP8VQ3mVBMLwiWFKcxWn/FYIWCIlJV8j2AvDrVE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769017910; c=relaxed/simple;
	bh=1qYGgZ9c1b8r3u+ifdHQSBBS7lpLzGEKtldRnalLi6U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pjwdDS082bvzrVAhGm2t05y1wHccNgg9MCz4W4AtK4oi7iSg9wEBMY8L8olmtnoLBVuyojX88OW6aqDbwQ7DAHMAnO858wU8Qj70ccVcvWbTh63/+KOsGxQ6Dgz6+GMCSOz/+Vb7JgG0D6gFqwM7I9pTTIvMFi2nIm54QxuvIUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WO/y8HoN; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WO/y8HoN"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-81f3b4ae67bso111102b3a.1
        for <target-devel@vger.kernel.org>; Wed, 21 Jan 2026 09:51:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769017906; x=1769622706; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xSB1wkD3tnNMvDpX/kYDMDj0XcHDa2KakGtOpJoZJvw=;
        b=WO/y8HoN8++LvTXEnlN+3f5gDWDSUm8n+DL3HU2hv1uCQUVaUdkpBB4z1GNQlcQl89
         xX12P/wt4OkuQrJcLbmZZr5Krf3FNaFOeWBVe8WzXf+88X0Z9D/Qn8Wi/FsUSl+z3t7y
         UDaLZ7U5BZDTEg6zkRlas4v1eWL+rBltX/WyU5FLSK18ZAhaYG+IKyL7o3N9Eg6PzR9I
         17Rdkl0uBp20uoqz4j07jCD47tgZU8AwJ1AE2EZOKC8gKSX+P3Vj0Tk7BB70mDF1Tz/o
         GhWiLfWWwxXI625dlz727yNxEacK+wlu1lQH3NcUfqF6zIlyxgXkUI1e1rbA0MeaQpcw
         0QFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769017906; x=1769622706;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xSB1wkD3tnNMvDpX/kYDMDj0XcHDa2KakGtOpJoZJvw=;
        b=WSHsA/ouahbZvPy0tqGm8C0N9IYLmgIdaLOGaXJjsNgVoKBiEIuziqW83bkEfpvUuJ
         tvz619xnMCwE7kZabok8su0ZTBkvflEENY21LJAH1GeOS02FJ0sxjYZpNlZHRABiPV5+
         TwwLpWrJoOKfi+5VZ+NAgApLaZMT1YRaKWb+Gl6fi40irA4BIg+8q6odioF1lm4T8asw
         529V+Vxtd2M6KaTtVCPl6mwIx9msXJt0oYiuhldeABG2tbABKrggTjycglF1OQog0ZJU
         1SMF9Q/nnnaUIvs3v3OXX4wwrvIVcmZqArJFiJFPHs4pV5hh+ogJR/Ou/9vgCowBW01y
         yY1Q==
X-Forwarded-Encrypted: i=1; AJvYcCV1zpdrz/6rfuetBI3gAI5toHxPQKWMsdqCuUPGZ1VEVXHzKPqvflfRRrP8j0pAUhzD8EEEHSBwGkdI5dQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyzK46YfNuRxXnf6DO4ejWDiaR7Ab9noLc9yhoDNoq49OlUhWzg
	1cSspffPos4+nVjCaYd7odG5e6oeXhvmqn/u2t4usrFMEAYY2PxV43Wn
X-Gm-Gg: AZuq6aLd9efRS5oi/0zgnR+oI4VDQK4wPGaIBiQW4vdtYfFbfgGfGum8pv/FP6Nq3Ip
	paqbT28KnxtF23R4h8R+7KGO0zZtElvM4qE39CtSza7P6ETJj6O0hCjhpDUXcENjTFb6rbd9yRu
	8WPW8A5cWtRZF+72o2/+8UkrZn3QXvAV6qNjVupRYMU3fYtq9GD1RUtjzv5EbkTa5bjgx1FYa0O
	FTlxs/n7tCPqJ2wRkXEnPicIDfGzwHf6Fdfdo0kDJw91b5uJNWTlSk2WKNBFlE2HMcLLwBmc4dr
	hlJBF8C4DGQ1SEAufqYy2ZgFvwPvYxtfm5wkQYZFXY9B6lAnXlAb3/rQ8/STNCLpHRDAI9xksSj
	YOTKM7RqKgOvAZ+s54RXUrf08C4nCS8+PKjoOAxYoSv1f61X9Ve7SRQe3kHAU6+Tw+7w2WPBDb5
	QKjSVH/kN+okU=
X-Received: by 2002:a05:6a00:8d2:b0:81e:408e:47c9 with SMTP id d2e1a72fcca58-81f9f69002amr15459101b3a.11.1769017906237;
        Wed, 21 Jan 2026 09:51:46 -0800 (PST)
Received: from inspiron ([111.125.231.221])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-81fddd12fcasm7382081b3a.0.2026.01.21.09.51.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 09:51:45 -0800 (PST)
Date: Wed, 21 Jan 2026 23:21:36 +0530
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
Message-ID: <20260121175136.2ku57xskhwwg7syz@inspiron>
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

Hello Bart,

I tried using lockdep_register_key() and lockdep_unregister_key() for the
frag_sem lock, however it stil gives the possible recursive locking
warning. Here is the patch and the bug report from its test:

https://lore.kernel.org/all/6767d8ea.050a0220.226966.0021.GAE@google.com/T/#m3203ceddf3423b7116ba9225d182771608f93a6f

Would using down_read_nested() and subclasses be a better option here?

I also checked out some documentation regarding it and learnt that to use
the _nested() form, the hierarchy among the locks should be mapped
accurately; however, IIUC, there isn't any hierarchy between the locks in
this case, is this right?

Apologies if I am missing something obvious here, and thanks for your 
time and guidance.

Best Regards,
Prithvi
