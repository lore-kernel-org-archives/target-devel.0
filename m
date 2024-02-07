Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE501B270
	for <target-devel@vger.kernel.org>; Wed,  7 Feb 2024 10:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707302449; cv=none; b=OugysON9g25DshG42IVqm/zgkkwuWiHCLpiG2UxGRaGvZ5L7/zv1qewaVW4BdBOCcZwHluQNLiRuN6KhjPOG9sG0CApFN/Gvj0pmVieQWnZ+vUqbJ6hoG/qwnJphbIySHIVuv8gDf/HD41xoAMI2vK4xz8Bi01t7hTkeqC08LNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707302449; c=relaxed/simple;
	bh=y7mfnDkpkBX9UzT7rvEawvP3Nzr1YWsD+mlYAX5Q0Io=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ek0E75uzA3zrPckOkV40N8y0QSGoG0AXy8OYEv69LBn6xnPEUAqikZ6t6IulbHmhkJw3groW8IUcIZQGLaBgskQO4J2Pe7EytOaT9RrKirpwQOE+CUJU21tp0zXMhsal7cZj9YYAq7usdAElG3Yop7YmwaozNsCr0rjyX4sknbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fHi5gpX/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fHi5gpX/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707302446;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D8D95Wv2uFhy3JNCjiYOnY3j4dsKXxlHj6HBfXvMeto=;
	b=fHi5gpX/4cFQolq2cdGF2XgbPtHEZ3dAkDpLNXHAKTx2s8zH0pYfXpSNhyFCBfl5OqoKAi
	6g5Qffh9mle7VB58iD2iod2mz1o1ssu0P+cFFnqX/gS36BrCwrTJsy1vVmej09hEfD8rnQ
	Wkk7uoIUletTYlR2kFw48b0DotMN2mM=
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com
 [209.85.221.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-356-1RiOQ3dIOUaPZQNpIW4iIw-1; Wed, 07 Feb 2024 05:40:45 -0500
X-MC-Unique: 1RiOQ3dIOUaPZQNpIW4iIw-1
Received: by mail-vk1-f199.google.com with SMTP id 71dfb90a1353d-4c031359125so1584781e0c.0
        for <target-devel@vger.kernel.org>; Wed, 07 Feb 2024 02:40:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707302444; x=1707907244;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D8D95Wv2uFhy3JNCjiYOnY3j4dsKXxlHj6HBfXvMeto=;
        b=s3a/+AK7phofJb9JUyJNfnYUCMrvVVLEWRncgGw9kFiCFIp4Fndi2yoyrVEImVOEub
         VmtLdEjU/LSP17QlPV5fURgZ+zbYvrth+rBnAIKs+1oigSJd6lCC4z5aY3QT5VZ7kMnR
         /yF4Ur3N4acTYwTmjcoIM2TGd+zd5ypUG5fwC0/XD+rkXFsGBnefOqs+1Z+H+0ePePXF
         9geCoVFnlV35AG47YcrO41LjKV3OLBs7xU13u3oxEeQHDhTilhHNMoEk6LRGaa5dMRGf
         yGJlneX3fsM34dLNy9BV2s20Naqc+6LfzpaBrnPw+4CgV0viMR//N7gTqGXGMN2kK7O7
         QXsQ==
X-Gm-Message-State: AOJu0YxGQfps3SHHBVylFniwQ23PuC7vcmRv9ccLwvJ1sCbW45N2wuAA
	tp28MMis7525npBgivq8uyvPrLUeHTiJLBwyhbKCd25fxC/EpdAIL1P0EOe93LgaHAJM1K+59Nk
	DRDc+HuhOZdiLDKhnpZXRq6ihA7/53Wqdk8cMq3/FXDkOlO1VxafD6RMcq4C7WFApkiL0DmaKgq
	SnkX3jcbVdfqJyfp2ACb3lAVKKag0O+03muEzD
X-Received: by 2002:a05:6122:c96:b0:4b6:dbc2:1079 with SMTP id ba22-20020a0561220c9600b004b6dbc21079mr1573158vkb.0.1707302444592;
        Wed, 07 Feb 2024 02:40:44 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEfejQaK4aq55exy2XCBo4m6y6EkX6aYpyYLsWL0ix6y4nkZXQ4E5fDliKxJO3YJcqwURzU4vygUFKNQIQ0Afo=
X-Received: by 2002:a05:6122:c96:b0:4b6:dbc2:1079 with SMTP id
 ba22-20020a0561220c9600b004b6dbc21079mr1573148vkb.0.1707302444351; Wed, 07
 Feb 2024 02:40:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240207021919.7989-1-michael.christie@oracle.com>
In-Reply-To: <20240207021919.7989-1-michael.christie@oracle.com>
From: Maurizio Lombardi <mlombard@redhat.com>
Date: Wed, 7 Feb 2024 11:40:32 +0100
Message-ID: <CAFL455m_+s7nHA_FYFHzadb-qWf3VLdCqatGFbWHY1YCeuv3nw@mail.gmail.com>
Subject: Re: [PATCH 1/1] scsi: target: Fix unmap setup during configuration
To: Mike Christie <michael.christie@oracle.com>
Cc: me@xecycle.info, target-devel@vger.kernel.org, martin.petersen@oracle.com, 
	linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

st 7. 2. 2024 v 3:19 odes=C3=ADlatel Mike Christie
<michael.christie@oracle.com> napsal:
>
> +static int target_try_configure_unmap(struct se_device *dev,
> +                                     const char *config_opt)
> +{
> +       if (!dev->transport->configure_unmap)
> +               return 0;

With this patch, if the configure_unmap callback is NULL then we
return 0, implying that discard is supported.

Before, a NULL configure_unmap callback triggered an error:

        if (flag && !da->max_unmap_block_desc_count) {
                if (!dev->transport->configure_unmap ||   <<------
                    !dev->transport->configure_unmap(dev)) {
                        pr_err("Generic Block Discard not supported\n");
                        return -ENOSYS;
                }
        }

Shouldn't you return -ENOSYS in target_try_configure_unmap() if
configure_unmap is NULL?

Maurizio

