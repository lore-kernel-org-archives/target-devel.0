From: Mike Christie <michael.christie@oracle.com>
Date: Sun, 18 Oct 2020 22:46:50 +0000
Subject: Re: [PATCH] scsi: target: tcmu: scatter_/gather_data_area rework
Message-Id: <89399f74-86e5-1217-c06e-f5ac4f9b5853@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20201016195839.27440-1-bostroesser@gmail.com>
In-Reply-To: <20201016195839.27440-1-bostroesser@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bodo Stroesser <bostroesser@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 10/16/20 2:58 PM, Bodo Stroesser wrote:
> +
> +static inline void tcmu_copy_data(struct tcmu_dev *udev,
> +				  struct tcmu_cmd *tcmu_cmd, uint32_t direction,
> +				  struct scatterlist *sg, unsigned int sg_nents,
> +				  struct iovec **iov,
> +				  int data_len)

It's a nice cleanup. I only have a small nit. This line should have been merged
with the one above it.
