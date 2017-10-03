From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Date: Tue, 03 Oct 2017 15:13:25 +0000
Subject: Re: [PATCH] ibmvscsis: Fix write_pending failure path
Message-Id: <a7ec59e1-b8d7-b591-01ef-afb4c1e25c0e@linux.vnet.ibm.com>
List-Id: <target-devel.vger.kernel.org>
References: <20171002175938.11764-1-bryantly@linux.vnet.ibm.com>
 <yq1k20d0wqg.fsf@oracle.com>
In-Reply-To: <yq1k20d0wqg.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: nab@linux-iscsi.org, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, "Bryant G. Ly" <bgly@us.ibm.com>



On 10/2/17 9:51 PM, Martin K. Petersen wrote:
> Bryant,
>
>> For write_pending if the queue is down or client failed then return
>> -EIO so that LIO can properly process the completed command. Prior we
>> returned 0 since LIO could not handle it properly. Now with: target:
>> Fix unknown fabric callback queue-full errors that patch addresses
>> LIO's ability to handle things right.
> Applied to 4.14/scsi-fixes. thanks!
>
Thanks! I forgot to add the stable tag for 4.11+, but I guess we can 
wait for
Nick to reply since we had discussed making the dependent patch series 
stable.

[PATCH 0/3] target: Fix queue-full callback error signaling

fa7e25cf13a6d0b82b5ed1008246f44d42e8422c
a4467018c2a7228f4ef58051f0511bd037bff264
025def92dd6b5b84b0d6d9069e2bb24e51e48c17


-Bryant


