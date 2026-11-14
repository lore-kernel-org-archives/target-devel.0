Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794686762;
	b=XhqFTPNxGuOPy/qM0t6YE9h6Z5leYA/GU1fVLtH9WoBBb6oT5OedWyS2Fw1EgoRtIl9m
	 Gtb+Inr4eKsG8plKJHx4CsN/EpXAW6xQszZ7Fqwu753KIlF1LezEagHFSELHHPUwk+Axu
	 iXsiAYJjOtfhnu1peoedhPcjDcJYN6umMVAhsh7HBhKJKQ3FKulc2O1NyXEJY0/mbOZ3N
	 mUkduQ8udtQ58gfi+wi/I4UJEy2m/sPBx6QNae5biQw1UrMzIp/6t96u2MACoqKJD0ZrY
	 8go/1UAgghjBV2b9CAJ/PFEmT/mVy9SSIDA2iNnd2yRUcaEnNYLpp4CSECoT00wWP/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794686762;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Message-ID:User-Agent;
	bh=L9fh6nGpkdQ3PKE1Pv6VuACg3WWhS00/MicQv00SggM=;
	b=wCi7ksK+FeigU+VV8nLB9AqDeeFB/mamt+Ob3fjrUYue98ffjjOKi/pL0Cht+7DQkvFk
	 f/26A/Qmw/FYo7+5ghdvHikHcBfVJjjbUnlT84IYlh2znsunQLyCxfa8Cqou9QRmfBh1I
	 TfNOabFsqtOGAf+T9LajQuV7cD5w4isKMQgQGVBLBGBBzaZVD6CWgKxAmsfTGX26Wm4Bh
	 BYijHZsmXaeaOYXe4MksJB5bzTMoocCB7Pw+ikKqQr3YDch3UqSwBvZ0mH2gU7LoBTHsG
	 RmrigD51mqxPdMYAjTjiC9H92xovYAflWSlTScgZWe+uSzxHHZoz9khZI1IImHhjT8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chrisdown.name;
	spf=pass smtp.mailfrom=chrisdown.name;
	dkim=pass header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=WyNKKpAN;
	arc=none smtp.remote-ip=209.85.215.169
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2DB660A380D
	for <target-devel@vger.kernel.org>; Sat, 14 Nov 2026 20:06:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B2DB660A380D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=WyNKKpAN
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-cdd9d0c9bbdso2097066a12.1
        for <target-devel@vger.kernel.org>; Sat, 14 Nov 2026 12:06:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794686761; x=1795291561; darn=vger.kernel.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=L9fh6nGpkdQ3PKE1Pv6VuACg3WWhS00/MicQv00SggM=;
        b=WyNKKpANsG5sdrHWGAt+Y38DvSIGt+WnCUyNYCZoBM4YbSq3wCVAHI95jQ8BFTGgLn
         +vM7af/q0i5zrzjZXXnriwzXN4L/RbeBg/iztvO0eyeIXYNiQp/OYlS5LD9yZqr2gKgm
         1I+5A88e/cV4J0nLZfgp0f7sQwj9jY0Q4quBE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794686761; x=1795291561;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L9fh6nGpkdQ3PKE1Pv6VuACg3WWhS00/MicQv00SggM=;
        b=PteJYD/IVvPiWqmP06HwNuhWT1Px7Q8RrzmIc2SdSCkU+bReAydB8xRpNQsRfKo8ub
         Qj9vk17P/IklzAbsf8xAZn/iRyqRaCdDKWmdIUYFd4TK1sYFUwsEaIqwEQ31oxl3PWVy
         4YZYKGn5pFMOuevIxs/ZLPsfUSlwgy03TmBseP2UgCcsg12kCsGimVkm/C32nTISnrMH
         rT4qLErvnWbyFeCvGAl8TuFRuvcJdzWXlMkemaLWA8eAp+Enly+z9/+cYv3YR2HIfcsp
         dO5Nu/elWMxtm+JaAJ04WtJAc3gVt/jUfRImlHqfa5NEoDkNNC2yMi9uI4hv+F4b8LIn
         v+8A==
X-Forwarded-Encrypted: i=1; AL+hErEv4xjTRooi3Tm5h2uEXdKJDDxYDGEIpiVVQRKTkXQu8dCJonFh9DDMHE736nvj5b5/wBZTZ5l9Cxkjz3E=@vger.kernel.org
X-Gm-Message-State: APuU4Z/Fkj05Dvj3iqbhjQNWNF6gSieej+CSNT67RJwng1sdb4q3MpRF
	t+5HVqRzNUejfjLPXl0KSQpRmlKaj4r8hJIa0TcR2X3zUYE6kuvkOki1jOy2PBwDxNU=
X-Gm-Gg: AYBFou1sCaQ8gsWV/uRv7ONn0TOdOzu1xOLRyLhaNi86zYxpwbeblKCFFANnogfIpFO
	mCU2YjdS/SJvICbHock41ctJDsFUicm3NJISgzV9qCmXZnoKNs6ovt0zM4hhgL5V4Fpmc5p6r1x
	Wp8oxTQWPxX40rB7CmOO9p+adRQqaZK6l1FNs6Fehpxn4DWzalC22hhyaMs/MjK+3H9Ha1bah5d
	D0tzNKPQfsATlqIjkbZ/+8ldEAGEbTsEqATqMpZJsyjlFfTlGASuixqahqXCvTKlGK87Oq9Tbxq
	iHkRLOQaboZjQam/Hxtutlp7IQekL63HRbyx8djPqrbEOrs/27+zosCJGfL07gTGB8qfPttnv35
	0I3Ke9SOTY7dRgliqVSGYrGaDPMOCr46wJlRhgLY4rcKf00H4wa27/+EYC0i+P2qLSUedGdjEQL
	t/rTxhlh8H6qZC2Vj/HjXUR2vs2qzzC4fWElX2rLLpjz/R90oIkRnNOvltpfjjgvCclf7HO9rcU
	JmaxTG/SIrC36odwUt5gkWIBL3UmD7toCdr1YCx3HPbt5pR1Ly9v9+A166mrpCGBhK9/DYfo21A
	zWHLxdYJSNXPB7rW3ieUSbgk7OO+FG7plToiMOhIZKSm2AK4cyl8vQiO68HpeA/ntanO9gxqDnM
	qskyBoBmcQn8K67ENXtTkc5jFyK1R1no0OS53i/jr2OYC9LXvEW6aRaoZzuukYOMr0PGaQD94JX
	g0pzp7XF+s6mmX+9vAU8wLdLqA/hw+AHc75UcsirV/We47axbOILT8rJyd
X-Received: by 2002:a17:90b:2584:b0:3ac:9f00:3bc7 with SMTP id 98e67ed59e1d1-3b1b0ba61famr5629200a91.33.1794686761104;
        Sat, 14 Nov 2026 12:06:01 -0800 (PST)
Received: from [172.22.0.2] ([64.16.22.130])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1b1e9ef15sm5258887a91.0.2026.11.14.12.05.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 12:06:00 -0800 (PST)
Date: Sat, 14 Nov 2026 12:05:57 -0800
From: Chris Down <chris@chrisdown.name>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>,
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	driver-core@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org,
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org,
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-usb@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
	linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC v2 33/42] fs: add file_check_backing()
In-Reply-To: <20261114-work-loop-pseudo-v2-33-98639a2286fb@kernel.org>
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
	<20261114-work-loop-pseudo-v2-33-98639a2286fb@kernel.org>
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Post: <mailto:target-devel@vger.kernel.org>
List-Help: <mailto:target-devel+help@vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:target-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261114120557.4bc1eb6e57218cdc@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)

Hi Christian,

Christian Brauner writes:
>+	/* Look through stacking filesystems at the inode with the data. */
>+	if (d_real_inode(file->f_path.dentry)->i_sb->s_iflags & SB_I_PSEUDO)
>+		return -EINVAL;

This looks good in general, but what the bots said about O_PATH files
here is real. With FMODE_PATH this is reached for a file that was never
opened, so on overlayfs nothing has been through ovl_open() to look up
the lowerdata of a metacopy file yet. ovl_d_real() then does the lookup
itself, and when that fails it hits the WARN(1) at its end and returns
the overlayfs dentry, so the check passes as well.

Only fuse passes FMODE_PATH, so it takes CAP_SYS_ADMIN to get there, but
it's easy to trigger with that. From a quick test with a metacopy file
whose redirect into a data-only layer points at nothing, registering an
O_PATH fd of it with FUSE_DEV_IOC_BACKING_OPEN gives

     ovl_d_real(/f, 0): real dentry not found
     WARNING: fs/overlayfs/super.c:79 at ovl_d_real+0xc9/0x210
     [...]
      file_check_backing+0x308/0x5e0
      fuse_backing_new+0x219/0x4a0
      fuse_backing_open+0xe8/0x390
      fuse_dev_ioctl+0x53a/0x7d0

and the ioctl still succeeds. A normal open of that file fails with
ENOENT, so nothing could have used it as a backing file anyway, but with
panic_on_warn this is now a panic.

Maybe ovl_d_real() should just stop warning when the lookup fails, now
that it has a caller that isn't trace_uprobe? The check would still pass
for an O_PATH file whose lowerdata couldn't be looked up at that point,
though.

Thanks!

Chris
