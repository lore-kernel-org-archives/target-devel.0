From: Sagi Grimberg <sagi@grimberg.me>
Date: Sun, 14 Jan 2018 09:24:21 +0000
Subject: Re: [PATCH] iser-target: Fix possible use-after-free in connection establishment error
Message-Id: <3653058c-324b-ef18-eb3b-c9a8c24b70ed@grimberg.me>
List-Id: <target-devel.vger.kernel.org>
References: <20171126133104.22710-1-sagi@grimberg.me>
 <3676820c-544e-8ced-859a-ade8e6a0ef53@grimberg.me>
 <BN3PR07MB25782C93E50A7A0C55A110B4F83B0@BN3PR07MB2578.namprd07.prod.outlook.com>
 <eda02d71-cf33-2333-223a-0d6eeabb8185@grimberg.me>
 <e11259b7-5add-bf87-73d4-49483c90bf73@mellanox.com>
 <20180109171718.GC4518@ziepe.ca> <1515621286.3403.172.camel@redhat.com>
 <1515822365.24576.100.camel@haakon3.daterainc.com>
 <20180113180841.GB32353@ziepe.ca>
In-Reply-To: <20180113180841.GB32353-uk2M96/98Pc@public.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Thanks Jason for picking it up, and sorry for the
late reply on this.

> That can be done:
> 
> Fixes: a060b5629ab0 ("IB/core: generic RDMA READ/WRITE API")

This patch is not the offending patch, if at all its this one:

Fixes: 572a143489a1 ("iser-target: Use ib_drain_qp")

But, the missing qp drain existed way before this commit.
I think any fixes tag would be confusing as there isn't a clear
culprit for this one...
