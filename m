From: Bart Van Assche <bvanassche@acm.org>
Date: Wed, 28 Oct 2020 03:45:11 +0000
Subject: Re: [PATCH rdma-next v1] IB/srpt: Fix memory leak in srpt_add_one
Message-Id: <1bc9ef14-4d91-6b12-f396-222cb6775ce4@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20201027055920.1760663-1-leon@kernel.org>
In-Reply-To: <20201027055920.1760663-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>
Cc: Maor Gottlieb <maorg@nvidia.com>, linux-rdma@vger.kernel.org, "Nicholas A. Bellinger" <nab@risingtidesystems.com>, target-devel@vger.kernel.org

On 10/26/20 10:59 PM, Leon Romanovsky wrote:
> +/**
> + * srpt_unregister_mad_agent - unregister MAD callback functions
> + * @sdev: SRPT HCA pointer.
> + *
> + * Note: It is safe to call this function more than once for the same device.
> + */
> +static void srpt_unregister_mad_agent(struct srpt_device *sdev)
> +{
> +	__srpt_unregister_mad_agent(sdev, sdev->device->phys_port_cnt);
> +}

As far as I can see with this patch applied srpt_unregister_mad_agent()
has no callers. So please add an argument to srpt_unregister_mad_agent()
instead of introducing __srpt_unregister_mad_agent().

Thanks,

Bart.
