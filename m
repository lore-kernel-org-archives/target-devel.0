From: Mike Christie <michael.christie@oracle.com>
Date: Thu, 29 Oct 2020 22:19:07 +0000
Subject: Re: [PATCH 00/17 V3] vhost: fix scsi cmd handling and cgroup support
Message-Id: <c95612d5-104a-f8f5-d335-bd20e74e9ecc@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
 <20201029174719-mutt-send-email-mst@kernel.org>
In-Reply-To: <20201029174719-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, jasowang@redhat.com, pbonzini@redhat.com, stefanha@redhat.com, virtualization@lists.linux-foundation.org

On 10/29/20 4:47 PM, Michael S. Tsirkin wrote:
> On Wed, Oct 21, 2020 at 07:34:46PM -0500, Mike Christie wrote:
>> In-Reply-To:
>>
>> The following patches were made over Michael's vhost branch here:
>>
>> https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/log/?h=vhost__;!!GqivPVa7Brio!ORlQVwL5FxDLtNmvh5l9nLqhQJOO6UexX4vl-NrAhagQG9dAGFNFCPXoSNU8rW75g3OH$
>>
>> They fix a couple issues with vhost-scsi when we hit the 256 cmd limit
>> that result in the guest getting IO errors, add LUN reset support so
>> devices are not offlined during transient errors, allow us to manage
>> vhost scsi IO with cgroups, and imrpove IOPs up to 2X.
>>
>> The following patches are a follow up to this post:
>> https://urldefense.com/v3/__https://patchwork.kernel.org/project/target-devel/cover/1600712588-9514-1-git-send-email-michael.christie@oracle.com/__;!!GqivPVa7Brio!ORlQVwL5FxDLtNmvh5l9nLqhQJOO6UexX4vl-NrAhagQG9dAGFNFCPXoSNU8rXJWM8fh$
>> which originally was fixing how vhost-scsi handled cmds so we would
>> not get IO errors when sending more than 256 cmds.
>>
>> In that patchset I needed to detect if a vq was in use and for this
>> patch:
>> https://urldefense.com/v3/__https://patchwork.kernel.org/project/target-devel/patch/1600712588-9514-3-git-send-email-michael.christie@oracle.com/__;!!GqivPVa7Brio!ORlQVwL5FxDLtNmvh5l9nLqhQJOO6UexX4vl-NrAhagQG9dAGFNFCPXoSNU8rbRNqMbK$
>> It was suggested to add support for VHOST_RING_ENABLE. While doing
>> that though I hit a couple problems:
>>
>> 1. The patches moved how vhost-scsi allocated cmds from per lio
>> session to per vhost vq. To support both VHOST_RING_ENABLE and
>> where userspace didn't support it, I would have to keep around the
>> old per session/device cmd allocator/completion and then also maintain
>> the new code. Or, I would still have to use this patch
>> patchwork.kernel.org/cover/11790763/ for the compat case so there
>> adding the new ioctl would not help much.
>>
>> 2. For vhost-scsi I also wanted to prevent where we allocate iovecs
>> for 128 vqs even though we normally use a couple. To do this, I needed
>> something similar to #1, but the problem is that the VHOST_RING_ENABLE
>> call would come too late.
>>
>> To try and balance #1 and #2, these patches just allow vhost-scsi
>> to setup a vq when userspace starts to config it. This allows the
>> driver to only fully setup (we still waste some memory to support older
>> setups but do not have to preallocate everything like before) what
>> is used plus I do not need to maintain 2 code paths.
> 
> 
> OK, so could we get a patchset with just bugfixes for this release
> please? > And features should go into next one ...

Yeah, that sounds good.

Just to make sure I am on the same page as you and Jason about what 
patches are features vs fixes/cleanups. I'm thinking patches 1 - 11 are 
to resend in the fixes patchset?

0. Patches 1 - 2 are adding helpers I use later.

1. Patches 3 - 8 are related to fixing IO errors due to the VM sending 
virtqueue_size/cmd_per_lun commands but vhost-scsi having 256 hard coded.

Patch:

[PATCH 08/17] vhost scsi: alloc cmds per vq instead of session

is what fixes the issue in vhost-scsi so we allocate enough resource to 
match what the VM is going to send us, but is built on patches 3 - 7 
which allow vhost-scsi to know which vqs to allocate cmd resrouces for.

[PATCH 03/17] vhost net: use goto error handling in open
[PATCH 04/17] vhost: prep vhost_dev_init users to handle failures
[PATCH 05/17] vhost: move vq iovec allocation to dev init time
[PATCH 06/17] vhost: support delayed vq creation
[PATCH 07/17] vhost scsi: support delayed IO vq creation

2. Patch 9 fixes a race where we signal userspace the cmd is done before 
we were done with it. We can then get IO errors if the VM sends a new IO 
before we free up the old cmd.


3. Patch 10 adds LUN reset support. Currently, if the real/backing 
device hits a temp issue, the VM's scsi/block layer cmd timer might fire 
and send a reset. We don't implement this, so we just fail. The VM's 
device goes offline and the app in the VM gets IO errors.

4. Patch 11 removes extra flush calls.


Patches 12 - 17 are adding support for the thread per VQ which is a perf 
feature so resend them separately when we figure what is best.
