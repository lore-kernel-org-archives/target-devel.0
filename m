Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7602CF4E3
	for <target-devel@vger.kernel.org>; Mon, 12 Feb 2024 08:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707725295; cv=none; b=JG5yZqb9SbpQfU86oi/CUVO1rHgZ+q/hk/WWYR3NeFAfFb+cFMY3EmdZhH/acOPueEtu3N+Vt6AWT4Os8UQ1Up8szens8wt2GgUgbez15wKpUB4LTLDg6FIIXxWG81Nk3E/uK8sr2fC7+VH34UYwIKdcUDQnRnHWiiwPPcOeaQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707725295; c=relaxed/simple;
	bh=OxCIciPqR2CGxmJVs+ARy66BdHyf2bhD9db1C9DMqy8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pImVWSh9BlPJiBTdCjRHzfGd4n09NpFNKOnUyNUOfwkU23QsY9oE9/PcPVYhYBcRz7kI18C1e4BWjgr8kkqW6NZh2kYvMQbZC5KxKLxL7VAIJwCaS9nWsGDoj8gdpzj/BFmKc508ivT2FpwkocXn7fEuYv27/CA1DnEKbFR1gGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZvfoGVcX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZvfoGVcX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707725291;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RWCguNETcrfTBiAY5f9wJsa/D0Q5D3XV8r2NEo/B7go=;
	b=ZvfoGVcXjcTUzVu2uThb4Ab2K4RalDnWbqPLZ6d/efVP9O6B99aIJZzZZ3zgHneaPZQOxY
	0w3gB81NFDgOZ6teKKldvxOkWLkkRO9bBNMKQ59hf3Fj2uEP347TzUB03iEK4rrOJp412X
	dckqu0nwjiSNnG7cs47BdHHIN46aMuk=
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com
 [209.85.217.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-170-Noh4MR5YNC2ZMYqEr78e8g-1; Mon, 12 Feb 2024 03:08:10 -0500
X-MC-Unique: Noh4MR5YNC2ZMYqEr78e8g-1
Received: by mail-vs1-f71.google.com with SMTP id ada2fe7eead31-46d2c0e3691so572110137.3
        for <target-devel@vger.kernel.org>; Mon, 12 Feb 2024 00:08:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707725289; x=1708330089;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RWCguNETcrfTBiAY5f9wJsa/D0Q5D3XV8r2NEo/B7go=;
        b=mOJllqDOTHi2nljWC/Z4qCg9DgY1EnU+1ZolnUkc35VJI3zqPJbZlVX4vCuD3K/VH/
         hSseXK+z3XbNDLdxkVtwluYQ+UoXWyzssILuXAj9C4bw8V2s2bvDF5BffCWitwyA9aqr
         q+TgZG4HJnk4KrkOluiB7s6pASxvOUXIABRh8vMnvW3LBPHFzjhSBIStVbZIv7iHF+x5
         Lj3W+ATDztf3NRCuoDYkh+G8npFzU8TA7zodktA5mbyuhV8ugFXUseqJv0ZBeSeD7eMb
         qwYZkfSdtGJtpdm7d+ptwt+eV/jCMIrfb/8b4Srdt2qfaDlUsQst0ORw4s5B17tdy6VM
         JG/g==
X-Forwarded-Encrypted: i=1; AJvYcCXiGMikUOYaapgV+xPHVp6aykz6O/HGKgbvUePbH5PanN4NW8mNOrWj0MQDXQYi2mQ/UbnhMOTJhI+VVjRjYuuxeCPKr8DgJUHICPEg
X-Gm-Message-State: AOJu0YzuQuRLrmEFTUxumU0N+cfqe5jrH4k4vvFqbRPdP41ZU+GkwhbH
	CUE3q7AoLdFuJCasYGFygA3nerLdvrf1ePwUjb5sLv4k4/UfrR6b1LNx6kS5Sdie9cLW65c6Hxx
	kt9DJA5ohEG+mIAAKw/iVvxDiSaDQPP32MNGVaJgR2KmOajv3GuFw0Xb5d5zH06Ygg8aFCzSLQ/
	NOfF0DCxefaeu+f0XXSCUBamtCEuM4HDkEHPoH
X-Received: by 2002:a05:6102:2828:b0:46e:ba1f:a754 with SMTP id ba8-20020a056102282800b0046eba1fa754mr657347vsb.12.1707725289551;
        Mon, 12 Feb 2024 00:08:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEXucn9iVS5eHX0jo5XJu2W7Duyw6MqNBJ/IF9kFHf21qeDdQhXhkbgYn78g5Nebb1aAapGztgSv3G3jtGCqmU=
X-Received: by 2002:a05:6102:2828:b0:46e:ba1f:a754 with SMTP id
 ba8-20020a056102282800b0046eba1fa754mr657339vsb.12.1707725289280; Mon, 12 Feb
 2024 00:08:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240209215247.5213-1-michael.christie@oracle.com>
In-Reply-To: <20240209215247.5213-1-michael.christie@oracle.com>
From: Maurizio Lombardi <mlombard@redhat.com>
Date: Mon, 12 Feb 2024 09:07:57 +0100
Message-ID: <CAFL455mRRFUEiSKXsHkRUMVu4vRz4cFOJBzDCs1DU6=rZ5SjUw@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] scsi: target: Fix unmap setup during configuration
To: Mike Christie <michael.christie@oracle.com>
Cc: d.bogdanov@yadro.com, me@xecycle.info, target-devel@vger.kernel.org, 
	martin.petersen@oracle.com, linux-scsi@vger.kernel.org, 
	james.bottomley@hansenpartnership.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

p=C3=A1 9. 2. 2024 v 22:52 odes=C3=ADlatel Mike Christie
<michael.christie@oracle.com> napsal:
>
> This issue was found and also debugged by Carl Lei <me@xecycle.info>.
>
> If the device is not enabled, iblock/file will have not setup their
> se_device to bdev/file mappings. If a user tries to config the unmap
> settings at this time, we will then crash trying to access a NULL
> pointer where the bdev/file should be.
>
> This patch adds a check to make sure the device is configured before
> we try to call the configure_unmap callout.
>
> Fixes: 34bd1dcacf0d ("scsi: target: Detect UNMAP support post configurati=
on")
> Reported-by: Carl Lei <me@xecycle.info>
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>
> v2: Fix missing configure_unmap handling so failure is returned.
>
>  drivers/target/target_core_configfs.c | 48 ++++++++++++++++++---------
>  1 file changed, 32 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/targe=
t_core_configfs.c
> index a5f58988130a..c1fbcdd16182 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -759,6 +759,29 @@ static ssize_t emulate_tas_store(struct config_item =
*item,
>         return count;
>  }
>
> +static int target_try_configure_unmap(struct se_device *dev,
> +                                     const char *config_opt)
> +{
> +       if (!dev->transport->configure_unmap) {
> +               pr_err("Generic Block Discard not supported\n");
> +               return -ENOSYS;
> +       }
> +
> +       if (!target_dev_configured(dev)) {
> +               pr_err("Generic Block Discard setup for %s requires devic=
e to be configured\n",
> +                      config_opt);
> +               return -ENODEV;
> +       }
> +
> +       if (!dev->transport->configure_unmap(dev)) {
> +               pr_err("Generic Block Discard setup for %s failed\n",
> +                      config_opt);
> +               return -ENOSYS;
> +       }
> +
> +       return 0;
> +}
> +
>  static ssize_t emulate_tpu_store(struct config_item *item,
>                 const char *page, size_t count)
>  {
> @@ -776,11 +799,9 @@ static ssize_t emulate_tpu_store(struct config_item =
*item,
>          * Discard supported is detected iblock_create_virtdevice().
>          */
>         if (flag && !da->max_unmap_block_desc_count) {
> -               if (!dev->transport->configure_unmap ||
> -                   !dev->transport->configure_unmap(dev)) {
> -                       pr_err("Generic Block Discard not supported\n");
> -                       return -ENOSYS;
> -               }
> +               ret =3D target_try_configure_unmap(dev, "emulate_tpu");
> +               if (ret)
> +                       return ret;
>         }
>
>         da->emulate_tpu =3D flag;
> @@ -806,11 +827,9 @@ static ssize_t emulate_tpws_store(struct config_item=
 *item,
>          * Discard supported is detected iblock_create_virtdevice().
>          */
>         if (flag && !da->max_unmap_block_desc_count) {
> -               if (!dev->transport->configure_unmap ||
> -                   !dev->transport->configure_unmap(dev)) {
> -                       pr_err("Generic Block Discard not supported\n");
> -                       return -ENOSYS;
> -               }
> +               ret =3D target_try_configure_unmap(dev, "emulate_tpws");
> +               if (ret)
> +                       return ret;
>         }
>
>         da->emulate_tpws =3D flag;
> @@ -1022,12 +1041,9 @@ static ssize_t unmap_zeroes_data_store(struct conf=
ig_item *item,
>          * Discard supported is detected iblock_configure_device().
>          */
>         if (flag && !da->max_unmap_block_desc_count) {
> -               if (!dev->transport->configure_unmap ||
> -                   !dev->transport->configure_unmap(dev)) {
> -                       pr_err("dev[%p]: Thin Provisioning LBPRZ will not=
 be set because max_unmap_block_desc_count is zero\n",
> -                              da->da_dev);
> -                       return -ENOSYS;
> -               }
> +               ret =3D target_try_configure_unmap(dev, "unmap_zeroes_dat=
a");
> +               if (ret)
> +                       return ret;
>         }
>         da->unmap_zeroes_data =3D flag;
>         pr_debug("dev[%p]: SE Device Thin Provisioning LBPRZ bit: %d\n",
> --
> 2.34.1
>

Reviewed-by: Maurizio Lombardi <mlombard@redhat.com>

