From: Mike Christie <mchristi@redhat.com>
Date: Wed, 15 Apr 2020 17:38:04 +0000
Subject: Re: [RFC PATCH 3/5] target: add target_setup_session sysfs support
Message-Id: <5E97467C.1070108@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200414051514.7296-1-mchristi@redhat.com>
 <20200414051514.7296-4-mchristi@redhat.com>
 <0267ebe3-8168-ef02-b414-6d14a756277b@acm.org>
In-Reply-To: <0267ebe3-8168-ef02-b414-6d14a756277b@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bart Van Assche <bvanassche@acm.org>, jsmart2021@gmail.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, nab@linux-iscsi.org

On 04/14/2020 09:37 PM, Bart Van Assche wrote:
> On 2020-04-13 22:15, Mike Christie wrote:
>>  struct se_session *target_setup_session(struct se_portal_group *,
>>  		unsigned int, unsigned int, enum target_prot_op prot_op,
>> -		const char *, void *,
>> -		int (*callback)(struct se_portal_group *,
>> -				struct se_session *, void *));
>> +		const char *, struct attribute_group *, void *,
>> +		int (*setup_cb)(struct se_portal_group *,
>> +				struct se_session *, void *),
>> +		void (*free_cb)(struct se_session *));
> 
> The argument list of target_setup_session() is getting really long. How
> about moving the attribute_group, setup_cb and free_cb arguments into
> struct target_core_fabric_ops? Would that make it easier to extend

I agree.

> session sysfs attribute support in the future?
> 

Yeah, I can move those callbacks and the attribute_group to the
target_core_fabric_ops and it then it will work more similarly to the
other callout/attr handling.
