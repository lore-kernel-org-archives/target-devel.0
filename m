From: Bart Van Assche <bvanassche@acm.org>
Date: Thu, 19 Mar 2020 04:29:33 +0000
Subject: Re: [PATCH] scsi: target: core: add task tag to trace events
Message-Id: <42e02192-4c5a-e19e-a02d-ede3974c18ed@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <226e01deaa9baf46d6ff3b8698bc9fe881f7dfc1.camel@dubeyko.com>
In-Reply-To: <226e01deaa9baf46d6ff3b8698bc9fe881f7dfc1.camel@dubeyko.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Viacheslav Dubeyko <slava@dubeyko.com>, target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, linux@yadro.com, v.dubeiko@yadro.com, rostedt@goodmis.org, mingo@redhat.com, r.bolshakov@yadro.com, k.shelekhin@yadro.com

On 2020-03-16 06:07, Viacheslav Dubeyko wrote:
> Trace events target_sequencer_start and target_cmd_complete
> (include/trace/events/target.h) are ready to show NAA identifier,
> LUN ID, and many other important command details in the system log:

Reviewed-by: Bart van Assche <bvanassche@acm.org>
