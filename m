Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794658800;
	b=ufPoceOeH9pDQkHCSrwe6GALmKF7656pLXLSkBcsRIox65wulG6x8YY3JaHUxrdWOwDp
	 DPWLOmKmVuocpogL8rcaEksiQmje9wW/sVTnrGm6p9WSajXzmOqJMM3xF4D35BfSIhUi2
	 WSZpWH9Lz3sPnnoSVSqq8jBEusOuRtT2PvXolVzi+CulR57rFDzB5UXFmIs82bOf7jCVZ
	 11NBJeYhrHblBQ+iK2KMO7zKrxF2iGQoa0A8w8sWrPk8iG7eSRFy8BvcEVLadXHXzxNsS
	 nQv7FUPBHygES7fiveBEKt5Hag2eHfgT4RSbBzqd1XZVBIAU04yhdy4I73cSFzszNSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794658800;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=nkM3J4QAu8kIsGHpB1EKb0NRF0JxtY2T/gqGpQ/nt0Q=;
	b=QMy53bIvJulMTkjJ1wy3aMFytI0pB2NTagBwgOMq+e912zhOmBv3rxeQSAyvSBywORNU
	 IU7qwjourp/7Nhw5Tjvbb4fVYfgIkZ4tBBZaQdmqjnOIg+HyrFAFs555ettm/8DE4Wo5b
	 zuRXhvTuMGXZjn8PsTxQQRuyuU/CalF2X8MUUl/VuZ6nhbCHfS+R//mh3ydDZJIyau1sM
	 d7+mK5BEOhH8X5AmNV8z1o1Y8A4JiqfHMS2c6DC2suLS8eAHm4aJChCLJw3si7P8nKh05
	 cpWnA+REJ4QIBSb23MgrVSnxn2iwUCuwl8xx1XlbJI6yStkQ4NYe4NUlxKogHmVlJnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Zvg2B30u;
	arc=none smtp.remote-ip=209.85.218.52
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DBD0606A338
	for <target-devel@vger.kernel.org>; Sat, 14 Nov 2026 12:19:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3DBD0606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Zvg2B30u
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c169ae1cb26so387166066b.1
        for <target-devel@vger.kernel.org>; Sat, 14 Nov 2026 04:19:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794658797; x=1795263597; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nkM3J4QAu8kIsGHpB1EKb0NRF0JxtY2T/gqGpQ/nt0Q=;
        b=Zvg2B30uBzOFFo54OpfHCzqSK6TOyxTRmwNZV7t2nfrBwunaCrRH+5tI09/jIosXZS
         GdYk6iMfyO0nJ3moVzjaSKnXCCWxcV1Ye+R/4YjiwdwGG8ofIv4PWH24MjP/VV4CkNiq
         nSM7j6UNEdEDdNWpjUjn43q9YL/wt1IFltOrsPhL2VYrn8g/yyR7Uz6PFelA0j1tolIT
         QTqiv37OCVMy+5oEwlNBsw2cKiejzgZGAC7AZW2QPAu9cR2dMcfIteYf8vq02JyCIN53
         /PYiFz/vA+fp7KPo0fCiRfu55fCeLd5qLFIcUMGbAUVH1mkivaDzQTprXnn5n1PDT9pn
         6ZTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794658797; x=1795263597;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nkM3J4QAu8kIsGHpB1EKb0NRF0JxtY2T/gqGpQ/nt0Q=;
        b=bAPm6gyGt7qHZlw00Txh5h6CgHSIPvIEDJLNoxY2CCG168OLRBwuFREPkH7DuT6V1M
         D5YaFVnRNxWbwJuaw62t4LxH8W3Uy05vOOCjhIYolstXl6LtnjgVZcpjCcAeb/LkFPgu
         fBNcyqm18S9RztIRt53lvP1ieh98YeLjPxH4/4lkRCmE4vnauVEGYBICMXSQBrXhnBCP
         sP5lFo5RXS4xtVHfcgeHHlaEJlaHo0WqcmLc4bB9XgYRmfCckPewNSKzAVNzPwswDYnw
         68pOsD8SCGNm71rllGEbybgH/fyi5IGF5Rk/pSDj7sBgWjcHhdr+MbYZloV+OJWDwDKW
         lbyQ==
X-Forwarded-Encrypted: i=1; AL+hErEbZA8ShavR1nomqUrQxj2n8FyMp19B+J67lxESd6jXVOlOtZaRcYpOvn8izuhFqkwuHD8dStRSlH8FjWk=@vger.kernel.org
X-Gm-Message-State: APuU4Z9hv1AbV3dnRpEtLeArO4k8zKTtJDGbXxxMKMs2smtggkp1q0zd
	reJxnxOqKDkpdwlDFfrGbfWXlsg9+pVsW1j08UoVfieoNhyGocYCk5b+
X-Gm-Gg: AYBFou3kJceGm3VPpPuPxgCjoPFktksrKAbqn7OISvUtrZg/y+bnQ+NqctLAm62VsQ9
	CYSGG/rMejEfCJUDwHyYeaUlK+VjddsvvX4hd92KI+iOyK5IbJg2jXxLyHLTMY6xk71Lsj8LGoA
	Vvi1lxVyiw38uh4g+XNQiEB++/rzBsX7APXoSBGXr/w5nEQkCW/6vRSUcgEelYctcaoP9SH7cJk
	G63dNFlyzrZxn7zm4UzjW0P2RXsYha3G5s8iirFZV3poYCd+ygvMheZKTZIg/NWuX3PDKXrg/Co
	dKMw1RGgiRVd9WixDnjOjFsjYri30cFbw7jB/fEM1CRFPvKoUMb9dhLpglhxPXZY6G00cJnAQdD
	p+lnVyd+Grnf2hySPD9/l4RukH9VNymxnZdH4kvfxLHQanm/0XXqWIS/JRWDX/XffqoKsW3vzau
	eGmA4EazHGeBCzp28Jc4avk4uSZ4U0c/ZL5HDkp8pWaabiRPhu5djhddlqHClWiN1KRubvS2X1D
	Rl7bC5N4HYUO/errd3fyVZBaJ+oWfAfZzamNVl7NEYo92F+3jYySarK8Lt6DYvZWlcyixKc1Qky
	+bKn+NUuSFZBBCpuTj7755QFm9lqwTqtO4PnN41aqTL1Pm3CqHRr+Dfkr+QEpXRDQKTJ+2GGUYW
	LrnjZY2C93QcF
X-Received: by 2002:a17:906:1001:10b0:c41:4512:560d with SMTP id a640c23a62f3a-c5096387b02mr309942166b.16.1794658797424;
        Sat, 14 Nov 2026 04:19:57 -0800 (PST)
Received: from localhost (178-84-201-199.dynamic.upc.nl. [178.84.201.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b5ac2asm211518966b.55.2026.11.14.04.19.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 04:19:56 -0800 (PST)
Date: Sat, 14 Nov 2026 13:19:56 +0100
From: Amir Goldstein <amir73il@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Shakeel Butt <shakeel.butt@linux.dev>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org, linux-unionfs@vger.kernel.org,
	bpf@vger.kernel.org, linux-nfs@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 10/12] ovl: take freeze protection when storing the uuid
Message-ID: <avhR7DbNbVDCyPDO@amir-ThinkPad-T480>
References: <20261114-work-fs-frozen_writes-v1-0-f5ae61c898b1@kernel.org>
 <20261114-work-fs-frozen_writes-v1-10-f5ae61c898b1@kernel.org>
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
In-Reply-To: <20261114-work-fs-frozen_writes-v1-10-f5ae61c898b1@kernel.org>

On Sat, Nov 14, 2026 at 11:47:17AM +0100, Christian Brauner wrote:
> ovl_init_uuid_xattr() stores the persistent uuid in an xattr on the
> upper root. That happens after ovl_make_workdir() dropped its write
> access to the upper mount and before ovl_get_indexdir() takes it
> again. So a freeze of the upper filesystem that lands in between lets
> the mount modify a frozen filesystem.
> 
> Take write access to the upper mount around the xattr update.
> 
> Fixes: d9544c1b0d9e ("ovl: store persistent uuid/fsid with uuid=on")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Thanks,
Amir.

> ---
>  fs/overlayfs/util.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index 521717209b2e4..67aa7b71e9c83 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -829,8 +829,12 @@ bool ovl_init_uuid_xattr(struct super_block *sb, struct ovl_fs *ofs,
>  
>  	/* Try to store persistent uuid */
>  	set = true;
> -	res = ovl_setxattr(ofs, upperpath->dentry, OVL_XATTR_UUID, uuid.b,
> -			   UUID_SIZE);
> +	res = mnt_want_write(ovl_upper_mnt(ofs));
> +	if (!res) {
> +		res = ovl_setxattr(ofs, upperpath->dentry, OVL_XATTR_UUID,
> +				   uuid.b, UUID_SIZE);
> +		mnt_drop_write(ovl_upper_mnt(ofs));
> +	}
>  	if (res)
>  		goto fail;
>  
> 
> -- 
> 2.53.0
> 

