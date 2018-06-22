From: Bart Van Assche <bart.vanassche@wdc.com>
Date: Fri, 22 Jun 2018 15:38:53 +0000
Subject: Re: [PATCH 14/14] target: Fix handling of removed LUNs
Message-Id: <7b9303c6-f2bf-bfd3-da60-bb2c37f23dfe@wdc.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180301222632.31507-15-bart.vanassche@wdc.com>
In-Reply-To: <20180301222632.31507-15-bart.vanassche@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 06/21/18 20:45, Mike Christie wrote:
> On 06/21/2018 03:58 PM, Bart Van Assche wrote:
>> On Thu, 2018-06-21 at 15:32 -0500, Mike Christie wrote:
>>> I am not seeing that. I saw SCF_EMULATED_TASK_SENSE was moved but not
>>> SCF_SENT_CHECK_CONDITION. The latter is set a little earlier in
>>> transport_send_check_condition_and_sense.
>>
>> Are you sure we need to change the code that sets SCF_SENT_CHECK_CONDITION?
>> It seems to me like the name of that flag is misleading. I think that flag
>> is used to keep track of whether or not a response has been sent to the
>> initiator. So keeping the current code for the manipulation of that flag
>> should be fine.
> 
> I think with your patch the behavior will be the same as before, so it
> is safe.
> 
> I was more asking if in another future patch we need to set that bit for
> the case where TCM_LUN_BUSY/TCM_OUT_OF_RESOURCES is passed to
> transport_generic_request_failure so the behavior for that code path is
> the same as when you now set cmd->scsi_status = TCM_LUN_BUSY in your patch.

Hello Mike,

As you know today the code that processes the abort task management 
function is executed concurrently with the regular command processing 
code. I think if we would process task aborts from inside the regular 
command processing path that not only that code would become simpler but 
also that we wouldn't need the SCF_SENT_CHECK_CONDITION flag anymore for 
most target drivers. I'm not sure though about the iSCSI target driver. 
It's possible that we still would need that flag for the iSCSI target 
driver. How about me resurrecting the patch that moves abort processing
into the same context as the regular SCSI command execution?

Bart.
