Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFDA32AE68
	for <target-devel@vger.kernel.org>; Thu, 25 Sep 2025 12:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758804598; cv=none; b=j1Ct3cuqi6j71QQRAFF/JlU33buqo7qRCFjnU3UP/eC2dj6i7kKO+dKRXczLm2RN+8oXqvFMX2Fhsw2AQZDgBAl9wmV0CNIxIhomU6A34Nw38J5RGK9Cro13UoHgt2lbFw49xfFJoMhJu9nJwdJchNwlFui9civd24jIKPSs1Do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758804598; c=relaxed/simple;
	bh=MF54MGCuDfi8gReEhm6Ls7UVrLmOKS7TeRw9elzcLcQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=It3VHH6+ibm0SVl7y6ohFKew+T8Nthk39wFfxZpPJ7katHLeEX+CeHJD1yx7obSvnhYxYmNjSAJCOjW+5Ag+dWQkTRYjy/5FDDwjMiNiul8MxmfiRvZUh8rK1gjmGwEl82RFqBz6/rkcBM9qnNdDUsHaF16FuttA+loQkZbaXBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A8CmWYcb; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A8CmWYcb"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-46e34b0841aso961325e9.0
        for <target-devel@vger.kernel.org>; Thu, 25 Sep 2025 05:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758804594; x=1759409394; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uDHkDpnwsvXEtA5926rNuw5z8tqEQhjcHTKI7hITw3g=;
        b=A8CmWYcbs7J+eaUMRhy/EpGN/Zxtp0fG2sJ5usJeQBUhcph4/piPijJT+AgMs1pjV9
         iDGJTwRiIEAnIhrJJEXWLfFMuwRG+YQsMHnp5DR4LptAmDyubFZsiuJdcMQueP9FWzKg
         b9puH6pI4G+R2VP/i+afwnGPTRETsgihqiSzJkS2El5IaNJuxLaixaMN7sXiWKNgyO1f
         eeJcNs2YdDvghSLUnUrm++t3VLK2Egies46b22P0Ff+EfxzsL/6VptO2sqL3VmECTaDd
         GCKfZ+LGrnC2fbqdaPqltYch+G5MBg9qXqjqjhJ1Dlk7fk1JUNghnpSuizHZZl6CZ7ip
         mwEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758804594; x=1759409394;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uDHkDpnwsvXEtA5926rNuw5z8tqEQhjcHTKI7hITw3g=;
        b=ldNR2cl4B06qmM5tNsrL4BGy7MMwbl/xyY7j8QHrZjhOi0rdHKiaP7/kNiZyM9bLCl
         1P2ZYWig7rYw2e2lztWHnaAQBM0jbzgiNfcaZ+iPRywBAJ/gC3YWYLlurjTKR6I4Ud4c
         QrcMnpHhS3d08EUbFhGuRMA/hG/20hkou27bfAi1SIgIv9CGIi5NtM66+TGSQ4FXPpfG
         jK6EC1HXVcUbpAPN18G90pfxbckcYb4izSNQK8vhoZpa0dX+22eUNyvpjaedf0pP+xFp
         mmZOEKTxb3kDwcbzSiwyRI5NNTw0JJJMhzf6T03ev8ORFU4Gv9YDc01BtYgL7nMkH73m
         fQpg==
X-Forwarded-Encrypted: i=1; AJvYcCUR9QPoa6tOuVt+iGM8CC3CSi4sJGHrQBBh5UDduD4Kc6OFNn7QOaaGelzXAsQvtGBwrZ0zRrTsm25Tso0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxIggH41xe6a494HNoZQuL4naTJkFZruVGpAevi9HyNk/0eRLsQ
	canbGjxxQVwqBbLHgLu8PXKirs4OCYVQJ/U2ZgjF5StZ+SQf/HuRaAI=
X-Gm-Gg: ASbGncvI96tkmK4d6lhzKur1w3Ux5LcaPb9+QpbSQU68q1jp5W8w55LUNYXAJhcG2OC
	z2g9ya2A5scAVnG27o8Zg/Djti1UcW4j61DNrueXT+G0Ic4lcVYrIJ9XyXMScZrXNO1WHxnFcJS
	BgoIS1HwMwN24tUPuVvRadIPzN4vNpFGO/9byXFrtaeN8CEgi4S7Ya+Svns8MH/nt1iguDjOGor
	0R0de1ZzLDftQqD6sVGgJxkdAfPZOtInJmSHLiaM30KmsfN5K0OnEUlxod9WjVkpb6FTHm1DURl
	iyLx0yF+0ljPQvgGYuL7s5pvCKD1BrSD+Hwtq5QrqzGLrZUnsWtqmVedGAuMla6a8paMiOHUmb8
	Dvk4OTSndP3t4LNntxYOAe+hthEVQZvL/ydmbyJWW8J4zBSIzuuPwWXwumOGU
X-Google-Smtp-Source: AGHT+IGRbKrVkaHhQiDxnGP95SsqRWK4KznirLakvgFxIIq9h6bEbsYldjuEYHWl6BnbYeAb+ou3WQ==
X-Received: by 2002:a05:6000:2a89:b0:3ec:db87:e8a9 with SMTP id ffacd0b85a97d-40e3ab888bfmr1523246f8f.0.1758804593967;
        Thu, 25 Sep 2025 05:49:53 -0700 (PDT)
Received: from localhost (20.red-80-39-32.staticip.rima-tde.net. [80.39.32.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e32bf61b1sm18914565e9.2.2025.09.25.05.49.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Sep 2025 05:49:53 -0700 (PDT)
Message-ID: <0669b097-0bf1-4895-9c2a-5e953aebbfab@gmail.com>
Date: Thu, 25 Sep 2025 14:49:52 +0200
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 14/15] scsi: qla2xxx: add back SRR support
To: Tony Battersby <tonyb@cybernetics.com>,
 Nilesh Javali <njavali@marvell.com>, GR-QLogic-Storage-Upstream@marvell.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 adadasdasdasasd@adasdasasdasdasdas
Cc: linux-scsi <linux-scsi@vger.kernel.org>, target-devel@vger.kernel.org,
 scst-devel@lists.sourceforge.net, KERNEL ML <linux-kernel@vger.kernel.org>
References: <f8977250-638c-4d7d-ac0c-65f742b8d535@cybernetics.com>
 <2cc10189-6953-428e-b34e-b1c714fc0eae@cybernetics.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <2cc10189-6953-428e-b34e-b1c714fc0eae@cybernetics.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/8/25 9:10 PM, Tony Battersby wrote:

> (target mode)

> [...]

> I ran into some HBA firmware bugs with QLE2694L firmware 9.06.02 -
> 9.08.02 where a SRR would cause the HBA to misbehave badly.  Since SRRs
> are rare and therefore difficult to test, I figured it would be worth
> checking for the buggy firmware and disabling SLER with a warning
> instead of letting others run into the same problem on the rare
> occasion that they get a SRR.  This turned out to be difficult because
> the firmware version isn't known in the normal NVRAM config routine, so
> I added a second NVRAM config routine that is called after the firmware
> version is known.  It may be necessary to add checks for additional
> buggy firmware versions or additional chips that I was not able to
> test.
> 
> Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
> ---
>   drivers/scsi/qla2xxx/qla_dbg.c     |    1 +
>   drivers/scsi/qla2xxx/qla_init.c    |    1 +
>   drivers/scsi/qla2xxx/qla_target.c  | 1030 ++++++++++++++++++++++++++++
>   drivers/scsi/qla2xxx/qla_target.h  |   81 +++
>   drivers/scsi/qla2xxx/tcm_qla2xxx.c |   15 +
>   5 files changed, 1128 insertions(+)

> [...]

> + * Return true if the HBA firmware version is known to have bugs that
> + * prevent Sequence Level Error Recovery (SLER) / Sequence Retransmission
> + * Request (SRR) from working.
> + */
> +static bool qlt_has_sler_fw_bug(struct qla_hw_data *ha)
> +{
> +	bool has_sler_fw_bug = false;
> +
> +	if (IS_QLA2071(ha)) {
> +		/*
> +		 * QLE2694L known bad firmware:
> +		 *   9.06.02
> +		 *   9.07.00
> +		 *   9.08.02
> +		 *   SRRs trigger hundreds of bogus entries in the response
> +		 *   queue and various other problems.
> +		 *
> +		 * QLE2694L known good firmware:
> +		 *   8.08.05
> +		 *   9.09.00
> +		 *
> +		 * QLE2694L unknown firmware:
> +		 *   9.00.00 - 9.05.xx
> +		 */
> +		if (ha->fw_major_version == 9 &&
> +		    ha->fw_minor_version >= 6 &&
> +		    ha->fw_minor_version <= 8)
> +			has_sler_fw_bug = true;
> +	}
> +
> +	return has_sler_fw_bug;
> +}

> [...]

 > +/* Update any settings that depend on ha->fw_*_version. */> +void
> +qlt_config_nvram_with_fw_version(struct scsi_qla_host *vha)
> +{
> +	struct qla_hw_data *ha = vha->hw;
> +
> +	if (!QLA_TGT_MODE_ENABLED())
> +		return;
> +
> +	if (ql2xtgt_tape_enable && qlt_has_sler_fw_bug(ha)) {
> +		ql_log(ql_log_warn, vha, 0x11036,
> +		    "WARNING: ignoring ql2xtgt_tape_enable due to buggy HBA firmware; please upgrade FW\n");
> +
> +		/* Disable FC Tape support */
> +		if (ha->isp_ops->nvram_config == qla81xx_nvram_config) {
> +			struct init_cb_81xx *icb =
> +				(struct init_cb_81xx *)ha->init_cb;
> +			icb->firmware_options_2 &= cpu_to_le32(~BIT_12);
> +		} else {
> +			struct init_cb_24xx *icb =
> +				(struct init_cb_24xx *)ha->init_cb;
> +			icb->firmware_options_2 &= cpu_to_le32(~BIT_12);
> +		}
> +	}
> +}

If you want to review the firmware changelog, mainly: FCD-1183 (FCD-371, ER147301), FCD-259, ER146998
(from 9.00.00 to 9.15.05 [06/10/25]):
https://www.marvell.com/content/dam/marvell/en/drivers/2025-06-10-release/fw_release_notes/Fibre_Channel_Firmware_Release_Notes.pdf

It's look like all 2{678}xx devices/chips are affected by this bug.
Perhaps the Marvel crew could provide more information on this.
