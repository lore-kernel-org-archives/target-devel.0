From: Mike Christie <mchristi@redhat.com>
Date: Thu, 01 Aug 2019 16:18:47 +0000
Subject: Re: Reporting of errors detected by handler_read() before it returns
Message-Id: <5D4310E7.5020701@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Sorry for the late reply. Maybe add a tcmu prefix to the subject next time.

On 07/23/2019 09:07 PM, David Butterfield wrote:
> In tcmu-runner.h some comments in struct tcmur_handler say this:
> 
> 	/*
> 	 * Below callbacks are only executed by generic_handle_cmd.
> 	 * Returns:
> 	 * - TCMU_STS_OK if the handler has queued the command.
> 	 * - TCMU_STS_NO_RESOURCE if the handler was not able to allocate
> 	 *   resources for the command.
> 	 *
> 	 * If TCMU_STS_OK is returned from the callout the handler must call
> 	 * the tcmulib_cmd->done function with TCMU_STS return code.
> 	 */
> 	rw_fn_t write;
> 	rw_fn_t read;
> 	flush_fn_t flush;
> 	unmap_fn_t unmap;
> 
> It is not clear what the handler should do if it detects a non-resource error, processing
> one of those command types, before returning from the handler's callout function.
>     
> The comment appears to say that rhandler->write() could return TCMU_STS_OK after calling
> cmd->done(..., TCMU_STS_error) (so callers should be warned that the completion can occur
> before the request call returns).
> 
> But given that the caller has to check for TCMU_STS_NO_RESOURCE anyway, perhaps it is also
> permitted to simply return other errors directly from the callout function, always omitting
> the call to cmd->done() when TCMU_STS_OK is not returned.
> 
> However, the code in file_example.c does not do either of those things, and directly
> violates the comment in tcmu-runner.h -- this excerpt is from file_read():
> 
> 	while (remaining) {
> 		ret = preadv(state->fd, iov, iov_cnt, offset);
> 		if (ret < 0) {
> 			tcmu_err("read failed: %m\n");
> 			ret = TCMU_STS_RD_ERR;
> 			goto done;
> 		}
> 		...
> 	}
> 	ret = TCMU_STS_OK;
> done:
> 	return ret;
> 
> The file_read() function operates synchronously, and never issues a call to cmd->done()
> for successful reads returning TCMU_STS_OK, contradicting the comment in tcmu-runner.h.
> 
> Assuming the function is required to call cmd->done() for a successful operation, a
> question remains which of these solutions is more correct or preferred.  (I would prefer
> the first one be allowed -- to return any TCMU_STS_error directly from the function and
> omit the call to cmd->done() whenever returning TCMU_STS_OK.)
> 

Update your tcmu-runner git repo :)

A little bit ago, the comments in tcmu-runner.h were updated to make it
clear what type of handler can do what, and also support for not having
to call cmd->done in handlers like file_example was added.
