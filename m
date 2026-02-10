Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE533815E4
	for <target-devel@vger.kernel.org>; Tue, 10 Feb 2026 15:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770735615; cv=none; b=BaJDl7LEPXBz6tn4K1g2hevifS10wlvQz8HWwGjlUkXAGCz9w7PnQ7v/Yr6eRWkuYfUKL1T9yrwde0fQZpOP21ra9gOLW9+mmtWNEV5MYslCc8ZzEUZ2GoZbMlxREt73p16S9MgAzNBdxC76rYekrOsX29PTLCEp5eqAvmlve2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770735615; c=relaxed/simple;
	bh=P5N4ABjZx124VekI186qd2AD4yXfKDQt9Vo1Fag6vHg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aS3OS6kz7VJ3EfC3MSKPDcKcXWkzazsW0Q4E7qOXv/bdAY4M/8aV6qytP7otqZLLUenn32sV/Ru1ozUyQaiSBFZZzjr+q/DfWJKwIEbBPw22TbN0+IK2TYCc//4i4cvuh3yAU66LrknMaxCrhOViU9+o2FRlTIObi1/z6+0BZJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gFoRBQUK; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gFoRBQUK"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2aae4816912so16636915ad.2
        for <target-devel@vger.kernel.org>; Tue, 10 Feb 2026 07:00:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770735614; x=1771340414; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=v436SyFigxsHrmhj471D+104SnMzTMwy4MIHa73zImY=;
        b=gFoRBQUKg+Jbo78iDrELjJ0UCZCUblkzS9MxRPdPYY/sbzRniiq1YIPrnkjYGTzhe/
         22vgvcKY9UueLO/JyQz19mU9CeAdK05ffCOZyY2NXjSSm9wQ6j1P3zvo4pjttVaYo9bJ
         8NYcXQQTnYonQTIlzzRdwR3DHf8b1HIS+cvuWnXROFtqohoGlfkmfQHL52rr0It3rXsp
         ILYBHiGc9WK0eIJMjup0tl3t90UmZ0msyQAAtcrZN26Wh4cBlyvoff/bZhCQ+eoIKTI7
         sdqK3T9oqX4LaxhgNT9KrmcFAFudrlMSOEmRylnCa6AzZvWcMHmd82YrdsAHkIrfjNm/
         I97Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770735614; x=1771340414;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v436SyFigxsHrmhj471D+104SnMzTMwy4MIHa73zImY=;
        b=CqVoqhsoeiQxV+oWXbH1Mzy54l+6O/g2XsNyxIxuEvcHuHoF+qL3em3SHQLIwFsetq
         xoiH3my3O5yB9EGhyuIZontd3QLEg27FvaqhiPf7z+y2cuS8Ww1bPxxbqWRXa3zuhFDe
         +EQsGj7qm6g14XZZ+kOhcCbvCbimwcRpwgbFdMCA2fZFB7ENf5aqTtGtBf9F/2bxZLhi
         QTUEQSrK7lO/IiqfgXo9TodOGVEXMx8CTouOyx63CXn6sUoewowGiyDwAPI7ZrpjYWB6
         fOxml+UcIDzqF+/mYvPsPp0McqEaXEXnTfISvI+wO8OM8n8FJyBiiQlDmvgNTTlYIXZ1
         jMSw==
X-Forwarded-Encrypted: i=1; AJvYcCWBcsXxpHiGe29OnqXQsgVQzPp3p/SSk0nRIkzN4XVq4kkBA0D46gj3CxXqLTEzQKYjSJv43yvTyy15jcQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYOh/hOvlqIt5w4gim72sLgJ1DztY3YcUynv3lYulkjgPzTBKT
	13VYHcM+1Ko65c7oZ34JJitzXD/rWkPOXii60/rya5La9KzCDeTzKfUR
X-Gm-Gg: AZuq6aLV3w6RepMdPZIQlMhanuhyfQYWCP5+gcPzP4BSG3edgkTezVnXtltiJ1c48Kv
	+22xCpyoO4ql5PD74se2bZyZS1AS1q00mihgEU2eZ7JFw0ui6/m43/tXEmdRSGV9hGBDQPdIiDf
	HatwYQjF26Pz5jgaqRjPPeZwNG7KeTY20t9W4DWii2jWh7yS/3qNkgHQzKHTlzHOPyrWgtvGwRR
	7H3STAuTlUz/luPmWPGL8vjJ+Ee54CTIDu4cxCq18MAi3lANZBrlz9vJG5LqEWYqIoaabuY7MzR
	D4i7PlZkAWIzo0g7CUqYKR1UEpHPlMLWWQLoAGErI0gs/MliZzebcGMoUBFQlQmsVPJA+rIWu8o
	s8y0CyhaIhP9iqf9W0eZujWlbwj5qZ//giKQP4M3ooOdV6FNQNug3yrDvF8VTE04iCu6Gs3M3CY
	C05yGn7llbKnXWXN41fsy15O/xJajHkfbnTg==
X-Received: by 2002:a17:902:e742:b0:2a0:d629:9035 with SMTP id d9443c01a7336-2a951643629mr163927435ad.3.1770735613704;
        Tue, 10 Feb 2026 07:00:13 -0800 (PST)
Received: from inspiron ([111.125.237.190])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aa3ec42e2asm149045835ad.53.2026.02.10.07.00.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Feb 2026 07:00:13 -0800 (PST)
Date: Tue, 10 Feb 2026 20:30:03 +0530
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
Message-ID: <20260210150003.s55mbwdpgbamjtso@inspiron>
References: <20260205162624.117957-1-activprithvi@gmail.com>
 <20260205192644.GT3183987@ZenIV>
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260205192644.GT3183987@ZenIV>

On Thu, Feb 05, 2026 at 07:26:44PM +0000, Al Viro wrote:
> On Thu, Feb 05, 2026 at 09:56:24PM +0530, Prithvi Tambewagh wrote:
> 
> > +	r = kern_path(db_root_stage, LOOKUP_FOLLOW, &path);
> > +	if (r) {
> >  		pr_err("db_root: cannot open: %s\n", db_root_stage);
> >  		goto unlock;
> >  	}
> > -	if (!S_ISDIR(file_inode(fp)->i_mode)) {
> > -		filp_close(fp, NULL);
> > +	if (!d_is_dir(path.dentry)) {
> > +		path_put(&path);
> >  		pr_err("db_root: not a directory: %s\n", db_root_stage);
> > +		r = -ENOTDIR;
> >  		goto unlock;
> >  	}
> > -	filp_close(fp, NULL);
> > +	path_put(&path);
> 
> Just pass it LOOKUP_FOLLOW | LOOKUP_DIRECTORY and be done with the manual
> "is it a directory" tests in any form...

Hello Al,

I sincerely apologise for the delayed response. I was testing the change you 
suggested, however, whenever I tried testing my patch against the latest 
commit where syzbot reported this bug (commit 3a8660878839faadb4f1a6dd72c3179c1df56787
of upstream repository) it gave me a build failure immediately without any
debug log, just the message:

syzbot tried to test the proposed patch but the build/boot failed:

failed to run ["make" "KERNELVERSION=syzkaller" "KERNELRELEASE=syzkaller" "LOCALVERSION=-syzkaller" "-j" "48" "ARCH=x86_64" "bzImage"]: exit status 2

The issue seems to occur multiple times when a patch is tested against the 
latest commit where syzbot reported the issue while it doesn't occur on that 
latest commit of the upstream repository.

However, testing the change on the latest commit of upstream reprository 
(commit 72c395024dac5e215136cbff793455f065603b06) gives a positive result 
that the reproducer doesn't trigger any issue.

Reference: https://lore.kernel.org/all/6767d8ea.050a0220.226966.0021.GAE@google.com/T/#mbf32aeb54c4cae609d3b6176ad8dcd99bfc51ad2

IIUC, since the reported failure appears to be unrelated to the change and is working
successfully on latest commit of upstream, I wanted to confirm if v4 based on 
these findings is acceptable.

What do you think?

Thank you,
Prithvi 
