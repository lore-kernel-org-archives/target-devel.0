From: Bart Van Assche <bvanassche@acm.org>
Date: Wed, 03 Oct 2018 23:20:44 +0000
Subject: Re: [PATCH 14/17] target/qla2xxx: Simplify the code for handling aborted commands
Message-Id: <1538608844.205649.37.camel@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20180917213554.987-15-bvanassche@acm.org>
In-Reply-To: <20180917213554.987-15-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Mon, 2018-09-17 at 14:35 -0700, Bart Van Assche wrote:
+AD4 Since the target core waits anyway until a target driver has
+AD4 finished processing a command, remove similar waiting code from
+AD4 the tcm+AF8-qla2xxx driver. With this change applied command abortion
+AD4 works as follows:
+AD4 +ACo tcm+AF8-qla2xxx receives an ABTS and calls target+AF8-submit+AF8-tmr().
+AD4 +ACo The target core calls core+AF8-tmr+AF8-abort+AF8-task(). That function
+AD4   sets the CMD+AF8-T+AF8-ABORTED flag and next calls transport+AF8-wait+AF8-for+AF8-tasks().
+AD4 +ACo If CMD+AF8-T+AF8-ACTIVE is still set, +AF8AXw-transport+AF8-wait+AF8-for+AF8-tasks() sets
+AD4   CMD+AF8-T+AF8-STOP and waits for t+AF8-transport+AF8-stop+AF8-comp.
+AD4 +ACo When tcm+AF8-qla2xxx+AF8-handle+AF8-data+AF8-work() gets called, it either invokes
+AD4   transport+AF8-generic+AF8-request+AF8-failure() or target+AF8-execute+AF8-cmd().
+AD4 +ACo Both functions start with calling +AF8AXw-transport+AF8-check+AF8-aborted+AF8-status()
+AD4   and return 1 if CMD+AF8-T+AF8-ABORTED was set. Otherwise the command that
+AD4   is being executed is completed and target+AF8-complete+AF8-cmd() completes
+AD4   t+AF8-transport+AF8-stop+AF8-comp.
+AD4 +ACo Once transport+AF8-wait+AF8-for+AF8-tasks() returns the target core considers
+AD4   the TMF as finished.
+AD4 
+AD4 Signed-off-by: Bart Van Assche +ADw-bvanassche+AEA-acm.org+AD4
+AD4 Cc: Himanshu Madhani +ADw-himanshu.madhani+AEA-cavium.com+AD4
+AD4 Cc: Quinn Tran +ADw-quinn.tran+AEA-cavium.com+AD4
+AD4 Cc: Nicholas Bellinger +ADw-nab+AEA-linux-iscsi.org+AD4
+AD4 Cc: Mike Christie +ADw-mchristi+AEA-redhat.com+AD4
+AD4 Cc: Christoph Hellwig +ADw-hch+AEA-lst.de+AD4
+AD4 Cc: Hannes Reinecke +ADw-hare+AEA-suse.de+AD4

Hello Himanshu and Quinn,

Can one of you review this patch?

Thanks,

Bart.
