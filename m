Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794323278;
	b=iAT8aMOTq2xUbM9Dt1s57uobWT+VpdkWmYYBKGDLnB4G5Dzn1XMSrYutQygYGt8TZd9J
	 1C/6lRpjcMwITQuW8yAleL6Eqs5AxcnOM9fuwjTAeuLzsBWxLzWTHBkrIPIyaJ/XphvP7
	 i54VXvtH/xey+ILWIO/SPbRzuiXggFcNcWUUSS1QNCHV6ujvG0iioNRMPk1lKM4gR5xDK
	 fbqUmg8s+C/lRUG65Q9aSnSskm4WvrGdXh36dzI7fxxF2zjKJC4d6NpT5UmiSIR+XtBJ6
	 QBEecfWjLAcLsNh2LqC5Rgca58tFIUb4QwB99jFcwoG5WvXfjZZWlFyne1ju96P/pLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794323278;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=JtM9UtzYhAWCxTCfoBKbcmHIR3U4Wq7tzdw7gboBY64=;
	b=lBbf/U4WjeacFag3G4l3UjtZqVxRB0KBmNzWuySFoVNAZHOOc7tv8CV5PfCgghS3TTrv
	 r1gJ7Dx5HCv1Ts2KYFtV3mek1ViEQ76Iq7lpZ3aFJrUjq3NSNymW93cFn8ohS0iCbaWen
	 FjqjUqA8XYefRQOi77fQXtARADoNjGZB70Rz+63TJPD9Shfboy7Gn7V6UQCLfYGzvBNqK
	 36rt1Mku032yK5kbloJVCnxlDN+pxsCnro7P5yXexn6DRpbsPKUWSjubh9C9lUJlwjAkP
	 Ko2cUzPqYDtsKsLb2lTCKkh3ak+Z3QR5QgTNql/gnjEFEt3TnCfBwxsphV6X1Z0Btfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LHozpx7Z;
	arc=none smtp.remote-ip=209.85.214.181
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B99A60A261C
	for <target-devel@vger.kernel.org>; Tue, 10 Nov 2026 15:07:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1B99A60A261C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LHozpx7Z
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2e8da6ef7ddso12775855ad.3
        for <target-devel@vger.kernel.org>; Tue, 10 Nov 2026 07:07:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794323277; x=1794928077; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JtM9UtzYhAWCxTCfoBKbcmHIR3U4Wq7tzdw7gboBY64=;
        b=LHozpx7ZkQyIUBsAkv4C311vzxfheFN2pzrL9Y/FTHkEXQzaVUkMAz9U9wFUejAOr8
         YATASi40x9WcOvyF4dkS6SJQ2bBJHO0yE68WsOT8oewufPXMhMYT6O7d4/5H33a+EMHR
         jjCu1KqktdAA/9c8ZIpbjFjA/3BLyNbgEZc3fS3F9+PTZ5y3jCgkJQ9rhGft5ONP+cJO
         aTEF5vn9sQP8UWqDXO8UszNcV0yZFTKvtrsUk25y1Sz/3h5njQt9uj1PBQLO+FuWPgpB
         LsGoLTWDE/iFYFuKD+GJLya2PXFipxPXM8zYDthkWkjgd0549O004Xgoom3qc/ylK84T
         vykg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794323277; x=1794928077;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JtM9UtzYhAWCxTCfoBKbcmHIR3U4Wq7tzdw7gboBY64=;
        b=BlxaCDMQauRcCfDvDhZhek5aa2cj94sx22HqMgLeH3URKpt5ncpLxWUTH1RA0uOl1H
         FaK+Gu4/GDE8UAWQf1jogQocSqgFT5XhTtZdc6dBYJTHc1IihmVxNl86alW6hVdz1y+d
         pF1qx028+P+OZuVYMvZ8IhGhY0VPxD+2FfE6LcVgiPrrjlyNH+kcgieouZvQfoFIq10T
         BrF9LSeKZsBqoUB/e3W9bT6b/7mYCYeLiGJeYgs0LUzFZUsYED9zmVuZiDaB8BVXLb93
         unXihoD8RLHg+bBRSOSC0vLdC2ffaTZNR2CV07vogB4UeQ0NKTEGfm9ShxZmEBf4XuUW
         Cgxw==
X-Forwarded-Encrypted: i=1; AL+hErF8ilD4+OuKaeBD/09ljxd4Px5ynd4OisHYKULDIpTe4oipvut8L3nQGuEc3XhrfoO/uerQuqhLXa3nCmk=@vger.kernel.org
X-Gm-Message-State: APuU4Z/CqCgxC5BTMPoobkbDLUp95lj+Krf5eEQZYQ4V6hA83Sy7yBG4
	Wk380h2W2/eCz3UrqdmWti6ipj+mG2pA6VNGnizHG1kEY+TbBkdghXuL
X-Gm-Gg: AYBFou0/i9ipKGDGqSMbN8L5zU4O8PSG4J1c4kB8BO6fGE4jAjMU1dTlSzsb+iE/Yx2
	uPLy9r38c7SzVotXoQsUo0oJYSlyJbtEKWPcWKuYRv7zcNcjT+m1z2I4Vtfs/tV+sSdHStnx3Fj
	XqJuySPiRayt7mZRAG1VViNq/jF5kzRsBun+M6oe3JLuuUesbm2q8Hc+6ZgqFkyU+dlfz/p+SVq
	Jj2WUJOG1KzgSP+OwU8IQEJb4zO4z7/BiWMzLZ1UTDu8iA7gzPQGDHKrLz0GHJPFAEElcn62EfF
	wbcto/lFo0aqblLXysSaUCnYS6sfb5ssYTlJoA14r4/Gr0mGwvVv6kN8EThHOMKh2AEX3kuRyc9
	8leKuyotELeNKibq9Ah8t+WvHI1uvH0U2p8QeFL36i6TLtADzTuCBcDnFXtyBVNgScjbMUx8B/L
	UFajMyPLsmJIHWJclvk+XyPB+KW4+9tsSCbSPpcplBZPb5QAW+7XCnek2Vw2y1gKsBurB0Dty3M
	IAJVeyLVE46OvEPMrXqA8XqtfdnSnQR2fMjrnu0Z51GmAuYvAHMpT7MbL2OmUTt0CYueB1YpCgh
	MDGuEUwW+kNzrz4ioC4kKYRN+BEVTF9xXFokO8rX6Aae2IptUe3y1yCYTJIXGbheiyaH2zmeazL
	Tu7nqOynqUO8=
X-Received: by 2002:a17:902:d481:b0:2ed:1ef3:9ec with SMTP id d9443c01a7336-2edb9172a2dmr26826345ad.14.1794323276968;
        Tue, 10 Nov 2026 07:07:56 -0800 (PST)
Received: from [192.168.2.6] ([27.75.101.24])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2edb6d78dbcsm10397575ad.27.2026.11.10.07.07.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2026 07:07:56 -0800 (PST)
Message-ID: <71f76e5e-ce24-4a71-863a-169ad262c510@gmail.com>
Date: Tue, 10 Nov 2026 22:07:46 +0700
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Post: <mailto:target-devel@vger.kernel.org>
List-Help: <mailto:target-devel+help@vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:target-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 36/41] nvmet: refuse files on pseudo filesystems as
 namespace backing files
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>,
 Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, driver-core@lists.linux.dev,
 linux-mm@kvack.org, bpf@vger.kernel.org,
 linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
 apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org,
 netdev@vger.kernel.org, fuse-devel@lists.linux.dev,
 linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org,
 ocfs2-devel@lists.linux.dev, linux-s390@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org,
 Amir Goldstein <amir73il@gmail.com>, linux-erofs@lists.ozlabs.org,
 linux-kselftest@vger.kernel.org
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
 <20261110-work-loop-pseudo-v1-36-4c998976c6c7@kernel.org>
Content-Language: en-US
From: Bui Nguyen Nhu Quynh <kaylovefoss@gmail.com>
In-Reply-To: <20261110-work-loop-pseudo-v1-36-4c998976c6c7@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/10/2026 4:14 PM, Christian Brauner wrote:
> The file backend takes any path that isn't a block device. With
> buffered_io=1 that includes files on procfs or sysfs which then get read
> and written by a kernel worker on behalf of the host. Refuse files on
> pseudo filesystems just like loop does.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  drivers/nvme/target/io-cmd-file.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/nvme/target/io-cmd-file.c b/drivers/nvme/target/io-cmd-file.c
> index dfa8aa46188c..71c69bac5394 100644
> --- a/drivers/nvme/target/io-cmd-file.c
> +++ b/drivers/nvme/target/io-cmd-file.c
> @@ -52,6 +52,11 @@ int nvmet_file_ns_enable(struct nvmet_ns *ns)
>  		goto err;
>  	}
>  
> +	if (file_is_pseudo(ns->file)) {
> +		ret = -EINVAL;
> +		goto err;
> +	}
> +
>  	nvmet_file_ns_revalidate(ns);
>  
>  	/*
> 

I noticed patch 41/41 doesn't include a test for nvmet. Would it make
sense to add one with buffered_io=1? The test would need a pseudo file
that can be opened with O_RDWR and supports both read_iter and
write_iter. Otherwise, it could pass without ever reaching the new
file_is_pseudo() check.

Thanks.
