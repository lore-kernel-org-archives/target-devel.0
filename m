From: Mike Christie <mchristi@redhat.com>
Date: Wed, 08 Nov 2017 22:42:28 +0000
Subject: Re: [PATCHv2] tcmu: Add fifo type waiter list support to avoid starvation
Message-Id: <5A038854.3010406@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <1499843767-17420-1-git-send-email-lixiubo@cmss.chinamobile.com>
 <1501452645.1499.21.camel@haakon3.daterainc.com>
 <65f2456a-057c-9e68-be34-b89fd560b5ca@linux.vnet.ibm.com>
In-Reply-To: <65f2456a-057c-9e68-be34-b89fd560b5ca@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, lixiubo@cmss.chinamobile.com
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 11/08/2017 04:35 PM, Bryant G. Ly wrote:
> 
> On 7/30/17 5:10 PM, Nicholas A. Bellinger wrote:
> 
>> Hi Xiubo,
>>
>> Apologies for the delayed response.  Comments below.
>>
>> On Wed, 2017-07-12 at 15:16 +0800, lixiubo@cmss.chinamobile.com wrote:
>>> From: Xiubo Li <lixiubo@cmss.chinamobile.com>
>>>
>>> The fifo type waiter list will hold the udevs who are waiting for the
>>> blocks from the data global pool. The unmap thread will try to feed the
>>> first udevs in waiter list, if the global free blocks available are
>>> not enough, it will stop traversing the list and abort waking up the
>>> others.
>>>
>>> Signed-off-by: Xiubo Li <lixiubo@cmss.chinamobile.com>
>>> ---
>>>  drivers/target/target_core_user.c | 104 ++++++++++++++++++++++++++++++++------
>>>  1 file changed, 88 insertions(+), 16 deletions(-)
>>>
>> Applied to target-pending/for-next.
>>
>> Thanks Xiubo + MNC.
>>
> Hi Nick, 
> 
> Do you know what ever happened to this patch? You mentioned that you had applied the patch but I don't see it anywhere in your tree.
> 

I asked that it be reverted from for-next instead of sending to Linus,
because it added several regressions. Instead of adding this patch and
adding fixes on top like in this patchset
https://www.spinics.net/lists/target-devel/msg16121.html, I did this
patchset:

https://www.spinics.net/lists/target-devel/msg16162.html

the other day which adds similar support. The first 4 patches and last
one are merged in his for-next branch.

