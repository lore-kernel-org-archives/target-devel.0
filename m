From: Mike Christie <mchristi@redhat.com>
Date: Fri, 22 Jun 2018 03:45:18 +0000
Subject: Re: [PATCH 14/14] target: Fix handling of removed LUNs
Message-Id: <5B2C70CE.7020202@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180301222632.31507-15-bart.vanassche@wdc.com>
In-Reply-To: <20180301222632.31507-15-bart.vanassche@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 06/21/2018 03:58 PM, Bart Van Assche wrote:
> On Thu, 2018-06-21 at 15:32 -0500, Mike Christie wrote:
>> I am not seeing that. I saw SCF_EMULATED_TASK_SENSE was moved but not
>> SCF_SENT_CHECK_CONDITION. The latter is set a little earlier in
>> transport_send_check_condition_and_sense.
> 
> Are you sure we need to change the code that sets SCF_SENT_CHECK_CONDITION?
> It seems to me like the name of that flag is misleading. I think that flag
> is used to keep track of whether or not a response has been sent to the
> initiator. So keeping the current code for the manipulation of that flag
> should be fine.
> 

I think with your patch the behavior will be the same as before, so it
is safe.

I was more asking if in another future patch we need to set that bit for
the case where TCM_LUN_BUSY/TCM_OUT_OF_RESOURCES is passed to
transport_generic_request_failure so the behavior for that code path is
the same as when you now set cmd->scsi_status = TCM_LUN_BUSY in your patch.



