Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F3422DA18
	for <target-devel@vger.kernel.org>; Thu, 22 May 2025 09:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747905091; cv=none; b=KTYCS1+BojnWpkQP4Z+Vg1M8uAGDcpr5Dk3LWCikZj2bCNtfXXLGr6eVyRBxR4X2Fjoz9yhWub25YqGus2nLYCc6U7r5RJz6dJdWg7CgCnH9NyoWNVO7tISi7aQyjADEGmFDMRc+flCz+hDK2JEHbgcXqAgANNE372529MbF1Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747905091; c=relaxed/simple;
	bh=ZDC9x4MYunxqEojxt2QMnAUa/sa1GbM7hsgeW5aenQ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RtO1eicSM/Od79eD2ikX9UKBZ9dqHpx7W26/kS7Mu1S9CC3UwXk1THPd5GaZIibfeKHs5Zj5JqQMNGJVjHRGVadm14B/zvDjVqBBTFtHYqCKOnlD2+mIShd6MD95p3a6qPjCZh+iZDVZDEsOIdi5xfs3QP8oGQVnMgwlyEFo9PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d0RkTwnL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d0RkTwnL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747905088;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Efw/xOoBR5JtsAGWTbkGb39F5QrJRSJy0Aiy1rPkylA=;
	b=d0RkTwnLqSfj3Fchi08koiFF1bUS0ZYlIgM/GNhR1Y13qYukU1EOmapWj7fQLJqamI8sRj
	RvbS366oTj1FIHYXBTkgj+d8E0MEoHGXeUTAyIQoaDilumkmo5HNl0lnXIOCWkCHOkbeJD
	z8fNqrXBRtlmXpR+IU57searNgtoRvU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-433-OJgq5ja0MVuGwdAb8aqMdA-1; Thu, 22 May 2025 05:11:24 -0400
X-MC-Unique: OJgq5ja0MVuGwdAb8aqMdA-1
X-Mimecast-MFC-AGG-ID: OJgq5ja0MVuGwdAb8aqMdA_1747905084
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43d0830c3f7so56734125e9.2
        for <target-devel@vger.kernel.org>; Thu, 22 May 2025 02:11:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747905084; x=1748509884;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Efw/xOoBR5JtsAGWTbkGb39F5QrJRSJy0Aiy1rPkylA=;
        b=W5WC4dW9cMgyaPIP88TEOXuRz6QfSKzAHeEMLAUlkRckHOe3HxcMEnwTG1bI14nBWO
         hBgDCe7aVMOtb4XBdGsl2KAybzyMO6b5uzRhKJuJRwn6dmUQ+Cu4TjDP0CYjsdi9C6ba
         GH0AMGN1VH4ODGID5zspxnlmb0stXTT7Dqw2ylJ+KByLUldvfZ8H/XC+pvkGTjg4dea9
         FpIObOdREJMeUBsPVLZ9rQBQ7AbGkGvPGmMun7IkfTKeKUgVjSsjJt8b4Hc+SsgseYOb
         2QyXu1ZbV+nPrS0OxOyKTcF6Xkm+D51z9YO6vSBtln1WCrMfUkfivwXdUEy2/xzAEbmJ
         sILw==
X-Forwarded-Encrypted: i=1; AJvYcCUSzCUxczRYAH7zlC2eJRtMhiqO1IEUBhYLwax/SKUq6/BVN+i0vWriWEjEqcrhSG87saQ33A3hrCcLvRc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7zB4L6vZo6TLjljtcbm6GxBMgPYjHennavh5KQBEHaCFEKSWS
	byL5F31OfxQT3piGCEQYaSlwGk0ZijpDQuQti4X4wD3dgU8dSpj8EagX9B8JpQusLWZyt/aMOWC
	cj/n9sXx1LUZnwmsF+nBi6jfhFb3WzQpqh3U5j4pJbRsl0CnoduxzROUakWLRLIMv+w==
X-Gm-Gg: ASbGncvm7WPNvUL0msmM8FwesV5Zrir0I/mxa3kEm+QH4A9zTR/rgnghql+AcdGg+fO
	5IE1SPlHxnztoFq1HHGrfom+tibN/AiMp2HSdGN3O8Y7V4KzrfCDXD6dTLqqpkkRmsPnz36I1sW
	XWm0z4nxV05DSbFtdUYw2BMEmKTLESgY47lEwTciQV9SXR/TfllGkXqpy9rkIAWHqYbUguKQavx
	Z4j6iK+4QPS0etnPr1vhkcwsUtroHBK3RnYT47IVeyBiimh7Q3evN2+orO070n60F05oMMbydnj
	SjaoZz+79HfYmSpykl4=
X-Received: by 2002:a05:600c:a016:b0:441:d2d8:bd8b with SMTP id 5b1f17b1804b1-442fd622c81mr247895345e9.8.1747905083664;
        Thu, 22 May 2025 02:11:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEciTJ/zcRf4AXElu0pqBhYj5jKqeehae3NT83Gy64LvlkBARBipL5idMvjE3WFf06oe/P65g==
X-Received: by 2002:a05:600c:a016:b0:441:d2d8:bd8b with SMTP id 5b1f17b1804b1-442fd622c81mr247894945e9.8.1747905083275;
        Thu, 22 May 2025 02:11:23 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:247a:1010::f39? ([2a0d:3344:247a:1010::f39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-447f6f05581sm97329145e9.13.2025.05.22.02.11.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 May 2025 02:11:22 -0700 (PDT)
Message-ID: <f8640da1-c442-4704-8f0a-8d498e1b7e16@redhat.com>
Date: Thu, 22 May 2025 11:11:20 +0200
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 net-next 5/6] socket: Replace most sock_create() calls
 with sock_create_kern().
To: Kuniyuki Iwashima <kuniyu@amazon.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Willem de Bruijn <willemb@google.com>
Cc: Simon Horman <horms@kernel.org>, Kuniyuki Iwashima <kuni1840@gmail.com>,
 netdev@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
 Juergen Gross <jgross@suse.com>, Stefano Stabellini
 <sstabellini@kernel.org>, xen-devel@lists.xenproject.org,
 Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 ocfs2-devel@lists.linux.dev
References: <20250517035120.55560-1-kuniyu@amazon.com>
 <20250517035120.55560-6-kuniyu@amazon.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20250517035120.55560-6-kuniyu@amazon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/17/25 5:50 AM, Kuniyuki Iwashima wrote:
> Except for only one user, sctp_do_peeloff(), all sockets created
> by drivers and fs are not tied to userspace processes nor exposed
> via file descriptors.
> 
> Let's use sock_create_kern() for such in-kernel use cases as CIFS
> client and NFS.
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>

The change makes sense to me, but it has a semantic change, let's add
more CCs.

Link to the full series:

https://lore.kernel.org/all/20250517035120.55560-1-kuniyu@amazon.com/

/P

