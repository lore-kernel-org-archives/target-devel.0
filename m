Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D371A2E6122
	for <target-devel@vger.kernel.org>; Thu, 25 Sep 2025 15:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758814215; cv=none; b=gzH7wR6m3h/GIV3ev2RLlGtDdMgPQjCMBOcTpZ9h/oZnPMrNtzNtjSfJ4SJZZBm36gtmgOIrJGawBDmZQqGuy4UO66JVv7dvejm5Kgq0BshnPuKQWnx4Befj4gNteADeisimMxHrB+dc2cw9Q+KCzJZs4Fz24zZ74Kki5rVWJAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758814215; c=relaxed/simple;
	bh=7embYRPF/5Q9/8iByQGHRwo8kMx6aLILpJkp6lh8BDQ=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=oWrQh4fyPDV8xquq61ejgWZQtcp8+2oWFWtVxp7HCfvHQmWEFyHmbiCfcy3tYAMvkqEjdaeFWX/lBMGMzCjXfrSRFwdOCKQ7rQVUiD2TkW/PQlAvhprDSD54CQ3qLdzjGJYnwBikyv3OINhyKaG9SAo045rWYywmKzwR0wDavpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f90Q2eyg; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f90Q2eyg"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-46e33b12589so2426085e9.1
        for <target-devel@vger.kernel.org>; Thu, 25 Sep 2025 08:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758814211; x=1759419011; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VF1Bqi8k7PXZlzWvyUXBJx9B9dWwFCwidqruMuP4DAw=;
        b=f90Q2eygaG4dc0yryHBMGZQ6RAsDgj/qQVgiqBJg0uemvGk1G1YyRGRLOAbfMUpdJm
         BDs7s6e7VxAbWWzDRwOpYu9HORzi3yPg7qWBHSMIia7wp3bcEvRl54Qd5k3Ol26KF0Iz
         XFMx0v41u4bQrq0PVQrn6t0G8kz8gM0V7BGPkxShESZFW6j+NdHFN4OS4xqsFMRZN1go
         1j0aWZOCGvqZ1DG1aueIzp3qrCMgL9XJqDOKosOnktamH/HVkmuChXLg5fQAAQMo4mcD
         PuihuQ3DyvW+FhF7pXrobXvTv3GVwYpcjJRxVkKbYjWGi9lo69fMf/gHakOqNWaG0dAi
         fw5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758814211; x=1759419011;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VF1Bqi8k7PXZlzWvyUXBJx9B9dWwFCwidqruMuP4DAw=;
        b=atq3ICsLG86p49Tek13uFT0GFfl19Dr765cypx5me+p1m8sHqzZW3KvL8JWYCNA9t8
         w+s6Kv67sEiNgh58uWwwQoiID/rgjYlmfG+jTY2Q9swj7usjZZSt4KQdhEtYP8Z1kAFO
         cQrVzl7Qi3bINE2s9YG6/SwZ7Ruro5OjqubxdCNNmG7ZSb5NIKzh5V5XFUsk/Q+OJaEy
         9aa+KDtD8xptq1qGfmRDb1iGhbd681Ca/D83sM/taPeDpi1WkBcU884mdaScYklfS4n0
         PhSgST6K90OYyiDw1mt8SnGhr1R0C+kZOWqXU7qTtqlbZlmuV4JZo29bZF5SFGt40CxC
         B9hw==
X-Forwarded-Encrypted: i=1; AJvYcCVwCoKPpiFFY9LKymTvO+tnOJlj7BehqiIGyHF3GobHXxroMBxQv2W0CBHa9A5OabMG3otqFgTg9kw3Cac=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0R2boHva3vm9683ooVcN1LOPuImXxqQl5nfBA//yrjDPFLkOi
	UCfh9h04hwXScQ6GabIrIi2nGYlStJ3uzB2lCZOaWHr7UnqWYEdotWY=
X-Gm-Gg: ASbGncuogxktivDvOScpKSKWEJSq7JznQKYriR8+Xfbq3QjDIo1Faoub6gfvcpXiYiq
	ctqlKIPc7iWkpD2S6sH6nUgdMkMzvQpRGc5/aPx8+qBlRs0b4Mei5mAQjYjfSTI5RfDDF1U2sPR
	8DdxGrpIeCKaynQXdcHY14HuY6C3bg85RMvI7StB6JVpNxm8SdayY2DlE2GUak3IvQwX7iu5dLQ
	AMDYht536jEe5aEsm5HCNsmzRhIeXLBljha2TODslA5HH+KdkNjQj9+yVtNTOUAFUARZsL6UMRg
	weFSsJddxqqjdWHjpNKumx/ZF389uuHjVUMARtAxZMkvxc9KSJmezDFO8cbP3ahD4V38eRuNHEC
	t9d3Axdo7VjavPiTtBQBDvhwhfKQ983O0SquORSEQgOwZ+XShBF7r5sX55E+9
X-Google-Smtp-Source: AGHT+IFqiPDWCPZpM+LXT8lqt7ta4cimw64WrasTX61w6SM4yI70RjOESL5EB0LuI187Xe9we0NonQ==
X-Received: by 2002:a05:6000:2a89:b0:3ec:db87:e8a9 with SMTP id ffacd0b85a97d-40e3ab888bfmr1778010f8f.0.1758814210739;
        Thu, 25 Sep 2025 08:30:10 -0700 (PDT)
Received: from localhost (20.red-80-39-32.staticip.rima-tde.net. [80.39.32.20])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb9c32734sm3546318f8f.25.2025.09.25.08.30.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Sep 2025 08:30:10 -0700 (PDT)
Message-ID: <8056aa80-7e5a-4cb3-804c-d9c7f8bd6d55@gmail.com>
Date: Thu, 25 Sep 2025 17:30:09 +0200
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 14/15] scsi: qla2xxx: add back SRR support
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: Tony Battersby <tonyb@cybernetics.com>,
 Nilesh Javali <njavali@marvell.com>, GR-QLogic-Storage-Upstream@marvell.com,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, target-devel@vger.kernel.org,
 scst-devel@lists.sourceforge.net, KERNEL ML <linux-kernel@vger.kernel.org>
References: <f8977250-638c-4d7d-ac0c-65f742b8d535@cybernetics.com>
 <2cc10189-6953-428e-b34e-b1c714fc0eae@cybernetics.com>
 <0669b097-0bf1-4895-9c2a-5e953aebbfab@gmail.com>
Content-Language: en-US, en-GB, es-ES
In-Reply-To: <0669b097-0bf1-4895-9c2a-5e953aebbfab@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/25/25 2:49 PM, Xose Vazquez Perez wrote:

> If you want to review the firmware changelog, mainly: FCD-1183 (FCD-371, ER147301), FCD-259, ER146998
> (from 9.00.00 to 9.15.05 [06/10/25]):
> https://www.marvell.com/content/dam/marvell/en/drivers/2025-06-10-release/fw_release_notes/Fibre_Channel_Firmware_Release_Notes.pdf
> 
> It's look like all 2{678}xx devices/chips are affected by this bug.
> Perhaps the Marvel crew could provide more information on this.

267x, or older, is still on 8.08, so apparently it's free of this bug:
https://www.marvell.com/content/dam/marvell/en/drivers/release-matrix/release-matrix-qlogic-fc-sw-posting-by-release-matrix.pdf

2870 / 2770 :        9.15.06 FW
2740 / 2760 / 269x : 9.15.01 FW
267x :               8.08.231 FW
