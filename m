From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 01 Oct 2018 05:03:01 +0000
Subject: Re: [PATCH 00/17] Make ABORT and LUN RESET handling synchronous
Message-Id: <b671f11c-bd7d-a196-fa60-f10934650755@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20180917213554.987-1-bvanassche@acm.org>
In-Reply-To: <20180917213554.987-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 9/17/18 2:35 PM, Bart Van Assche wrote:
> As you maybe know the LIO task management handling code is complicated
> because it is asynchronous compared to the command execution flow. This
> patch series makes task management function handling synchronous and
> thereby significantly simplifies the LIO code. Please consider these
> patches for kernel v4.20.

Does anyone want to comment on this patch series?

Thanks,

Bart.
