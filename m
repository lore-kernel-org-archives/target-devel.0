From: Mike Christie <mchristi@redhat.com>
Date: Tue, 28 Apr 2020 16:33:51 +0000
Subject: Re: [PATCH 07/11] target: add sysfs support
Message-Id: <e066ccc2-c13a-3c82-22d9-0d366d8efa34@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200428061109.3042-1-mchristi@redhat.com>
 <20200428061109.3042-8-mchristi@redhat.com>
 <a79c2243-f4ee-4138-abd5-d9df70761bf0@acm.org>
In-Reply-To: <a79c2243-f4ee-4138-abd5-d9df70761bf0@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bart Van Assche <bvanassche@acm.org>, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 4/28/20 11:29 AM, Bart Van Assche wrote:
> On 2020-04-27 23:11, Mike Christie wrote:
>> @@ -3536,6 +3551,15 @@ static int __init target_core_init_configfs(void)
>>  
>>  	target_init_dbroot();
>>  
>> +	tcm_core_kobj = kobject_create_and_add("scsi_target", NULL);
>> +	if (!tcm_core_kobj)
>> +		goto out;
> 
> Is an ack from Greg KH required when adding a new directory under
> /sys/kernel?

I'm not sure. When I resend with your other comments handled, I will cc him.
