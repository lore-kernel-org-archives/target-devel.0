Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D686E2EBBB7
	for <target-devel@vger.kernel.org>; Mon, 16 Feb 2026 05:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771221281; cv=none; b=AuUb5jMRoXH+eTbKMG272nwlidlPE420iYoe6KqbslxaxRtGQZiSEb30zpMExnb/BoFaUBLSJHwzjk5sgfg2N0VM/Fx4tvyABJUIdYCW618XixYwTNMX7FcuIkA0u+adqIpWKzPjMUbaotabpFWNJQB7UsjTpD0gHc/gpASSzJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771221281; c=relaxed/simple;
	bh=SjHdNqg/sXBWS1+UD7F6sYwEnZg7Kd+rR0ZVIvXV3uY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YyskSAt6Z50pxhuRdiG7/sygjT6yt1Sz/DKKPt5Jvfw6cfUWKfdOgrQIUauULyDePsBRzl/5Ij0zYEhopxoKXysQExqfaEA3FhB4AEd9i1bmHdFLq6bIpdC1wBdti2lcltqrA8xf19M0YRUsrxI5DyFI8RcUURXVt4LGtO5P3M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EOga8Gxt; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EOga8Gxt"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-823210d1d8eso1344271b3a.1
        for <target-devel@vger.kernel.org>; Sun, 15 Feb 2026 21:54:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771221280; x=1771826080; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qC3qOJwn2Egn3pO4hpRHwOWWG7H3KZpCaBuiI05D8gI=;
        b=EOga8GxtpqO20rytk3ppquKv7gBddA9QHBfKchByhZVR7rLWsorHg1qour4mQJj/7W
         o4AKdi2/BB8risO8J3JNH0hQj6jwjfs76FVxp3uTkVFQJgt2WW41gosj3urdojkSJUl1
         7HuSrTSpKEdYuky2v+uUEeZnLBvip4Q3itQEvJqbsJMj3dgcBw1z1ooaPlphw+VfHJ8u
         wqpZqoXksZF4fvqzNCXPKIrKphlWsgJbOe2tq/8kUn1mhrSVfnDVM5RULEBhg/rsiROE
         5J2J4lT01t0tkQ55+J0dRBzu8cmI71RGCm5HMT8F/CHQSDPtoPVp18F+Ups1TpNNye7S
         +RtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771221280; x=1771826080;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qC3qOJwn2Egn3pO4hpRHwOWWG7H3KZpCaBuiI05D8gI=;
        b=LR+NAndJUall1jaNts5aeoT0jK4fa0YatyhILs8nAUYIB/qXwm68tVvMJnawPU+giO
         +v8hKc7PJBIUC89T9Aou74gvh2N+Xy+yYuS0rcMEZ6W8yv46OOato052TcdBwWJ4/roG
         JXoOgzF6YwCMlCIXLfr2BlFVPyJK07v8G/c6DXCEa8GSASN66hbi8S6FP9yM386d/VP3
         CAHkNCc4zBIFf5EM08aGrzNoGI91UmBYaRKm9V0dlSfhgpu+Yjgu1xBmDP9kghUvRRfL
         3a3vZC1x7isRm5V4DQUgMTI0v7f+QRIpZHe07OO/zoDHOgCWVKwJXajVU3Y5Qw+uHany
         36Eg==
X-Forwarded-Encrypted: i=1; AJvYcCX6eN0F2bwCuLA6kT/j8MpZHErmZ5o9yNVVNatX/I43e+2VgLsFdtL/a77gP5wtdxMCtzT+gou66H64HJM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQJjC7QI6nlydMFZieGTA8WiDPpYmSvX78lRxeNo9yZ27a/wAp
	xPkf0pIPx7ScEge7fgnnpi8CTmVEf0jPOt0dkmCcfAy5Ch3nX8+3nciS
X-Gm-Gg: AZuq6aKxVwdxZvtzKvdMbOzs2G+bgoXW01DSPWbauAws/1Bl4Qr2EeRRy8felBRUE7r
	eb//kpx8Z3CMEzLTcQZvqpfZD6XuRsodCGSYYuxy6XL2LXKq6XiTjYOEtDzw2KaqM/mGboEv9Zq
	9ullrX3QSyJtwm/PYr+6uBiyyepxwOFvYaGW3ZCLAW4cim6uRRdiWNNwFrzc5diaq/w9N3nJi0I
	sLtyvVBemdnWebb2i41+gkHg0FClw/FF06XJyI3SneJNnqbk5uquSGLRub4cHjFoknKuBl8/YNY
	46COd6RqUNn1XKjJpv6JLAHM9uOUoy32Dj6UjiXBOp6VM9nX8ny/BK2+6DvlL6vcrdWxUk1zUy8
	KeuIrz2qXykALs1Lqggzp2dYMBc+Ck5EF08oCX6/w0JI+cCIMTTY2NGSbzNuTrKgd4cvBM6jfoR
	4eInWhax+8Ckjf6pWyR83l
X-Received: by 2002:a05:6a21:9d91:b0:38d:e87c:48b3 with SMTP id adf61e73a8af0-3948376c10emr5725741637.2.1771221280238;
        Sun, 15 Feb 2026 21:54:40 -0800 (PST)
Received: from inspiron ([114.79.136.20])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1a713675sm75682935ad.27.2026.02.15.21.54.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Feb 2026 21:54:39 -0800 (PST)
Date: Mon, 16 Feb 2026 11:24:32 +0530
From: Prithvi <activprithvi@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: martin.petersen@oracle.com, d.bogdanov@yadro.com, bvanassche@acm.org,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org, david.hunter.linux@gmail.com,
	khalid@kernel.org,
	syzbot+f6e8174215573a84b797@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v3] scsi: target: fix recursive locking in
 __configfs_open_file()
Message-ID: <20260216055432.lf5n4h7tbzwgugwk@inspiron>
References: <20260205162624.117957-1-activprithvi@gmail.com>
 <20260205192644.GT3183987@ZenIV>
 <20260210150003.s55mbwdpgbamjtso@inspiron>
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260210150003.s55mbwdpgbamjtso@inspiron>

On Tue, Feb 10, 2026 at 08:30:14PM +0530, Prithvi wrote:
> On Thu, Feb 05, 2026 at 07:26:44PM +0000, Al Viro wrote:
> > On Thu, Feb 05, 2026 at 09:56:24PM +0530, Prithvi Tambewagh wrote:
> > 
> > > +	r = kern_path(db_root_stage, LOOKUP_FOLLOW, &path);
> > > +	if (r) {
> > >  		pr_err("db_root: cannot open: %s\n", db_root_stage);
> > >  		goto unlock;
> > >  	}
> > > -	if (!S_ISDIR(file_inode(fp)->i_mode)) {
> > > -		filp_close(fp, NULL);
> > > +	if (!d_is_dir(path.dentry)) {
> > > +		path_put(&path);
> > >  		pr_err("db_root: not a directory: %s\n", db_root_stage);
> > > +		r = -ENOTDIR;
> > >  		goto unlock;
> > >  	}
> > > -	filp_close(fp, NULL);
> > > +	path_put(&path);
> > 
> > Just pass it LOOKUP_FOLLOW | LOOKUP_DIRECTORY and be done with the manual
> > "is it a directory" tests in any form...
> 
> Hello Al,
> 
> I sincerely apologise for the delayed response. I was testing the change you 
> suggested, however, whenever I tried testing my patch against the latest 
> commit where syzbot reported this bug (commit 3a8660878839faadb4f1a6dd72c3179c1df56787
> of upstream repository) it gave me a build failure immediately without any
> debug log, just the message:
> 
> syzbot tried to test the proposed patch but the build/boot failed:
> 
> failed to run ["make" "KERNELVERSION=syzkaller" "KERNELRELEASE=syzkaller" "LOCALVERSION=-syzkaller" "-j" "48" "ARCH=x86_64" "bzImage"]: exit status 2
> 
> The issue seems to occur multiple times when a patch is tested against the 
> latest commit where syzbot reported the issue while it doesn't occur on that 
> latest commit of the upstream repository.
> 
> However, testing the change on the latest commit of upstream reprository 
> (commit 72c395024dac5e215136cbff793455f065603b06) gives a positive result 
> that the reproducer doesn't trigger any issue.
> 
> Reference: https://lore.kernel.org/all/6767d8ea.050a0220.226966.0021.GAE@google.com/T/#mbf32aeb54c4cae609d3b6176ad8dcd99bfc51ad2
> 
> IIUC, since the reported failure appears to be unrelated to the change and is working
> successfully on latest commit of upstream, I wanted to confirm if v4 based on 
> these findings is acceptable.
> 
> What do you think?
> 
> Thank you,
> Prithvi 

Hello Al, 

I checked out and found that when I try to test on commit 3a8660878839faadb4f1a6dd72c3179c1df56787
syzbot uses, in its kernel config:

CONFIG_CC_VERSION_TEXT="gcc (Debian 12.2.0-14+deb12u1) 12.2.0"

Ref: https://syzkaller.appspot.com/x/.config?x=e854293d7f44b5a5

While when I do #syz test (i.e. on HEAD commit of upstream) it uses, in
its kernel config:

CONFIG_CC_VERSION_TEXT="gcc (Debian 14.2.0-19) 14.2.0"

Ref: https://syzkaller.appspot.com/x/.config?x=99ac58566e9eb044

However in both cases it uses:

gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44

Probably due to mismatch in compiler version which syzbot actually uses and 
whats present in kernel config, the build fails for the first case. However, 
the patch succeeds in fixing the bug in second case.

Hence, I think it would be appropriate to send v4 patch, incorporating your 
feedback for v3 patch.

Thanks,
Prithvi
