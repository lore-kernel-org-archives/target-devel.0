From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Date: Wed, 08 Nov 2017 22:41:07 +0000
Subject: Re: [PATCH] tcmu: Oops in unmap_thread_fn()
Message-Id: <d4d2840b-d453-e67a-01b2-662a29bc134c@linux.vnet.ibm.com>
List-Id: <target-devel.vger.kernel.org>
References: <20170801200917.brigs5x47eujfx7a@mwanda>
 <1502062073.22966.45.camel@haakon3.daterainc.com>
In-Reply-To: <1502062073.22966.45.camel@haakon3.daterainc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Dan Carpenter <dan.carpenter@oracle.com>
Cc: Xiubo Li <lixiubo@cmss.chinamobile.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org



On 8/6/17 6:27 PM, Nicholas A. Bellinger wrote:
> On Tue, 2017-08-01 at 23:09 +0300, Dan Carpenter wrote:
>> Calling list_del() on the iterator pointer in list_for_each_entry() will
>> cause an oops.  We need to user the _safe() version for that.
>>
>> Fixes: c73d02f63c16 ("tcmu: Add fifo type waiter list support to avoid starvation")
>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>>
> Applied to target-pending/for-next.
>
> Thanks DanC.
>
> --
> To unsubscribe from this list: send the line "unsubscribe target-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
Also missing.

-Bryant

