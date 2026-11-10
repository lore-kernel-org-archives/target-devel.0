Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794305680;
	b=JTlfLs2JO+/Up6WToxaa7zTxcwy36N948zdBP5Xq38GD6jY55URlAdaBgj1KT/BohS/D
	 xLwZVQaBeEEhqi2oW+OQHDCYJfgabSgpdJaWP0lgdFdRtHt0T4E40ILuv8KaarApHlWzE
	 /Gn5Q8tmP6d2VbcyOjGirEKAvFjHNbfbmUr5Hy/IVAU4A3aSOpB/v3RFVrFeJTJwHgzOJ
	 SgB3NSJQAGSDqf/sbvWmobdTd7HZbL6ACkd9pFXruEEVAkdGegTkg/k+xLjHwDvWgxvTb
	 2kwjB0J8IWDNS61oo7XHSYBGikl9v0znrHw1Af3J+Go1nKH0DuG3RVExKnC1pZ4V5iA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794305680;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=9WFltYRvNkpM0HMxRLJxGiCTEiP83WtKPHu+oXy3KTg=;
	b=UO3UBvMErfuabiK0J/p6c3fGxoStINjPGLdjb7zDTjS0FwvQ+XpMkr9UjZRvyg8KTDUr
	 GwiwSNWhcbldkUxYgcJlsNWGQC4mhlpeWqMLCjWfoFANinL6JvYyv3wLkl19NGqf48rz8
	 DiIHRBE84c7Xg/+CUITv6CLzXZOy0no9ry9Ffo6JlTIZHCmwP2rD3F40fZA1ga2wkaQ5v
	 HTAeR8xYN3mF03ae4hC45eCKB0UbJFA2dDjzstc8nnj5vDf1//UqytRWsnQ5pQSEeBqAu
	 /9HmxwKMeGxh/8DMW+hgGf9/94ZWf5qzKB2wFOIQzK543cPnZScgyA1+nxuq/4lM1Tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DrlQYRb4;
	arc=none smtp.remote-ip=209.85.208.47
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9210F606AA49
	for <target-devel@vger.kernel.org>; Tue, 10 Nov 2026 10:14:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9210F606AA49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DrlQYRb4
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6b2237b596cso3959801a12.0
        for <target-devel@vger.kernel.org>; Tue, 10 Nov 2026 02:14:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794305678; x=1794910478; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9WFltYRvNkpM0HMxRLJxGiCTEiP83WtKPHu+oXy3KTg=;
        b=DrlQYRb4d+FJBQLFk4gip1vdMb9pZcbFm0QRoW/O9nsnnIGk5B/dcI7komCKzkv/uM
         Uz0TTkL3EB0XOLA2v0TTxwYvqDOvah1wiwbB4uUsiRRXfj1OcdvtnHWnMQS6yfKTNN5Y
         2S+sbZpFj/oUd6OIfB1K+t4luOgmpm8MRta8dNUBz+XdEb16ui6jztHrAySR2QYDDBtW
         UcH7ksMk3kyTCuhLg24n4RSbgP43bR1MD63YWBBHbNHKba+s6Adtgd3r0iiTavTYgvkx
         vCBmyxhjfzRfUpjuhY0K7x1CK/3uUIf/0FzbTbFW5bHu/k5G1xko0Cr6O3LrrObY61iA
         y+ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794305678; x=1794910478;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9WFltYRvNkpM0HMxRLJxGiCTEiP83WtKPHu+oXy3KTg=;
        b=pZFvLS6y2yuxMd3RhTnxqPuseQ7GX/Oqx1cWh15pLAyopldISZFvNNBDKrP8cR+hTO
         U4uoj18AP3iBVJPIcj5a8O9DApLeTRJludNBWNY8YRddlwOPtp+P7ojqcGWCWu9g3aEg
         KlYM5Om7fskC15ArWHfudkPkSIjconzmV8rlbUA2SeHdFCMJjVRZUWyE/HabQIatlz32
         ctzuIoP1UVg8T+b0WjuwU/RK6RfKhXi0xKMJiZ93Oq9AaJEjzSXMbRGQC/ajHxibwQ+X
         RlpMc6+KTKEQnFdEsuMiXM8nZ89CZ0U0ICF8zGkYLL9zm8yAE3vo7pmFAoDESwg4RtDL
         mg0A==
X-Forwarded-Encrypted: i=1; AL+hErG8TzojHuVLct3DSe6BhtEEMyzMWyIuWzZoa0zfJatH7sSnJiWvCb+eZBB4I71zuACcf0OXH6ZZ37MIol8=@vger.kernel.org
X-Gm-Message-State: APuU4Z+e9nIAgxFgNEwg2mkJpNiM3EGkgK58htycGxpYKqTDtv+GiSAD
	c8GIFrboj19BJZDLHAKRoQGvzxhkvPadYld/uoqAtwtVfj4l2rClCXMk
X-Gm-Gg: AYBFou3OhJfGVRCaNiIpvijtJurcVEXodA2vt3RhytO8KMSk7yAEyTqWnMNAn4jdlvo
	R827MdylQn2/2LTQzzP63eIr1fwM/4DqDQIAxn5d/HWXk6hF6SgBEw+KzuQqFdRxcMnH00AulGm
	jgSLwdzUcJCoFDtDg0WvF+uGcl+itW2CL4XUgi1e1zd0MWZyBrxe0hasnzgm7t7cl8W8DgVoVPh
	mrZ26/m8WMBT0SF9HfR9r+4ixQxEMhLdRgHIzPN/m4FhmxvZvQJqAFJym3VFm+Bikx8T5ZXsmfW
	xuJwbqRRBIK4q95UALsDL31ErHk8JTG6KuF29I+8rgGuGGY4GEqZKYtjL+Gm2TZdfmx0mxiKlGV
	xBIeIRjrnpJNWiIBCXA32vBNJx6waowys/uZ+kzccCWWfFogZGNJ5oSTK4mm+FR3HDUnaRUBY9Q
	CS5ieUo13l9ZIhVqlkCIFFo1L+fpy9bP3XAoKsB3HPoBB8wuQnfNgOYdBBfpaRRvpFFYtvGmba3
	3Q9bF0LEBjoBdkC6pc8unzEOTGpiFAc42vK1FSyk/FFPCxUcJnvLX5FXfVoM6lZx56N5wEqIv2K
	w6HCWmUldPMYoVoaEyGuX5HZggHIRM/fUvf6BzYWCqIGb2QeTIQek6NeGSXcHQPkg044UqZB22x
	LbGrSG+EMYvCH
X-Received: by 2002:a17:907:944d:b0:c41:4c20:5a80 with SMTP id a640c23a62f3a-c504963ce05mr189793966b.44.1794305677695;
        Tue, 10 Nov 2026 02:14:37 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c504a593eacsm90433466b.36.2026.11.10.02.14.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 02:14:36 -0800 (PST)
Date: Tue, 10 Nov 2026 11:14:35 +0100
From: Amir Goldstein <amir73il@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>,
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	driver-core@lists.linux.dev, linux-mm@kvack.org,
	bpf@vger.kernel.org, linux-security-module@vger.kernel.org,
	selinux@vger.kernel.org, apparmor@lists.ubuntu.com,
	linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
	fuse-devel@lists.linux.dev, linux-efi@vger.kernel.org,
	xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-usb@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 38/41] fuse: refuse files on pseudo filesystems as
 passthrough backing files
Message-ID: <avLui6Mpf8GbKbtc@amir-ThinkPad-T480>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
 <20261110-work-loop-pseudo-v1-38-4c998976c6c7@kernel.org>
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Post: <mailto:target-devel@vger.kernel.org>
List-Help: <mailto:target-devel+help@vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:target-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-work-loop-pseudo-v1-38-4c998976c6c7@kernel.org>

On Tue, Nov 10, 2026 at 10:14:54AM +0100, Christian Brauner wrote:
> The fuse server can register any regular file as a backing file. procfs
> and binfmt_misc files are already refused by the stacking depth check as
> both set s_stack_depth to FILESYSTEM_MAX_STACK_DEPTH. sysfs and the
> other pseudo filesystems aren't. Reads and writes of the fuse file would
> then be done on the pseudo file with the fuse server's credentials.
> Refuse files on pseudo filesystems just like loop does.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/fuse/backing.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
> index 8c21a8a74efb..4e4fb810ddaa 100644
> --- a/fs/fuse/backing.c
> +++ b/fs/fuse/backing.c
> @@ -147,6 +147,9 @@ static int fuse_backing_open_file(struct fuse_conn *fc, struct fuse_backing *fb,
>  		if (inode->i_sb->s_stack_depth >= fc->max_stack_depth)
>  			return -ELOOP;
>  
> +		if (file_is_pseudo(file))
> +			return -EINVAL;
> +
>  		fb->type = FUSE_BACKING_PATH;
>  		fb->path = file->f_path;
>  		path_get(&fb->path);
> 
> -- 
> 2.53.0
> 

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

