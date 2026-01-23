Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91FE733555B
	for <target-devel@vger.kernel.org>; Fri, 23 Jan 2026 14:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769180308; cv=none; b=OPgiGNinv3WXcOr2+5nOGxn6xhpwOHJHeb4prllYBFGxvDlbHjvzUfb1Hn/p+rZZDiDaRw+BZ0BxKVTLHvv+BdBiLdsrfoqHnPgmMLZ2zlPWSDFoq90WsKCDnhHRgyYY7C7oQhkpzTWz3dLtZMUwXTNE806hZ9wkbLO5qS4Qc4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769180308; c=relaxed/simple;
	bh=yLzY19MuS3iN380+AoG930YPzVQx3y4RwEr4smOpjaQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OkOfHClxJkNhHF0egS+bTJlL3yjMTegRtMTZnyb8sD/1kM+56W+h65aVD50oTICS7rxeJvbWKlYwIu6FM28X6G/rcJkEsVzFnO7gmd/k2XY4AM9RwnVod2imFP6KKGWPWCAN/pCalaYic1sxpE6ZCrFDdNx6z/7fQiqDWdBWvPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E03gqZWO; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E03gqZWO"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-8231061d234so1693077b3a.1
        for <target-devel@vger.kernel.org>; Fri, 23 Jan 2026 06:58:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769180306; x=1769785106; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eEedmtOY7Y8eJ9xgbPCCWxatDC0k0Q8serp7IKoqpeM=;
        b=E03gqZWOFHV3q/QQn+Zg2MgCO0R4louQSem3MkoQbOTGUL4ZT/EziRRSowEbQN6H/p
         aUNsW2+IbwA0Q3G7kYkJO2679gs98qiGwCy8AU7TIQ5J42HcAr8/uZYDHlMDgLJwgSdM
         t3drZyVjo4hbGG5tGlmZSsT/K3OVgs4pZlSLZDlzAeMh0DR+3zB0YArA7v8/Q3NaSyAy
         wIDi7QDlO6uWxeXZkfZRTsSGBs2RTiThdFdUop9xefCTEC49ZW3/39gKcxojKAyTL+j+
         3N0sdIGy0CLWJsN/lt9XyzbUYpBuZFhrQCoPRUSFmVU2oozpDmWtVu7NxJU28n00sLff
         GgAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769180306; x=1769785106;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eEedmtOY7Y8eJ9xgbPCCWxatDC0k0Q8serp7IKoqpeM=;
        b=Ao6l+SMJRy9M7N+Sy22Kyp8ZqJxdMeN7QtK3LnByHZqcqg3feu3v4NYcUQ0p8bXMon
         IzhNn5aqsmG/rFkrnxYsQA6F/SRCyW7fvnEG1+M5p164uXvKP6ZYdmWdG+inlEdyxtFz
         Ez+g59/Dpu+QHrznI+EKYBvmeEMDmxL4R5RVOemODG5fx7vfpsn5wQveNgaeQMEQBvGW
         W6Jf4jiiScmCfMK+OkGlxw8fl3JiZEgrPzmXO2bHU0u4Tn2bmbBP5JEpPF01C5HEF9JO
         v4ixqDirrmpOI7vyiM0CiNUHFggm4meGMfaa3JoxWHM6i3/bXQPI7ewt/kkMbEtYnPC/
         ZipQ==
X-Forwarded-Encrypted: i=1; AJvYcCUgr+uRHgoMXgjTuLjhDm6k+fTUEihVbdDq8OSAkpwnHebKJC+iAOybBvuuwfCn5p6dmCRg4acfEnHOqUU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz76i51VrkSNz0yZJJ9d9QSO+bKPBWXiglJXKJlVMvTpMHJFtJ6
	RIFNm8Fwwj9a0Fd+PwoTJHeh/UGfwlO8RrsUW0VRzRcJcMGZiKU+Bf/i
X-Gm-Gg: AZuq6aLISw8ixFISxN3oWPhPPW2FoA+4FiAJ8LcRL1TX/bzlH+YpZozy+KdJ8WrA+De
	DLl2XD56zhwn7wNbHzNrYnFbITcXC+m3s/dkmRpkPr9wpb8hi4SC7DkJyC3O9iPzHk+eDm9Qjqt
	c9uo86jvTZ3eTx8eJ++B+ghbnne4vFRexBCBNdLOf4m3KhYifBOqwksSpxxH5Xn7/6U31Ny2sQ+
	p0I3+F7mYQ3Mo6+/d7nPY2oX/boTiUuOZzXtGQV53sq5chD5RtYld8p+WzXUTNYe1cNG9+cKwYf
	xOgoGtvM9zgxMFc8DpIt63Ys+w0QyMcCaEOm+6CN45DievZWPLReu8BxruQxeSTINdk8d0xqLCa
	rsb7xf4+6aeQOq+2E99Yee1mdK6usxCQMJG8QJZa9w9VCRBxqBre1ME0RbBJcAT5IAh21V476WX
	BCufbkCtO2PWs=
X-Received: by 2002:a05:6a21:3944:b0:366:14b0:1a41 with SMTP id adf61e73a8af0-38e6f8297c7mr3334491637.79.1769180305734;
        Fri, 23 Jan 2026 06:58:25 -0800 (PST)
Received: from inspiron ([111.125.231.221])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c635a42e8ecsm2290372a12.32.2026.01.23.06.58.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jan 2026 06:58:25 -0800 (PST)
Date: Fri, 23 Jan 2026 20:28:13 +0530
From: Prithvi <activprithvi@gmail.com>
To: Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
	hch@lst.de, jlbec@evilplan.org, linux-fsdevel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev, skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com, khalid@kernel.org,
	syzbot+f6e8174215573a84b797@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] scsi: target: Fix recursive locking in
 __configfs_open_file()
Message-ID: <20260123145813.wamnt62fwh2ihtur@inspiron>
References: <20260108191523.303114-1-activprithvi@gmail.com>
 <20260115032012.yb5ylmumcirrmsbr@inspiron>
 <20260122095634.GA15012@yadro.com>
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122095634.GA15012@yadro.com>

On Thu, Jan 22, 2026 at 12:56:34PM +0300, Dmitry Bogdanov wrote:
> On Thu, Jan 15, 2026 at 08:50:12AM +0530, Prithvi wrote:
> > 
> > On Fri, Jan 09, 2026 at 12:45:23AM +0530, Prithvi Tambewagh wrote:
> > > In flush_write_buffer, &p->frag_sem is acquired and then the loaded store
> > > function is called, which, here, is target_core_item_dbroot_store().
> > > This function called filp_open(), following which these functions were
> > > called (in reverse order), according to the call trace:
> > >
> > > down_read
> > > __configfs_open_file
> > > do_dentry_open
> > > vfs_open
> > > do_open
> > > path_openat
> > > do_filp_open
> > > file_open_name
> > > filp_open
> > > target_core_item_dbroot_store
> > > flush_write_buffer
> > > configfs_write_iter
> > >
> > > Hence ultimately, __configfs_open_file() was called, indirectly by
> > > target_core_item_dbroot_store(), and it also attempted to acquire
> > > &p->frag_sem, which was already held by the same thread, acquired earlier
> > > in flush_write_buffer. This poses a possibility of recursive locking,
> > > which triggers the lockdep warning.
> > >
> > > Fix this by modifying target_core_item_dbroot_store() to use kern_path()
> > > instead of filp_open() to avoid opening the file using filesystem-specific
> > > function __configfs_open_file(), and further modifying it to make this
> > > fix compatible.
> > >
> > > Reported-by: syzbot+f6e8174215573a84b797@syzkaller.appspotmail.com
> > > Closes: https://syzkaller.appspot.com/bug?extid=f6e8174215573a84b797
> > > Tested-by: syzbot+f6e8174215573a84b797@syzkaller.appspotmail.com
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
> > > ---
> > >  drivers/target/target_core_configfs.c | 13 +++++++------
> > >  1 file changed, 7 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> > > index b19acd662726..f29052e6a87d 100644
> > > --- a/drivers/target/target_core_configfs.c
> > > +++ b/drivers/target/target_core_configfs.c
> > > @@ -108,8 +108,8 @@ static ssize_t target_core_item_dbroot_store(struct config_item *item,
> > >                                       const char *page, size_t count)
> > >  {
> > >       ssize_t read_bytes;
> > > -     struct file *fp;
> > >       ssize_t r = -EINVAL;
> > > +     struct path path = {};
> > >
> > >       mutex_lock(&target_devices_lock);
> > >       if (target_devices) {
> > > @@ -131,17 +131,18 @@ static ssize_t target_core_item_dbroot_store(struct config_item *item,
> > >               db_root_stage[read_bytes - 1] = '\0';
> > >
> > >       /* validate new db root before accepting it */
> > > -     fp = filp_open(db_root_stage, O_RDONLY, 0);
> > > -     if (IS_ERR(fp)) {
> > > +     r = kern_path(db_root_stage, LOOKUP_FOLLOW, &path);
> > > +     if (r) {
> > >               pr_err("db_root: cannot open: %s\n", db_root_stage);
> > >               goto unlock;
> > >       }
> > > -     if (!S_ISDIR(file_inode(fp)->i_mode)) {
> > > -             filp_close(fp, NULL);
> > > +     if (!d_is_dir(path.dentry)) {
> > > +             path_put(&path);
> > >               pr_err("db_root: not a directory: %s\n", db_root_stage);
> > > +             r = -ENOTDIR;
> > >               goto unlock;
> > >       }
> > > -     filp_close(fp, NULL);
> > > +     path_put(&path);
> > >
> > >       strscpy(db_root, db_root_stage);
> > >       pr_debug("Target_Core_ConfigFS: db_root set to %s\n", db_root);
> > >
> > > base-commit: 3a8660878839faadb4f1a6dd72c3179c1df56787
> > > --
> > > 2.34.1
> > >
> 
> You missed the very significant thing in the commit message - that this
> lockdep warning is due to try to write its own filename to dbroot file:
> 
> 	db_root: not a directory: /sys/kernel/config/target/dbroot
> 
> That is why the semaphore is the same - it is of the same file.
> 
> Without that explanation nobody understands wheter it is a false positive or not.
> 
> The fix itself looks good.
> 
> Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com> 

Hello Dmitry,

I have sent v2 patch with this change incorporated, however it doesn't
include your Reviewed-by tag. Since your review applies, and the changes
in v2 don't invalidate it, I wanted to confirm if its okay to carry
forward your Reviewed-by tag or if you would prefer to review it agian.

Apologies if this is an obvious point.

Best Regards,
Prithvi
