Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F4C55E53
	for <target-devel@vger.kernel.org>; Wed,  9 Oct 2024 06:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728455435; cv=none; b=F9/cEOVTCzEMlLPGoTdQHj1u3Rnfcud/2EwMxdReARyPc7zRw84dHiAZSltQX3bI6bul1oODgDlg1d2NrPBTKhvjggK9aXhYcdmviZqsPJbE21SD/U1/KR6zBEk1aaxJp0zMSxryULHOG4mxVx00iZ7nrlWyH0RSt3Co0B8ogvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728455435; c=relaxed/simple;
	bh=UA+nhOKrvPaVSedr02lSqCKSfRhowcU0PUDZ58k9fRs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kYrSnh2xtioDhStmKjYeew6QKWXJEHIB/0g0HtUDeocBqbcblB1KAMD9B5M/mBYCnRyRu3oW3I++S3n+DxJStmKEMqlyf6RND9O5BTqE5bZwgyA8HjOC/wlJXdv0ytzXXZsZN0IenMDJjd0d/rziCJ6W/SzR5jtasRd73F/6/4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SGdKnp6+; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SGdKnp6+"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2fb18f14242so4030631fa.3
        for <target-devel@vger.kernel.org>; Tue, 08 Oct 2024 23:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1728455431; x=1729060231; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BT61mqzWa/Vplik9tb6XjJgFQUw+Q5nF5lXcNmSEzsU=;
        b=SGdKnp6+W8ukGKnJ2epD459rmAP7VqP5mXBy18ZF/wadxzv76zaxSNX3cxHR/eAcsk
         4lzOHeXm1fOV8rVstv/fd49hxqFCmwGhtXDf1yfmrERmLjcNKehHlxTbXC3IiygMQKUn
         3S4a0IZswKwciZuJHcc2gd9Dl32ifwl2e5/etCIIRJOykrBFtZQWA9in0U5/5CczYS9M
         skKxKNgj0usG1PukLyw5SLoxGGs4lm3hIZRp9bkPvPjLUVoT5Jp4RZj32cslaNlGQrfe
         syW97ZPmz2NdsMxBMazahAbPQBd9snxzWCJw7xOKBLPc0EirBuQiphGDuxlJprTJi77L
         +xlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728455431; x=1729060231;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BT61mqzWa/Vplik9tb6XjJgFQUw+Q5nF5lXcNmSEzsU=;
        b=lIirqe9L9+IlpJHS8+p16ua/mZ106Tq17fzzrocxMe4tBZ5aC5ctm3lzjVMe1uxpC6
         PJ7Mc8BrJ7TLKdYCDC3deqebzRBqsXx0ePcL272nDMKTFI1NWjJwxwqAS4HW4TiIcV7f
         zJROZ9obtdLwFkxtNf3sAS3JSDpx7XG5XokEh+WiIvBaLO6Y+RO2yGdKlqAnYkWKKCA+
         wOP9oBh1hfugBuuPiq2OTkjNX0RacwQTnK1mbLps+JpAVjt7AX3Smj6kEe+3qpI02KcS
         qGkafrMhBX65LYWKJ8s35Z8Vd2/FeQfwdBlgb/VF6+oYbce9Ryb12oxoSSrb/0cLnIvH
         2Zog==
X-Forwarded-Encrypted: i=1; AJvYcCXiBMvWlLN/UCHXejxN0sw2QOFdDq/nuKyAxLWPdEgwe8xvAFXVtva8VQTTIGYRzwcDAZCn8E2cxN4kTo8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWdSyqvRdeDgKxk9Mj/hn6kvS1qX+TZsk81Fid5oER/XoLsJxX
	AjVgLYK/KnI94ftTzeeiyADd5zbjQBn9f4iCA+GiUtV7M0nQ+8N0y9QZmYhjrlA=
X-Google-Smtp-Source: AGHT+IFnss7Rt8sKnZ+AYU3P80OInifkc1mksDwCq/WzXeOIAU7NW2wbqD0zcKMnC0fsN6+zzj4rmg==
X-Received: by 2002:a05:6512:1090:b0:533:455c:8a49 with SMTP id 2adb3069b0e04-539c4948d61mr642592e87.38.1728455430661;
        Tue, 08 Oct 2024 23:30:30 -0700 (PDT)
Received: from ?IPV6:2001:a61:2a51:d701:2d49:fdc9:7cfb:5cc8? ([2001:a61:2a51:d701:2d49:fdc9:7cfb:5cc8])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c8e05bd4dcsm5072933a12.49.2024.10.08.23.30.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Oct 2024 23:30:30 -0700 (PDT)
Message-ID: <ee878956-852b-4be6-b7f9-94cdea5e94dd@suse.com>
Date: Wed, 9 Oct 2024 08:30:29 +0200
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] scsi: qla2xxx: Drop starvation counter on success
To: Anastasia Kovaleva <a.kovaleva@yadro.com>, target-devel@vger.kernel.org
Cc: njavali@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 bvanassche@acm.org, quinn.tran@cavium.com, nab@linux-iscsi.org,
 himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux@yadro.com
References: <20241008132402.26164-1-a.kovaleva@yadro.com>
 <20241008132402.26164-2-a.kovaleva@yadro.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20241008132402.26164-2-a.kovaleva@yadro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/8/24 15:24, Anastasia Kovaleva wrote:
> Long-lived sessions under high load can accumulate a starvation counter,
> and the current implementation does not allow this counter to be reset
> during an active session.
> 
> If HBA sends correct ATIO IOCB, then it has enough resources to process
> commands and we should not call ISP recovery.
> 
> Cc: stable@vger.kernel.org
> Fixes: ead038556f64 ("qla2xxx: Add Dual mode support in the driver")
> Signed-off-by: Anastasia Kovaleva <a.kovaleva@yadro.com>
> Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
> ---
>   drivers/scsi/qla2xxx/qla_isr.c    |  4 ++++
>   drivers/scsi/qla2xxx/qla_target.c | 11 +++++++++++
>   2 files changed, 15 insertions(+)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index fe98c76e9be3..5234ce0985e0 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -1959,6 +1959,10 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
>   		ql_dbg(ql_dbg_async, vha, 0x5091, "Transceiver Removal\n");
>   		break;
>   
> +	case MBA_REJECTED_FCP_CMD:
> +		ql_dbg(ql_dbg_async, vha, 0x5092, "LS_RJT was sent. No resources to process the ELS request.\n");
> +		break;
> +
>   	default:
>   		ql_dbg(ql_dbg_async, vha, 0x5057,
>   		    "Unknown AEN:%04x %04x %04x %04x\n",
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> index d7551b1443e4..bc7feef6ee79 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -6801,6 +6801,7 @@ qlt_24xx_process_atio_queue(struct scsi_qla_host *vha, uint8_t ha_locked)
>   	struct qla_hw_data *ha = vha->hw;
>   	struct atio_from_isp *pkt;
>   	int cnt, i;
> +	unsigned long flags = 0;
>   
>   	if (!ha->flags.fw_started)
>   		return;
> @@ -6826,6 +6827,16 @@ qlt_24xx_process_atio_queue(struct scsi_qla_host *vha, uint8_t ha_locked)
>   			qlt_send_term_exchange(ha->base_qpair, NULL, pkt,
>   			    ha_locked, 0);
>   		} else {
> +			/*
> +			 * If we get correct ATIO, then HBA had enough memory
> +			 * to proceed without reset.
> +			 */
> +			if (!ha_locked)
> +				spin_lock_irqsave(&ha->hardware_lock, flags);
> +			vha->hw->exch_starvation = 0;
> +			if (!ha_locked)
> +				spin_unlock_irqrestore(&ha->hardware_lock, flags);
> +
>   			qlt_24xx_atio_pkt_all_vps(vha,
>   			    (struct atio_from_isp *)pkt, ha_locked);
>   		}

Why not just 'WRITE_ONCE()' and drop the spinlock?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

