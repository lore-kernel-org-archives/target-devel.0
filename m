From: David Miller <davem@davemloft.net>
Date: Wed, 05 Jun 2019 03:17:41 +0000
Subject: Re: [PATCH v2 net-next] cxgb4/libcxgb/cxgb4i/cxgbit: enable eDRAM page pods for iSCSI
Message-Id: <20190604.201741.2198584533127418560.davem@davemloft.net>
List-Id: <target-devel.vger.kernel.org>
References: <1559643109-3397-1-git-send-email-varun@chelsio.com>
In-Reply-To: <1559643109-3397-1-git-send-email-varun@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: varun@chelsio.com
Cc: netdev@vger.kernel.org, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, dt@chelsio.com, indranil@chelsio.com, ganji.aravind@chelsio.com

From: Varun Prakash <varun@chelsio.com>
Date: Tue,  4 Jun 2019 15:41:49 +0530

> +static int setup_ppod_edram(struct adapter *adap)
> +{
> +	int ret;
> +	unsigned int param, val;

Reverse christmas tree please.
