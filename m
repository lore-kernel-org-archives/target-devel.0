From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 07 Jan 2020 02:56:41 +0000
Subject: Re: Recent trace observed in target code during iSer testing
Message-Id: <3b724797-275a-9a14-1503-1778780a5872@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <MWHPR1101MB2271A83D246FAE4710E47BB2863C0@MWHPR1101MB2271.namprd11.prod.outlook.com>
In-Reply-To: <MWHPR1101MB2271A83D246FAE4710E47BB2863C0@MWHPR1101MB2271.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "'linux-rdma@vger.kernel.org'" <linux-rdma@vger.kernel.org>

On 2020-01-06 10:23, Marciniszyn, Mike wrote:
> Seeing the following trace in some target testing for IB ulps:
> 
> [28630.870878] ------------[ cut here ]------------
> [28630.876936] percpu_ref_kill_and_confirm called more than once on target_release_sess_cmd_refcnt [target_core_mod]!

A candidate fix has been posted but needs review and/or a Tested-by. See
also https://www.spinics.net/lists/target-devel/msg17981.html.

Thanks,

Bart.
