From: Jason Gunthorpe <jgg@nvidia.com>
Date: Thu, 12 Nov 2020 18:30:23 +0000
Subject: Re: [PATCH] IB/srpt: Fix passing zero to 'PTR_ERR'
Message-Id: <20201112183023.GB917484@nvidia.com>
List-Id: <target-devel.vger.kernel.org>
References: <20201112145443.17832-1-yuehaibing@huawei.com>
 <20201112172008.GA944848@nvidia.com>
 <c73d9be0-0bd8-634a-e3d1-c81fe4c30482@acm.org>
In-Reply-To: <c73d9be0-0bd8-634a-e3d1-c81fe4c30482@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bart Van Assche <bvanassche@acm.org>
Cc: YueHaibing <yuehaibing@huawei.com>, dledford@redhat.com, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Nov 12, 2020 at 10:25:48AM -0800, Bart Van Assche wrote:
> On 11/12/20 9:20 AM, Jason Gunthorpe wrote:
> > I think it should be like this, Bart?
> > 
> > diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
> > index 6017d525084a0c..80f9673956ced2 100644
> > +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> > @@ -2311,7 +2311,7 @@ static int srpt_cm_req_recv(struct srpt_device *const sdev,
> >   	mutex_lock(&sport->port_guid_id.mutex);
> >   	list_for_each_entry(stpg, &sport->port_guid_id.tpg_list, entry) {
> > -		if (!IS_ERR_OR_NULL(ch->sess))
> > +		if (ch->sess)
> >   			break;
> >   		ch->sess = target_setup_session(&stpg->tpg, tag_num,
> >   						tag_size, TARGET_PROT_NORMAL,
> > @@ -2321,12 +2321,12 @@ static int srpt_cm_req_recv(struct srpt_device *const sdev,
> >   	mutex_lock(&sport->port_gid_id.mutex);
> >   	list_for_each_entry(stpg, &sport->port_gid_id.tpg_list, entry) {
> > -		if (!IS_ERR_OR_NULL(ch->sess))
> > +		if (ch->sess)
> >   			break;
> >   		ch->sess = target_setup_session(&stpg->tpg, tag_num,
> >   					tag_size, TARGET_PROT_NORMAL, i_port_id,
> >   					ch, NULL);
> > -		if (!IS_ERR_OR_NULL(ch->sess))
> > +		if (ch->sess)
> >   			break;
> >   		/* Retry without leading "0x" */
> >   		ch->sess = target_setup_session(&stpg->tpg, tag_num,
> > @@ -2335,7 +2335,9 @@ static int srpt_cm_req_recv(struct srpt_device *const sdev,
> >   	}
> >   	mutex_unlock(&sport->port_gid_id.mutex);
> > -	if (IS_ERR_OR_NULL(ch->sess)) {
> > +	if (!ch->sess)
> > +		ch->sess = ERR_PTR(-ENOENT);
> > +	if (IS_ERR(ch->sess)) {
> >   		WARN_ON_ONCE(ch->sess = NULL);
> >   		ret = PTR_ERR(ch->sess);
> >   		ch->sess = NULL;
> > 
> 
> Hi Jason,
> 
> The ib_srpt driver accepts three different formats for the initiator ACL. Up
> to two of the three target_setup_session() calls will fail if the fifth
> argument of target_setup_session() does not use the format of the initiator
> ID in configfs. If the first or the second target_setup_session() call fails
> it is essential that later target_setup_session() calls happen. Hence the
> IS_ERR_OR_NULL(ch->sess) checks in the above loops.

IS_ERR_OR_NULL is an abomination, it should not be used.

I see I didn't quite get it right, but that is still closer to sane,
probably target_setup_session() should return NULL not err_ptr

Jason
