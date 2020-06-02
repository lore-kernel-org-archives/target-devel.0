From: Mike Christie <michael.christie@oracle.com>
Date: Tue, 02 Jun 2020 23:28:54 +0000
Subject: Re: [PATCH v3 2/3] target: fix NULL pointer dereference
Message-Id: <86ebdc00-afd7-dfc6-3fe7-7e1128b70ee4@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1591122825-2652-1-git-send-email-sudhakar.panneerselvam@oracle.com>
 <1591122825-2652-3-git-send-email-sudhakar.panneerselvam@oracle.com>
 <58f5ec86-2791-a3c6-2c0d-94b717030c42@oracle.com>
 <3df40de4-ab01-4b9c-b727-f7fafbb82b29@default>
 <b88dd350-16d6-4551-9602-03368e639642@default>
In-Reply-To: <b88dd350-16d6-4551-9602-03368e639642@default>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>, Martin Petersen <martin.petersen@oracle.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Shirley Ma <shirley.ma@oracle.com>



On 6/2/20 6:01 PM, Sudhakar Panneerselvam wrote:
>>> Maybe move this to after target_get_sess_cmd().
>>
>> I moved it before target_get_sess_cmd() because if target_get_sess_cmd() fails
>> then we have NULL pointer dereference issue again. For instance, the sequence
>>    vhost_scsi_submission_work
>>       target_submit_cmd_map_sgls
>>         target_get_sess_cmd() -- Suppose this fails
>>       transport_send_check_condition_and_sense
>>          trace_target_cmd_complete -- NULL ptr derefence.
>>
>> Still thinking how to address both these issues together.
> 
> Also, noticed that not all callers of target_get_sess_cmd() check for return value.( iscsit_setup_scsi_cmd() and iscsit_handle_task_mgt_cmd()). Could this cause problems?
> 

I think it's ok. iscsi doesn't use target_sess_cmd_list_set_waiting so 
the only way it fails there is if there is a driver bug.
