From: Sagi Grimberg <sagi@grimberg.me>
Date: Wed, 29 Nov 2017 22:46:25 +0000
Subject: Re: [PATCH] iser-target: Fix possible use-after-free in connection establishment error
Message-Id: <eda02d71-cf33-2333-223a-0d6eeabb8185@grimberg.me>
List-Id: <target-devel.vger.kernel.org>
References: <20171126133104.22710-1-sagi@grimberg.me>
 <3676820c-544e-8ced-859a-ade8e6a0ef53@grimberg.me>
 <BN3PR07MB25782C93E50A7A0C55A110B4F83B0@BN3PR07MB2578.namprd07.prod.outlook.com>
In-Reply-To: <BN3PR07MB25782C93E50A7A0C55A110B4F83B0@BN3PR07MB2578.namprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Amrani, Ram" <Ram.Amrani@cavium.com>, Doug Ledford <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>


> If it's not already committed, can you add a "Fixes:" so stable maintainers will catch it?

I'm not sure at all that there is a clear cut commit that this fixes,
both the target code and the rdma interface code changed a lot so I
can't find any clear indication which broke this.

I can send a separate patch to stable from when we introduced
ib_drain_qp though.
