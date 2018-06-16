From: Zhu Lingshan <lszhu@suse.de>
Date: Sat, 16 Jun 2018 07:08:19 +0000
Subject: Re: [PATCH 01/33] TCMU PR: first commit to implement TCMU PR
Message-Id: <17711def-ad8d-dc54-1a2b-83a89dadb3d6@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20180615182342.6239-1-lszhu@suse.com>
In-Reply-To: <20180615182342.6239-1-lszhu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: target-devel@vger.kernel.org

Hello Christoph,

Thanks for your comment, actually we already have pure kernel code that 
can handle PRG for a single target hosting a TCMU device. It is commit 
4ec5bf0ea83930b96addf6b78225bf0355459d7f. But in it's commit message, it 
mentioned that it does not handle multiple targets  use cases.

IMHO, users may setup multiple target servers hosting the same TCMU 
devices to avoid performance single point bottleneck, For example:
If they have two target servers(let's call them target A and target B) 
hosting the same Ceph RBD device, all PR requests against this RBD 
device must have consistent response. Like if Initiator A registered a 
key via Target A, another Initiator B must can see it via Target B. If 
Initiator A reserved the device via Target A, when Initiator B try to 
reserve the same RBD device, it must get a RESERVATION_CONFLICT.

User A                             User B
     \                                         /
      \                                       /
   Initiator A                Initiator B
        \                                 /
         \                               /
     Target A                 Target B
           \                           /
            \                         /
             \                       /
           The same TCMU device
           As a LUN


I have tried pure kernel code before, this requires a communication 
mechanism between target server kernels, only can send message is not 
enough, they must can automatic synchronize information, because when a 
PR request coming in, we can not query every target server, then judge 
whose PR information is newer, there are more problem like network 
delay, more puzzled. Then a DLM solution come to my mind, Bart also 
kindly offered his SCST solution(Thanks for Bart!). The reason why I did 
not use DLM is: (1)if we use DLM, we need corosync and pacemaker, a 
whole HA stack, it's a little overkill, users may setup multiple targets 
just for avoiding single point performance bottleneck. (2) Users may 
setup target server on a OSD server, if we use DLM, this means two 
clusters controlling the same nodes(Ceph itself is a cluster). This may 
lead conflicts, like if our HA cluster want to fence a node, but 
actually it's working well for Ceph.

So this solution come to my mind, we use the TCMU device(like RBD) 
itself as a mutual and single point that can help response to PR 
requests. Yes, the code is a bit complex, but the logic is easy, just 
exchange information with tcmu-runner via netlink, then tcmu-runner 
handles read / write the metadata.

Thanks a lot for your help!

Thanks,
BR
Zhu Lingshan

On 2018/6/16 13:22, Christoph Hellwig wrote:
> On Sat, Jun 16, 2018 at 02:23:10AM +0800, Zhu Lingshan wrote:
>> These commits and the following intend to implement Persistent
>> Reservation operations for TCMU devices.
> Err, hell no.
>
> If you are that tightly integrated with the target code that you can
> implement persistent reservation you need to use kernel code.
> Everything else just creates a way too complex interface.
>

