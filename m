From: Mike Christie <mchristi@redhat.com>
Date: Mon, 01 Oct 2018 16:08:23 +0000
Subject: Re: [PATCH 00/17] Make ABORT and LUN RESET handling synchronous
Message-Id: <5BB24677.2030905@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180917213554.987-1-bvanassche@acm.org>
In-Reply-To: <20180917213554.987-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 10/01/2018 12:03 AM, Bart Van Assche wrote:
> On 9/17/18 2:35 PM, Bart Van Assche wrote:
>> As you maybe know the LIO task management handling code is complicated
>> because it is asynchronous compared to the command execution flow. This
>> patch series makes task management function handling synchronous and
>> thereby significantly simplifies the LIO code. Please consider these
>> patches for kernel v4.20.
> 
> Does anyone want to comment on this patch series?
> 

Sorry for the delay Bart. I am at patch 9. I will try to finish the set
by the beginning of next week.
