From: Leon Romanovsky <leon@kernel.org>
Date: Tue, 27 Oct 2020 05:34:56 +0000
Subject: Re: [PATCH rdma-next] IB/srpt: Fix memory leak in srpt_add_one
Message-Id: <20201027053456.GD4821@unreal>
List-Id: <target-devel.vger.kernel.org>
References: <20201026132737.1338171-1-leon@kernel.org>
 <93385ff4-cab7-05f2-e29a-82c9c71e47fa@acm.org>
In-Reply-To: <93385ff4-cab7-05f2-e29a-82c9c71e47fa@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bart Van Assche <bvanassche@acm.org>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>, Maor Gottlieb <maorg@nvidia.com>, linux-rdma@vger.kernel.org, "Nicholas A. Bellinger" <nab@risingtidesystems.com>, target-devel@vger.kernel.org

On Mon, Oct 26, 2020 at 07:22:07PM -0700, Bart Van Assche wrote:
> On 10/26/20 6:27 AM, Leon Romanovsky wrote:
> > From: Maor Gottlieb <maorg@nvidia.com>
> >
> > In case srpt_refresh_port failed for the second port, then
> > we don't unregister the MAD agnet.
>                               ^^^^^
>                               agent?
>
> The commit message is incomplete. Why does this patch have a Fixes tag?
> The commit message should explain this but doesn't explain this.
>
> What does this patch actually change? ib_unregister_mad_agent() is only
> called by the current code if sport->mad_agent != NULL.

Failure in srpt_refresh_port() for the second port will leave MAD
registered for the first one, however the srpt_add_one() will be
marked as "failed" and SRPT will leak resources for that registered
but not used and released first port.

This is what is written in the commit message.

>
> > -static void srpt_unregister_mad_agent(struct srpt_device *sdev)
> > +static void __srpt_unregister_mad_agent(struct srpt_device *sdev, int port_cnt)
> >  {
> >  	struct ib_port_modify port_modify = {
> >  		.clr_port_cap_mask = IB_PORT_DEVICE_MGMT_SUP,
> > @@ -633,7 +627,10 @@ static void srpt_unregister_mad_agent(struct srpt_device *sdev)
> >  	struct srpt_port *sport;
> >  	int i;
> >
> > -	for (i = 1; i <= sdev->device->phys_port_cnt; i++) {
> > +	if (!port_cnt)
> > +		return;
> > +
> > +	for (i = 1; i <= port_cnt; i++) {
> >  		sport = &sdev->port[i - 1];
> >  		WARN_ON(sport->port != i);
> >  		if (sport->mad_agent) {
>
> If this patch is retained, please leave the if-test out if you agree
> that it is not necessary. I'm concerned that it will confuse readers.

No problem.

>
> Thanks,
>
> Bart.
