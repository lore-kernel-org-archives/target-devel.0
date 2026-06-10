Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6679C2857FA
	for <target-devel@vger.kernel.org>; Wed, 10 Jun 2026 06:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781071204; cv=none; b=J+WOHQtmIXnjfps74jaDxy+b7aIK+g+/9ZsS4bMpeoRg6bF7sOzREMPXLI25rLXKC9yYYmQcW6TGvzPLzCvXSt5FcM5vMn7VjzaGTxz+E+rgG6f5r5gRwhHlpiFyGG3r1vRt5WvXMHjTnS/BwIE670stfmkuzjnMMvfiuSjWOPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781071204; c=relaxed/simple;
	bh=AvZ62CJBNYf9slGn5Sv7jZnOy8sCQBSyuSuQs3KW624=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qcxo1vAQgh8LguD4+xI0lmVorylI/LvSOjQ2qtdWVAaJ9Vi1h0uLI5czavHdz8fjb1TajZ1UFHNOoItIpdnQhS6fLNBC1s+7s75vR1xfeRcRvwbZJpt70WPTx0ZrvQZ21slz7NPX0zDiXCgmK897uP9ZH8zgn9M32WEZPORV26o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EjMwLqYu; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EjMwLqYu"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-490b211ee6aso48962615e9.3
        for <target-devel@vger.kernel.org>; Tue, 09 Jun 2026 23:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781071201; x=1781676001; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0eeq4qUemue69ATVH9Hc0G+s1EX6SM4VcPKiJpjYoUk=;
        b=EjMwLqYujTxy+YSxoLHsRyOYOX4r/EAZp2/ifXHXTJoJpf9tpEOLpOI6D7kbGzidhm
         qLO79IlI7HlqlCK2gjE/c/4YJ1nTaFIu84/098dMgwpBwJeE6ErYxbhVjJIN+z8Sdkq6
         tG02njeUzYHi+UzF2x88M8Cj2tCrV/CvpscLRDBurC7eykEDaT6soboaQvvNGgsbgH1w
         cbhQPAhnngBmAjWFoXiD/UAP3F2fTRPvDToqhbNLmRvaotOirJ2RIJwGNcKaGni4Vzom
         AdDC11mPMOHY5fCA3RWHyUtXOlaKEZdxwYYX0zhLUJRpYxe9G5r2KsqOMbSpkoEVSioS
         8M4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781071201; x=1781676001;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0eeq4qUemue69ATVH9Hc0G+s1EX6SM4VcPKiJpjYoUk=;
        b=lmPcrKMj6S+nfopvCdRlwV+C3Q1TOQIPH6yN7/r2cOhLaLnIP2iX4BNybQJbUP/D8r
         2+MC5hIpQR4naNsFoopm4DFglyd1czg7Abk7/CS/cyGXojJFTlPnsJU9RuIFktcs7HkS
         QINsRBRk9Zb9Ap8yw6THlssX+9NLyw/v3PL1k5x0CCWwCG1jYDtcOIKNsF5yNff/P/cM
         HcSxJlThV27FY/ZJH+WzObHxBccTqk2M8zZymjDU12T2eM532HBOMwkMVf+c4scHJFfu
         ikFzl0RP6YFVk6eRPK3xpnb6MEAAGnoKipQ97Zp4BA4L0SfqQEMw4/piEcrKu3WTFMTX
         wiZg==
X-Forwarded-Encrypted: i=1; AFNElJ8JG/KbSPfcUZPpgoTkovQFgdjK4BTvGDI5CU4aNvsrVYnSrpY6QnqV61oTW8zvNsoRa4dZuhhNr/YsiZk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxGvVkFCN6OYsvE6Wb5VTA5zBrYZhtELrP26AsMeDhAZ1ukOl8v
	L6Kr/MQalow8BlCJwWwFGw/MeleEXLw0/f8fozmg6aLpyGrT5QKVOLuhtg3rtISULGA=
X-Gm-Gg: Acq92OFz4OMUMu3IYBXgtQACoecKTUDU+SRELcT0vs3n4qCK5HZeQFtu2NhNmMDn+VT
	sFtL+jlWYIVwOCL3vOmbvYI+Bx0Os4pZZRNdCz4dMjQ/zWLdKI6vYfcgsNJLUpA/3yLUBFIx8Yt
	zQSLaPs0ozMaBP3X01zrkZOS64dGObTd4sTkx1POi0FH17pGQqpUJbcWJ6nEBLmbk7eqxkFfg7/
	TETILVSoaPLFe7kDW5Kn2EpOU0GLL79W7PWCFbcD6KNcECYJFUFYdLV/HvpLRVBNJKRX1uAqTge
	8zReePJojunc4Fe4ZpXw6SNrF2DJ8UdhZw1Tu52jIcb6AVRxLZmcrIixlGBRj64ZxsjsQLZ04Iy
	TBDB4ljwEzf9OQARK6RQxs+Qb0VwhSs9Cy96bkkRowGCSHfASHwJfR5E07JLImrzSL2tuLwpC5f
	p3dwwqTsPHT+j2HD5VuSsJ/lWfz3m5xPzzfhE2DkypHmTOHsBWTGKLHGtmMvXPxtMGkw7EJJY=
X-Received: by 2002:a05:600c:8285:b0:490:abef:dae6 with SMTP id 5b1f17b1804b1-490c25b09bcmr392960895e9.19.1781071200857;
        Tue, 09 Jun 2026 23:00:00 -0700 (PDT)
Received: from ?IPV6:2001:a62:1439:d001:a0af:1164:c6fd:8c51? ([2001:a62:1439:d001:a0af:1164:c6fd:8c51])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f35eae5sm69552212f8f.33.2026.06.09.22.59.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jun 2026 23:00:00 -0700 (PDT)
Message-ID: <e2a61373-0c27-41c3-b0ca-836a4727a3b5@suse.com>
Date: Wed, 10 Jun 2026 07:59:57 +0200
Precedence: bulk
X-Mailing-List: target-devel@vger.kernel.org
List-Id: <target-devel.vger.kernel.org>
List-Subscribe: <mailto:target-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:target-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/4] scsi: host: allocate struct Scsi_Host on the NUMA
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
 xen-devel@lists.xenproject.org, John Garry <john.g.garry@oracle.com>
References: <20260609121806.2121755-1-sumit.saxena@broadcom.com>
 <20260609121806.2121755-3-sumit.saxena@broadcom.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260609121806.2121755-3-sumit.saxena@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/9/26 14:18, Sumit Saxena wrote:
> scsi_host_alloc() used kzalloc(), which always picks an arbitrary node.
> Extend the function to accept a 'struct device *dev' parameter and use
> kzalloc_node() with dev_to_node(dev) so the Scsi_Host struct lands on
> the same NUMA node as the HBA, mirroring the treatment already applied
> to struct scsi_device, struct scsi_target, and shost_data.
> 
> When dev is NULL (legacy ISA/platform drivers without a dma_dev) the
> allocation falls back to NUMA_NO_NODE, preserving existing behaviour.
> 
> Update all in-tree callers:
>    - PCI-based HBA drivers pass &pdev->dev (or the equivalent struct
>      member such as &phba->pcidev->dev, &h->pdev->dev, &ha->pdev->dev)
>      so their host struct is placed on the adapter's node.
>    - Non-PCI drivers (ISA, Amiga, ARM PCMCIA, virtio, Hyper-V, PS3, …)
>      pass NULL.
>    - libfc's libfc_host_alloc() inline helper passes NULL; FC drivers
>      that want NUMA awareness can open-code the call with their pdev.
> 
> Suggested-by: John Garry <john.g.garry@oracle.com>
> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
> ---
>   drivers/scsi/3w-9xxx.c                    | 2 +-
>   drivers/scsi/3w-sas.c                     | 2 +-
>   drivers/scsi/3w-xxxx.c                    | 2 +-
>   drivers/scsi/53c700.c                     | 2 +-
>   drivers/scsi/BusLogic.c                   | 2 +-
>   drivers/scsi/a100u2w.c                    | 2 +-
>   drivers/scsi/a2091.c                      | 2 +-
>   drivers/scsi/a3000.c                      | 2 +-
>   drivers/scsi/aacraid/linit.c              | 2 +-
>   drivers/scsi/advansys.c                   | 6 +++---
>   drivers/scsi/aha152x.c                    | 2 +-
>   drivers/scsi/aha1542.c                    | 2 +-
>   drivers/scsi/aha1740.c                    | 2 +-
>   drivers/scsi/aic7xxx/aic79xx_osm.c        | 2 +-
>   drivers/scsi/aic7xxx/aic7xxx_osm.c        | 2 +-
>   drivers/scsi/aic94xx/aic94xx_init.c       | 2 +-
>   drivers/scsi/am53c974.c                   | 2 +-
>   drivers/scsi/arcmsr/arcmsr_hba.c          | 3 ++-
>   drivers/scsi/arm/acornscsi.c              | 2 +-
>   drivers/scsi/arm/arxescsi.c               | 2 +-
>   drivers/scsi/arm/cumana_1.c               | 2 +-
>   drivers/scsi/arm/cumana_2.c               | 2 +-
>   drivers/scsi/arm/eesox.c                  | 2 +-
>   drivers/scsi/arm/oak.c                    | 2 +-
>   drivers/scsi/arm/powertec.c               | 2 +-
>   drivers/scsi/atari_scsi.c                 | 2 +-
>   drivers/scsi/atp870u.c                    | 2 +-
>   drivers/scsi/bfa/bfad_im.c                | 2 +-
>   drivers/scsi/csiostor/csio_init.c         | 4 ++--
>   drivers/scsi/dc395x.c                     | 2 +-
>   drivers/scsi/dmx3191d.c                   | 2 +-
>   drivers/scsi/elx/efct/efct_xport.c        | 4 ++--
>   drivers/scsi/esas2r/esas2r_main.c         | 2 +-
>   drivers/scsi/fdomain.c                    | 2 +-
>   drivers/scsi/fnic/fnic_main.c             | 2 +-
>   drivers/scsi/g_NCR5380.c                  | 2 +-
>   drivers/scsi/gvp11.c                      | 2 +-
>   drivers/scsi/hisi_sas/hisi_sas_main.c     | 2 +-
>   drivers/scsi/hisi_sas/hisi_sas_v3_hw.c    | 2 +-
>   drivers/scsi/hosts.c                      | 6 ++++--
>   drivers/scsi/hpsa.c                       | 2 +-
>   drivers/scsi/hptiop.c                     | 2 +-
>   drivers/scsi/ibmvscsi/ibmvfc.c            | 2 +-
>   drivers/scsi/ibmvscsi/ibmvscsi.c          | 2 +-
>   drivers/scsi/imm.c                        | 2 +-
>   drivers/scsi/initio.c                     | 2 +-
>   drivers/scsi/ipr.c                        | 2 +-
>   drivers/scsi/ips.c                        | 2 +-
>   drivers/scsi/isci/init.c                  | 2 +-
>   drivers/scsi/jazz_esp.c                   | 2 +-
>   drivers/scsi/libiscsi.c                   | 2 +-
>   drivers/scsi/lpfc/lpfc_init.c             | 2 +-
>   drivers/scsi/mac53c94.c                   | 2 +-
>   drivers/scsi/mac_esp.c                    | 2 +-
>   drivers/scsi/mac_scsi.c                   | 2 +-
>   drivers/scsi/megaraid.c                   | 2 +-
>   drivers/scsi/megaraid/megaraid_mbox.c     | 2 +-
>   drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
>   drivers/scsi/mesh.c                       | 2 +-
>   drivers/scsi/mpi3mr/mpi3mr_os.c           | 2 +-
>   drivers/scsi/mpt3sas/mpt3sas_scsih.c      | 4 ++--
>   drivers/scsi/mvme147.c                    | 2 +-
>   drivers/scsi/mvsas/mv_init.c              | 2 +-
>   drivers/scsi/mvumi.c                      | 2 +-
>   drivers/scsi/myrb.c                       | 2 +-
>   drivers/scsi/myrs.c                       | 2 +-
>   drivers/scsi/ncr53c8xx.c                  | 2 +-
>   drivers/scsi/nsp32.c                      | 2 +-
>   drivers/scsi/pcmcia/nsp_cs.c              | 2 +-
>   drivers/scsi/pcmcia/qlogic_stub.c         | 2 +-
>   drivers/scsi/pcmcia/sym53c500_cs.c        | 2 +-
>   drivers/scsi/pm8001/pm8001_init.c         | 2 +-
>   drivers/scsi/pmcraid.c                    | 2 +-
>   drivers/scsi/ppa.c                        | 2 +-
>   drivers/scsi/ps3rom.c                     | 2 +-
>   drivers/scsi/qla1280.c                    | 2 +-
>   drivers/scsi/qla2xxx/qla_mid.c            | 2 +-
>   drivers/scsi/qla2xxx/qla_os.c             | 2 +-
>   drivers/scsi/qlogicfas.c                  | 2 +-
>   drivers/scsi/qlogicpti.c                  | 2 +-
>   drivers/scsi/scsi_debug.c                 | 2 +-
>   drivers/scsi/sgiwd93.c                    | 2 +-
>   drivers/scsi/smartpqi/smartpqi_init.c     | 2 +-
>   drivers/scsi/snic/snic_main.c             | 2 +-
>   drivers/scsi/stex.c                       | 2 +-
>   drivers/scsi/storvsc_drv.c                | 2 +-
>   drivers/scsi/sun3_scsi.c                  | 2 +-
>   drivers/scsi/sun3x_esp.c                  | 2 +-
>   drivers/scsi/sun_esp.c                    | 2 +-
>   drivers/scsi/sym53c8xx_2/sym_glue.c       | 2 +-
>   drivers/scsi/virtio_scsi.c                | 2 +-
>   drivers/scsi/vmw_pvscsi.c                 | 2 +-
>   drivers/scsi/wd719x.c                     | 2 +-
>   drivers/scsi/xen-scsifront.c              | 2 +-
>   drivers/scsi/zorro_esp.c                  | 2 +-
>   include/scsi/libfc.h                      | 2 +-
>   include/scsi/scsi_host.h                  | 3 ++-
>   97 files changed, 107 insertions(+), 103 deletions(-)
> 
Quite a lot of churn for such a (relatively) simple change.

I think it might be better to introduce a new function
(scsi_host_alloc_node() ?) with the additional parameter,
and make scsi_host_alloc() a wrapper around that.

That will reduce the size of this patch immensely.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
