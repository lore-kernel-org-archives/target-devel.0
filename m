From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 02 Jul 2019 17:15:56 +0000
Subject: Re: [PATCH 0/2] Use REQ_OP_WRITE_SAME to implement WRITE SAME
Message-Id: <a2d20f62-2f2f-cf61-6ab2-38e7bf1caf72@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20190702153031.3832-1-bvanassche@acm.org>
In-Reply-To: <20190702153031.3832-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 7/2/19 9:26 AM, Christoph Hellwig wrote:
> I actually rather wanted to get rid of REQ_OP_WRITE_SAME entirely.
> Do you have a use case for this?

Hi Christoph,

I don't have a use case for this myself. I posted these patches because 
Roman Bolshakov reported a bug in the SCSI target WRITE SAME 
implementation. I think that means that he uses this functionality.

Bart.
