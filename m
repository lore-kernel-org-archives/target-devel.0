Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B657D2192F9
	for <target-devel@vger.kernel.org>; Mon, 23 Feb 2026 03:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771818496; cv=none; b=TKOm0Wq8aT/nxxqkETlMcOcjVMrsx4E8wPOpTJM8WLaCBUb6qyumsRvxUsN3VLK0Fjv8si2/OVSvZ7+uFjblH6UUF5nGxEYWG22b+TVXpln3wp5pQXyVPhZSdoPeSUwVeu6JJxz0BY+i3tiUFbnhNrrErVDokZfGZdzaFKCrSWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771818496; c=relaxed/simple;
	bh=SF93mBnv6b6pLe/1HBoftNRah+ZLiF1OcBwwqbvPe6E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ft51bIm+XC/aLNS6AUp+bndGKpxl1k4l7Gxo3+58fIbVA7h9e7O9KDBlXOLcAholOoXdTXf57vERkXJr8aIV6II93F8APF4o9oyjac3hZldsUGYfUjILLQbPCT9C39fTyaWuY3M4fNzGXwWokzEU0KgU8X/izRM9Vwz/fWTzjgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kn+WqJAI; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kn+WqJAI"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-c6f306faaffso1353431a12.0
        for <target-devel@vger.kernel.org>; Sun, 22 Feb 2026 19:48:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771818494; x=1772423294; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=W4rzQ0T621GZSjBat75RSIcrNnampDyhuho7rtv7pj0=;
        b=kn+WqJAIJ/4YHgC84EqeJVuE0n4c+IV1m44Cj81aoaJ0joDEls+GVbdMq6YNMXCLWY
         ALy6uiwRdoGfNuImrkaPD1T9XhkN5x/5XyJGQHrwiigHgKHkveltqmgeOMPDbChCdN3O
         f9kqH9az3Z/5mBBfDeOq0ARYAqcVBGfY05GRGe8qWxXkI0Wwu9pKh8i6is9+Yp9c64Eg
         w7pEnjyiUBmsyVdGR7sRb41Ohqb/ypkDF5rleXmrcFluW4yYHewuYGsEn/7dC3XLpcSF
         ZgzlHW1JRLHIUekk2DT0AMN/A3nBYosdPEwvh+xFcEjII2ziyKIZLFIo1VFyMAFUc4mT
         sNjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771818494; x=1772423294;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W4rzQ0T621GZSjBat75RSIcrNnampDyhuho7rtv7pj0=;
        b=tZVY/tRb5DQwWrx6OsHREMJsnweJMnqQB5asAimWBW+MDJQYAjI3mpONb2DHKLNxFW
         +kQWSHeZRTPT6URN7qUdMEK8GMy12CRn7jb1L2kMhrJyOn5GOnBi4cLDyjFBZ3jEau9n
         oHRZiwXEIt+g6LHBaVtFgksYJKlzi6ltThYHRJL3peGzhB45WUuhsSOHE+c6FxldmQUO
         M3hPYMsWwwjkl//srVLDk8c0mK23B+NBOoqHXeuGnWLHDzrd6rPv2+0CKPUD45mIiExJ
         a0S+IwWWYzn6NfQvyBjLMRlDMoJ5ahRzlqWq+EdheAxbpy8Rt7uvXL6KbufrKRt2rj6X
         yvpw==
X-Forwarded-Encrypted: i=1; AJvYcCW27lRUoF1bo+mqROCzpFLN/JYqMLCI6Qg3BonraGmcwJ/SZEfvGapYhW9ON4+cp8mp/J2CYzgkxLbdMwQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwpGbb7Hbi2u5vzdA/nz0wY/24J8zdqFFQENsKkRiXr39StYM5C
	dU2w/Tev7mk8Iaz3aV/6NwZcIDb5X9bjIBQ27S1t+QUcMaEC8AJSaHyq
X-Gm-Gg: ATEYQzz+3KuY/hstIyc7HVNe+IpTCtfAuk4abMtw8ROoJtT2oIRNJkBZFKqabkumrIU
	2LBdWiWNdvEpfmfCFMFvWq4wOZYSOWS4E9il0Mcj2R7fAa+qNVU8KoreK4aSvRF3QvrieIb8cWN
	86Esf9EC6HSy871hWcVqIIV6CYarHgiYckHVz9MFEJewEyIwh/nAM24bv42YHvF98M5+9+/8LZ4
	HrL36tuUYruFAYa7v4UZQW0Oje53gsp96urG9cFShM4zUFVm743CZlSKS60YGIdLv6hsibhEx76
	E1zWIGwPW9kL37tpP36QKQVyQBb9pqG5IJqiJ+8AQdlpXdxwcCcyQ3h1t57gfwMb7rBSgL2T5Cy
	cfzaFqJVFfxvlWbaoTveMn4CsGS83FaFl2kzJ+AeJmlRQXlaEk2BM665TLOA/4Hb8gZuLWLsfbz
	bHZDvFzA6XVdLpHqVUoObcEA8=
X-Received: by 2002:a17:902:ecc6:b0:2aa:d7fe:8603 with SMTP id d9443c01a7336-2ad74419e3emr70224515ad.8.1771818493881;
        Sun, 22 Feb 2026 19:48:13 -0800 (PST)
Received: from inspiron ([111.125.235.136])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad75027641sm67314185ad.64.2026.02.22.19.48.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Feb 2026 19:48:13 -0800 (PST)
Date: Mon, 23 Feb 2026 09:18:05 +0530
From: Prithvi <activprithvi@gmail.com>
To: martin.petersen@oracle.com, d.bogdanov@yadro.com, bvanassche@acm.org,
	viro@zeniv.linux.org.uk
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org, david.hunter.linux@gmail.com,
	khalid@kernel.org,
	syzbot+f6e8174215573a84b797@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v4] scsi: target: fix recursive locking in
 __configfs_open_file()
Message-ID: <20260223034805.yhzmheiwndxtj5zu@inspiron>
References: <20260216062002.61937-1-activprithvi@gmail.com>
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260216062002.61937-1-activprithvi@gmail.com>

On Mon, Feb 16, 2026 at 11:50:02AM +0530, Prithvi Tambewagh wrote:
> In flush_write_buffer, &p->frag_sem is acquired and then the loaded store
> function is called, which, here, is target_core_item_dbroot_store().
> This function called filp_open(), following which these functions were
> called (in reverse order), according to the call trace:
> 
> down_read
> __configfs_open_file
> do_dentry_open
> vfs_open
> do_open
> path_openat
> do_filp_open
> file_open_name
> filp_open
> target_core_item_dbroot_store
> flush_write_buffer
> configfs_write_iter
> 
> target_core_item_dbroot_store() tries to validate the new file path by
> trying to open the file path provided to it; however, in this case,
> the bug report shows:
> 
> db_root: not a directory: /sys/kernel/config/target/dbroot
> 
> indicating that the same configfs file was tried to be opened, on which
> it is currently working on. Thus, it is trying to acquire frag_sem
> semaphore of the same file of which it already holds the semaphore obtained
> in flush_write_buffer(), leading to acquiring the semaphore in a nested
> manner and a possibility of recursive locking.
> 
> Fix this by modifying target_core_item_dbroot_store() to use kern_path()
> instead of filp_open() to avoid opening the file using filesystem-specific
> function __configfs_open_file(), and further modifying it to make this
> fix compatible.
> 
> Reported-by: syzbot+f6e8174215573a84b797@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=f6e8174215573a84b797
> Tested-by: syzbot+f6e8174215573a84b797@syzkaller.appspotmail.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
> Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
> ---
> Changes since v3:
>  - Add LOOKUP_DIRECTORY flag in call to kern_path() so as to check presence 
>    of directory checks more efficiently
> 
> v3 link: https://lore.kernel.org/all/20260205162624.117957-1-activprithvi@gmail.com/T/#m175d152067817dd6e9dc1821b6fbf626e47a4007
> 
> 
> Note:
> I checked out and found that when I try to test on commit 3a8660878839faadb4f1a6dd72c3179c1df56787
> (latest commit on which bug dashboard reports the bug on, in upstream repository) 
> syzbot uses, in its kernel config:
> 
> CONFIG_CC_VERSION_TEXT="gcc (Debian 12.2.0-14+deb12u1) 12.2.0"
> 
> Ref: https://syzkaller.appspot.com/x/.config?x=e854293d7f44b5a5
> Syzbot Reply: https://lore.kernel.org/all/6767d8ea.050a0220.226966.0021.GAE@google.com/T/#m62bc76de5549460ae98e843bb120712548489794
> 
> While when #syz test (i.e. on HEAD commit of upstream) is used, it uses, in
> its kernel config:
> 
> CONFIG_CC_VERSION_TEXT="gcc (Debian 14.2.0-19) 14.2.0"
> 
> Ref: https://syzkaller.appspot.com/x/.config?x=99ac58566e9eb044
> Syzbot reply: https://lore.kernel.org/all/6767d8ea.050a0220.226966.0021.GAE@google.com/T/#me8b79610e4c18a8d8a7d8d6bc249d1c7cf2f8819
> 
> However in both cases it uses:
> 
> gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> 
> Probably due to mismatch in compiler version which syzbot actually uses and 
> whats present in kernel config, the build fails for the first case. However, 
> the patch succeeds in fixing the bug in second case.
> 
> Earlier for v1 patch (sine v2 patch involved minor change to commit message 
> and v3 involved adding a missed out Reviewed-by tag) patch the kernel builds 
> as well as testing succeeded since syzbot used this in its kernel config:
> 
> CONFIG_CC_VERSION_TEXT="gcc (Debian 12.2.0-14+deb12u1) 12.2.0"
> 
> as well as used the compiler:
> 
> gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40 
> 
> Changes since v2:
>  - Add Reviewed-by tag received from Dmitry Bogdanov, which was accidentally
>    left to be added in v2 patch.
> 
> v2 link: https://lore.kernel.org/linux-scsi/20260122154051.64132-1-activprithvi@gmail.com/T/#u
> Reference for Reviewed-by Tag: https://lore.kernel.org/all/20260108191523.303114-1-activprithvi@gmail.com/T/#mb22d0fc06e747e2b2df8320a15afd2a0670fd0e7
> 
> 
> Changes since v1:
>  - Update commit message to reflect the fact that same file, which code was 
>    currently operating on, was tried to be opened again, leading to 
>    acquiring the same semaphore in nested manner & possibility of recursive
>    locking.
> 
> v1 link: https://lore.kernel.org/all/20260108191523.303114-1-activprithvi@gmail.com/T/
> 
>  drivers/target/target_core_configfs.c | 15 ++++++---------
>  1 file changed, 6 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> index b19acd662726..f94c242eff97 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -108,8 +108,8 @@ static ssize_t target_core_item_dbroot_store(struct config_item *item,
>  					const char *page, size_t count)
>  {
>  	ssize_t read_bytes;
> -	struct file *fp;
>  	ssize_t r = -EINVAL;
> +	struct path path = {};
>  
>  	mutex_lock(&target_devices_lock);
>  	if (target_devices) {
> @@ -131,17 +131,14 @@ static ssize_t target_core_item_dbroot_store(struct config_item *item,
>  		db_root_stage[read_bytes - 1] = '\0';
>  
>  	/* validate new db root before accepting it */
> -	fp = filp_open(db_root_stage, O_RDONLY, 0);
> -	if (IS_ERR(fp)) {
> +	r = kern_path(db_root_stage, LOOKUP_FOLLOW | LOOKUP_DIRECTORY, &path);
> +	if (r) {
>  		pr_err("db_root: cannot open: %s\n", db_root_stage);
> +		if (r == -ENOTDIR)
> +			pr_err("db_root: not a directory: %s\n", db_root_stage);
>  		goto unlock;
>  	}
> -	if (!S_ISDIR(file_inode(fp)->i_mode)) {
> -		filp_close(fp, NULL);
> -		pr_err("db_root: not a directory: %s\n", db_root_stage);
> -		goto unlock;
> -	}
> -	filp_close(fp, NULL);
> +	path_put(&path);
>  
>  	strscpy(db_root, db_root_stage);
>  	pr_debug("Target_Core_ConfigFS: db_root set to %s\n", db_root);
> 
> base-commit: 3a8660878839faadb4f1a6dd72c3179c1df56787
> -- 
> 2.34.1
> 

Hello everyone,

Just a gentle ping on this v4 patch; it incorporates Al Viro's suggestion 
from v3 to use LOOKUP_DIRECTORY flag in kern_path(). Kindly let me know if 
anything else is needed from my side or any feedback is to be addressed.

Thanks,
Prithvi
