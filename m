From: Michael Christie <mchristi@redhat.com>
Date: Thu, 08 Aug 2019 18:02:16 +0000
Subject: Re: tcmu: Reporting of errors detected by handler_read() before it returns
Message-Id: <f3bfd765-34b8-cddd-be2d-19fdb6a29293@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <9f2e4a82-a16f-80bb-2c5d-847ec2d24c5f@gmail.com>
In-Reply-To: <9f2e4a82-a16f-80bb-2c5d-847ec2d24c5f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 08/08/2019 12:50 AM, David Butterfield wrote:
> Thanks for your help.  I'm afraid I'm still confused somehow about this.
> 
>>> If the handler successfully completes execution of the block I/O command
>>> in the callout function, what TCMU_STS code should it return from the
>>> callout function
>>
>> What is says on line 128.
>>
>> You must return a TCMU_STS code. It can TMCU_STS_OK or a TCMU_STS error
>> value like TCMU_STS_WR_ERR.
> 
> So, then, line 137 is intended to apply only to line 131 and not line 128?

Correct.

> I was reading it as applying to both.
> 
>> For handlers like file_example that operate like described on line 128,
>> tcmu-runner core will do cmd->done for it.
> 
> If TCMU_STS_OK is returned from file_read(), how does runner know whether that is
> 
>     (1) TCMU_STS_OK because the handler is async and it queued the command, and
> 	there will be a future call to tcmur_cmd_complete() from the handl>
>     (2) TCMU_STS_OK because the handler executed the entire command successfully
> 	and runner needs to issue the cmd->done for it now?

If you set nr_threads > 0 and implement the callouts below then
TCMU_STS_OK means you completed the command in the callout successfully.

If you set nr_threads = 0 and implement the callouts below then OK means
it got queued successfully and the handler is going to complete it by
calling tcmur_cmd_complete.

We do not have any handlers where nr_threads = 0, the callouts below are
implemented and the handler executes the command in the callout, so it's
not supported right now.


> 
> Also, I wonder why the return from async handlers for successful queueing
> of the command is TCMU_STS_OK rather than TCMU_STS_ASYNC_HANDLED.

It's just one of those things that needs to be cleaned up.

tcmu-runner uses it internally and when interacting with libtcmu, and
runner handlers that only implement a handle_cmd can use it directly.

> 
>>> 125         /*
>>> 126          * Below callouts are only executed by generic_handle_cmd.
>>> 127          *
>>> 128          * Handlers that completely execute cmds from the callout's calling
>>> 129          * context must return a TCMU_STS code from the callout.
>>> 130          *
>>> 131          * Async handlers that queue a command from the callout and complete
>>> 132          * it from their own async context return:
>>> 133          * - TCMU_STS_OK if the handler has queued the command.
>>> 134          * - TCMU_STS_NO_RESOURCE if the handler was not able to allocate
>>> 135          *   resources to queue the command.
>>> 136          *
>>> 137          * If TCMU_STS_OK is returned from the callout the handler must call
>>> 138          * tcmur_cmd_complete with a TCMU_STS return code to complete the
>>> 139          * command.
>>> 140          */
>>> 141         int (*read)(struct tcmu_device *dev, struct tcmur_cmd *cmd,
>>> 142                     struct iovec *iovec, size_t iov_cnt, size_t len, off_t off);
>>> 143         int (*write)(struct tcmu_device *dev, struct tcmur_cmd *cmd,
>>> 144                      struct iovec *iovec, size_t iov_cnt, size_t len, off_t off);
>>> 145         int (*flush)(struct tcmu_device *dev, struct tcmur_cmd *cmd);
> 
