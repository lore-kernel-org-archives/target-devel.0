Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED993B2FF7
	for <target-devel@vger.kernel.org>; Wed,  1 Jul 2026 06:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782889097; cv=none; b=p48RbLY+o4/NXqKn1ZEDKl/MvQmxbsATC5/lVMz13hhOvMJBS5TpE3kIKv+2+8KC/YJxfrbmHM51xWMnv3UlfmM6UwCsmwfqfhM75khqTu8HJjFyIHwwERWFFrC9V6m8rrZaE6EAmTZpu87lmLIpi8L8Qb5WZAD9nftClTPKR/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782889097; c=relaxed/simple;
	bh=r5m6bx+1S+UH9/Jug1ZvzJIVBVwid5Doa+5SlCgkwB4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HOnEUs/Y/RY5NFKLUhWE1Elplay+z6/kb6AqjvRBJDTkMIhtr+VClPbDKgytmUlgxpbH8ScsKr6dq87w0dn2RxyzaP+33eKTxMYD9z+EGAQ7+J2HzlzJRBCiSKxBx4513g/UaYltSJGi+EwqLswH77WXsEhsS5QJ2QO+ucNSask=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Ar2o9mBx; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Ar2o9mBx"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-474303f3c72so155534f8f.0
        for <target-devel@vger.kernel.org>; Tue, 30 Jun 2026 23:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782889094; x=1783493894; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uM40CkIKzZOswsbi2LSbdjru0/A7oQAC4WYJATBuHvw=;
        b=Ar2o9mBxYp5gMqTnRq7etf2LP0scht+0GyyXIDK7mkABInc3j8qfZcXl81sH0hJNNB
         NNdDXEc280yQgDVTgKmHoC5tazl09unF/EF1arqknKOoW29eQY3F3J+IV0FoS1mhr0nV
         zQU7N99HBJvpp/0xioOVhSfmgFU02a1aZ0IMRt8WBMrfuiNIc+hh42Gc6Jyan0hKvqmZ
         Q/v0McgCgVDLh/YO+dRgL4mmF8+1wTIDt1Btvtut73YOvnAkxbn9b4M52NqiAjFiWDRp
         PpCt5ipsaIw7bya0p6/HfmJ0t9pF9tQFHrrDT2qIX+kENs9D26IBEkk9IO1ex1CfJzv6
         nh8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782889094; x=1783493894;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uM40CkIKzZOswsbi2LSbdjru0/A7oQAC4WYJATBuHvw=;
        b=bj05lL5chjeTZn7BLOfBbEXzFEjYjTd4ZF+niLBspwxmP4wLI4uwAJ4JAFtPH6WeuL
         g6wOfL0KCWCEn+bVfiHibsEKbkzI2aJjt0JQKMBmnn2XVqS4dK91+2U6yFTbBTgGOnpy
         7qUieaYBJPy9UuPl+WVeKVR+TvHQRfAPR8dyiXC/eZ+a4/Sn00fZWIm61AhQbaVnVsxF
         NgOGbwVkePCVukxBWINITld23Fmu4lM5Q3egdkiUGukFtXGZ57R0eioM8THo6DxmAzBZ
         GfyydVxKnW+PNoUnHHLOQ5O5a5gTo8b37slpAYqs3eqyDSnRYrixX3fHnK3zN+K58Zgb
         6Jhw==
X-Forwarded-Encrypted: i=1; AHgh+RpMEX/TsXxyNCB8nnbwy5QVtSa6Hmb0XzUB5MLJZn2+lmdLu+DDCWgCxEzuLPWYytVT4lQ8GSQXTsY14Kw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZBr8X+1KjF0i+0XfyRN77DkueRDuXupL3S2v/38tDpJHS0ZRc
	EkJtKyTPxwYfXKHl5nCPiJwPSeU+yHe5O1XsW4HRMX41Vzw6ZByCmWoJKIfb/c6EcmY=
X-Gm-Gg: AfdE7cn3n5gESy2X0x4G5f8vlDYlHKx2o6T64IEmmYoMjfPCxBiBTdT+fUrWgbWdR8n
	9UO/ZMMSdXaed4+X1+TVY5+TNT9YyRjWpqKDe4nniM0qIQZbIG+kaV3o/7nL2teDHtHNqlZcJn1
	lql2eCUsDEGod3UjOad92D9yf/oF4ALDiPJ4/O61qo+t+IVduuHiWmt0Rm3QaVytODAFxuREEXa
	48vpBTCTn7hdJoVGv2jCarmfVQoWIX1MqUd5pZXZclOdXxraadhc8F20kSaF0ryL4+8kOkGjvN9
	WFoZUqU+0n7LcQH0Zr1YsJH9XK8VEd2hgOYcKceVjV7c320fIZm90Z+sZXtIFAnw7ciWfDY/x01
	G17lZ+YzzenNrFJld+zii/xVLHJ9mPrKdjEKFx3iVpkk9Yx18gtzolp3RyQD1TN20CZpQonyWil
	sGYqqoRZU7StkTm4wI96dSXNsbLjvHd8HGGmzBchA6SOFhSCAR2Utl6nbF/A==
X-Received: by 2002:a05:6000:230f:b0:46e:98a7:232b with SMTP id ffacd0b85a97d-477573bbc16mr566600f8f.10.1782889094328;
        Tue, 30 Jun 2026 23:58:14 -0700 (PDT)
Received: from ?IPV6:2001:a62:1403:d01:fcc2:cfc6:9af3:a0c1? ([2001:a62:1403:d01:fcc2:cfc6:9af3:a0c1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4756636cf1asm15708450f8f.18.2026.06.30.23.58.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2026 23:58:13 -0700 (PDT)
Message-ID: <1f9329e4-dbe2-4d46-8387-b3c7fc8faab0@suse.com>
Date: Wed, 1 Jul 2026 08:58:13 +0200
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] scsi: target: file: use kmalloc() to allocate
 temporary protection buffer
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Brian King <brking@us.ibm.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20260630-b4-scsi-v1-0-494fb37ebe7b@kernel.org>
 <20260630-b4-scsi-v1-1-494fb37ebe7b@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260630-b4-scsi-v1-1-494fb37ebe7b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/30/26 12:54 PM, Mike Rapoport (Microsoft) wrote:
> fd_do_prot_unmap() uses __get_free_page() to allocate a temporary buffer
> that is used to invalidate protection info for the unmapped region by
> filling with 0xff pattern.
> 
> This buffer can be allocated with kmalloc() as there's nothing special
> about it to go directly to the page allocator.
> 
> kmalloc() provides a better API that does not require ugly casts and
> kfree() does not need to know the size of the freed object.
> 
> Replace use of __get_free_page() with kmalloc().
> 
> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>   drivers/target/target_core_file.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
> index 62ced9f5102f..ab9824a4852f 100644
> --- a/drivers/target/target_core_file.c
> +++ b/drivers/target/target_core_file.c
> @@ -516,7 +516,7 @@ fd_do_prot_unmap(struct se_cmd *cmd, sector_t lba, sector_t nolb)
>   	void *buf;
>   	int rc;
>   
> -	buf = (void *)__get_free_page(GFP_KERNEL);
> +	buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
>   	if (!buf) {
>   		pr_err("Unable to allocate FILEIO prot buf\n");
>   		return -ENOMEM;
> @@ -524,7 +524,7 @@ fd_do_prot_unmap(struct se_cmd *cmd, sector_t lba, sector_t nolb)
>   
>   	rc = fd_do_prot_fill(cmd->se_dev, lba, nolb, buf, PAGE_SIZE);
>   
> -	free_page((unsigned long)buf);
> +	kfree(buf);
>   
>   	return rc;
>   }
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
