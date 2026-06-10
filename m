Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D52175A6B
	for <target-devel@vger.kernel.org>; Wed, 10 Jun 2026 06:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781071241; cv=none; b=rxmcxJcB0DWoOT1Fo17iZNSwEelGNvrSu4faMRxNxY1q/ZkkRTpdMW5ylmxMKlkc9mbbwwg2DudIgUqYwvuNJObe74JiOq0wSY+njNLQcyeVxKgL75JXhfRbpKF+JFHn1UQ6n+mTQ0w9+pf3+XgVu4QZKHP7DqgFPo2iR+mgZuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781071241; c=relaxed/simple;
	bh=S8CEMNCK3qGJNfDkKioIBoHNvaLuSk/NwLxdKcqC1Ls=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KdtE6FvtIHqRH2e3R6dcsnBo/PeuoPAVsimWOk+LwUdrXBgoa8EkNIBbBl1B7qSbZhFcgSsRPxlYzgDXosEexX7rdQmFwmp7mhxnIN+GEHX0OkVqciq6+p62ToLELSW696PDDOOdEtUEbjDdxm99LBfxiLtyJzEmEpXyKt1bFMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IFriv+0s; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IFriv+0s"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-3966388b388so56763621fa.1
        for <target-devel@vger.kernel.org>; Tue, 09 Jun 2026 23:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781071238; x=1781676038; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gj0YYK+8W8BmuuGLUjKiEFrVEApz47d5/8fZSNVUxGs=;
        b=IFriv+0sKu3CxcCpyIJeXMfi36nmgEs0snJknx+EVTPAcR8bQxlvkNzD2VaJrZzVZO
         Ns4c8SuTsRY8AC0isfE5bdCaCtM28ZpwmeQK0aKSgru3SpuEnelaujhXJmj7fjcE8Fpi
         Y4j4WKJdtSQCW2C6ChcSlejYChNYyVHLGDoxQqX6OE6QIuwZF0SMvrVKN1n3QyF0LVKF
         kCIWYVOZSTcNtQw51/qqy0kmrazJCy9mI02oXD/rfKPRCCSnvmORMg1jgjdBSsM6HKa4
         jbacnjO5GLLAvf9RMsh9ZVxHalT60ovmd7ENu5FUAXwqi5evLY3zQi80fLaPS4MNg5Nd
         PKGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781071238; x=1781676038;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gj0YYK+8W8BmuuGLUjKiEFrVEApz47d5/8fZSNVUxGs=;
        b=D6Vutj7QSJAy5JSVbwZxRwZntMpK05FUvHP7Bvy9wramNiOPuqMFLBnOUILOzW2r7r
         mAh/u5AQmtOsU6njCZN+QTY7SzpW2UEEnwo8jb1hzpSGMww+xThj16C94AWTGgtNBBRo
         vl1PpB15X5OX7Ml2CVnlhqutd8egNcbKH0AAbJhOMF+EK+b5Tfz2D8pZnN4VXozS6aLU
         Z7aqdf79Ztzzkly0Q33Y2RNhlrlxDPA1SLYMlw7E8uW8J/u8VIp8OrUZpRbxakSqem9H
         5HMLO7Xj+6mTrDoETZUSRzXY8OaNxPtSfzl7+AJEDBGcktAS8/mHIiztlGFhfd3xcVQ8
         O0wQ==
X-Forwarded-Encrypted: i=1; AFNElJ+wUk3Mydd1OeI0EjluNBIU7tIm5SHXr1GMI2Xsfwf04xEk12TCUX9hwusDPH/GcbERZNDXV57FpiLlcFg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZbKKn46PtSpe9W7eGmdr9qHZdRi/zavX321TglwnpRsQuPoIZ
	nDT3vPAB7uwi/r8K3wY5ZVkRCpSe2gx3e45zTrVBLTfaQTRADXUQI7CCb1PkXLcQaTg=
X-Gm-Gg: Acq92OExbkWS3q4FveBYsHghwil2I5MN1en6EtVlYuRTNc1jl0ll230WXF5/2kklOfe
	C6ivdR1qr5Qx3Uga6ckl73iH3Z7i0B2TZjC067YqGqC3kje1L8mrI9MDSTCcIdFdP929JpmnnZN
	lABfS+srO+8Qc7VZ9BRFM6IpaWKzuHuqc9KsYrYHre2AQ/ozplfXKW0BUYHGaFMcZVCiydR85ea
	O7nfje3n6IJULnQuVZK6v0WtSYappGEEJ/0TxOj0hQlW0+EHtjw0xos5tRTDCdSJpeGiXWeCFq7
	YwepliDPG4ruX4CqYlHpiAvOYfoekP47Rq9Fii/eMwP4MCnTUTbFFHTfBuxgBcPanQKfvF3TWOZ
	jxSF9l+ZMCQa6s8JrG30MDJexKhYcycdC9GKzCQCnzOWCqOq/8lMCfnHztzmsfFhnrEQZzMI0lr
	rV9rFko3gzNDRaxm9Wxyq3rEB/5SHXKGUdSg9mwM+KUzv2+JTeTt/hITp3R0Bheaf103wBV8M=
X-Received: by 2002:a2e:b8cd:0:b0:396:a647:76f5 with SMTP id 38308e7fff4ca-396d285f55dmr58137321fa.5.1781071237888;
        Tue, 09 Jun 2026 23:00:37 -0700 (PDT)
Received: from ?IPV6:2001:a62:1439:d001:a0af:1164:c6fd:8c51? ([2001:a62:1439:d001:a0af:1164:c6fd:8c51])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-396abd6cbe6sm59530741fa.0.2026.06.09.23.00.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jun 2026 23:00:36 -0700 (PDT)
Message-ID: <21746ee7-cff3-4db8-959d-dd693389492d@suse.com>
Date: Wed, 10 Jun 2026 08:00:30 +0200
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/4] scsi: scan: allocate sdev and starget on the NUMA
 node of the host adapter
To: Sumit Saxena <sumit.saxena@broadcom.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Jens Axboe <axboe@kernel.dk>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
 Adam Radford <aradford@gmail.com>, Khalid Aziz <khalid@gonehiking.org>,
 Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
 Matthew Wilcox <willy@infradead.org>, "Juergen E . Fischer"
 <fischer@norbit.de>, Russell King <linux@armlinux.org.uk>,
 linux-arm-kernel@lists.infradead.org, Finn Thain <fthain@linux-m68k.org>,
 Michael Schmitz <schmitzmic@gmail.com>,
 Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
 Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
 Oliver Neukum <oliver@neukum.org>, Ali Akcaagac <aliakc@web.de>,
 Jamie Lenehan <lenehan@twibble.org>, Ram Vegesna <ram.vegesna@broadcom.com>,
 target-devel@vger.kernel.org, Bradley Grove <linuxdrivers@attotech.com>,
 Satish Kharat <satishkh@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>,
 Karan Tilak Kumar <kartilak@cisco.com>, Yihang Li
 <liyihang9@h-partners.com>, Don Brace <don.brace@microchip.com>,
 storagedev@microchip.com, HighPoint Linux Team <linux@highpoint-tech.com>,
 Tyrel Datwyler <tyreld@linux.ibm.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>, linuxppc-dev@lists.ozlabs.org,
 Brian King <brking@us.ibm.com>, Lee Duncan <lduncan@suse.com>,
 Chris Leech <cleech@redhat.com>, Mike Christie
 <michael.christie@oracle.com>, open-iscsi@googlegroups.com,
 Justin Tee <justin.tee@broadcom.com>, Paul Ely <paul.ely@broadcom.com>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
 Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
 megaraidlinux.pdl@broadcom.com,
 Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 mpi3mr-linuxdrv.pdl@broadcom.com,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
 Ranjan Kumar <ranjan.kumar@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com,
 Daniel Palmer <daniel@thingy.jp>, GOTO Masanori <gotom@debian.or.jp>,
 YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
 Jack Wang <jinpu.wang@cloud.ionos.com>, Geoff Levand <geoff@infradead.org>,
 Michael Reed <mdr@sgi.com>, Nilesh Javali <njavali@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com, Narsimhulu Musini
 <nmusini@cisco.com>, "K . Y . Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>,
 linux-hyperv@vger.kernel.org, "Michael S . Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, Eugenio Perez <eperezma@redhat.com>,
 virtualization@lists.linux.dev, Vishal Bhakta <vishal.bhakta@broadcom.com>,
 bcm-kernel-feedback-list@broadcom.com, Juergen Gross <jgross@suse.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 xen-devel@lists.xenproject.org, James Rizzo <james.rizzo@broadcom.com>
References: <20260609121806.2121755-1-sumit.saxena@broadcom.com>
 <20260609121806.2121755-2-sumit.saxena@broadcom.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260609121806.2121755-2-sumit.saxena@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/9/26 14:18, Sumit Saxena wrote:
> From: James Rizzo <james.rizzo@broadcom.com>
> 
> When a host adapter is attached to a specific NUMA node, allocating
> scsi_device and scsi_target via kzalloc() may place them on a remote
> node.  All hot-path I/O accesses to these structures then cross the NUMA
> interconnect, adding latency and consuming inter-node bandwidth.
> 
> Use kzalloc_node() with dev_to_node(shost->dma_dev) so allocations land
> on the same node as the HBA, reducing cross-node traffic and improving
> I/O performance on NUMA systems.
> 
> Signed-off-by: James Rizzo <james.rizzo@broadcom.com>
> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
> ---
>   drivers/scsi/scsi_scan.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
