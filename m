From: Mike Christie <mchristi@redhat.com>
Date: Fri, 02 Aug 2019 16:27:01 +0000
Subject: Re: tcmu: Reporting of errors detected by handler_read() before it returns
Message-Id: <5D446455.4080100@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <9f2e4a82-a16f-80bb-2c5d-847ec2d24c5f@gmail.com>
In-Reply-To: <9f2e4a82-a16f-80bb-2c5d-847ec2d24c5f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 08/02/2019 11:20 AM, David Butterfield wrote:
> On 8/1/19 10:18 AM, Mike Christie wrote:
>> Update your tcmu-runner git repo :)
>>
>> A little bit ago, the comments in tcmu-runner.h were updated to make it
>> clear what type of handler can do what, and also support for not having
>> to call cmd->done in handlers like file_example was added.
> 
> I've pulled the latest master and the comment has been revised, but part
> of my question still remains:
> 
> If the handler successfully completes execution of the block I/O command
> in the callout function, what TCMU_STS code should it return from the
> callout function?
> 
> It can't be TCMU_STS_OK, right?  Because that would leave tcmu-runner
> expecting a call to cmd->done() later.
> 
> And it can't be a TCMU_STS error, because the I/O was successful.
> 
> So what does the handler return to indicate both success and completion?

What is says on line 128.

You must return a TCMU_STS code. It can TMCU_STS_OK or a TCMU_STS error
value like TCMU_STS_WR_ERR.

For handlers like file_example that operate like described on line 128,
tcmu-runner core will do cmd->done for it.


> 
> 125         /*
> 126          * Below callouts are only executed by generic_handle_cmd.
> 127          *
> 128          * Handlers that completely execute cmds from the callout's calling
> 129          * context must return a TCMU_STS code from the callout.
> 130          *
> 131          * Async handlers that queue a command from the callout and complete
> 132          * it from their own async context return:
> 133          * - TCMU_STS_OK if the handler has queued the command.
> 134          * - TCMU_STS_NO_RESOURCE if the handler was not able to allocate
> 135          *   resources to queue the command.
> 136          *
> 137          * If TCMU_STS_OK is returned from the callout the handler must call
> 138          * tcmur_cmd_complete with a TCMU_STS return code to complete the
> 139          * command.
> 140          */
> 141         int (*read)(struct tcmu_device *dev, struct tcmur_cmd *cmd,
> 142                     struct iovec *iovec, size_t iov_cnt, size_t len, off_t off);
> 143         int (*write)(struct tcmu_device *dev, struct tcmur_cmd *cmd,
> 144                      struct iovec *iovec, size_t iov_cnt, size_t len, off_t off);
> 145         int (*flush)(struct tcmu_device *dev, struct tcmur_cmd *cmd);
> 
> 
>>> However, the code in file_example.c does not do either of those things, and directly
>>> violates the comment in tcmu-runner.h -- this excerpt is from file_read():

file_example operates like described in line 128.

>>>
>>> 	while (remaining) {
>>> 		ret = preadv(state->fd, iov, iov_cnt, offset);
>>> 		if (ret < 0) {
>>> 			tcmu_err("read failed: %m\n");
>>> 			ret = TCMU_STS_RD_ERR;
>>> 			goto done;
>>> 		}
>>> 		...
>>> 	}
>>> 	ret = TCMU_STS_OK;
>>> done:
>>> 	return ret;
>>>
>>> The file_read() function operates synchronously, and never issues a call to cmd->done()
>>> for successful reads returning TCMU_STS_OK, contradicting the comment in tcmu-runner.h.
> 
