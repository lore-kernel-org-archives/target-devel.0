Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D095A84E18
	for <target-devel@vger.kernel.org>; Wed,  9 Oct 2024 06:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728455592; cv=none; b=OKdAke5ehRaOR7tmp4I+VAXUpuYziJv0rGp8/mB0nc69YErqKVmL7xkCteFm0OubcG4Dm+V7/K8Qc7sHnriY3O9h9oInkAh+QOJirM0Mz3WaNoeAOMF0sBYNw+2xpxWNkKtf7MDm1mP6QmG8d4ct3mY7diopWdzLULTOQYIsvTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728455592; c=relaxed/simple;
	bh=zcso0n1fwQJ5K7SukIQ0M/KIuZ/VXnLQVd7mx4EGyYo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ii+UKQswyNvJoe5rFEEIGVgtiYryvSLHpjL2XvwWsT2tXaV3hLT+vJmGk7SiQreRr0HxqpU4zM0+MjbUYma78IVy7UwPnpPeMFvHbAmDDbGK56TujN6M+ua1cNdkZ81Uqb23cPxooI0C5zcxf17SXV9Ofvpbu/UQTnxbqxBIhhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eYkYx/JU; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eYkYx/JU"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a994cd82a3bso472844766b.2
        for <target-devel@vger.kernel.org>; Tue, 08 Oct 2024 23:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1728455589; x=1729060389; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qCAQRg3HcpyXhOpZxeffQqKdGs7ZmGM3kOVNHjlGOXw=;
        b=eYkYx/JUwkNEs/oTV6YEOcbQlgTG14JMXZdXkBI+yJtdrb+0wEn2nOROeOd3VFzi6a
         pf/rDY1IBBYFOnQZ5sG1BcQDtFwhwvw+FOYFTaM/6im+CzafZl/B3PbSLH2XVbjbJvhT
         Tz7T8IC+KyB8tN2TB8STtnCmBJDQ/SOlD/Xvatfw57O8R4FB3K55Zl4a08kQmOif7M11
         2vI4rWU3d3maa290V1jrJ3TYFcR16os30A4Tn4CfUbUU9VRFDosX+M3F4bxIJ0d1rx3x
         vgcMAdD6EaMeD2BSpg6QyobDuCkdmd3x6jX1f4qm9xXt+bQ7bS4089HqUlU9poVh7yZ8
         hXFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728455589; x=1729060389;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qCAQRg3HcpyXhOpZxeffQqKdGs7ZmGM3kOVNHjlGOXw=;
        b=U49dfaTDxQzACa4ZAc9u4Lz1sKfL5W9g4uAYx75sDxt3tLPQENWEcJoIsKR7YAiMWq
         Bmdgau4sxBqZ6qCrvU5OaBduqr0DURStOzG6MZZo7OMUV3KPxXD5zJ2oiwWcEt7r52BU
         J6E1eM608ZKPh5n11JJPnQ23KZmuttGt22do1cAx1/KrBOcBL8nxb8AwZmUa7jdMVal6
         b1VwUeo8pIQRT9kl7bX3akPa3qbzf5hhnxamPWucff4CsSDmt2AbE1QljvD25G941Qkb
         ceGctmdQ0T4db0heN1qtNpaaDuxPBergxqUPFaxoHwqyfhG6LZBR+wzusx7SBlEjm7mJ
         jnYg==
X-Forwarded-Encrypted: i=1; AJvYcCX0IQcn7eXl8xQr4gbNpCSSObLYH2DZdi0+1kqRGcCFZ7vKDc7K+TsBjmtvVSoihIrifqnEZL3umvV/o+Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YycDIV2sALYr6xnwjxDflL8Gcot9zoKxSI9uL1YP8d0AkuqE0Zr
	RukpOpLoK3iG8XG2kAJ+nw/P5wYl8JotzbR6VCLYq5foRVTyiWNzpY18mI2FIHE=
X-Google-Smtp-Source: AGHT+IGalhqCt7/kvjBSresOH2qgGqV6br8sm3eXxXn4MIHs0ivbgXYD8BYNan9BTjwOWFHb2irzDg==
X-Received: by 2002:a17:906:f582:b0:a99:3fa4:a683 with SMTP id a640c23a62f3a-a998d37617cmr85298666b.63.1728455589137;
        Tue, 08 Oct 2024 23:33:09 -0700 (PDT)
Received: from ?IPV6:2001:a61:2a51:d701:2d49:fdc9:7cfb:5cc8? ([2001:a61:2a51:d701:2d49:fdc9:7cfb:5cc8])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a993a7cfcfcsm564290566b.143.2024.10.08.23.33.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Oct 2024 23:33:08 -0700 (PDT)
Message-ID: <0bd644dd-d7c6-4dbf-b408-60b844443456@suse.com>
Date: Wed, 9 Oct 2024 08:33:07 +0200
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] scsi: qla2xxx: Remove incorrect trap
To: Anastasia Kovaleva <a.kovaleva@yadro.com>, target-devel@vger.kernel.org
Cc: njavali@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 bvanassche@acm.org, quinn.tran@cavium.com, nab@linux-iscsi.org,
 himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux@yadro.com
References: <20241008132402.26164-1-a.kovaleva@yadro.com>
 <20241008132402.26164-4-a.kovaleva@yadro.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20241008132402.26164-4-a.kovaleva@yadro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/8/24 15:24, Anastasia Kovaleva wrote:
> This BUG_ON() is triggered when there is no fc_port with a certain
> loop ID in the scsi host vp_fcports list, but there is one in
> lport_loopid_map. As these two data structures do not change
> simultaneously and atomically, such a trap is invalid.
> 
> Cc: stable@vger.kernel.org
> Fixes: 726b85487067 ("qla2xxx: Add framework for async fabric discovery")
> Signed-off-by: Anastasia Kovaleva <a.kovaleva@yadro.com>
> Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
> ---
>   drivers/scsi/qla2xxx/qla_target.c | 10 +---------
>   1 file changed, 1 insertion(+), 9 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> index bc7feef6ee79..9a5dbd00de01 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -5190,15 +5190,7 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
>   		ql_dbg(ql_dbg_disc, vha, 0x20fc,
>   		    "%s: logo %llx res %d sess %p ",
>   		    __func__, wwn, res, sess);
> -		if (res == 0) {
> -			/*
> -			 * cmd went upper layer, look for qlt_xmit_tm_rsp()
> -			 * for LOGO_ACK & sess delete
> -			 */
> -			BUG_ON(!sess);
> -			res = 0;
> -		} else {
> -			/* cmd did not go to upper layer. */
> +		if (res) {
>   			if (sess) {
>   				qlt_schedule_sess_for_deletion(sess);
>   				res = 0;

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

