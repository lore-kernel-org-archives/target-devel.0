From: Bart Van Assche <bvanassche@acm.org>
Date: Sat, 02 Feb 2019 00:53:01 +0000
Subject: Re: [PATCH 06/16] RDMA/srpt: Fix handling of command / TMF submission failure
Message-Id: <1549068781.164323.20.camel@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20190125183458.220477-7-bvanassche@acm.org>
In-Reply-To: <20190125183458.220477-7-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Fri, 2019-02-01 at 18:15 -0600, Mike Christie wrote:
+AD4 On 01/25/2019 12:34 PM, Bart Van Assche wrote:
+AD4 +AD4 If submitting an SRP IU to the target core fails, send the SCSI
+AD4 +AD4 response +ACI-BUSY+ACI to the initiator instead of not sending any
+AD4 +AD4 response.
+AD4 +AD4 
+AD4 +AD4 Reviewed-by: Hannes Reinecke +ADw-hare+AEA-suse.com+AD4
+AD4 +AD4 Cc: Doug Ledford +ADw-dledford+AEA-redhat.com+AD4
+AD4 +AD4 Cc: Jason Gunthorpe +ADw-jgg+AEA-ziepe.ca+AD4
+AD4 +AD4 Cc: Nicholas Bellinger +ADw-nab+AEA-linux-iscsi.org+AD4
+AD4 +AD4 Cc: Mike Christie +ADw-mchristi+AEA-redhat.com+AD4
+AD4 +AD4 Cc: Christoph Hellwig +ADw-hch+AEA-lst.de+AD4
+AD4 +AD4 Signed-off-by: Bart Van Assche +ADw-bvanassche+AEA-acm.org+AD4
+AD4 +AD4 ---
+AD4 +AD4  drivers/infiniband/ulp/srpt/ib+AF8-srpt.c +AHw 9 +-+-+-+------
+AD4 +AD4  1 file changed, 4 insertions(+-), 5 deletions(-)
+AD4 +AD4 
+AD4 +AD4 diff --git a/drivers/infiniband/ulp/srpt/ib+AF8-srpt.c b/drivers/infiniband/ulp/srpt/ib+AF8-srpt.c
+AD4 +AD4 index 8cee8c6c6be9..4fc901d1c0c1 100644
+AD4 +AD4 --- a/drivers/infiniband/ulp/srpt/ib+AF8-srpt.c
+AD4 +AD4 +-+-+- b/drivers/infiniband/ulp/srpt/ib+AF8-srpt.c
+AD4 +AD4 +AEAAQA -1505,7 +-1505,7 +AEAAQA static void srpt+AF8-handle+AF8-cmd(struct srpt+AF8-rdma+AF8-ch +ACo-ch,
+AD4 +AD4  			pr+AF8-err(+ACI-0x+ACU-llx: parsing SRP descriptor table failed.+AFw-n+ACI,
+AD4 +AD4  			       srp+AF8-cmd-+AD4-tag)+ADs
+AD4 +AD4  		+AH0
+AD4 +AD4 -		goto release+AF8-ioctx+ADs
+AD4 +AD4 +-		goto busy+ADs
+AD4 +AD4  	+AH0
+AD4 +AD4  
+AD4 +AD4  	rc +AD0 target+AF8-submit+AF8-cmd+AF8-map+AF8-sgls(cmd, ch-+AD4-sess, srp+AF8-cmd-+AD4-cdb,
+AD4 +AD4 +AEAAQA -1516,13 +-1516,12 +AEAAQA static void srpt+AF8-handle+AF8-cmd(struct srpt+AF8-rdma+AF8-ch +ACo-ch,
+AD4 +AD4  	if (rc +ACEAPQ 0) +AHs
+AD4 +AD4  		pr+AF8-debug(+ACI-target+AF8-submit+AF8-cmd() returned +ACU-d for tag +ACUAIw-llx+AFw-n+ACI, rc,
+AD4 +AD4  			 srp+AF8-cmd-+AD4-tag)+ADs
+AD4 +AD4 -		goto release+AF8-ioctx+ADs
+AD4 +AD4 +-		goto busy+ADs
+AD4 +AD4  	+AH0
+AD4 +AD4  	return+ADs
+AD4 +AD4  
+AD4 +AD4 -release+AF8-ioctx:
+AD4 +AD4 -	send+AF8-ioctx-+AD4-state +AD0 SRPT+AF8-STATE+AF8-DONE+ADs
+AD4 +AD4 -	srpt+AF8-release+AF8-cmd(cmd)+ADs
+AD4 +AD4 +-busy:
+AD4 +AD4 +-	target+AF8-send+AF8-busy(cmd)+ADs
+AD4 +AD4  +AH0
+AD4 +AD4  
+AD4 +AD4  static int srp+AF8-tmr+AF8-to+AF8-tcm(int fn)
+AD4 +AD4 
+AD4 
+AD4 Can you not do transport+AF8-generic+AF8-request+AF8-failure(cmd, TCM+AF8-LUN+AF8-BUSY),
+AD4 because some of the cmd's bits are not yet set?

Hi Mike,

That's correct. I think it is only safe to call transport+AF8-generic+AF8-request+AF8-failure()
after a command has been submitted to the target core. target+AF8-send+AF8-busy() is called
if submitting a command to the target core failed. Hence the following comment above
target+AF8-send+AF8-busy():

+ACI-Note: Only call this function if target+AF8-submit+AF8-cmd+ACo() failed.+ACI

Bart.
