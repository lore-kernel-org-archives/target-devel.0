From: "Alexander A. Klimov" <grandmaster@al2klimov.de>
Date: Fri, 10 Jul 2020 18:12:26 +0000
Subject: Re: [PATCH] SCSI RDMA PROTOCOL (SRP) TARGET: Replace HTTP links with HTTPS ones
Message-Id: <8fca4633-41ad-7e86-2354-36381bf5c734@al2klimov.de>
List-Id: <target-devel.vger.kernel.org>
References: <20200709194820.27032-1-grandmaster@al2klimov.de>
 <3d230abd-752e-8ac1-e18d-b64561b409ff@acm.org>
In-Reply-To: <3d230abd-752e-8ac1-e18d-b64561b409ff@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bart Van Assche <bvanassche@acm.org>, dledford@redhat.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org



Am 10.07.20 um 16:22 schrieb Bart Van Assche:
> On 2020-07-09 12:48, Alexander A. Klimov wrote:
>> diff --git a/drivers/infiniband/ulp/srpt/Kconfig b/drivers/infiniband/ulp/srpt/Kconfig
>> index 4b5d9b792cfa..f63b34d9ae32 100644
>> --- a/drivers/infiniband/ulp/srpt/Kconfig
>> +++ b/drivers/infiniband/ulp/srpt/Kconfig
>> @@ -10,4 +10,4 @@ config INFINIBAND_SRPT
>>   	  that supports the RDMA protocol. Currently the RDMA protocol is
>>   	  supported by InfiniBand and by iWarp network hardware. More
>>   	  information about the SRP protocol can be found on the website
>> -	  of the INCITS T10 technical committee (http://www.t10.org/).
>> +	  of the INCITS T10 technical committee (https://www.t10.org/).
> 
> It is not clear to me how modifying an URL in a Kconfig file helps to
> reduce the attack surface on kernel devs?
Not on all, just on the ones who open it.

> 
> Thanks,
> 
> Bart.
> 
> 
