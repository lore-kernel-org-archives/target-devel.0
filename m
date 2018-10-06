From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Date: Sat, 06 Oct 2018 05:07:52 +0000
Subject: Re: [PATCH 14/17] target/qla2xxx: Simplify the code for handling aborted commands
Message-Id: <DBEFA9D8-68ED-492F-AA69-1F5044B585A1@cavium.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180917213554.987-15-bvanassche@acm.org>
In-Reply-To: <20180917213554.987-15-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org


> On Oct 3, 2018, at 4:20 PM, Bart Van Assche <bvanassche@acm.org> wrote:
> 
> External Email
> 
> On Mon, 2018-09-17 at 14:35 -0700, Bart Van Assche wrote:
>> Since the target core waits anyway until a target driver has
>> finished processing a command, remove similar waiting code from
>> the tcm_qla2xxx driver. With this change applied command abortion
>> works as follows:
>> * tcm_qla2xxx receives an ABTS and calls target_submit_tmr().
>> * The target core calls core_tmr_abort_task(). That function
>>  sets the CMD_T_ABORTED flag and next calls transport_wait_for_tasks().
>> * If CMD_T_ACTIVE is still set, __transport_wait_for_tasks() sets
>>  CMD_T_STOP and waits for t_transport_stop_comp.
>> * When tcm_qla2xxx_handle_data_work() gets called, it either invokes
>>  transport_generic_request_failure() or target_execute_cmd().
>> * Both functions start with calling __transport_check_aborted_status()
>>  and return 1 if CMD_T_ABORTED was set. Otherwise the command that
>>  is being executed is completed and target_complete_cmd() completes
>>  t_transport_stop_comp.
>> * Once transport_wait_for_tasks() returns the target core considers
>>  the TMF as finished.
>> 
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> Cc: Himanshu Madhani <himanshu.madhani@cavium.com>
>> Cc: Quinn Tran <quinn.tran@cavium.com>
>> Cc: Nicholas Bellinger <nab@linux-iscsi.org>
>> Cc: Mike Christie <mchristi@redhat.com>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: Hannes Reinecke <hare@suse.de>
> 
> Hello Himanshu and Quinn,
> 
> Can one of you review this patch?
> 
> Thanks,
> 
> Bart.
> 

Apologies for delay. Still reviewing the patch

Thanks,
- Himanshu
