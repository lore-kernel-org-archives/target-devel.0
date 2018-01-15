From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Date: Mon, 15 Jan 2018 04:39:58 +0000
Subject: Re: [RFC] iser-target: avoid reinitializing rdma contexts for isert commands
Message-Id: <1515991198.24576.143.camel@haakon3.daterainc.com>
List-Id: <target-devel.vger.kernel.org>
References: <1511893687-29298-1-git-send-email-bharat@chelsio.com>
         <20171218231439.GA31621@ziepe.ca>
         <1515824443.24576.108.camel@haakon3.daterainc.com>
         <20180113180428.GA32353@ziepe.ca>
         <143bd378-193e-0bbd-1ee3-25299af61aa8@grimberg.me>
         <20180114182344.GB9088@ziepe.ca>
In-Reply-To: <20180114182344.GB9088-uk2M96/98Pc@public.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Bharat Potnuri <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Bryant G. Ly" <bryantly-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

On Sun, 2018-01-14 at 11:23 -0700, Jason Gunthorpe wrote:
> On Sun, Jan 14, 2018 at 11:26:04AM +0200, Sagi Grimberg wrote:
> > 
> > >>Per Potnuri, it should be stable CC' to 4.11.y, and depends on:
> > >>
> > >>7a56dc8 iser-target: avoid posting a recv buffer twice
> > >>555a65f iser-target: Fix queue-full response handling
> > >>fa7e25c target: Fix unknown fabric callback queue-full errors
> > >
> > >Hi Nicholas,
> > >
> > >It is too late for us to revise this commit message in the RDMA tree,
> > >someone will have to notify stable manually instead.
> > 
> > I think it would be easier if nab would take this through the target
> > tree... Nic?
> 
> Too late for that too, it is in the rdma tree already.
> 

No worries.  Will send this out with the next round of stable backports,
post -rc1.

Btw, since this patch + earlier 4.11.y dependencies appear to be a hard
requirement for reliable iser-target operation for RNICs that generate
queue-full retries on large block workloads, I think the dependencies
have been upstream long enough to consider a 4.1.y+ backport as well.
(Adding Bryant CC')

