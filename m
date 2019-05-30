From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Thu, 30 May 2019 01:48:27 +0000
Subject: Re: [PATCH net-next] cxgb4/libcxgb/cxgb4i/cxgbit: enable eDRAM page pods for iSCSI
Message-Id: <yq1lfyozp90.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1559061660-4963-1-git-send-email-varun@chelsio.com>
In-Reply-To: <1559061660-4963-1-git-send-email-varun@chelsio.com> (Varun
        Prakash's message of "Tue, 28 May 2019 22:11:00 +0530")
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Varun Prakash <varun@chelsio.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, dt@chelsio.com, indranil@chelsio.com, ganji.aravind@chelsio.com


Varun,

> Page pods are used for direct data placement, this patch enables eDRAM
> page pods if firmware supports this feature.

No objections to the SCSI bits.

> @@ -394,6 +398,26 @@ int cxgbi_ppm_init(void **ppm_pp, struct net_device *ndev,
>  	unsigned int pool_index_max = 0;
>  	unsigned int alloc_sz;
>  	unsigned int ppod_bmap_size;
> +	unsigned int ppmax;
> +
> +	if (!iscsi_edram_start)
> +		iscsi_edram_size = 0;
> +
> +	if (iscsi_edram_size &&
> +	    ((iscsi_edram_start + iscsi_edram_size) != start)) {
> +		pr_err("iscsi ppod region not contigious: EDRAM start 0x%x "

contiguous

-- 
Martin K. Petersen	Oracle Linux Engineering
