From: Mike Christie <mchristi@redhat.com>
Date: Wed, 15 Apr 2020 17:28:02 +0000
Subject: Re: [RFC PATCH 1/5] target: add sysfs support
Message-Id: <5E974422.2060107@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200414051514.7296-1-mchristi@redhat.com>
 <20200414051514.7296-2-mchristi@redhat.com>
 <b6b87cff-c359-b7f6-ffd0-ff5b49dccbb8@acm.org>
In-Reply-To: <b6b87cff-c359-b7f6-ffd0-ff5b49dccbb8@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bart Van Assche <bvanassche@acm.org>, jsmart2021@gmail.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, nab@linux-iscsi.org

On 04/14/2020 09:23 PM, Bart Van Assche wrote:
> On 2020-04-13 22:15, Mike Christie wrote:
>> target_core/
>> `-- $fabric_driver
>>     `-- target_name
>>         |-- tpgt_1
>>         |   `-- sessions
>>         `-- tpgt_2
>>             `-- sessions
>>
>> iscsi example:
>> target_core/
>> `-- iscsi
>>     `-- iqn.1999-09.com.lio:tgt1
>>         |-- tpgt_1
>>         |   `-- sessions
>>         `-- tpgt_2
>>             `-- sessions
> 
> After the SCSI target core was added to the kernel tree an NVMe target
> core was added. How about using the name "scsi_target" for the top-level
> directory instead of "target_core" to prevent confusion with the NVMe
> target?
> 

Will do.
