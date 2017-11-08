From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Date: Wed, 08 Nov 2017 22:35:42 +0000
Subject: Re: [PATCHv2] tcmu: Add fifo type waiter list support to avoid starvation
Message-Id: <65f2456a-057c-9e68-be34-b89fd560b5ca@linux.vnet.ibm.com>
List-Id: <target-devel.vger.kernel.org>
References: <1499843767-17420-1-git-send-email-lixiubo@cmss.chinamobile.com>
 <1501452645.1499.21.camel@haakon3.daterainc.com>
In-Reply-To: <1501452645.1499.21.camel@haakon3.daterainc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, lixiubo@cmss.chinamobile.com
Cc: mchristi@redhat.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org


On 7/30/17 5:10 PM, Nicholas A. Bellinger wrote:

> Hi Xiubo,
>
> Apologies for the delayed response.  Comments below.
>
> On Wed, 2017-07-12 at 15:16 +0800, lixiubo@cmss.chinamobile.com wrote:
>> From: Xiubo Li <lixiubo@cmss.chinamobile.com>
>>
>> The fifo type waiter list will hold the udevs who are waiting for the
>> blocks from the data global pool. The unmap thread will try to feed the
>> first udevs in waiter list, if the global free blocks available are
>> not enough, it will stop traversing the list and abort waking up the
>> others.
>>
>> Signed-off-by: Xiubo Li <lixiubo@cmss.chinamobile.com>
>> ---
>>  drivers/target/target_core_user.c | 104 ++++++++++++++++++++++++++++++++------
>>  1 file changed, 88 insertions(+), 16 deletions(-)
>>
> Applied to target-pending/for-next.
>
> Thanks Xiubo + MNC.
>
Hi Nick, 

Do you know what ever happened to this patch? You mentioned that you had applied the patch but I don't see it anywhere in your tree.

Thanks, 

Bryant

