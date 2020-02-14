From: Bart Van Assche <bvanassche@acm.org>
Date: Fri, 14 Feb 2020 19:07:33 +0000
Subject: Re: [PATCH 1/2] Revert "RDMA/isert: Fix a recently introduced regression related to logout"
Message-Id: <0763a928-27f4-d6cf-fc54-128ddaf2f47f@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20200213050900.19094-1-bvanassche@acm.org>
 <fcc55797-40d0-a04f-e2de-6a20a02e6fb6@acm.org>
 <MWHPR1101MB227101D7C2DFEB8ABACD0FCB86150@MWHPR1101MB2271.namprd11.prod.outlook.com>
In-Reply-To: <MWHPR1101MB227101D7C2DFEB8ABACD0FCB86150@MWHPR1101MB2271.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, Dakshaja Uppalapati <dakshaja@chelsio.com>, Sagi Grimberg <sagi@grimberg.me>, Rahul Kundu <rahul.kundu@chelsio.com>, "'linux-rdma@vger.kernel.org'" <linux-rdma@vger.kernel.org>

On 2/14/20 6:28 AM, Marciniszyn, Mike wrote:
>>
>> [PATCH 0/2] Revert two recent iSCSI / iSER patches
>>
> 
> Bart,
> 
> This will mean we will again see failures in our internal iSer testing.
> 
> What is the status of a final fix?
> 
> If you have something to try, I would be glad to test...

Hi Mike,

Please take another look at this patch series. No new regressions should 
be introduced except if someone runs a bisect that lands in the middle 
of this patch series. Patch 1/2 reintroduces a regression but patches 
1/2 and 2/2 combined should restore iSER to the state of that driver in 
kernel v5.4.

Thanks,

Bart.
