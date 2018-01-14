From: Sagi Grimberg <sagi@grimberg.me>
Date: Sun, 14 Jan 2018 09:26:04 +0000
Subject: Re: [RFC] iser-target: avoid reinitializing rdma contexts for isert commands
Message-Id: <143bd378-193e-0bbd-1ee3-25299af61aa8@grimberg.me>
List-Id: <target-devel.vger.kernel.org>
References: <1511893687-29298-1-git-send-email-bharat@chelsio.com>
 <20171218231439.GA31621@ziepe.ca>
 <1515824443.24576.108.camel@haakon3.daterainc.com>
 <20180113180428.GA32353@ziepe.ca>
In-Reply-To: <20180113180428.GA32353@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jason Gunthorpe <jgg@ziepe.ca>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Bharat Potnuri <bharat@chelsio.com>, target-devel@vger.kernel.org, linux-rdma <linux-rdma@vger.kernel.org>


>> Per Potnuri, it should be stable CC' to 4.11.y, and depends on:
>>
>> 7a56dc8 iser-target: avoid posting a recv buffer twice
>> 555a65f iser-target: Fix queue-full response handling
>> fa7e25c target: Fix unknown fabric callback queue-full errors
> 
> Hi Nicholas,
> 
> It is too late for us to revise this commit message in the RDMA tree,
> someone will have to notify stable manually instead.

I think it would be easier if nab would take this through the target
tree... Nic?
