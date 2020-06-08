From: Mike Christie <michael.christie@oracle.com>
Date: Mon, 08 Jun 2020 14:49:48 +0000
Subject: Re: [PATCH 11/17] target: add session sysfs class support
Message-Id: <dcfb5e78-79b1-9e69-0097-a07db488397e@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
 <1591562164-9766-12-git-send-email-michael.christie@oracle.com>
 <780d2db6-2a29-677d-8ee2-a731bb98fb0f@ts.fujitsu.com>
In-Reply-To: <780d2db6-2a29-677d-8ee2-a731bb98fb0f@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Bodo Stroesser <bstroesser@ts.fujitsu.com>, bvanassche@acm.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>



On 6/8/20 7:06 AM, Bodo Stroesser wrote:
>> +What:        
>> /sys/class/scsi_target_session/session-N/transport_id/session_id
>> +Date:        June 5, 2020
>> +KernelVersion:    5.9
>> +Contact: linux-scsi@vger.kernel.org
>> +Description:    If is proto=0x5 (iSCSI) and TPID FORMAT=1 this file 
>> will exist
>> +        and will return the iSCSI Initiator Session ID in ASCII
>> +        characters that are the hexadecimal digits converted from the
>> +        binary iSCSI initiator session identifier value. If iSCSI and
>> +        format=1 is not used by this session this file will not exist.
> 
> If I got it right, this is not how the code works.
> AFAICS, the file will always exist, but reading it delivers data only if
> proto=0x5 (iSCSI) and TPID FORMAT=1
> 

I forgot to update the description when I changed the code. Will update. 
Thanks.
