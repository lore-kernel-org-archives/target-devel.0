From: Bart Van Assche <bvanassche@acm.org>
Date: Sun, 25 Oct 2020 00:25:17 +0000
Subject: Re: [PATCH 3/3] scsi: target: core: Change ASCQ for residual write
Message-Id: <b831a7db-1da2-c293-a8f6-d9c62f68c224@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20201022172011.42367-1-a.kovaleva@yadro.com>
 <20201022172011.42367-4-a.kovaleva@yadro.com>
 <e2b215ca-0aa8-bdae-e5bd-292a09d8282e@acm.org>
 <20201024121315.GA35317@SPB-NB-133.local>
In-Reply-To: <20201024121315.GA35317@SPB-NB-133.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Bolshakov <r.bolshakov@yadro.com>
Cc: Anastasia Kovaleva <a.kovaleva@yadro.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, linux@yadro.com

On 10/24/20 5:13 AM, Roman Bolshakov wrote:
> iSCSI doesn't specify a specific code but mentions a possibility of CHECK
> CONDITION for residuals (11.4.5.1.  Field Semantics):
> 
>   Targets may set the residual count, and initiators may use it when the
>   response code is Command Completed at Target (even if the status
>   returned is not GOOD).

My interpretation of the above text is that it neither allows nor
requires to change the status GOOD into something else if there is a
residue.

>> Additionally, what benefits does it provide to report a CHECK CONDITION
>> upon residual overflow?
> 
> Typical use case for CHECK CONDITION in case of Underflow/Overflow is
> extra robustness against buggy initiators [1][2]. Failing both READ and
> WRITE is the most solid approach in that sense [3][4][5] as it prevents
> data corruption at all costs.
> 
> Suppose an initiator wants to WRITE 8 LBA. For 512-byte formatted LUN,
> 8 LBAs need a buffer of 4K bytes. For 4096-byte formatted LUN the
> command would need 32K data buffer.
> 
> An Overflow happens if initiator treats 4Kn device like 512n one but
> provides a buffer of 4K. i.e. to complete the WRITE target needs to
> consume 28K more data, otherwise only 1 LBA would be written and the
> rest 7 LBAs would have indeterminate content.
> 
> An Underflow happens if initiator confuses 512n device with 4Kn one and
> provides a buffer of 32K, i.e. target doesn't utilize all buffer for the
> command.

Thanks for the additional background information, this really helps. How
about only rejecting SCSI commands for which the data buffer size is not
a multiple of the block size? I'm concerned that flagging all SCSI
commands that have a residue as invalid will break SCSI tape software.

Thanks,

Bart.
