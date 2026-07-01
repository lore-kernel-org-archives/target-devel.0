Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57DA2F6184
	for <target-devel@vger.kernel.org>; Wed,  1 Jul 2026 07:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782889495; cv=none; b=BV8YezzDhvbS2IAB5WnDLn8rV2Ciz/18QrT5GqlrolgN8aTm0Voh1s/f0Q7SWa1jhsk448pdaeGPQj48JYureYcCMMvT/cwuLOt3SN3WWYZjeT7QSJTxY65jnXirL/T0zB+l0v8XFGaqH0Sf7PbTsu6AvwMuTOeKRH2fqS3JzZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782889495; c=relaxed/simple;
	bh=M+tlOieiqe9VTehuccEv9JoE5ofZu5aY/gM7zDk/je4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aOunrHX6baEKTYUjpAlb8tZYu3vSyyIlo1SgGcdUQE3VLIctkGygygxfHTOBRzFRlbjtDtiPisvyY9VacfEfi3v4Rz2oXuPyrOqm/YXqN5g3Qgw2PBBHiUdVTgbTBxn9lN50J2UkYkViqP4YOwZbAn3qybLl/U3jxqiqnAgXhzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LqlklFoX; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LqlklFoX"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4939a809b24so2787885e9.1
        for <target-devel@vger.kernel.org>; Wed, 01 Jul 2026 00:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782889492; x=1783494292; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Frs6Emcy9pNNZIaepK2NrL0xBcYA3u3r9RRnho4i+Lk=;
        b=LqlklFoXO3chnZZVCTCQs6nR2OsRc0J9Wx5l35ehS8wOGIVNhPvYiq2xc2q0Vkll8P
         ki18p7Uxb1TNJz3uvs/eQBzEMwQ40Lx8RszZONJn6cmQDXqj9CvUAsypFapxLgoA+gcH
         Q2B8sA+B11MCZc4YLmREXHgJB2fskRs6KyZaXgzGoGgZlfNmo57Wbhji+FOOCTPvbgUm
         OXXRNgk92pEytcZVGlFL84Bjz+V0G+ernOxV8Ynj8PI+zs2U1NkzDc9+RsYTIKZuWnQU
         bWlx4Rta2Xrv7fPFKknGuxJDGkgR+gdGrG6mlm8e/2YSloJvAxucP8iasmJtAjAvDzuI
         oieQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782889492; x=1783494292;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Frs6Emcy9pNNZIaepK2NrL0xBcYA3u3r9RRnho4i+Lk=;
        b=kILTi9yfFWl9F638sP+8g83O7ka8hWlLFYr1wgqBzQnrH01EctQke4QW44eb4wYVIG
         2GtPneuBJBhsZwkzkz57fcOXzmv1PtwxAg7zsvddnnY9mGL3dNpujlVZnhd35MWhQOAV
         y5zUKdHqB+Epnxfdp5d01S/JxfkIAYv1DjHsV38d0hTkOYgg/JXQuqG1h89npMdZf3AI
         DIrW5mCh0mBcI0ed4eEwoTgdEqHDsoA5qjYm1NaxkYCGHO4X5/aPuitNmn+acIKajCmF
         5wIM/KOTMVQRKhBFQlsegSSrGlPod0ah9XjgSv3HUn6WgBdq+//4nQSo9KXaUEdKOxi4
         QSbw==
X-Forwarded-Encrypted: i=1; AFNElJ8aC584Jf7tfp+00cSXVarcJOMoQ9lm8w0E0xkADO+DKC92/WtqGtUyDWqVm6rWTGyX3QAaAo3PDPsD50E=@vger.kernel.org
X-Gm-Message-State: AOJu0YwWb1rb/Y5xEL/iwjUHM1x8T5hA4YZIyL5KXlmlfsDRm9u6exFH
	DvjvSkGe7nhSWtZHuaoks+d/Becdm6A00tTyyVi5aN+Q6BAWYgRN6EAeIpH6h2ozA3A=
X-Gm-Gg: AfdE7cmOxIlCa8ipj7cYVDhkK/vJ4AX3ZFVjspFg9B8C7/HJVPdu0SkMOEnhxRj/VmD
	MCbSzeVvjHu4IS0kWtAh2pt7u1UhBxOBxLj7IFBKn3TQyqiEMRxBFu57E5HrrxkgtPKkGwUeXmB
	dOG67MfduQ2NcbEjNLwbQ9AYIvivFMdtQdaQS0UD2A3s/v30G93rWK4LrsNzel/mRS+8ag+LxPp
	MzrLQdivSyxteLHFUQL/CcAA4OiAJKY1ImLJdqyq9YPBtQC3CfVeKrqWMmotOvzuXALfQEIm33y
	rp9gXdhRJArTIOK3AOeDjLVwBnAUqJ9X226MHGvkswR5XXte2vRJcmwsp1p2WPNEvbqdllkRlzN
	1duuiCy79GC56Bb6deRI9EnpWLKlf4agnMZRfwy8yRAs4Rmsmc8cCb79AvgKunTyL95H8BwYBtC
	Z07biEcmwKvhiqSPF7/kN6KnJnmjAW5HwsrPRGEWXklmyGdKE=
X-Received: by 2002:a05:600c:3e14:b0:492:437a:a653 with SMTP id 5b1f17b1804b1-493c2b9022dmr4676775e9.26.1782889445790;
        Wed, 01 Jul 2026 00:04:05 -0700 (PDT)
Received: from ?IPV6:2001:a62:1403:d01:fcc2:cfc6:9af3:a0c1? ([2001:a62:1403:d01:fcc2:cfc6:9af3:a0c1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493be81df2asm94738895e9.12.2026.07.01.00.04.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jul 2026 00:04:05 -0700 (PDT)
Message-ID: <9bc4021f-0648-4cea-9f27-8ee2bd9e7088@suse.com>
Date: Wed, 1 Jul 2026 09:04:04 +0200
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] scsi: sym53c8xx_2: replace __get_free_pages() with
 kmalloc()
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Brian King <brking@us.ibm.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20260630-b4-scsi-v1-0-494fb37ebe7b@kernel.org>
 <20260630-b4-scsi-v1-4-494fb37ebe7b@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260630-b4-scsi-v1-4-494fb37ebe7b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/30/26 12:54 PM, Mike Rapoport (Microsoft) wrote:
> sym53c8xx_2 driver has an internal memory allocator for small
> allocations of the driver structures. The backing memory for that
> allocator is allocated with __get_free_pages().
> 
> This memory can be allocated with kmalloc() as there's nothing special
> about it to go directly to the page allocator.
> 
> kmalloc() provides a better API that does not require ugly casts and
> kfree() does not need to know the size of the freed object.
> 
> Performance difference between kmalloc() and __get_free_pages() is not
> measurable as both allocators take an object/page from a per-CPU list for
> fast path allocations.
> 
> For the slow path the performance is anyway determined by the amount of
> reclaim involved rather than by what allocator is used.
> 
> Replace use of __get_free_pages() with kmalloc() and free_pages() with
> kfree().
> 
> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>   drivers/scsi/sym53c8xx_2/sym_hipd.h | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.h b/drivers/scsi/sym53c8xx_2/sym_hipd.h
> index 9231a2899064..aa365e8ba66f 100644
> --- a/drivers/scsi/sym53c8xx_2/sym_hipd.h
> +++ b/drivers/scsi/sym53c8xx_2/sym_hipd.h
> @@ -1110,9 +1110,9 @@ sym_build_sge(struct sym_hcb *np, struct sym_tblmove *data, u64 badd, int len)
>    */
>   
>   #define sym_get_mem_cluster()	\
> -	(void *) __get_free_pages(GFP_ATOMIC, SYM_MEM_PAGE_ORDER)
> +	kmalloc(PAGE_SIZE << SYM_MEM_PAGE_ORDER, GFP_ATOMIC)
>   #define sym_free_mem_cluster(p)	\
> -	free_pages((unsigned long)p, SYM_MEM_PAGE_ORDER)
> +	kfree(p)
>   
>   /*
>    *  Link between free memory chunks of a given size.
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
