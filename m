From: Jason Gunthorpe <jgg@ziepe.ca>
Date: Sat, 13 Jan 2018 18:04:28 +0000
Subject: Re: [RFC] iser-target: avoid reinitializing rdma contexts for isert commands
Message-Id: <20180113180428.GA32353@ziepe.ca>
List-Id: <target-devel.vger.kernel.org>
References: <1511893687-29298-1-git-send-email-bharat@chelsio.com>
 <20171218231439.GA31621@ziepe.ca>
 <1515824443.24576.108.camel@haakon3.daterainc.com>
In-Reply-To: <1515824443.24576.108.camel-XoQW25Eq2zs8TOCF0fvnoXxStJ4P+DSV@public.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: Bharat Potnuri <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Jan 12, 2018 at 10:20:43PM -0800, Nicholas A. Bellinger wrote:

> Per Potnuri, it should be stable CC' to 4.11.y, and depends on:
> 
> 7a56dc8 iser-target: avoid posting a recv buffer twice
> 555a65f iser-target: Fix queue-full response handling
> fa7e25c target: Fix unknown fabric callback queue-full errors

Hi Nicholas,

It is too late for us to revise this commit message in the RDMA tree,
someone will have to notify stable manually instead.

Jason
